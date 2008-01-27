Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56463 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069AbYA0NIR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jan 2008 08:08:17 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] iwlwifi: enable 802.11n in Kconfig
Date: Sun, 27 Jan 2008 15:06:23 +0200
Message-Id: <12014391833639-git-send-email-tomas.winkler@intel.com> (sfid-20080127_130822_715208_9C6F4467)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes 'IWL4965_HT: depends on n'  from iwlwifi's Kconfig
1. 11n is functional so no need to make it invisible in the configuration
2. Latest Johannes patch 'cfg80211 API for channels/bitrates, mac80211 and
driver conversion' broke compilation because this config option was
invisible - patch fixing it will be provided later

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index d1af938..9c3fe18 100644
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
1.5.2.2

