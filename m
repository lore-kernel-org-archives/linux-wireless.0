Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:44352 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932772AbaDII6R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 04:58:17 -0400
Received: by mail-ee0-f52.google.com with SMTP id e49so1581218eek.39
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 01:58:15 -0700 (PDT)
From: Marek Kwaczynski <marek.kwaczynski@tieto.com>
To: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Cc: johannes@sipsolutions.net,
	Marek Kwaczynski <marek.kwaczynski@tieto.com>
Subject: [PATCH v2 2/2] ath10k: Fix pmf for action frames
Date: Wed,  9 Apr 2014 10:57:37 +0200
Message-Id: <1397033857-2523-2-git-send-email-marek.kwaczynski@tieto.com> (sfid-20140409_105824_437854_7F129592)
In-Reply-To: <1397033857-2523-1-git-send-email-marek.kwaczynski@tieto.com>
References: <1397033857-2523-1-git-send-email-marek.kwaczynski@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix sending and receiveing protected managment frames.
Lack of protected flag for received protected action frames
causes report these frames as unprotected robust action frames.
If the driver in AP mode sent frame with protected flag and
CCMP header using IEEE80211_KEY_FLAG_SW_MGMT_TX flag,
the FW encrypted frames once again. From user side all
received SA Query Requests and Responses were skipped and
all protected action frames were sent as malformed packets.

Signed-off-by: Marek Kwaczynski <marek.kwaczynski@tieto.com>
---

v2: fix missed prefix

 drivers/net/wireless/ath/ath10k/mac.c |    5 ++++-
 drivers/net/wireless/ath/ath10k/wmi.c |   24 ++++++++++++++++++++----
 2 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 58ec5a7..0c66c18 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -54,7 +54,10 @@ static int ath10k_send_key(struct ath10k_vif *arvif,
 	switch (key->cipher) {
 	case WLAN_CIPHER_SUITE_CCMP:
 		arg.key_cipher = WMI_CIPHER_AES_CCM;
-		key->flags |= IEEE80211_KEY_FLAG_SW_MGMT_TX;
+		if (arvif->vdev_type == WMI_VDEV_TYPE_AP)
+			key->flags |= IEEE80211_KEY_FLAG_GENERATE_MGMT_IV_TX;
+		else
+			key->flags |= IEEE80211_KEY_FLAG_SW_MGMT_TX;
 		break;
 	case WLAN_CIPHER_SUITE_TKIP:
 		arg.key_cipher = WMI_CIPHER_TKIP;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index d4b48ef..6d8a097 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -639,6 +639,7 @@ int ath10k_wmi_mgmt_tx(struct ath10k *ar, struct sk_buff *skb)
 	struct sk_buff *wmi_skb;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	int len;
+	u32 buf_len = skb->len;
 	u16 fc;
 
 	hdr = (struct ieee80211_hdr *)skb->data;
@@ -648,6 +649,15 @@ int ath10k_wmi_mgmt_tx(struct ath10k *ar, struct sk_buff *skb)
 		return -EINVAL;
 
 	len = sizeof(cmd->hdr) + skb->len;
+
+	if ((ieee80211_is_action(hdr->frame_control) ||
+	     ieee80211_is_deauth(hdr->frame_control) ||
+	     ieee80211_is_disassoc(hdr->frame_control)) &&
+	     ieee80211_has_protected(hdr->frame_control)) {
+		len += IEEE80211_CCMP_MIC_LEN;
+		buf_len += IEEE80211_CCMP_MIC_LEN;
+	}
+
 	len = round_up(len, 4);
 
 	wmi_skb = ath10k_wmi_alloc_skb(len);
@@ -659,7 +669,7 @@ int ath10k_wmi_mgmt_tx(struct ath10k *ar, struct sk_buff *skb)
 	cmd->hdr.vdev_id = __cpu_to_le32(ATH10K_SKB_CB(skb)->vdev_id);
 	cmd->hdr.tx_rate = 0;
 	cmd->hdr.tx_power = 0;
-	cmd->hdr.buf_len = __cpu_to_le32((u32)(skb->len));
+	cmd->hdr.buf_len = __cpu_to_le32(buf_len);
 
 	memcpy(cmd->hdr.peer_macaddr.addr, ieee80211_get_DA(hdr), ETH_ALEN);
 	memcpy(cmd->buf, skb->data, skb->len);
@@ -957,10 +967,16 @@ static int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 	 * frames with Protected Bit set. */
 	if (ieee80211_has_protected(hdr->frame_control) &&
 	    !ieee80211_is_auth(hdr->frame_control)) {
-		status->flag |= RX_FLAG_DECRYPTED | RX_FLAG_IV_STRIPPED |
-				RX_FLAG_MMIC_STRIPPED;
-		hdr->frame_control = __cpu_to_le16(fc &
+		status->flag |= RX_FLAG_DECRYPTED;
+
+		if (!ieee80211_is_action(hdr->frame_control) &&
+		    !ieee80211_is_deauth(hdr->frame_control) &&
+		    !ieee80211_is_disassoc(hdr->frame_control)) {
+			status->flag |= RX_FLAG_IV_STRIPPED |
+					RX_FLAG_MMIC_STRIPPED;
+			hdr->frame_control = __cpu_to_le16(fc &
 					~IEEE80211_FCTL_PROTECTED);
+		}
 	}
 
 	ath10k_dbg(ATH10K_DBG_MGMT,
-- 
1.7.9.5

