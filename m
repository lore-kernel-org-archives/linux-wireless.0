Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:48198 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083Ab3CQJ7U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Mar 2013 05:59:20 -0400
Subject: [PATCH 2/4] rtlwifi: usb: remove extra skb copy on RX path
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Date: Sun, 17 Mar 2013 11:59:18 +0200
Message-ID: <20130317095918.24983.57848.stgit@localhost6.localdomain6> (sfid-20130317_105925_696033_A786301A)
In-Reply-To: <20130317095831.24983.97107.stgit@localhost6.localdomain6>
References: <20130317095831.24983.97107.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RX path has extra copying of packets, that can be avoided.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 drivers/net/wireless/rtlwifi/usb.c |   19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index 146d2b4..8563818 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -513,22 +513,11 @@ static void _rtl_usb_rx_process_noagg(struct ieee80211_hw *hw,
 			if (unicast)
 				rtlpriv->link_info.num_rx_inperiod++;
 		}
-		if (likely(rtl_action_proc(hw, skb, false))) {
-			struct sk_buff *uskb = NULL;
-			u8 *pdata;
-
-			uskb = dev_alloc_skb(skb->len + 128);
-			if (uskb) {	/* drop packet on allocation failure */
-				memcpy(IEEE80211_SKB_RXCB(uskb), &rx_status,
-				       sizeof(rx_status));
-				pdata = (u8 *)skb_put(uskb, skb->len);
-				memcpy(pdata, skb->data, skb->len);
-				ieee80211_rx_irqsafe(hw, uskb);
-			}
-			dev_kfree_skb_any(skb);
-		} else {
+
+		if (likely(rtl_action_proc(hw, skb, false)))
+			ieee80211_rx_irqsafe(hw, skb);
+		else
 			dev_kfree_skb_any(skb);
-		}
 	}
 }
 

