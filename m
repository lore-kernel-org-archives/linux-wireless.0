Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:55965 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756541Ab1ISQQX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 12:16:23 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 7/9] ath6kl: Remove unnecessary bssinfo event header conversion
Date: Mon, 19 Sep 2011 19:15:05 +0300
Message-ID: <1316448907-10166-8-git-send-email-jouni@qca.qualcomm.com> (sfid-20110919_181625_646576_598BB238)
In-Reply-To: <1316448907-10166-1-git-send-email-jouni@qca.qualcomm.com>
References: <1316448907-10166-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no point in unconditionally converting the bssinfo header
to the old version since only the new header is being used and the
driver can as well read the values from it when needed. Leaving out
the conversion saves some extra memory copying.

In addition, use the calculated "rssi" value snr - 95 dBm to get the
proper value in cfg80211 BSS table (i.e., something that more or less
matches with the value used in STA info).

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c |   37 ++++++++-------------------------
 drivers/net/wireless/ath/ath6kl/wmi.h |   25 ++-------------------
 2 files changed, 12 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 3ade9a1..72cf78c 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -381,25 +381,6 @@ int ath6kl_wmi_dot3_2_dix(struct sk_buff *skb)
 	return 0;
 }
 
-static void ath6kl_wmi_convert_bssinfo_hdr2_to_hdr(struct sk_buff *skb,
-						   u8 *datap)
-{
-	struct wmi_bss_info_hdr2 bih2;
-	struct wmi_bss_info_hdr *bih;
-
-	memcpy(&bih2, datap, sizeof(struct wmi_bss_info_hdr2));
-
-	skb_push(skb, 4);
-	bih = (struct wmi_bss_info_hdr *) skb->data;
-
-	bih->ch = bih2.ch;
-	bih->frame_type = bih2.frame_type;
-	bih->snr = bih2.snr;
-	bih->rssi = a_cpu_to_sle16(bih2.snr - 95);
-	bih->ie_mask = cpu_to_le32(le16_to_cpu(bih2.ie_mask));
-	memcpy(bih->bssid, bih2.bssid, ETH_ALEN);
-}
-
 static int ath6kl_wmi_tx_complete_event_rx(u8 *datap, int len)
 {
 	struct tx_complete_msg_v1 *msg_v1;
@@ -912,24 +893,24 @@ static int ath6kl_wmi_tkip_micerr_event_rx(struct wmi *wmi, u8 *datap, int len)
 
 static int ath6kl_wmi_bssinfo_event_rx(struct wmi *wmi, u8 *datap, int len)
 {
-	struct wmi_bss_info_hdr *bih;
+	struct wmi_bss_info_hdr2 *bih;
 	u8 *buf;
 	struct ieee80211_channel *channel;
 	struct ath6kl *ar = wmi->parent_dev;
 	struct ieee80211_mgmt *mgmt;
 	struct cfg80211_bss *bss;
 
-	if (len <= sizeof(struct wmi_bss_info_hdr))
+	if (len <= sizeof(struct wmi_bss_info_hdr2))
 		return -EINVAL;
 
-	bih = (struct wmi_bss_info_hdr *) datap;
-	buf = datap + sizeof(struct wmi_bss_info_hdr);
-	len -= sizeof(struct wmi_bss_info_hdr);
+	bih = (struct wmi_bss_info_hdr2 *) datap;
+	buf = datap + sizeof(struct wmi_bss_info_hdr2);
+	len -= sizeof(struct wmi_bss_info_hdr2);
 
 	ath6kl_dbg(ATH6KL_DBG_WMI,
 		   "bss info evt - ch %u, snr %d, rssi %d, bssid \"%pM\" "
 		   "frame_type=%d\n",
-		   bih->ch, bih->snr, a_sle16_to_cpu(bih->rssi), bih->bssid,
+		   bih->ch, bih->snr, bih->snr - 95, bih->bssid,
 		   bih->frame_type);
 
 	if (bih->frame_type != BEACON_FTYPE &&
@@ -973,7 +954,8 @@ static int ath6kl_wmi_bssinfo_event_rx(struct wmi *wmi, u8 *datap, int len)
 	memcpy(&mgmt->u.beacon, buf, len);
 
 	bss = cfg80211_inform_bss_frame(ar->wdev->wiphy, channel, mgmt,
-					24 + len, bih->snr * 100, GFP_ATOMIC);
+					24 + len, (bih->snr - 95) * 100,
+					GFP_ATOMIC);
 	kfree(mgmt);
 	if (bss == NULL)
 		return -ENOMEM;
@@ -2859,8 +2841,7 @@ int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
 		break;
 	case WMI_BSSINFO_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_BSSINFO_EVENTID\n");
-		ath6kl_wmi_convert_bssinfo_hdr2_to_hdr(skb, datap);
-		ret = ath6kl_wmi_bssinfo_event_rx(wmi, skb->data, skb->len);
+		ret = ath6kl_wmi_bssinfo_event_rx(wmi, datap, len);
 		break;
 	case WMI_REGDOMAIN_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_REGDOMAIN_EVENTID\n");
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index f65bc0d..d458d6d 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1393,33 +1393,14 @@ struct roam_ctrl_cmd {
 	u8 roam_ctrl;
 } __packed;
 
-struct wmi_bss_info_hdr {
-	__le16 ch;
-
-	/* see, enum wmi_bi_ftype */
-	u8 frame_type;
-
-	u8 snr;
-	a_sle16 rssi;
-	u8 bssid[ETH_ALEN];
-	__le32 ie_mask;
-} __packed;
-
-/*
- * BSS INFO HDR version 2.0
- * With 6 bytes HTC header and 6 bytes of WMI header
- * WMI_BSS_INFO_HDR cannot be accommodated in the removed 802.11 management
- * header space.
- * - Reduce the ie_mask to 2 bytes as only two bit flags are used
- * - Remove rssi and compute it on the host. rssi = snr - 95
- */
+/* BSS INFO HDR version 2.0 */
 struct wmi_bss_info_hdr2 {
-	__le16 ch;
+	__le16 ch; /* frequency in MHz */
 
 	/* see, enum wmi_bi_ftype */
 	u8 frame_type;
 
-	u8 snr;
+	u8 snr; /* note: rssi = snr - 95 dBm */
 	u8 bssid[ETH_ALEN];
 	__le16 ie_mask;
 } __packed;
-- 
1.7.4.1

