Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88A75326CF
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 10:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790072339; cv=none; b=f5Mx5UGK1A7D1Fa8NGUOCE8rZ46ZT/+fzOmnbRUD/q6Te7zhVHjMXVRk2jowIFM912x7ZiF/J+vogdRK76DwG9dDf9kuKSriqch0ygxF8CYHu/yo++SBrOHJf+rdivYqE7Yj+wKenaOq/PS6q5BAK0KCjE15zQpAnOg61Au5bWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790072339; c=relaxed/simple;
	bh=m85LyU8L20msmZwqtLKtE9JkjyqtkLc+u3e2NhH0PDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tiDzDAI4TvwPSnk3AtEthNpn3C+mvsGoKQclMhYHZOaSrR12gvj1/gBRcsnh1TUaS6i2rYp2kCt4gHYe36kaBwGnFO+lLUwYsGgaHT/9GdY0P6q8JGPBOk3/zHNZ6Gl1eLidi+3M80YztJ6Ot/PggEJTJyKJ5iOtjp4In7xT+6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=RgUbWBFd; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="RgUbWBFd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/feYUnSyCqoXhTX9MShNFancfnIScbfet9KR7wlorEk=; b=RgUbWBFdYyX80wFuEYdRjj3n5b
	RSSdWALlC4JeA3cntyiuPTj/f5eqWdjCvHnDTIuKzW0Uda0P4j5NFpNQLSRvFHK3rL4Tve/bW7Idm
	uOjcrZ5awAZpJkHlpIt4z/0EqyBZNRrcVDWfqG+dZ+/soHehTdcpNOYLyxlCs81sg9FY=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1x8xaN-0080aD-2t;
	Tue, 22 Sep 2026 12:18:52 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: vivek.chettri@oss.qualcomm.com,
	bhagavathi.pillai@oss.qualcomm.com,
	ripan.deuri@oss.qualcomm.com
Subject: [RFC PATCH 4/5] net: ethernet: mtk_eth_soc: query the wireless driver for the flow TID
Date: Tue, 22 Sep 2026 12:18:47 +0200
Message-ID: <206d39ab34918d83c84305aa498bd9f34d30ee86.1790072192.git-series.nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.cadd8c50b95a5843991b4ea42462910882ab0982.1790072192.git-series.nbd@nbd.name>
References: <cover.cadd8c50b95a5843991b4ea42462910882ab0982.1790072192.git-series.nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Packets that the PPE forwards to a WLAN station bypass the wireless
stack, so the SCS and MSCS rules of the station are not applied to
them. Query the wireless driver for the user priority of a flow before
the entry is bound, and store the result in the TID field of the WINFO
data. Only netsys v3 has this field.

The query happens in __mtk_ppe_check_skb(), because that is the only
place where the flow of an entry is known for both rule based entries
and the learned subflows of a bridge entry. The flow description is
built from the FOE entry and only includes the fields that the entry
matches on, since one answer has to be valid for every packet that hits
the entry. This leaves out the DSCP, which varies per packet, and the
ports of 3-tuple entries. If the driver cannot answer with the fields
provided, the entry stays unbound.

Add a flush callback for the wireless driver to use when the rules of
a station change. It unbinds every entry of that station, so that the
next packet binds it again with a fresh query. A bridge entry has no
hardware entry of its own, so its subflows are removed instead and
learned again. Implement the mac80211 flush op in mt7996 on top of it.
The forward path fills entries with the station index of the default
link, so the same index is flushed.

