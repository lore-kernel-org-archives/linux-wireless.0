Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:4746 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756256AbYGABXb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 21:23:31 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Rick Farrington <rickdic@hotmail.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH-2.6.26 1/2] iwlwifi: fix incorrect 5GHz rates reported in monitor mode
Date: Tue,  1 Jul 2008 09:20:33 +0800
Message-Id: <1214875234-23567-2-git-send-email-yi.zhu@intel.com> (sfid-20080701_032337_246831_3006E9AD)
In-Reply-To: <1214875234-23567-1-git-send-email-yi.zhu@intel.com>
References: <1214875234-23567-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rick Farrington <rickdic@hotmail.com>

This patch fixes the rates reported in monitor mode operation
(Wireshark) for iwlwifi.

Previously, packets with rates of 6M..24M would be reported
incorrectly and packets with rates of 36M..54M would not passed
up the stack.

Signed-off-by: Rick Farrington <rickdic@hotmail.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c |    6 +++++-
 drivers/net/wireless/iwlwifi/iwl-4965.c |    6 +++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 62a3d8f..f5387a7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -588,8 +588,12 @@ static void iwl3945_add_radiotap(struct iwl3945_priv *priv,
 
 	if (rate == -1)
 		iwl3945_rt->rt_rate = 0;
-	else
+	else {
+		if (stats->band == IEEE80211_BAND_5GHZ)
+			rate += IWL_FIRST_OFDM_RATE;
+
 		iwl3945_rt->rt_rate = iwl3945_rates[rate].ieee;
+	}
 
 	/* antenna number */
 	antenna = phy_flags_hw & RX_RES_PHY_FLAGS_ANTENNA_MSK;
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index bf19eb8..de330ae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -3528,8 +3528,12 @@ static void iwl4965_add_radiotap(struct iwl_priv *priv,
 
 	if (rate == -1)
 		iwl4965_rt->rt_rate = 0;
-	else
+	else {
+		if (stats->band == IEEE80211_BAND_5GHZ)
+			rate += IWL_FIRST_OFDM_RATE;
+
 		iwl4965_rt->rt_rate = iwl4965_rates[rate].ieee;
+	}
 
 	/*
 	 * "antenna number"
-- 
1.5.3.6

