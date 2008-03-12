Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:51341 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbYCMAEA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2008 20:04:00 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/5] iwlwifi: rename iwl-4965-debug.h back to iwl-debug.h
Date: Wed, 12 Mar 2008 16:58:49 -0700
Message-Id: <1205366332-12652-3-git-send-email-reinette.chatre@intel.com> (sfid-20080313_000410_264720_7A89F144)
In-Reply-To: <1205366332-12652-2-git-send-email-reinette.chatre@intel.com>
References: <1205366332-12652-1-git-send-email-reinette.chatre@intel.com>
 <1205366332-12652-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch removes iwl-4965-debug.h to iwl-debug.h
It will be used by more NICs

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965-debug.h |  168 -------------------------
 drivers/net/wireless/iwlwifi/iwl-4965-io.h    |   36 +++---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c    |    4 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c       |    6 +-
 drivers/net/wireless/iwlwifi/iwl-4965.h       |    4 +-
 drivers/net/wireless/iwlwifi/iwl-core.c       |    8 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h      |  168 +++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-eeprom.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c   |   56 ++++----
 10 files changed, 227 insertions(+), 227 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-4965-debug.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-debug.h

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 5b7c016..acb8079 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -50,7 +50,7 @@ config IWL4965_SENSITIVITY
 	  This option will enable sensitivity calibration for the iwl4965
 	  driver.
 