The query runs in the receive path, where hw_lock cannot be taken.
Publish the WED device for it through a separate RCU protected pointer,
which is cleared and synchronised before the device is detached.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.h      |   1 +-
 drivers/net/ethernet/mediatek/mtk_ppe.c          | 198 +++++++++++++---
 drivers/net/ethernet/mediatek/mtk_ppe.h          |   4 +-
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c  |  34 ++-
 drivers/net/ethernet/mediatek/mtk_wed.c          |  33 +++-
 drivers/net/ethernet/mediatek/mtk_wed.h          |   9 +-
 drivers/net/wireless/mediatek/mt76/mt7996/main.c |  39 ++-
 include/linux/soc/mediatek/mtk_wed.h             |   8 +-
 8 files changed, 292 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 88a9b3b23bea..a41c3f939538 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -1512,6 +1512,7 @@ int mtk_gmac_rgmii_path_setup(struct mtk_eth *eth, int mac_id);
 int mtk_eth_offload_init(struct mtk_eth *eth, u8 id);
 int mtk_eth_setup_tc(struct net_device *dev, enum tc_setup_type type,
 		     void *type_data);
+void mtk_flow_offload_unbind_wcid(struct mtk_eth *eth, int wed_index, u16 wcid);
 int mtk_flow_offload_cmd(struct mtk_eth *eth, struct flow_cls_offload *cls,
 			 int ppe_index);
 void mtk_flow_offload_cleanup(struct mtk_eth *eth, struct list_head *list);
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index 8451dc3fd00a..eab88ad067a0 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -9,11 +9,13 @@
 #include <linux/if_ether.h>
 #include <linux/if_vlan.h>
 
+#include <net/cfg80211.h>
 #include <net/dst_metadata.h>
 #include <net/dsa.h>
 #include <net/ipv6.h>
 
 #include "mtk_eth_soc.h"
+#include "mtk_wed.h"
 #include "mtk_ppe.h"
 #include "mtk_ppe_regs.h"
 
@@ -461,6 +463,116 @@ int mtk_foe_entry_set_wdma(struct mtk_eth *eth, struct mtk_foe_entry *entry,
 	return 0;
 }
 
