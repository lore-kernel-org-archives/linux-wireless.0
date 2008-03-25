Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:42941 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755572AbYCYXdo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2008 19:33:44 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 3/6] iwlwifi: improve NIC i/o debug prints information
Date: Tue, 25 Mar 2008 16:33:38 -0700
Message-Id: <1206488021-4193-4-git-send-email-reinette.chatre@intel.com> (sfid-20080325_233412_756531_39D822B9)
In-Reply-To: <1206488021-4193-3-git-send-email-reinette.chatre@intel.com>
References: <1206488021-4193-1-git-send-email-reinette.chatre@intel.com>
 <1206488021-4193-2-git-send-email-reinette.chatre@intel.com>
 <1206488021-4193-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch gives the function's caller name in case NIC
access reference count was not used by it.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-io.h |   47 +++++++++++++++++---------------
 1 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index 09cc094..5bc3df4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -42,10 +42,12 @@
  * check or debug information is printed when that function is called.
  *
  * A double __ prefix before an access function means that state is checked
- * and the current line number is printed in addition to any other debug output.
+ * and the current line number and caller function name are printed in addition
+ * to any other debug output.
  *
  * The non-prefixed name is the #define that maps the caller into a
- * #define that provides the caller's __LINE__ to the double prefix version.
+ * #define that provides the caller's name and __LINE__ to the double
+ * prefix version.
  *
  * If you wish to call the function without any debug or state checking,
  * you should use the single _ prefix version (as is used by dependent IO
@@ -197,8 +199,7 @@ static inline int __iwl_grab_nic_access(const char *f, u32 l,
 					       struct iwl_priv *priv)
 {
 	if (atomic_read(&priv->restrict_refcnt))
-		IWL_DEBUG_INFO("Grabbing access while already held at "
-			       "line %d.\n", l);
+		IWL_ERROR("Grabbing access while already held %s %d.\n", f, l);
 
 	IWL_DEBUG_IO("grabbing nic access - %s %d\n", f, l);
 	return _iwl_grab_nic_access(priv);
@@ -223,7 +224,7 @@ static inline void __iwl_release_nic_access(const char *f, u32 l,
 					    struct iwl_priv *priv)
 {
 	if (atomic_read(&priv->restrict_refcnt) <= 0)
-		IWL_ERROR("Release unheld nic access at line %d.\n", l);
+		IWL_ERROR("Release unheld nic access at line %s %d.\n", f, l);
 
 	IWL_DEBUG_IO("releasing nic access - %s %d\n", f, l);
 	_iwl_release_nic_access(priv);
@@ -262,15 +263,15 @@ static inline void _iwl_write_direct32(struct iwl_priv *priv,
 	_iwl_write32(priv, reg, value);
 }
 #ifdef CONFIG_IWLWIFI_DEBUG
-static void __iwl_write_direct32(u32 line,
+static void __iwl_write_direct32(const char *f , u32 line,
 				   struct iwl_priv *priv, u32 reg, u32 value)
 {
 	if (!atomic_read(&priv->restrict_refcnt))
-		IWL_ERROR("Nic access not held from line %d\n", line);
+		IWL_ERROR("Nic access not held from %s line %d\n", f, line);
 	_iwl_write_direct32(priv, reg, value);
 }
 #define iwl_write_direct32(priv, reg, value) \
-	__iwl_write_direct32(__LINE__, priv, reg, value)
+	__iwl_write_direct32(__func__, __LINE__, priv, reg, value)
 #else
 #define iwl_write_direct32 _iwl_write_direct32
 #endif
@@ -328,15 +329,16 @@ static inline u32 _iwl_read_prph(struct iwl_priv *priv, u32 reg)
 	return _iwl_read_direct32(priv, HBUS_TARG_PRPH_RDAT);
 }
 #ifdef CONFIG_IWLWIFI_DEBUG
-static inline u32 __iwl_read_prph(u32 line, struct iwl_priv *priv, u32 reg)
+static inline u32 __iwl_read_prph(const char *f, u32 line,
+				  struct iwl_priv *priv, u32 reg)
 {
 	if (!atomic_read(&priv->restrict_refcnt))
-		IWL_ERROR("Nic access not held from line %d\n", line);
+		IWL_ERROR("Nic access not held from %s line %d\n", f, line);
 	return _iwl_read_prph(priv, reg);
 }
 
 #define iwl_read_prph(priv, reg) \
-	__iwl_read_prph(__LINE__, priv, reg)
+	__iwl_read_prph(__func__, __LINE__, priv, reg)
 #else
 #define iwl_read_prph _iwl_read_prph
 #endif
@@ -349,16 +351,16 @@ static inline void _iwl_write_prph(struct iwl_priv *priv,
 	_iwl_write_direct32(priv, HBUS_TARG_PRPH_WDAT, val);
 }
 #ifdef CONFIG_IWLWIFI_DEBUG
-static inline void __iwl_write_prph(u32 line, struct iwl_priv *priv,
-					      u32 addr, u32 val)
+static inline void __iwl_write_prph(const char *f, u32 line,
+				    struct iwl_priv *priv, u32 addr, u32 val)
 {
 	if (!atomic_read(&priv->restrict_refcnt))
-		IWL_ERROR("Nic access from line %d\n", line);
+		IWL_ERROR("Nic access not held from %s line %d\n", f, line);
 	_iwl_write_prph(priv, addr, val);
 }
 
 #define iwl_write_prph(priv, addr, val) \
-	__iwl_write_prph(__LINE__, priv, addr, val);
+	__iwl_write_prph(__func__, __LINE__, priv, addr, val);
 #else
 #define iwl_write_prph _iwl_write_prph
 #endif
@@ -366,16 +368,17 @@ static inline void __iwl_write_prph(u32 line, struct iwl_priv *priv,
 #define _iwl_set_bits_prph(priv, reg, mask) \
 	_iwl_write_prph(priv, reg, (_iwl_read_prph(priv, reg) | mask))
 #ifdef CONFIG_IWLWIFI_DEBUG
-static inline void __iwl_set_bits_prph(u32 line, struct iwl_priv *priv,
-					u32 reg, u32 mask)
+static inline void __iwl_set_bits_prph(const char *f, u32 line,
+				       struct iwl_priv *priv,
+				       u32 reg, u32 mask)
 {
 	if (!atomic_read(&priv->restrict_refcnt))
-		IWL_ERROR("Nic access not held from line %d\n", line);
+		IWL_ERROR("Nic access not held from %s line %d\n", f, line);
 
 	_iwl_set_bits_prph(priv, reg, mask);
 }
 #define iwl_set_bits_prph(priv, reg, mask) \
-	__iwl_set_bits_prph(__LINE__, priv, reg, mask)
+	__iwl_set_bits_prph(__func__, __LINE__, priv, reg, mask)
 #else
 #define iwl_set_bits_prph _iwl_set_bits_prph
 #endif
@@ -384,15 +387,15 @@ static inline void __iwl_set_bits_prph(u32 line, struct iwl_priv *priv,
 	_iwl_write_prph(priv, reg, ((_iwl_read_prph(priv, reg) & mask) | bits))
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-static inline void __iwl_set_bits_mask_prph(u32 line,
+static inline void __iwl_set_bits_mask_prph(const char *f, u32 line,
 		struct iwl_priv *priv, u32 reg, u32 bits, u32 mask)
 {
 	if (!atomic_read(&priv->restrict_refcnt))
-		IWL_ERROR("Nic access not held from line %d\n", line);
+		IWL_ERROR("Nic access not held from %s line %d\n", f, line);
 	_iwl_set_bits_mask_prph(priv, reg, bits, mask);
 }
 #define iwl_set_bits_mask_prph(priv, reg, bits, mask) \
-	__iwl_set_bits_mask_prph(__LINE__, priv, reg, bits, mask)
+	__iwl_set_bits_mask_prph(__func__, __LINE__, priv, reg, bits, mask)
 #else
 #define iwl_set_bits_mask_prph _iwl_set_bits_mask_prph
 #endif
-- 
1.5.3.4

