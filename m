Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:49805 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbYLEP5p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2008 10:57:45 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, "Zhu, Yi" <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 6/6] iwlwifi: use rmb/wmb to protect indirect mmio operation
Date: Fri,  5 Dec 2008 07:58:41 -0800
Message-Id: <1228492721-27381-7-git-send-email-reinette.chatre@intel.com> (sfid-20081205_165754_769888_2D3A41CE)
In-Reply-To: <1228492721-27381-6-git-send-email-reinette.chatre@intel.com>
References: <>
 <1228492721-27381-1-git-send-email-reinette.chatre@intel.com>
 <1228492721-27381-2-git-send-email-reinette.chatre@intel.com>
 <1228492721-27381-3-git-send-email-reinette.chatre@intel.com>
 <1228492721-27381-4-git-send-email-reinette.chatre@intel.com>
 <1228492721-27381-5-git-send-email-reinette.chatre@intel.com>
 <1228492721-27381-6-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu, Yi <yi.zhu@intel.com>

This patch protects iwlwifi indirect mmio operations with rmb() and
wmb(). It makes sure CPU reordering won't affect our indirect mmio
access.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-io.h |    5 +++++
 drivers/net/wireless/iwlwifi/iwl-io.h      |    5 +++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-io.h b/drivers/net/wireless/iwlwifi/iwl-3945-io.h
index 994f8ba..d381b82 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-io.h
@@ -298,6 +298,7 @@ static inline int __iwl3945_poll_direct_bit(const char *f, u32 l,
 static inline u32 _iwl3945_read_prph(struct iwl3945_priv *priv, u32 reg)
 {
 	_iwl3945_write_direct32(priv, HBUS_TARG_PRPH_RADDR, reg | (3 << 24));
+	rmb();
 	return _iwl3945_read_direct32(priv, HBUS_TARG_PRPH_RDAT);
 }
 #ifdef CONFIG_IWL3945_DEBUG
@@ -319,6 +320,7 @@ static inline void _iwl3945_write_prph(struct iwl3945_priv *priv,
 {
 	_iwl3945_write_direct32(priv, HBUS_TARG_PRPH_WADDR,
 			      ((addr & 0x0000FFFF) | (3 << 24)));
+	wmb();
 	_iwl3945_write_direct32(priv, HBUS_TARG_PRPH_WDAT, val);
 }
 #ifdef CONFIG_IWL3945_DEBUG
@@ -380,12 +382,14 @@ static inline void iwl3945_clear_bits_prph(struct iwl3945_priv
 static inline u32 iwl3945_read_targ_mem(struct iwl3945_priv *priv, u32 addr)
 {
 	iwl3945_write_direct32(priv, HBUS_TARG_MEM_RADDR, addr);
+	rmb();
 	return iwl3945_read_direct32(priv, HBUS_TARG_MEM_RDAT);
 }
 
 static inline void iwl3945_write_targ_mem(struct iwl3945_priv *priv, u32 addr, u32 val)
 {
 	iwl3945_write_direct32(priv, HBUS_TARG_MEM_WADDR, addr);
+	wmb();
 	iwl3945_write_direct32(priv, HBUS_TARG_MEM_WDAT, val);
 }
 
@@ -393,6 +397,7 @@ static inline void iwl3945_write_targ_mem_buf(struct iwl3945_priv *priv, u32 add
 					  u32 len, u32 *values)
 {
 	iwl3945_write_direct32(priv, HBUS_TARG_MEM_WADDR, addr);
+	wmb();
 	for (; 0 < len; len -= sizeof(u32), values++)
 		iwl3945_write_direct32(priv, HBUS_TARG_MEM_WDAT, *values);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index c56dc21..10ca032 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -299,6 +299,7 @@ static inline int __iwl_poll_direct_bit(const char *f, u32 l,
 static inline u32 _iwl_read_prph(struct iwl_priv *priv, u32 reg)
 {
 	_iwl_write_direct32(priv, HBUS_TARG_PRPH_RADDR, reg | (3 << 24));
+	rmb();
 	return _iwl_read_direct32(priv, HBUS_TARG_PRPH_RDAT);
 }
 #ifdef CONFIG_IWLWIFI_DEBUG
@@ -321,6 +322,7 @@ static inline void _iwl_write_prph(struct iwl_priv *priv,
 {
 	_iwl_write_direct32(priv, HBUS_TARG_PRPH_WADDR,
 			      ((addr & 0x0000FFFF) | (3 << 24)));
+	wmb();
 	_iwl_write_direct32(priv, HBUS_TARG_PRPH_WDAT, val);
 }
 #ifdef CONFIG_IWLWIFI_DEBUG
@@ -383,12 +385,14 @@ static inline void iwl_clear_bits_prph(struct iwl_priv
 static inline u32 iwl_read_targ_mem(struct iwl_priv *priv, u32 addr)
 {
 	iwl_write_direct32(priv, HBUS_TARG_MEM_RADDR, addr);
+	rmb();
 	return iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
 }
 
 static inline void iwl_write_targ_mem(struct iwl_priv *priv, u32 addr, u32 val)
 {
 	iwl_write_direct32(priv, HBUS_TARG_MEM_WADDR, addr);
+	wmb();
 	iwl_write_direct32(priv, HBUS_TARG_MEM_WDAT, val);
 }
 
@@ -396,6 +400,7 @@ static inline void iwl_write_targ_mem_buf(struct iwl_priv *priv, u32 addr,
 					  u32 len, u32 *values)
 {
 	iwl_write_direct32(priv, HBUS_TARG_MEM_WADDR, addr);
+	wmb();
 	for (; 0 < len; len -= sizeof(u32), values++)
 		iwl_write_direct32(priv, HBUS_TARG_MEM_WDAT, *values);
 }
-- 
1.5.4.3

