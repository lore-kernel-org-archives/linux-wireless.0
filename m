Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:41005 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926AbYDOXCK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 19:02:10 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 08/11] iwlwifi: Fix TKIP update key and get_free_ucode_key
Date: Tue, 15 Apr 2008 16:01:44 -0700
Message-Id: <1208300507-25628-9-git-send-email-reinette.chatre@intel.com> (sfid-20080416_000235_000613_2EA2EBF4)
In-Reply-To: <1208300507-25628-8-git-send-email-reinette.chatre@intel.com>
References: <1208300507-25628-1-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-2-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-3-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-4-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-5-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-6-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-7-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-8-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch fixes a bug in update_tkip_key: only one key needs to be
allocated in uCode, every time it is updated, the old one will be
overwritten

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-sta.c      |    4 +++-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 --
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 0ccd156..e4fdfaa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -43,7 +43,7 @@ int iwl_get_free_ucode_key_index(struct iwl_priv *priv)
 	int i;
 
 	for (i = 0; i < STA_KEY_MAX_NUM; i++)
-		if (test_and_set_bit(i, &priv->ucode_key_table))
+		if (!test_and_set_bit(i, &priv->ucode_key_table))
 			return i;
 
 	return -1;
@@ -243,6 +243,8 @@ static int iwl_set_tkip_dynamic_key_info(struct iwl_priv *priv,
 	priv->stations[sta_id].keyinfo.alg = keyconf->alg;
 	priv->stations[sta_id].keyinfo.conf = keyconf;
 	priv->stations[sta_id].keyinfo.keylen = 16;
+	priv->stations[sta_id].sta.key.key_offset =
+				 iwl_get_free_ucode_key_index(priv);
 
 	/* This copy is acutally not needed: we get the key with each TX */
 	memcpy(priv->stations[sta_id].keyinfo.key, keyconf->key, 16);
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 745b462..0eb4220 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -6810,8 +6810,6 @@ static void iwl4965_mac_update_tkip_key(struct ieee80211_hw *hw,
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
 
-	priv->stations[sta_id].sta.key.key_offset =
-				iwl_get_free_ucode_key_index(priv);
 	priv->stations[sta_id].sta.key.key_flags = key_flags;
 	priv->stations[sta_id].sta.key.tkip_rx_tsc_byte2 = (u8) iv32;
 
-- 
1.5.3.4

