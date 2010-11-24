Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753155Ab0KXKiG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 05:38:06 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] iwlwifi: avoid "Error sending TX power (-5)"
Date: Wed, 24 Nov 2010 11:37:49 +0100
Message-Id: <1290595069-3878-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We can have this error message when loading or unloading module, when
device is not marked as ready, but we want to set tx power from
commit_rxon. Perhaps something better should be done like call
lib->send_tx_power() directly from commit_rxon, but for now just
do not return error.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index c884ed3..3f826e5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1169,8 +1169,13 @@ int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
 		return -EINVAL;
 	}
 
+	/*
+	 * (FIXME ?) Do not report error, we can be called through commit_rxon
+	 * from iwl_set_mode() and iwl_bg_alive_start() when device is not
+	 * marked as ready
+	 */
 	if (!iwl_is_ready_rf(priv))
-		return -EIO;
+		return 0;
 
 	/* scan complete use tx_power_next, need to be updated */
 	priv->tx_power_next = tx_power;
-- 
1.7.1

