Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37081 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245AbYLVDiv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2008 22:38:51 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 09/10] iwlwifi: fix warning 'Should it be static'
Date: Mon, 22 Dec 2008 11:31:22 +0800
Message-Id: <1229916683-9772-10-git-send-email-yi.zhu@intel.com> (sfid-20081222_043858_238295_CB302BF9)
In-Reply-To: <1229916683-9772-9-git-send-email-yi.zhu@intel.com>
References: <1229916683-9772-1-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-2-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-3-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-4-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-5-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-6-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-7-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-8-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-9-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

This patch adds static for functions iwl3945_apm_reset() and
iwl3945_init_drv(). It fixes compile warnings.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index ae68f2b..fb2c2db 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1315,7 +1315,7 @@ static void iwl3945_apm_stop(struct iwl_priv *priv)
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
-int iwl3945_apm_reset(struct iwl_priv *priv)
+static int iwl3945_apm_reset(struct iwl_priv *priv)
 {
 	int rc;
 	unsigned long flags;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 32cfc8f..2e5c4d8 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -7423,7 +7423,7 @@ static struct ieee80211_ops iwl3945_hw_ops = {
 	.hw_scan = iwl3945_mac_hw_scan
 };
 
-int iwl3945_init_drv(struct iwl_priv *priv)
+static int iwl3945_init_drv(struct iwl_priv *priv)
 {
 	int ret;
 
-- 
1.5.3.6

