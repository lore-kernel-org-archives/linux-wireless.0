Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:49478 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050AbZCKSNB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2009 14:13:01 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 6/8] iwlagn: fix warning when set WEP key
Date: Wed, 11 Mar 2009 11:17:59 -0700
Message-Id: <1236795481-12757-7-git-send-email-reinette.chatre@intel.com> (sfid-20090311_191317_075475_4C41E926)
In-Reply-To: <1236795481-12757-6-git-send-email-reinette.chatre@intel.com>
References: <1236795481-12757-1-git-send-email-reinette.chatre@intel.com>
 <1236795481-12757-2-git-send-email-reinette.chatre@intel.com>
 <1236795481-12757-3-git-send-email-reinette.chatre@intel.com>
 <1236795481-12757-4-git-send-email-reinette.chatre@intel.com>
 <1236795481-12757-5-git-send-email-reinette.chatre@intel.com>
 <1236795481-12757-6-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mohamed.abbas@intel.com>

iwl_clear_station_table will be called every time rxon called.
In this function ucode_key_table is set to 0 even though a static
WEP security is set. This will cause in many warning and might be
an issue if dynamic WEP is set. This patch make sure we keep track
of all existing static WEP when this function is called.

Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-sta.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 0ea08d0..1684490 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -472,6 +472,7 @@ EXPORT_SYMBOL(iwl_remove_station);
 void iwl_clear_stations_table(struct iwl_priv *priv)
 {
 	unsigned long flags;
+	int i;
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
 
@@ -486,6 +487,12 @@ void iwl_clear_stations_table(struct iwl_priv *priv)
 	/* clean ucode key table bit map */
 	priv->ucode_key_table = 0;
 
+	/* keep track of static keys */
+	for (i = 0; i < WEP_KEYS_MAX ; i++) {
+		if (priv->wep_keys[i].key_size)
+			test_and_set_bit(i, &priv->ucode_key_table);
+	}
+
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 }
 EXPORT_SYMBOL(iwl_clear_stations_table);
-- 
1.5.6.3

