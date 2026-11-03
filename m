Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793723048;
	b=kz/jxPQJLHmxB6oMP3EPQe9w6lJBMqOjp9sjqLiKv5vSsIIbwrBKeRf4fsZoPZwWEOD1
	 Bk5gNpuFZiFUR/ANJs4TSOT7Y+sBBbqqDBXSXFy+L0YxrP6fcgXvJfNpeOy+SVgJ1KpMs
	 jNvqK0GrxvkNn74nRaz2voznkBAKKYSHLE+iQMyvvHwbdu5G8CUBHjSH0toduYXbYGqUN
	 H6nlbocChJJsAi3G4vezwYc9pKwuY7nHFSflVnCKwwSU8P0oNryc1YZ562CYF0pVIbll3
	 38FcoWOFkKHNm7HB6J0VSkxji+fbMIqu0vP7arfEloXapsHAjDKSejxhACZIew8n4Mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793723048;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=95MNN4iM85uT8aIiBN1Bsl1Yqouwyu85HqeHNwJDhQo=;
	b=WyxcJzbdIbdi0Yvo9czNarcdFV45DJqvDEIWKepwOh6d43fwtRgjJJsR9L76eWiXkMgU
	 80ZHZINi5ADr7+wo/WXTYWEcEI0ZDyNjSF++663PO0uOJyl0kqAeINxaJ9YYfk3Rlvx+9
	 UoILzj5Yvv8g9tPDcvaGIltfliTtHhgldNhJpYx33LsrfZSFlna8LtL4wf6PsJqy8ah29
	 kzijULpolNq47FDi2fG9R/WuxcMGgeSdgclzSFZ77LQvJ3311sJHHWeBXXvjpjP7QqUo1
	 PZyCuaIll0+rRNM5cyH0yrxv7m433NQX3QCci8w1pxZTzidDVYCo4ga9sCH8Ee6KgeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b="avzB/QZv";
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53AC2606D818
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 16:24:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 53AC2606D818
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=avzB/QZv
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=95MNN4iM85uT8aIiBN1Bsl1Yqouwyu85HqeHNwJDhQo=; b=avzB/QZvoSAoevNiVZy9LX0GV1
	fu71XfQG0WvIFRKdE5I3d90ux9SovM/AenvW+3NwsDit2meU/YTo60dp3Gmz4XtG1MSSCLoVtpsgu
	7RIUCreO2ifTiHjwko6WBuoipP1sNTQj7dHCfpYR9LNKLPuCUi+n+3fqjEPMx1eRk4SA=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xOHIn-00FDFp-1r;
	Tue, 03 Nov 2026 17:24:01 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH wireless-next 14/18] wifi: mac80211: add SCS and MSCS debugfs files
Date: Tue,  3 Nov 2026 17:23:47 +0100
Message-ID: <637f60209850188c9d10817e3791062caec2293b.1793722802.git-series.nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.118d7c7b799f8ed35de51dc2aefef460bf69727b.1793722802.git-series.nbd@nbd.name>
References: <cover.118d7c7b799f8ed35de51dc2aefef460bf69727b.1793722802.git-series.nbd@nbd.name>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a per station scs file, which dumps every rule with its parsed
classifier and client, and an mscs file, which dumps every MSCS of the
station with its parameters and learned entries.

The scs file is a seq_file iterator, so that it does not have to size a
buffer for a set of up to 255 rules with 255 classifiers each.

Neither file takes the wiphy lock. Station removal holds it while
debugfs waits for readers to finish, so a reader that needed it would
have to go through wiphy_locked_debugfs_read(). RCU is enough here.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/debugfs_sta.c | 190 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 190 insertions(+)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 690c186e3bb9..f7e99240678f 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -10,6 +10,7 @@
 
 #include <linux/debugfs.h>
 #include <linux/ieee80211.h>
+#include <linux/if_vlan.h>
 #include "ieee80211_i.h"
 #include "debugfs.h"
 #include "debugfs_sta.h"
@@ -131,6 +132,193 @@ static ssize_t sta_last_seq_ctrl_read(struct file *file, char __user *userbuf,
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
+	if (!is_zero_ether_addr(desc->client))
+		seq_printf(s, " client %pM", desc->client);
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
+static int sta_mscs_show(struct seq_file *s, void *data)
+{
+	struct sta_info *sta = s->private;
+	struct ieee80211_flow_entry *entry;
+	struct ieee80211_mscs_sta *mscs;
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(mscs, &sta->mscs, list) {
+		spin_lock_bh(&mscs->lock);
+
+		seq_printf(s,
+			   "client %pM%s up_bitmap 0x%02x up_limit %u timeout %ums entries %u\n",
+			   mscs->client, mscs->configured ? " configured" : "",
+			   mscs->up_bitmap, mscs->up_limit,
+			   jiffies_to_msecs(mscs->timeout), mscs->n_entries);
+
+		list_for_each_entry(entry, &mscs->entries, list) {
+			seq_printf(s, "  up %u age %ums", READ_ONCE(entry->up),
+				   jiffies_to_msecs(jiffies -
+						    READ_ONCE(entry->last_update)));
+			sta_flow_key_show(s, &entry->hkey.key, mscs->layout);
+			seq_putc(s, '\n');
+		}
+
+		spin_unlock_bh(&mscs->lock);
+	}
+
+	rcu_read_unlock();
+
+	return 0;
+}
+
+static int sta_mscs_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, sta_mscs_show, inode->i_private);
+}
+
+static const struct file_operations sta_mscs_ops = {
+	.open = sta_mscs_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
 #define AQM_TXQ_ENTRY_LEN 130
 
 static ssize_t sta_aqm_read(struct file *file, char __user *userbuf,
@@ -1267,6 +1455,8 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
 	sta->debugfs_dir = debugfs_create_dir(mac, stations_dir);
 
 	DEBUGFS_ADD(flags);
+	DEBUGFS_ADD(scs);
+	DEBUGFS_ADD(mscs);
 	DEBUGFS_ADD(aid);
 	DEBUGFS_ADD(num_ps_buf_frames);
 	DEBUGFS_ADD(last_seq_ctrl);
-- 
git-series 0.9.1
