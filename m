Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:42941 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757085AbYCYXdp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2008 19:33:45 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/6] iwlwifi: rename iwl-4965-io.h to iwl-io.h
Date: Tue, 25 Mar 2008 16:33:37 -0700
Message-Id: <1206488021-4193-3-git-send-email-reinette.chatre@intel.com> (sfid-20080325_233414_296763_1E966FC8)
In-Reply-To: <1206488021-4193-2-git-send-email-reinette.chatre@intel.com>
References: <1206488021-4193-1-git-send-email-reinette.chatre@intel.com>
 <1206488021-4193-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch renames iwl-4965-io.h back to iw-io.h
it also remove 4965 from all functions it supplies

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-io.h  |  426 ---------------------------
 drivers/net/wireless/iwlwifi/iwl-4965.c     |  215 +++++++-------
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |    8 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c   |   26 +-
 drivers/net/wireless/iwlwifi/iwl-io.h       |  426 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-led.c      |    9 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |  233 ++++++++--------
 8 files changed, 671 insertions(+), 673 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-4965-io.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-io.h

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-io.h b/drivers/net/wireless/iwlwifi/iwl-4965-io.h
deleted file mode 100644
index fba7d03..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-4965-io.h
+++ /dev/null
@@ -1,426 +0,0 @@
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
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- *****************************************************************************/
-
-#ifndef __iwl4965_io_h__
-#define __iwl4965_io_h__
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
- * routines, for example _iwl4965_read_direct32 calls the non-check version of
- * _iwl4965_read32.)
- *
- * These declarations are *extremely* useful in quickly isolating code deltas
- * which result in misconfiguring of the hardware I/O.  In combination with
- * git-bisect and the IO debug level you can quickly determine the specific
- * commit which breaks the IO sequence to the hardware.
- *
- */
-
-#define _iwl4965_write32(priv, ofs, val) writel((val), (priv)->hw_base + (ofs))
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline void __iwl4965_write32(const char *f, u32 l, struct iwl_priv *priv,
-				 u32 ofs, u32 val)
-{
-	IWL_DEBUG_IO("write32(0x%08X, 0x%08X) - %s %d\n", ofs, val, f, l);
-	_iwl4965_write32(priv, ofs, val);
-}
-#define iwl4965_write32(priv, ofs, val) \
-	__iwl4965_write32(__FILE__, __LINE__, priv, ofs, val)
-#else
-#define iwl4965_write32(priv, ofs, val) _iwl4965_write32(priv, ofs, val)
-#endif
-
-#define _iwl4965_read32(priv, ofs) readl((priv)->hw_base + (ofs))
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline u32 __iwl4965_read32(char *f, u32 l, struct iwl_priv *priv, u32 ofs)
-{
-	IWL_DEBUG_IO("read_direct32(0x%08X) - %s %d\n", ofs, f, l);
-	return _iwl4965_read32(priv, ofs);
-}
-#define iwl4965_read32(priv, ofs) __iwl4965_read32(__FILE__, __LINE__, priv, ofs)
-#else
-#define iwl4965_read32(p, o) _iwl4965_read32(p, o)
-#endif
-
-static inline int _iwl4965_poll_bit(struct iwl_priv *priv, u32 addr,
-				u32 bits, u32 mask, int timeout)
-{
-	int i = 0;
-
-	do {
-		if ((_iwl4965_read32(priv, addr) & mask) == (bits & mask))
-			return i;
-		mdelay(10);
-		i += 10;
-	} while (i < timeout);
-
-	return -ETIMEDOUT;
-}
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline int __iwl4965_poll_bit(const char *f, u32 l,
-				 struct iwl_priv *priv, u32 addr,
-				 u32 bits, u32 mask, int timeout)
-{
-	int ret = _iwl4965_poll_bit(priv, addr, bits, mask, timeout);
-	IWL_DEBUG_IO("poll_bit(0x%08X, 0x%08X, 0x%08X) - %s- %s %d\n",
-		     addr, bits, mask,
-		     unlikely(ret  == -ETIMEDOUT)?"timeout":"", f, l);
-	return ret;
-}
-#define iwl4965_poll_bit(priv, addr, bits, mask, timeout) \
-	__iwl4965_poll_bit(__FILE__, __LINE__, priv, addr, bits, mask, timeout)
-#else
-#define iwl4965_poll_bit(p, a, b, m, t) _iwl4965_poll_bit(p, a, b, m, t)
-#endif
-
-static inline void _iwl4965_set_bit(struct iwl_priv *priv, u32 reg, u32 mask)
-{
-	_iwl4965_write32(priv, reg, _iwl4965_read32(priv, reg) | mask);
-}
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline void __iwl4965_set_bit(const char *f, u32 l,
-				 struct iwl_priv *priv, u32 reg, u32 mask)
-{
-	u32 val = _iwl4965_read32(priv, reg) | mask;
-	IWL_DEBUG_IO("set_bit(0x%08X, 0x%08X) = 0x%08X\n", reg, mask, val);
-	_iwl4965_write32(priv, reg, val);
-}
-#define iwl4965_set_bit(p, r, m) __iwl4965_set_bit(__FILE__, __LINE__, p, r, m)
-#else
-#define iwl4965_set_bit(p, r, m) _iwl4965_set_bit(p, r, m)
-#endif
-
-static inline void _iwl4965_clear_bit(struct iwl_priv *priv, u32 reg, u32 mask)
-{
-	_iwl4965_write32(priv, reg, _iwl4965_read32(priv, reg) & ~mask);
-}
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline void __iwl4965_clear_bit(const char *f, u32 l,
-				   struct iwl_priv *priv, u32 reg, u32 mask)
-{
-	u32 val = _iwl4965_read32(priv, reg) & ~mask;
-	IWL_DEBUG_IO("clear_bit(0x%08X, 0x%08X) = 0x%08X\n", reg, mask, val);
-	_iwl4965_write32(priv, reg, val);
-}
-#define iwl4965_clear_bit(p, r, m) __iwl4965_clear_bit(__FILE__, __LINE__, p, r, m)
-#else
-#define iwl4965_clear_bit(p, r, m) _iwl4965_clear_bit(p, r, m)
-#endif
-
-static inline int _iwl4965_grab_nic_access(struct iwl_priv *priv)
-{
-	int ret;
-	u32 gp_ctl;
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-	if (atomic_read(&priv->restrict_refcnt))
-		return 0;
-#endif
-	if (test_bit(STATUS_RF_KILL_HW, &priv->status) ||
-	    test_bit(STATUS_RF_KILL_SW, &priv->status)) {
-		IWL_WARNING("WARNING: Requesting MAC access during RFKILL "
-			"wakes up NIC\n");
-
-		/* 10 msec allows time for NIC to complete its data save */
-		gp_ctl = _iwl4965_read32(priv, CSR_GP_CNTRL);
-		if (gp_ctl & CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY) {
-			IWL_DEBUG_RF_KILL("Wait for complete power-down, "
-				"gpctl = 0x%08x\n", gp_ctl);
-			mdelay(10);
-		} else
-			IWL_DEBUG_RF_KILL("power-down complete, "
-					  "gpctl = 0x%08x\n", gp_ctl);
-	}
-
-	/* this bit wakes up the NIC */
-	_iwl4965_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-	ret = _iwl4965_poll_bit(priv, CSR_GP_CNTRL,
-			   CSR_GP_CNTRL_REG_VAL_MAC_ACCESS_EN,
-			   (CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY |
-			    CSR_GP_CNTRL_REG_FLAG_GOING_TO_SLEEP), 50);
-	if (ret < 0) {
-		IWL_ERROR("MAC is in deep sleep!\n");
-		return -EIO;
-	}
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-	atomic_inc(&priv->restrict_refcnt);
-#endif
-	return 0;
-}
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline int __iwl4965_grab_nic_access(const char *f, u32 l,
-					       struct iwl_priv *priv)
-{
-	if (atomic_read(&priv->restrict_refcnt))
-		IWL_DEBUG_INFO("Grabbing access while already held at "
-			       "line %d.\n", l);
-
-	IWL_DEBUG_IO("grabbing nic access - %s %d\n", f, l);
-	return _iwl4965_grab_nic_access(priv);
-}
-#define iwl4965_grab_nic_access(priv) \
-	__iwl4965_grab_nic_access(__FILE__, __LINE__, priv)
-#else
-#define iwl4965_grab_nic_access(priv) \
-	_iwl4965_grab_nic_access(priv)
-#endif
-
-static inline void _iwl4965_release_nic_access(struct iwl_priv *priv)
-{
-#ifdef CONFIG_IWLWIFI_DEBUG
-	if (atomic_dec_and_test(&priv->restrict_refcnt))
-#endif
-		_iwl4965_clear_bit(priv, CSR_GP_CNTRL,
-			       CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-}
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline void __iwl4965_release_nic_access(const char *f, u32 l,
-					    struct iwl_priv *priv)
-{
-	if (atomic_read(&priv->restrict_refcnt) <= 0)
-		IWL_ERROR("Release unheld nic access at line %d.\n", l);
-
-	IWL_DEBUG_IO("releasing nic access - %s %d\n", f, l);
-	_iwl4965_release_nic_access(priv);
-}
-#define iwl4965_release_nic_access(priv) \
-	__iwl4965_release_nic_access(__FILE__, __LINE__, priv)
-#else
-#define iwl4965_release_nic_access(priv) \
-	_iwl4965_release_nic_access(priv)
-#endif
-
-static inline u32 _iwl4965_read_direct32(struct iwl_priv *priv, u32 reg)
-{
-	return _iwl4965_read32(priv, reg);
-}
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline u32 __iwl4965_read_direct32(const char *f, u32 l,
-					struct iwl_priv *priv, u32 reg)
-{
-	u32 value = _iwl4965_read_direct32(priv, reg);
-	if (!atomic_read(&priv->restrict_refcnt))
-		IWL_ERROR("Nic access not held from %s %d\n", f, l);
-	IWL_DEBUG_IO("read_direct32(0x%4X) = 0x%08x - %s %d \n", reg, value,
-		     f, l);
-	return value;
-}
-#define iwl4965_read_direct32(priv, reg) \
-	__iwl4965_read_direct32(__FILE__, __LINE__, priv, reg)
-#else
-#define iwl4965_read_direct32 _iwl4965_read_direct32
-#endif
-
-static inline void _iwl4965_write_direct32(struct iwl_priv *priv,
-					 u32 reg, u32 value)
-{
-	_iwl4965_write32(priv, reg, value);
-}
-#ifdef CONFIG_IWLWIFI_DEBUG
-static void __iwl4965_write_direct32(u32 line,
-				   struct iwl_priv *priv, u32 reg, u32 value)
-{
-	if (!atomic_read(&priv->restrict_refcnt))
-		IWL_ERROR("Nic access not held from line %d\n", line);
-	_iwl4965_write_direct32(priv, reg, value);
-}
-#define iwl4965_write_direct32(priv, reg, value) \
-	__iwl4965_write_direct32(__LINE__, priv, reg, value)
-#else
-#define iwl4965_write_direct32 _iwl4965_write_direct32
-#endif
-
-static inline void iwl4965_write_reg_buf(struct iwl_priv *priv,
-					       u32 reg, u32 len, u32 *values)
-{
-	u32 count = sizeof(u32);
-
-	if ((priv != NULL) && (values != NULL)) {
-		for (; 0 < len; len -= count, reg += count, values++)
-			_iwl4965_write_direct32(priv, reg, *values);
-	}
-}
-
-static inline int _iwl4965_poll_direct_bit(struct iwl_priv *priv,
-					   u32 addr, u32 mask, int timeout)
-{
-	int i = 0;
-
-	do {
-		if ((_iwl4965_read_direct32(priv, addr) & mask) == mask)
-			return i;
-		mdelay(10);
-		i += 10;
-	} while (i < timeout);
-
-	return -ETIMEDOUT;
-}
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline int __iwl4965_poll_direct_bit(const char *f, u32 l,
-					    struct iwl_priv *priv,
-					    u32 addr, u32 mask, int timeout)
-{
-	int ret  = _iwl4965_poll_direct_bit(priv, addr, mask, timeout);
-
-	if (unlikely(ret == -ETIMEDOUT))
-		IWL_DEBUG_IO("poll_direct_bit(0x%08X, 0x%08X) - "
-			     "timedout - %s %d\n", addr, mask, f, l);
-	else
-		IWL_DEBUG_IO("poll_direct_bit(0x%08X, 0x%08X) = 0x%08X "
-			     "- %s %d\n", addr, mask, ret, f, l);
-	return ret;
-}
-#define iwl4965_poll_direct_bit(priv, addr, mask, timeout) \
-	__iwl4965_poll_direct_bit(__FILE__, __LINE__, priv, addr, mask, timeout)
-#else
-#define iwl4965_poll_direct_bit _iwl4965_poll_direct_bit
-#endif
-
-static inline u32 _iwl4965_read_prph(struct iwl_priv *priv, u32 reg)
-{
-	_iwl4965_write_direct32(priv, HBUS_TARG_PRPH_RADDR, reg | (3 << 24));
-	return _iwl4965_read_direct32(priv, HBUS_TARG_PRPH_RDAT);
-}
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline u32 __iwl4965_read_prph(u32 line, struct iwl_priv *priv, u32 reg)
-{
-	if (!atomic_read(&priv->restrict_refcnt))
-		IWL_ERROR("Nic access not held from line %d\n", line);
-	return _iwl4965_read_prph(priv, reg);
-}
-
-#define iwl4965_read_prph(priv, reg) \
-	__iwl4965_read_prph(__LINE__, priv, reg)
-#else
-#define iwl4965_read_prph _iwl4965_read_prph
-#endif
-
-static inline void _iwl4965_write_prph(struct iwl_priv *priv,
-					     u32 addr, u32 val)
-{
-	_iwl4965_write_direct32(priv, HBUS_TARG_PRPH_WADDR,
-			      ((addr & 0x0000FFFF) | (3 << 24)));
-	_iwl4965_write_direct32(priv, HBUS_TARG_PRPH_WDAT, val);
-}
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline void __iwl4965_write_prph(u32 line, struct iwl_priv *priv,
-					      u32 addr, u32 val)
-{
-	if (!atomic_read(&priv->restrict_refcnt))
-		IWL_ERROR("Nic access from line %d\n", line);
-	_iwl4965_write_prph(priv, addr, val);
-}
-
-#define iwl4965_write_prph(priv, addr, val) \
-	__iwl4965_write_prph(__LINE__, priv, addr, val);
-#else
-#define iwl4965_write_prph _iwl4965_write_prph
-#endif
-
-#define _iwl4965_set_bits_prph(priv, reg, mask) \
-	_iwl4965_write_prph(priv, reg, (_iwl4965_read_prph(priv, reg) | mask))
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline void __iwl4965_set_bits_prph(u32 line, struct iwl_priv *priv,
-					u32 reg, u32 mask)
-{
-	if (!atomic_read(&priv->restrict_refcnt))
-		IWL_ERROR("Nic access not held from line %d\n", line);
-
-	_iwl4965_set_bits_prph(priv, reg, mask);
-}
-#define iwl4965_set_bits_prph(priv, reg, mask) \
-	__iwl4965_set_bits_prph(__LINE__, priv, reg, mask)
-#else
-#define iwl4965_set_bits_prph _iwl4965_set_bits_prph
-#endif
-
-#define _iwl4965_set_bits_mask_prph(priv, reg, bits, mask) \
-	_iwl4965_write_prph(priv, reg, ((_iwl4965_read_prph(priv, reg) & mask) | bits))
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline void __iwl4965_set_bits_mask_prph(u32 line,
-		struct iwl_priv *priv, u32 reg, u32 bits, u32 mask)
-{
-	if (!atomic_read(&priv->restrict_refcnt))
-		IWL_ERROR("Nic access not held from line %d\n", line);
-	_iwl4965_set_bits_mask_prph(priv, reg, bits, mask);
-}
-#define iwl4965_set_bits_mask_prph(priv, reg, bits, mask) \
-	__iwl4965_set_bits_mask_prph(__LINE__, priv, reg, bits, mask)
-#else
-#define iwl4965_set_bits_mask_prph _iwl4965_set_bits_mask_prph
-#endif
-
-static inline void iwl4965_clear_bits_prph(struct iwl_priv
-						 *priv, u32 reg, u32 mask)
-{
-	u32 val = _iwl4965_read_prph(priv, reg);
-	_iwl4965_write_prph(priv, reg, (val & ~mask));
-}
-
-static inline u32 iwl4965_read_targ_mem(struct iwl_priv *priv, u32 addr)
-{
-	iwl4965_write_direct32(priv, HBUS_TARG_MEM_RADDR, addr);
-	return iwl4965_read_direct32(priv, HBUS_TARG_MEM_RDAT);
-}
-
-static inline void iwl4965_write_targ_mem(struct iwl_priv *priv, u32 addr, u32 val)
-{
-	iwl4965_write_direct32(priv, HBUS_TARG_MEM_WADDR, addr);
-	iwl4965_write_direct32(priv, HBUS_TARG_MEM_WDAT, val);
-}
-
-static inline void iwl4965_write_targ_mem_buf(struct iwl_priv *priv, u32 addr,
-					  u32 len, u32 *values)
-{
-	iwl4965_write_direct32(priv, HBUS_TARG_MEM_WADDR, addr);
-	for (; 0 < len; len -= sizeof(u32), values++)
-		iwl4965_write_direct32(priv, HBUS_TARG_MEM_WDAT, *values);
-}
-#endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 8b5cacb..e5f64d7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -41,6 +41,7 @@
 #include "iwl-eeprom.h"
 #include "iwl-core.h"
 #include "iwl-4965.h"
+#include "iwl-io.h"
 #include "iwl-helpers.h"
 
 /* module parameters */
@@ -315,20 +316,20 @@ int iwl4965_hw_rxq_stop(struct iwl_priv *priv)
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl4965_grab_nic_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return rc;
 	}
 
 	/* stop Rx DMA */
