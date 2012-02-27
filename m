Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:45594 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755458Ab2B0XTF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 18:19:05 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/24] iwlwifi: use sparse compliant __aligned__ attribute
Date: Mon, 27 Feb 2012 14:07:32 -0800
Message-Id: <1330380468-17674-9-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120228_001912_209000_C188BAE6)
In-Reply-To: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Sparse prefers __aligned(sizeof(void *));

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-bus.h   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-bus.h b/drivers/net/wireless/iwlwifi/iwl-bus.h
index 30965e0..7d56cbc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-bus.h
+++ b/drivers/net/wireless/iwlwifi/iwl-bus.h
@@ -133,7 +133,7 @@ struct iwl_bus {
 
 	/* pointer to bus specific struct */
 	/*Ensure that this pointer will always be aligned to sizeof pointer */
-	char bus_specific[0] __attribute__((__aligned__(sizeof(void *))));
+	char bus_specific[0] __aligned(sizeof(void *));
 };
 
 /*****************************************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index cc7a3cf..f423286 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -347,7 +347,7 @@ struct iwl_trans {
 
 	/* pointer to trans specific struct */
 	/*Ensure that this pointer will always be aligned to sizeof pointer */
-	char trans_specific[0] __attribute__((__aligned__(sizeof(void *))));
+	char trans_specific[0] __aligned(sizeof(void *));
 };
 
 static inline int iwl_trans_start_hw(struct iwl_trans *trans)
-- 
1.7.0.4

