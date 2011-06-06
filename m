Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35980 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab1FFONO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 10:13:14 -0400
Received: by mail-pz0-f46.google.com with SMTP id 9so1905470pzk.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2011 07:13:14 -0700 (PDT)
Message-ID: <4DECE065.1090202@ring3k.org> (sfid-20110606_161317_244165_C8184A60)
Date: Mon, 06 Jun 2011 23:12:53 +0900
From: Mike McCormack <mikem@ring3k.org>
MIME-Version: 1.0
To: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 4/5] rtlwifi: Free skb in one place
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Mike McCormack <mikem@ring3k.org>
---
 drivers/net/wireless/rtlwifi/pci.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index c89d6d7..b60c1ab 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -727,11 +727,9 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 		    (rtlpriv->rtlhal.current_bandtype == BAND_ON_2_4G) &&
 		     (ieee80211_is_beacon(fc) ||
 		     ieee80211_is_probe_resp(fc))) {
-			dev_kfree_skb_any(skb);
+			;
 		} else {
-			if (unlikely(!rtl_action_proc(hw, skb, false))) {
-				dev_kfree_skb_any(skb);
-			} else {
+			if (likely(rtl_action_proc(hw, skb, false))) {
 				struct sk_buff *uskb = NULL;
 				u8 *pdata;
 				uskb = dev_alloc_skb(skb->len + 128);
@@ -739,7 +737,6 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 				       &rx_status, sizeof(rx_status));
 				pdata = (u8 *)skb_put(uskb, skb->len);
 				memcpy(pdata, skb->data, skb->len);
-				dev_kfree_skb_any(skb);
 
 				ieee80211_rx_irqsafe(hw, uskb);
 			}
@@ -751,6 +748,7 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 			tasklet_schedule(&rtlpriv->works.ips_leave_tasklet);
 		}
 
+		dev_kfree_skb_any(skb);
 		skb = new_skb;
 
 		rtlpci->rx_ring[rx_queue_idx].rx_buf[index] = skb;
-- 
1.7.4.1


