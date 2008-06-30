Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:19551 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759568AbYF3J1P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 05:27:15 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Rick Farrington <rickdic@hotmail.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 27/33] iwlwifi: fix incorrect 5GHz rates reported in monitor mode
Date: Mon, 30 Jun 2008 17:23:27 +0800
Message-Id: <1214817813-17639-28-git-send-email-yi.zhu@intel.com> (sfid-20080630_113812_531761_CDD4422F)
In-Reply-To: <1214817813-17639-27-git-send-email-yi.zhu@intel.com>
References: <1214817813-17639-1-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-2-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-3-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-4-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-5-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-6-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-7-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-8-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-9-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-10-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-11-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-12-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-13-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-14-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-15-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-16-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-17-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-18-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-19-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-20-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-21-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-22-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-23-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-24-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-25-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-26-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-27-git-send-email-yi.zhu@intel.com>
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
 drivers/net/wireless/iwlwifi/iwl-rx.c   |    6 +++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 63f2037..38866ab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -590,8 +590,12 @@ static void iwl3945_add_radiotap(struct iwl3945_priv *priv,
 
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
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 0c734fd..1adb1aa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -860,8 +860,12 @@ static void iwl_add_radiotap(struct iwl_priv *priv,
 
 	if (rate == -1)
 		iwl4965_rt->rt_rate = 0;
-	else
+	else {
+		if (stats->band == IEEE80211_BAND_5GHZ)
+			rate += IWL_FIRST_OFDM_RATE;
+
 		iwl4965_rt->rt_rate = iwl_rates[rate].ieee;
+	}
 
 	/*
 	 * "antenna number"
-- 
1.5.3.6

