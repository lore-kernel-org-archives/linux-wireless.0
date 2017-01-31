Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14380 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751913AbdAaULL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jan 2017 15:11:11 -0500
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2 2/3] mac80211: Make mesh failure moving average configurable
Date: Tue, 31 Jan 2017 12:07:51 -0800
Message-ID: <1485893272-6893-2-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20170131_211115_871528_FAA5AEBF)
In-Reply-To: <1485893272-6893-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1485893272-6893-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently mesh moving fail average is calculated based on constant
weight factor. In worst case moving average reaches threshold by
considering 16 msdu tx ack status and deactivates mesh path. Having
a constant weight factor might not be suitable for all environments.
So make it tunable parameter and also lower default weight to 10 so
that mesh broken link calculation will consider more packet status
(32 msdus ack status) before dropping mesh path.

In OTA 2-hop topolgy (MP1 <-> MP2 <-> MP3), while running TCP traffic
of window size of 2M where each nodes are operating in VHT80 mode,
mesh path between forwarding node (MP2) and border nodes (MP1/MP3) is
deactivated more often when average weight is 20.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 net/mac80211/debugfs_netdev.c | 27 +++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h    |  1 +
 net/mac80211/mesh.c           |  1 +
 net/mac80211/mesh.h           |  3 +++
 net/mac80211/mesh_hwmp.c      |  4 +++-
 5 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 8f5fff8b2040..3923401a85dd 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -586,6 +586,32 @@ static ssize_t ieee80211_if_parse_tsf(
 #ifdef CONFIG_MAC80211_MESH
 IEEE80211_IF_FILE(estab_plinks, u.mesh.estab_plinks, ATOMIC);
 
+static ssize_t ieee80211_if_fmt_fail_avg_weight(
+	const struct ieee80211_sub_if_data *sdata, char *buf, int buflen)
+{
+	return snprintf(buf, buflen, "%d\n", sdata->u.mesh.fail_avg_weight);
+}
+
+static ssize_t ieee80211_if_parse_fail_avg_weight(
+	struct ieee80211_sub_if_data *sdata, const char *buf, int buflen)
+{
+	u8 val;
+	int ret;
+
+	ret = kstrtou8(buf, 0, &val);
+	if (ret)
+		return ret;
+
+	if (val > 100)
+		return -ERANGE;
+
+	sdata->u.mesh.fail_avg_weight = val;
+
+	return buflen;
+}
+
+IEEE80211_IF_FILE_RW(fail_avg_weight);
+
 /* Mesh stats attributes */
 IEEE80211_IF_FILE(fwded_mcast, u.mesh.mshstats.fwded_mcast, DEC);
 IEEE80211_IF_FILE(fwded_unicast, u.mesh.mshstats.fwded_unicast, DEC);
@@ -711,6 +737,7 @@ static void add_mesh_files(struct ieee80211_sub_if_data *sdata)
 {
 	DEBUGFS_ADD_MODE(tsf, 0600);
 	DEBUGFS_ADD_MODE(estab_plinks, 0400);
+	DEBUGFS_ADD_MODE(fail_avg_weight, 0600);
 }
 
 static void add_mesh_stats(struct ieee80211_sub_if_data *sdata)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 159a1a733725..30babcea3e06 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -711,6 +711,7 @@ struct ieee80211_if_mesh {
 	struct mesh_table *mpp_paths; /* Store paths for MPP&MAP */
 	int mesh_paths_generation;
 	int mpp_paths_generation;
+	u8 fail_avg_weight;
 };
 
 #ifdef CONFIG_MAC80211_MESH
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 9c23172feba0..491fd76f91bd 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1368,6 +1368,7 @@ void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata)
 	ifmsh->last_preq = jiffies;
 	ifmsh->next_perr = jiffies;
 	ifmsh->csa_role = IEEE80211_MESH_CSA_ROLE_NONE;
+	ifmsh->fail_avg_weight = MESH_FAIL_AVG_WEIGHT;
 	/* Allocate all mesh structures when creating the first mesh interface. */
 	if (!mesh_allocated)
 		ieee80211s_init();
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 7e5f271e3c30..887746022cc6 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -185,6 +185,9 @@ struct mesh_rmc {
 /* Number of frames buffered per destination for unresolved destinations */
 #define MESH_FRAME_QUEUE_LEN	10
 
+/* Moving failure average weight of mesh peer link (in percent) */
+#define MESH_FAIL_AVG_WEIGHT 10
+
 /* Public interfaces */
 /* Various */
 int ieee80211_fill_mesh_addresses(struct ieee80211_hdr *hdr, __le16 *fc,
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index f0aa1da15bd0..61a824eb2c73 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -301,6 +301,7 @@ void ieee80211s_update_metric(struct ieee80211_local *local,
 	struct ieee80211_tx_info *txinfo = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	u32 fail_avg = sta->mesh->fail_avg;
+	u8 fail_avg_weight = sta->sdata->u.mesh.fail_avg_weight;
 	int failed;
 
 	if (!ieee80211_is_data(hdr->frame_control))
@@ -309,7 +310,8 @@ void ieee80211s_update_metric(struct ieee80211_local *local,
 	failed = !(txinfo->flags & IEEE80211_TX_STAT_ACK);
 
 	/* moving average, scaled to 100 */
-	fail_avg = ((80 * fail_avg + 5) / 100 + 20 * failed);
+	fail_avg = (((100 - fail_avg_weight) * fail_avg + 5) / 100 +
+		    fail_avg_weight * failed);
 
 	/* bump up fail average since fractional part of average is ignored.
 	 * Otherwise fail average always stuck at the same level and
-- 
1.9.1
