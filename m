Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:26932 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932390AbZHMUbP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 16:31:15 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Daniel C Halperin <daniel.c.halperin@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 02/13] iwlwifi: remove unused HT configuration entry tx_chan_width
Date: Thu, 13 Aug 2009 13:30:51 -0700
Message-Id: <1250195462-15811-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1250195462-15811-1-git-send-email-reinette.chatre@intel.com>
References: <1250195462-15811-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel C Halperin <daniel.c.halperin@intel.com>

The tx_chan_width entry is never used, supported_chan_width is used instead.

Signed-off-by: Daniel C Halperin <daniel.c.halperin@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    1 -
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index af73512..479b7e1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2423,7 +2423,6 @@ static void iwl_ht_conf(struct iwl_priv *priv,
 
 	memcpy(&iwl_conf->mcs, &ht_conf->mcs, 16);
 
-	iwl_conf->tx_chan_width = iwl_conf->supported_chan_width != 0;
 	iwl_conf->ht_protection =
 		bss_conf->ht_operation_mode & IEEE80211_HT_OP_MODE_PROTECTION;
 	iwl_conf->non_GF_STA_present =
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index b96c3c9..c34f9d7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -515,7 +515,6 @@ struct iwl_ht_info {
 	struct ieee80211_mcs_info mcs;
 	/* BSS related data */
 	u8 extension_chan_offset;
-	u8 tx_chan_width;
 	u8 ht_protection;
 	u8 non_GF_STA_present;
 };
-- 
1.5.6.3

