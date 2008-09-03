Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:22294 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754113AbYICDXA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:23:00 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Gregory Greenman <gregory.greenman@intel.com>,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 8/9] iwlwifi: call apm stop on exit
Date: Wed,  3 Sep 2008 11:18:49 +0800
Message-Id: <1220411930-15216-9-git-send-email-yi.zhu@intel.com> (sfid-20080903_052310_165087_6792E508)
In-Reply-To: <1220411930-15216-8-git-send-email-yi.zhu@intel.com>
References: <1220411930-15216-1-git-send-email-yi.zhu@intel.com>
 <1220411930-15216-2-git-send-email-yi.zhu@intel.com>
 <1220411930-15216-3-git-send-email-yi.zhu@intel.com>
 <1220411930-15216-4-git-send-email-yi.zhu@intel.com>
 <1220411930-15216-5-git-send-email-yi.zhu@intel.com>
 <1220411930-15216-6-git-send-email-yi.zhu@intel.com>
 <1220411930-15216-7-git-send-email-yi.zhu@intel.com>
 <1220411930-15216-8-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gregory Greenman <gregory.greenman@intel.com>

This patch calls apm stop on exit and suspend. Without this patch
hardware consumes power even after driver is removed or suspended.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 34928c8..4e3d6c7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2187,7 +2187,10 @@ static void __iwl4965_down(struct iwl_priv *priv)
 	udelay(5);
 
 	/* FIXME: apm_ops.suspend(priv) */
-	priv->cfg->ops->lib->apm_ops.reset(priv);
+	if (exit_pending || test_bit(STATUS_IN_SUSPEND, &priv->status))
+		priv->cfg->ops->lib->apm_ops.stop(priv);
+	else
+		priv->cfg->ops->lib->apm_ops.reset(priv);
 	priv->cfg->ops->lib->free_shared_mem(priv);
 
  exit:
-- 
1.5.3.6

