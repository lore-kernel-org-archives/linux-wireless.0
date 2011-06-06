Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35980 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab1FFOND (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 10:13:03 -0400
Received: by pzk9 with SMTP id 9so1905470pzk.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2011 07:13:03 -0700 (PDT)
Message-ID: <4DECE05A.6080803@ring3k.org> (sfid-20110606_161308_246602_DB05036F)
Date: Mon, 06 Jun 2011 23:12:42 +0900
From: Mike McCormack <mikem@ring3k.org>
MIME-Version: 1.0
To: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 3/5] rtlwifi: Resubmit skbs with bad CRC early
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Once we realize a bad packet was received, don't
waste time unmapping it, freeing it, then allocation
a new skb and mapping it, just resubmit the existing
skb.

Signed-off-by: Mike McCormack <mikem@ring3k.org>
---
 drivers/net/wireless/rtlwifi/pci.c |   81 +++++++++++++++++------------------
 1 files changed, 39 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index fbb4c13..c89d6d7 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -669,6 +669,9 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 						 &rx_status,
 						 (u8 *) pdesc, skb);
 
+		if (stats.crc || stats.hwerror)
+			goto done;
+
 		new_skb = dev_alloc_skb(rtlpci->rxbuffersize);
 		if (unlikely(!new_skb)) {
 			RT_TRACE(rtlpriv, (COMP_INTR | COMP_RECV),
@@ -696,56 +699,50 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 		hdr = rtl_get_hdr(skb);
 		fc = rtl_get_fc(skb);
 
-		if (!stats.crc && !stats.hwerror) {
-			memcpy(IEEE80211_SKB_RXCB(skb), &rx_status,
-				       sizeof(rx_status));
+		memcpy(IEEE80211_SKB_RXCB(skb), &rx_status,
+		       sizeof(rx_status));
 
-			if (is_broadcast_ether_addr(hdr->addr1)) {
-				;/*TODO*/
-			} else if (is_multicast_ether_addr(hdr->addr1)) {
-				;/*TODO*/
-			} else {
-				unicast = true;
-				rtlpriv->stats.rxbytesunicast += skb->len;
-			}
+		if (is_broadcast_ether_addr(hdr->addr1)) {
+			;/*TODO*/
+		} else if (is_multicast_ether_addr(hdr->addr1)) {
+			;/*TODO*/
+		} else {
+			unicast = true;
+			rtlpriv->stats.rxbytesunicast += skb->len;
+		}
 
-			rtl_is_special_data(hw, skb, false);
+		rtl_is_special_data(hw, skb, false);
 
-			if (ieee80211_is_data(fc)) {
-				rtlpriv->cfg->ops->led_control(hw, LED_CTL_RX);
+		if (ieee80211_is_data(fc)) {
+			rtlpriv->cfg->ops->led_control(hw, LED_CTL_RX);
 
-				if (unicast)
-					rtlpriv->link_info.num_rx_inperiod++;
-			}
+			if (unicast)
+				rtlpriv->link_info.num_rx_inperiod++;
+		}
 
-			/* for sw lps */
-			rtl_swlps_beacon(hw, (void *)skb->data, skb->len);
-			rtl_recognize_peer(hw, (void *)skb->data, skb->len);
-			if ((rtlpriv->mac80211.opmode == NL80211_IFTYPE_AP) &&
-			    (rtlpriv->rtlhal.current_bandtype ==
-			     BAND_ON_2_4G) &&
-			     (ieee80211_is_beacon(fc) ||
-			     ieee80211_is_probe_resp(fc))) {
+		/* for sw lps */
+		rtl_swlps_beacon(hw, (void *)skb->data, skb->len);
+		rtl_recognize_peer(hw, (void *)skb->data, skb->len);
+		if ((rtlpriv->mac80211.opmode == NL80211_IFTYPE_AP) &&
+		    (rtlpriv->rtlhal.current_bandtype == BAND_ON_2_4G) &&
+		     (ieee80211_is_beacon(fc) ||
+		     ieee80211_is_probe_resp(fc))) {
+			dev_kfree_skb_any(skb);
+		} else {
+			if (unlikely(!rtl_action_proc(hw, skb, false))) {
 				dev_kfree_skb_any(skb);
 			} else {
-				if (unlikely(!rtl_action_proc(hw, skb,
-				    false))) {
-					dev_kfree_skb_any(skb);
-				} else {
-					struct sk_buff *uskb = NULL;
-					u8 *pdata;
-					uskb = dev_alloc_skb(skb->len + 128);
-					memcpy(IEEE80211_SKB_RXCB(uskb),
-					       &rx_status, sizeof(rx_status));
-					pdata = (u8 *)skb_put(uskb, skb->len);
-					memcpy(pdata, skb->data, skb->len);
-					dev_kfree_skb_any(skb);
-
-					ieee80211_rx_irqsafe(hw, uskb);
-				}
+				struct sk_buff *uskb = NULL;
+				u8 *pdata;
+				uskb = dev_alloc_skb(skb->len + 128);
+				memcpy(IEEE80211_SKB_RXCB(uskb),
+				       &rx_status, sizeof(rx_status));
+				pdata = (u8 *)skb_put(uskb, skb->len);
+				memcpy(pdata, skb->data, skb->len);
+				dev_kfree_skb_any(skb);
+
+				ieee80211_rx_irqsafe(hw, uskb);
 			}
-		} else {
-			dev_kfree_skb_any(skb);
 		}
 
 		if (((rtlpriv->link_info.num_rx_inperiod +
-- 
1.7.4.1


