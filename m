Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:26222 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757680AbXHHHyi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 03:54:38 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH] iwlwifi: fix gcc warning when CONFIG_IWLWIFI_DEBUG is not defined
Date: Wed,  8 Aug 2007 15:51:19 +0800
Message-Id: <11865594794161-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 origin/iwl-base.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/origin/iwl-base.c b/origin/iwl-base.c
index 15965fc..b8293fe 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -5107,9 +5107,12 @@ static void iwl_error_recovery(struct iwl_priv *priv)
 
 static void iwl_irq_tasklet(struct iwl_priv *priv)
 {
-	u32 inta, inta_mask, handled = 0;
+	u32 inta, handled = 0;
 	u32 inta_fh;
 	unsigned long flags;
+#ifdef CONFIG_IWLWIFI_DEBUG
+	u32 inta_mask;
+#endif
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-- 
1.5.2
