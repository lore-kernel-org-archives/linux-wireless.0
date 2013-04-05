Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1567 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162003Ab3DEI6F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 04:58:05 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 03/16] brcmfmac: handle firmware signals requesting for
 packets
Date: Fri, 5 Apr 2013 10:57:41 +0200
Message-ID: <1365152274-4252-4-git-send-email-arend@broadcom.com> (sfid-20130405_105827_827128_2F88EB7D)
In-Reply-To: <1365152274-4252-1-git-send-email-arend@broadcom.com>
References: <1365152274-4252-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware can request the host driver for packets, by sending
either the MAC_REQUEST_CREDIT or the MAC_REQUEST_PACKET primitive.
This patch adds handling of these primitives.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h  |    2 ++
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   29 ++++++++++++++++++--
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
index e105889..d259ae5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
@@ -146,6 +146,8 @@ struct brcmf_fws_stats {
 	u32 mac_update_failed;
 	u32 mac_ps_update_failed;
 	u32 if_update_failed;
+	u32 packet_request_failed;
+	u32 credit_request_failed;
 	u32 rollback_success;
 	u32 rollback_failed;
 	u32 delayq_full_error;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 57cbfb6..619fff3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -959,6 +959,29 @@ fail:
 	return ret;
 }
 
+static int brcmf_fws_request_indicate(struct brcmf_fws_info *fws, u8 type,
+				      u8 *data)
+{
+	struct brcmf_fws_mac_descriptor *entry;
+
+	entry = &fws->desc.nodes[data[1] & 0x1F];
+	if (!entry->occupied) {
+		if (type == BRCMF_FWS_TYPE_MAC_REQUEST_CREDIT)
+			fws->stats.credit_request_failed++;
+		else
+			fws->stats.packet_request_failed++;
+		return -ESRCH;
+	}
+
+	if (type == BRCMF_FWS_TYPE_MAC_REQUEST_CREDIT)
+		entry->requested_credit = data[0];
+	else
+		entry->requested_packet = data[0];
+
+	entry->ac_bitmap = data[2];
+	return 0;
+}
+
 static void brcmf_fws_return_credits(struct brcmf_fws_info *fws,
 				     u8 fifo, u8 credits)
 {
@@ -1366,8 +1389,6 @@ int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
 			break;
 
 		switch (type) {
-		case BRCMF_FWS_TYPE_MAC_REQUEST_CREDIT:
-		case BRCMF_FWS_TYPE_MAC_REQUEST_PACKET:
 		case BRCMF_FWS_TYPE_HOST_REORDER_RXPKTS:
 		case BRCMF_FWS_TYPE_COMP_TXSTATUS:
 			break;
@@ -1383,6 +1404,10 @@ int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
 		case BRCMF_FWS_TYPE_INTERFACE_CLOSE:
 			brcmf_fws_interface_state_indicate(fws, type, data);
 			break;
+		case BRCMF_FWS_TYPE_MAC_REQUEST_CREDIT:
+		case BRCMF_FWS_TYPE_MAC_REQUEST_PACKET:
+			brcmf_fws_request_indicate(fws, type, data);
+			break;
 		case BRCMF_FWS_TYPE_TXSTATUS:
 			brcmf_fws_txstatus_indicate(fws, data);
 			break;
-- 
1.7.10.4