-	iwl4965_write_direct32(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
-	rc = iwl4965_poll_direct_bit(priv, FH_MEM_RSSR_RX_STATUS_REG,
+	iwl_write_direct32(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
+	rc = iwl_poll_direct_bit(priv, FH_MEM_RSSR_RX_STATUS_REG,
 				     (1 << 24), 1000);
 	if (rc < 0)
 		IWL_ERROR("Can't stop Rx DMA.\n");
 
-	iwl4965_release_nic_access(priv);
+	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return 0;
@@ -372,7 +373,7 @@ static int iwl4965_nic_set_pwr_src(struct iwl_priv *priv, int pwr_max)
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	ret = iwl4965_grab_nic_access(priv);
+	ret = iwl_grab_nic_access(priv);
 	if (ret) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return ret;
@@ -385,15 +386,15 @@ static int iwl4965_nic_set_pwr_src(struct iwl_priv *priv, int pwr_max)
 					   &val);
 
 		if (val & PCI_CFG_PMC_PME_FROM_D3COLD_SUPPORT)
-			iwl4965_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
+			iwl_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
 				APMG_PS_CTRL_VAL_PWR_SRC_VAUX,
 				~APMG_PS_CTRL_MSK_PWR_SRC);
 	} else
-		iwl4965_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
+		iwl_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
 			APMG_PS_CTRL_VAL_PWR_SRC_VMAIN,
 			~APMG_PS_CTRL_MSK_PWR_SRC);
 
-	iwl4965_release_nic_access(priv);
+	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return ret;
@@ -406,7 +407,7 @@ static int iwl4965_rx_init(struct iwl_priv *priv, struct iwl4965_rx_queue *rxq)
 	unsigned int rb_size;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl4965_grab_nic_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return rc;
@@ -418,34 +419,34 @@ static int iwl4965_rx_init(struct iwl_priv *priv, struct iwl4965_rx_queue *rxq)
 		rb_size = FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_4K;
 
 	/* Stop Rx DMA */
