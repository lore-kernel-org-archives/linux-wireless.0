Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:19305 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbYIKDtj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 23:49:39 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 3/3] iwl3945: add MODULE_FIRMWARE for 3945 HW
Date: Thu, 11 Sep 2008 11:45:22 +0800
Message-Id: <1221104722-8771-4-git-send-email-yi.zhu@intel.com> (sfid-20080911_054942_469181_6DE4EFF0)
In-Reply-To: <1221104722-8771-3-git-send-email-yi.zhu@intel.com>
References: <1221104722-8771-1-git-send-email-yi.zhu@intel.com>
 <1221104722-8771-2-git-send-email-yi.zhu@intel.com>
 <1221104722-8771-3-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds MODULE_FIRMWARE statement for 3945 HW.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index cbbe73a..1834fa8 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -8376,6 +8376,8 @@ static void __exit iwl3945_exit(void)
 	iwl3945_rate_control_unregister();
 }
 
+MODULE_FIRMWARE("iwlwifi-3945" IWL3945_UCODE_API ".ucode");
+
 module_param_named(antenna, iwl3945_param_antenna, int, 0444);
 MODULE_PARM_DESC(antenna, "select antenna (1=Main, 2=Aux, default 0 [both])");
 module_param_named(disable, iwl3945_param_disable, int, 0444);
-- 
1.5.3.6

