Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38651 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756381AbYBMTfH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2008 14:35:07 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Ester Kummer <ester.kummer@intel.com>
Subject: [PATCH 2/3] iwlwifi: change iwl->priv iwl_priv * type in iwl-YYY-io.h
Date: Wed, 13 Feb 2008 11:32:30 -0800
Message-Id: <1202931151-4141-3-git-send-email-reinette.chatre@intel.com> (sfid-20080213_193517_842755_CE4CC2E6)
In-Reply-To: <1202931151-4141-2-git-send-email-reinette.chatre@intel.com>
References: <1202931151-4141-1-git-send-email-reinette.chatre@intel.com>
 <1202931151-4141-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch makes all variables of type struct iwl_priv to be named priv
This is needed for smooth change of debug printing mechanism

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Ester Kummer <ester.kummer@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-io.h |   39 ++++++++++++---------------
 drivers/net/wireless/iwlwifi/iwl-4965-io.h |   39 ++++++++++++---------------
 2 files changed, 34 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-io.h b/drivers/net/wireless/iwlwifi/iwl-3945-io.h
index 75e20d0..4a18729 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-io.h
@@ -59,28 +59,28 @@
  *
  */
 
-#define _iwl3945_write32(iwl, ofs, val) writel((val), (iwl)->hw_base + (ofs))
+#define _iwl3945_write32(priv, ofs, val) writel((val), (priv)->hw_base + (ofs))
 #ifdef CONFIG_IWL3945_DEBUG
-static inline void __iwl3945_write32(const char *f, u32 l, struct iwl3945_priv *iwl,
+static inline void __iwl3945_write32(const char *f, u32 l, struct iwl3945_priv *priv,
 				 u32 ofs, u32 val)
 {
 	IWL_DEBUG_IO("write32(0x%08X, 0x%08X) - %s %d\n", ofs, val, f, l);
-	_iwl3945_write32(iwl, ofs, val);
+	_iwl3945_write32(priv, ofs, val);
 }
-#define iwl3945_write32(iwl, ofs, val) \
-	__iwl3945_write32(__FILE__, __LINE__, iwl, ofs, val)
+#define iwl3945_write32(priv, ofs, val) \
+	__iwl3945_write32(__FILE__, __LINE__, priv, ofs, val)
 #else
-#define iwl3945_write32(iwl, ofs, val) _iwl3945_write32(iwl, ofs, val)
+#define iwl3945_write32(priv, ofs, val) _iwl3945_write32(priv, ofs, val)
 #endif
 
-#define _iwl3945_read32(iwl, ofs) readl((iwl)->hw_base + (ofs))
+#define _iwl3945_read32(priv, ofs) readl((priv)->hw_base + (ofs))
 #ifdef CONFIG_IWL3945_DEBUG
-static inline u32 __iwl3945_read32(char *f, u32 l, struct iwl3945_priv *iwl, u32 ofs)
+static inline u32 __iwl3945_read32(char *f, u32 l, struct iwl3945_priv *priv, u32 ofs)
 {
 	IWL_DEBUG_IO("read_direct32(0x%08X) - %s %d\n", ofs, f, l);
-	return _iwl3945_read32(iwl, ofs);
+	return _iwl3945_read32(priv, ofs);
 }
-#define iwl3945_read32(iwl, ofs) __iwl3945_read32(__FILE__, __LINE__, iwl, ofs)
+#define iwl3945_read32(priv, ofs) __iwl3945_read32(__FILE__, __LINE__, priv, ofs)
 #else
 #define iwl3945_read32(p, o) _iwl3945_read32(p, o)
 #endif
@@ -105,18 +105,13 @@ static inline int __iwl3945_poll_bit(const char *f, u32 l,
 				 u32 bits, u32 mask, int timeout)
 {
 	int ret = _iwl3945_poll_bit(priv, addr, bits, mask, timeout);
-	if (unlikely(ret  == -ETIMEDOUT))
-		IWL_DEBUG_IO
-		    ("poll_bit(0x%08X, 0x%08X, 0x%08X) - timedout - %s %d\n",
-		     addr, bits, mask, f, l);
-	else
-		IWL_DEBUG_IO
-		    ("poll_bit(0x%08X, 0x%08X, 0x%08X) = 0x%08X - %s %d\n",
-		     addr, bits, mask, ret, f, l);
+	IWL_DEBUG_IO("poll_bit(0x%08X, 0x%08X, 0x%08X) - %s- %s %d\n",
+		      addr, bits, mask,
+		      unlikely(ret  == -ETIMEDOUT)?"timeout":"", f, l);
 	return ret;
 }
-#define iwl3945_poll_bit(iwl, addr, bits, mask, timeout) \
-	__iwl3945_poll_bit(__FILE__, __LINE__, iwl, addr, bits, mask, timeout)
+#define iwl3945_poll_bit(priv, addr, bits, mask, timeout) \
+	__iwl3945_poll_bit(__FILE__, __LINE__, priv, addr, bits, mask, timeout)
 #else
 #define iwl3945_poll_bit(p, a, b, m, t) _iwl3945_poll_bit(p, a, b, m, t)
 #endif
@@ -321,8 +316,8 @@ static inline int __iwl3945_poll_direct_bit(const char *f, u32 l,
 			     "- %s %d\n", addr, mask, ret, f, l);
 	return ret;
 }