+/*
+ * Only report the fields that the entry matches on, since the answer has to
+ * hold for every packet that hits it. This excludes the DSCP and the ports of
+ * 3-tuple entries.
+ */
+static void
+mtk_foe_entry_get_flow(struct mtk_eth *eth, struct mtk_foe_entry *entry,
+		       struct cfg80211_flow_info *info)
+{
+	int type = mtk_get_ib1_pkt_type(eth, entry->ib1);
+	struct mtk_foe_mac_info *l2;
+	struct mtk_ipv4_tuple *t;
+	int i;
+
+	memset(info, 0, sizeof(*info));
+	info->key.proto = entry->ib1 & MTK_FOE_IB1_UDP ? IPPROTO_UDP
+						       : IPPROTO_TCP;
+
+	l2 = mtk_foe_entry_l2(eth, entry);
+	put_unaligned_be32(l2->dest_mac_hi, info->key.da);
+	put_unaligned_be16(l2->dest_mac_lo, info->key.da + 4);
+	put_unaligned_be32(l2->src_mac_hi, info->key.sa);
+	put_unaligned_be16(l2->src_mac_lo, info->key.sa + 4);
+	info->key.eth_type = htons(l2->etype);
+	info->present = BIT(CFG80211_FLOW_F_ETH_DA) |
+			BIT(CFG80211_FLOW_F_ETH_SA) |
+			BIT(CFG80211_FLOW_F_ETH_TYPE);
+
+	switch (type) {
+	case MTK_PPE_PKT_TYPE_IPV4_HNAPT:
+	case MTK_PPE_PKT_TYPE_IPV4_ROUTE:
+		t = type == MTK_PPE_PKT_TYPE_IPV4_HNAPT ? &entry->ipv4.new
+							: &entry->ipv4.orig;
+		info->key.ip_version = 4;
+		info->key.src.s6_addr32[0] = cpu_to_be32(t->src_ip);
+		info->key.dst.s6_addr32[0] = cpu_to_be32(t->dest_ip);
+
+		if (type == MTK_PPE_PKT_TYPE_IPV4_ROUTE) {
+			info->key.proto = t->protocol;
+			break;
+		}
+
+		info->key.src_port = cpu_to_be16(t->src_port);
+		info->key.dst_port = cpu_to_be16(t->dest_port);
+		info->present |= BIT(CFG80211_FLOW_F_SRC_PORT) |
+				 BIT(CFG80211_FLOW_F_DST_PORT);
+		break;
+	case MTK_PPE_PKT_TYPE_IPV6_ROUTE_3T:
+	case MTK_PPE_PKT_TYPE_IPV6_ROUTE_5T:
+		info->key.ip_version = 6;
+		for (i = 0; i < 4; i++) {
+			info->key.src.s6_addr32[i] =
+				cpu_to_be32(entry->ipv6.src_ip[i]);
+			info->key.dst.s6_addr32[i] =
+				cpu_to_be32(entry->ipv6.dest_ip[i]);
+		}
+
+		if (type == MTK_PPE_PKT_TYPE_IPV6_ROUTE_3T) {
+			info->key.proto = entry->ipv6.protocol;
+			break;
+		}
+
+		info->key.src_port = cpu_to_be16(entry->ipv6.src_port);
+		info->key.dst_port = cpu_to_be16(entry->ipv6.dest_port);
+		info->present |= BIT(CFG80211_FLOW_F_SRC_PORT) |
+				 BIT(CFG80211_FLOW_F_DST_PORT);
+		break;
+	default:
+		info->key.proto = 0;
+		return;
+	}
+
+	info->present |= BIT(CFG80211_FLOW_F_IP_VERSION) |
+			 BIT(CFG80211_FLOW_F_IP_SRC) |
+			 BIT(CFG80211_FLOW_F_IP_DST) |
+			 BIT(CFG80211_FLOW_F_PROTO);
+}
+
+static void
+mtk_foe_entry_set_tid(struct mtk_eth *eth, struct mtk_foe_entry *entry, u8 tid)
+{
+	struct mtk_foe_mac_info *l2;
+
+	if (!mtk_is_netsys_v3_or_greater(eth))
+		return;
+
+	l2 = mtk_foe_entry_l2(eth, entry);
+	l2->amsdu &= ~MTK_FOE_WINFO_AMSDU_TID;
+	l2->amsdu |= FIELD_PREP(MTK_FOE_WINFO_AMSDU_TID, tid);
+}
+
+static bool
+mtk_foe_entry_set_prio(struct mtk_ppe *ppe, struct mtk_flow_entry *base,
+		       struct mtk_foe_entry *foe)
+{
+	struct cfg80211_flow_info info;
+	u8 tid = 0;
+
+	if (base->wed_index < 0)
+		return true;
+
+	mtk_foe_entry_get_flow(ppe->eth, foe, &info);
+	if (mtk_wed_flow_prio(base->wed_index, base->wcid, &info, &tid))
+		return false;
+
+	mtk_foe_entry_set_tid(ppe->eth, foe, tid);
+
+	return true;
+}
+
 int mtk_foe_entry_set_queue(struct mtk_eth *eth, struct mtk_foe_entry *entry,
 			    unsigned int queue)
 {
@@ -498,22 +610,8 @@ mtk_flow_entry_match(struct mtk_eth *eth, struct mtk_flow_entry *entry,
 }
 
 static void
-__mtk_foe_entry_clear(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
+__mtk_foe_entry_unbind(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
 {
-	struct hlist_head *head;
-	struct hlist_node *tmp;
-
-	if (entry->type == MTK_FLOW_TYPE_L2) {
-		rhashtable_remove_fast(&ppe->l2_flows, &entry->l2_node,
-				       mtk_flow_l2_ht_params);
-
-		head = &entry->l2_flows;
-		hlist_for_each_entry_safe(entry, tmp, head, l2_data.list)
-			__mtk_foe_entry_clear(ppe, entry);
-		return;
-	}
-
-	hlist_del_init(&entry->list);
 	if (entry->hash != 0xffff) {
 		struct mtk_foe_entry *hwe = mtk_foe_get_entry(ppe, entry->hash);
 
@@ -531,6 +629,26 @@ __mtk_foe_entry_clear(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
 		}
 	}
 	entry->hash = 0xffff;
+}
+
+static void
+__mtk_foe_entry_clear(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
+{
+	struct hlist_head *head;
+	struct hlist_node *tmp;
+
+	if (entry->type == MTK_FLOW_TYPE_L2) {
+		rhashtable_remove_fast(&ppe->l2_flows, &entry->l2_node,
+				       mtk_flow_l2_ht_params);
+
+		head = &entry->l2_flows;
+		hlist_for_each_entry_safe(entry, tmp, head, l2_data.list)
+			__mtk_foe_entry_clear(ppe, entry);
+		return;
+	}
+
+	hlist_del_init(&entry->list);
+	__mtk_foe_entry_unbind(ppe, entry);
 
 	if (entry->type != MTK_FLOW_TYPE_L2_SUBFLOW)
 		return;
@@ -539,6 +657,24 @@ __mtk_foe_entry_clear(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
 	kfree(entry);
 }
 
+/* A bridge entry has no hardware entry, so drop its subflows instead */
+void mtk_foe_entry_unbind(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
+{
+	struct mtk_flow_entry *cur;
+	struct hlist_node *tmp;
+
+	spin_lock_bh(&ppe_lock);
+
+	if (entry->type == MTK_FLOW_TYPE_L2)
+		hlist_for_each_entry_safe(cur, tmp, &entry->l2_flows,
+					  l2_data.list)
+			__mtk_foe_entry_clear(ppe, cur);
+	else
+		__mtk_foe_entry_unbind(ppe, entry);
+
+	spin_unlock_bh(&ppe_lock);
+}
+
 static int __mtk_foe_entry_idle_time(struct mtk_ppe *ppe, u32 ib1)
 {
 	u32 ib1_ts_mask = mtk_get_ib1_ts_mask(ppe->eth);
@@ -705,17 +841,6 @@ mtk_foe_entry_commit_subflow(struct mtk_ppe *ppe, struct mtk_flow_entry *entry,
 	u32 ib1_mask = mtk_get_ib1_pkt_type_mask(ppe->eth) | MTK_FOE_IB1_UDP;
 	int type;
 
-	flow_info = kzalloc_obj(*flow_info, GFP_ATOMIC);
-	if (!flow_info)
-		return;
-
-	flow_info->l2_data.base_flow = entry;
-	flow_info->type = MTK_FLOW_TYPE_L2_SUBFLOW;
-	flow_info->hash = hash;
-	hlist_add_head(&flow_info->list,
-		       &ppe->foe_flow[hash / soc->hash_offset]);
-	hlist_add_head(&flow_info->l2_data.list, &entry->l2_flows);
-
 	hwe = mtk_foe_get_entry(ppe, hash);
 	memcpy(&foe, hwe, soc->foe_entry_size);
 	foe.ib1 &= ib1_mask;
@@ -732,6 +857,20 @@ mtk_foe_entry_commit_subflow(struct mtk_ppe *ppe, struct mtk_flow_entry *entry,
 
 	*mtk_foe_entry_ib2(ppe->eth, &foe) = entry->data.bridge.ib2;
 
+	if (!mtk_foe_entry_set_prio(ppe, entry, &foe))
+		return;
+
+	flow_info = kzalloc_obj(*flow_info, GFP_ATOMIC);
+	if (!flow_info)
+		return;
+
+	flow_info->l2_data.base_flow = entry;
+	flow_info->type = MTK_FLOW_TYPE_L2_SUBFLOW;
+	flow_info->hash = hash;
+	hlist_add_head(&flow_info->list,
+		       &ppe->foe_flow[hash / soc->hash_offset]);
+	hlist_add_head(&flow_info->l2_data.list, &entry->l2_flows);
+
 	__mtk_foe_entry_commit(ppe, &foe, hash);
 }
 
@@ -769,9 +908,14 @@ void __mtk_ppe_check_skb(struct mtk_ppe *ppe, struct sk_buff *skb, u16 hash)
 			continue;
 		}
 
+		found = true;
+		if (!mtk_foe_entry_set_prio(ppe, entry, &entry->data)) {
+			entry->hash = 0xffff;
+			continue;
+		}
+
 		entry->hash = hash;
 		__mtk_foe_entry_commit(ppe, &entry->data, hash);
-		found = true;
 	}
 
 	if (found)
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.h b/drivers/net/ethernet/mediatek/mtk_ppe.h
index ba85e39a155b..c39758f8369c 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.h
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.h
@@ -8,6 +8,8 @@
 #include <linux/bitfield.h>
 #include <linux/rhashtable.h>
 
+struct cfg80211_flow_info;
+
 #define MTK_PPE_ENTRIES_SHIFT		4
 #define MTK_PPE_ENTRIES			(1024 << MTK_PPE_ENTRIES_SHIFT)
 #define MTK_PPE_HASH_MASK		(MTK_PPE_ENTRIES - 1)
@@ -296,6 +298,7 @@ struct mtk_flow_entry {
 	s8 wed_index;
 	u8 ppe_index;
 	u16 hash;
+	u16 wcid;
 	union {
 		struct mtk_foe_entry data;
 		struct {
@@ -399,6 +402,7 @@ int mtk_foe_entry_set_queue(struct mtk_eth *eth, struct mtk_foe_entry *entry,
 			    unsigned int queue);
 int mtk_foe_entry_commit(struct mtk_ppe *ppe, struct mtk_flow_entry *entry);
 void mtk_foe_entry_clear(struct mtk_ppe *ppe, struct mtk_flow_entry *entry);
+void mtk_foe_entry_unbind(struct mtk_ppe *ppe, struct mtk_flow_entry *entry);
 int mtk_foe_entry_idle_time(struct mtk_ppe *ppe, struct mtk_flow_entry *entry);
 int mtk_ppe_debugfs_init(struct mtk_ppe *ppe, int index);
 struct mtk_foe_accounting *mtk_foe_entry_get_mib(struct mtk_ppe *ppe, u32 index,
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index 99b28aaa7cc4..1f48eccc06bc 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -199,7 +199,7 @@ mtk_flow_get_dsa_port(struct net_device **dev)
 static int
 mtk_flow_set_output_device(struct mtk_eth *eth, struct mtk_foe_entry *foe,
 			   struct net_device *dev, const u8 *dest_mac,
-			   int *wed_index)
+			   int *wed_index, u16 *wcid)
 {
 	struct mtk_wdma_info info = {};
 	int pse_port, dsa_port, queue;
@@ -225,6 +225,7 @@ mtk_flow_set_output_device(struct mtk_eth *eth, struct mtk_foe_entry *foe,
 			pse_port = 3;
 		}
 		*wed_index = info.wdma_idx;
+		*wcid = info.wcid;
 		goto out;
 	}
 
@@ -285,6 +286,7 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f,
 	int offload_type = 0;
 	int wed_index = -1;
 	u16 addr_type = 0;
+	u16 wcid = 0;
 	u8 l4proto = 0;
 	int err = 0;
 	int i;
@@ -490,7 +492,7 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f,
 		mtk_foe_entry_set_pppoe(eth, &foe, data.pppoe.sid);
 
 	err = mtk_flow_set_output_device(eth, &foe, odev, data.eth.h_dest,
-					 &wed_index);
+					 &wed_index, &wcid);
 	if (err)
 		return err;
 
@@ -505,6 +507,7 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f,
 	memcpy(&entry->data, &foe, sizeof(entry->data));
 	entry->wed_index = wed_index;
 	entry->ppe_index = ppe_index;
+	entry->wcid = wcid;
 
 	err = mtk_foe_entry_commit(eth->ppe[entry->ppe_index], entry);
 	if (err < 0)
@@ -598,6 +601,33 @@ int mtk_flow_offload_cmd(struct mtk_eth *eth, struct flow_cls_offload *cls,
 	return err;
 }
 
+void mtk_flow_offload_unbind_wcid(struct mtk_eth *eth, int wed_index, u16 wcid)
+{
+	struct mtk_flow_entry *entry;
+	struct rhashtable_iter iter;
+
+	mutex_lock(&mtk_flow_offload_mutex);
+
+	rhashtable_walk_enter(&eth->flow_table, &iter);
+	rhashtable_walk_start(&iter);
+	while ((entry = rhashtable_walk_next(&iter)) != NULL) {
+		if (IS_ERR(entry)) {
+			if (PTR_ERR(entry) != -EAGAIN)
+				break;
+			continue;
+		}
+
+		if (entry->wed_index != wed_index || entry->wcid != wcid)
+			continue;
+
+		mtk_foe_entry_unbind(eth->ppe[entry->ppe_index], entry);
+	}
+	rhashtable_walk_stop(&iter);
+	rhashtable_walk_exit(&iter);
+
+	mutex_unlock(&mtk_flow_offload_mutex);
+}
+
 static int
 mtk_eth_setup_tc_block_cb(enum tc_setup_type type, void *type_data, void *cb_priv)
 {
diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index 53d3b7e00e1c..78c2e7bc2370 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -51,6 +51,9 @@
 static struct mtk_wed_hw *hw_list[3];
 static DEFINE_MUTEX(hw_lock);
 
+/* Used by the flow priority query from the receive path, without hw_lock */
+static struct mtk_wed_device __rcu *flow_prio_dev[ARRAY_SIZE(hw_list)];
+
 struct mtk_wed_flow_block_priv {
 	struct mtk_wed_hw *hw;
 	struct net_device *dev;
@@ -522,6 +525,8 @@ mtk_wed_assign(struct mtk_wed_device *dev)
 
 out:
 	hw->wed_dev = dev;
+	rcu_assign_pointer(flow_prio_dev[hw->index], dev);
+
 	return hw;
 }
 
@@ -1129,6 +1134,9 @@ __mtk_wed_detach(struct mtk_wed_device *dev)
 {
 	struct mtk_wed_hw *hw = dev->hw;
 
+	rcu_assign_pointer(flow_prio_dev[hw->index], NULL);
+	synchronize_rcu();
+
 	mtk_wed_deinit(dev);
 
 	mtk_wdma_rx_reset(dev);
@@ -1164,6 +1172,24 @@ __mtk_wed_detach(struct mtk_wed_device *dev)
 	hw->wed_dev = NULL;
 }
 
+int mtk_wed_flow_prio(int index, u16 wcid, const struct cfg80211_flow_info *info,
+		      u8 *prio)
+{
+	struct mtk_wed_device *dev;
+	int ret = 0;
+
+	if (index < 0 || index >= ARRAY_SIZE(flow_prio_dev))
+		return 0;
+
+	rcu_read_lock();
+	dev = rcu_dereference(flow_prio_dev[index]);
+	if (dev && dev->wlan.flow_prio)
+		ret = dev->wlan.flow_prio(dev, wcid, info, prio);
+	rcu_read_unlock();
+
+	return ret;
+}
+
 static void
 mtk_wed_detach(struct mtk_wed_device *dev)
 {
@@ -1975,6 +2001,12 @@ mtk_wed_ppe_check(struct mtk_wed_device *dev, struct sk_buff *skb,
 }
 
 static void
+mtk_wed_flow_flush(struct mtk_wed_device *dev, u16 wcid)
+{
+	mtk_flow_offload_unbind_wcid(dev->hw->eth, dev->hw->index, wcid);
+}
+
+static void
 mtk_wed_configure_irq(struct mtk_wed_device *dev, u32 irq_mask)
 {
 	u32 wdma_mask = FIELD_PREP(MTK_WDMA_INT_MASK_RX_DONE, GENMASK(1, 0));
@@ -2798,6 +2830,7 @@ void mtk_wed_add_hw(struct device_node *np, struct mtk_eth *eth,
 		.rro_rx_ring_setup = mtk_wed_rro_rx_ring_setup,
 		.msdu_pg_rx_ring_setup = mtk_wed_msdu_pg_rx_ring_setup,
 		.ind_rx_ring_setup = mtk_wed_ind_rx_ring_setup,
+		.flow_flush = mtk_wed_flow_flush,
 	};
 	struct device_node *eth_np = eth->dev->of_node;
 	struct platform_device *pdev;
diff --git a/drivers/net/ethernet/mediatek/mtk_wed.h b/drivers/net/ethernet/mediatek/mtk_wed.h
index b49aee9a8b65..1ed21ea6d17f 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.h
+++ b/drivers/net/ethernet/mediatek/mtk_wed.h
@@ -185,6 +185,8 @@ void mtk_wed_add_hw(struct device_node *np, struct mtk_eth *eth,
 void mtk_wed_exit(void);
 int mtk_wed_flow_add(int index);
 void mtk_wed_flow_remove(int index);
+int mtk_wed_flow_prio(int index, u16 wcid, const struct cfg80211_flow_info *info,
+		      u8 *prio);
 void mtk_wed_fe_reset(void);
 void mtk_wed_fe_reset_complete(void);
 #else
@@ -206,6 +208,13 @@ static inline void mtk_wed_flow_remove(int index)
 {
 }
 
+static inline int mtk_wed_flow_prio(int index, u16 wcid,
+				    const struct cfg80211_flow_info *info,
+				    u8 *prio)
+{
+	return 0;
+}
+
 static inline void mtk_wed_fe_reset(void)
 {
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 6b2d24fe70f1..b245386702b2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -2457,6 +2457,37 @@ mt7996_set_radar_background(struct ieee80211_hw *hw,
 	return ret;
 }
 
+static struct mtk_wed_device *
+mt7996_sta_wed(struct mt7996_dev *dev, struct mt7996_sta_link *msta_link)
+{
+	if (dev->hif2 &&
+	    ((is_mt7996(&dev->mt76) && msta_link->wcid.phy_idx == MT_BAND2) ||
+	     (is_mt7992(&dev->mt76) && msta_link->wcid.phy_idx == MT_BAND1)))
+		return &dev->mt76.mmio.wed_hif2;
+
+	return &dev->mt76.mmio.wed;
+}
+
+static void
+mt7996_flow_offload_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			  struct ieee80211_sta *sta)
+{
+	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
+	struct mt7996_dev *dev = mt7996_hw_dev(hw);
+	struct mt7996_sta_link *msta_link;
+	struct mtk_wed_device *wed;
+
+	msta_link = mt7996_sta_link_protected(dev, msta, msta->deflink_id);
+	if (!msta_link)
+		return;
+
+	wed = mt7996_sta_wed(dev, msta_link);
+	if (!mtk_wed_device_active(wed))
+		return;
+
+	mtk_wed_device_flow_flush(wed, msta_link->wcid.idx);
+}
+
 static int
 mt7996_net_fill_forward_path(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif,
@@ -2466,9 +2497,9 @@ mt7996_net_fill_forward_path(struct ieee80211_hw *hw,
 {
 	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
 	struct mt7996_dev *dev = mt7996_hw_dev(hw);
-	struct mtk_wed_device *wed = &dev->mt76.mmio.wed;
 	struct mt7996_sta_link *msta_link;
 	struct mt7996_vif_link *link;
+	struct mtk_wed_device *wed;
 
 	link = mt7996_vif_link(dev, vif, msta->deflink_id);
 	if (!link)
@@ -2481,10 +2512,7 @@ mt7996_net_fill_forward_path(struct ieee80211_hw *hw,
 	if (!msta_link->wcid.sta || msta_link->wcid.idx > MT7996_WTBL_STA)
 		return -EIO;
 
-	if (dev->hif2 &&
-	    ((is_mt7996(&dev->mt76) && msta_link->wcid.phy_idx == MT_BAND2) ||
-	     (is_mt7992(&dev->mt76) && msta_link->wcid.phy_idx == MT_BAND1)))
-		wed = &dev->mt76.mmio.wed_hif2;
+	wed = mt7996_sta_wed(dev, msta_link);
 
 	if (!mtk_wed_device_active(wed) &&
 	    !mt76_npu_device_active(&dev->mt76))
@@ -2661,6 +2689,7 @@ const struct ieee80211_ops mt7996_ops = {
 #endif
 	.set_radar_background = mt7996_set_radar_background,
 	.net_fill_forward_path = mt7996_net_fill_forward_path,
+	.flow_offload_flush = mt7996_flow_offload_flush,
 #if defined(CONFIG_NET_MEDIATEK_SOC_WED) || defined(CONFIG_MT7996_NPU)
 	.net_setup_tc = mt7996_net_setup_tc,
 #endif
diff --git a/include/linux/soc/mediatek/mtk_wed.h b/include/linux/soc/mediatek/mtk_wed.h
index 3fa93bd65004..d9089cc545c0 100644
--- a/include/linux/soc/mediatek/mtk_wed.h
+++ b/include/linux/soc/mediatek/mtk_wed.h
@@ -16,6 +16,7 @@
 
 struct mtk_wed_hw;
 struct mtk_wdma_desc;
+struct cfg80211_flow_info;
 
 enum mtk_wed_wo_cmd {
 	MTK_WED_WO_CMD_WED_CFG,
@@ -188,6 +189,9 @@ struct mtk_wed_device {
 					   struct mtk_wed_wo_rx_stats *stats);
 		int (*reset)(struct mtk_wed_device *wed);
 		void (*reset_complete)(struct mtk_wed_device *wed);
+		int (*flow_prio)(struct mtk_wed_device *wed, u16 wcid,
+				 const struct cfg80211_flow_info *info,
+				 u8 *prio);
 	} wlan;
 #endif
 };
@@ -225,6 +229,7 @@ struct mtk_wed_ops {
 				      void __iomem *regs);
 	int (*ind_rx_ring_setup)(struct mtk_wed_device *dev,
 				 void __iomem *regs);
+	void (*flow_flush)(struct mtk_wed_device *dev, u16 wcid);
 };
 
 extern const struct mtk_wed_ops __rcu *mtk_soc_wed_ops;
@@ -304,6 +309,8 @@ static inline bool mtk_wed_is_amsdu_supported(struct mtk_wed_device *dev)
 	(_dev)->ops->msdu_pg_rx_ring_setup(_dev, _ring, _regs)
 #define mtk_wed_device_ind_rx_ring_setup(_dev, _regs) \
 	(_dev)->ops->ind_rx_ring_setup(_dev, _regs)
+#define mtk_wed_device_flow_flush(_dev, _wcid) \
+	(_dev)->ops->flow_flush(_dev, _wcid)
 
 #else
 static inline bool mtk_wed_device_active(struct mtk_wed_device *dev)
@@ -328,6 +335,7 @@ static inline bool mtk_wed_device_active(struct mtk_wed_device *dev)
 #define mtk_wed_device_rro_rx_ring_setup(_dev, _ring, _regs) -ENODEV
 #define mtk_wed_device_msdu_pg_rx_ring_setup(_dev, _ring, _regs) -ENODEV
 #define mtk_wed_device_ind_rx_ring_setup(_dev, _regs) -ENODEV
+#define mtk_wed_device_flow_flush(_dev, _wcid) do {} while (0)
 #endif
 
 #endif
-- 
git-series 0.9.1
