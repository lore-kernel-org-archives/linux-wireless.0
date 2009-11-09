Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:52823 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692AbZKIMxN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 07:53:13 -0500
Received: by fxm21 with SMTP id 21so164895fxm.21
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 04:53:18 -0800 (PST)
From: Rui Paulo <rpaulo@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Rui Paulo <rpaulo@gmail.com>
Subject: iw [PATCH] update to latest kernel changes (mesh)
Date: Mon,  9 Nov 2009 12:53:07 +0000
Message-Id: <1257771187-7894-2-git-send-email-rpaulo@gmail.com>
In-Reply-To: <1257771187-7894-1-git-send-email-rpaulo@gmail.com>
References: <1257771187-7894-1-git-send-email-rpaulo@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This introduces a new mesh parameter mesh_hwmp_rootmode to make the
mesh point act as a root node using mesh RANN frames.

Signed-off-by: Rui Paulo <rpaulo@gmail.com>
---
 mesh.c    |    2 ++
 mpath.c   |    8 ++++----
 nl80211.h |   11 +++++++----
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/mesh.c b/mesh.c
index 624ec37..8a03282 100644
--- a/mesh.c
+++ b/mesh.c
@@ -165,6 +165,8 @@ const static struct mesh_param_descr _mesh_param_descrs[] =
 	{"mesh_hwmp_net_diameter_traversal_time",
 	NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME,
 	_my_nla_put_u16, _parse_u16, _print_u16_in_TUs},
+	{"mesh_hwmp_rootmode", NL80211_MESHCONF_HWMP_ROOTMODE,
+	_my_nla_put_u8, _parse_u8, _print_u8},
 };
 
 static void print_all_mesh_param_descr(void)
diff --git a/mpath.c b/mpath.c
index eb5ad6a..8f5a334 100644
--- a/mpath.c
+++ b/mpath.c
@@ -38,7 +38,7 @@ static int print_mpath_handler(struct nl_msg *msg, void *arg)
 	char dst[20], next_hop[20], dev[20];
 	static struct nla_policy mpath_policy[NL80211_MPATH_INFO_MAX + 1] = {
 		[NL80211_MPATH_INFO_FRAME_QLEN] = { .type = NLA_U32 },
-		[NL80211_MPATH_INFO_DSN] = { .type = NLA_U32 },
+		[NL80211_MPATH_INFO_SN] = { .type = NLA_U32 },
 		[NL80211_MPATH_INFO_METRIC] = { .type = NLA_U32 },
 		[NL80211_MPATH_INFO_EXPTIME] = { .type = NLA_U32 },
 		[NL80211_MPATH_INFO_DISCOVERY_TIMEOUT] = { .type = NLA_U32 },
@@ -70,9 +70,9 @@ static int print_mpath_handler(struct nl_msg *msg, void *arg)
 	mac_addr_n2a(next_hop, nla_data(tb[NL80211_ATTR_MPATH_NEXT_HOP]));
 	if_indextoname(nla_get_u32(tb[NL80211_ATTR_IFINDEX]), dev);
 	printf("%s %s %s", dst, next_hop, dev);
-	if (pinfo[NL80211_MPATH_INFO_DSN])
+	if (pinfo[NL80211_MPATH_INFO_SN])
 		printf("\t%u",
-			nla_get_u32(pinfo[NL80211_MPATH_INFO_DSN]));
+			nla_get_u32(pinfo[NL80211_MPATH_INFO_SN]));
 	if (pinfo[NL80211_MPATH_INFO_METRIC])
 		printf("\t%u",
 			nla_get_u32(pinfo[NL80211_MPATH_INFO_METRIC]));
@@ -184,7 +184,7 @@ static int handle_mpath_dump(struct nl80211_state *state,
 			     struct nl_msg *msg,
 			     int argc, char **argv)
 {
-	printf("DEST ADDR         NEXT HOP          IFACE\tDSN\tMETRIC\tQLEN\t"
+	printf("DEST ADDR         NEXT HOP          IFACE\tSN\tMETRIC\tQLEN\t"
 	       "EXPTIME\t\tDTIM\tDRET\tFLAGS\n");
 	nl_cb_set(cb, NL_CB_VALID, NL_CB_CUSTOM, print_mpath_handler, NULL);
 	return 0;
diff --git a/nl80211.h b/nl80211.h
index a8d71ed..8d58267 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -895,14 +895,14 @@ enum nl80211_sta_info {
  *
  * @NL80211_MPATH_FLAG_ACTIVE: the mesh path is active
  * @NL80211_MPATH_FLAG_RESOLVING: the mesh path discovery process is running
- * @NL80211_MPATH_FLAG_DSN_VALID: the mesh path contains a valid DSN
+ * @NL80211_MPATH_FLAG_SN_VALID: the mesh path contains a valid SN
  * @NL80211_MPATH_FLAG_FIXED: the mesh path has been manually set
  * @NL80211_MPATH_FLAG_RESOLVED: the mesh path discovery process succeeded
  */
 enum nl80211_mpath_flags {
 	NL80211_MPATH_FLAG_ACTIVE =	1<<0,
 	NL80211_MPATH_FLAG_RESOLVING =	1<<1,
-	NL80211_MPATH_FLAG_DSN_VALID =	1<<2,
+	NL80211_MPATH_FLAG_SN_VALID =	1<<2,
 	NL80211_MPATH_FLAG_FIXED =	1<<3,
 	NL80211_MPATH_FLAG_RESOLVED =	1<<4,
 };
@@ -915,7 +915,7 @@ enum nl80211_mpath_flags {
  *
  * @__NL80211_MPATH_INFO_INVALID: attribute number 0 is reserved
  * @NL80211_ATTR_MPATH_FRAME_QLEN: number of queued frames for this destination
- * @NL80211_ATTR_MPATH_DSN: destination sequence number
+ * @NL80211_ATTR_MPATH_SN: destination sequence number
  * @NL80211_ATTR_MPATH_METRIC: metric (cost) of this mesh path
  * @NL80211_ATTR_MPATH_EXPTIME: expiration time for the path, in msec from now
  * @NL80211_ATTR_MPATH_FLAGS: mesh path flags, enumerated in
@@ -926,7 +926,7 @@ enum nl80211_mpath_flags {
 enum nl80211_mpath_info {
 	__NL80211_MPATH_INFO_INVALID,
 	NL80211_MPATH_INFO_FRAME_QLEN,
-	NL80211_MPATH_INFO_DSN,
+	NL80211_MPATH_INFO_SN,
 	NL80211_MPATH_INFO_METRIC,
 	NL80211_MPATH_INFO_EXPTIME,
 	NL80211_MPATH_INFO_FLAGS,
@@ -1196,6 +1196,8 @@ enum nl80211_mntr_flags {
  * @NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME: The interval of time (in TUs)
  * that it takes for an HWMP information element to propagate across the mesh
  *
+ * @NL80211_MESHCONF_ROOTMODE: whether root mode is enabled or not
+ *
  * @NL80211_MESHCONF_ATTR_MAX: highest possible mesh configuration attribute
  *
  * @__NL80211_MESHCONF_ATTR_AFTER_LAST: internal use
@@ -1215,6 +1217,7 @@ enum nl80211_meshconf_params {
 	NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT,
 	NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL,
 	NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME,
+	NL80211_MESHCONF_HWMP_ROOTMODE,
 
 	/* keep last */
 	__NL80211_MESHCONF_ATTR_AFTER_LAST,
-- 
1.5.6.5

