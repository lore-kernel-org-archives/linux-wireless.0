Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:43088 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845AbZFZRxr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jun 2009 13:53:47 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/3] iwlwifi: add utility to print buffer when error occurs
Date: Fri, 26 Jun 2009 11:00:54 -0700
Message-Id: <1246039255-2195-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1246039255-2195-2-git-send-email-reinette.chatre@intel.com>
References: <1246039255-2195-1-git-send-email-reinette.chatre@intel.com>
 <1246039255-2195-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debug.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 2cf014f..65bbce0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -36,6 +36,12 @@ struct iwl_priv;
 #define IWL_INFO(p, f, a...) dev_info(&((p)->pci_dev->dev), f, ## a)
 #define IWL_CRIT(p, f, a...) dev_crit(&((p)->pci_dev->dev), f, ## a)
 
+#define iwl_print_hex_error(priv, p, len) 				\
+do {									\
+	print_hex_dump(KERN_ERR, "iwl data: ",				\
+		       DUMP_PREFIX_OFFSET, 16, 1, p, len, 1);		\
+} while (0)
+
 #ifdef CONFIG_IWLWIFI_DEBUG
 #define IWL_DEBUG(__priv, level, fmt, args...)				\
 do {									\
-- 
1.5.6.3

