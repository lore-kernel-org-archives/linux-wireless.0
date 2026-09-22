Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D602E53160A
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 10:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790072035; cv=none; b=qhQoT1VvGsJJEUY/Py3XL5dQ2kQZZAzLdhdN+ud4scSC4a+aPMSqvIMiG/PfxR8vj9uDxv12XfKsqGrqq0qegkX9ECW5JI4D/cl4Kucy777BW/fzCvOE49ckO/jzTLQWoaRT5RGYRMY8vs57aniYlFvFzoTu2QHUrtOsvTNHFm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790072035; c=relaxed/simple;
	bh=wC3A0NyO828hllByTdTsf5azBsHYSCe65h0nOeS3jIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dhavIo9JNfgNqEnzyEAcINw76s+53AJZBslDYsKwYAFkwnsvJjFy14zF0zEo0ajx40AoeF56FhraYxqS/4/jeUtBPVmDaag5TVl/DhpA03GcW54HKjiKD9tabTm6LolVaROaJdKrG4nDn/19HX2ukZOQ/NpWvfsneEogQGi4sPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=piOnGczP; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="piOnGczP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1S6AUYdx8EvIn3iVj+CpsX3rT9FuQLiIJVarX4BA2YQ=; b=piOnGczP9dBb4y5EXZpggh7uKK
	lbZCCvykKpyzVHGrjRnuVBk5huhDh8ERL2EJZhrKZWvpKvgMDahhPEOEHIGU9TGbRfGn6cukXtlpS
	hD8bqxRepXpWPsfHQbI6qwCX5tllWuhXiRo4PiEBVR1bzx4Gk68rOBT8Erv9hntd+3LY=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1x8xVV-00807z-3C;
	Tue, 22 Sep 2026 12:13:50 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	vivek.chettri@oss.qualcomm.com,
	bhagavathi.pillai@oss.qualcomm.com,
	ripan.deuri@oss.qualcomm.com
Subject: [RFC PATCH v2 14/16] wifi: mac80211: add SCS and MSCS debugfs files
Date: Tue, 22 Sep 2026 12:13:41 +0200
Message-ID: <1dc785acb649995a0fad8297ad340862b8cda29d.1790071773.git-series.nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.5f82cb9d25f8f1b63e1994e64a6e9dac538e0ac8.1790071773.git-series.nbd@nbd.name>
References: <cover.5f82cb9d25f8f1b63e1994e64a6e9dac538e0ac8.1790071773.git-series.nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a per station scs file, which dumps every rule with its parsed
classifier, and an mscs file, which dumps the parameters and every
learned entry with its age.

Both files are seq_file iterators, so that neither has to size a
buffer for a set of up to 255 rules with 255 classifiers each. A
request replaces the rule set as a whole, so a rule is addressed by its
position and the set is looked up again at every step. The entry list
of an MSCS is not an RCU list, so that walk holds the MSCS lock from
start to stop.

Neither file takes the wiphy lock. Station removal holds it while
debugfs waits for readers to finish, so a reader that needed it would
have to go through wiphy_locked_debugfs_read(). RCU is enough here.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/debugfs_sta.c | 240 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 240 insertions(+)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index ef75255d47d5..bcf4961af24f 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -10,6 +10,7 @@
 
 #include <linux/debugfs.h>
 #include <linux/ieee80211.h>
+#include <linux/if_vlan.h>
 #include "ieee80211_i.h"
 #include "debugfs.h"
 #include "debugfs_sta.h"
@@ -131,6 +132,243 @@ static ssize_t sta_last_seq_ctrl_read(struct file *file, char __user *userbuf,
 }
 STA_OPS(last_seq_ctrl);
 
