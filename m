Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:20115 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150AbZCKSNC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2009 14:13:02 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 7/8] iwlwifi: print contents of control register when error occurs
Date: Wed, 11 Mar 2009 11:18:00 -0700
Message-Id: <1236795481-12757-8-git-send-email-reinette.chatre@intel.com> (sfid-20090311_191315_409158_E5972914)
In-Reply-To: <1236795481-12757-7-git-send-email-reinette.chatre@intel.com>
References: <1236795481-12757-1-git-send-email-reinette.chatre@intel.com>
 <1236795481-12757-2-git-send-email-reinette.chatre@intel.com>
 <1236795481-12757-3-git-send-email-reinette.chatre@intel.com>
 <1236795481-12757-4-git-send-email-reinette.chatre@intel.com>
 <1236795481-12757-5-git-send-email-reinette.chatre@intel.com>
 <1236795481-12757-6-git-send-email-reinette.chatre@intel.com>
 <1236795481-12757-7-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

hopefully the register contents will guide us to why this failure occured

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-io.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index c7b8e5b..083ea1f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -156,6 +156,7 @@ static inline void __iwl_clear_bit(const char *f, u32 l,
 static inline int _iwl_grab_nic_access(struct iwl_priv *priv)
 {
 	int ret;
+	u32 val;
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (atomic_read(&priv->restrict_refcnt))
 		return 0;
@@ -167,7 +168,8 @@ static inline int _iwl_grab_nic_access(struct iwl_priv *priv)
 			   (CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY |
 			    CSR_GP_CNTRL_REG_FLAG_GOING_TO_SLEEP), 15000);
 	if (ret < 0) {
-		IWL_ERR(priv, "MAC is in deep sleep!\n");
+		val = _iwl_read32(priv, CSR_GP_CNTRL);
+		IWL_ERR(priv, "MAC is in deep sleep!.  CSR_GP_CNTRL = 0x%08X\n", val);
 		return -EIO;
 	}
 
-- 
1.5.6.3

