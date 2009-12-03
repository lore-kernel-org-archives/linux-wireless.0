Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:12472 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755927AbZLCKjh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2009 05:39:37 -0500
From: Samuel Ortiz <sameo@linux.intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 4/4] iwmc3200wifi: Enable wimax core through module parameter
Date: Thu,  3 Dec 2009 11:40:18 +0100
Message-Id: <5254f26fc43d0932cb2b27c0fbccda53e3093ced.1259835655.git.sameo@linux.intel.com>
In-Reply-To: <f623da29d10f87111c698e7d9750ae39cd98bb09.1259835655.git.sameo@linux.intel.com>
References: <cover.1259835655.git.sameo@linux.intel.com>
 <4790a128344a09f0bdb2249c8ee831f254ca72ec.1259835655.git.sameo@linux.intel.com>
 <3259e3798cc114c1d6da7e764ce9da739b4e88b4.1259835655.git.sameo@linux.intel.com>
 <f623da29d10f87111c698e7d9750ae39cd98bb09.1259835655.git.sameo@linux.intel.com>
In-Reply-To: <cover.1259835655.git.sameo@linux.intel.com>
References: <cover.1259835655.git.sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When debugging the wifi firmware, we need to disable the wimax core to gain
some memory space. The default value will keep the wimax core enabled.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/net/wireless/iwmc3200wifi/main.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/main.c b/drivers/net/wireless/iwmc3200wifi/main.c
index 0ffb041..7f34d6d 100644
--- a/drivers/net/wireless/iwmc3200wifi/main.c
+++ b/drivers/net/wireless/iwmc3200wifi/main.c
@@ -68,7 +68,6 @@ static struct iwm_conf def_iwm_conf = {
 	.ct_kill_exit		= 110,
 	.reset_on_fatal_err	= 1,
 	.auto_connect		= 1,
-	.wimax_not_present	= 0,
 	.enable_qos		= 1,
 	.mode			= UMAC_MODE_BSS,
 
@@ -94,6 +93,10 @@ static int modparam_reset;
 module_param_named(reset, modparam_reset, bool, 0644);
 MODULE_PARM_DESC(reset, "reset on firmware errors (default 0 [not reset])");
 
+static int modparam_wimax_enable = 1;
+module_param_named(wimax_enable, modparam_wimax_enable, bool, 0644);
+MODULE_PARM_DESC(wimax_enable, "Enable wimax core (default 1 [wimax enabled])");
+
 int iwm_mode_to_nl80211_iftype(int mode)
 {
 	switch (mode) {
@@ -486,7 +489,7 @@ static int iwm_config_boot_params(struct iwm_priv *iwm)
 	int ret;
 
 	/* check Wimax is off and config debug monitor */
-	if (iwm->conf.wimax_not_present) {
+	if (!modparam_wimax_enable) {
 		u32 data1 = 0x1f;
 		u32 addr1 = 0x606BE258;
 
-- 
1.6.3.3

