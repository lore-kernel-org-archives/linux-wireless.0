Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1667 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765997Ab3DEI6K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 04:58:10 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 02/16] brcmfmac: handle firmware signalling destination
 entry state
Date: Fri, 5 Apr 2013 10:57:40 +0200
Message-ID: <1365152274-4252-3-git-send-email-arend@broadcom.com> (sfid-20130405_111305_768849_4E593432)
In-Reply-To: <1365152274-4252-1-git-send-email-arend@broadcom.com>
References: <1365152274-4252-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware can signal whether the host driver may sent packets for
a specific destination or interface. This can happen when a
destination is sleeping or when going off-channel.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c  |    4 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h  |    2 +
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   80 ++++++++++++++++++--
 3 files changed, 79 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
index bd16f0b..202869c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
@@ -143,6 +143,8 @@ ssize_t brcmf_debugfs_fws_stats_read(struct file *f, char __user *data,
 			"tlv_parse_failed:  %u\n"
 			"tlv_invalid_type:  %u\n"
 			"mac_update_fails:  %u\n"
+			"ps_update_fails:   %u\n"
+			"if_update_fails:   %u\n"
 			"pkt2bus:           %u\n"
 			"generic_error:     %u\n"
 			"rollback_success:  %u\n"
@@ -161,6 +163,8 @@ ssize_t brcmf_debugfs_fws_stats_read(struct file *f, char __user *data,
 			fwstats->tlv_parse_failed,
 			fwstats->tlv_invalid_type,
 			fwstats->mac_update_failed,
+			fwstats->mac_ps_update_failed,
+			fwstats->if_update_failed,
 			fwstats->pkt2bus,
 			fwstats->generic_error,
 			fwstats->rollback_success,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
index a6b16a1..e105889 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
@@ -144,6 +144,8 @@ struct brcmf_fws_stats {
 	u32 fifo_credits_back[6];
 	u32 generic_error;
 	u32 mac_update_failed;
+	u32 mac_ps_update_failed;
+	u32 if_update_failed;
 	u32 rollback_success;
 	u32 rollback_failed;
 	u32 delayq_full_error;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 451cfc1..57cbfb6 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -896,6 +896,69 @@ int brcmf_fws_macdesc_indicate(struct brcmf_fws_info *fws, u8 type, u8 *data)
 	return 0;
 }
 
+static int brcmf_fws_macdesc_state_indicate(struct brcmf_fws_info *fws,
+					    u8 type, u8 *data)
+{
+	struct brcmf_fws_mac_descriptor *entry;
+	u8 mac_handle;
+	int i;
+
+	mac_handle = data[0];
+	entry = &fws->desc.nodes[mac_handle & 0x1F];
+	if (!entry->occupied) {
+		fws->stats.mac_ps_update_failed++;
+		return -ESRCH;
+	}
+
+	/* a state update should wipe old credits? */
+	entry->requested_credit = 0;
+	if (type == BRCMF_FWS_TYPE_MAC_OPEN) {
+		entry->state = BRCMF_FWS_STATE_OPEN;
+	} else {
+		entry->state = BRCMF_FWS_STATE_CLOSE;
+		for (i = BRCMF_FWS_FIFO_AC_BE; i < NL80211_NUM_ACS; i++)
+			brcmf_fws_tim_update(fws, entry, i);
+	}
+	return 0;
+}
+
+static int brcmf_fws_interface_state_indicate(struct brcmf_fws_info *fws,
+					      u8 type, u8 *data)
+{
+	struct brcmf_fws_mac_descriptor *entry;
+	u8 ifidx;
+	int ret;
+
+	ifidx = data[0];
+
+	brcmf_dbg(TRACE, "enter: ifidx=%d\n", ifidx);
+	if (ifidx >= BRCMF_MAX_IFS) {
+		ret = -ERANGE;
+		goto fail;
+	}
+
+	entry = &fws->desc.iface[ifidx];
+	if (!entry->occupied) {
+		ret = -ESRCH;
+		goto fail;
+	}
+
+	switch (type) {
+	case BRCMF_FWS_TYPE_INTERFACE_OPEN:
+		entry->state = BRCMF_FWS_STATE_OPEN;
+		return 0;
+	case BRCMF_FWS_TYPE_INTERFACE_CLOSE:
+		entry->state = BRCMF_FWS_STATE_CLOSE;
+		return 0;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+fail:
+	fws->stats.if_update_failed++;
+	return ret;
+}
+
 static void brcmf_fws_return_credits(struct brcmf_fws_info *fws,
 				     u8 fifo, u8 credits)
 {
@@ -1111,8 +1174,6 @@ brcmf_fws_txstatus_process(struct brcmf_fws_info *fws, u8 flags, u32 hslot,
 	struct sk_buff *skb;
 	struct brcmf_fws_mac_descriptor *entry = NULL;
 
-	fws->stats.txs_indicate++;
-
 	brcmf_dbg(TRACE, "status: flags=0x%X, hslot=%d\n",
 		  flags, hslot);
 
@@ -1305,11 +1366,7 @@ int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
 			break;
 
 		switch (type) {
-		case BRCMF_FWS_TYPE_MAC_OPEN:
-		case BRCMF_FWS_TYPE_MAC_CLOSE:
 		case BRCMF_FWS_TYPE_MAC_REQUEST_CREDIT:
-		case BRCMF_FWS_TYPE_INTERFACE_OPEN:
-		case BRCMF_FWS_TYPE_INTERFACE_CLOSE:
 		case BRCMF_FWS_TYPE_MAC_REQUEST_PACKET:
 		case BRCMF_FWS_TYPE_HOST_REORDER_RXPKTS:
 		case BRCMF_FWS_TYPE_COMP_TXSTATUS:
@@ -1318,6 +1375,14 @@ int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
 		case BRCMF_FWS_TYPE_MACDESC_DEL:
 			brcmf_fws_macdesc_indicate(fws, type, data);
 			break;
+		case BRCMF_FWS_TYPE_MAC_OPEN:
+		case BRCMF_FWS_TYPE_MAC_CLOSE:
+			brcmf_fws_macdesc_state_indicate(fws, type, data);
+			break;
+		case BRCMF_FWS_TYPE_INTERFACE_OPEN:
+		case BRCMF_FWS_TYPE_INTERFACE_CLOSE:
+			brcmf_fws_interface_state_indicate(fws, type, data);
+			break;
 		case BRCMF_FWS_TYPE_TXSTATUS:
 			brcmf_fws_txstatus_indicate(fws, data);
 			break;
@@ -1779,7 +1844,8 @@ int brcmf_fws_init(struct brcmf_pub *drvr)
 	/* enable firmware signalling if fcmode active */
 	if (drvr->fws->fcmode != BRCMF_FWS_FCMODE_NONE)
 		tlv |= BRCMF_FWS_FLAGS_XONXOFF_SIGNALS |
-		       BRCMF_FWS_FLAGS_CREDIT_STATUS_SIGNALS;
+		       BRCMF_FWS_FLAGS_CREDIT_STATUS_SIGNALS |
+		       BRCMF_FWS_FLAGS_HOST_PROPTXSTATUS_ACTIVE;
 
 	rc = brcmf_fil_iovar_int_set(drvr->iflist[0], "tlv", tlv);
 	if (rc < 0) {
-- 
1.7.10.4