-#define iwl3945_poll_direct_bit(iwl, addr, mask, timeout) \
-	__iwl3945_poll_direct_bit(__FILE__, __LINE__, iwl, addr, mask, timeout)
+#define iwl3945_poll_direct_bit(priv, addr, mask, timeout) \
+	__iwl3945_poll_direct_bit(__FILE__, __LINE__, priv, addr, mask, timeout)
 #else
 #define iwl3945_poll_direct_bit _iwl3945_poll_direct_bit
 #endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-io.h b/drivers/net/wireless/iwlwifi/iwl-4965-io.h
index 34a0b57..4af0c01 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-io.h
@@ -59,28 +59,28 @@
  *
  */
 
-#define _iwl4965_write32(iwl, ofs, val) writel((val), (iwl)->hw_base + (ofs))
+#define _iwl4965_write32(priv, ofs, val) writel((val), (priv)->hw_base + (ofs))
 #ifdef CONFIG_IWL4965_DEBUG
-static inline void __iwl4965_write32(const char *f, u32 l, struct iwl4965_priv *iwl,
+static inline void __iwl4965_write32(const char *f, u32 l, struct iwl4965_priv *priv,
 				 u32 ofs, u32 val)
 {
 	IWL_DEBUG_IO("write32(0x%08X, 0x%08X) - %s %d\n", ofs, val, f, l);
-	_iwl4965_write32(iwl, ofs, val);
+	_iwl4965_write32(priv, ofs, val);
 }
-#define iwl4965_write32(iwl, ofs, val) \
-	__iwl4965_write32(__FILE__, __LINE__, iwl, ofs, val)
+#define iwl4965_write32(priv, ofs, val) \
+	__iwl4965_write32(__FILE__, __LINE__, priv, ofs, val)
 #else
-#define iwl4965_write32(iwl, ofs, val) _iwl4965_write32(iwl, ofs, val)
+#define iwl4965_write32(priv, ofs, val) _iwl4965_write32(priv, ofs, val)
 #endif
 
-#define _iwl4965_read32(iwl, ofs) readl((iwl)->hw_base + (ofs))
+#define _iwl4965_read32(priv, ofs) readl((priv)->hw_base + (ofs))
 #ifdef CONFIG_IWL4965_DEBUG
-static inline u32 __iwl4965_read32(char *f, u32 l, struct iwl4965_priv *iwl, u32 ofs)
+static inline u32 __iwl4965_read32(char *f, u32 l, struct iwl4965_priv *priv, u32 ofs)
 {
 	IWL_DEBUG_IO("read_direct32(0x%08X) - %s %d\n", ofs, f, l);
-	return _iwl4965_read32(iwl, ofs);
+	return _iwl4965_read32(priv, ofs);
 }
-#define iwl4965_read32(iwl, ofs) __iwl4965_read32(__FILE__, __LINE__, iwl, ofs)
+#define iwl4965_read32(priv, ofs) __iwl4965_read32(__FILE__, __LINE__, priv, ofs)
 #else
 #define iwl4965_read32(p, o) _iwl4965_read32(p, o)
 #endif
@@ -105,18 +105,13 @@ static inline int __iwl4965_poll_bit(const char *f, u32 l,
 				 u32 bits, u32 mask, int timeout)
 {
 	int ret = _iwl4965_poll_bit(priv, addr, bits, mask, timeout);
-	if (unlikely(ret  == -ETIMEDOUT))
-		IWL_DEBUG_IO
-		    ("poll_bit(0x%08X, 0x%08X, 0x%08X) - timedout - %s %d\n",
-		     addr, bits, mask, f, l);
-	else
-		IWL_DEBUG_IO
-		    ("poll_bit(0x%08X, 0x%08X, 0x%08X) = 0x%08X - %s %d\n",
-		     addr, bits, mask, ret, f, l);
+	IWL_DEBUG_IO("poll_bit(0x%08X, 0x%08X, 0x%08X) - %s- %s %d\n",
+		     addr, bits, mask,
+		     unlikely(ret  == -ETIMEDOUT)?"timeout":"", f, l);
 	return ret;
 }
-#define iwl4965_poll_bit(iwl, addr, bits, mask, timeout) \
-	__iwl4965_poll_bit(__FILE__, __LINE__, iwl, addr, bits, mask, timeout)
+#define iwl4965_poll_bit(priv, addr, bits, mask, timeout) \
+	__iwl4965_poll_bit(__FILE__, __LINE__, priv, addr, bits, mask, timeout)
 #else
 #define iwl4965_poll_bit(p, a, b, m, t) _iwl4965_poll_bit(p, a, b, m, t)
 #endif
@@ -321,8 +316,8 @@ static inline int __iwl4965_poll_direct_bit(const char *f, u32 l,
 			     "- %s %d\n", addr, mask, ret, f, l);
 	return ret;
 }
-#define iwl4965_poll_direct_bit(iwl, addr, mask, timeout) \
-	__iwl4965_poll_direct_bit(__FILE__, __LINE__, iwl, addr, mask, timeout)
+#define iwl4965_poll_direct_bit(priv, addr, mask, timeout) \
+	__iwl4965_poll_direct_bit(__FILE__, __LINE__, priv, addr, mask, timeout)
 #else
 #define iwl4965_poll_direct_bit _iwl4965_poll_direct_bit
 #endif
-- 
1.5.3.4

