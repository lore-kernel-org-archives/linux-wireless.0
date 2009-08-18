Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:40179 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756286AbZHRDwT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 23:52:19 -0400
Date: Tue, 18 Aug 2009 05:52:20 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 09/29] mwl8k: remove usage of deprecated radio_enabled
Message-ID: <20090818035220.GN18639@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 9f54204..3a201a2 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2935,7 +2935,7 @@ static int mwl8k_config_wt(struct work_struct *wt)
 	struct mwl8k_priv *priv = hw->priv;
 	int rc = 0;
 
-	if (!conf->radio_enabled) {
+	if (conf->flags & IEEE80211_CONF_IDLE) {
 		mwl8k_cmd_802_11_radio_disable(hw);
 		priv->current_channel = NULL;
 		rc = 0;
-- 
1.5.6.4
