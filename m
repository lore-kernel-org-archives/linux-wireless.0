Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:43661 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004AbZASX2U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 18:28:20 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Jay Sternberg <jay.e.sternberg@linux.intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 13/15] iwlwifi: remove static from 5000 structures
Date: Mon, 19 Jan 2009 15:30:33 -0800
Message-Id: <1232407835-19451-14-git-send-email-reinette.chatre@intel.com> (sfid-20090120_003051_105389_DD9B5E50)
In-Reply-To: <1232407835-19451-13-git-send-email-reinette.chatre@intel.com>
References: <>
 <1232407835-19451-1-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-2-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-3-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-4-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-5-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-6-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-7-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-8-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-9-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-10-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-11-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-12-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-13-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jay Sternberg <jay.e.sternberg@linux.intel.com>

remove static from config structures which will be used by new
hardware that is similar to 5000.  This way the new devices
can use them without the new structures having to be stored in the
already overloaded iwl-5000.c file.

Signed-off-by: Jay Sternberg <jay.e.sternberg@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    4 ++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index a35af67..04c2585 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1528,13 +1528,13 @@ static struct iwl_lib_ops iwl5000_lib = {
 	},
 };
 
-static struct iwl_ops iwl5000_ops = {
+struct iwl_ops iwl5000_ops = {
 	.lib = &iwl5000_lib,
 	.hcmd = &iwl5000_hcmd,
 	.utils = &iwl5000_hcmd_utils,
 };
 
-static struct iwl_mod_params iwl50_mod_params = {
+struct iwl_mod_params iwl50_mod_params = {
 	.num_of_queues = IWL50_NUM_QUEUES,
 	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
 	.amsdu_size_8K = 1,
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 9dc6e3c..2602944 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -58,6 +58,10 @@ extern struct iwl_cfg iwl5100_bg_cfg;
 extern struct iwl_cfg iwl5100_abg_cfg;
 extern struct iwl_cfg iwl5150_agn_cfg;
 
+/* shared structures from iwl-5000.c */
+extern struct iwl_mod_params iwl50_mod_params;
+extern struct iwl_ops iwl5000_ops;
+
 /* CT-KILL constants */
 #define CT_KILL_THRESHOLD	110 /* in Celsius */
 
-- 
1.5.4.3

