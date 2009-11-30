Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:45406 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbZK3Rbe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 12:31:34 -0500
Date: Mon, 30 Nov 2009 18:31:40 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 02/11] mwl8k: hw is never NULL in mwl8k_set_radio_preamble()
Message-ID: <20091130173140.GR20214@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 51a762c..43b2d64 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1991,11 +1991,7 @@ static int mwl8k_cmd_radio_enable(struct ieee80211_hw *hw)
 static int
 mwl8k_set_radio_preamble(struct ieee80211_hw *hw, bool short_preamble)
 {
-	struct mwl8k_priv *priv;
-
-	if (hw == NULL || hw->priv == NULL)
-		return -EINVAL;
-	priv = hw->priv;
+	struct mwl8k_priv *priv = hw->priv;
 
 	priv->radio_short_preamble = short_preamble;
 
-- 
1.5.6.4
