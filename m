Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53654 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934066AbZHHMiX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2009 08:38:23 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/7] [compat-2.6] Rename the rest of CONFIG_MAC80211_MESH to CONFIG_COMPAT_MAC80211_MESH
Date: Sat,  8 Aug 2009 14:38:10 +0200
Message-Id: <1249735096-27071-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Without this, some symbols can not be resolved because only parts of mesh were disabled.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/patches/08-disable-mesh.patch |   85 ++++++++++++++++++++++++++++++++++
 1 files changed, 85 insertions(+), 0 deletions(-)

diff --git a/compat/patches/08-disable-mesh.patch b/compat/patches/08-disable-mesh.patch
index b11be2b..4dee94b 100644
--- a/compat/patches/08-disable-mesh.patch
+++ b/compat/patches/08-disable-mesh.patch
@@ -16,6 +16,17 @@ if your kernel *does* enable it we want to disable
 it for you. We do this by relabelling the mesh
 kconfig option.
 
+--- a/include/net/mac80211.h
++++ b/include/net/mac80211.h
+@@ -679,7 +679,7 @@ struct ieee80211_vif {
+ 
+ static inline bool ieee80211_vif_is_mesh(struct ieee80211_vif *vif)
+ {
+-#ifdef CONFIG_MAC80211_MESH
++#ifdef CONFIG_COMPAT_MAC80211_MESH
+ 	return vif->type == NL80211_IFTYPE_MESH_POINT;
+ #endif
+ 	return false;
 --- a/net/mac80211/Makefile	2009-08-04 15:46:36.454027243 -0700
 +++ b/net/mac80211/Makefile	2009-08-04 15:50:01.627056156 -0700
 @@ -32,7 +32,7 @@
@@ -112,6 +123,80 @@ kconfig option.
  		del_mesh_stats(sdata);
  		del_mesh_config(sdata);
  #endif
+--- a/net/mac80211/ieee80211_i.h
++++ b/net/mac80211/ieee80211_i.h
+@@ -83,7 +83,7 @@ struct ieee80211_bss {
+ 
+ 	unsigned long last_probe_resp;
+ 
+-#ifdef CONFIG_MAC80211_MESH
++#ifdef CONFIG_COMPAT_MAC80211_MESH
+ 	u8 *mesh_id;
+ 	size_t mesh_id_len;
+ 	u8 *mesh_cfg;
+@@ -105,7 +105,7 @@ struct ieee80211_bss {
+ 
+ static inline u8 *bss_mesh_cfg(struct ieee80211_bss *bss)
+ {
+-#ifdef CONFIG_MAC80211_MESH
++#ifdef CONFIG_COMPAT_MAC80211_MESH
+ 	return bss->mesh_cfg;
+ #endif
+ 	return NULL;
+@@ -113,7 +113,7 @@ static inline u8 *bss_mesh_cfg(struct ieee80211_bss *bss)
+ 
+ static inline u8 *bss_mesh_id(struct ieee80211_bss *bss)
+ {
+-#ifdef CONFIG_MAC80211_MESH
++#ifdef CONFIG_COMPAT_MAC80211_MESH
+ 	return bss->mesh_id;
+ #endif
+ 	return NULL;
+@@ -121,7 +121,7 @@ static inline u8 *bss_mesh_id(struct ieee80211_bss *bss)
+ 
+ static inline u8 bss_mesh_id_len(struct ieee80211_bss *bss)
+ {
+-#ifdef CONFIG_MAC80211_MESH
++#ifdef CONFIG_COMPAT_MAC80211_MESH
+ 	return bss->mesh_id_len;
+ #endif
+ 	return 0;
+@@ -384,7 +384,7 @@ struct ieee80211_if_mesh {
+ 	bool accepting_plinks;
+ };
+ 
+-#ifdef CONFIG_MAC80211_MESH
++#ifdef CONFIG_COMPAT_MAC80211_MESH
+ #define IEEE80211_IFSTA_MESH_CTR_INC(msh, name)	\
+ 	do { (msh)->mshstats.name++; } while (0)
+ #else
+@@ -458,7 +458,7 @@ struct ieee80211_sub_if_data {
+ 		struct ieee80211_if_vlan vlan;
+ 		struct ieee80211_if_managed mgd;
+ 		struct ieee80211_if_ibss ibss;
+-#ifdef CONFIG_MAC80211_MESH
++#ifdef CONFIG_COMPAT_MAC80211_MESH
+ 		struct ieee80211_if_mesh mesh;
+ #endif
+ 		u32 mntr_flags;
+@@ -503,7 +503,7 @@ struct ieee80211_sub_if_data {
+ 		struct dentry *default_mgmt_key;
+ 	} common_debugfs;
+ 
+-#ifdef CONFIG_MAC80211_MESH
++#ifdef CONFIG_COMPAT_MAC80211_MESH
+ 	struct dentry *mesh_stats_dir;
+ 	struct {
+ 		struct dentry *fwded_frames;
+@@ -546,7 +546,7 @@ static inline void
+ ieee80211_sdata_set_mesh_id(struct ieee80211_sub_if_data *sdata,
+ 			    u8 mesh_id_len, u8 *mesh_id)
+ {
+-#ifdef CONFIG_MAC80211_MESH
++#ifdef CONFIG_COMPAT_MAC80211_MESH
+ 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+ 	ifmsh->mesh_id_len = mesh_id_len;
+ 	memcpy(ifmsh->mesh_id, mesh_id, mesh_id_len);
 --- a/net/mac80211/mesh.h	2009-08-07 12:13:38.500500259 -0700
 +++ b/net/mac80211/mesh.h	2009-08-07 12:13:39.504493864 -0700
 @@ -267,7 +267,7 @@ void mesh_path_restart(struct ieee80211_
-- 
1.6.2.1

