Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62901 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab1FONKj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jun 2011 09:10:39 -0400
Date: Wed, 15 Jun 2011 16:10:10 +0300
From: Dan Carpenter <error27@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"open list:INTEL WIRELESS 39..." <linux-wireless@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Subject: [patch -next] iwlegacy: fix up brokenness caused by cleanup
Message-ID: <20110615131009.GD23739@shale.localdomain> (sfid-20110615_151044_243270_E753B749)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch 7f1f9742514 "iwlegacy: refactor iwl4965_mac_channel_switch"
reversed a test and also it changed a spin_lock_irq() to
spin_lock().  I assume the spin_lock change was a mistake because
the unlock was left as spin_unlock_irq().

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
Compile tested only.

diff --git a/drivers/net/wireless/iwlegacy/iwl4965-base.c b/drivers/net/wireless/iwlegacy/iwl4965-base.c
index 49a80bb..46242d2 100644
--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
@@ -2526,7 +2526,7 @@ void iwl4965_mac_channel_switch(struct ieee80211_hw *hw,
 	if (!iwl_legacy_is_associated_ctx(ctx))
 		goto out;
 
-	if (priv->cfg->ops->lib->set_channel_switch)
+	if (!priv->cfg->ops->lib->set_channel_switch)
 		goto out;
 
 	ch = channel->hw_value;
@@ -2539,7 +2539,7 @@ void iwl4965_mac_channel_switch(struct ieee80211_hw *hw,
 		goto out;
 	}
 
-	spin_lock(&priv->lock);
+	spin_lock_irq(&priv->lock);
 
 	priv->current_ht_config.smps = conf->smps_mode;
 
