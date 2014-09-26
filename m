Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:34684 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205AbaIZVkj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2014 17:40:39 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, troy_tan@realsil.com.cn,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org
Subject: [PATCH 1/7 NEXT] rtlwifi: rtl8188ee: rtl8821ae: Fix a queue locking problem
Date: Fri, 26 Sep 2014 16:40:22 -0500
Message-Id: <1411767628-7965-2-git-send-email-Larry.Finger@lwfinger.net> (sfid-20140926_234047_062327_6B05A095)
In-Reply-To: <1411767628-7965-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1411767628-7965-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The code fails to lock the skb queue, which leads to a number of problems.
This patch also fixes a Sparse warning about using a memset of 1 byte.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: troy_tan@realsil.com.cn
---
 drivers/net/wireless/rtlwifi/rtl8188ee/fw.c | 2 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/hw.c | 3 +++
 drivers/net/wireless/rtlwifi/rtl8821ae/fw.c | 2 +-
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/fw.c b/drivers/net/wireless/rtlwifi/rtl8188ee/fw.c
index eda6617..8d4cf2e 100644
--- a/drivers/net/wireless/rtlwifi/rtl8188ee/fw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/fw.c
@@ -770,7 +770,7 @@ void rtl88e_set_p2p_ps_offload_cmd(struct ieee80211_hw *hw, u8 p2p_ps_state)
 	switch (p2p_ps_state) {
 	case P2P_PS_DISABLE:
 		RT_TRACE(rtlpriv, COMP_FW, DBG_LOUD, "P2P_PS_DISABLE\n");
-		memset(p2p_ps_offload, 0, 1);
+		memset(p2p_ps_offload, 0, sizeof(*p2p_ps_offload));
 		break;
 	case P2P_PS_ENABLE:
 		RT_TRACE(rtlpriv, COMP_FW, DBG_LOUD, "P2P_PS_ENABLE\n");
diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
index f74b7fb..f2b9713 100644
--- a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
@@ -89,7 +89,9 @@ static void _rtl88ee_return_beacon_queue_skb(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl8192_tx_ring *ring = &rtlpci->tx_ring[BEACON_QUEUE];
+	unsigned long flags;
 
+	spin_lock_irqsave(&rtlpriv->locks.irq_th_lock, flags);
 	while (skb_queue_len(&ring->queue)) {
 		struct rtl_tx_desc *entry = &ring->desc[ring->idx];
 		struct sk_buff *skb = __skb_dequeue(&ring->queue);
@@ -101,6 +103,7 @@ static void _rtl88ee_return_beacon_queue_skb(struct ieee80211_hw *hw)
 		kfree_skb(skb);
 		ring->idx = (ring->idx + 1) % ring->entries;
 	}
+	spin_unlock_irqrestore(&rtlpriv->locks.irq_th_lock, flags);
 }
 
 static void _rtl88ee_disable_bcn_sub_func(struct ieee80211_hw *hw)
diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/fw.c b/drivers/net/wireless/rtlwifi/rtl8821ae/fw.c
index 6f71aaa..2efdb64 100644
--- a/drivers/net/wireless/rtlwifi/rtl8821ae/fw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8821ae/fw.c
@@ -1757,7 +1757,7 @@ void rtl8821ae_set_p2p_ps_offload_cmd(struct ieee80211_hw *hw, u8 p2p_ps_state)
 	switch (p2p_ps_state) {
 	case P2P_PS_DISABLE:
 		RT_TRACE(rtlpriv, COMP_FW, DBG_LOUD, "P2P_PS_DISABLE\n");
-		memset(p2p_ps_offload, 0, 1);
+		memset(p2p_ps_offload, 0, sizeof(*p2p_ps_offload));
 		break;
 	case P2P_PS_ENABLE:
 		RT_TRACE(rtlpriv, COMP_FW, DBG_LOUD, "P2P_PS_ENABLE\n");
-- 
1.8.4.5

