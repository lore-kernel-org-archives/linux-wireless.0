Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:61291 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873AbYAWSPX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2008 13:15:23 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Maarten Lankhorst <m.b.lankhorst@gmail.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH] iwlwifi: Fix an invalid bitmask test in iwl3945 and iwl4965
Date: Wed, 23 Jan 2008 10:15:16 -0800
Message-Id: <1201112121-22340-2-git-send-email-reinette.chatre@intel.com> (sfid-20080123_181529_192516_3563B17B)
In-Reply-To: <1201112121-22340-1-git-send-email-reinette.chatre@intel.com>
References: <1201112121-22340-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Maarten Lankhorst <m.b.lankhorst@gmail.com>

Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 61f9eb7..c9f2ce5 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -7120,7 +7120,7 @@ static void iwl3945_config_ap(struct iwl3945_priv *priv)
 {
 	int rc = 0;
 
-	if (priv->status & STATUS_EXIT_PENDING)
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
 	/* The following should be done only at AP bring up */
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 04217e9..bcaaec2 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -7580,7 +7580,7 @@ static void iwl4965_config_ap(struct iwl4965_priv *priv)
 {
 	int rc = 0;
 
-	if (priv->status & STATUS_EXIT_PENDING)
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
 	/* The following should be done only at AP bring up */
-- 
1.5.3.4

