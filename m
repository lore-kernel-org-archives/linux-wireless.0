Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650Ab0I3O0F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 10:26:05 -0400
Date: Thu, 30 Sep 2010 16:27:35 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] iwlwifi: change WARN_ON to IWL_WARN in iwl_mac_add_interface
Message-ID: <20100930142734.GA2368@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We can start restarting firmware or RF kill switch can be turned on
during call to iwl_mac_add_interface(). That are normal working
conditions, so do not print call trace, just print simple message
instead.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 5c56893..b7adcf8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2003,7 +2003,8 @@ int iwl_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 
 	mutex_lock(&priv->mutex);
 
-	if (WARN_ON(!iwl_is_ready_rf(priv))) {
+	if (!iwl_is_ready_rf(priv)) {
+		IWL_WARN(priv, "Try to add interface when device not ready\n");
 		err = -EINVAL;
 		goto out;
 	}
-- 
1.7.1

