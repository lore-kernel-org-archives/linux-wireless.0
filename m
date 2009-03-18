Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:57755 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571AbZCREq5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2009 00:46:57 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 13/13] iwl3945: replace stations with stations_39
Date: Tue, 17 Mar 2009 21:51:53 -0700
Message-Id: <1237351913-19202-14-git-send-email-reinette.chatre@intel.com> (sfid-20090318_054712_470163_8A841B48)
In-Reply-To: <1237351913-19202-13-git-send-email-reinette.chatre@intel.com>
References: <1237351913-19202-1-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-2-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-3-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-4-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-5-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-6-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-7-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-8-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-9-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-10-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-11-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-12-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-13-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

A *leftover* stations is replaced with stations_39.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index ab6a7d5..279d10c 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -485,14 +485,14 @@ static int iwl3945_set_ccmp_dynamic_key_info(struct iwl_priv *priv,
 	memcpy(priv->stations_39[sta_id].sta.key.key, keyconf->key,
 	       keyconf->keylen);
 
-	if ((priv->stations[sta_id].sta.key.key_flags & STA_KEY_FLG_ENCRYPT_MSK)
+	if ((priv->stations_39[sta_id].sta.key.key_flags & STA_KEY_FLG_ENCRYPT_MSK)
 			== STA_KEY_FLG_NO_ENC)
-		priv->stations[sta_id].sta.key.key_offset =
+		priv->stations_39[sta_id].sta.key.key_offset =
 				 iwl_get_free_ucode_key_index(priv);
 	/* else, we are overriding an existing key => no need to allocated room
 	* in uCode. */
 
-	WARN(priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET,
+	WARN(priv->stations_39[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET,
 		"no space for a new key");
 
 	priv->stations_39[sta_id].sta.key.key_flags = key_flags;
-- 
1.5.6.3