+static void sta_flow_key_show(struct seq_file *s,
+			      const struct cfg80211_flow_key *key, u32 fields)
+{
+	u16 tci = be16_to_cpu(key->vlan_tci);
+
+	if (fields & BIT(CFG80211_FLOW_F_ETH_SA))
+		seq_printf(s, " sa=%pM", key->sa);
+	if (fields & BIT(CFG80211_FLOW_F_ETH_DA))
+		seq_printf(s, " da=%pM", key->da);
+	if (fields & BIT(CFG80211_FLOW_F_ETH_TYPE))
+		seq_printf(s, " ethertype=0x%04x", be16_to_cpu(key->eth_type));
+
+	if (fields & BIT(CFG80211_FLOW_F_VLAN_PCP))
+		seq_printf(s, " pcp=%u",
+			   (tci & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT);
+	if (fields & BIT(CFG80211_FLOW_F_VLAN_DEI))
+		seq_printf(s, " dei=%u", !!(tci & VLAN_CFI_MASK));
+	if (fields & BIT(CFG80211_FLOW_F_VLAN_VID))
+		seq_printf(s, " vid=%u", tci & VLAN_VID_MASK);
+
+	if (fields & BIT(CFG80211_FLOW_F_IP_VERSION))
+		seq_printf(s, " ipv%u", key->ip_version);
+
+	if (fields & BIT(CFG80211_FLOW_F_IP_SRC))
+		seq_printf(s, key->ip_version == 6 ? " src=%pI6" : " src=%pI4",
+			   &key->src);
+	if (fields & BIT(CFG80211_FLOW_F_IP_DST))
+		seq_printf(s, key->ip_version == 6 ? " dst=%pI6" : " dst=%pI4",
+			   &key->dst);
+
+	if (fields & BIT(CFG80211_FLOW_F_SRC_PORT))
+		seq_printf(s, " sport=%u", be16_to_cpu(key->src_port));
+	if (fields & BIT(CFG80211_FLOW_F_DST_PORT))
+		seq_printf(s, " dport=%u", be16_to_cpu(key->dst_port));
+
+	if (fields & BIT(CFG80211_FLOW_F_DSCP))
+		seq_printf(s, " dscp=%u", key->dscp);
+	if (fields & BIT(CFG80211_FLOW_F_PROTO))
+		seq_printf(s, " proto=%u", key->proto);
+	if (fields & BIT(CFG80211_FLOW_F_FLOW_LABEL))
+		seq_printf(s, " flowlabel=0x%05x",
+			   be32_to_cpu(key->flow_label));
+}
+
+/* The set can be replaced during a walk, so look it up again at every step */
+static void *sta_scs_seq_start(struct seq_file *s, loff_t *pos)
+	__acquires(RCU)
+{
+	struct sta_info *sta = s->private;
+	struct ieee80211_scs_sta *scs;
+
+	rcu_read_lock();
+	scs = rcu_dereference(sta->scs);
+	if (!scs || *pos >= scs->n_rules)
+		return NULL;
+
+	return scs->rule[*pos];
+}
+
+static void *sta_scs_seq_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	struct sta_info *sta = s->private;
+	struct ieee80211_scs_sta *scs = rcu_dereference(sta->scs);
+
+	++*pos;
+	if (!scs || *pos >= scs->n_rules)
+		return NULL;
+
+	return scs->rule[*pos];
+}
+
+static void sta_scs_seq_stop(struct seq_file *s, void *v)
+	__releases(RCU)
+{
+	rcu_read_unlock();
+}
+
+static int sta_scs_seq_show(struct seq_file *s, void *v)
+{
+	static const char * const processing[] = {
+		[CFG80211_TCLAS_PROCESSING_ALL] = "all",
+		[CFG80211_TCLAS_PROCESSING_ANY] = "any",
+		[CFG80211_TCLAS_PROCESSING_DEFAULT] = "default",
+	};
+	const struct cfg80211_scs_desc *desc = v;
+	const char *proc = "none";
+	u8 i;
+
+	if (desc->tclas_processing < ARRAY_SIZE(processing))
+		proc = processing[desc->tclas_processing];
+
+	seq_printf(s, "scsid %u up %u processing %s", desc->id, desc->up, proc);
+
+	if (desc->qos_char)
+		seq_printf(s, " qos_char %u direction %u", desc->qos_char_len,
+			   ieee80211_qos_char_direction(desc->qos_char));
+
+	seq_putc(s, '\n');
+
+	for (i = 0; i < desc->n_tclas; i++) {
+		const struct cfg80211_tclas *t = &desc->tclas[i];
+
+		seq_printf(s, "  type %u", t->type);
+		sta_flow_key_show(s, &t->key, t->fields);
+		seq_putc(s, '\n');
+	}
+
+	return 0;
+}
+
+static const struct seq_operations sta_scs_seq_ops = {
+	.start = sta_scs_seq_start,
+	.next = sta_scs_seq_next,
+	.stop = sta_scs_seq_stop,
+	.show = sta_scs_seq_show,
+};
+
+static int sta_scs_open(struct inode *inode, struct file *file)
+{
+	struct seq_file *s;
+	int ret;
+
+	ret = seq_open(file, &sta_scs_seq_ops);
+	if (ret)
+		return ret;
+
+	s = file->private_data;
+	s->private = inode->i_private;
+
+	return 0;
+}
+
+static const struct file_operations sta_scs_ops = {
+	.open = sta_scs_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release,
+};
+
+struct sta_mscs_iter {
+	struct sta_info *sta;
+	struct ieee80211_mscs_sta *mscs;
+};
+
+/* The entry list is not an RCU list, so the whole walk holds the lock */
+static void *sta_mscs_seq_start(struct seq_file *s, loff_t *pos)
+	__acquires(RCU)
+{
+	struct sta_mscs_iter *iter = s->private;
+
+	rcu_read_lock();
+	iter->mscs = rcu_dereference(iter->sta->mscs);
+	if (!iter->mscs)
+		return NULL;
+
+	spin_lock_bh(&iter->mscs->lock);
+
+	if (*pos == 0)
+		return SEQ_START_TOKEN;
+
+	return seq_list_start(&iter->mscs->entries, *pos - 1);
+}
+
+static void *sta_mscs_seq_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	struct sta_mscs_iter *iter = s->private;
+
+	if (v == SEQ_START_TOKEN) {
+		++*pos;
+		return seq_list_start(&iter->mscs->entries, 0);
+	}
+
+	return seq_list_next(v, &iter->mscs->entries, pos);
+}
+
+static void sta_mscs_seq_stop(struct seq_file *s, void *v)
+	__releases(RCU)
+{
+	struct sta_mscs_iter *iter = s->private;
+
+	if (iter->mscs)
+		spin_unlock_bh(&iter->mscs->lock);
+
+	rcu_read_unlock();
+}
+
+static int sta_mscs_seq_show(struct seq_file *s, void *v)
+{
+	struct sta_mscs_iter *iter = s->private;
+	struct ieee80211_mscs_sta *mscs = iter->mscs;
+	struct ieee80211_flow_entry *entry;
+
+	if (v == SEQ_START_TOKEN) {
+		seq_printf(s,
+			   "up_bitmap 0x%02x up_limit %u timeout %ums entries %u\n",
+			   mscs->up_bitmap, mscs->up_limit,
+			   jiffies_to_msecs(mscs->timeout), mscs->n_entries);
+		return 0;
+	}
+
+	entry = list_entry(v, struct ieee80211_flow_entry, list);
+
+	seq_printf(s, "  up %u age %ums", READ_ONCE(entry->up),
+		   jiffies_to_msecs(jiffies - READ_ONCE(entry->last_update)));
+	sta_flow_key_show(s, &entry->hkey.key, mscs->layout);
+	seq_putc(s, '\n');
+
+	return 0;
+}
+
+static const struct seq_operations sta_mscs_seq_ops = {
+	.start = sta_mscs_seq_start,
+	.next = sta_mscs_seq_next,
+	.stop = sta_mscs_seq_stop,
+	.show = sta_mscs_seq_show,
+};
+
+static int sta_mscs_open(struct inode *inode, struct file *file)
+{
+	struct sta_mscs_iter *iter;
+
+	iter = __seq_open_private(file, &sta_mscs_seq_ops, sizeof(*iter));
+	if (!iter)
+		return -ENOMEM;
+
+	iter->sta = inode->i_private;
+
+	return 0;
+}
+
+static const struct file_operations sta_mscs_ops = {
+	.open = sta_mscs_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release_private,
+};
+
 #define AQM_TXQ_ENTRY_LEN 130
 
 static ssize_t sta_aqm_read(struct file *file, char __user *userbuf,
@@ -1252,6 +1490,8 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
 	sta->debugfs_dir = debugfs_create_dir(mac, stations_dir);
 
 	DEBUGFS_ADD(flags);
+	DEBUGFS_ADD(scs);
+	DEBUGFS_ADD(mscs);
 	DEBUGFS_ADD(aid);
 	DEBUGFS_ADD(num_ps_buf_frames);
 	DEBUGFS_ADD(last_seq_ctrl);
-- 
git-series 0.9.1
