Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:45424 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbZK3Rc6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 12:32:58 -0500
Date: Mon, 30 Nov 2009 18:33:04 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 10/11] mwl8k: remove unused mwl8k_vif::priv
Message-ID: <20091130173304.GZ20214@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 36c826c..c53968b 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -205,9 +205,6 @@ struct mwl8k_priv {
 
 /* Per interface specific private data */
 struct mwl8k_vif {
-	/* backpointer to parent config block */
-	struct mwl8k_priv *priv;
-
 	/* BSS config of AP or IBSS from mac80211*/
 	struct ieee80211_bss_conf bss_info;
 
@@ -2878,9 +2875,6 @@ static int mwl8k_add_interface(struct ieee80211_hw *hw,
 	mwl8k_cmd_set_mac_addr(hw, conf->mac_addr);
 	memcpy(mwl8k_vif->mac_addr, conf->mac_addr, ETH_ALEN);
 
-	/* Back pointer to parent config block */
-	mwl8k_vif->priv = priv;
-
 	/* Set Initial sequence number to zero */
 	mwl8k_vif->seqno = 0;
 
-- 
1.5.6.4