-config IWL4965_DEBUG
+config IWLWIFI_DEBUG
 	bool "Enable full debugging output in iwl4965 driver"
 	depends on IWL4965
 	---help---
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-debug.h b/drivers/net/wireless/iwlwifi/iwl-4965-debug.h
deleted file mode 100644
index df32948..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-4965-debug.h
+++ /dev/null
@@ -1,168 +0,0 @@
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
-#ifndef __iwl4965_debug_h__
-#define __iwl4965_debug_h__
-
-#ifdef CONFIG_IWL4965_DEBUG
-extern u32 iwl4965_debug_level;
-#define IWL_DEBUG(level, fmt, args...) \
-do { if (iwl4965_debug_level & (level)) \
-  printk(KERN_ERR DRV_NAME": %c %s " fmt, \
-	 in_interrupt() ? 'I' : 'U', __FUNCTION__ , ## args); } while (0)
-
-#define IWL_DEBUG_LIMIT(level, fmt, args...) \
-do { if ((iwl4965_debug_level & (level)) && net_ratelimit()) \
-  printk(KERN_ERR DRV_NAME": %c %s " fmt, \
-	 in_interrupt() ? 'I' : 'U', __FUNCTION__ , ## args); } while (0)
-
-static inline void iwl4965_print_hex_dump(int level, void *p, u32 len)
-{
-	if (!(iwl4965_debug_level & level))
-		return;
-
-	print_hex_dump(KERN_DEBUG, "iwl data: ", DUMP_PREFIX_OFFSET, 16, 1,
-			p, len, 1);
-}
-#else
-
-static inline void IWL_DEBUG(int level, const char *fmt, ...)
-{
-}
-static inline void IWL_DEBUG_LIMIT(int level, const char *fmt, ...)
-{
-}
-static inline void iwl4965_print_hex_dump(int level, void *p, u32 len)
-{
-}
-#endif				/* CONFIG_IWL4965_DEBUG */
-
-
-
-/*
- * To use the debug system;
- *
- * If you are defining a new debug classification, simply add it to the #define
- * list here in the form of:
- *
- * #define IWL_DL_xxxx VALUE
- *
- * shifting value to the left one bit from the previous entry.  xxxx should be
- * the name of the classification (for example, WEP)
- *
- * You then need to either add a IWL_xxxx_DEBUG() macro definition for your
- * classification, or use IWL_DEBUG(IWL_DL_xxxx, ...) whenever you want
- * to send output to that classification.
- *
- * To add your debug level to the list of levels seen when you perform
- *
- * % cat /proc/net/iwl/debug_level
- *
- * you simply need to add your entry to the iwl4965_debug_levels array.
- *
- * If you do not see debug_level in /proc/net/iwl then you do not have
- * CONFIG_IWL4965_DEBUG defined in your kernel configuration
- *
- */
-
-#define IWL_DL_INFO          (1 << 0)
-#define IWL_DL_MAC80211      (1 << 1)
-#define IWL_DL_HOST_COMMAND  (1 << 2)
-#define IWL_DL_STATE         (1 << 3)
-
-#define IWL_DL_RADIO         (1 << 7)
-#define IWL_DL_POWER         (1 << 8)
-#define IWL_DL_TEMP          (1 << 9)
-
-#define IWL_DL_NOTIF         (1 << 10)
-#define IWL_DL_SCAN          (1 << 11)
-#define IWL_DL_ASSOC         (1 << 12)
-#define IWL_DL_DROP          (1 << 13)
-
-#define IWL_DL_TXPOWER       (1 << 14)
-
-#define IWL_DL_AP            (1 << 15)
-
-#define IWL_DL_FW            (1 << 16)
-#define IWL_DL_RF_KILL       (1 << 17)
-#define IWL_DL_FW_ERRORS     (1 << 18)
-
-#define IWL_DL_LED           (1 << 19)
-
-#define IWL_DL_RATE          (1 << 20)
-
-#define IWL_DL_CALIB         (1 << 21)
-#define IWL_DL_WEP           (1 << 22)
-#define IWL_DL_TX            (1 << 23)
-#define IWL_DL_RX            (1 << 24)
-#define IWL_DL_ISR           (1 << 25)
-#define IWL_DL_HT            (1 << 26)
-#define IWL_DL_IO            (1 << 27)
-#define IWL_DL_11H           (1 << 28)
-
-#define IWL_DL_STATS         (1 << 29)
-#define IWL_DL_TX_REPLY      (1 << 30)
-#define IWL_DL_QOS           (1 << 31)
-
-#define IWL_ERROR(f, a...) printk(KERN_ERR DRV_NAME ": " f, ## a)
-#define IWL_WARNING(f, a...) printk(KERN_WARNING DRV_NAME ": " f, ## a)
-#define IWL_DEBUG_INFO(f, a...)    IWL_DEBUG(IWL_DL_INFO, f, ## a)
-
-#define IWL_DEBUG_MAC80211(f, a...)     IWL_DEBUG(IWL_DL_MAC80211, f, ## a)
-#define IWL_DEBUG_TEMP(f, a...)   IWL_DEBUG(IWL_DL_TEMP, f, ## a)
-#define IWL_DEBUG_SCAN(f, a...)   IWL_DEBUG(IWL_DL_SCAN, f, ## a)
-#define IWL_DEBUG_RX(f, a...)     IWL_DEBUG(IWL_DL_RX, f, ## a)
-#define IWL_DEBUG_TX(f, a...)     IWL_DEBUG(IWL_DL_TX, f, ## a)
-#define IWL_DEBUG_ISR(f, a...)    IWL_DEBUG(IWL_DL_ISR, f, ## a)
-#define IWL_DEBUG_LED(f, a...) IWL_DEBUG(IWL_DL_LED, f, ## a)
-#define IWL_DEBUG_WEP(f, a...)    IWL_DEBUG(IWL_DL_WEP, f, ## a)
-#define IWL_DEBUG_HC(f, a...) IWL_DEBUG(IWL_DL_HOST_COMMAND, f, ## a)
-#define IWL_DEBUG_CALIB(f, a...) IWL_DEBUG(IWL_DL_CALIB, f, ## a)
-#define IWL_DEBUG_FW(f, a...) IWL_DEBUG(IWL_DL_FW, f, ## a)
-#define IWL_DEBUG_RF_KILL(f, a...) IWL_DEBUG(IWL_DL_RF_KILL, f, ## a)
-#define IWL_DEBUG_DROP(f, a...) IWL_DEBUG(IWL_DL_DROP, f, ## a)
-#define IWL_DEBUG_DROP_LIMIT(f, a...) IWL_DEBUG_LIMIT(IWL_DL_DROP, f, ## a)
-#define IWL_DEBUG_AP(f, a...) IWL_DEBUG(IWL_DL_AP, f, ## a)
-#define IWL_DEBUG_TXPOWER(f, a...) IWL_DEBUG(IWL_DL_TXPOWER, f, ## a)
-#define IWL_DEBUG_IO(f, a...) IWL_DEBUG(IWL_DL_IO, f, ## a)
-#define IWL_DEBUG_RATE(f, a...) IWL_DEBUG(IWL_DL_RATE, f, ## a)
-#define IWL_DEBUG_RATE_LIMIT(f, a...) IWL_DEBUG_LIMIT(IWL_DL_RATE, f, ## a)
-#define IWL_DEBUG_NOTIF(f, a...) IWL_DEBUG(IWL_DL_NOTIF, f, ## a)
-#define IWL_DEBUG_ASSOC(f, a...) IWL_DEBUG(IWL_DL_ASSOC | IWL_DL_INFO, f, ## a)
-#define IWL_DEBUG_ASSOC_LIMIT(f, a...) \
-	IWL_DEBUG_LIMIT(IWL_DL_ASSOC | IWL_DL_INFO, f, ## a)
-#define IWL_DEBUG_HT(f, a...) IWL_DEBUG(IWL_DL_HT, f, ## a)
-#define IWL_DEBUG_STATS(f, a...) IWL_DEBUG(IWL_DL_STATS, f, ## a)
-#define IWL_DEBUG_STATS_LIMIT(f, a...) IWL_DEBUG_LIMIT(IWL_DL_STATS, f, ## a)
-#define IWL_DEBUG_TX_REPLY(f, a...) IWL_DEBUG(IWL_DL_TX_REPLY, f, ## a)
-#define IWL_DEBUG_QOS(f, a...)   IWL_DEBUG(IWL_DL_QOS, f, ## a)
-#define IWL_DEBUG_RADIO(f, a...)  IWL_DEBUG(IWL_DL_RADIO, f, ## a)
-#define IWL_DEBUG_POWER(f, a...)  IWL_DEBUG(IWL_DL_POWER, f, ## a)
-#define IWL_DEBUG_11H(f, a...)  IWL_DEBUG(IWL_DL_11H, f, ## a)
-
-#endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-io.h b/drivers/net/wireless/iwlwifi/iwl-4965-io.h
index 07fca88..3accdfb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-io.h
@@ -31,7 +31,7 @@
 
 #include <linux/io.h>
 
-#include "iwl-4965-debug.h"
+#include "iwl-debug.h"
 
 /*
  * IO, register, and NIC memory access functions
@@ -60,7 +60,7 @@
  */
 
 #define _iwl4965_write32(priv, ofs, val) writel((val), (priv)->hw_base + (ofs))
-#ifdef CONFIG_IWL4965_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 static inline void __iwl4965_write32(const char *f, u32 l, struct iwl4965_priv *priv,
 				 u32 ofs, u32 val)
 {
@@ -74,7 +74,7 @@ static inline void __iwl4965_write32(const char *f, u32 l, struct iwl4965_priv *
 #endif
 
 #define _iwl4965_read32(priv, ofs) readl((priv)->hw_base + (ofs))
-#ifdef CONFIG_IWL4965_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 static inline u32 __iwl4965_read32(char *f, u32 l, struct iwl4965_priv *priv, u32 ofs)
 {
 	IWL_DEBUG_IO("read_direct32(0x%08X) - %s %d\n", ofs, f, l);
@@ -99,7 +99,7 @@ static inline int _iwl4965_poll_bit(struct iwl4965_priv *priv, u32 addr,
 
 	return -ETIMEDOUT;
 }
-#ifdef CONFIG_IWL4965_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 static inline int __iwl4965_poll_bit(const char *f, u32 l,
 				 struct iwl4965_priv *priv, u32 addr,
 				 u32 bits, u32 mask, int timeout)
@@ -120,7 +120,7 @@ static inline void _iwl4965_set_bit(struct iwl4965_priv *priv, u32 reg, u32 mask
 {
 	_iwl4965_write32(priv, reg, _iwl4965_read32(priv, reg) | mask);
 }
-#ifdef CONFIG_IWL4965_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 static inline void __iwl4965_set_bit(const char *f, u32 l,
 				 struct iwl4965_priv *priv, u32 reg, u32 mask)
 {
@@ -137,7 +137,7 @@ static inline void _iwl4965_clear_bit(struct iwl4965_priv *priv, u32 reg, u32 ma
 {
 	_iwl4965_write32(priv, reg, _iwl4965_read32(priv, reg) & ~mask);
 }
-#ifdef CONFIG_IWL4965_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 static inline void __iwl4965_clear_bit(const char *f, u32 l,
 				   struct iwl4965_priv *priv, u32 reg, u32 mask)
 {
@@ -155,7 +155,7 @@ static inline int _iwl4965_grab_nic_access(struct iwl4965_priv *priv)
 	int ret;
 	u32 gp_ctl;
 
-#ifdef CONFIG_IWL4965_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 	if (atomic_read(&priv->restrict_refcnt))
 		return 0;
 #endif
@@ -186,13 +186,13 @@ static inline int _iwl4965_grab_nic_access(struct iwl4965_priv *priv)
 		return -EIO;
 	}
 
-#ifdef CONFIG_IWL4965_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 	atomic_inc(&priv->restrict_refcnt);
 #endif
 	return 0;
 }
 
-#ifdef CONFIG_IWL4965_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 static inline int __iwl4965_grab_nic_access(const char *f, u32 l,
 					       struct iwl4965_priv *priv)
 {
@@ -212,13 +212,13 @@ static inline int __iwl4965_grab_nic_access(const char *f, u32 l,
 
 static inline void _iwl4965_release_nic_access(struct iwl4965_priv *priv)
 {
-#ifdef CONFIG_IWL4965_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 	if (atomic_dec_and_test(&priv->restrict_refcnt))
 #endif
 		_iwl4965_clear_bit(priv, CSR_GP_CNTRL,
 			       CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 }
-#ifdef CONFIG_IWL4965_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 static inline void __iwl4965_release_nic_access(const char *f, u32 l,
 					    struct iwl4965_priv *priv)
 {
@@ -239,7 +239,7 @@ static inline u32 _iwl4965_read_direct32(struct iwl4965_priv *priv, u32 reg)
 {
 	return _iwl4965_read32(priv, reg);
 }
-#ifdef CONFIG_IWL4965_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 static inline u32 __iwl4965_read_direct32(const char *f, u32 l,
 					struct iwl4965_priv *priv, u32 reg)
 {
@@ -261,7 +261,7 @@ static inline void _iwl4965_write_direct32(struct iwl4965_priv *priv,
 {
 	_iwl4965_write32(priv, reg, value);
 }
-#ifdef CONFIG_IWL4965_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 static void __iwl4965_write_direct32(u32 line,
 				   struct iwl4965_priv *priv, u32 reg, u32 value)
 {
@@ -301,7 +301,7 @@ static inline int _iwl4965_poll_direct_bit(struct iwl4965_priv *priv,
 	return -ETIMEDOUT;
 }
 
-#ifdef CONFIG_IWL4965_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 static inline int __iwl4965_poll_direct_bit(const char *f, u32 l,
 					    struct iwl4965_priv *priv,
 					    u32 addr, u32 mask, int timeout)
@@ -327,7 +327,7 @@ static inline u32 _iwl4965_read_prph(struct iwl4965_priv *priv, u32 reg)
 	_iwl4965_write_direct32(priv, HBUS_TARG_PRPH_RADDR, reg | (3 << 24));
 	return _iwl4965_read_direct32(priv, HBUS_TARG_PRPH_RDAT);
 }
-#ifdef CONFIG_IWL4965_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 static inline u32 __iwl4965_read_prph(u32 line, struct iwl4965_priv *priv, u32 reg)
 {
 	if (!atomic_read(&priv->restrict_refcnt))
@@ -348,7 +348,7 @@ static inline void _iwl4965_write_prph(struct iwl4965_priv *priv,
 			      ((addr & 0x0000FFFF) | (3 << 24)));
 	_iwl4965_write_direct32(priv, HBUS_TARG_PRPH_WDAT, val);
 }
-#ifdef CONFIG_IWL4965_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 static inline void __iwl4965_write_prph(u32 line, struct iwl4965_priv *priv,
 					      u32 addr, u32 val)
 {
@@ -365,7 +365,7 @@ static inline void __iwl4965_write_prph(u32 line, struct iwl4965_priv *priv,
 
 #define _iwl4965_set_bits_prph(priv, reg, mask) \
 	_iwl4965_write_prph(priv, reg, (_iwl4965_read_prph(priv, reg) | mask))
-#ifdef CONFIG_IWL4965_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 static inline void __iwl4965_set_bits_prph(u32 line, struct iwl4965_priv *priv,
 					u32 reg, u32 mask)
 {
@@ -383,7 +383,7 @@ static inline void __iwl4965_set_bits_prph(u32 line, struct iwl4965_priv *priv,
 #define _iwl4965_set_bits_mask_prph(priv, reg, bits, mask) \
 	_iwl4965_write_prph(priv, reg, ((_iwl4965_read_prph(priv, reg) & mask) | bits))
 
-#ifdef CONFIG_IWL4965_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 static inline void __iwl4965_set_bits_mask_prph(u32 line,
 		struct iwl4965_priv *priv, u32 reg, u32 bits, u32 mask)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index 4b46226..7733b23 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -244,7 +244,7 @@ static inline u8 iwl4965_rate_get_rate(u32 rate_n_flags)
 static int rs_send_lq_cmd(struct iwl4965_priv *priv,
 			  struct iwl4965_link_quality_cmd *lq, u8 flags)
 {
-#ifdef CONFIG_IWL4965_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 	int i;
 #endif
 	struct iwl4965_host_cmd cmd = {
@@ -265,7 +265,7 @@ static int rs_send_lq_cmd(struct iwl4965_priv *priv,
 	IWL_DEBUG_RATE("lq dta 0x%X 0x%X\n",
 		       lq->general_params.single_stream_ant_msk,
 		       lq->general_params.dual_stream_ant_msk);
-#ifdef CONFIG_IWL4965_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++)
 		IWL_DEBUG_RATE("lq index %d 0x%X\n",
 				i, lq->rs_table[i].rate_n_flags);
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 3401f2a..2896af2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -3583,7 +3583,7 @@ static void iwl4965_update_ps_mode(struct iwl4965_priv *priv, u16 ps_bit, u8 *ad
 		}
 	}
 }
-#ifdef CONFIG_IWL4965_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 
 /**
  * iwl4965_dbg_report_frame - dump frame to syslog during debug sessions
@@ -3623,7 +3623,7 @@ static void iwl4965_dbg_report_frame(struct iwl4965_priv *priv,
 	struct iwl4965_rx_frame_end *rx_end = IWL_RX_END(pkt);
 	u8 *data = IWL_RX_DATA(pkt);
 
-	if (likely(!(iwl4965_debug_level & IWL_DL_RX)))
+	if (likely(!(iwl_debug_level & IWL_DL_RX)))
 		return;
 
 	/* MAC header */
@@ -3726,7 +3726,7 @@ static void iwl4965_dbg_report_frame(struct iwl4965_priv *priv,
 		}
 	}
 	if (print_dump)
-		iwl4965_print_hex_dump(IWL_DL_RX, data, length);
+		iwl_print_hex_dump(IWL_DL_RX, data, length);
 }
 #else
 static inline void iwl4965_dbg_report_frame(struct iwl4965_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index f4e395f..4426d0f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -44,7 +44,7 @@ extern struct pci_device_id iwl4965_hw_card_ids[];
 #include "iwl-4965-hw.h"
 #include "iwl-csr.h"
 #include "iwl-prph.h"
-#include "iwl-4965-debug.h"
+#include "iwl-debug.h"
 
 /* Change firmware file name, using "-" and incrementing number,
  *   *only* when uCode interface or architecture changes so that it
@@ -1202,7 +1202,7 @@ struct iwl4965_priv {
 	u32 pm_state[16];
 #endif
 
-#ifdef CONFIG_IWL4965_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 	/* debugging info */
 	u32 framecnt_to_us;
 	atomic_t restrict_refcnt;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 9ca5398..4645d19 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -30,7 +30,7 @@
 #include <linux/module.h>
 #include <linux/version.h>
 
-#include "iwl-4965-debug.h"
+#include "iwl-debug.h"
 #include "iwl-eeprom.h"
 #include "iwl-core.h"
 
@@ -39,7 +39,7 @@ MODULE_VERSION(IWLWIFI_VERSION);
 MODULE_AUTHOR(DRV_COPYRIGHT);
 MODULE_LICENSE("GPL/BSD");
 
-#ifdef CONFIG_IWL4965_DEBUG
-u32 iwl4965_debug_level;
-EXPORT_SYMBOL(iwl4965_debug_level);
+#ifdef CONFIG_IWLWIFI_DEBUG
+u32 iwl_debug_level;
+EXPORT_SYMBOL(iwl_debug_level);
 #endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
new file mode 100644
index 0000000..0677006
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -0,0 +1,168 @@
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
+#ifndef __iwl_debug_h__
+#define __iwl_debug_h__
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+extern u32 iwl_debug_level;
+#define IWL_DEBUG(level, fmt, args...) \
+do { if (iwl_debug_level & (level)) \
+  printk(KERN_ERR DRV_NAME": %c %s " fmt, \
+	 in_interrupt() ? 'I' : 'U', __FUNCTION__ , ## args); } while (0)
+
+#define IWL_DEBUG_LIMIT(level, fmt, args...) \
+do { if ((iwl_debug_level & (level)) && net_ratelimit()) \
+  printk(KERN_ERR DRV_NAME": %c %s " fmt, \
+	 in_interrupt() ? 'I' : 'U', __FUNCTION__ , ## args); } while (0)
+
+static inline void iwl_print_hex_dump(int level, void *p, u32 len)
+{
+	if (!(iwl_debug_level & level))
+		return;
+
+	print_hex_dump(KERN_DEBUG, "iwl data: ", DUMP_PREFIX_OFFSET, 16, 1,
+			p, len, 1);
+}
+#else
+
+static inline void IWL_DEBUG(int level, const char *fmt, ...)
+{
+}
+static inline void IWL_DEBUG_LIMIT(int level, const char *fmt, ...)
+{
+}
+static inline void iwl_print_hex_dump(int level, void *p, u32 len)
+{
+}
+#endif				/* CONFIG_IWLWIFI_DEBUG */
+
+
+
+/*
+ * To use the debug system;
+ *
+ * If you are defining a new debug classification, simply add it to the #define
+ * list here in the form of:
+ *
+ * #define IWL_DL_xxxx VALUE
+ *
+ * shifting value to the left one bit from the previous entry.  xxxx should be
+ * the name of the classification (for example, WEP)
+ *
+ * You then need to either add a IWL_xxxx_DEBUG() macro definition for your
+ * classification, or use IWL_DEBUG(IWL_DL_xxxx, ...) whenever you want
+ * to send output to that classification.
+ *
+ * To add your debug level to the list of levels seen when you perform
+ *
+ * % cat /proc/net/iwl/debug_level
+ *
+ * you simply need to add your entry to the iwl_debug_levels array.
+ *
+ * If you do not see debug_level in /proc/net/iwl then you do not have
+ * CONFIG_IWLWIFI_DEBUG defined in your kernel configuration
+ *
+ */
+
+#define IWL_DL_INFO          (1 << 0)
+#define IWL_DL_MAC80211      (1 << 1)
+#define IWL_DL_HOST_COMMAND  (1 << 2)
+#define IWL_DL_STATE         (1 << 3)
+
+#define IWL_DL_RADIO         (1 << 7)
+#define IWL_DL_POWER         (1 << 8)
+#define IWL_DL_TEMP          (1 << 9)
+
+#define IWL_DL_NOTIF         (1 << 10)
+#define IWL_DL_SCAN          (1 << 11)
+#define IWL_DL_ASSOC         (1 << 12)
+#define IWL_DL_DROP          (1 << 13)
+
+#define IWL_DL_TXPOWER       (1 << 14)
+
+#define IWL_DL_AP            (1 << 15)
+
+#define IWL_DL_FW            (1 << 16)
+#define IWL_DL_RF_KILL       (1 << 17)
+#define IWL_DL_FW_ERRORS     (1 << 18)
+
+#define IWL_DL_LED           (1 << 19)
+
+#define IWL_DL_RATE          (1 << 20)
+
+#define IWL_DL_CALIB         (1 << 21)
+#define IWL_DL_WEP           (1 << 22)
+#define IWL_DL_TX            (1 << 23)
+#define IWL_DL_RX            (1 << 24)
+#define IWL_DL_ISR           (1 << 25)
+#define IWL_DL_HT            (1 << 26)
+#define IWL_DL_IO            (1 << 27)
+#define IWL_DL_11H           (1 << 28)
+
+#define IWL_DL_STATS         (1 << 29)
+#define IWL_DL_TX_REPLY      (1 << 30)
+#define IWL_DL_QOS           (1 << 31)
+
+#define IWL_ERROR(f, a...) printk(KERN_ERR DRV_NAME ": " f, ## a)
+#define IWL_WARNING(f, a...) printk(KERN_WARNING DRV_NAME ": " f, ## a)
+#define IWL_DEBUG_INFO(f, a...)    IWL_DEBUG(IWL_DL_INFO, f, ## a)
+
+#define IWL_DEBUG_MAC80211(f, a...)     IWL_DEBUG(IWL_DL_MAC80211, f, ## a)
+#define IWL_DEBUG_TEMP(f, a...)   IWL_DEBUG(IWL_DL_TEMP, f, ## a)
+#define IWL_DEBUG_SCAN(f, a...)   IWL_DEBUG(IWL_DL_SCAN, f, ## a)
+#define IWL_DEBUG_RX(f, a...)     IWL_DEBUG(IWL_DL_RX, f, ## a)
+#define IWL_DEBUG_TX(f, a...)     IWL_DEBUG(IWL_DL_TX, f, ## a)
+#define IWL_DEBUG_ISR(f, a...)    IWL_DEBUG(IWL_DL_ISR, f, ## a)
+#define IWL_DEBUG_LED(f, a...) IWL_DEBUG(IWL_DL_LED, f, ## a)
+#define IWL_DEBUG_WEP(f, a...)    IWL_DEBUG(IWL_DL_WEP, f, ## a)
+#define IWL_DEBUG_HC(f, a...) IWL_DEBUG(IWL_DL_HOST_COMMAND, f, ## a)
+#define IWL_DEBUG_CALIB(f, a...) IWL_DEBUG(IWL_DL_CALIB, f, ## a)
+#define IWL_DEBUG_FW(f, a...) IWL_DEBUG(IWL_DL_FW, f, ## a)
+#define IWL_DEBUG_RF_KILL(f, a...) IWL_DEBUG(IWL_DL_RF_KILL, f, ## a)
+#define IWL_DEBUG_DROP(f, a...) IWL_DEBUG(IWL_DL_DROP, f, ## a)
+#define IWL_DEBUG_DROP_LIMIT(f, a...) IWL_DEBUG_LIMIT(IWL_DL_DROP, f, ## a)
+#define IWL_DEBUG_AP(f, a...) IWL_DEBUG(IWL_DL_AP, f, ## a)
+#define IWL_DEBUG_TXPOWER(f, a...) IWL_DEBUG(IWL_DL_TXPOWER, f, ## a)
+#define IWL_DEBUG_IO(f, a...) IWL_DEBUG(IWL_DL_IO, f, ## a)
+#define IWL_DEBUG_RATE(f, a...) IWL_DEBUG(IWL_DL_RATE, f, ## a)
+#define IWL_DEBUG_RATE_LIMIT(f, a...) IWL_DEBUG_LIMIT(IWL_DL_RATE, f, ## a)
+#define IWL_DEBUG_NOTIF(f, a...) IWL_DEBUG(IWL_DL_NOTIF, f, ## a)
+#define IWL_DEBUG_ASSOC(f, a...) IWL_DEBUG(IWL_DL_ASSOC | IWL_DL_INFO, f, ## a)
+#define IWL_DEBUG_ASSOC_LIMIT(f, a...) \
+	IWL_DEBUG_LIMIT(IWL_DL_ASSOC | IWL_DL_INFO, f, ## a)
+#define IWL_DEBUG_HT(f, a...) IWL_DEBUG(IWL_DL_HT, f, ## a)
+#define IWL_DEBUG_STATS(f, a...) IWL_DEBUG(IWL_DL_STATS, f, ## a)
+#define IWL_DEBUG_STATS_LIMIT(f, a...) IWL_DEBUG_LIMIT(IWL_DL_STATS, f, ## a)
+#define IWL_DEBUG_TX_REPLY(f, a...) IWL_DEBUG(IWL_DL_TX_REPLY, f, ## a)
+#define IWL_DEBUG_QOS(f, a...)   IWL_DEBUG(IWL_DL_QOS, f, ## a)
+#define IWL_DEBUG_RADIO(f, a...)  IWL_DEBUG(IWL_DL_RADIO, f, ## a)
+#define IWL_DEBUG_POWER(f, a...)  IWL_DEBUG(IWL_DL_POWER, f, ## a)
+#define IWL_DEBUG_11H(f, a...)  IWL_DEBUG(IWL_DL_11H, f, ## a)
+
+#endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 0064387..4fd1b36 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -71,7 +71,7 @@
 #include "iwl-4965-commands.h"
 #include "iwl-4965.h"
 #include "iwl-core.h"
-#include "iwl-4965-debug.h"
+#include "iwl-debug.h"
 #include "iwl-eeprom.h"
 #include "iwl-4965-io.h"
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index d0cb36b..e05bc90 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -76,7 +76,7 @@ int iwl4965_param_amsdu_size_8K;   /* def: enable 8K amsdu size */
 
 #define DRV_DESCRIPTION	"Intel(R) Wireless WiFi Link 4965AGN driver for Linux"
 
-#ifdef CONFIG_IWL4965_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 #define VD "d"
 #else
 #define VD
@@ -2578,7 +2578,7 @@ static int iwl4965_get_sta_id(struct iwl4965_priv *priv,
 		IWL_DEBUG_DROP("Station %s not in station map. "
 			       "Defaulting to broadcast...\n",
 			       print_mac(mac, hdr->addr1));
-		iwl4965_print_hex_dump(IWL_DL_DROP, (u8 *) hdr, sizeof(*hdr));
+		iwl_print_hex_dump(IWL_DL_DROP, (u8 *) hdr, sizeof(*hdr));
 		return priv->hw_setting.bcast_sta_id;
 
 	default:
@@ -2634,7 +2634,7 @@ static int iwl4965_tx_skb(struct iwl4965_priv *priv,
 
 	fc = le16_to_cpu(hdr->frame_control);
 
-#ifdef CONFIG_IWL4965_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 	if (ieee80211_is_auth(fc))
 		IWL_DEBUG_TX("Sending AUTH frame\n");
 	else if (ieee80211_is_assoc_request(fc))
@@ -2792,10 +2792,10 @@ static int iwl4965_tx_skb(struct iwl4965_priv *priv,
 		txq->need_update = 0;
 	}
 
-	iwl4965_print_hex_dump(IWL_DL_TX, out_cmd->cmd.payload,
+	iwl_print_hex_dump(IWL_DL_TX, out_cmd->cmd.payload,
 			   sizeof(out_cmd->cmd.tx));
 
-	iwl4965_print_hex_dump(IWL_DL_TX, (u8 *)out_cmd->cmd.tx.hdr,
+	iwl_print_hex_dump(IWL_DL_TX, (u8 *)out_cmd->cmd.tx.hdr,
 			   ieee80211_get_hdrlen(fc));
 
 	/* Set up entry for this TFD in Tx byte-count array */
@@ -3590,7 +3590,7 @@ static void iwl4965_rx_spectrum_measure_notif(struct iwl4965_priv *priv,
 static void iwl4965_rx_pm_sleep_notif(struct iwl4965_priv *priv,
 				  struct iwl4965_rx_mem_buffer *rxb)
 {
-#ifdef CONFIG_IWL4965_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl4965_sleep_notification *sleep = &(pkt->u.sleep_notif);
 	IWL_DEBUG_RX("sleep mode: %d, src: %d\n",
@@ -3605,7 +3605,7 @@ static void iwl4965_rx_pm_debug_statistics_notif(struct iwl4965_priv *priv,
 	IWL_DEBUG_RADIO("Dumping %d bytes of unhandled "
 			"notification for %s:\n",
 			le32_to_cpu(pkt->len), get_cmd_string(pkt->hdr.cmd));
-	iwl4965_print_hex_dump(IWL_DL_RADIO, pkt->u.raw, le32_to_cpu(pkt->len));
+	iwl_print_hex_dump(IWL_DL_RADIO, pkt->u.raw, le32_to_cpu(pkt->len));
 }
 
 static void iwl4965_bg_beacon_update(struct work_struct *work)
@@ -3636,7 +3636,7 @@ static void iwl4965_bg_beacon_update(struct work_struct *work)
 static void iwl4965_rx_beacon_notif(struct iwl4965_priv *priv,
 				struct iwl4965_rx_mem_buffer *rxb)
 {
-#ifdef CONFIG_IWL4965_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl4965_beacon_notif *beacon = &(pkt->u.beacon_status);
 	u8 rate = iwl4965_hw_get_rate(beacon->beacon_notify_hdr.rate_n_flags);
@@ -3659,7 +3659,7 @@ static void iwl4965_rx_beacon_notif(struct iwl4965_priv *priv,
 static void iwl4965_rx_reply_scan(struct iwl4965_priv *priv,
 			      struct iwl4965_rx_mem_buffer *rxb)
 {
-#ifdef CONFIG_IWL4965_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl4965_scanreq_notification *notif =
 	    (struct iwl4965_scanreq_notification *)pkt->u.raw;
@@ -4510,13 +4510,13 @@ static int iwl4965_tx_queue_update_write_ptr(struct iwl4965_priv *priv,
 	return rc;
 }
 
-#ifdef CONFIG_IWL4965_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 static void iwl4965_print_rx_config_cmd(struct iwl4965_rxon_cmd *rxon)
 {
 	DECLARE_MAC_BUF(mac);
 
 	IWL_DEBUG_RADIO("RX CONFIG:\n");
-	iwl4965_print_hex_dump(IWL_DL_RADIO, (u8 *) rxon, sizeof(*rxon));
+	iwl_print_hex_dump(IWL_DL_RADIO, (u8 *) rxon, sizeof(*rxon));
 	IWL_DEBUG_RADIO("u16 channel: 0x%x\n", le16_to_cpu(rxon->channel));
 	IWL_DEBUG_RADIO("u32 flags: 0x%08X\n", le32_to_cpu(rxon->flags));
 	IWL_DEBUG_RADIO("u32 filter_flags: 0x%08x\n",
@@ -4733,8 +4733,8 @@ static void iwl4965_irq_handle_error(struct iwl4965_priv *priv)
 	/* Cancel currently queued command. */
 	clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
 
-#ifdef CONFIG_IWL4965_DEBUG
-	if (iwl4965_debug_level & IWL_DL_FW_ERRORS) {
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if (iwl_debug_level & IWL_DL_FW_ERRORS) {
 		iwl4965_dump_nic_error_log(priv);
 		iwl4965_dump_nic_event_log(priv);
 		iwl4965_print_rx_config_cmd(&priv->staging_rxon);
@@ -4782,7 +4782,7 @@ static void iwl4965_irq_tasklet(struct iwl4965_priv *priv)
 	u32 inta, handled = 0;
 	u32 inta_fh;
 	unsigned long flags;
-#ifdef CONFIG_IWL4965_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 	u32 inta_mask;
 #endif
 
@@ -4800,8 +4800,8 @@ static void iwl4965_irq_tasklet(struct iwl4965_priv *priv)
 	inta_fh = iwl4965_read32(priv, CSR_FH_INT_STATUS);
 	iwl4965_write32(priv, CSR_FH_INT_STATUS, inta_fh);
 
-#ifdef CONFIG_IWL4965_DEBUG
-	if (iwl4965_debug_level & IWL_DL_ISR) {
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if (iwl_debug_level & IWL_DL_ISR) {
 		/* just for debug */
 		inta_mask = iwl4965_read32(priv, CSR_INT_MASK);
 		IWL_DEBUG_ISR("inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
@@ -4834,8 +4834,8 @@ static void iwl4965_irq_tasklet(struct iwl4965_priv *priv)
 		return;
 	}
 
-#ifdef CONFIG_IWL4965_DEBUG
-	if (iwl4965_debug_level & (IWL_DL_ISR)) {
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if (iwl_debug_level & (IWL_DL_ISR)) {
 		/* NIC fires this, but we don't use it, redundant with WAKEUP */
 		if (inta & CSR_INT_BIT_SCD)
 			IWL_DEBUG_ISR("Scheduler finished to transmit "
@@ -4925,8 +4925,8 @@ static void iwl4965_irq_tasklet(struct iwl4965_priv *priv)
 	/* Re-enable all interrupts */
 	iwl4965_enable_interrupts(priv);
 
-#ifdef CONFIG_IWL4965_DEBUG
-	if (iwl4965_debug_level & (IWL_DL_ISR)) {
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if (iwl_debug_level & (IWL_DL_ISR)) {
 		inta = iwl4965_read32(priv, CSR_INT);
 		inta_mask = iwl4965_read32(priv, CSR_INT_MASK);
 		inta_fh = iwl4965_read32(priv, CSR_FH_INT_STATUS);
@@ -7916,7 +7916,7 @@ static int iwl4965_mac_conf_ht(struct ieee80211_hw *hw,
  *
  *****************************************************************************/
 
-#ifdef CONFIG_IWL4965_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 
 /*
  * The following adds a new attribute to the sysfs representation
@@ -7928,7 +7928,7 @@ static int iwl4965_mac_conf_ht(struct ieee80211_hw *hw,
 
 static ssize_t show_debug_level(struct device_driver *d, char *buf)
 {
-	return sprintf(buf, "0x%08X\n", iwl4965_debug_level);
+	return sprintf(buf, "0x%08X\n", iwl_debug_level);
 }
 static ssize_t store_debug_level(struct device_driver *d,
 				 const char *buf, size_t count)
@@ -7941,7 +7941,7 @@ static ssize_t store_debug_level(struct device_driver *d,
 		printk(KERN_INFO DRV_NAME
 		       ": %s is not in hex or decimal form.\n", buf);
 	else
-		iwl4965_debug_level = val;
+		iwl_debug_level = val;
 
 	return strnlen(buf, count);
 }
@@ -7949,7 +7949,7 @@ static ssize_t store_debug_level(struct device_driver *d,
 static DRIVER_ATTR(debug_level, S_IWUSR | S_IRUGO,
 		   show_debug_level, store_debug_level);
 
-#endif /* CONFIG_IWL4965_DEBUG */
+#endif /* CONFIG_IWLWIFI_DEBUG */
 
 static ssize_t show_rf_kill(struct device *d,
 			    struct device_attribute *attr, char *buf)
@@ -8548,8 +8548,8 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	priv->pci_dev = pdev;
 	priv->antenna = (enum iwl4965_antenna)iwl4965_param_antenna;
-#ifdef CONFIG_IWL4965_DEBUG
-	iwl4965_debug_level = iwl4965_param_debug;
+#ifdef CONFIG_IWLWIFI_DEBUG
+	iwl_debug_level = iwl4965_param_debug;
 	atomic_set(&priv->restrict_refcnt, 0);
 #endif
 	priv->retry_rate = 1;
@@ -8878,7 +8878,7 @@ static int __init iwl4965_init(void)
 		IWL_ERROR("Unable to initialize PCI module\n");
 		return ret;
 	}
-#ifdef CONFIG_IWL4965_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 	ret = driver_create_file(&iwl4965_driver.driver, &driver_attr_debug_level);
 	if (ret) {
 		IWL_ERROR("Unable to create driver sysfs file\n");
@@ -8892,7 +8892,7 @@ static int __init iwl4965_init(void)
 
 static void __exit iwl4965_exit(void)
 {
-#ifdef CONFIG_IWL4965_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUG
 	driver_remove_file(&iwl4965_driver.driver, &driver_attr_debug_level);
 #endif
 	pci_unregister_driver(&iwl4965_driver);
-- 
1.5.3.4

