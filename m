Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:58830 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab0ALMrt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 07:47:49 -0500
Date: Tue, 12 Jan 2010 13:47:47 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 04/17] mwl8k: simplify sequence number assignment
Message-ID: <20100112124747.GT1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

By storing the sequence counter in << 4 format, like other drivers do.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 67ee3da..7d165be 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1355,11 +1355,9 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 	mwl8k_vif = MWL8K_VIF(tx_info->control.vif);
 
 	if (tx_info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
-		u16 seqno = mwl8k_vif->seqno;
-
 		wh->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
-		wh->seq_ctrl |= cpu_to_le16(seqno << 4);
-		mwl8k_vif->seqno = seqno++ % 4096;
+		wh->seq_ctrl |= cpu_to_le16(mwl8k_vif->seqno);
+		mwl8k_vif->seqno += 0x10;
 	}
 
 	/* Setup firmware control bit fields for each frame type.  */
-- 
1.5.6.4
