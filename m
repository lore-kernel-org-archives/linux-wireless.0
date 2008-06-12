Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:8439 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841AbYFLBuE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 21:50:04 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 27/29] iwlwifi: fix software rf_kill problem when interface is down
Date: Thu, 12 Jun 2008 09:47:17 +0800
Message-Id: <1213235239-2954-28-git-send-email-yi.zhu@intel.com> (sfid-20080612_041914_035911_DAC1F742)
In-Reply-To: <1213235239-2954-27-git-send-email-yi.zhu@intel.com>
References: <1213235239-2954-1-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-2-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-3-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-4-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-5-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-6-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-7-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-8-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-9-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-10-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-11-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-12-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-13-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-14-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-15-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-16-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-17-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-18-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-19-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-20-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-21-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-22-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-23-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-24-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-25-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-26-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-27-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch fixes the problem that software rf_kill messes up the
card status when it is disabled if the interface is down.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    3 ++-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 72279e0..d0084bc 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2875,7 +2875,8 @@ static void iwl3945_radio_kill_sw(struct iwl3945_priv *priv, int disable_radio)
 		return;
 	}
 
-	queue_work(priv->workqueue, &priv->restart);
+	if (priv->is_open)
+		queue_work(priv->workqueue, &priv->restart);
 	return;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 8f1ab23..5aec7d5 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -970,7 +970,8 @@ int iwl4965_radio_kill_sw(struct iwl_priv *priv, int disable_radio)
 		return 0;
 	}
 
-	queue_work(priv->workqueue, &priv->restart);
+	if (priv->is_open)
+		queue_work(priv->workqueue, &priv->restart);
 	return 1;
 }
 
-- 
1.5.3.6

