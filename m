Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:65030 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731AbYLSCpa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 21:45:30 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 29/43] iwl3945: use iwl-io.h and delete iwl-3945-io.h
Date: Fri, 19 Dec 2008 10:37:29 +0800
Message-Id: <1229654263-21454-30-git-send-email-yi.zhu@intel.com> (sfid-20081219_040901_065335_5C6D2DA9)
In-Reply-To: <1229654263-21454-29-git-send-email-yi.zhu@intel.com>
References: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-2-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-3-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-4-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-5-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-6-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-7-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-8-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-9-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-10-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-11-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-12-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-13-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-14-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-15-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-16-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-17-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-18-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-19-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-20-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-21-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-22-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-23-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-24-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-25-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-26-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-27-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-28-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-29-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

The patch deletes iwl-3945-io.h and uses iwl-io.h functions.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-io.h  |  404 ---------------------------
 drivers/net/wireless/iwlwifi/iwl-3945.c     |  162 ++++++------
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |  230 ++++++++--------
 4 files changed, 197 insertions(+), 601 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-3945-io.h

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-io.h b/drivers/net/wireless/iwlwifi/iwl-3945-io.h
deleted file mode 100644
index 0b84815..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-3945-io.h
+++ /dev/null
@@ -1,404 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2003 - 2008 Intel Corporation. All rights reserved.
- *
- * Portions of this file are derived from the ipw3945 project.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
- * The full GNU General Public License is included in this distribution in the
- * file called LICENSE.
- *
- * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- *****************************************************************************/
-
-#ifndef __iwl3945_io_h__
-#define __iwl3945_io_h__
-
-#include <linux/io.h>
-
-#include "iwl-debug.h"
-
-/*
- * IO, register, and NIC memory access functions
- *
- * NOTE on naming convention and macro usage for these
- *
- * A single _ prefix before a an access function means that no state
- * check or debug information is printed when that function is called.
- *
- * A double __ prefix before an access function means that state is checked
- * and the current line number is printed in addition to any other debug output.
- *
- * The non-prefixed name is the #define that maps the caller into a
- * #define that provides the caller's __LINE__ to the double prefix version.
- *
- * If you wish to call the function without any debug or state checking,
- * you should use the single _ prefix version (as is used by dependent IO
- * routines, for example _iwl3945_read_direct32 calls the non-check version of
- * _iwl3945_read32.)
- *
- * These declarations are *extremely* useful in quickly isolating code deltas
- * which result in misconfiguration of the hardware I/O.  In combination with
- * git-bisect and the IO debug level you can quickly determine the specific
- * commit which breaks the IO sequence to the hardware.
- *
- */
-
-#define _iwl3945_write32(priv, ofs, val) iowrite32((val), (priv)->hw_base + (ofs))
-#ifdef CONFIG_IWL3945_DEBUG
-static inline void __iwl3945_write32(const char *f, u32 l, struct iwl_priv *priv,
-				 u32 ofs, u32 val)
-{
-	IWL_DEBUG_IO("write32(0x%08X, 0x%08X) - %s %d\n", ofs, val, f, l);
-	_iwl3945_write32(priv, ofs, val);
-}
-#define iwl3945_write32(priv, ofs, val) \
-	__iwl3945_write32(__FILE__, __LINE__, priv, ofs, val)
-#else
-#define iwl3945_write32(priv, ofs, val) _iwl3945_write32(priv, ofs, val)
-#endif
-
-#define _iwl3945_read32(priv, ofs) ioread32((priv)->hw_base + (ofs))
-#ifdef CONFIG_IWL3945_DEBUG
-static inline u32 __iwl3945_read32(char *f, u32 l, struct iwl_priv *priv, u32 ofs)
-{
-	IWL_DEBUG_IO("read_direct32(0x%08X) - %s %d\n", ofs, f, l);
-	return _iwl3945_read32(priv, ofs);
-}
-#define iwl3945_read32(priv, ofs)__iwl3945_read32(__FILE__, __LINE__, priv, ofs)
-#else
-#define iwl3945_read32(p, o) _iwl3945_read32(p, o)
-#endif
-
-static inline int _iwl3945_poll_bit(struct iwl_priv *priv, u32 addr,
-				u32 bits, u32 mask, int timeout)
-{
-	int i = 0;
-
-	do {
-		if ((_iwl3945_read32(priv, addr) & mask) == (bits & mask))
-			return i;
-		udelay(10);
-		i += 10;
-	} while (i < timeout);
-
-	return -ETIMEDOUT;
-}
-#ifdef CONFIG_IWL3945_DEBUG
-static inline int __iwl3945_poll_bit(const char *f, u32 l,
-				 struct iwl_priv *priv, u32 addr,
-				 u32 bits, u32 mask, int timeout)
-{
-	int ret = _iwl3945_poll_bit(priv, addr, bits, mask, timeout);
-	IWL_DEBUG_IO("poll_bit(0x%08X, 0x%08X, 0x%08X) - %s- %s %d\n",
-		      addr, bits, mask,
-		      unlikely(ret  == -ETIMEDOUT) ? "timeout" : "", f, l);
-	return ret;
-}
-#define iwl3945_poll_bit(priv, addr, bits, mask, timeout) \
-	__iwl3945_poll_bit(__FILE__, __LINE__, priv, addr, bits, mask, timeout)
-#else
-#define iwl3945_poll_bit(p, a, b, m, t) _iwl3945_poll_bit(p, a, b, m, t)
-#endif
-
-static inline void _iwl3945_set_bit(struct iwl_priv *priv, u32 reg, u32 mask)
-{
-	_iwl3945_write32(priv, reg, _iwl3945_read32(priv, reg) | mask);
-}
-#ifdef CONFIG_IWL3945_DEBUG
-static inline void __iwl3945_set_bit(const char *f, u32 l,
-				 struct iwl_priv *priv, u32 reg, u32 mask)
-{
-	u32 val = _iwl3945_read32(priv, reg) | mask;
-	IWL_DEBUG_IO("set_bit(0x%08X, 0x%08X) = 0x%08X\n", reg, mask, val);
-	_iwl3945_write32(priv, reg, val);
-}
-#define iwl3945_set_bit(p, r, m) __iwl3945_set_bit(__FILE__, __LINE__, p, r, m)
-#else
-#define iwl3945_set_bit(p, r, m) _iwl3945_set_bit(p, r, m)
-#endif
-
-static inline void _iwl3945_clear_bit(struct iwl_priv *priv, u32 reg, u32 mask)
-{
-	_iwl3945_write32(priv, reg, _iwl3945_read32(priv, reg) & ~mask);
-}
-#ifdef CONFIG_IWL3945_DEBUG
-static inline void __iwl3945_clear_bit(const char *f, u32 l,
-				   struct iwl_priv *priv, u32 reg, u32 mask)
-{
-	u32 val = _iwl3945_read32(priv, reg) & ~mask;
-	IWL_DEBUG_IO("clear_bit(0x%08X, 0x%08X) = 0x%08X\n", reg, mask, val);
-	_iwl3945_write32(priv, reg, val);
-}
-#define iwl3945_clear_bit(p, r, m) __iwl3945_clear_bit(__FILE__, __LINE__, p, r, m)
-#else
-#define iwl3945_clear_bit(p, r, m) _iwl3945_clear_bit(p, r, m)
-#endif
-
-static inline int _iwl3945_grab_nic_access(struct iwl_priv *priv)
-{
-	int ret;
-#ifdef CONFIG_IWL3945_DEBUG
-	if (atomic_read(&priv->restrict_refcnt))
-		return 0;
-#endif
-	/* this bit wakes up the NIC */
-	_iwl3945_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-	ret = _iwl3945_poll_bit(priv, CSR_GP_CNTRL,
-			   CSR_GP_CNTRL_REG_VAL_MAC_ACCESS_EN,
-			   (CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY |
-			    CSR_GP_CNTRL_REG_FLAG_GOING_TO_SLEEP), 50);
-	if (ret < 0) {
-		IWL_ERROR("MAC is in deep sleep!\n");
-		return -EIO;
-	}
-
-#ifdef CONFIG_IWL3945_DEBUG
-	atomic_inc(&priv->restrict_refcnt);
-#endif
-	return 0;
-}
-
-#ifdef CONFIG_IWL3945_DEBUG
-static inline int __iwl3945_grab_nic_access(const char *f, u32 l,
-					       struct iwl_priv *priv)
-{
-	if (atomic_read(&priv->restrict_refcnt))
-		IWL_DEBUG_INFO("Grabbing access while already held at "
-			       "line %d.\n", l);
-
-	IWL_DEBUG_IO("grabbing nic access - %s %d\n", f, l);
-	return _iwl3945_grab_nic_access(priv);
-}
-#define iwl3945_grab_nic_access(priv) \
-	__iwl3945_grab_nic_access(__FILE__, __LINE__, priv)
-#else
-#define iwl3945_grab_nic_access(priv) \
-	_iwl3945_grab_nic_access(priv)
-#endif
-
-static inline void _iwl3945_release_nic_access(struct iwl_priv *priv)
-{
-#ifdef CONFIG_IWL3945_DEBUG
-	if (atomic_dec_and_test(&priv->restrict_refcnt))
-#endif
-		_iwl3945_clear_bit(priv, CSR_GP_CNTRL,
-			       CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-}
-#ifdef CONFIG_IWL3945_DEBUG
-static inline void __iwl3945_release_nic_access(const char *f, u32 l,
-					    struct iwl_priv *priv)
-{
-	if (atomic_read(&priv->restrict_refcnt) <= 0)
-		IWL_ERROR("Release unheld nic access at line %d.\n", l);
-
-	IWL_DEBUG_IO("releasing nic access - %s %d\n", f, l);
-	_iwl3945_release_nic_access(priv);
-}
-#define iwl3945_release_nic_access(priv) \
-	__iwl3945_release_nic_access(__FILE__, __LINE__, priv)
-#else
-#define iwl3945_release_nic_access(priv) \
-	_iwl3945_release_nic_access(priv)
-#endif
-
-static inline u32 _iwl3945_read_direct32(struct iwl_priv *priv, u32 reg)
-{
-	return _iwl3945_read32(priv, reg);
-}
-#ifdef CONFIG_IWL3945_DEBUG
-static inline u32 __iwl3945_read_direct32(const char *f, u32 l,
-					struct iwl_priv *priv, u32 reg)
-{
-	u32 value = _iwl3945_read_direct32(priv, reg);
-	if (!atomic_read(&priv->restrict_refcnt))
-		IWL_ERROR("Nic access not held from %s %d\n", f, l);
-	IWL_DEBUG_IO("read_direct32(0x%4X) = 0x%08x - %s %d \n", reg, value,
-		     f, l);
-	return value;
-}
-#define iwl3945_read_direct32(priv, reg) \
-	__iwl3945_read_direct32(__FILE__, __LINE__, priv, reg)
-#else
-#define iwl3945_read_direct32 _iwl3945_read_direct32
-#endif
-
-static inline void _iwl3945_write_direct32(struct iwl_priv *priv,
-					 u32 reg, u32 value)
-{
-	_iwl3945_write32(priv, reg, value);
-}
-#ifdef CONFIG_IWL3945_DEBUG
-static void __iwl3945_write_direct32(u32 line,
-				   struct iwl_priv *priv, u32 reg, u32 value)
-{
-	if (!atomic_read(&priv->restrict_refcnt))
-		IWL_ERROR("Nic access not held from line %d\n", line);
-	_iwl3945_write_direct32(priv, reg, value);
-}
-#define iwl3945_write_direct32(priv, reg, value) \
-	__iwl3945_write_direct32(__LINE__, priv, reg, value)
-#else
-#define iwl3945_write_direct32 _iwl3945_write_direct32
-#endif
-
-static inline void iwl3945_write_reg_buf(struct iwl_priv *priv,
-					       u32 reg, u32 len, u32 *values)
-{
-	u32 count = sizeof(u32);
-
-	if ((priv != NULL) && (values != NULL)) {
-		for (; 0 < len; len -= count, reg += count, values++)
-			_iwl3945_write_direct32(priv, reg, *values);
-	}
-}
-
-static inline int _iwl3945_poll_direct_bit(struct iwl_priv *priv,
-					   u32 addr, u32 mask, int timeout)
-{
-	return _iwl3945_poll_bit(priv, addr, mask, mask, timeout);
-}
-
-#ifdef CONFIG_IWL3945_DEBUG
-static inline int __iwl3945_poll_direct_bit(const char *f, u32 l,
-					    struct iwl_priv *priv,
-					    u32 addr, u32 mask, int timeout)
-{
-	int ret  = _iwl3945_poll_direct_bit(priv, addr, mask, timeout);
-
-	if (unlikely(ret == -ETIMEDOUT))
-		IWL_DEBUG_IO("poll_direct_bit(0x%08X, 0x%08X) - "
-			     "timedout - %s %d\n", addr, mask, f, l);
-	else
-		IWL_DEBUG_IO("poll_direct_bit(0x%08X, 0x%08X) = 0x%08X "
-			     "- %s %d\n", addr, mask, ret, f, l);
-	return ret;
-}
-#define iwl3945_poll_direct_bit(priv, addr, mask, timeout) \
-	__iwl3945_poll_direct_bit(__FILE__, __LINE__, priv, addr, mask, timeout)
-#else
-#define iwl3945_poll_direct_bit _iwl3945_poll_direct_bit
-#endif
-
-static inline u32 _iwl3945_read_prph(struct iwl_priv *priv, u32 reg)
-{
-	_iwl3945_write_direct32(priv, HBUS_TARG_PRPH_RADDR, reg | (3 << 24));
-	rmb();
-	return _iwl3945_read_direct32(priv, HBUS_TARG_PRPH_RDAT);
-}
-#ifdef CONFIG_IWL3945_DEBUG
-static inline u32 __iwl3945_read_prph(u32 line, struct iwl_priv *priv, u32 reg)
-{
-	if (!atomic_read(&priv->restrict_refcnt))
-		IWL_ERROR("Nic access not held from line %d\n", line);
-	return _iwl3945_read_prph(priv, reg);
-}
-
-#define iwl3945_read_prph(priv, reg) \
-	__iwl3945_read_prph(__LINE__, priv, reg)
-#else
-#define iwl3945_read_prph _iwl3945_read_prph
-#endif
-
-static inline void _iwl3945_write_prph(struct iwl_priv *priv,
-					     u32 addr, u32 val)
-{
-	_iwl3945_write_direct32(priv, HBUS_TARG_PRPH_WADDR,
-			      ((addr & 0x0000FFFF) | (3 << 24)));
-	wmb();
-	_iwl3945_write_direct32(priv, HBUS_TARG_PRPH_WDAT, val);
-}
-#ifdef CONFIG_IWL3945_DEBUG
-static inline void __iwl3945_write_prph(u32 line, struct iwl_priv *priv,
-					      u32 addr, u32 val)
-{
-	if (!atomic_read(&priv->restrict_refcnt))
-		IWL_ERROR("Nic access from line %d\n", line);
-	_iwl3945_write_prph(priv, addr, val);
-}
-
-#define iwl3945_write_prph(priv, addr, val) \
-	__iwl3945_write_prph(__LINE__, priv, addr, val);
-#else
-#define iwl3945_write_prph _iwl3945_write_prph
-#endif
-
-#define _iwl3945_set_bits_prph(priv, reg, mask) \
-	_iwl3945_write_prph(priv, reg, (_iwl3945_read_prph(priv, reg) | mask))
-#ifdef CONFIG_IWL3945_DEBUG
-static inline void __iwl3945_set_bits_prph(u32 line, struct iwl_priv *priv,
-					u32 reg, u32 mask)
-{
-	if (!atomic_read(&priv->restrict_refcnt))
-		IWL_ERROR("Nic access not held from line %d\n", line);
-
-	_iwl3945_set_bits_prph(priv, reg, mask);
-}
-#define iwl3945_set_bits_prph(priv, reg, mask) \
-	__iwl3945_set_bits_prph(__LINE__, priv, reg, mask)
-#else
-#define iwl3945_set_bits_prph _iwl3945_set_bits_prph
-#endif
-
-#define _iwl3945_set_bits_mask_prph(priv, reg, bits, mask) \
-	_iwl3945_write_prph(priv, reg, ((_iwl3945_read_prph(priv, reg) & mask) | bits))
-
-#ifdef CONFIG_IWL3945_DEBUG
-static inline void __iwl3945_set_bits_mask_prph(u32 line,
-		struct iwl_priv *priv, u32 reg, u32 bits, u32 mask)
-{
-	if (!atomic_read(&priv->restrict_refcnt))
-		IWL_ERROR("Nic access not held from line %d\n", line);
-	_iwl3945_set_bits_mask_prph(priv, reg, bits, mask);
-}
-#define iwl3945_set_bits_mask_prph(priv, reg, bits, mask) \
-	__iwl3945_set_bits_mask_prph(__LINE__, priv, reg, bits, mask)
-#else
-#define iwl3945_set_bits_mask_prph _iwl3945_set_bits_mask_prph
-#endif
-
-static inline void iwl3945_clear_bits_prph(struct iwl_priv
-						 *priv, u32 reg, u32 mask)
-{
-	u32 val = _iwl3945_read_prph(priv, reg);
-	_iwl3945_write_prph(priv, reg, (val & ~mask));
-}
-
-static inline u32 iwl3945_read_targ_mem(struct iwl_priv *priv, u32 addr)
-{
-	iwl3945_write_direct32(priv, HBUS_TARG_MEM_RADDR, addr);
-	rmb();
-	return iwl3945_read_direct32(priv, HBUS_TARG_MEM_RDAT);
-}
-
-static inline void iwl3945_write_targ_mem(struct iwl_priv *priv, u32 addr, u32 val)
-{
-	iwl3945_write_direct32(priv, HBUS_TARG_MEM_WADDR, addr);
-	wmb();
-	iwl3945_write_direct32(priv, HBUS_TARG_MEM_WDAT, val);
-}
-
-static inline void iwl3945_write_targ_mem_buf(struct iwl_priv *priv, u32 addr,
-					  u32 len, u32 *values)
-{
-	iwl3945_write_direct32(priv, HBUS_TARG_MEM_WADDR, addr);
-	wmb();
-	for (; 0 < len; len -= sizeof(u32), values++)
-		iwl3945_write_direct32(priv, HBUS_TARG_MEM_WDAT, *values);
-}
-#endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 35477d5..522f020 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -156,26 +156,26 @@ void iwl3945_disable_events(struct iwl_priv *priv)
 		return;
 	}
 
