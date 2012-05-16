Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54103 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966157Ab2EPUgG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 16:36:06 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Subject: [PATCH 3/3] iwlwifi: do not use shadow registers by default
Date: Wed, 16 May 2012 22:35:59 +0200
Message-Id: <1337200559-11133-4-git-send-email-johannes@sipsolutions.net> (sfid-20120516_223611_536912_BCE471FC)
In-Reply-To: <1337200559-11133-1-git-send-email-johannes@sipsolutions.net>
References: <1337200559-11133-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

Shadow registers in the device are meant to
allow the driver to update certain device
registers without needing to wake up all
components of the device. However, using
this feature in the device causes
communication between the driver and the
device to become unreliable, resulting in
host command timeouts.

Disable this feature by default till a fix is
available for the bug.

Cc: stable@vger.kernel.org #2.6.38+
Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-2000.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-6000.c |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 7f79341..8133105 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -79,7 +79,7 @@ static const struct iwl_base_params iwl2000_base_params = {
 	.chain_noise_scale = 1000,
 	.wd_timeout = IWL_DEF_WD_TIMEOUT,
 	.max_event_log_size = 512,
-	.shadow_reg_enable = true,
+	.shadow_reg_enable = false, /* TODO: fix bugs using this feature */
 	.hd_v2 = true,
 };
 
@@ -97,7 +97,7 @@ static const struct iwl_base_params iwl2030_base_params = {
 	.chain_noise_scale = 1000,
 	.wd_timeout = IWL_LONG_WD_TIMEOUT,
 	.max_event_log_size = 512,
-	.shadow_reg_enable = true,
+	.shadow_reg_enable = false, /* TODO: fix bugs using this feature */
 	.hd_v2 = true,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 381b02c..19f7ee8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -86,7 +86,7 @@ static const struct iwl_base_params iwl6000_base_params = {
 	.chain_noise_scale = 1000,
 	.wd_timeout = IWL_DEF_WD_TIMEOUT,
 	.max_event_log_size = 512,
-	.shadow_reg_enable = true,
+	.shadow_reg_enable = false, /* TODO: fix bugs using this feature */
 };
 
 static const struct iwl_base_params iwl6050_base_params = {
@@ -102,7 +102,7 @@ static const struct iwl_base_params iwl6050_base_params = {
 	.chain_noise_scale = 1500,
 	.wd_timeout = IWL_DEF_WD_TIMEOUT,
 	.max_event_log_size = 1024,
-	.shadow_reg_enable = true,
+	.shadow_reg_enable = false, /* TODO: fix bugs using this feature */
 };
 
 static const struct iwl_base_params iwl6000_g2_base_params = {
@@ -118,7 +118,7 @@ static const struct iwl_base_params iwl6000_g2_base_params = {
 	.chain_noise_scale = 1000,
 	.wd_timeout = IWL_LONG_WD_TIMEOUT,
 	.max_event_log_size = 512,
-	.shadow_reg_enable = true,
+	.shadow_reg_enable = false, /* TODO: fix bugs using this feature */
 };
 
 static const struct iwl_ht_params iwl6000_ht_params = {
-- 
1.7.10

