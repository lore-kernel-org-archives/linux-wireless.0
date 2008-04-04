Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:62561 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbYDDVcE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2008 17:32:04 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2.6.25] iwlwifi: fix n-band association problem
Date: Fri,  4 Apr 2008 14:32:01 -0700
Message-Id: <1207344721-21977-1-git-send-email-reinette.chatre@intel.com> (sfid-20080404_223211_168314_FFC9AB21)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

This patch enables the IWL4965_HT flag (n-band) in Kconfig.
Removed the "depends on n" from Kconfig for config IWL4965_HT

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
John,

This patch applies to 2.6.25-rc8 and enables users to use N band.
This fixes the current "unable to associate to N band in 2.6.25
problems".

Could you please push it up to 2.6.25?

Thanks


 drivers/net/wireless/iwlwifi/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index b79a35a..b54ff71 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -35,7 +35,6 @@ config IWL4965_HT
 	bool "Enable 802.11n HT features in iwl4965 driver"
 	depends on EXPERIMENTAL
 	depends on IWL4965 && IWL4965_QOS
-	depends on n
 	---help---
 	  This option enables IEEE 802.11n High Throughput features
 	  for the iwl4965 driver.
-- 
1.5.3.4

