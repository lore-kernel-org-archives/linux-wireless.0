Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47846 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbZEHIxa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2009 04:53:30 -0400
Subject: [PATCH] iwlwifi: make iwl_set_rate static
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: reinette chatre <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 08 May 2009 10:53:24 +0200
Message-Id: <1241772804.1567.29.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's not needed elsewhere.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.h |    2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-core.h	2009-05-08 10:52:20.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-core.h	2009-05-08 10:52:24.000000000 +0200
@@ -363,8 +363,6 @@ int iwl_hwrate_to_plcp_idx(u32 rate_n_fl
 
 u8 iwl_rate_get_lowest_plcp(struct iwl_priv *priv);
 
-void iwl_set_rate(struct iwl_priv *priv);
-
 u8 iwl_toggle_tx_ant(struct iwl_priv *priv, u8 ant_idx);
 
 static inline u32 iwl_ant_idx_to_flags(u8 ant_idx)
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-core.c	2009-05-08 10:52:20.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-core.c	2009-05-08 10:52:24.000000000 +0200
@@ -1124,7 +1124,7 @@ void iwl_connection_init_rx_config(struc
 }
 EXPORT_SYMBOL(iwl_connection_init_rx_config);
 
-void iwl_set_rate(struct iwl_priv *priv)
+static void iwl_set_rate(struct iwl_priv *priv)
 {
 	const struct ieee80211_supported_band *hw = NULL;
 	struct ieee80211_rate *rate;


