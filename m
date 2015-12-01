Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:23426 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755755AbbLAJ7O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 04:59:14 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/41] iwlwifi: trans: make various conversion macros inlines
Date: Tue,  1 Dec 2015 11:58:30 +0200
Message-Id: <1448963947-24302-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151201_110405_096650_1DC9EF8B)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Make the various conversion functions typesafe, so we don't
accidentally try to call them with the wrong pointers and
cast them to something that will crash.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index bf8cb59..bf41543 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -378,8 +378,11 @@ struct iwl_trans_pcie {
 	u32 fw_mon_size;
 };
 
-#define IWL_TRANS_GET_PCIE_TRANS(_iwl_trans) \
-	((struct iwl_trans_pcie *) ((_iwl_trans)->trans_specific))
+static inline struct iwl_trans_pcie *
+IWL_TRANS_GET_PCIE_TRANS(struct iwl_trans *trans)
+{
+	return (void *)trans->trans_specific;
+}
 
 static inline struct iwl_trans *
 iwl_trans_pcie_get_trans(struct iwl_trans_pcie *trans_pcie)
-- 
2.5.0