-	iwl4965_write_direct32(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
+	iwl_write_direct32(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
 
 	/* Reset driver's Rx queue write index */
-	iwl4965_write_direct32(priv, FH_RSCSR_CHNL0_RBDCB_WPTR_REG, 0);
+	iwl_write_direct32(priv, FH_RSCSR_CHNL0_RBDCB_WPTR_REG, 0);
 
 	/* Tell device where to find RBD circular buffer in DRAM */
-	iwl4965_write_direct32(priv, FH_RSCSR_CHNL0_RBDCB_BASE_REG,
-			     rxq->dma_addr >> 8);
+	iwl_write_direct32(priv, FH_RSCSR_CHNL0_RBDCB_BASE_REG,
+			   rxq->dma_addr >> 8);
 
 	/* Tell device where in DRAM to update its Rx status */
-	iwl4965_write_direct32(priv, FH_RSCSR_CHNL0_STTS_WPTR_REG,
-			     (priv->hw_setting.shared_phys +
-			      offsetof(struct iwl4965_shared, val0)) >> 4);
+	iwl_write_direct32(priv, FH_RSCSR_CHNL0_STTS_WPTR_REG,
+			   (priv->hw_setting.shared_phys +
+				offsetof(struct iwl4965_shared, val0)) >> 4);
 
 	/* Enable Rx DMA, enable host interrupt, Rx buffer size 4k, 256 RBDs */
-	iwl4965_write_direct32(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG,
-			     FH_RCSR_RX_CONFIG_CHNL_EN_ENABLE_VAL |
-			     FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_INT_HOST_VAL |
-			     rb_size |
+	iwl_write_direct32(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG,
+			   FH_RCSR_RX_CONFIG_CHNL_EN_ENABLE_VAL |
+			   FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_INT_HOST_VAL |
+			   rb_size |
 			     /*0x10 << 4 | */
-			     (RX_QUEUE_SIZE_LOG <<
+			   (RX_QUEUE_SIZE_LOG <<
 			      FH_RCSR_RX_CONFIG_RBDCB_SIZE_BITSHIFT));
 
 	/*
-	 * iwl4965_write32(priv,CSR_INT_COAL_REG,0);
+	 * iwl_write32(priv,CSR_INT_COAL_REG,0);
 	 */
 
-	iwl4965_release_nic_access(priv);
+	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return 0;
@@ -458,13 +459,13 @@ static int iwl4965_kw_init(struct iwl_priv *priv)
 	int rc;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl4965_grab_nic_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc)
 		goto out;
 
-	iwl4965_write_direct32(priv, IWL_FH_KW_MEM_ADDR_REG,
+	iwl_write_direct32(priv, IWL_FH_KW_MEM_ADDR_REG,
 			     priv->kw.dma_addr >> 4);
-	iwl4965_release_nic_access(priv);
+	iwl_release_nic_access(priv);
 out:
 	spin_unlock_irqrestore(&priv->lock, flags);
 	return rc;
@@ -524,7 +525,7 @@ static int iwl4965_txq_ctx_reset(struct iwl_priv *priv)
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	rc = iwl4965_grab_nic_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (unlikely(rc)) {
 		IWL_ERROR("TX reset failed");
 		spin_unlock_irqrestore(&priv->lock, flags);
@@ -532,8 +533,8 @@ static int iwl4965_txq_ctx_reset(struct iwl_priv *priv)
 	}
 
 	/* Turn off all Tx DMA channels */
-	iwl4965_write_prph(priv, KDR_SCD_TXFACT, 0);
-	iwl4965_release_nic_access(priv);
+	iwl_write_prph(priv, KDR_SCD_TXFACT, 0);
+	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	/* Tell 4965 where to find the keep-warm buffer */
@@ -580,11 +581,11 @@ int iwl4965_hw_nic_init(struct iwl_priv *priv)
 	/* nic_init */
 	spin_lock_irqsave(&priv->lock, flags);
 
-	iwl4965_set_bit(priv, CSR_GIO_CHICKEN_BITS,
+	iwl_set_bit(priv, CSR_GIO_CHICKEN_BITS,
 		    CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER);
 
-	iwl4965_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
-	rc = iwl4965_poll_bit(priv, CSR_GP_CNTRL,
+	iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+	rc = iwl_poll_bit(priv, CSR_GP_CNTRL,
 			  CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
 			  CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
 	if (rc < 0) {
@@ -593,26 +594,25 @@ int iwl4965_hw_nic_init(struct iwl_priv *priv)
 		return rc;
 	}
 
-	rc = iwl4965_grab_nic_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return rc;
 	}
 
-	iwl4965_read_prph(priv, APMG_CLK_CTRL_REG);
+	iwl_read_prph(priv, APMG_CLK_CTRL_REG);
 
-	iwl4965_write_prph(priv, APMG_CLK_CTRL_REG,
-				 APMG_CLK_VAL_DMA_CLK_RQT |
-				 APMG_CLK_VAL_BSM_CLK_RQT);
-	iwl4965_read_prph(priv, APMG_CLK_CTRL_REG);
+	iwl_write_prph(priv, APMG_CLK_CTRL_REG,
+			APMG_CLK_VAL_DMA_CLK_RQT | APMG_CLK_VAL_BSM_CLK_RQT);
+	iwl_read_prph(priv, APMG_CLK_CTRL_REG);
 
 	udelay(20);
 
-	iwl4965_set_bits_prph(priv, APMG_PCIDEV_STT_REG,
-				    APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
+	iwl_set_bits_prph(priv, APMG_PCIDEV_STT_REG,
+				APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
 
-	iwl4965_release_nic_access(priv);
-	iwl4965_write32(priv, CSR_INT_COALESCING, 512 / 32);
+	iwl_release_nic_access(priv);
+	iwl_write32(priv, CSR_INT_COALESCING, 512 / 32);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	/* Determine HW type */
@@ -648,26 +648,24 @@ int iwl4965_hw_nic_init(struct iwl_priv *priv)
 
 	/* set CSR_HW_CONFIG_REG for uCode use */
 
-	iwl4965_set_bit(priv, CSR_HW_IF_CONFIG_REG,
-			CSR49_HW_IF_CONFIG_REG_BIT_4965_R |
-			CSR49_HW_IF_CONFIG_REG_BIT_RADIO_SI |
-			CSR49_HW_IF_CONFIG_REG_BIT_MAC_SI);
+	iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
+		    CSR49_HW_IF_CONFIG_REG_BIT_4965_R |
+		    CSR49_HW_IF_CONFIG_REG_BIT_RADIO_SI |
+		    CSR49_HW_IF_CONFIG_REG_BIT_MAC_SI);
 
-	rc = iwl4965_grab_nic_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc < 0) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		IWL_DEBUG_INFO("Failed to init the card\n");
 		return rc;
 	}
 
-	iwl4965_read_prph(priv, APMG_PS_CTRL_REG);
-	iwl4965_set_bits_prph(priv, APMG_PS_CTRL_REG,
-				    APMG_PS_CTRL_VAL_RESET_REQ);
+	iwl_read_prph(priv, APMG_PS_CTRL_REG);
+	iwl_set_bits_prph(priv, APMG_PS_CTRL_REG, APMG_PS_CTRL_VAL_RESET_REQ);
 	udelay(5);
-	iwl4965_clear_bits_prph(priv, APMG_PS_CTRL_REG,
-				      APMG_PS_CTRL_VAL_RESET_REQ);
+	iwl_clear_bits_prph(priv, APMG_PS_CTRL_REG, APMG_PS_CTRL_VAL_RESET_REQ);
 
-	iwl4965_release_nic_access(priv);
+	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	iwl4965_hw_card_show_info(priv);
@@ -720,16 +718,16 @@ int iwl4965_hw_nic_stop_master(struct iwl_priv *priv)
 	spin_lock_irqsave(&priv->lock, flags);
 
 	/* set stop master bit */
-	iwl4965_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_STOP_MASTER);
+	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_STOP_MASTER);
 
-	reg_val = iwl4965_read32(priv, CSR_GP_CNTRL);
+	reg_val = iwl_read32(priv, CSR_GP_CNTRL);
 
 	if (CSR_GP_CNTRL_REG_FLAG_MAC_POWER_SAVE ==
 	    (reg_val & CSR_GP_CNTRL_REG_MSK_POWER_SAVE_TYPE))
 		IWL_DEBUG_INFO("Card in power save, master is already "
 			       "stopped\n");
 	else {
-		rc = iwl4965_poll_bit(priv, CSR_RESET,
+		rc = iwl_poll_bit(priv, CSR_RESET,
 				  CSR_RESET_REG_FLAG_MASTER_DISABLED,
 				  CSR_RESET_REG_FLAG_MASTER_DISABLED, 100);
 		if (rc < 0) {
@@ -756,18 +754,17 @@ void iwl4965_hw_txq_ctx_stop(struct iwl_priv *priv)
 	/* Stop each Tx DMA channel, and wait for it to be idle */
 	for (txq_id = 0; txq_id < priv->hw_setting.max_txq_num; txq_id++) {
 		spin_lock_irqsave(&priv->lock, flags);
-		if (iwl4965_grab_nic_access(priv)) {
+		if (iwl_grab_nic_access(priv)) {
 			spin_unlock_irqrestore(&priv->lock, flags);
 			continue;
 		}
 
-		iwl4965_write_direct32(priv,
-				     IWL_FH_TCSR_CHNL_TX_CONFIG_REG(txq_id),
-				     0x0);
-		iwl4965_poll_direct_bit(priv, IWL_FH_TSSR_TX_STATUS_REG,
-					IWL_FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE
-					(txq_id), 200);
-		iwl4965_release_nic_access(priv);
+		iwl_write_direct32(priv,
+				   IWL_FH_TCSR_CHNL_TX_CONFIG_REG(txq_id), 0x0);
+		iwl_poll_direct_bit(priv, IWL_FH_TSSR_TX_STATUS_REG,
+				    IWL_FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE
+				    (txq_id), 200);
+		iwl_release_nic_access(priv);
 		spin_unlock_irqrestore(&priv->lock, flags);
 	}
 
@@ -784,29 +781,29 @@ int iwl4965_hw_nic_reset(struct iwl_priv *priv)
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	iwl4965_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
+	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
 
 	udelay(10);
 
-	iwl4965_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
-	rc = iwl4965_poll_bit(priv, CSR_RESET,
+	iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+	rc = iwl_poll_bit(priv, CSR_RESET,
 			  CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
 			  CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25);
 
 	udelay(10);
 
-	rc = iwl4965_grab_nic_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (!rc) {
-		iwl4965_write_prph(priv, APMG_CLK_EN_REG,
-					 APMG_CLK_VAL_DMA_CLK_RQT |
-					 APMG_CLK_VAL_BSM_CLK_RQT);
+		iwl_write_prph(priv, APMG_CLK_EN_REG,
+				APMG_CLK_VAL_DMA_CLK_RQT |
+				APMG_CLK_VAL_BSM_CLK_RQT);
 
 		udelay(10);
 
-		iwl4965_set_bits_prph(priv, APMG_PCIDEV_STT_REG,
-				APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
+		iwl_set_bits_prph(priv, APMG_PCIDEV_STT_REG,
+					APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
 
-		iwl4965_release_nic_access(priv);
+		iwl_release_nic_access(priv);
 	}
 
 	clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
@@ -872,7 +869,7 @@ void iwl4965_rf_kill_ct_config(struct iwl_priv *priv)
 	int ret = 0;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	iwl4965_write32(priv, CSR_UCODE_DRV_GP1_CLR,
+	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR,
 		    CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -1733,9 +1730,9 @@ static void iwl4965_bg_txpower_work(struct work_struct *work)
  */
 static void iwl4965_set_wr_ptrs(struct iwl_priv *priv, int txq_id, u32 index)
 {
-	iwl4965_write_direct32(priv, HBUS_TARG_WRPTR,
+	iwl_write_direct32(priv, HBUS_TARG_WRPTR,
 			     (index & 0xff) | (txq_id << 8));
-	iwl4965_write_prph(priv, KDR_SCD_QUEUE_RDPTR(txq_id), index);
+	iwl_write_prph(priv, KDR_SCD_QUEUE_RDPTR(txq_id), index);
 }
 
 /**
@@ -1755,7 +1752,7 @@ static void iwl4965_tx_queue_set_status(struct iwl_priv *priv,
 	int active = test_bit(txq_id, &priv->txq_ctx_active_msk)?1:0;
 
 	/* Set up and activate */
-	iwl4965_write_prph(priv, KDR_SCD_QUEUE_STATUS_BITS(txq_id),
+	iwl_write_prph(priv, KDR_SCD_QUEUE_STATUS_BITS(txq_id),
 				 (active << SCD_QUEUE_STTS_REG_POS_ACTIVE) |
 				 (tx_fifo_id << SCD_QUEUE_STTS_REG_POS_TXF) |
 				 (scd_retry << SCD_QUEUE_STTS_REG_POS_WSL) |
@@ -1807,46 +1804,46 @@ int iwl4965_alive_notify(struct iwl_priv *priv)
 		priv->chain_noise_data.delta_gain_code[i] =
 				CHAIN_NOISE_DELTA_GAIN_INIT_VAL;
 #endif /* CONFIG_IWL4965_SENSITIVITY*/
-	ret = iwl4965_grab_nic_access(priv);
+	ret = iwl_grab_nic_access(priv);
 	if (ret) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return ret;
 	}
 
 	/* Clear 4965's internal Tx Scheduler data base */
-	priv->scd_base_addr = iwl4965_read_prph(priv, KDR_SCD_SRAM_BASE_ADDR);
+	priv->scd_base_addr = iwl_read_prph(priv, KDR_SCD_SRAM_BASE_ADDR);
 	a = priv->scd_base_addr + SCD_CONTEXT_DATA_OFFSET;
 	for (; a < priv->scd_base_addr + SCD_TX_STTS_BITMAP_OFFSET; a += 4)
-		iwl4965_write_targ_mem(priv, a, 0);
+		iwl_write_targ_mem(priv, a, 0);
 	for (; a < priv->scd_base_addr + SCD_TRANSLATE_TBL_OFFSET; a += 4)
-		iwl4965_write_targ_mem(priv, a, 0);
+		iwl_write_targ_mem(priv, a, 0);
 	for (; a < sizeof(u16) * priv->hw_setting.max_txq_num; a += 4)
-		iwl4965_write_targ_mem(priv, a, 0);
+		iwl_write_targ_mem(priv, a, 0);
 
 	/* Tel 4965 where to find Tx byte count tables */
-	iwl4965_write_prph(priv, KDR_SCD_DRAM_BASE_ADDR,
+	iwl_write_prph(priv, KDR_SCD_DRAM_BASE_ADDR,
 		(priv->hw_setting.shared_phys +
 		 offsetof(struct iwl4965_shared, queues_byte_cnt_tbls)) >> 10);
 
 	/* Disable chain mode for all queues */
-	iwl4965_write_prph(priv, KDR_SCD_QUEUECHAIN_SEL, 0);
+	iwl_write_prph(priv, KDR_SCD_QUEUECHAIN_SEL, 0);
 
 	/* Initialize each Tx queue (including the command queue) */
 	for (i = 0; i < priv->hw_setting.max_txq_num; i++) {
 
 		/* TFD circular buffer read/write indexes */
-		iwl4965_write_prph(priv, KDR_SCD_QUEUE_RDPTR(i), 0);
-		iwl4965_write_direct32(priv, HBUS_TARG_WRPTR, 0 | (i << 8));
+		iwl_write_prph(priv, KDR_SCD_QUEUE_RDPTR(i), 0);
+		iwl_write_direct32(priv, HBUS_TARG_WRPTR, 0 | (i << 8));
 
 		/* Max Tx Window size for Scheduler-ACK mode */
-		iwl4965_write_targ_mem(priv, priv->scd_base_addr +
+		iwl_write_targ_mem(priv, priv->scd_base_addr +
 					SCD_CONTEXT_QUEUE_OFFSET(i),
 					(SCD_WIN_SIZE <<
 					SCD_QUEUE_CTX_REG1_WIN_SIZE_POS) &
 					SCD_QUEUE_CTX_REG1_WIN_SIZE_MSK);
 
 		/* Frame limit */
-		iwl4965_write_targ_mem(priv, priv->scd_base_addr +
+		iwl_write_targ_mem(priv, priv->scd_base_addr +
 					SCD_CONTEXT_QUEUE_OFFSET(i) +
 					sizeof(u32),
 					(SCD_FRAME_LIMIT <<
@@ -1854,11 +1851,11 @@ int iwl4965_alive_notify(struct iwl_priv *priv)
 					SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK);
 
 	}
-	iwl4965_write_prph(priv, KDR_SCD_INTERRUPT_MASK,
+	iwl_write_prph(priv, KDR_SCD_INTERRUPT_MASK,
 				 (1 << priv->hw_setting.max_txq_num) - 1);
 
 	/* Activate all Tx DMA/FIFO channels */
-	iwl4965_write_prph(priv, KDR_SCD_TXFACT,
+	iwl_write_prph(priv, KDR_SCD_TXFACT,
 				 SCD_TXFACT_REG_TXFIFO_MASK(0, 7));
 
 	iwl4965_set_wr_ptrs(priv, IWL_CMD_QUEUE_NUM, 0);
@@ -1870,7 +1867,7 @@ int iwl4965_alive_notify(struct iwl_priv *priv)
 		iwl4965_tx_queue_set_status(priv, &priv->txq[i], ac, 0);
 	}
 
-	iwl4965_release_nic_access(priv);
+	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return ret;
@@ -2929,22 +2926,22 @@ int iwl4965_hw_tx_queue_init(struct iwl_priv *priv, struct iwl4965_tx_queue *txq
 	int txq_id = txq->q.id;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl4965_grab_nic_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return rc;
 	}
 
 	/* Circular buffer (TFD queue in DRAM) physical base address */
-	iwl4965_write_direct32(priv, FH_MEM_CBBC_QUEUE(txq_id),
+	iwl_write_direct32(priv, FH_MEM_CBBC_QUEUE(txq_id),
 			     txq->q.dma_addr >> 8);
 
 	/* Enable DMA channel, using same id as for TFD queue */
-	iwl4965_write_direct32(
+	iwl_write_direct32(
 		priv, IWL_FH_TCSR_CHNL_TX_CONFIG_REG(txq_id),
 		IWL_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE |
 		IWL_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE_VAL);
-	iwl4965_release_nic_access(priv);
+	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return 0;
@@ -4259,7 +4256,7 @@ static void iwl4965_tx_queue_stop_scheduler(struct iwl_priv *priv,
 {
 	/* Simply stop the queue, but don't change any configuration;
 	 * the SCD_ACT_EN bit is the write-enable mask for the ACTIVE bit. */
-	iwl4965_write_prph(priv,
+	iwl_write_prph(priv,
 		KDR_SCD_QUEUE_STATUS_BITS(txq_id),
 		(0 << SCD_QUEUE_STTS_REG_POS_ACTIVE)|
 		(1 << SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN));
@@ -4280,24 +4277,24 @@ static int iwl4965_tx_queue_agg_disable(struct iwl_priv *priv, u16 txq_id,
 		return -EINVAL;
 	}
 
-	ret = iwl4965_grab_nic_access(priv);
+	ret = iwl_grab_nic_access(priv);
 	if (ret)
 		return ret;
 
 	iwl4965_tx_queue_stop_scheduler(priv, txq_id);
 
-	iwl4965_clear_bits_prph(priv, KDR_SCD_QUEUECHAIN_SEL, (1 << txq_id));
+	iwl_clear_bits_prph(priv, KDR_SCD_QUEUECHAIN_SEL, (1 << txq_id));
 
 	priv->txq[txq_id].q.read_ptr = (ssn_idx & 0xff);
 	priv->txq[txq_id].q.write_ptr = (ssn_idx & 0xff);
 	/* supposes that ssn_idx is valid (!= 0xFFF) */
 	iwl4965_set_wr_ptrs(priv, txq_id, ssn_idx);
 
-	iwl4965_clear_bits_prph(priv, KDR_SCD_INTERRUPT_MASK, (1 << txq_id));
+	iwl_clear_bits_prph(priv, KDR_SCD_INTERRUPT_MASK, (1 << txq_id));
 	iwl4965_txq_ctx_deactivate(priv, txq_id);
 	iwl4965_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 0);
 
-	iwl4965_release_nic_access(priv);
+	iwl_release_nic_access(priv);
 
 	return 0;
 }
@@ -4432,14 +4429,14 @@ static int iwl4965_tx_queue_set_q2ratid(struct iwl_priv *priv, u16 ra_tid,
 	tbl_dw_addr = priv->scd_base_addr +
 			SCD_TRANSLATE_TBL_OFFSET_QUEUE(txq_id);
 
-	tbl_dw = iwl4965_read_targ_mem(priv, tbl_dw_addr);
+	tbl_dw = iwl_read_targ_mem(priv, tbl_dw_addr);
 
 	if (txq_id & 0x1)
 		tbl_dw = (scd_q2ratid << 16) | (tbl_dw & 0x0000FFFF);
 	else
 		tbl_dw = scd_q2ratid | (tbl_dw & 0xFFFF0000);
 
-	iwl4965_write_targ_mem(priv, tbl_dw_addr, tbl_dw);
+	iwl_write_targ_mem(priv, tbl_dw_addr, tbl_dw);
 
 	return 0;
 }
@@ -4469,7 +4466,7 @@ static int iwl4965_tx_queue_agg_enable(struct iwl_priv *priv, int txq_id,
 	iwl4965_sta_modify_enable_tid_tx(priv, sta_id, tid);
 
 	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl4965_grab_nic_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return rc;
@@ -4482,7 +4479,7 @@ static int iwl4965_tx_queue_agg_enable(struct iwl_priv *priv, int txq_id,
 	iwl4965_tx_queue_set_q2ratid(priv, ra_tid, txq_id);
 
 	/* Set this queue as a chain-building queue */
-	iwl4965_set_bits_prph(priv, KDR_SCD_QUEUECHAIN_SEL, (1 << txq_id));
+	iwl_set_bits_prph(priv, KDR_SCD_QUEUECHAIN_SEL, (1 << txq_id));
 
 	/* Place first TFD at index corresponding to start sequence number.
 	 * Assumes that ssn_idx is valid (!= 0xFFF) */
@@ -4491,22 +4488,22 @@ static int iwl4965_tx_queue_agg_enable(struct iwl_priv *priv, int txq_id,
 	iwl4965_set_wr_ptrs(priv, txq_id, ssn_idx);
 
 	/* Set up Tx window size and frame limit for this queue */
-	iwl4965_write_targ_mem(priv,
+	iwl_write_targ_mem(priv,
 			priv->scd_base_addr + SCD_CONTEXT_QUEUE_OFFSET(txq_id),
 			(SCD_WIN_SIZE << SCD_QUEUE_CTX_REG1_WIN_SIZE_POS) &
 			SCD_QUEUE_CTX_REG1_WIN_SIZE_MSK);
 
-	iwl4965_write_targ_mem(priv, priv->scd_base_addr +
+	iwl_write_targ_mem(priv, priv->scd_base_addr +
 			SCD_CONTEXT_QUEUE_OFFSET(txq_id) + sizeof(u32),
 			(SCD_FRAME_LIMIT << SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS)
 			& SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK);
 
-	iwl4965_set_bits_prph(priv, KDR_SCD_INTERRUPT_MASK, (1 << txq_id));
+	iwl_set_bits_prph(priv, KDR_SCD_INTERRUPT_MASK, (1 << txq_id));
 
 	/* Set up Status area in SRAM, map to Tx DMA/FIFO, activate the queue */
 	iwl4965_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 1);
 
-	iwl4965_release_nic_access(priv);
+	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 32c21d2..98644d9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -1266,6 +1266,5 @@ extern const struct iwl_channel_info *iwl_get_channel_info(
 	const struct iwl_priv *priv, enum ieee80211_band band, u16 channel);
 
 /* Requires full declaration of iwl_priv before including */
-#include "iwl-4965-io.h"
 
 #endif				/* __iwl4965_4965_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index c659bd3..b2cc552 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -36,7 +36,7 @@
 
 #include "iwl-4965.h"
 #include "iwl-debug.h"
-#include "iwl-4965-io.h"
+#include "iwl-io.h"
 
 
 /* create and remove of files */
@@ -141,9 +141,9 @@ static ssize_t iwl_dbgfs_sram_read(struct file *file,
 	printk(KERN_DEBUG "offset is: 0x%x\tlen is: 0x%x\n",
 	priv->dbgfs->sram_offset, priv->dbgfs->sram_len);
 
-	iwl4965_grab_nic_access(priv);
+	iwl_grab_nic_access(priv);
 	for (i = priv->dbgfs->sram_len; i > 0; i -= 4) {
-		val = iwl4965_read_targ_mem(priv, priv->dbgfs->sram_offset + \
+		val = iwl_read_targ_mem(priv, priv->dbgfs->sram_offset + \
 					priv->dbgfs->sram_len - i);
 		if (i < 4) {
 			switch (i) {
@@ -161,7 +161,7 @@ static ssize_t iwl_dbgfs_sram_read(struct file *file,
 		pos += sprintf(buf+pos, "0x%08x ", val);
 	}
 	pos += sprintf(buf+pos, "\n");
-	iwl4965_release_nic_access(priv);
+	iwl_release_nic_access(priv);
 
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 	return ret;
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 72cad56..a07d5dc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -73,7 +73,7 @@
 #include "iwl-core.h"
 #include "iwl-debug.h"
 #include "iwl-eeprom.h"
-#include "iwl-4965-io.h"
+#include "iwl-io.h"
 
 /************************** EEPROM BANDS ****************************
  *
@@ -144,7 +144,7 @@ static const u8 iwl_eeprom_band_7[] = {       /* 5.2 FAT channel */
 
 int iwlcore_eeprom_verify_signature(struct iwl_priv *priv)
 {
-	u32 gp = iwl4965_read32(priv, CSR_EEPROM_GP);
+	u32 gp = iwl_read32(priv, CSR_EEPROM_GP);
 	if ((gp & CSR_EEPROM_GP_VALID_MSK) == CSR_EEPROM_GP_BAD_SIGNATURE) {
 		IWL_ERROR("EEPROM not found, EEPROM_GP=0x%08x", gp);
 		return -ENOENT;
@@ -166,14 +166,14 @@ int iwlcore_eeprom_acquire_semaphore(struct iwl_priv *priv)
 
 	for (count = 0; count < EEPROM_SEM_RETRY_LIMIT; count++) {
 		/* Request semaphore */
-		iwl4965_set_bit(priv, CSR_HW_IF_CONFIG_REG,
-			CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM);
+		iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
+			    CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM);
 
 		/* See if we got it */
-		ret = iwl4965_poll_bit(priv, CSR_HW_IF_CONFIG_REG,
-					CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM,
-					CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM,
-					EEPROM_SEM_TIMEOUT);
+		ret = iwl_poll_bit(priv, CSR_HW_IF_CONFIG_REG,
+				   CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM,
+				   CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM,
+				   EEPROM_SEM_TIMEOUT);
 		if (ret >= 0) {
 			IWL_DEBUG_IO("Acquired semaphore after %d tries.\n",
 				count+1);
@@ -187,7 +187,7 @@ EXPORT_SYMBOL(iwlcore_eeprom_acquire_semaphore);
 
 void iwlcore_eeprom_release_semaphore(struct iwl_priv *priv)
 {
-	iwl4965_clear_bit(priv, CSR_HW_IF_CONFIG_REG,
+	iwl_clear_bit(priv, CSR_HW_IF_CONFIG_REG,
 		CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM);
 
 }
@@ -204,7 +204,7 @@ EXPORT_SYMBOL(iwlcore_eeprom_release_semaphore);
 int iwl_eeprom_init(struct iwl_priv *priv)
 {
 	u16 *e = (u16 *)&priv->eeprom;
-	u32 gp = iwl4965_read32(priv, CSR_EEPROM_GP);
+	u32 gp = iwl_read32(priv, CSR_EEPROM_GP);
 	u32 r;
 	int sz = sizeof(priv->eeprom);
 	int ret;
@@ -231,12 +231,12 @@ int iwl_eeprom_init(struct iwl_priv *priv)
 
 	/* eeprom is an array of 16bit values */
 	for (addr = 0; addr < sz; addr += sizeof(u16)) {
-		_iwl4965_write32(priv, CSR_EEPROM_REG, addr << 1);
-		_iwl4965_clear_bit(priv, CSR_EEPROM_REG, CSR_EEPROM_REG_BIT_CMD);
+		_iwl_write32(priv, CSR_EEPROM_REG, addr << 1);
+		_iwl_clear_bit(priv, CSR_EEPROM_REG, CSR_EEPROM_REG_BIT_CMD);
 
 		for (i = 0; i < IWL_EEPROM_ACCESS_TIMEOUT;
 					i += IWL_EEPROM_ACCESS_DELAY) {
-			r = _iwl4965_read_direct32(priv, CSR_EEPROM_REG);
+			r = _iwl_read_direct32(priv, CSR_EEPROM_REG);
 			if (r & CSR_EEPROM_REG_READ_VALID_MSK)
 				break;
 			udelay(IWL_EEPROM_ACCESS_DELAY);
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
new file mode 100644
index 0000000..09cc094
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -0,0 +1,426 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2003 - 2008 Intel Corporation. All rights reserved.
+ *
+ * Portions of this file are derived from the ipw3945 project.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ *****************************************************************************/
+
+#ifndef __iwl_io_h__
+#define __iwl_io_h__
+
+#include <linux/io.h>
+
+#include "iwl-debug.h"
+
+/*
+ * IO, register, and NIC memory access functions
+ *
+ * NOTE on naming convention and macro usage for these
+ *
+ * A single _ prefix before a an access function means that no state
+ * check or debug information is printed when that function is called.
+ *
+ * A double __ prefix before an access function means that state is checked
+ * and the current line number is printed in addition to any other debug output.
+ *
+ * The non-prefixed name is the #define that maps the caller into a
+ * #define that provides the caller's __LINE__ to the double prefix version.
+ *
+ * If you wish to call the function without any debug or state checking,
+ * you should use the single _ prefix version (as is used by dependent IO
+ * routines, for example _iwl_read_direct32 calls the non-check version of
+ * _iwl_read32.)
+ *
+ * These declarations are *extremely* useful in quickly isolating code deltas
+ * which result in misconfiguring of the hardware I/O.  In combination with
+ * git-bisect and the IO debug level you can quickly determine the specific
+ * commit which breaks the IO sequence to the hardware.
+ *
+ */
+
+#define _iwl_write32(priv, ofs, val) writel((val), (priv)->hw_base + (ofs))
+#ifdef CONFIG_IWLWIFI_DEBUG
+static inline void __iwl_write32(const char *f, u32 l, struct iwl_priv *priv,
+				 u32 ofs, u32 val)
+{
+	IWL_DEBUG_IO("write32(0x%08X, 0x%08X) - %s %d\n", ofs, val, f, l);
+	_iwl_write32(priv, ofs, val);
+}
+#define iwl_write32(priv, ofs, val) \
+	__iwl_write32(__FILE__, __LINE__, priv, ofs, val)
+#else
+#define iwl_write32(priv, ofs, val) _iwl_write32(priv, ofs, val)
+#endif
+
+#define _iwl_read32(priv, ofs) readl((priv)->hw_base + (ofs))
+#ifdef CONFIG_IWLWIFI_DEBUG
+static inline u32 __iwl_read32(char *f, u32 l, struct iwl_priv *priv, u32 ofs)
+{
+	IWL_DEBUG_IO("read_direct32(0x%08X) - %s %d\n", ofs, f, l);
+	return _iwl_read32(priv, ofs);
+}
+#define iwl_read32(priv, ofs) __iwl_read32(__FILE__, __LINE__, priv, ofs)
+#else
+#define iwl_read32(p, o) _iwl_read32(p, o)
+#endif
+
+static inline int _iwl_poll_bit(struct iwl_priv *priv, u32 addr,
+				u32 bits, u32 mask, int timeout)
+{
+	int i = 0;
+
+	do {
+		if ((_iwl_read32(priv, addr) & mask) == (bits & mask))
+			return i;
+		mdelay(10);
+		i += 10;
+	} while (i < timeout);
+
+	return -ETIMEDOUT;
+}
+#ifdef CONFIG_IWLWIFI_DEBUG
+static inline int __iwl_poll_bit(const char *f, u32 l,
+				 struct iwl_priv *priv, u32 addr,
+				 u32 bits, u32 mask, int timeout)
+{
+	int ret = _iwl_poll_bit(priv, addr, bits, mask, timeout);
+	IWL_DEBUG_IO("poll_bit(0x%08X, 0x%08X, 0x%08X) - %s- %s %d\n",
+		     addr, bits, mask,
+		     unlikely(ret  == -ETIMEDOUT)?"timeout":"", f, l);
+	return ret;
+}
+#define iwl_poll_bit(priv, addr, bits, mask, timeout) \
+	__iwl_poll_bit(__FILE__, __LINE__, priv, addr, bits, mask, timeout)
+#else
+#define iwl_poll_bit(p, a, b, m, t) _iwl_poll_bit(p, a, b, m, t)
+#endif
+
+static inline void _iwl_set_bit(struct iwl_priv *priv, u32 reg, u32 mask)
+{
+	_iwl_write32(priv, reg, _iwl_read32(priv, reg) | mask);
+}
+#ifdef CONFIG_IWLWIFI_DEBUG
+static inline void __iwl_set_bit(const char *f, u32 l,
+				 struct iwl_priv *priv, u32 reg, u32 mask)
+{
+	u32 val = _iwl_read32(priv, reg) | mask;
+	IWL_DEBUG_IO("set_bit(0x%08X, 0x%08X) = 0x%08X\n", reg, mask, val);
+	_iwl_write32(priv, reg, val);
+}
+#define iwl_set_bit(p, r, m) __iwl_set_bit(__FILE__, __LINE__, p, r, m)
+#else
+#define iwl_set_bit(p, r, m) _iwl_set_bit(p, r, m)
+#endif
+
+static inline void _iwl_clear_bit(struct iwl_priv *priv, u32 reg, u32 mask)
+{
+	_iwl_write32(priv, reg, _iwl_read32(priv, reg) & ~mask);
+}
+#ifdef CONFIG_IWLWIFI_DEBUG
+static inline void __iwl_clear_bit(const char *f, u32 l,
+				   struct iwl_priv *priv, u32 reg, u32 mask)
+{
+	u32 val = _iwl_read32(priv, reg) & ~mask;
+	IWL_DEBUG_IO("clear_bit(0x%08X, 0x%08X) = 0x%08X\n", reg, mask, val);
+	_iwl_write32(priv, reg, val);
+}
+#define iwl_clear_bit(p, r, m) __iwl_clear_bit(__FILE__, __LINE__, p, r, m)
+#else
+#define iwl_clear_bit(p, r, m) _iwl_clear_bit(p, r, m)
+#endif
+
+static inline int _iwl_grab_nic_access(struct iwl_priv *priv)
+{
+	int ret;
+	u32 gp_ctl;
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if (atomic_read(&priv->restrict_refcnt))
+		return 0;
+#endif
+	if (test_bit(STATUS_RF_KILL_HW, &priv->status) ||
+	    test_bit(STATUS_RF_KILL_SW, &priv->status)) {
+		IWL_WARNING("WARNING: Requesting MAC access during RFKILL "
+			"wakes up NIC\n");
+
+		/* 10 msec allows time for NIC to complete its data save */
+		gp_ctl = _iwl_read32(priv, CSR_GP_CNTRL);
+		if (gp_ctl & CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY) {
+			IWL_DEBUG_RF_KILL("Wait for complete power-down, "
+				"gpctl = 0x%08x\n", gp_ctl);
+			mdelay(10);
+		} else
+			IWL_DEBUG_RF_KILL("power-down complete, "
+					  "gpctl = 0x%08x\n", gp_ctl);
+	}
+
+	/* this bit wakes up the NIC */
+	_iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+	ret = _iwl_poll_bit(priv, CSR_GP_CNTRL,
+			   CSR_GP_CNTRL_REG_VAL_MAC_ACCESS_EN,
+			   (CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY |
+			    CSR_GP_CNTRL_REG_FLAG_GOING_TO_SLEEP), 50);
+	if (ret < 0) {
+		IWL_ERROR("MAC is in deep sleep!\n");
+		return -EIO;
+	}
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+	atomic_inc(&priv->restrict_refcnt);
+#endif
+	return 0;
+}
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+static inline int __iwl_grab_nic_access(const char *f, u32 l,
+					       struct iwl_priv *priv)
+{
+	if (atomic_read(&priv->restrict_refcnt))
+		IWL_DEBUG_INFO("Grabbing access while already held at "
+			       "line %d.\n", l);
+
+	IWL_DEBUG_IO("grabbing nic access - %s %d\n", f, l);
+	return _iwl_grab_nic_access(priv);
+}
+#define iwl_grab_nic_access(priv) \
+	__iwl_grab_nic_access(__FILE__, __LINE__, priv)
+#else
+#define iwl_grab_nic_access(priv) \
+	_iwl_grab_nic_access(priv)
+#endif
+
+static inline void _iwl_release_nic_access(struct iwl_priv *priv)
+{
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if (atomic_dec_and_test(&priv->restrict_refcnt))
+#endif
+		_iwl_clear_bit(priv, CSR_GP_CNTRL,
+			       CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+}
+#ifdef CONFIG_IWLWIFI_DEBUG
+static inline void __iwl_release_nic_access(const char *f, u32 l,
+					    struct iwl_priv *priv)
+{
+	if (atomic_read(&priv->restrict_refcnt) <= 0)
+		IWL_ERROR("Release unheld nic access at line %d.\n", l);
+
+	IWL_DEBUG_IO("releasing nic access - %s %d\n", f, l);
+	_iwl_release_nic_access(priv);
+}
+#define iwl_release_nic_access(priv) \
+	__iwl_release_nic_access(__FILE__, __LINE__, priv)
+#else
+#define iwl_release_nic_access(priv) \
+	_iwl_release_nic_access(priv)
+#endif
+
+static inline u32 _iwl_read_direct32(struct iwl_priv *priv, u32 reg)
+{
+	return _iwl_read32(priv, reg);
+}
+#ifdef CONFIG_IWLWIFI_DEBUG
+static inline u32 __iwl_read_direct32(const char *f, u32 l,
+					struct iwl_priv *priv, u32 reg)
+{
+	u32 value = _iwl_read_direct32(priv, reg);
+	if (!atomic_read(&priv->restrict_refcnt))
+		IWL_ERROR("Nic access not held from %s %d\n", f, l);
+	IWL_DEBUG_IO("read_direct32(0x%4X) = 0x%08x - %s %d \n", reg, value,
+		     f, l);
+	return value;
+}
+#define iwl_read_direct32(priv, reg) \
+	__iwl_read_direct32(__FILE__, __LINE__, priv, reg)
+#else
+#define iwl_read_direct32 _iwl_read_direct32
+#endif
+
+static inline void _iwl_write_direct32(struct iwl_priv *priv,
+					 u32 reg, u32 value)
+{
+	_iwl_write32(priv, reg, value);
+}
+#ifdef CONFIG_IWLWIFI_DEBUG
+static void __iwl_write_direct32(u32 line,
+				   struct iwl_priv *priv, u32 reg, u32 value)
+{
+	if (!atomic_read(&priv->restrict_refcnt))
+		IWL_ERROR("Nic access not held from line %d\n", line);
+	_iwl_write_direct32(priv, reg, value);
+}
+#define iwl_write_direct32(priv, reg, value) \
+	__iwl_write_direct32(__LINE__, priv, reg, value)
+#else
+#define iwl_write_direct32 _iwl_write_direct32
+#endif
+
+static inline void iwl_write_reg_buf(struct iwl_priv *priv,
+					       u32 reg, u32 len, u32 *values)
+{
+	u32 count = sizeof(u32);
+
+	if ((priv != NULL) && (values != NULL)) {
+		for (; 0 < len; len -= count, reg += count, values++)
+			_iwl_write_direct32(priv, reg, *values);
+	}
+}
+
+static inline int _iwl_poll_direct_bit(struct iwl_priv *priv,
+					   u32 addr, u32 mask, int timeout)
+{
+	int i = 0;
+
+	do {
+		if ((_iwl_read_direct32(priv, addr) & mask) == mask)
+			return i;
+		mdelay(10);
+		i += 10;
+	} while (i < timeout);
+
+	return -ETIMEDOUT;
+}
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+static inline int __iwl_poll_direct_bit(const char *f, u32 l,
+					    struct iwl_priv *priv,
+					    u32 addr, u32 mask, int timeout)
+{
+	int ret  = _iwl_poll_direct_bit(priv, addr, mask, timeout);
+
+	if (unlikely(ret == -ETIMEDOUT))
+		IWL_DEBUG_IO("poll_direct_bit(0x%08X, 0x%08X) - "
+			     "timedout - %s %d\n", addr, mask, f, l);
+	else
+		IWL_DEBUG_IO("poll_direct_bit(0x%08X, 0x%08X) = 0x%08X "
+			     "- %s %d\n", addr, mask, ret, f, l);
+	return ret;
+}
+#define iwl_poll_direct_bit(priv, addr, mask, timeout) \
+	__iwl_poll_direct_bit(__FILE__, __LINE__, priv, addr, mask, timeout)
+#else
+#define iwl_poll_direct_bit _iwl_poll_direct_bit
+#endif
+
+static inline u32 _iwl_read_prph(struct iwl_priv *priv, u32 reg)
+{
+	_iwl_write_direct32(priv, HBUS_TARG_PRPH_RADDR, reg | (3 << 24));
+	return _iwl_read_direct32(priv, HBUS_TARG_PRPH_RDAT);
+}
+#ifdef CONFIG_IWLWIFI_DEBUG
+static inline u32 __iwl_read_prph(u32 line, struct iwl_priv *priv, u32 reg)
+{
+	if (!atomic_read(&priv->restrict_refcnt))
+		IWL_ERROR("Nic access not held from line %d\n", line);
+	return _iwl_read_prph(priv, reg);
+}
+
+#define iwl_read_prph(priv, reg) \
+	__iwl_read_prph(__LINE__, priv, reg)
+#else
+#define iwl_read_prph _iwl_read_prph
+#endif
+
+static inline void _iwl_write_prph(struct iwl_priv *priv,
+					     u32 addr, u32 val)
+{
+	_iwl_write_direct32(priv, HBUS_TARG_PRPH_WADDR,
+			      ((addr & 0x0000FFFF) | (3 << 24)));
+	_iwl_write_direct32(priv, HBUS_TARG_PRPH_WDAT, val);
+}
+#ifdef CONFIG_IWLWIFI_DEBUG
+static inline void __iwl_write_prph(u32 line, struct iwl_priv *priv,
+					      u32 addr, u32 val)
+{
+	if (!atomic_read(&priv->restrict_refcnt))
+		IWL_ERROR("Nic access from line %d\n", line);
+	_iwl_write_prph(priv, addr, val);
+}
+
+#define iwl_write_prph(priv, addr, val) \
+	__iwl_write_prph(__LINE__, priv, addr, val);
+#else
+#define iwl_write_prph _iwl_write_prph
+#endif
+
+#define _iwl_set_bits_prph(priv, reg, mask) \
+	_iwl_write_prph(priv, reg, (_iwl_read_prph(priv, reg) | mask))
+#ifdef CONFIG_IWLWIFI_DEBUG
+static inline void __iwl_set_bits_prph(u32 line, struct iwl_priv *priv,
+					u32 reg, u32 mask)
+{
+	if (!atomic_read(&priv->restrict_refcnt))
+		IWL_ERROR("Nic access not held from line %d\n", line);
+
+	_iwl_set_bits_prph(priv, reg, mask);
+}
+#define iwl_set_bits_prph(priv, reg, mask) \
+	__iwl_set_bits_prph(__LINE__, priv, reg, mask)
+#else
+#define iwl_set_bits_prph _iwl_set_bits_prph
+#endif
+
+#define _iwl_set_bits_mask_prph(priv, reg, bits, mask) \
+	_iwl_write_prph(priv, reg, ((_iwl_read_prph(priv, reg) & mask) | bits))
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+static inline void __iwl_set_bits_mask_prph(u32 line,
+		struct iwl_priv *priv, u32 reg, u32 bits, u32 mask)
+{
+	if (!atomic_read(&priv->restrict_refcnt))
+		IWL_ERROR("Nic access not held from line %d\n", line);
+	_iwl_set_bits_mask_prph(priv, reg, bits, mask);
+}
+#define iwl_set_bits_mask_prph(priv, reg, bits, mask) \
+	__iwl_set_bits_mask_prph(__LINE__, priv, reg, bits, mask)
+#else
+#define iwl_set_bits_mask_prph _iwl_set_bits_mask_prph
+#endif
+
+static inline void iwl_clear_bits_prph(struct iwl_priv
+						 *priv, u32 reg, u32 mask)
+{
+	u32 val = _iwl_read_prph(priv, reg);
+	_iwl_write_prph(priv, reg, (val & ~mask));
+}
+
+static inline u32 iwl_read_targ_mem(struct iwl_priv *priv, u32 addr)
+{
+	iwl_write_direct32(priv, HBUS_TARG_MEM_RADDR, addr);
+	return iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
+}
+
+static inline void iwl_write_targ_mem(struct iwl_priv *priv, u32 addr, u32 val)
+{
+	iwl_write_direct32(priv, HBUS_TARG_MEM_WADDR, addr);
+	iwl_write_direct32(priv, HBUS_TARG_MEM_WDAT, val);
+}
+
+static inline void iwl_write_targ_mem_buf(struct iwl_priv *priv, u32 addr,
+					  u32 len, u32 *values)
+{
+	iwl_write_direct32(priv, HBUS_TARG_MEM_WADDR, addr);
+	for (; 0 < len; len -= sizeof(u32), values++)
+		iwl_write_direct32(priv, HBUS_TARG_MEM_WDAT, *values);
+}
+#endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 6f5424b..d59ad18 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -40,6 +40,7 @@
 #include <asm/unaligned.h>
 
 #include "iwl-4965.h"
+#include "iwl-io.h"
 #include "iwl-core.h"
 #include "iwl-helpers.h"
 
@@ -85,9 +86,9 @@ static int iwl_send_led_cmd(struct iwl_priv *priv,
 	};
 	u32 reg;
 
-	reg = iwl4965_read32(priv, CSR_LED_REG);
+	reg = iwl_read32(priv, CSR_LED_REG);
 	if (reg != (reg & CSR_LED_BSM_CTRL_MSK))
-		iwl4965_write32(priv, CSR_LED_REG, reg & CSR_LED_BSM_CTRL_MSK);
+		iwl_write32(priv, CSR_LED_REG, reg & CSR_LED_BSM_CTRL_MSK);
 
 	return iwl_send_cmd(priv, &cmd);
 }
@@ -126,7 +127,7 @@ static int iwl4965_led_pattern(struct iwl_priv *priv, int led_id,
 static int iwl4965_led_on_reg(struct iwl_priv *priv, int led_id)
 {
 	IWL_DEBUG_LED("led on %d\n", led_id);
-	iwl4965_write32(priv, CSR_LED_REG, CSR_LED_REG_TRUN_ON);
+	iwl_write32(priv, CSR_LED_REG, CSR_LED_REG_TRUN_ON);
 	return 0;
 }
 
@@ -150,7 +151,7 @@ int iwl4965_led_off(struct iwl_priv *priv, int led_id)
 static int iwl4965_led_off_reg(struct iwl_priv *priv, int led_id)
 {
 	IWL_DEBUG_LED("radio off\n");
-	iwl4965_write32(priv, CSR_LED_REG, CSR_LED_REG_TRUN_OFF);
+	iwl_write32(priv, CSR_LED_REG, CSR_LED_REG_TRUN_OFF);
 	return 0;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index f7a84ca..b424137 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -48,6 +48,7 @@
 #include "iwl-eeprom.h"
 #include "iwl-core.h"
 #include "iwl-4965.h"
+#include "iwl-io.h"
 #include "iwl-helpers.h"
 
 static int iwl4965_tx_queue_update_write_ptr(struct iwl_priv *priv,
@@ -2616,7 +2617,7 @@ static void iwl4965_radio_kill_sw(struct iwl_priv *priv, int disable_radio)
 		/* FIXME: This is a workaround for AP */
 		if (priv->iw_mode != IEEE80211_IF_TYPE_AP) {
 			spin_lock_irqsave(&priv->lock, flags);
-			iwl4965_write32(priv, CSR_UCODE_DRV_GP1_SET,
+			iwl_write32(priv, CSR_UCODE_DRV_GP1_SET,
 				    CSR_UCODE_SW_BIT_RFKILL);
 			spin_unlock_irqrestore(&priv->lock, flags);
 			iwl4965_send_card_state(priv, CARD_STATE_CMD_DISABLE, 0);
@@ -2626,7 +2627,7 @@ static void iwl4965_radio_kill_sw(struct iwl_priv *priv, int disable_radio)
 	}
 
 	spin_lock_irqsave(&priv->lock, flags);
-	iwl4965_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
 
 	clear_bit(STATUS_RF_KILL_SW, &priv->status);
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -2635,9 +2636,9 @@ static void iwl4965_radio_kill_sw(struct iwl_priv *priv, int disable_radio)
 	msleep(10);
 
 	spin_lock_irqsave(&priv->lock, flags);
-	iwl4965_read32(priv, CSR_UCODE_DRV_GP1);
-	if (!iwl4965_grab_nic_access(priv))
-		iwl4965_release_nic_access(priv);
+	iwl_read32(priv, CSR_UCODE_DRV_GP1);
+	if (!iwl_grab_nic_access(priv))
+		iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	if (test_bit(STATUS_RF_KILL_HW, &priv->status)) {
@@ -3514,35 +3515,35 @@ static void iwl4965_rx_card_state_notif(struct iwl_priv *priv,
 	if (flags & (SW_CARD_DISABLED | HW_CARD_DISABLED |
 		     RF_CARD_DISABLED)) {
 
-		iwl4965_write32(priv, CSR_UCODE_DRV_GP1_SET,
+		iwl_write32(priv, CSR_UCODE_DRV_GP1_SET,
 			    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
 
-		if (!iwl4965_grab_nic_access(priv)) {
-			iwl4965_write_direct32(
+		if (!iwl_grab_nic_access(priv)) {
+			iwl_write_direct32(
 				priv, HBUS_TARG_MBX_C,
 				HBUS_TARG_MBX_C_REG_BIT_CMD_BLOCKED);
 
-			iwl4965_release_nic_access(priv);
+			iwl_release_nic_access(priv);
 		}
 
 		if (!(flags & RXON_CARD_DISABLED)) {
-			iwl4965_write32(priv, CSR_UCODE_DRV_GP1_CLR,
+			iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR,
 				    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
-			if (!iwl4965_grab_nic_access(priv)) {
-				iwl4965_write_direct32(
+			if (!iwl_grab_nic_access(priv)) {
+				iwl_write_direct32(
 					priv, HBUS_TARG_MBX_C,
 					HBUS_TARG_MBX_C_REG_BIT_CMD_BLOCKED);
 
-				iwl4965_release_nic_access(priv);
+				iwl_release_nic_access(priv);
 			}
 		}
 
 		if (flags & RF_CARD_DISABLED) {
-			iwl4965_write32(priv, CSR_UCODE_DRV_GP1_SET,
+			iwl_write32(priv, CSR_UCODE_DRV_GP1_SET,
 				    CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT);
-			iwl4965_read32(priv, CSR_UCODE_DRV_GP1);
-			if (!iwl4965_grab_nic_access(priv))
-				iwl4965_release_nic_access(priv);
+			iwl_read32(priv, CSR_UCODE_DRV_GP1);
+			if (!iwl_grab_nic_access(priv))
+				iwl_release_nic_access(priv);
 		}
 	}
 
@@ -3756,27 +3757,27 @@ int iwl4965_rx_queue_update_write_ptr(struct iwl_priv *priv, struct iwl4965_rx_q
 
 	/* If power-saving is in use, make sure device is awake */
 	if (test_bit(STATUS_POWER_PMI, &priv->status)) {
-		reg = iwl4965_read32(priv, CSR_UCODE_DRV_GP1);
+		reg = iwl_read32(priv, CSR_UCODE_DRV_GP1);
 
 		if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
-			iwl4965_set_bit(priv, CSR_GP_CNTRL,
+			iwl_set_bit(priv, CSR_GP_CNTRL,
 				    CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 			goto exit_unlock;
 		}
 
-		rc = iwl4965_grab_nic_access(priv);
+		rc = iwl_grab_nic_access(priv);
 		if (rc)
 			goto exit_unlock;
 
 		/* Device expects a multiple of 8 */
-		iwl4965_write_direct32(priv, FH_RSCSR_CHNL0_WPTR,
+		iwl_write_direct32(priv, FH_RSCSR_CHNL0_WPTR,
 				     q->write & ~0x7);
-		iwl4965_release_nic_access(priv);
+		iwl_release_nic_access(priv);
 
 	/* Else device is assumed to be awake */
 	} else
 		/* Device expects a multiple of 8 */
-		iwl4965_write32(priv, FH_RSCSR_CHNL0_WPTR, q->write & ~0x7);
+		iwl_write32(priv, FH_RSCSR_CHNL0_WPTR, q->write & ~0x7);
 
 
 	q->need_update = 0;
@@ -4213,27 +4214,27 @@ static int iwl4965_tx_queue_update_write_ptr(struct iwl_priv *priv,
 		/* wake up nic if it's powered down ...
 		 * uCode will wake up, and interrupt us again, so next
 		 * time we'll skip this part. */
-		reg = iwl4965_read32(priv, CSR_UCODE_DRV_GP1);
+		reg = iwl_read32(priv, CSR_UCODE_DRV_GP1);
 
 		if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
 			IWL_DEBUG_INFO("Requesting wakeup, GP1 = 0x%x\n", reg);
-			iwl4965_set_bit(priv, CSR_GP_CNTRL,
+			iwl_set_bit(priv, CSR_GP_CNTRL,
 				    CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 			return rc;
 		}
 
 		/* restore this queue's parameters in nic hardware. */
-		rc = iwl4965_grab_nic_access(priv);
+		rc = iwl_grab_nic_access(priv);
 		if (rc)
 			return rc;
-		iwl4965_write_direct32(priv, HBUS_TARG_WRPTR,
+		iwl_write_direct32(priv, HBUS_TARG_WRPTR,
 				     txq->q.write_ptr | (txq_id << 8));
-		iwl4965_release_nic_access(priv);
+		iwl_release_nic_access(priv);
 
 	/* else not in power-save mode, uCode will never sleep when we're
 	 * trying to tx (during RFKILL, we're not trying to tx). */
 	} else
-		iwl4965_write32(priv, HBUS_TARG_WRPTR,
+		iwl_write32(priv, HBUS_TARG_WRPTR,
 			    txq->q.write_ptr | (txq_id << 8));
 
 	txq->need_update = 0;
@@ -4268,7 +4269,7 @@ static void iwl4965_enable_interrupts(struct iwl_priv *priv)
 {
 	IWL_DEBUG_ISR("Enabling interrupts\n");
 	set_bit(STATUS_INT_ENABLED, &priv->status);
-	iwl4965_write32(priv, CSR_INT_MASK, CSR_INI_SET_MASK);
+	iwl_write32(priv, CSR_INT_MASK, CSR_INI_SET_MASK);
 }
 
 static inline void iwl4965_disable_interrupts(struct iwl_priv *priv)
@@ -4276,12 +4277,12 @@ static inline void iwl4965_disable_interrupts(struct iwl_priv *priv)
 	clear_bit(STATUS_INT_ENABLED, &priv->status);
 
 	/* disable interrupts from uCode/NIC to host */
-	iwl4965_write32(priv, CSR_INT_MASK, 0x00000000);
+	iwl_write32(priv, CSR_INT_MASK, 0x00000000);
 
 	/* acknowledge/clear/reset any interrupts still pending
 	 * from uCode or flow handler (Rx/Tx DMA) */
-	iwl4965_write32(priv, CSR_INT, 0xffffffff);
-	iwl4965_write32(priv, CSR_FH_INT_STATUS, 0xffffffff);
+	iwl_write32(priv, CSR_INT, 0xffffffff);
+	iwl_write32(priv, CSR_FH_INT_STATUS, 0xffffffff);
 	IWL_DEBUG_ISR("Disabled interrupts\n");
 }
 
@@ -4322,28 +4323,28 @@ static void iwl4965_dump_nic_error_log(struct iwl_priv *priv)
 		return;
 	}
 
-	rc = iwl4965_grab_nic_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc) {
 		IWL_WARNING("Can not read from adapter at this time.\n");
 		return;
 	}
 
-	count = iwl4965_read_targ_mem(priv, base);
+	count = iwl_read_targ_mem(priv, base);
 
 	if (ERROR_START_OFFSET <= count * ERROR_ELEM_SIZE) {
 		IWL_ERROR("Start IWL Error Log Dump:\n");
 		IWL_ERROR("Status: 0x%08lX, count: %d\n", priv->status, count);
 	}
 
-	desc = iwl4965_read_targ_mem(priv, base + 1 * sizeof(u32));
-	blink1 = iwl4965_read_targ_mem(priv, base + 3 * sizeof(u32));
-	blink2 = iwl4965_read_targ_mem(priv, base + 4 * sizeof(u32));
-	ilink1 = iwl4965_read_targ_mem(priv, base + 5 * sizeof(u32));
-	ilink2 = iwl4965_read_targ_mem(priv, base + 6 * sizeof(u32));
-	data1 = iwl4965_read_targ_mem(priv, base + 7 * sizeof(u32));
-	data2 = iwl4965_read_targ_mem(priv, base + 8 * sizeof(u32));
-	line = iwl4965_read_targ_mem(priv, base + 9 * sizeof(u32));
-	time = iwl4965_read_targ_mem(priv, base + 11 * sizeof(u32));
+	desc = iwl_read_targ_mem(priv, base + 1 * sizeof(u32));
+	blink1 = iwl_read_targ_mem(priv, base + 3 * sizeof(u32));
+	blink2 = iwl_read_targ_mem(priv, base + 4 * sizeof(u32));
+	ilink1 = iwl_read_targ_mem(priv, base + 5 * sizeof(u32));
+	ilink2 = iwl_read_targ_mem(priv, base + 6 * sizeof(u32));
+	data1 = iwl_read_targ_mem(priv, base + 7 * sizeof(u32));
+	data2 = iwl_read_targ_mem(priv, base + 8 * sizeof(u32));
+	line = iwl_read_targ_mem(priv, base + 9 * sizeof(u32));
+	time = iwl_read_targ_mem(priv, base + 11 * sizeof(u32));
 
 	IWL_ERROR("Desc               Time       "
 		  "data1      data2      line\n");
@@ -4353,7 +4354,7 @@ static void iwl4965_dump_nic_error_log(struct iwl_priv *priv)
 	IWL_ERROR("0x%05X 0x%05X 0x%05X 0x%05X\n", blink1, blink2,
 		  ilink1, ilink2);
 
-	iwl4965_release_nic_access(priv);
+	iwl_release_nic_access(priv);
 }
 
 #define EVENT_START_OFFSET  (4 * sizeof(u32))
@@ -4361,7 +4362,7 @@ static void iwl4965_dump_nic_error_log(struct iwl_priv *priv)
 /**
  * iwl4965_print_event_log - Dump error event log to syslog
  *
- * NOTE: Must be called with iwl4965_grab_nic_access() already obtained!
+ * NOTE: Must be called with iwl_grab_nic_access() already obtained!
  */
 static void iwl4965_print_event_log(struct iwl_priv *priv, u32 start_idx,
 				u32 num_events, u32 mode)
@@ -4387,14 +4388,14 @@ static void iwl4965_print_event_log(struct iwl_priv *priv, u32 start_idx,
 	/* "time" is actually "data" for mode 0 (no timestamp).
 	 * place event id # at far right for easier visual parsing. */
 	for (i = 0; i < num_events; i++) {
-		ev = iwl4965_read_targ_mem(priv, ptr);
+		ev = iwl_read_targ_mem(priv, ptr);
 		ptr += sizeof(u32);
-		time = iwl4965_read_targ_mem(priv, ptr);
+		time = iwl_read_targ_mem(priv, ptr);
 		ptr += sizeof(u32);
 		if (mode == 0)
 			IWL_ERROR("0x%08x\t%04u\n", time, ev); /* data, ev */
 		else {
-			data = iwl4965_read_targ_mem(priv, ptr);
+			data = iwl_read_targ_mem(priv, ptr);
 			ptr += sizeof(u32);
 			IWL_ERROR("%010u\t0x%08x\t%04u\n", time, data, ev);
 		}
@@ -4417,24 +4418,24 @@ static void iwl4965_dump_nic_event_log(struct iwl_priv *priv)
 		return;
 	}
 
-	rc = iwl4965_grab_nic_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc) {
 		IWL_WARNING("Can not read from adapter at this time.\n");
 		return;
 	}
 
 	/* event log header */
-	capacity = iwl4965_read_targ_mem(priv, base);
-	mode = iwl4965_read_targ_mem(priv, base + (1 * sizeof(u32)));
-	num_wraps = iwl4965_read_targ_mem(priv, base + (2 * sizeof(u32)));
-	next_entry = iwl4965_read_targ_mem(priv, base + (3 * sizeof(u32)));
+	capacity = iwl_read_targ_mem(priv, base);
+	mode = iwl_read_targ_mem(priv, base + (1 * sizeof(u32)));
+	num_wraps = iwl_read_targ_mem(priv, base + (2 * sizeof(u32)));
+	next_entry = iwl_read_targ_mem(priv, base + (3 * sizeof(u32)));
 
 	size = num_wraps ? capacity : next_entry;
 
 	/* bail out if nothing in log */
 	if (size == 0) {
 		IWL_ERROR("Start IWL Event Log Dump: nothing in log\n");
-		iwl4965_release_nic_access(priv);
+		iwl_release_nic_access(priv);
 		return;
 	}
 
@@ -4450,7 +4451,7 @@ static void iwl4965_dump_nic_event_log(struct iwl_priv *priv)
 	/* (then/else) start at top of log */
 	iwl4965_print_event_log(priv, 0, next_entry, mode);
 
-	iwl4965_release_nic_access(priv);
+	iwl_release_nic_access(priv);
 }
 
 /**
@@ -4522,19 +4523,19 @@ static void iwl4965_irq_tasklet(struct iwl_priv *priv)
 	/* Ack/clear/reset pending uCode interrupts.
 	 * Note:  Some bits in CSR_INT are "OR" of bits in CSR_FH_INT_STATUS,
 	 *  and will clear only when CSR_FH_INT_STATUS gets cleared. */
-	inta = iwl4965_read32(priv, CSR_INT);
-	iwl4965_write32(priv, CSR_INT, inta);
+	inta = iwl_read32(priv, CSR_INT);
+	iwl_write32(priv, CSR_INT, inta);
 
 	/* Ack/clear/reset pending flow-handler (DMA) interrupts.
 	 * Any new interrupts that happen after this, either while we're
 	 * in this tasklet, or later, will show up in next ISR/tasklet. */
-	inta_fh = iwl4965_read32(priv, CSR_FH_INT_STATUS);
-	iwl4965_write32(priv, CSR_FH_INT_STATUS, inta_fh);
+	inta_fh = iwl_read32(priv, CSR_FH_INT_STATUS);
+	iwl_write32(priv, CSR_FH_INT_STATUS, inta_fh);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (iwl_debug_level & IWL_DL_ISR) {
 		/* just for debug */
-		inta_mask = iwl4965_read32(priv, CSR_INT_MASK);
+		inta_mask = iwl_read32(priv, CSR_INT_MASK);
 		IWL_DEBUG_ISR("inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
 			      inta, inta_mask, inta_fh);
 	}
@@ -4583,7 +4584,7 @@ static void iwl4965_irq_tasklet(struct iwl_priv *priv)
 	/* HW RF KILL switch toggled */
 	if (inta & CSR_INT_BIT_RF_KILL) {
 		int hw_rf_kill = 0;
-		if (!(iwl4965_read32(priv, CSR_GP_CNTRL) &
+		if (!(iwl_read32(priv, CSR_GP_CNTRL) &
 				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW))
 			hw_rf_kill = 1;
 
@@ -4658,9 +4659,9 @@ static void iwl4965_irq_tasklet(struct iwl_priv *priv)
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (iwl_debug_level & (IWL_DL_ISR)) {
-		inta = iwl4965_read32(priv, CSR_INT);
-		inta_mask = iwl4965_read32(priv, CSR_INT_MASK);
-		inta_fh = iwl4965_read32(priv, CSR_FH_INT_STATUS);
+		inta = iwl_read32(priv, CSR_INT);
+		inta_mask = iwl_read32(priv, CSR_INT_MASK);
+		inta_fh = iwl_read32(priv, CSR_FH_INT_STATUS);
 		IWL_DEBUG_ISR("End inta 0x%08x, enabled 0x%08x, fh 0x%08x, "
 			"flags 0x%08lx\n", inta, inta_mask, inta_fh, flags);
 	}
@@ -4682,12 +4683,12 @@ static irqreturn_t iwl4965_isr(int irq, void *data)
 	 *    back-to-back ISRs and sporadic interrupts from our NIC.
 	 * If we have something to service, the tasklet will re-enable ints.
 	 * If we *don't* have something, we'll re-enable before leaving here. */
-	inta_mask = iwl4965_read32(priv, CSR_INT_MASK);  /* just for debug */
-	iwl4965_write32(priv, CSR_INT_MASK, 0x00000000);
+	inta_mask = iwl_read32(priv, CSR_INT_MASK);  /* just for debug */
+	iwl_write32(priv, CSR_INT_MASK, 0x00000000);
 
 	/* Discover which interrupts are active/pending */
-	inta = iwl4965_read32(priv, CSR_INT);
-	inta_fh = iwl4965_read32(priv, CSR_FH_INT_STATUS);
+	inta = iwl_read32(priv, CSR_INT);
+	inta_fh = iwl_read32(priv, CSR_FH_INT_STATUS);
 
 	/* Ignore interrupt if there's nothing in NIC to service.
 	 * This may be due to IRQ shared with another device,
@@ -5050,18 +5051,18 @@ static int iwl4965_verify_inst_full(struct iwl_priv *priv, __le32 *image,
 
 	IWL_DEBUG_INFO("ucode inst image size is %u\n", len);
 
-	rc = iwl4965_grab_nic_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc)
 		return rc;
 
-	iwl4965_write_direct32(priv, HBUS_TARG_MEM_RADDR, RTC_INST_LOWER_BOUND);
+	iwl_write_direct32(priv, HBUS_TARG_MEM_RADDR, RTC_INST_LOWER_BOUND);
 
 	errcnt = 0;
 	for (; len > 0; len -= sizeof(u32), image++) {
 		/* read data comes through single port, auto-incr addr */
 		/* NOTE: Use the debugless read so we don't flood kernel log
 		 * if IWL_DL_IO is set */
-		val = _iwl4965_read_direct32(priv, HBUS_TARG_MEM_RDAT);
+		val = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
 		if (val != le32_to_cpu(*image)) {
 			IWL_ERROR("uCode INST section is invalid at "
 				  "offset 0x%x, is 0x%x, s/b 0x%x\n",
@@ -5073,7 +5074,7 @@ static int iwl4965_verify_inst_full(struct iwl_priv *priv, __le32 *image,
 		}
 	}
 
-	iwl4965_release_nic_access(priv);
+	iwl_release_nic_access(priv);
 
 	if (!errcnt)
 		IWL_DEBUG_INFO
@@ -5097,7 +5098,7 @@ static int iwl4965_verify_inst_sparse(struct iwl_priv *priv, __le32 *image, u32
 
 	IWL_DEBUG_INFO("ucode inst image size is %u\n", len);
 
-	rc = iwl4965_grab_nic_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc)
 		return rc;
 
@@ -5105,9 +5106,9 @@ static int iwl4965_verify_inst_sparse(struct iwl_priv *priv, __le32 *image, u32
 		/* read data comes through single port, auto-incr addr */
 		/* NOTE: Use the debugless read so we don't flood kernel log
 		 * if IWL_DL_IO is set */
-		iwl4965_write_direct32(priv, HBUS_TARG_MEM_RADDR,
+		iwl_write_direct32(priv, HBUS_TARG_MEM_RADDR,
 			i + RTC_INST_LOWER_BOUND);
-		val = _iwl4965_read_direct32(priv, HBUS_TARG_MEM_RDAT);
+		val = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
 		if (val != le32_to_cpu(*image)) {
 #if 0 /* Enable this if you want to see details */
 			IWL_ERROR("uCode INST section is invalid at "
@@ -5121,7 +5122,7 @@ static int iwl4965_verify_inst_sparse(struct iwl_priv *priv, __le32 *image, u32
 		}
 	}
 
-	iwl4965_release_nic_access(priv);
+	iwl_release_nic_access(priv);
 
 	return rc;
 }
@@ -5188,11 +5189,11 @@ static int iwl4965_verify_bsm(struct iwl_priv *priv)
 	IWL_DEBUG_INFO("Begin verify bsm\n");
 
 	/* verify BSM SRAM contents */
-	val = iwl4965_read_prph(priv, BSM_WR_DWCOUNT_REG);
+	val = iwl_read_prph(priv, BSM_WR_DWCOUNT_REG);
 	for (reg = BSM_SRAM_LOWER_BOUND;
 	     reg < BSM_SRAM_LOWER_BOUND + len;
 	     reg += sizeof(u32), image ++) {
-		val = iwl4965_read_prph(priv, reg);
+		val = iwl_read_prph(priv, reg);
 		if (val != le32_to_cpu(*image)) {
 			IWL_ERROR("BSM uCode verification failed at "
 				  "addr 0x%08X+%u (of %u), is 0x%x, s/b 0x%x\n",
@@ -5269,42 +5270,42 @@ static int iwl4965_load_bsm(struct iwl_priv *priv)
 	inst_len = priv->ucode_init.len;
 	data_len = priv->ucode_init_data.len;
 
-	rc = iwl4965_grab_nic_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc)
 		return rc;
 
-	iwl4965_write_prph(priv, BSM_DRAM_INST_PTR_REG, pinst);
-	iwl4965_write_prph(priv, BSM_DRAM_DATA_PTR_REG, pdata);
-	iwl4965_write_prph(priv, BSM_DRAM_INST_BYTECOUNT_REG, inst_len);
-	iwl4965_write_prph(priv, BSM_DRAM_DATA_BYTECOUNT_REG, data_len);
+	iwl_write_prph(priv, BSM_DRAM_INST_PTR_REG, pinst);
+	iwl_write_prph(priv, BSM_DRAM_DATA_PTR_REG, pdata);
+	iwl_write_prph(priv, BSM_DRAM_INST_BYTECOUNT_REG, inst_len);
+	iwl_write_prph(priv, BSM_DRAM_DATA_BYTECOUNT_REG, data_len);
 
 	/* Fill BSM memory with bootstrap instructions */
 	for (reg_offset = BSM_SRAM_LOWER_BOUND;
 	     reg_offset < BSM_SRAM_LOWER_BOUND + len;
 	     reg_offset += sizeof(u32), image++)
-		_iwl4965_write_prph(priv, reg_offset,
+		_iwl_write_prph(priv, reg_offset,
 					  le32_to_cpu(*image));
 
 	rc = iwl4965_verify_bsm(priv);
 	if (rc) {
-		iwl4965_release_nic_access(priv);
+		iwl_release_nic_access(priv);
 		return rc;
 	}
 
 	/* Tell BSM to copy from BSM SRAM into instruction SRAM, when asked */
-	iwl4965_write_prph(priv, BSM_WR_MEM_SRC_REG, 0x0);
-	iwl4965_write_prph(priv, BSM_WR_MEM_DST_REG,
+	iwl_write_prph(priv, BSM_WR_MEM_SRC_REG, 0x0);
+	iwl_write_prph(priv, BSM_WR_MEM_DST_REG,
 				 RTC_INST_LOWER_BOUND);
-	iwl4965_write_prph(priv, BSM_WR_DWCOUNT_REG, len / sizeof(u32));
+	iwl_write_prph(priv, BSM_WR_DWCOUNT_REG, len / sizeof(u32));
 
 	/* Load bootstrap code into instruction SRAM now,
 	 *   to prepare to load "initialize" uCode */
-	iwl4965_write_prph(priv, BSM_WR_CTRL_REG,
+	iwl_write_prph(priv, BSM_WR_CTRL_REG,
 		BSM_WR_CTRL_REG_BIT_START);
 
 	/* Wait for load of bootstrap uCode to finish */
 	for (i = 0; i < 100; i++) {
-		done = iwl4965_read_prph(priv, BSM_WR_CTRL_REG);
+		done = iwl_read_prph(priv, BSM_WR_CTRL_REG);
 		if (!(done & BSM_WR_CTRL_REG_BIT_START))
 			break;
 		udelay(10);
@@ -5318,10 +5319,10 @@ static int iwl4965_load_bsm(struct iwl_priv *priv)
 
 	/* Enable future boot loads whenever power management unit triggers it
 	 *   (e.g. when powering back up after power-save shutdown) */
-	iwl4965_write_prph(priv, BSM_WR_CTRL_REG,
+	iwl_write_prph(priv, BSM_WR_CTRL_REG,
 		BSM_WR_CTRL_REG_BIT_START_EN);
 
-	iwl4965_release_nic_access(priv);
+	iwl_release_nic_access(priv);
 
 	return 0;
 }
@@ -5329,7 +5330,7 @@ static int iwl4965_load_bsm(struct iwl_priv *priv)
 static void iwl4965_nic_start(struct iwl_priv *priv)
 {
 	/* Remove all resets to allow NIC to operate */
-	iwl4965_write32(priv, CSR_RESET, 0);
+	iwl_write32(priv, CSR_RESET, 0);
 }
 
 
@@ -5551,24 +5552,24 @@ static int iwl4965_set_ucode_ptrs(struct iwl_priv *priv)
 	pdata = priv->ucode_data_backup.p_addr >> 4;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl4965_grab_nic_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return rc;
 	}
 
 	/* Tell bootstrap uCode where to find image to load */
-	iwl4965_write_prph(priv, BSM_DRAM_INST_PTR_REG, pinst);
-	iwl4965_write_prph(priv, BSM_DRAM_DATA_PTR_REG, pdata);
-	iwl4965_write_prph(priv, BSM_DRAM_DATA_BYTECOUNT_REG,
+	iwl_write_prph(priv, BSM_DRAM_INST_PTR_REG, pinst);
+	iwl_write_prph(priv, BSM_DRAM_DATA_PTR_REG, pdata);
+	iwl_write_prph(priv, BSM_DRAM_DATA_BYTECOUNT_REG,
 				 priv->ucode_data.len);
 
 	/* Inst bytecount must be last to set up, bit 31 signals uCode
 	 *   that all new ptr/size info is in place */
-	iwl4965_write_prph(priv, BSM_DRAM_INST_BYTECOUNT_REG,
+	iwl_write_prph(priv, BSM_DRAM_INST_BYTECOUNT_REG,
 				 priv->ucode_code.len | BSM_DRAM_INST_LOAD);
 
-	iwl4965_release_nic_access(priv);
+	iwl_release_nic_access(priv);
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -5748,7 +5749,7 @@ static void __iwl4965_down(struct iwl_priv *priv)
 		clear_bit(STATUS_EXIT_PENDING, &priv->status);
 
 	/* stop and reset the on-board processor */
-	iwl4965_write32(priv, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
+	iwl_write32(priv, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
 
 	/* tell the device to stop sending interrupts */
 	iwl4965_disable_interrupts(priv);
@@ -5784,7 +5785,7 @@ static void __iwl4965_down(struct iwl_priv *priv)
 				STATUS_FW_ERROR;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	iwl4965_clear_bit(priv, CSR_GP_CNTRL,
+	iwl_clear_bit(priv, CSR_GP_CNTRL,
 			 CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -5792,17 +5793,17 @@ static void __iwl4965_down(struct iwl_priv *priv)
 	iwl4965_hw_rxq_stop(priv);
 
 	spin_lock_irqsave(&priv->lock, flags);
-	if (!iwl4965_grab_nic_access(priv)) {
-		iwl4965_write_prph(priv, APMG_CLK_DIS_REG,
+	if (!iwl_grab_nic_access(priv)) {
+		iwl_write_prph(priv, APMG_CLK_DIS_REG,
 					 APMG_CLK_VAL_DMA_CLK_RQT);
-		iwl4965_release_nic_access(priv);
+		iwl_release_nic_access(priv);
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	udelay(5);
 
 	iwl4965_hw_nic_stop_master(priv);
-	iwl4965_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
+	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
 	iwl4965_hw_nic_reset(priv);
 
  exit:
@@ -5848,7 +5849,7 @@ static int __iwl4965_up(struct iwl_priv *priv)
 	}
 
 	/* If platform's RF_KILL switch is NOT set to KILL */
-	if (iwl4965_read32(priv, CSR_GP_CNTRL) &
+	if (iwl_read32(priv, CSR_GP_CNTRL) &
 				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
 		clear_bit(STATUS_RF_KILL_HW, &priv->status);
 	else {
@@ -5859,7 +5860,7 @@ static int __iwl4965_up(struct iwl_priv *priv)
 		}
 	}
 
-	iwl4965_write32(priv, CSR_INT, 0xFFFFFFFF);
+	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
 
 	rc = iwl4965_hw_nic_init(priv);
 	if (rc) {
@@ -5868,17 +5869,17 @@ static int __iwl4965_up(struct iwl_priv *priv)
 	}
 
 	/* make sure rfkill handshake bits are cleared */
-	iwl4965_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
-	iwl4965_write32(priv, CSR_UCODE_DRV_GP1_CLR,
+	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR,
 		    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
 
 	/* clear (again), then enable host interrupts */
-	iwl4965_write32(priv, CSR_INT, 0xFFFFFFFF);
+	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
 	iwl4965_enable_interrupts(priv);
 
 	/* really make sure rfkill handshake bits are cleared */
-	iwl4965_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
-	iwl4965_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
 
 	/* Copy original ucode data image from disk into backup cache.
 	 * This will be used to initialize the on-board processor's
@@ -8078,11 +8079,11 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	 * 4. Read EEPROM
 	 *****************/
 	/* nic init */
-	iwl4965_set_bit(priv, CSR_GIO_CHICKEN_BITS,
+	iwl_set_bit(priv, CSR_GIO_CHICKEN_BITS,
 		CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER);
 
-	iwl4965_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
-	err = iwl4965_poll_bit(priv, CSR_GP_CNTRL,
+	iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+	err = iwl_poll_bit(priv, CSR_GP_CNTRL,
 		CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
 		CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
 	if (err < 0) {
-- 
1.5.3.4

