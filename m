Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51754 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbZD3UuR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2009 16:50:17 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 4/5] iwlwifi: replace test_and_set_bit by set_bit in clear stations function
Date: Thu, 30 Apr 2009 13:56:29 -0700
Message-Id: <1241124991-12492-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1241124991-12492-4-git-send-email-reinette.chatre@intel.com>
References: <1241124991-12492-1-git-send-email-reinette.chatre@intel.com>
 <1241124991-12492-2-git-send-email-reinette.chatre@intel.com>
 <1241124991-12492-3-git-send-email-reinette.chatre@intel.com>
 <1241124991-12492-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch replaces test_and_set_bit by set_bit since the bit is not
tested anyway

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-sta.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 17a4dd2..28dd225 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -490,7 +490,7 @@ void iwl_clear_stations_table(struct iwl_priv *priv)
 	/* keep track of static keys */
 	for (i = 0; i < WEP_KEYS_MAX ; i++) {
 		if (priv->wep_keys[i].key_size)
-			test_and_set_bit(i, &priv->ucode_key_table);
+			set_bit(i, &priv->ucode_key_table);
 	}
 
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
-- 
1.5.6.3

