Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:14081 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbZA1Rff (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 12:35:35 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH v2.6.29] iwlwifi: clean key table in iwl_clear_stations_table
Date: Wed, 28 Jan 2009 09:38:30 -0800
Message-Id: <1233164310-22770-1-git-send-email-reinette.chatre@intel.com> (sfid-20090128_183539_794013_573635C8)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleans uCode key table bit map iwl_clear_stations_table
since all stations are cleared also the key table must be.

Since the keys are not removed properly on suspend by mac80211
this may result in exhausting key table on resume leading
to memory corruption during removal

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
This change originally formed part of commit
40a9a8299116297429298e8fcee08235134883f7 "iwlwifi: clean key table in
iwl_clear_stations_table function". After that patch this function was
moved to iwl-sta.c with commit 565ddeb389362b42df69e26804903ecd2303bb8e.

This change was lost between 2.6.28 and 2.6.29-rc1, so adding it back here.

This will fix http://bugzilla.kernel.org/show_bug.cgi?id=12415

 drivers/net/wireless/iwlwifi/iwl-sta.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 7d2129c..1fae3a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -483,6 +483,9 @@ void iwl_clear_stations_table(struct iwl_priv *priv)
 	priv->num_stations = 0;
 	memset(priv->stations, 0, sizeof(priv->stations));
 
+	/* clean ucode key table bit map */
+	priv->ucode_key_table = 0;
+
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 }
 EXPORT_SYMBOL(iwl_clear_stations_table);
-- 
1.5.4.3

