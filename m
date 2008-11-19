Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:64646 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201AbYKSXb5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 18:31:57 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, Zhu Yi <yi.zhu@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 7/7] iwlwifi: prevent double key removal
Date: Wed, 19 Nov 2008 15:32:28 -0800
Message-Id: <1227137548-28718-8-git-send-email-reinette.chatre@intel.com> (sfid-20081120_003216_235323_380F5650)
In-Reply-To: <1227137548-28718-7-git-send-email-reinette.chatre@intel.com>
References: <>
 <1227137548-28718-1-git-send-email-reinette.chatre@intel.com>
 <1227137548-28718-2-git-send-email-reinette.chatre@intel.com>
 <1227137548-28718-3-git-send-email-reinette.chatre@intel.com>
 <1227137548-28718-4-git-send-email-reinette.chatre@intel.com>
 <1227137548-28718-5-git-send-email-reinette.chatre@intel.com>
 <1227137548-28718-6-git-send-email-reinette.chatre@intel.com>
 <1227137548-28718-7-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>

Do not remove the same key twice.

This patch also fixes a memory corruption problem reported in
http://marc.info/?l=linux-wireless&m=122641417231586&w=2 and tracked in
http://bugzilla.kernel.org/show_bug.cgi?id=12040.

When the key is removed a second time the offset is set to 255 - this index
is not valid for the ucode_key_table and corrupts the eeprom pointer (which
is 255 bits from ucode_key_table).

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Tested-by: Carlos R. Mafra <crmafra2@gmail.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
John, Could you please push this patch up to 2.6.28 also?

 drivers/net/wireless/iwlwifi/iwl-sta.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 0222ef8..27f7108 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -809,6 +809,12 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
 		return 0;
 	}
 
+	if (WARN(priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET,
+		 "Removing wrong key %d 0x%x\n", keyconf->keyidx, key_flags)) {
+		spin_unlock_irqrestore(&priv->sta_lock, flags);
+		return 0;
+	}
+
 	if (!test_and_clear_bit(priv->stations[sta_id].sta.key.key_offset,
 		&priv->ucode_key_table))
 		IWL_ERROR("index %d not used in uCode key table.\n",
-- 
1.5.4.3

