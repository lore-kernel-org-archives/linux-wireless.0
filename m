Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:36687 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbbLUXFO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 18:05:14 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Stable <stable@vger.kernel.org>
Subject: [PATCH] rtlwifi: rtl_pci: Fix kernel panic
Date: Mon, 21 Dec 2015 17:05:08 -0600
Message-Id: <1450739108-24121-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20151222_000521_518910_0B5DE288)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In commit 38506ecefab9 (rtlwifi: rtl_pci: Start modification for new
drivers), a bug was introduced that causes a NULL pointer dereference.
As this bug only affects the infrequently used RTL8192EE and only under
low-memory conditions, it has taken a long time for the bug to show up.

The bug was reported on the linix-wireless mailing list and also at
https://bugs.launchpad.net/ubuntu/+source/ubuntu-release-upgrader/ as
bug #1527603 (kernel crashes due to rtl8192ee driver on ubuntu 15.10).

Fixes: 38506ecefab9
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/pci.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index f46c9d7..7f471bf 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -801,7 +801,9 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 								      hw_queue);
 			if (rx_remained_cnt == 0)
 				return;
-
+			buffer_desc = &rtlpci->rx_ring[rxring_idx].buffer_desc[
+				rtlpci->rx_ring[rxring_idx].idx];
+			pdesc = (struct rtl_rx_desc *)skb->data;
 		} else {	/* rx descriptor */
 			pdesc = &rtlpci->rx_ring[rxring_idx].desc[
 				rtlpci->rx_ring[rxring_idx].idx];
@@ -824,13 +826,6 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 		new_skb = dev_alloc_skb(rtlpci->rxbuffersize);
 		if (unlikely(!new_skb))
 			goto no_new;
-		if (rtlpriv->use_new_trx_flow) {
-			buffer_desc =
-			  &rtlpci->rx_ring[rxring_idx].buffer_desc
-				[rtlpci->rx_ring[rxring_idx].idx];
-			/*means rx wifi info*/
-			pdesc = (struct rtl_rx_desc *)skb->data;
-		}
 		memset(&rx_status , 0 , sizeof(rx_status));
 		rtlpriv->cfg->ops->query_rx_desc(hw, &stats,
 						 &rx_status, (u8 *)pdesc, skb);
-- 
2.1.4

