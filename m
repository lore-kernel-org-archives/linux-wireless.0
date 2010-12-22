Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:44229 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab0LVQ4B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 11:56:01 -0500
Date: Wed, 22 Dec 2010 10:56:02 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: Fix large packet issue
Message-ID: <4d122da2.JR/KEqgZBBb8QjT4%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaoming Li <chaoming_li@realsil.com.cn>

An RX buffer is set to 9100 bytes to receive 8K AMSDU; however, an skb
of this size fails in the kernel.

Signed-off-by: Chaoming Li <chaoming_li@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This fix should be in 2.6.38.

Larry
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/pci.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/pci.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/pci.c
@@ -612,10 +612,22 @@ static void _rtl_pci_rx_interrupt(struct
 						    num_rx_inperiod++;
 				}
 
-				if (unlikely(!rtl_action_proc(hw, skb, false)))
+				if (unlikely(!rtl_action_proc(hw, skb,
+				    false))) {
 					dev_kfree_skb_any(skb);
-				else
-					ieee80211_rx_irqsafe(hw, skb);
+				} else {
+					struct sk_buff *uskb = NULL;
+					u8 *pdata;
+					uskb = dev_alloc_skb(skb->len + 128);
+					memcpy(IEEE80211_SKB_RXCB(uskb),
+							&rx_status,
+							sizeof(rx_status));
+					pdata = (u8 *)skb_put(uskb, skb->len);
+					memcpy(pdata, skb->data, skb->len);
+					dev_kfree_skb_any(skb);
+
+					ieee80211_rx_irqsafe(hw, uskb);
+				}
 			} else {
 				dev_kfree_skb_any(skb);
 			}
