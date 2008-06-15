Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:17649 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbYFOUiG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jun 2008 16:38:06 -0400
Received: by ug-out-1314.google.com with SMTP id h2so298249ugf.16
        for <linux-wireless@vger.kernel.org>; Sun, 15 Jun 2008 13:38:04 -0700 (PDT)
Message-ID: <f6ca9fed0806151338l5d6968a9w5c3823577551ef93@mail.gmail.com> (sfid-20080615_223812_270584_95267794)
Date: Sun, 15 Jun 2008 22:38:04 +0200
From: drago01 <drago01@gmail.com>
To: "Linux Wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH] iwl4965: remove useless code
Cc: "Zhu Yi" <yi.zhu@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	"John Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
while reading throught the iwlwifi code I spotted this code which does nothing.

The attached patch removes it, when the function is turned into an non
nop it can be re added.

-----------
Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c
b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index f591168..2184a0b 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -3547,9 +3547,6 @@ static int iwl4965_mac_get_tx_stats(struct
ieee80211_hw *hw,
 static int iwl4965_mac_get_stats(struct ieee80211_hw *hw,
 			     struct ieee80211_low_level_stats *stats)
 {
-	struct iwl_priv *priv = hw->priv;
-
-	priv = hw->priv;
 	IWL_DEBUG_MAC80211("enter\n");
 	IWL_DEBUG_MAC80211("leave\n");

@@ -3558,9 +3555,6 @@ static int iwl4965_mac_get_stats(struct ieee80211_hw *hw,

 static u64 iwl4965_mac_get_tsf(struct ieee80211_hw *hw)
 {
-	struct iwl_priv *priv;
-
-	priv = hw->priv;
 	IWL_DEBUG_MAC80211("enter\n");
 	IWL_DEBUG_MAC80211("leave\n");
