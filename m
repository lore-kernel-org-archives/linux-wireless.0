Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:20115 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770AbZCKSNA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2009 14:13:00 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/8] iwl3945: fix sparse error
Date: Wed, 11 Mar 2009 11:17:54 -0700
Message-Id: <1236795481-12757-2-git-send-email-reinette.chatre@intel.com> (sfid-20090311_191315_001396_7529E9CD)
In-Reply-To: <1236795481-12757-1-git-send-email-reinette.chatre@intel.com>
References: <1236795481-12757-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

error is:
iwl3945-base.c:545:5: warning: symbol 'iwl3945_set_dynamic_key' was not
declared. Should it be static?

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index e5c6295..7ce32c9 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -542,7 +542,7 @@ static int iwl3945_clear_sta_key_info(struct iwl_priv *priv, u8 sta_id)
 	return 0;
 }
 
-int iwl3945_set_dynamic_key(struct iwl_priv *priv,
+static int iwl3945_set_dynamic_key(struct iwl_priv *priv,
 			struct ieee80211_key_conf *keyconf, u8 sta_id)
 {
 	int ret = 0;
-- 
1.5.6.3

