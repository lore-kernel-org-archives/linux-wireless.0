Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607Ab1KRIU7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:20:59 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8KxbV022520
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:20:59 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 05/77] iwlegacy: remove DEBUG_IO
Date: Fri, 18 Nov 2011 09:21:27 +0100
Message-Id: <1321604559-10707-5-git-send-email-sgruszka@redhat.com> (sfid-20111118_092105_524945_406B26F4)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nothing useful at present.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-4965-eeprom.c |    6 +-
 drivers/net/wireless/iwlegacy/iwl-debug.h       |    2 -
 drivers/net/wireless/iwlegacy/iwl-io.h          |  192 +----------------------
 3 files changed, 3 insertions(+), 197 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-eeprom.c b/drivers/net/wireless/iwlegacy/iwl-4965-eeprom.c
index 947475e..ef8b0d5 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-eeprom.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-eeprom.c
@@ -102,12 +102,8 @@ int il4965_eeprom_acquire_semaphore(struct il_priv *il)
 				CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM,
 				CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM,
 				EEPROM_SEM_TIMEOUT);
-		if (ret >= 0) {
-			IL_DEBUG_IO(il,
-				"Acquired semaphore after %d tries.\n",
-				count+1);
+		if (ret >= 0)
 			return ret;
-		}
 	}
 
 	return ret;
diff --git a/drivers/net/wireless/iwlegacy/iwl-debug.h b/drivers/net/wireless/iwlegacy/iwl-debug.h
index 05a7933..a825051 100644
--- a/drivers/net/wireless/iwlegacy/iwl-debug.h
+++ b/drivers/net/wireless/iwlegacy/iwl-debug.h
@@ -146,7 +146,6 @@ static inline void il_dbgfs_unregister(struct il_priv *il)
 #define IL_DL_RX		(1 << 24)
 #define IL_DL_ISR		(1 << 25)
 #define IL_DL_HT		(1 << 26)
-#define IL_DL_IO		(1 << 27)
 /* 0xF0000000 - 0x10000000 */
 #define IL_DL_11H		(1 << 28)
 #define IL_DL_STATS		(1 << 29)
