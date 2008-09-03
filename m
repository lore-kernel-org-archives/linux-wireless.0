Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:43814 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754316AbYICDbO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:31:14 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 14/39] iwlwifi: replace readl and writel with io/read/write/32
Date: Wed,  3 Sep 2008 11:26:34 +0800
Message-Id: <1220412419-15404-15-git-send-email-yi.zhu@intel.com> (sfid-20080903_053122_323495_E5A07A70)
In-Reply-To: <1220412419-15404-14-git-send-email-yi.zhu@intel.com>
References: <1220412419-15404-1-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-2-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-3-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-4-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-5-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-6-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-7-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-8-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-9-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-10-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-11-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-12-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-13-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-14-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch replaces readl and writel with more cross platform ioread32
and iowrite32.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-io.h |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-io.h      |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-io.h b/drivers/net/wireless/iwlwifi/iwl-3945-io.h
index 0b94751..98740e8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-io.h
@@ -59,7 +59,7 @@
  *
  */
 
-#define _iwl3945_write32(priv, ofs, val) writel((val), (priv)->hw_base + (ofs))
+#define _iwl3945_write32(priv, ofs, val) iowrite32((val), (priv)->hw_base + (ofs))
 #ifdef CONFIG_IWL3945_DEBUG
 static inline void __iwl3945_write32(const char *f, u32 l, struct iwl3945_priv *priv,
 				 u32 ofs, u32 val)
@@ -73,14 +73,14 @@ static inline void __iwl3945_write32(const char *f, u32 l, struct iwl3945_priv *
 #define iwl3945_write32(priv, ofs, val) _iwl3945_write32(priv, ofs, val)
 #endif
 
-#define _iwl3945_read32(priv, ofs) readl((priv)->hw_base + (ofs))
+#define _iwl3945_read32(priv, ofs) ioread32((priv)->hw_base + (ofs))
 #ifdef CONFIG_IWL3945_DEBUG
 static inline u32 __iwl3945_read32(char *f, u32 l, struct iwl3945_priv *priv, u32 ofs)
 {
 	IWL_DEBUG_IO("read_direct32(0x%08X) - %s %d\n", ofs, f, l);
 	return _iwl3945_read32(priv, ofs);
 }
-#define iwl3945_read32(priv, ofs) __iwl3945_read32(__FILE__, __LINE__, priv, ofs)
+#define iwl3945_read32(priv, ofs)__iwl3945_read32(__FILE__, __LINE__, priv, ofs)
 #else
 #define iwl3945_read32(p, o) _iwl3945_read32(p, o)
 #endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index 5bc3df4..17fb4e2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -61,7 +61,7 @@
  *
  */
 
-#define _iwl_write32(priv, ofs, val) writel((val), (priv)->hw_base + (ofs))
+#define _iwl_write32(priv, ofs, val) iowrite32((val), (priv)->hw_base + (ofs))
 #ifdef CONFIG_IWLWIFI_DEBUG
 static inline void __iwl_write32(const char *f, u32 l, struct iwl_priv *priv,
 				 u32 ofs, u32 val)
@@ -75,7 +75,7 @@ static inline void __iwl_write32(const char *f, u32 l, struct iwl_priv *priv,
 #define iwl_write32(priv, ofs, val) _iwl_write32(priv, ofs, val)
 #endif
 
-#define _iwl_read32(priv, ofs) readl((priv)->hw_base + (ofs))
+#define _iwl_read32(priv, ofs) ioread32((priv)->hw_base + (ofs))
 #ifdef CONFIG_IWLWIFI_DEBUG
 static inline u32 __iwl_read32(char *f, u32 l, struct iwl_priv *priv, u32 ofs)
 {
-- 
1.5.3.6

