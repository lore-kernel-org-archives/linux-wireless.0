Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f47.google.com ([209.85.210.47]:50520 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757385Ab3BHWzn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 17:55:43 -0500
Received: by mail-da0-f47.google.com with SMTP id s35so2017958dak.34
        for <linux-wireless@vger.kernel.org>; Fri, 08 Feb 2013 14:55:43 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH] mac80211: fix CONFIG_MAC80211=n build breakage
Date: Fri,  8 Feb 2013 14:54:37 -0800
Message-Id: <1360364077-12204-1-git-send-email-thomas@cozybit.com> (sfid-20130208_235547_287234_C8B73589)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The original mesh_sta_cleanup() declaration should have been 
inside the ifdef.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index e5f6095..cd7868a 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -294,7 +294,6 @@ void mesh_plink_block(struct sta_info *sta);
 void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 			 struct ieee80211_mgmt *mgmt, size_t len,
 			 struct ieee80211_rx_status *rx_status);
-void mesh_sta_cleanup(struct sta_info *sta);
 
 /* Private interfaces */
 /* Mesh tables */
@@ -367,6 +366,7 @@ void mesh_plink_quiesce(struct sta_info *sta);
 void mesh_plink_restart(struct sta_info *sta);
 void mesh_path_flush_by_iface(struct ieee80211_sub_if_data *sdata);
 void mesh_sync_adjust_tbtt(struct ieee80211_sub_if_data *sdata);
+void mesh_sta_cleanup(struct sta_info *sta);
 #else
 #define mesh_allocated	0
 static inline void
-- 
1.7.10.4

