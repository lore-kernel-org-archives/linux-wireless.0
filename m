Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43102 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753540AbXLRAX4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 19:23:56 -0500
Message-Id: <200712180022.lBI0MqGt010072@imap1.linux-foundation.org> (sfid-20071218_002400_273049_6635726F)
Subject: [patch (for 2.6.24?) 2/4] iwlwifi3945/4965: fix rate control algo reference leak
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, akpm@linux-foundation.org,
	gorcunov@gmail.com, yi.zhu@intel.com
From: akpm@linux-foundation.org
Date: Mon, 17 Dec 2007 16:22:52 -0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Cyrill Gorcunov <gorcunov@gmail.com>

Fix rate control algo reference leak in case if network device has been
failed to register.  In this case special flag priv->mac80211_registered is
not set and the rate algo reference is not freeing on module unload.  That
leads to OOPs in further ieee80211 rate register/unregister procedure (by
any callee).

It should fix the bug #9470

	http://bugzilla.kernel.org/show_bug.cgi?id=9470

[akpm@linux-foundation.org: build fix]
Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Acked-by: Zhu Yi <yi.zhu@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 +
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    1 +
 2 files changed, 2 insertions(+)

diff -puN drivers/net/wireless/iwlwifi/iwl3945-base.c~iwlwifi3945-4965-fix-rate-control-algo-reference-leak drivers/net/wireless/iwlwifi/iwl3945-base.c
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c~iwlwifi3945-4965-fix-rate-control-algo-reference-leak
+++ a/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6171,6 +6171,7 @@ static void iwl_alive_start(struct iwl_p
 		mutex_lock(&priv->mutex);
 
 		if (rc) {
+			iwl3945_rate_control_unregister(priv->hw);
 			IWL_ERROR("Failed to register network "
 				  "device (error %d)\n", rc);
 			return;
diff -puN drivers/net/wireless/iwlwifi/iwl4965-base.c~iwlwifi3945-4965-fix-rate-control-algo-reference-leak drivers/net/wireless/iwlwifi/iwl4965-base.c
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c~iwlwifi3945-4965-fix-rate-control-algo-reference-leak
+++ a/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -6527,6 +6527,7 @@ static void iwl_alive_start(struct iwl_p
 		mutex_lock(&priv->mutex);
 
 		if (rc) {
+			iwl4965_rate_control_unregister(priv->hw);
 			IWL_ERROR("Failed to register network "
 				  "device (error %d)\n", rc);
 			return;
_
