Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51290 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757431AbYDXSzo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2008 14:55:44 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 09/21] iwlwifi-5000: use iwl4965_set_pwr_src in 5000
Date: Thu, 24 Apr 2008 11:55:26 -0700
Message-Id: <1209063338-6572-10-git-send-email-reinette.chatre@intel.com> (sfid-20080424_205620_686430_2C788915)
In-Reply-To: <1209063338-6572-9-git-send-email-reinette.chatre@intel.com>
References: <1209063338-6572-1-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-2-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-3-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-4-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-5-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-6-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-7-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-8-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-9-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch makes use of iwl4965_set_pwr_src in 5000 HW family

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 32c591c..58a35cb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -95,6 +95,7 @@ static struct iwl_hcmd_utils_ops iwl5000_hcmd_utils = {
 static struct iwl_lib_ops iwl5000_lib = {
 	.apm_ops = {
 		.init =	iwl5000_apm_init,
+		.set_pwr_src = iwl4965_set_pwr_src,
 	},
 	.eeprom_ops = {
 		.verify_signature  = iwlcore_eeprom_verify_signature,
-- 
1.5.3.4