-	ret = iwl3945_grab_nic_access(priv);
+	ret = iwl_grab_nic_access(priv);
 	if (ret) {
 		IWL_WARNING("Can not read from adapter at this time.\n");
 		return;
 	}
 
-	disable_ptr = iwl3945_read_targ_mem(priv, base + (4 * sizeof(u32)));
-	array_size = iwl3945_read_targ_mem(priv, base + (5 * sizeof(u32)));
-	iwl3945_release_nic_access(priv);
+	disable_ptr = iwl_read_targ_mem(priv, base + (4 * sizeof(u32)));
+	array_size = iwl_read_targ_mem(priv, base + (5 * sizeof(u32)));
+	iwl_release_nic_access(priv);
 
 	if (IWL_EVT_DISABLE && (array_size == IWL_EVT_DISABLE_SIZE)) {
 		IWL_DEBUG_INFO("Disabling selected uCode log events at 0x%x\n",
 			       disable_ptr);
-		ret = iwl3945_grab_nic_access(priv);
+		ret = iwl_grab_nic_access(priv);
 		for (i = 0; i < IWL_EVT_DISABLE_SIZE; i++)
-			iwl3945_write_targ_mem(priv,
+			iwl_write_targ_mem(priv,
 					   disable_ptr + (i * sizeof(u32)),
 					   evt_disable[i]);
 
-		iwl3945_release_nic_access(priv);
+		iwl_release_nic_access(priv);
 	} else {
 		IWL_DEBUG_INFO("Selected uCode log events may be disabled\n");
 		IWL_DEBUG_INFO("  by writing \"1\"s into disable bitmap\n");
@@ -926,7 +926,7 @@ static int iwl3945_nic_set_pwr_src(struct iwl_priv *priv, int pwr_max)
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl3945_grab_nic_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return rc;
@@ -938,23 +938,23 @@ static int iwl3945_nic_set_pwr_src(struct iwl_priv *priv, int pwr_max)
 		rc = pci_read_config_dword(priv->pci_dev,
 				PCI_POWER_SOURCE, &val);
 		if (val & PCI_CFG_PMC_PME_FROM_D3COLD_SUPPORT) {
-			iwl3945_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
+			iwl_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
 					APMG_PS_CTRL_VAL_PWR_SRC_VAUX,
 					~APMG_PS_CTRL_MSK_PWR_SRC);
-			iwl3945_release_nic_access(priv);
+			iwl_release_nic_access(priv);
 
-			iwl3945_poll_bit(priv, CSR_GPIO_IN,
+			iwl_poll_bit(priv, CSR_GPIO_IN,
 				     CSR_GPIO_IN_VAL_VAUX_PWR_SRC,
 				     CSR_GPIO_IN_BIT_AUX_POWER, 5000);
 		} else
-			iwl3945_release_nic_access(priv);
+			iwl_release_nic_access(priv);
 	} else {
-		iwl3945_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
+		iwl_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
 				APMG_PS_CTRL_VAL_PWR_SRC_VMAIN,
 				~APMG_PS_CTRL_MSK_PWR_SRC);
 
-		iwl3945_release_nic_access(priv);
-		iwl3945_poll_bit(priv, CSR_GPIO_IN, CSR_GPIO_IN_VAL_VMAIN_PWR_SRC,
+		iwl_release_nic_access(priv);
+		iwl_poll_bit(priv, CSR_GPIO_IN, CSR_GPIO_IN_VAL_VMAIN_PWR_SRC,
 			     CSR_GPIO_IN_BIT_AUX_POWER, 5000);	/* uS */
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -968,18 +968,18 @@ static int iwl3945_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl3945_grab_nic_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return rc;
 	}
 
-	iwl3945_write_direct32(priv, FH39_RCSR_RBD_BASE(0), rxq->dma_addr);
-	iwl3945_write_direct32(priv, FH39_RCSR_RPTR_ADDR(0),
+	iwl_write_direct32(priv, FH39_RCSR_RBD_BASE(0), rxq->dma_addr);
+	iwl_write_direct32(priv, FH39_RCSR_RPTR_ADDR(0),
 			     priv->shared_phys +
 			     offsetof(struct iwl3945_shared, rx_read_ptr[0]));
-	iwl3945_write_direct32(priv, FH39_RCSR_WPTR(0), 0);
-	iwl3945_write_direct32(priv, FH39_RCSR_CONFIG(0),
+	iwl_write_direct32(priv, FH39_RCSR_WPTR(0), 0);
+	iwl_write_direct32(priv, FH39_RCSR_CONFIG(0),
 		FH39_RCSR_RX_CONFIG_REG_VAL_DMA_CHNL_EN_ENABLE |
 		FH39_RCSR_RX_CONFIG_REG_VAL_RDRBD_EN_ENABLE |
 		FH39_RCSR_RX_CONFIG_REG_BIT_WR_STTS_EN |
@@ -990,9 +990,9 @@ static int iwl3945_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 		FH39_RCSR_RX_CONFIG_REG_VAL_MSG_MODE_FH);
 
 	/* fake read to flush all prev I/O */
-	iwl3945_read_direct32(priv, FH39_RSSR_CTRL);
+	iwl_read_direct32(priv, FH39_RSSR_CTRL);
 
-	iwl3945_release_nic_access(priv);
+	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return 0;
@@ -1004,30 +1004,30 @@ static int iwl3945_tx_reset(struct iwl_priv *priv)
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl3945_grab_nic_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return rc;
 	}
 
 	/* bypass mode */
-	iwl3945_write_prph(priv, ALM_SCD_MODE_REG, 0x2);
+	iwl_write_prph(priv, ALM_SCD_MODE_REG, 0x2);
 
 	/* RA 0 is active */
-	iwl3945_write_prph(priv, ALM_SCD_ARASTAT_REG, 0x01);
+	iwl_write_prph(priv, ALM_SCD_ARASTAT_REG, 0x01);
 
 	/* all 6 fifo are active */
-	iwl3945_write_prph(priv, ALM_SCD_TXFACT_REG, 0x3f);
+	iwl_write_prph(priv, ALM_SCD_TXFACT_REG, 0x3f);
 
-	iwl3945_write_prph(priv, ALM_SCD_SBYP_MODE_1_REG, 0x010000);
-	iwl3945_write_prph(priv, ALM_SCD_SBYP_MODE_2_REG, 0x030002);
-	iwl3945_write_prph(priv, ALM_SCD_TXF4MF_REG, 0x000004);
-	iwl3945_write_prph(priv, ALM_SCD_TXF5MF_REG, 0x000005);
+	iwl_write_prph(priv, ALM_SCD_SBYP_MODE_1_REG, 0x010000);
+	iwl_write_prph(priv, ALM_SCD_SBYP_MODE_2_REG, 0x030002);
+	iwl_write_prph(priv, ALM_SCD_TXF4MF_REG, 0x000004);
+	iwl_write_prph(priv, ALM_SCD_TXF5MF_REG, 0x000005);
 
-	iwl3945_write_direct32(priv, FH39_TSSR_CBB_BASE,
+	iwl_write_direct32(priv, FH39_TSSR_CBB_BASE,
 			     priv->shared_phys);
 
-	iwl3945_write_direct32(priv, FH39_TSSR_MSG_CONFIG,
+	iwl_write_direct32(priv, FH39_TSSR_MSG_CONFIG,
 		FH39_TSSR_TX_MSG_CONFIG_REG_VAL_SNOOP_RD_TXPD_ON |
 		FH39_TSSR_TX_MSG_CONFIG_REG_VAL_ORDER_RD_TXPD_ON |
 		FH39_TSSR_TX_MSG_CONFIG_REG_VAL_MAX_FRAG_SIZE_128B |
@@ -1036,7 +1036,7 @@ static int iwl3945_tx_reset(struct iwl_priv *priv)
 		FH39_TSSR_TX_MSG_CONFIG_REG_VAL_ORDER_RSP_WAIT_TH |
 		FH39_TSSR_TX_MSG_CONFIG_REG_VAL_RSP_WAIT_TH);
 
-	iwl3945_release_nic_access(priv);
+	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return 0;
@@ -1088,12 +1088,12 @@ int iwl3945_hw_nic_init(struct iwl_priv *priv)
 	iwl3945_power_init_handle(priv);
 
 	spin_lock_irqsave(&priv->lock, flags);
-	iwl3945_set_bit(priv, CSR_ANA_PLL_CFG, CSR39_ANA_PLL_CFG_VAL);
-	iwl3945_set_bit(priv, CSR_GIO_CHICKEN_BITS,
+	iwl_set_bit(priv, CSR_ANA_PLL_CFG, CSR39_ANA_PLL_CFG_VAL);
+	iwl_set_bit(priv, CSR_GIO_CHICKEN_BITS,
 		    CSR_GIO_CHICKEN_BITS_REG_BIT_L1A_NO_L0S_RX);
 
-	iwl3945_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
-	rc = iwl3945_poll_direct_bit(priv, CSR_GP_CNTRL,
+	iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+	rc = iwl_poll_direct_bit(priv, CSR_GP_CNTRL,
 			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
 	if (rc < 0) {
 		spin_unlock_irqrestore(&priv->lock, flags);
@@ -1101,18 +1101,18 @@ int iwl3945_hw_nic_init(struct iwl_priv *priv)
 		return rc;
 	}
 
-	rc = iwl3945_grab_nic_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return rc;
 	}
-	iwl3945_write_prph(priv, APMG_CLK_EN_REG,
+	iwl_write_prph(priv, APMG_CLK_EN_REG,
 				 APMG_CLK_VAL_DMA_CLK_RQT |
 				 APMG_CLK_VAL_BSM_CLK_RQT);
 	udelay(20);
-	iwl3945_set_bits_prph(priv, APMG_PCIDEV_STT_REG,
+	iwl_set_bits_prph(priv, APMG_PCIDEV_STT_REG,
 				    APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
-	iwl3945_release_nic_access(priv);
+	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	/* Determine HW type */
@@ -1128,17 +1128,17 @@ int iwl3945_hw_nic_init(struct iwl_priv *priv)
 		IWL_DEBUG_INFO("RTP type \n");
 	else if (rev_id & PCI_CFG_REV_ID_BIT_BASIC_SKU) {
 		IWL_DEBUG_INFO("3945 RADIO-MB type\n");
-		iwl3945_set_bit(priv, CSR_HW_IF_CONFIG_REG,
+		iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
 			    CSR39_HW_IF_CONFIG_REG_BIT_3945_MB);
 	} else {
 		IWL_DEBUG_INFO("3945 RADIO-MM type\n");
-		iwl3945_set_bit(priv, CSR_HW_IF_CONFIG_REG,
+		iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
 			    CSR39_HW_IF_CONFIG_REG_BIT_3945_MM);
 	}
 
 	if (EEPROM_SKU_CAP_OP_MODE_MRC == priv->eeprom39.sku_cap) {
 		IWL_DEBUG_INFO("SKU OP mode is mrc\n");
-		iwl3945_set_bit(priv, CSR_HW_IF_CONFIG_REG,
+		iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
 			    CSR39_HW_IF_CONFIG_REG_BIT_SKU_MRC);
 	} else
 		IWL_DEBUG_INFO("SKU OP mode is basic\n");
@@ -1146,24 +1146,24 @@ int iwl3945_hw_nic_init(struct iwl_priv *priv)
 	if ((priv->eeprom39.board_revision & 0xF0) == 0xD0) {
 		IWL_DEBUG_INFO("3945ABG revision is 0x%X\n",
 			       priv->eeprom39.board_revision);
-		iwl3945_set_bit(priv, CSR_HW_IF_CONFIG_REG,
+		iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
 			    CSR39_HW_IF_CONFIG_REG_BIT_BOARD_TYPE);
 	} else {
 		IWL_DEBUG_INFO("3945ABG revision is 0x%X\n",
 			       priv->eeprom39.board_revision);
-		iwl3945_clear_bit(priv, CSR_HW_IF_CONFIG_REG,
+		iwl_clear_bit(priv, CSR_HW_IF_CONFIG_REG,
 			      CSR39_HW_IF_CONFIG_REG_BIT_BOARD_TYPE);
 	}
 
 	if (priv->eeprom39.almgor_m_version <= 1) {
-		iwl3945_set_bit(priv, CSR_HW_IF_CONFIG_REG,
+		iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
 			    CSR39_HW_IF_CONFIG_REG_BITS_SILICON_TYPE_A);
 		IWL_DEBUG_INFO("Card M type A version is 0x%X\n",
 			       priv->eeprom39.almgor_m_version);
 	} else {
 		IWL_DEBUG_INFO("Card M type B version is 0x%X\n",
 			       priv->eeprom39.almgor_m_version);
-		iwl3945_set_bit(priv, CSR_HW_IF_CONFIG_REG,
+		iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
 			    CSR39_HW_IF_CONFIG_REG_BITS_SILICON_TYPE_B);
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -1195,13 +1195,13 @@ int iwl3945_hw_nic_init(struct iwl_priv *priv)
 	iwl3945_rx_queue_update_write_ptr(priv, rxq);
 	*/
 
-	rc = iwl3945_grab_nic_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return rc;
 	}
-	iwl3945_write_direct32(priv, FH39_RCSR_WPTR(0), rxq->write & ~7);
-	iwl3945_release_nic_access(priv);
+	iwl_write_direct32(priv, FH39_RCSR_WPTR(0), rxq->write & ~7);
+	iwl_release_nic_access(priv);
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -1234,24 +1234,24 @@ void iwl3945_hw_txq_ctx_stop(struct iwl_priv *priv)
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	if (iwl3945_grab_nic_access(priv)) {
+	if (iwl_grab_nic_access(priv)) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		iwl3945_hw_txq_ctx_free(priv);
 		return;
 	}
 
 	/* stop SCD */
-	iwl3945_write_prph(priv, ALM_SCD_MODE_REG, 0);
+	iwl_write_prph(priv, ALM_SCD_MODE_REG, 0);
 
 	/* reset TFD queues */
 	for (txq_id = 0; txq_id < TFD_QUEUE_MAX; txq_id++) {
-		iwl3945_write_direct32(priv, FH39_TCSR_CONFIG(txq_id), 0x0);
-		iwl3945_poll_direct_bit(priv, FH39_TSSR_TX_STATUS,
+		iwl_write_direct32(priv, FH39_TCSR_CONFIG(txq_id), 0x0);
+		iwl_poll_direct_bit(priv, FH39_TSSR_TX_STATUS,
 				FH39_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(txq_id),
 				1000);
 	}
 
-	iwl3945_release_nic_access(priv);
+	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	iwl3945_hw_txq_ctx_free(priv);
@@ -1266,16 +1266,16 @@ int iwl3945_hw_nic_stop_master(struct iwl_priv *priv)
 	spin_lock_irqsave(&priv->lock, flags);
 
 	/* set stop master bit */
-	iwl3945_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_STOP_MASTER);
+	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_STOP_MASTER);
 
-	reg_val = iwl3945_read32(priv, CSR_GP_CNTRL);
+	reg_val = iwl_read32(priv, CSR_GP_CNTRL);
 
 	if (CSR_GP_CNTRL_REG_FLAG_MAC_POWER_SAVE ==
 	    (reg_val & CSR_GP_CNTRL_REG_MSK_POWER_SAVE_TYPE))
 		IWL_DEBUG_INFO("Card in power save, master is already "
 			       "stopped\n");
 	else {
-		rc = iwl3945_poll_direct_bit(priv, CSR_RESET,
+		rc = iwl_poll_direct_bit(priv, CSR_RESET,
 				  CSR_RESET_REG_FLAG_MASTER_DISABLED, 100);
 		if (rc < 0) {
 			spin_unlock_irqrestore(&priv->lock, flags);
@@ -1298,37 +1298,37 @@ int iwl3945_hw_nic_reset(struct iwl_priv *priv)
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	iwl3945_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
+	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
 
-	iwl3945_poll_direct_bit(priv, CSR_GP_CNTRL,
+	iwl_poll_direct_bit(priv, CSR_GP_CNTRL,
 			 CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
 
-	rc = iwl3945_grab_nic_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (!rc) {
-		iwl3945_write_prph(priv, APMG_CLK_CTRL_REG,
+		iwl_write_prph(priv, APMG_CLK_CTRL_REG,
 					 APMG_CLK_VAL_BSM_CLK_RQT);
 
 		udelay(10);
 
-		iwl3945_set_bit(priv, CSR_GP_CNTRL,
+		iwl_set_bit(priv, CSR_GP_CNTRL,
 			    CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
 
-		iwl3945_write_prph(priv, APMG_RTC_INT_MSK_REG, 0x0);
-		iwl3945_write_prph(priv, APMG_RTC_INT_STT_REG,
+		iwl_write_prph(priv, APMG_RTC_INT_MSK_REG, 0x0);
+		iwl_write_prph(priv, APMG_RTC_INT_STT_REG,
 					0xFFFFFFFF);
 
 		/* enable DMA */
-		iwl3945_write_prph(priv, APMG_CLK_EN_REG,
+		iwl_write_prph(priv, APMG_CLK_EN_REG,
 					 APMG_CLK_VAL_DMA_CLK_RQT |
 					 APMG_CLK_VAL_BSM_CLK_RQT);
 		udelay(10);
 
-		iwl3945_set_bits_prph(priv, APMG_PS_CTRL_REG,
+		iwl_set_bits_prph(priv, APMG_PS_CTRL_REG,
 				APMG_PS_CTRL_VAL_RESET_REQ);
 		udelay(5);
-		iwl3945_clear_bits_prph(priv, APMG_PS_CTRL_REG,
+		iwl_clear_bits_prph(priv, APMG_PS_CTRL_REG,
 				APMG_PS_CTRL_VAL_RESET_REQ);
-		iwl3945_release_nic_access(priv);
+		iwl_release_nic_access(priv);
 	}
 
 	/* Clear the 'host command active' bit... */
@@ -1359,7 +1359,7 @@ static inline int iwl3945_hw_reg_temp_out_of_range(int temperature)
 
 int iwl3945_hw_get_temperature(struct iwl_priv *priv)
 {
-	return iwl3945_read32(priv, CSR_UCODE_DRV_GP2);
+	return iwl_read32(priv, CSR_UCODE_DRV_GP2);
 }
 
 /**
@@ -2291,19 +2291,19 @@ int iwl3945_hw_rxq_stop(struct iwl_priv *priv)
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl3945_grab_nic_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return rc;
 	}
 
-	iwl3945_write_direct32(priv, FH39_RCSR_CONFIG(0), 0);
-	rc = iwl3945_poll_direct_bit(priv, FH39_RSSR_STATUS,
+	iwl_write_direct32(priv, FH39_RCSR_CONFIG(0), 0);
+	rc = iwl_poll_direct_bit(priv, FH39_RSSR_STATUS,
 			FH39_RSSR_CHNL0_RX_STATUS_CHNL_IDLE, 1000);
 	if (rc < 0)
 		IWL_ERROR("Can't stop Rx DMA.\n");
 
-	iwl3945_release_nic_access(priv);
+	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return 0;
@@ -2320,24 +2320,24 @@ int iwl3945_hw_tx_queue_init(struct iwl_priv *priv, struct iwl3945_tx_queue *txq
 	shared_data->tx_base_ptr[txq_id] = cpu_to_le32((u32)txq->q.dma_addr);
 
 	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl3945_grab_nic_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return rc;
 	}
-	iwl3945_write_direct32(priv, FH39_CBCC_CTRL(txq_id), 0);
-	iwl3945_write_direct32(priv, FH39_CBCC_BASE(txq_id), 0);
+	iwl_write_direct32(priv, FH39_CBCC_CTRL(txq_id), 0);
+	iwl_write_direct32(priv, FH39_CBCC_BASE(txq_id), 0);
 
-	iwl3945_write_direct32(priv, FH39_TCSR_CONFIG(txq_id),
+	iwl_write_direct32(priv, FH39_TCSR_CONFIG(txq_id),
 		FH39_TCSR_TX_CONFIG_REG_VAL_CIRQ_RTC_NOINT |
 		FH39_TCSR_TX_CONFIG_REG_VAL_MSG_MODE_TXF |
 		FH39_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_IFTFD |
 		FH39_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE_VAL |
 		FH39_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE);
-	iwl3945_release_nic_access(priv);
+	iwl_release_nic_access(priv);
 
 	/* fake read to flush all prev. writes */
-	iwl3945_read32(priv, FH39_TSSR_CBB_BASE);
+	iwl_read32(priv, FH39_TSSR_CBB_BASE);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 098ac76..63bf832 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -397,6 +397,6 @@ extern const struct iwl_channel_info *iwl3945_get_channel_info(
 extern int iwl3945_rs_next_rate(struct iwl_priv *priv, int rate);
 
 /* Requires full declaration of iwl_priv before including */
-#include "iwl-3945-io.h"
+#include "iwl-io.h"
 
 #endif
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index fbf800f..0ecb8b8 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1413,7 +1413,7 @@ static void get_eeprom_mac(struct iwl_priv *priv, u8 *mac)
  */
 static inline int iwl3945_eeprom_acquire_semaphore(struct iwl_priv *priv)
 {
-	_iwl3945_clear_bit(priv, CSR_EEPROM_GP, CSR_EEPROM_GP_IF_OWNER_MSK);
+	_iwl_clear_bit(priv, CSR_EEPROM_GP, CSR_EEPROM_GP_IF_OWNER_MSK);
 	return 0;
 }
 
@@ -1427,7 +1427,7 @@ static inline int iwl3945_eeprom_acquire_semaphore(struct iwl_priv *priv)
 int iwl3945_eeprom_init(struct iwl_priv *priv)
 {
 	u16 *e = (u16 *)&priv->eeprom39;
-	u32 gp = iwl3945_read32(priv, CSR_EEPROM_GP);
+	u32 gp = iwl_read32(priv, CSR_EEPROM_GP);
 	int sz = sizeof(priv->eeprom39);
 	int ret;
 	u16 addr;
@@ -1454,10 +1454,10 @@ int iwl3945_eeprom_init(struct iwl_priv *priv)
 	for (addr = 0; addr < sz; addr += sizeof(u16)) {
 		u32 r;
 
-		_iwl3945_write32(priv, CSR_EEPROM_REG,
+		_iwl_write32(priv, CSR_EEPROM_REG,
 				 CSR_EEPROM_REG_MSK_ADDR & (addr << 1));
-		_iwl3945_clear_bit(priv, CSR_EEPROM_REG, CSR_EEPROM_REG_BIT_CMD);
-		ret = iwl3945_poll_direct_bit(priv, CSR_EEPROM_REG,
+		_iwl_clear_bit(priv, CSR_EEPROM_REG, CSR_EEPROM_REG_BIT_CMD);
+		ret = iwl_poll_direct_bit(priv, CSR_EEPROM_REG,
 					      CSR_EEPROM_REG_READ_VALID_MSK,
 					      IWL_EEPROM_ACCESS_TIMEOUT);
 		if (ret < 0) {
@@ -1465,7 +1465,7 @@ int iwl3945_eeprom_init(struct iwl_priv *priv)
 			return ret;
 		}
 
-		r = _iwl3945_read_direct32(priv, CSR_EEPROM_REG);
+		r = _iwl_read_direct32(priv, CSR_EEPROM_REG);
 		e[addr / 2] = le16_to_cpu((__force __le16)(r >> 16));
 	}
 
@@ -2669,7 +2669,7 @@ static void iwl3945_radio_kill_sw(struct iwl_priv *priv, int disable_radio)
 		/* FIXME: This is a workaround for AP */
 		if (priv->iw_mode != NL80211_IFTYPE_AP) {
 			spin_lock_irqsave(&priv->lock, flags);
-			iwl3945_write32(priv, CSR_UCODE_DRV_GP1_SET,
+			iwl_write32(priv, CSR_UCODE_DRV_GP1_SET,
 				    CSR_UCODE_SW_BIT_RFKILL);
 			spin_unlock_irqrestore(&priv->lock, flags);
 			iwl3945_send_card_state(priv, CARD_STATE_CMD_DISABLE, 0);
@@ -2679,7 +2679,7 @@ static void iwl3945_radio_kill_sw(struct iwl_priv *priv, int disable_radio)
 	}
 
 	spin_lock_irqsave(&priv->lock, flags);
-	iwl3945_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
 
 	clear_bit(STATUS_RF_KILL_SW, &priv->status);
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -2688,9 +2688,9 @@ static void iwl3945_radio_kill_sw(struct iwl_priv *priv, int disable_radio)
 	msleep(10);
 
 	spin_lock_irqsave(&priv->lock, flags);
-	iwl3945_read32(priv, CSR_UCODE_DRV_GP1);
-	if (!iwl3945_grab_nic_access(priv))
-		iwl3945_release_nic_access(priv);
+	iwl_read32(priv, CSR_UCODE_DRV_GP1);
+	if (!iwl_grab_nic_access(priv))
+		iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	if (test_bit(STATUS_RF_KILL_HW, &priv->status)) {
@@ -3157,7 +3157,7 @@ static void iwl3945_rx_card_state_notif(struct iwl_priv *priv,
 			  (flags & HW_CARD_DISABLED) ? "Kill" : "On",
 			  (flags & SW_CARD_DISABLED) ? "Kill" : "On");
 
-	iwl3945_write32(priv, CSR_UCODE_DRV_GP1_SET,
+	iwl_write32(priv, CSR_UCODE_DRV_GP1_SET,
 		    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
 
 	if (flags & HW_CARD_DISABLED)
@@ -3392,27 +3392,27 @@ int iwl3945_rx_queue_update_write_ptr(struct iwl_priv *priv, struct iwl_rx_queue
 
 	/* If power-saving is in use, make sure device is awake */
 	if (test_bit(STATUS_POWER_PMI, &priv->status)) {
-		reg = iwl3945_read32(priv, CSR_UCODE_DRV_GP1);
+		reg = iwl_read32(priv, CSR_UCODE_DRV_GP1);
 
 		if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
-			iwl3945_set_bit(priv, CSR_GP_CNTRL,
+			iwl_set_bit(priv, CSR_GP_CNTRL,
 				    CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 			goto exit_unlock;
 		}
 
-		rc = iwl3945_grab_nic_access(priv);
+		rc = iwl_grab_nic_access(priv);
 		if (rc)
 			goto exit_unlock;
 
 		/* Device expects a multiple of 8 */
-		iwl3945_write_direct32(priv, FH39_RSCSR_CHNL0_WPTR,
+		iwl_write_direct32(priv, FH39_RSCSR_CHNL0_WPTR,
 				     q->write & ~0x7);
-		iwl3945_release_nic_access(priv);
+		iwl_release_nic_access(priv);
 
 	/* Else device is assumed to be awake */
 	} else
 		/* Device expects a multiple of 8 */
-		iwl3945_write32(priv, FH39_RSCSR_CHNL0_WPTR, q->write & ~0x7);
+		iwl_write32(priv, FH39_RSCSR_CHNL0_WPTR, q->write & ~0x7);
 
 
 	q->need_update = 0;
@@ -3849,27 +3849,27 @@ static int iwl3945_tx_queue_update_write_ptr(struct iwl_priv *priv,
 		/* wake up nic if it's powered down ...
 		 * uCode will wake up, and interrupt us again, so next
 		 * time we'll skip this part. */
-		reg = iwl3945_read32(priv, CSR_UCODE_DRV_GP1);
+		reg = iwl_read32(priv, CSR_UCODE_DRV_GP1);
 
 		if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
 			IWL_DEBUG_INFO("Requesting wakeup, GP1 = 0x%x\n", reg);
-			iwl3945_set_bit(priv, CSR_GP_CNTRL,
+			iwl_set_bit(priv, CSR_GP_CNTRL,
 				    CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 			return rc;
 		}
 
 		/* restore this queue's parameters in nic hardware. */
-		rc = iwl3945_grab_nic_access(priv);
+		rc = iwl_grab_nic_access(priv);
 		if (rc)
 			return rc;
-		iwl3945_write_direct32(priv, HBUS_TARG_WRPTR,
+		iwl_write_direct32(priv, HBUS_TARG_WRPTR,
 				     txq->q.write_ptr | (txq_id << 8));
-		iwl3945_release_nic_access(priv);
+		iwl_release_nic_access(priv);
 
 	/* else not in power-save mode, uCode will never sleep when we're
 	 * trying to tx (during RFKILL, we're not trying to tx). */
 	} else
-		iwl3945_write32(priv, HBUS_TARG_WRPTR,
+		iwl_write32(priv, HBUS_TARG_WRPTR,
 			    txq->q.write_ptr | (txq_id << 8));
 
 	txq->need_update = 0;
@@ -3905,7 +3905,7 @@ static void iwl3945_enable_interrupts(struct iwl_priv *priv)
 {
 	IWL_DEBUG_ISR("Enabling interrupts\n");
 	set_bit(STATUS_INT_ENABLED, &priv->status);
-	iwl3945_write32(priv, CSR_INT_MASK, CSR_INI_SET_MASK);
+	iwl_write32(priv, CSR_INT_MASK, CSR_INI_SET_MASK);
 }
 
 
@@ -3923,12 +3923,12 @@ static inline void iwl3945_disable_interrupts(struct iwl_priv *priv)
 	clear_bit(STATUS_INT_ENABLED, &priv->status);
 
 	/* disable interrupts from uCode/NIC to host */
-	iwl3945_write32(priv, CSR_INT_MASK, 0x00000000);
+	iwl_write32(priv, CSR_INT_MASK, 0x00000000);
 
 	/* acknowledge/clear/reset any interrupts still pending
 	 * from uCode or flow handler (Rx/Tx DMA) */
-	iwl3945_write32(priv, CSR_INT, 0xffffffff);
-	iwl3945_write32(priv, CSR_FH_INT_STATUS, 0xffffffff);
+	iwl_write32(priv, CSR_INT, 0xffffffff);
+	iwl_write32(priv, CSR_FH_INT_STATUS, 0xffffffff);
 	IWL_DEBUG_ISR("Disabled interrupts\n");
 }
 
@@ -3969,13 +3969,13 @@ static void iwl3945_dump_nic_error_log(struct iwl_priv *priv)
 		return;
 	}
 
-	rc = iwl3945_grab_nic_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc) {
 		IWL_WARNING("Can not read from adapter at this time.\n");
 		return;
 	}
 
-	count = iwl3945_read_targ_mem(priv, base);
+	count = iwl_read_targ_mem(priv, base);
 
 	if (ERROR_START_OFFSET <= count * ERROR_ELEM_SIZE) {
 		IWL_ERROR("Start IWL Error Log Dump:\n");
@@ -3987,19 +3987,19 @@ static void iwl3945_dump_nic_error_log(struct iwl_priv *priv)
 	for (i = ERROR_START_OFFSET;
 	     i < (count * ERROR_ELEM_SIZE) + ERROR_START_OFFSET;
 	     i += ERROR_ELEM_SIZE) {
-		desc = iwl3945_read_targ_mem(priv, base + i);
+		desc = iwl_read_targ_mem(priv, base + i);
 		time =
-		    iwl3945_read_targ_mem(priv, base + i + 1 * sizeof(u32));
+		    iwl_read_targ_mem(priv, base + i + 1 * sizeof(u32));
 		blink1 =
-		    iwl3945_read_targ_mem(priv, base + i + 2 * sizeof(u32));
+		    iwl_read_targ_mem(priv, base + i + 2 * sizeof(u32));
 		blink2 =
-		    iwl3945_read_targ_mem(priv, base + i + 3 * sizeof(u32));
+		    iwl_read_targ_mem(priv, base + i + 3 * sizeof(u32));
 		ilink1 =
-		    iwl3945_read_targ_mem(priv, base + i + 4 * sizeof(u32));
+		    iwl_read_targ_mem(priv, base + i + 4 * sizeof(u32));
 		ilink2 =
-		    iwl3945_read_targ_mem(priv, base + i + 5 * sizeof(u32));
+		    iwl_read_targ_mem(priv, base + i + 5 * sizeof(u32));
 		data1 =
-		    iwl3945_read_targ_mem(priv, base + i + 6 * sizeof(u32));
+		    iwl_read_targ_mem(priv, base + i + 6 * sizeof(u32));
 
 		IWL_ERROR
 		    ("%-13s (#%d) %010u 0x%05X 0x%05X 0x%05X 0x%05X %u\n\n",
@@ -4007,7 +4007,7 @@ static void iwl3945_dump_nic_error_log(struct iwl_priv *priv)
 		     ilink1, ilink2, data1);
 	}
 
-	iwl3945_release_nic_access(priv);
+	iwl_release_nic_access(priv);
 
 }
 
@@ -4016,7 +4016,7 @@ static void iwl3945_dump_nic_error_log(struct iwl_priv *priv)
 /**
  * iwl3945_print_event_log - Dump error event log to syslog
  *
- * NOTE: Must be called with iwl3945_grab_nic_access() already obtained!
+ * NOTE: Must be called with iwl_grab_nic_access() already obtained!
  */
 static void iwl3945_print_event_log(struct iwl_priv *priv, u32 start_idx,
 				u32 num_events, u32 mode)
@@ -4042,14 +4042,14 @@ static void iwl3945_print_event_log(struct iwl_priv *priv, u32 start_idx,
 	/* "time" is actually "data" for mode 0 (no timestamp).
 	 * place event id # at far right for easier visual parsing. */
 	for (i = 0; i < num_events; i++) {
-		ev = iwl3945_read_targ_mem(priv, ptr);
+		ev = iwl_read_targ_mem(priv, ptr);
 		ptr += sizeof(u32);
-		time = iwl3945_read_targ_mem(priv, ptr);
+		time = iwl_read_targ_mem(priv, ptr);
 		ptr += sizeof(u32);
 		if (mode == 0)
 			IWL_ERROR("0x%08x\t%04u\n", time, ev); /* data, ev */
 		else {
-			data = iwl3945_read_targ_mem(priv, ptr);
+			data = iwl_read_targ_mem(priv, ptr);
 			ptr += sizeof(u32);
 			IWL_ERROR("%010u\t0x%08x\t%04u\n", time, data, ev);
 		}
@@ -4072,24 +4072,24 @@ static void iwl3945_dump_nic_event_log(struct iwl_priv *priv)
 		return;
 	}
 
-	rc = iwl3945_grab_nic_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc) {
 		IWL_WARNING("Can not read from adapter at this time.\n");
 		return;
 	}
 
 	/* event log header */
-	capacity = iwl3945_read_targ_mem(priv, base);
-	mode = iwl3945_read_targ_mem(priv, base + (1 * sizeof(u32)));
-	num_wraps = iwl3945_read_targ_mem(priv, base + (2 * sizeof(u32)));
-	next_entry = iwl3945_read_targ_mem(priv, base + (3 * sizeof(u32)));
+	capacity = iwl_read_targ_mem(priv, base);
+	mode = iwl_read_targ_mem(priv, base + (1 * sizeof(u32)));
+	num_wraps = iwl_read_targ_mem(priv, base + (2 * sizeof(u32)));
+	next_entry = iwl_read_targ_mem(priv, base + (3 * sizeof(u32)));
 
 	size = num_wraps ? capacity : next_entry;
 
 	/* bail out if nothing in log */
 	if (size == 0) {
 		IWL_ERROR("Start IWL Event Log Dump: nothing in log\n");
-		iwl3945_release_nic_access(priv);
+		iwl_release_nic_access(priv);
 		return;
 	}
 
@@ -4105,7 +4105,7 @@ static void iwl3945_dump_nic_event_log(struct iwl_priv *priv)
 	/* (then/else) start at top of log */
 	iwl3945_print_event_log(priv, 0, next_entry, mode);
 
-	iwl3945_release_nic_access(priv);
+	iwl_release_nic_access(priv);
 }
 
 /**
@@ -4177,19 +4177,19 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 	/* Ack/clear/reset pending uCode interrupts.
 	 * Note:  Some bits in CSR_INT are "OR" of bits in CSR_FH_INT_STATUS,
 	 *  and will clear only when CSR_FH_INT_STATUS gets cleared. */
-	inta = iwl3945_read32(priv, CSR_INT);
-	iwl3945_write32(priv, CSR_INT, inta);
+	inta = iwl_read32(priv, CSR_INT);
+	iwl_write32(priv, CSR_INT, inta);
 
 	/* Ack/clear/reset pending flow-handler (DMA) interrupts.
 	 * Any new interrupts that happen after this, either while we're
 	 * in this tasklet, or later, will show up in next ISR/tasklet. */
-	inta_fh = iwl3945_read32(priv, CSR_FH_INT_STATUS);
-	iwl3945_write32(priv, CSR_FH_INT_STATUS, inta_fh);
+	inta_fh = iwl_read32(priv, CSR_FH_INT_STATUS);
+	iwl_write32(priv, CSR_FH_INT_STATUS, inta_fh);
 
 #ifdef CONFIG_IWL3945_DEBUG
 	if (priv->debug_level & IWL_DL_ISR) {
 		/* just for debug */
-		inta_mask = iwl3945_read32(priv, CSR_INT_MASK);
+		inta_mask = iwl_read32(priv, CSR_INT_MASK);
 		IWL_DEBUG_ISR("inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
 			      inta, inta_mask, inta_fh);
 	}
@@ -4268,11 +4268,11 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 	if (inta & CSR_INT_BIT_FH_TX) {
 		IWL_DEBUG_ISR("Tx interrupt\n");
 
-		iwl3945_write32(priv, CSR_FH_INT_STATUS, (1 << 6));
-		if (!iwl3945_grab_nic_access(priv)) {
-			iwl3945_write_direct32(priv, FH39_TCSR_CREDIT
+		iwl_write32(priv, CSR_FH_INT_STATUS, (1 << 6));
+		if (!iwl_grab_nic_access(priv)) {
+			iwl_write_direct32(priv, FH39_TCSR_CREDIT
 					     (FH39_SRVC_CHNL), 0x0);
-			iwl3945_release_nic_access(priv);
+			iwl_release_nic_access(priv);
 		}
 		handled |= CSR_INT_BIT_FH_TX;
 	}
@@ -4293,9 +4293,9 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 
 #ifdef CONFIG_IWL3945_DEBUG
 	if (priv->debug_level & (IWL_DL_ISR)) {
-		inta = iwl3945_read32(priv, CSR_INT);
-		inta_mask = iwl3945_read32(priv, CSR_INT_MASK);
-		inta_fh = iwl3945_read32(priv, CSR_FH_INT_STATUS);
+		inta = iwl_read32(priv, CSR_INT);
+		inta_mask = iwl_read32(priv, CSR_INT_MASK);
+		inta_fh = iwl_read32(priv, CSR_FH_INT_STATUS);
 		IWL_DEBUG_ISR("End inta 0x%08x, enabled 0x%08x, fh 0x%08x, "
 			"flags 0x%08lx\n", inta, inta_mask, inta_fh, flags);
 	}
@@ -4317,12 +4317,12 @@ static irqreturn_t iwl3945_isr(int irq, void *data)
 	 *    back-to-back ISRs and sporadic interrupts from our NIC.
 	 * If we have something to service, the tasklet will re-enable ints.
 	 * If we *don't* have something, we'll re-enable before leaving here. */
-	inta_mask = iwl3945_read32(priv, CSR_INT_MASK);  /* just for debug */
-	iwl3945_write32(priv, CSR_INT_MASK, 0x00000000);
+	inta_mask = iwl_read32(priv, CSR_INT_MASK);  /* just for debug */
+	iwl_write32(priv, CSR_INT_MASK, 0x00000000);
 
 	/* Discover which interrupts are active/pending */
-	inta = iwl3945_read32(priv, CSR_INT);
-	inta_fh = iwl3945_read32(priv, CSR_FH_INT_STATUS);
+	inta = iwl_read32(priv, CSR_INT);
+	inta_fh = iwl_read32(priv, CSR_FH_INT_STATUS);
 
 	/* Ignore interrupt if there's nothing in NIC to service.
 	 * This may be due to IRQ shared with another device,
@@ -4947,11 +4947,11 @@ static int iwl3945_verify_inst_full(struct iwl_priv *priv, __le32 *image, u32 le
 
 	IWL_DEBUG_INFO("ucode inst image size is %u\n", len);
 
-	rc = iwl3945_grab_nic_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc)
 		return rc;
 
-	iwl3945_write_direct32(priv, HBUS_TARG_MEM_RADDR,
+	iwl_write_direct32(priv, HBUS_TARG_MEM_RADDR,
 			       IWL39_RTC_INST_LOWER_BOUND);
 
 	errcnt = 0;
@@ -4959,7 +4959,7 @@ static int iwl3945_verify_inst_full(struct iwl_priv *priv, __le32 *image, u32 le
 		/* read data comes through single port, auto-incr addr */
 		/* NOTE: Use the debugless read so we don't flood kernel log
 		 * if IWL_DL_IO is set */
-		val = _iwl3945_read_direct32(priv, HBUS_TARG_MEM_RDAT);
+		val = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
 		if (val != le32_to_cpu(*image)) {
 			IWL_ERROR("uCode INST section is invalid at "
 				  "offset 0x%x, is 0x%x, s/b 0x%x\n",
@@ -4971,7 +4971,7 @@ static int iwl3945_verify_inst_full(struct iwl_priv *priv, __le32 *image, u32 le
 		}
 	}
 
-	iwl3945_release_nic_access(priv);
+	iwl_release_nic_access(priv);
 
 	if (!errcnt)
 		IWL_DEBUG_INFO("ucode image in INSTRUCTION memory is good\n");
@@ -4994,7 +4994,7 @@ static int iwl3945_verify_inst_sparse(struct iwl_priv *priv, __le32 *image, u32
 
 	IWL_DEBUG_INFO("ucode inst image size is %u\n", len);
 
-	rc = iwl3945_grab_nic_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc)
 		return rc;
 
@@ -5002,9 +5002,9 @@ static int iwl3945_verify_inst_sparse(struct iwl_priv *priv, __le32 *image, u32
 		/* read data comes through single port, auto-incr addr */
 		/* NOTE: Use the debugless read so we don't flood kernel log
 		 * if IWL_DL_IO is set */
-		iwl3945_write_direct32(priv, HBUS_TARG_MEM_RADDR,
+		iwl_write_direct32(priv, HBUS_TARG_MEM_RADDR,
 			i + IWL39_RTC_INST_LOWER_BOUND);
-		val = _iwl3945_read_direct32(priv, HBUS_TARG_MEM_RDAT);
+		val = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
 		if (val != le32_to_cpu(*image)) {
 #if 0 /* Enable this if you want to see details */
 			IWL_ERROR("uCode INST section is invalid at "
@@ -5018,7 +5018,7 @@ static int iwl3945_verify_inst_sparse(struct iwl_priv *priv, __le32 *image, u32
 		}
 	}
 
-	iwl3945_release_nic_access(priv);
+	iwl_release_nic_access(priv);
 
 	return rc;
 }
@@ -5085,11 +5085,11 @@ static int iwl3945_verify_bsm(struct iwl_priv *priv)
 	IWL_DEBUG_INFO("Begin verify bsm\n");
 
 	/* verify BSM SRAM contents */
-	val = iwl3945_read_prph(priv, BSM_WR_DWCOUNT_REG);
+	val = iwl_read_prph(priv, BSM_WR_DWCOUNT_REG);
 	for (reg = BSM_SRAM_LOWER_BOUND;
 	     reg < BSM_SRAM_LOWER_BOUND + len;
 	     reg += sizeof(u32), image++) {
-		val = iwl3945_read_prph(priv, reg);
+		val = iwl_read_prph(priv, reg);
 		if (val != le32_to_cpu(*image)) {
 			IWL_ERROR("BSM uCode verification failed at "
 				  "addr 0x%08X+%u (of %u), is 0x%x, s/b 0x%x\n",
@@ -5166,42 +5166,42 @@ static int iwl3945_load_bsm(struct iwl_priv *priv)
 	inst_len = priv->ucode_init.len;
 	data_len = priv->ucode_init_data.len;
 
-	rc = iwl3945_grab_nic_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc)
 		return rc;
 
-	iwl3945_write_prph(priv, BSM_DRAM_INST_PTR_REG, pinst);
-	iwl3945_write_prph(priv, BSM_DRAM_DATA_PTR_REG, pdata);
-	iwl3945_write_prph(priv, BSM_DRAM_INST_BYTECOUNT_REG, inst_len);
-	iwl3945_write_prph(priv, BSM_DRAM_DATA_BYTECOUNT_REG, data_len);
+	iwl_write_prph(priv, BSM_DRAM_INST_PTR_REG, pinst);
+	iwl_write_prph(priv, BSM_DRAM_DATA_PTR_REG, pdata);
+	iwl_write_prph(priv, BSM_DRAM_INST_BYTECOUNT_REG, inst_len);
+	iwl_write_prph(priv, BSM_DRAM_DATA_BYTECOUNT_REG, data_len);
 
 	/* Fill BSM memory with bootstrap instructions */
 	for (reg_offset = BSM_SRAM_LOWER_BOUND;
 	     reg_offset < BSM_SRAM_LOWER_BOUND + len;
 	     reg_offset += sizeof(u32), image++)
-		_iwl3945_write_prph(priv, reg_offset,
+		_iwl_write_prph(priv, reg_offset,
 					  le32_to_cpu(*image));
 
 	rc = iwl3945_verify_bsm(priv);
 	if (rc) {
-		iwl3945_release_nic_access(priv);
+		iwl_release_nic_access(priv);
 		return rc;
 	}
 
 	/* Tell BSM to copy from BSM SRAM into instruction SRAM, when asked */
-	iwl3945_write_prph(priv, BSM_WR_MEM_SRC_REG, 0x0);
-	iwl3945_write_prph(priv, BSM_WR_MEM_DST_REG,
+	iwl_write_prph(priv, BSM_WR_MEM_SRC_REG, 0x0);
+	iwl_write_prph(priv, BSM_WR_MEM_DST_REG,
 				 IWL39_RTC_INST_LOWER_BOUND);
-	iwl3945_write_prph(priv, BSM_WR_DWCOUNT_REG, len / sizeof(u32));
+	iwl_write_prph(priv, BSM_WR_DWCOUNT_REG, len / sizeof(u32));
 
 	/* Load bootstrap code into instruction SRAM now,
 	 *   to prepare to load "initialize" uCode */
-	iwl3945_write_prph(priv, BSM_WR_CTRL_REG,
+	iwl_write_prph(priv, BSM_WR_CTRL_REG,
 		BSM_WR_CTRL_REG_BIT_START);
 
 	/* Wait for load of bootstrap uCode to finish */
 	for (i = 0; i < 100; i++) {
-		done = iwl3945_read_prph(priv, BSM_WR_CTRL_REG);
+		done = iwl_read_prph(priv, BSM_WR_CTRL_REG);
 		if (!(done & BSM_WR_CTRL_REG_BIT_START))
 			break;
 		udelay(10);
@@ -5215,10 +5215,10 @@ static int iwl3945_load_bsm(struct iwl_priv *priv)
 
 	/* Enable future boot loads whenever power management unit triggers it
 	 *   (e.g. when powering back up after power-save shutdown) */
-	iwl3945_write_prph(priv, BSM_WR_CTRL_REG,
+	iwl_write_prph(priv, BSM_WR_CTRL_REG,
 		BSM_WR_CTRL_REG_BIT_START_EN);
 
-	iwl3945_release_nic_access(priv);
+	iwl_release_nic_access(priv);
 
 	return 0;
 }
@@ -5226,7 +5226,7 @@ static int iwl3945_load_bsm(struct iwl_priv *priv)
 static void iwl3945_nic_start(struct iwl_priv *priv)
 {
 	/* Remove all resets to allow NIC to operate */
-	iwl3945_write32(priv, CSR_RESET, 0);
+	iwl_write32(priv, CSR_RESET, 0);
 }
 
 /**
@@ -5487,24 +5487,24 @@ static int iwl3945_set_ucode_ptrs(struct iwl_priv *priv)
 	pdata = priv->ucode_data_backup.p_addr;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl3945_grab_nic_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return rc;
 	}
 
 	/* Tell bootstrap uCode where to find image to load */
-	iwl3945_write_prph(priv, BSM_DRAM_INST_PTR_REG, pinst);
-	iwl3945_write_prph(priv, BSM_DRAM_DATA_PTR_REG, pdata);
-	iwl3945_write_prph(priv, BSM_DRAM_DATA_BYTECOUNT_REG,
+	iwl_write_prph(priv, BSM_DRAM_INST_PTR_REG, pinst);
+	iwl_write_prph(priv, BSM_DRAM_DATA_PTR_REG, pdata);
+	iwl_write_prph(priv, BSM_DRAM_DATA_BYTECOUNT_REG,
 				 priv->ucode_data.len);
 
 	/* Inst byte count must be last to set up, bit 31 signals uCode
 	 *   that all new ptr/size info is in place */
-	iwl3945_write_prph(priv, BSM_DRAM_INST_BYTECOUNT_REG,
+	iwl_write_prph(priv, BSM_DRAM_INST_BYTECOUNT_REG,
 				 priv->ucode_code.len | BSM_DRAM_INST_LOAD);
 
-	iwl3945_release_nic_access(priv);
+	iwl_release_nic_access(priv);
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -5593,15 +5593,15 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 
 	iwl3945_clear_stations_table(priv);
 
-	rc = iwl3945_grab_nic_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc) {
 		IWL_WARNING("Can not read RFKILL status from adapter\n");
 		return;
 	}
 
-	rfkill = iwl3945_read_prph(priv, APMG_RFKILL_REG);
+	rfkill = iwl_read_prph(priv, APMG_RFKILL_REG);
 	IWL_DEBUG_INFO("RFKILL status: 0x%x\n", rfkill);
-	iwl3945_release_nic_access(priv);
+	iwl_release_nic_access(priv);
 
 	if (rfkill & 0x1) {
 		clear_bit(STATUS_RF_KILL_HW, &priv->status);
@@ -5705,7 +5705,7 @@ static void __iwl3945_down(struct iwl_priv *priv)
 		clear_bit(STATUS_EXIT_PENDING, &priv->status);
 
 	/* stop and reset the on-board processor */
-	iwl3945_write32(priv, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
+	iwl_write32(priv, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
 
 	/* tell the device to stop sending interrupts */
 	spin_lock_irqsave(&priv->lock, flags);
@@ -5748,24 +5748,24 @@ static void __iwl3945_down(struct iwl_priv *priv)
 				STATUS_EXIT_PENDING;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	iwl3945_clear_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+	iwl_clear_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	iwl3945_hw_txq_ctx_stop(priv);
 	iwl3945_hw_rxq_stop(priv);
 
 	spin_lock_irqsave(&priv->lock, flags);
-	if (!iwl3945_grab_nic_access(priv)) {
-		iwl3945_write_prph(priv, APMG_CLK_DIS_REG,
+	if (!iwl_grab_nic_access(priv)) {
+		iwl_write_prph(priv, APMG_CLK_DIS_REG,
 					 APMG_CLK_VAL_DMA_CLK_RQT);
-		iwl3945_release_nic_access(priv);
+		iwl_release_nic_access(priv);
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	udelay(5);
 
 	iwl3945_hw_nic_stop_master(priv);
-	iwl3945_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
+	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
 	iwl3945_hw_nic_reset(priv);
 
  exit:
@@ -5811,7 +5811,7 @@ static int __iwl3945_up(struct iwl_priv *priv)
 	}
 
 	/* If platform's RF_KILL switch is NOT set to KILL */
-	if (iwl3945_read32(priv, CSR_GP_CNTRL) &
+	if (iwl_read32(priv, CSR_GP_CNTRL) &
 				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
 		clear_bit(STATUS_RF_KILL_HW, &priv->status);
 	else {
@@ -5822,7 +5822,7 @@ static int __iwl3945_up(struct iwl_priv *priv)
 		}
 	}
 
-	iwl3945_write32(priv, CSR_INT, 0xFFFFFFFF);
+	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
 
 	rc = iwl3945_hw_nic_init(priv);
 	if (rc) {
@@ -5831,17 +5831,17 @@ static int __iwl3945_up(struct iwl_priv *priv)
 	}
 
 	/* make sure rfkill handshake bits are cleared */
-	iwl3945_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
-	iwl3945_write32(priv, CSR_UCODE_DRV_GP1_CLR,
+	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR,
 		    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
 
 	/* clear (again), then enable host interrupts */
-	iwl3945_write32(priv, CSR_INT, 0xFFFFFFFF);
+	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
 	iwl3945_enable_interrupts(priv);
 
 	/* really make sure rfkill handshake bits are cleared */
-	iwl3945_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
-	iwl3945_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
 
 	/* Copy original ucode data image from disk into backup cache.
 	 * This will be used to initialize the on-board processor's
@@ -7837,11 +7837,11 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	pci_write_config_byte(pdev, 0x41, 0x00);
 
 	/* nic init */
-	iwl3945_set_bit(priv, CSR_GIO_CHICKEN_BITS,
+	iwl_set_bit(priv, CSR_GIO_CHICKEN_BITS,
 			CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER);
 
-	iwl3945_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
-	err = iwl3945_poll_direct_bit(priv, CSR_GP_CNTRL,
+	iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+	err = iwl_poll_direct_bit(priv, CSR_GP_CNTRL,
 				CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
 	if (err < 0) {
 		IWL_DEBUG_INFO("Failed to init the card\n");
-- 
1.5.3.6

