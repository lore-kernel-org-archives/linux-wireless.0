Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34210 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989Ab1FFON1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 10:13:27 -0400
Received: by pwi15 with SMTP id 15so2108882pwi.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2011 07:13:26 -0700 (PDT)
Message-ID: <4DECE072.10702@ring3k.org> (sfid-20110606_161330_388578_F7F8CCDA)
Date: Mon, 06 Jun 2011 23:13:06 +0900
From: Mike McCormack <mikem@ring3k.org>
MIME-Version: 1.0
To: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 5/5] rtlwifi: Factor out code to receive one packet
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Mike McCormack <mikem@ring3k.org>
---
 drivers/net/wireless/rtlwifi/pci.c |   99 ++++++++++++++++++-----------------
 1 files changed, 51 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index b60c1ab..cb4e5e8 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -626,6 +626,56 @@ tx_status_ok:
 	}
 }
 
+static void _rtl_receive_one(struct ieee80211_hw *hw, struct sk_buff *skb,
+			     struct ieee80211_rx_status rx_status)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct ieee80211_hdr *hdr = rtl_get_hdr(skb);
+	__le16 fc = rtl_get_fc(skb);
+	bool unicast = false;
+	struct sk_buff *uskb = NULL;
+	u8 *pdata;
+
+
+	memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
+
+	if (is_broadcast_ether_addr(hdr->addr1)) {
+		;/*TODO*/
+	} else if (is_multicast_ether_addr(hdr->addr1)) {
+		;/*TODO*/
+	} else {
+		unicast = true;
+		rtlpriv->stats.rxbytesunicast += skb->len;
+	}
+
+	rtl_is_special_data(hw, skb, false);
+
+	if (ieee80211_is_data(fc)) {
+		rtlpriv->cfg->ops->led_control(hw, LED_CTL_RX);
+
+		if (unicast)
+			rtlpriv->link_info.num_rx_inperiod++;
+	}
+
+	/* for sw lps */
+	rtl_swlps_beacon(hw, (void *)skb->data, skb->len);
+	rtl_recognize_peer(hw, (void *)skb->data, skb->len);
+	if ((rtlpriv->mac80211.opmode == NL80211_IFTYPE_AP) &&
+	    (rtlpriv->rtlhal.current_bandtype == BAND_ON_2_4G) &&
+	     (ieee80211_is_beacon(fc) || ieee80211_is_probe_resp(fc)))
+		return;
+
+	if (unlikely(!rtl_action_proc(hw, skb, false)))
+		return;
+
+	uskb = dev_alloc_skb(skb->len + 128);
+	memcpy(IEEE80211_SKB_RXCB(uskb), &rx_status, sizeof(rx_status));
+	pdata = (u8 *)skb_put(uskb, skb->len);
+	memcpy(pdata, skb->data, skb->len);
+
+	ieee80211_rx_irqsafe(hw, uskb);
+}
+
 static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -637,7 +687,6 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 	u8 own;
 	u8 tmp_one;
 	u32 bufferaddress;
-	bool unicast = false;
 
 	struct rtl_stats stats = {
 		.signal = 0,
@@ -654,8 +703,6 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 		/*rx pkt */
 		struct sk_buff *skb = rtlpci->rx_ring[rx_queue_idx].rx_buf[
 				index];
-		struct ieee80211_hdr *hdr;
-		__le16 fc;
 		struct sk_buff *new_skb = NULL;
 
 		own = (u8) rtlpriv->cfg->ops->get_desc((u8 *) pdesc,
@@ -696,51 +743,7 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 		 * skb_trim(skb, skb->len - 4);
 		 */
 
-		hdr = rtl_get_hdr(skb);
-		fc = rtl_get_fc(skb);
-
-		memcpy(IEEE80211_SKB_RXCB(skb), &rx_status,
-		       sizeof(rx_status));
-
-		if (is_broadcast_ether_addr(hdr->addr1)) {
-			;/*TODO*/
-		} else if (is_multicast_ether_addr(hdr->addr1)) {
-			;/*TODO*/
-		} else {
-			unicast = true;
-			rtlpriv->stats.rxbytesunicast += skb->len;
-		}
-
-		rtl_is_special_data(hw, skb, false);
-
-		if (ieee80211_is_data(fc)) {
-			rtlpriv->cfg->ops->led_control(hw, LED_CTL_RX);
-
-			if (unicast)
-				rtlpriv->link_info.num_rx_inperiod++;
-		}
-
-		/* for sw lps */
-		rtl_swlps_beacon(hw, (void *)skb->data, skb->len);
-		rtl_recognize_peer(hw, (void *)skb->data, skb->len);
-		if ((rtlpriv->mac80211.opmode == NL80211_IFTYPE_AP) &&
-		    (rtlpriv->rtlhal.current_bandtype == BAND_ON_2_4G) &&
-		     (ieee80211_is_beacon(fc) ||
-		     ieee80211_is_probe_resp(fc))) {
-			;
-		} else {
-			if (likely(rtl_action_proc(hw, skb, false))) {
-				struct sk_buff *uskb = NULL;
-				u8 *pdata;
-				uskb = dev_alloc_skb(skb->len + 128);
-				memcpy(IEEE80211_SKB_RXCB(uskb),
-				       &rx_status, sizeof(rx_status));
-				pdata = (u8 *)skb_put(uskb, skb->len);
-				memcpy(pdata, skb->data, skb->len);
-
-				ieee80211_rx_irqsafe(hw, uskb);
-			}
-		}
+		_rtl_receive_one(hw, skb, rx_status);
 
 		if (((rtlpriv->link_info.num_rx_inperiod +
 			rtlpriv->link_info.num_tx_inperiod) > 8) ||
-- 
1.7.4.1

