Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:7077 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759AbZA0WZI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 17:25:08 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 6/7] iwlwifi: clean key table in iwl_clear_stations_table
Date: Tue, 27 Jan 2009 14:27:57 -0800
Message-Id: <1233095278-5850-7-git-send-email-reinette.chatre@intel.com> (sfid-20090127_232516_476846_16818325)
In-Reply-To: <1233095278-5850-6-git-send-email-reinette.chatre@intel.com>
References: <>
 <1233095278-5850-1-git-send-email-reinette.chatre@intel.com>
 <1233095278-5850-2-git-send-email-reinette.chatre@intel.com>
 <1233095278-5850-3-git-send-email-reinette.chatre@intel.com>
 <1233095278-5850-4-git-send-email-reinette.chatre@intel.com>
 <1233095278-5850-5-git-send-email-reinette.chatre@intel.com>
 <1233095278-5850-6-git-send-email-reinette.chatre@intel.com>
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

