Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:38065 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386Ab1DEQOM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 12:14:12 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH wireless-2.6] iwlagn: override 5300 EEPROM # of chains
Date: Tue,  5 Apr 2011 08:55:05 -0700
Message-Id: <1302018905-19518-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

At least EEPROM version 0x11A has the wrong
number of chains programmed into it for some
reason, so we need to override in the driver.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
these patches are also available from wireless-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-5000.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 3ea31b6..22e045b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -530,6 +530,9 @@ static struct iwl_ht_params iwl5000_ht_params = {
 struct iwl_cfg iwl5300_agn_cfg = {
 	.name = "Intel(R) Ultimate N WiFi Link 5300 AGN",
 	IWL_DEVICE_5000,
+	/* at least EEPROM 0x11A has wrong info */
+	.valid_tx_ant = ANT_ABC,	/* .cfg overwrite */
+	.valid_rx_ant = ANT_ABC,	/* .cfg overwrite */
 	.ht_params = &iwl5000_ht_params,
 };
 
-- 
1.7.0.4

