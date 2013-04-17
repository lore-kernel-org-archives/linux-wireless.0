Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4871 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966744Ab3DQT0T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 15:26:19 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 06/10] brcmfmac: schedule dequeue upon firmware-signal
 reception
Date: Wed, 17 Apr 2013 21:25:54 +0200
Message-ID: <1366226758-20641-7-git-send-email-arend@broadcom.com> (sfid-20130417_214304_294399_10DDECA0)
In-Reply-To: <1366226758-20641-1-git-send-email-arend@broadcom.com>
References: <1366226758-20641-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Several firmware signals should be considered as opportunity to
send packets to the firmware. This patch adds conditional scheduling
of the dequeue worker thread while handling those signals.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   36 +++++++++++++-------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 0d2ff60..648f9bd 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -147,6 +147,9 @@ static const char *brcmf_fws_get_tlv_name(enum brcmf_fws_tlv_type id)
 #define BRCMF_FWS_HTOD_FLAG_PKTFROMHOST			0x01
 #define BRCMF_FWS_HTOD_FLAG_PKT_REQUESTED		0x02
 
+#define BRCMF_FWS_RET_OK_NOSCHEDULE	0
+#define BRCMF_FWS_RET_OK_SCHEDULE	1
+
 /**
  * enum brcmf_fws_skb_state - indicates processing state of skb.
  *
@@ -920,12 +923,13 @@ static int brcmf_fws_macdesc_state_indicate(struct brcmf_fws_info *fws,
 	entry->requested_credit = 0;
 	if (type == BRCMF_FWS_TYPE_MAC_OPEN) {
 		entry->state = BRCMF_FWS_STATE_OPEN;
+		return BRCMF_FWS_RET_OK_SCHEDULE;
 	} else {
 		entry->state = BRCMF_FWS_STATE_CLOSE;
 		for (i = BRCMF_FWS_FIFO_AC_BE; i < NL80211_NUM_ACS; i++)
 			brcmf_fws_tim_update(fws, entry, i);
 	}
-	return 0;
+	return BRCMF_FWS_RET_OK_NOSCHEDULE;
 }
 
 static int brcmf_fws_interface_state_indicate(struct brcmf_fws_info *fws,
@@ -952,10 +956,10 @@ static int brcmf_fws_interface_state_indicate(struct brcmf_fws_info *fws,
 	switch (type) {
 	case BRCMF_FWS_TYPE_INTERFACE_OPEN:
 		entry->state = BRCMF_FWS_STATE_OPEN;
-		return 0;
+		return BRCMF_FWS_RET_OK_SCHEDULE;
 	case BRCMF_FWS_TYPE_INTERFACE_CLOSE:
 		entry->state = BRCMF_FWS_STATE_CLOSE;
-		return 0;
+		return BRCMF_FWS_RET_OK_NOSCHEDULE;
 	default:
 		ret = -EINVAL;
 		break;
@@ -985,7 +989,7 @@ static int brcmf_fws_request_indicate(struct brcmf_fws_info *fws, u8 type,
 		entry->requested_packet = data[0];
 
 	entry->ac_bitmap = data[2];
-	return 0;
+	return BRCMF_FWS_RET_OK_SCHEDULE;
 }
 
 static void brcmf_fws_return_credits(struct brcmf_fws_info *fws,
@@ -1259,7 +1263,7 @@ static int brcmf_fws_fifocreditback_indicate(struct brcmf_fws_info *fws,
 
 	if (fws->fcmode != BRCMF_FWS_FCMODE_EXPLICIT_CREDIT) {
 		brcmf_dbg(INFO, "ignored\n");
-		return 0;
+		return BRCMF_FWS_RET_OK_NOSCHEDULE;
 	}
 
 	brcmf_dbg(TRACE, "enter: data %pM\n", data);
@@ -1268,8 +1272,7 @@ static int brcmf_fws_fifocreditback_indicate(struct brcmf_fws_info *fws,
 
 	brcmf_dbg(INFO, "map: credit %x delay %x\n", fws->fifo_credit_map,
 		  fws->fifo_delay_map);
-	brcmf_fws_schedule_deq(fws);
-	return 0;
+	return BRCMF_FWS_RET_OK_SCHEDULE;
 }
 
 static int brcmf_fws_txstatus_indicate(struct brcmf_fws_info *fws, u8 *data)
@@ -1353,6 +1356,8 @@ int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
 	u8 type;
 	u8 len;
 	u8 *data;
+	s32 status;
+	s32 err;
 
 	brcmf_dbg(TRACE, "enter: ifidx %d, skblen %u, sig %d\n",
 		  ifidx, skb->len, signal_len);
@@ -1372,6 +1377,7 @@ int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
 	data_len = signal_len;
 	signal_data = skb->data;
 
+	status = BRCMF_FWS_RET_OK_NOSCHEDULE;
 	while (data_len > 0) {
 		/* extract tlv info */
 		type = signal_data[0];
@@ -1397,6 +1403,7 @@ int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
 		if (len != brcmf_fws_get_tlv_len(fws, type))
 			break;
 
+		err = BRCMF_FWS_RET_OK_NOSCHEDULE;
 		switch (type) {
 		case BRCMF_FWS_TYPE_HOST_REORDER_RXPKTS:
 		case BRCMF_FWS_TYPE_COMP_TXSTATUS:
@@ -1407,21 +1414,22 @@ int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
 			break;
 		case BRCMF_FWS_TYPE_MAC_OPEN:
 		case BRCMF_FWS_TYPE_MAC_CLOSE:
-			brcmf_fws_macdesc_state_indicate(fws, type, data);
+			err = brcmf_fws_macdesc_state_indicate(fws, type, data);
 			break;
 		case BRCMF_FWS_TYPE_INTERFACE_OPEN:
 		case BRCMF_FWS_TYPE_INTERFACE_CLOSE:
-			brcmf_fws_interface_state_indicate(fws, type, data);
+			err = brcmf_fws_interface_state_indicate(fws, type,
+								 data);
 			break;
 		case BRCMF_FWS_TYPE_MAC_REQUEST_CREDIT:
 		case BRCMF_FWS_TYPE_MAC_REQUEST_PACKET:
-			brcmf_fws_request_indicate(fws, type, data);
+			err = brcmf_fws_request_indicate(fws, type, data);
 			break;
 		case BRCMF_FWS_TYPE_TXSTATUS:
 			brcmf_fws_txstatus_indicate(fws, data);
 			break;
 		case BRCMF_FWS_TYPE_FIFO_CREDITBACK:
-			brcmf_fws_fifocreditback_indicate(fws, data);
+			err = brcmf_fws_fifocreditback_indicate(fws, data);
 			break;
 		case BRCMF_FWS_TYPE_RSSI:
 			brcmf_fws_rssi_indicate(fws, *data);
@@ -1435,7 +1443,8 @@ int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
 			fws->stats.tlv_invalid_type++;
 			break;
 		}
-
+		if (err == BRCMF_FWS_RET_OK_SCHEDULE)
+			status = BRCMF_FWS_RET_OK_SCHEDULE;
 		signal_data += len + 2;
 		data_len -= len + 2;
 	}
@@ -1443,6 +1452,9 @@ int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
 	if (data_len != 0)
 		fws->stats.tlv_parse_failed++;
 
+	if (status == BRCMF_FWS_RET_OK_SCHEDULE)
+		brcmf_fws_schedule_deq(fws);
+
 	/* signalling processing result does
 	 * not affect the actual ethernet packet.
 	 */
-- 
1.7.10.4


