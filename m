Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:63642 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756827Ab3ECCgN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 22:36:13 -0400
Received: by mail-pb0-f49.google.com with SMTP id rp8so662459pbb.36
        for <linux-wireless@vger.kernel.org>; Thu, 02 May 2013 19:36:13 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>, me@bobcopeland.com,
	open80211s <devel@lists.open80211s.org>
Subject: [RFC 02/12] mac80211: mesh: add function to tx on all other mbss ifaces
Date: Thu,  2 May 2013 19:33:52 -0700
Message-Id: <1367548442-8229-3-git-send-email-thomas@cozybit.com> (sfid-20130503_043617_662186_74996776)
In-Reply-To: <1367548442-8229-1-git-send-email-thomas@cozybit.com>
References: <1367548442-8229-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bob Copeland <me@bobcopeland.com>

Add a function to rebroadcast mcast/bcast frames on other
interfaces when multiple interfaces are shared in an mbss.

Signed-off-by: Bob Copeland <bob@cozybit.com>
---
 net/mac80211/mesh.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/mesh.h |    4 ++++
 2 files changed, 47 insertions(+)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 5ea4812..eac9988 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -11,6 +11,7 @@
 #include <linux/slab.h>
 #include <asm/unaligned.h>
 #include "ieee80211_i.h"
+#include "wme.h"
 #include "mesh.h"
 
 static int mesh_allocated;
@@ -202,6 +203,48 @@ bool mesh_bss_matches_addr(struct mesh_local_bss *mbss, const u8 *addr)
 }
 
 /**
+ * mesh_bss_forward_tx - send a frame on all other interfaces in a bss
+ *
+ * @sdata: interface to exclude from tx
+ * @skb: frame to send
+ *
+ * Forwards group-directed frames from sdata for tx on all other interfaces
+ * which are participating in an mbss.
+ */
+void mesh_bss_forward_tx(struct ieee80211_sub_if_data *sdata,
+			 struct sk_buff *skb)
+{
+	struct mesh_local_bss *mbss = mbss(sdata);
+	struct ieee80211_hdr *fwd_hdr;
+	struct sk_buff *fwd_skb;
+	struct ieee80211_tx_info *info;
+	struct ieee80211_sub_if_data *tmp_sdata;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(tmp_sdata, &mbss->if_list, u.mesh.if_list) {
+
+		if (sdata == tmp_sdata)
+			continue;
+
+		fwd_skb = skb_copy(skb, GFP_ATOMIC);
+		if (!fwd_skb)
+			goto out;
+
+		fwd_hdr =  (struct ieee80211_hdr *) fwd_skb->data;
+		info = IEEE80211_SKB_CB(fwd_skb);
+		memset(info, 0, sizeof(*info));
+		info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
+		info->control.vif = &tmp_sdata->vif;
+
+		memcpy(fwd_hdr->addr2, tmp_sdata->vif.addr, ETH_ALEN);
+		ieee80211_set_qos_hdr(tmp_sdata, fwd_skb);
+		ieee80211_add_pending_skb(tmp_sdata->local, fwd_skb);
+	}
+out:
+	rcu_read_unlock();
+}
+
+/**
  * mesh_matches_local - check if the config of a mesh point matches ours
  *
  * @sdata: local mesh subif
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index f23b58f..4a1a15e 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -361,6 +361,8 @@ void ieee80211_mesh_notify_scan_completed(struct ieee80211_local *local);
 void mesh_path_flush_by_iface(struct ieee80211_sub_if_data *sdata);
 void mesh_sync_adjust_tbtt(struct ieee80211_sub_if_data *sdata);
 void ieee80211s_stop(void);
+void mesh_bss_forward_tx(struct ieee80211_sub_if_data *sdata,
+			 struct sk_buff *skb);
 struct ieee80211_sub_if_data *
 mesh_bss_find_if(struct mesh_local_bss *mbss, const u8 *addr);
 bool mesh_bss_matches_addr(struct mesh_local_bss *mbss, const u8 *addr);
@@ -373,6 +375,8 @@ static inline bool mesh_path_sel_is_hwmp(struct ieee80211_sub_if_data *sdata)
 static inline void mesh_path_flush_by_iface(struct ieee80211_sub_if_data *sdata)
 {}
 static inline void ieee80211s_stop(void) {}
+static inline void mesh_bss_forward_tx(struct ieee80211_sub_if_data *sdata,
+				       struct sk_buff *skb) {}
 #endif
 
 #endif /* IEEE80211S_H */
-- 
1.7.10.4