@@ -174,7 +173,6 @@ static inline void il_dbgfs_unregister(struct il_priv *il)
 		IL_DEBUG_LIMIT(p, IL_DL_DROP, f, ## a)
 #define IL_DEBUG_AP(p, f, a...)	IL_DEBUG(p, IL_DL_AP, f, ## a)
 #define IL_DEBUG_TXPOWER(p, f, a...)	IL_DEBUG(p, IL_DL_TXPOWER, f, ## a)
-#define IL_DEBUG_IO(p, f, a...)	IL_DEBUG(p, IL_DL_IO, f, ## a)
 #define IL_DEBUG_RATE(p, f, a...)	IL_DEBUG(p, IL_DL_RATE, f, ## a)
 #define IL_DEBUG_RATE_LIMIT(p, f, a...)	\
 		IL_DEBUG_LIMIT(p, IL_DL_RATE, f, ## a)
diff --git a/drivers/net/wireless/iwlegacy/iwl-io.h b/drivers/net/wireless/iwlegacy/iwl-io.h
index 42d241f..d6aae8d 100644
--- a/drivers/net/wireless/iwlegacy/iwl-io.h
+++ b/drivers/net/wireless/iwlegacy/iwl-io.h
@@ -34,90 +34,24 @@
 #include "iwl-dev.h"
 #include "iwl-debug.h"
 
-/*
- * IO, register, and NIC memory access functions
- *
- * NOTE on naming convention and macro usage for these
- *
- * A single _ prefix before a an access function means that no state
- * check or debug information is printed when that function is called.
- *
- * A double __ prefix before an access function means that state is checked
- * and the current line number and caller function name are printed in addition
- * to any other debug output.
- *
- * The non-prefixed name is the #define that maps the caller into a
- * #define that provides the caller's name and __LINE__ to the double
- * prefix version.
- *
- * If you wish to call the function without any debug or state checking,
- * you should use the single _ prefix version (as is used by dependent IO
- * routines, for example _il_read_direct32 calls the non-check version of
- * _il_read32.)
- *
- * These declarations are *extremely* useful in quickly isolating code deltas
- * which result in misconfiguration of the hardware I/O.  In combination with
- * git-bisect and the IO debug level you can quickly determine the specific
- * commit which breaks the IO sequence to the hardware.
- *
- */
-
 static inline void _il_write8(struct il_priv *il, u32 ofs, u8 val)
 {
 	iowrite8(val, il->hw_base + ofs);
 }
-
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
-static inline void
-__il_write8(const char *f, u32 l, struct il_priv *il,
-				 u32 ofs, u8 val)
-{
-	IL_DEBUG_IO(il, "write8(0x%08X, 0x%02X) - %s %d\n", ofs, val, f, l);
-	_il_write8(il, ofs, val);
-}
-#define il_write8(il, ofs, val) \
-	__il_write8(__FILE__, __LINE__, il, ofs, val)
-#else
 #define il_write8(il, ofs, val) _il_write8(il, ofs, val)
-#endif
-
 
 static inline void _il_write32(struct il_priv *il, u32 ofs, u32 val)
 {
 	iowrite32(val, il->hw_base + ofs);
 }
-
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
-static inline void
-__il_write32(const char *f, u32 l, struct il_priv *il,
-				 u32 ofs, u32 val)
-{
-	IL_DEBUG_IO(il, "write32(0x%08X, 0x%08X) - %s %d\n", ofs, val, f, l);
-	_il_write32(il, ofs, val);
-}
-#define il_write32(il, ofs, val) \
-	__il_write32(__FILE__, __LINE__, il, ofs, val)
-#else
 #define il_write32(il, ofs, val) _il_write32(il, ofs, val)
-#endif
 
 static inline u32 _il_read32(struct il_priv *il, u32 ofs)
 {
 	u32 val = ioread32(il->hw_base + ofs);
 	return val;
 }
-
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
-static inline u32
-__il_read32(char *f, u32 l, struct il_priv *il, u32 ofs)
-{
-	IL_DEBUG_IO(il, "read_direct32(0x%08X) - %s %d\n", ofs, f, l);
-	return _il_read32(il, ofs);
-}
-#define il_read32(il, ofs) __il_read32(__FILE__, __LINE__, il, ofs)
-#else
 #define il_read32(p, o) _il_read32(p, o)
-#endif
 
 #define IL_POLL_INTERVAL 10	/* microseconds */
 static inline int
@@ -135,46 +69,13 @@ _il_poll_bit(struct il_priv *il, u32 addr,
 
 	return -ETIMEDOUT;
 }
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
-static inline int __il_poll_bit(const char *f, u32 l,
-				 struct il_priv *il, u32 addr,
-				 u32 bits, u32 mask, int timeout)
-{
-	int ret = _il_poll_bit(il, addr, bits, mask, timeout);
-	IL_DEBUG_IO(il, "poll_bit(0x%08X, 0x%08X, 0x%08X) - %s- %s %d\n",
-		     addr, bits, mask,
-		     unlikely(ret  == -ETIMEDOUT) ? "timeout" : "", f, l);
-	return ret;
-}
-#define il_poll_bit(il, addr, bits, mask, timeout) \
-	__il_poll_bit(__FILE__, __LINE__, il, addr, \
-	bits, mask, timeout)
-#else
 #define il_poll_bit(p, a, b, m, t) _il_poll_bit(p, a, b, m, t)
-#endif
 
 static inline void _il_set_bit(struct il_priv *il, u32 reg, u32 mask)
 {
 	_il_write32(il, reg, _il_read32(il, reg) | mask);
 }
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
-static inline void __il_set_bit(const char *f, u32 l,
-				 struct il_priv *il, u32 reg, u32 mask)
-{
-	u32 val = _il_read32(il, reg) | mask;
-	IL_DEBUG_IO(il, "set_bit(0x%08X, 0x%08X) = 0x%08X\n", reg,
-							mask, val);
-	_il_write32(il, reg, val);
-}
-static inline void il_set_bit(struct il_priv *p, u32 r, u32 m)
-{
-	unsigned long reg_flags;
 
-	spin_lock_irqsave(&p->reg_lock, reg_flags);
-	__il_set_bit(__FILE__, __LINE__, p, r, m);
-	spin_unlock_irqrestore(&p->reg_lock, reg_flags);
-}
-#else
 static inline void il_set_bit(struct il_priv *p, u32 r, u32 m)
 {
 	unsigned long reg_flags;
@@ -183,31 +84,13 @@ static inline void il_set_bit(struct il_priv *p, u32 r, u32 m)
 	_il_set_bit(p, r, m);
 	spin_unlock_irqrestore(&p->reg_lock, reg_flags);
 }
-#endif
 
 static inline void
 _il_clear_bit(struct il_priv *il, u32 reg, u32 mask)
 {
 	_il_write32(il, reg, _il_read32(il, reg) & ~mask);
 }
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
-static inline void
-__il_clear_bit(const char *f, u32 l,
-				   struct il_priv *il, u32 reg, u32 mask)
-{
-	u32 val = _il_read32(il, reg) & ~mask;
-	IL_DEBUG_IO(il, "clear_bit(0x%08X, 0x%08X) = 0x%08X\n", reg, mask, val);
-	_il_write32(il, reg, val);
-}
-static inline void il_clear_bit(struct il_priv *p, u32 r, u32 m)
-{
-	unsigned long reg_flags;
 
-	spin_lock_irqsave(&p->reg_lock, reg_flags);
-	__il_clear_bit(__FILE__, __LINE__, p, r, m);
-	spin_unlock_irqrestore(&p->reg_lock, reg_flags);
-}
-#else
 static inline void il_clear_bit(struct il_priv *p, u32 r, u32 m)
 {
 	unsigned long reg_flags;
@@ -216,7 +99,6 @@ static inline void il_clear_bit(struct il_priv *p, u32 r, u32 m)
 	_il_clear_bit(p, r, m);
 	spin_unlock_irqrestore(&p->reg_lock, reg_flags);
 }
-#endif
 
 static inline int _il_grab_nic_access(struct il_priv *il)
 {
@@ -259,69 +141,20 @@ static inline int _il_grab_nic_access(struct il_priv *il)
 
 	return 0;
 }
-
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
-static inline int __il_grab_nic_access(const char *f, u32 l,
-					       struct il_priv *il)
-{
-	IL_DEBUG_IO(il, "grabbing nic access - %s %d\n", f, l);
-	return _il_grab_nic_access(il);
-}
-#define il_grab_nic_access(il) \
-	__il_grab_nic_access(__FILE__, __LINE__, il)
-#else
-#define il_grab_nic_access(il) \
-	_il_grab_nic_access(il)
-#endif
+#define il_grab_nic_access(il) _il_grab_nic_access(il)
 
 static inline void _il_release_nic_access(struct il_priv *il)
 {
 	_il_clear_bit(il, CSR_GP_CNTRL,
 			CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 }
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
-static inline void __il_release_nic_access(const char *f, u32 l,
-					    struct il_priv *il)
-{
-
-	IL_DEBUG_IO(il, "releasing nic access - %s %d\n", f, l);
-	_il_release_nic_access(il);
-}
-#define il_release_nic_access(il) \
-	__il_release_nic_access(__FILE__, __LINE__, il)
-#else
-#define il_release_nic_access(il) \
-	_il_release_nic_access(il)
-#endif
+#define il_release_nic_access(il) _il_release_nic_access(il)
 
 static inline u32 _il_read_direct32(struct il_priv *il, u32 reg)
 {
 	return _il_read32(il, reg);
 }
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
-static inline u32 __il_read_direct32(const char *f, u32 l,
-					struct il_priv *il, u32 reg)
-{
-	u32 value = _il_read_direct32(il, reg);
-	IL_DEBUG_IO(il,
-			"read_direct32(0x%4X) = 0x%08x - %s %d\n", reg, value,
-		     f, l);
-	return value;
-}
-static inline u32 il_read_direct32(struct il_priv *il, u32 reg)
-{
-	u32 value;
-	unsigned long reg_flags;
-
-	spin_lock_irqsave(&il->reg_lock, reg_flags);
-	il_grab_nic_access(il);
-	value = __il_read_direct32(__FILE__, __LINE__, il, reg);
-	il_release_nic_access(il);
-	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
-	return value;
-}
 
-#else
 static inline u32 il_read_direct32(struct il_priv *il, u32 reg)
 {
 	u32 value;
@@ -335,7 +168,6 @@ static inline u32 il_read_direct32(struct il_priv *il, u32 reg)
 	return value;
 
 }
-#endif
 
 static inline void _il_write_direct32(struct il_priv *il,
 					 u32 reg, u32 value)
@@ -380,27 +212,7 @@ static inline int _il_poll_direct_bit(struct il_priv *il, u32 addr,
 
 	return -ETIMEDOUT;
 }
-
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
-static inline int __il_poll_direct_bit(const char *f, u32 l,
-					    struct il_priv *il,
-					    u32 addr, u32 mask, int timeout)
-{
-	int ret  = _il_poll_direct_bit(il, addr, mask, timeout);
-
-	if (unlikely(ret == -ETIMEDOUT))
-		IL_DEBUG_IO(il, "poll_direct_bit(0x%08X, 0x%08X) - "
-			     "timedout - %s %d\n", addr, mask, f, l);
-	else
-		IL_DEBUG_IO(il, "poll_direct_bit(0x%08X, 0x%08X) = 0x%08X "
-			     "- %s %d\n", addr, mask, ret, f, l);
-	return ret;
-}
-#define il_poll_direct_bit(il, addr, mask, timeout) \
-__il_poll_direct_bit(__FILE__, __LINE__, il, addr, mask, timeout)
-#else
 #define il_poll_direct_bit _il_poll_direct_bit
-#endif
 
 static inline u32 _il_read_prph(struct il_priv *il, u32 reg)
 {
-- 
1.7.1

