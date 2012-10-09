Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60190 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab2JIU3j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2012 16:29:39 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so5630701pbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Oct 2012 13:29:39 -0700 (PDT)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	javier@cozybit.com, devel@lists.open80211s.org,
	Ashok Nagarajan <ashok@cozybit.com>
Subject: [PATCH 2/2] iw: Add new command to get statistical information of the mesh network
Date: Tue,  9 Oct 2012 13:29:27 -0700
Message-Id: <1349814567-29556-2-git-send-email-ashok@cozybit.com> (sfid-20121009_222942_029665_893BD0A0)
In-Reply-To: <1349814567-29556-1-git-send-email-ashok@cozybit.com>
References: <1349814567-29556-1-git-send-email-ashok@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iw dev <devname> get mesh_stats [<stats>] gets statistics of the mesh network.
It will use the new %NL80211_CMD_GET_MESH_STATS command.

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
---
 mesh.c |  117 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 util.c |    2 +
 2 files changed, 119 insertions(+), 0 deletions(-)

diff --git a/mesh.c b/mesh.c
index 4fdad6a..32135ae 100644
--- a/mesh.c
+++ b/mesh.c
@@ -23,6 +23,14 @@ typedef struct _any_t {
 	} u;
 } _any;
 
+/* describes a mesh stats */
+struct mesh_stats_descr {
+	const char *name;
+	enum nl80211_mesh_stats mesh_stats_num;
+	int (*nla_put_fn)(struct nl_msg*, int, _any*);
+	void (*nla_print_fn)(struct nlattr *);
+};
+
 /* describes a mesh parameter */
 struct mesh_param_descr {
 	const char *name;
@@ -150,6 +158,38 @@ static void _print_s32_in_dBm(struct nlattr *a)
 	printf("%d dBm", (int32_t) nla_get_u32(a));
 }
 
+/* The current mesh stats */
+const static struct mesh_stats_descr _mesh_stats_descrs[] =
+{
+	{"mesh_fwded_mcast",
+	NL80211_MESH_STATS_FWDED_MCAST,
+	_my_nla_put_u32, _print_u32},
+	{"mesh_fwded_unicast",
+	NL80211_MESH_STATS_FWDED_UNICAST,
+	_my_nla_put_u32, _print_u32},
+	{"mesh_fwded_frames",
+	NL80211_MESH_STATS_FWDED_FRAMES,
+	_my_nla_put_u32, _print_u32},
+	{"mesh_dropped_frames_ttl",
+	NL80211_MESH_STATS_DROPPED_FRAMES_TTL,
+	_my_nla_put_u32, _print_u32},
+	{"mesh_dropped_frames_no_route",
+	NL80211_MESH_STATS_DROPPED_FRAMES_NO_ROUTE,
+	_my_nla_put_u32, _print_u32},
+	{"mesh_dropped_frames_congestion",
+	NL80211_MESH_STATS_DROPPED_FRAMES_CONGESTION,
+	_my_nla_put_u32, _print_u32},
+};
+
+static void print_all_mesh_stats_descr(void)
+{
+	int i;
+
+	printf("Possible mesh stats are:\n");
+
+	for (i = 0; i < ARRAY_SIZE(_mesh_stats_descrs); i++)
+		printf(" - %s\n", _mesh_stats_descrs[i].name);
+}
 
 /* The current mesh parameters */
 const static struct mesh_param_descr _mesh_param_descrs[] =
@@ -229,6 +269,19 @@ static void print_all_mesh_param_descr(void)
 		printf(" - %s\n", _mesh_param_descrs[i].name);
 }
 
+static const struct mesh_stats_descr *find_mesh_stats(const char *name)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(_mesh_stats_descrs); i++) {
+		if (strcmp(_mesh_stats_descrs[i].name, name) == 0)
+			return _mesh_stats_descrs + i;
+	}
+
+	print_all_mesh_stats_descr();
+	return NULL;
+}
+
 static const struct mesh_param_descr *find_mesh_param(const char *name)
 {
 	int i;
@@ -351,6 +404,70 @@ static int print_mesh_param_handler(struct nl_msg *msg, void *arg)
 	return NL_SKIP;
 }
 
+static int print_mesh_stats_handler(struct nl_msg *msg, void *arg)
+{
+	const struct mesh_stats_descr *mdescr = arg;
+	struct nlattr *attrs[NL80211_ATTR_MAX + 1];
+	struct nlattr *parent_attr;
+	struct nlattr *mesh_stats[NL80211_MESH_STATS_ATTR_MAX + 1];
+	struct genlmsghdr *gnlh = nlmsg_data(nlmsg_hdr(msg));
+
+	/* locate NL80211_ATTR_MESH_STATS */
+	nla_parse(attrs, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
+		  genlmsg_attrlen(gnlh, 0), NULL);
+	parent_attr = attrs[NL80211_ATTR_MESH_STATS];
+	if (!parent_attr)
+		return -EINVAL;
+
+	if (nla_parse_nested(mesh_stats, NL80211_MESH_STATS_ATTR_MAX,
+			     parent_attr, NULL))
+		return -EINVAL;
+
+	/* Print all mesh stats if no parameter is passed */
+	if (!mdescr) {
+		int i;
+
+		for (i = 0; i < ARRAY_SIZE(_mesh_stats_descrs); i++) {
+			mdescr = &_mesh_stats_descrs[i];
+			printf("%s = ", mdescr->name);
+			mdescr->nla_print_fn(mesh_stats[mdescr->mesh_stats_num]);
+			printf("\n");
+		}
+		return NL_SKIP;
+	}
+
+	/* Print the mesh stat requested */
+	mdescr->nla_print_fn(mesh_stats[mdescr->mesh_stats_num]);
+	printf("\n");
+	return NL_SKIP;
+}
+
+static int get_interface_meshstats(struct nl80211_state *state,
+				   struct nl_cb *cb,
+				   struct nl_msg *msg,
+				   int argc, char **argv,
+				   enum id_input id)
+{
+	const struct mesh_stats_descr *mdescr = NULL;
+
+	if (argc > 1)
+		return 1;
+
+	if (argc == 1) {
+		mdescr = find_mesh_stats(argv[0]);
+		if (!mdescr)
+			return 2;
+	}
+
+	nl_cb_set(cb, NL_CB_VALID, NL_CB_CUSTOM,
+		  print_mesh_stats_handler, (void *)mdescr);
+	return 0;
+}
+
+COMMAND(get, mesh_stats, "[<stats>]",
+	NL80211_CMD_GET_MESH_STATS, 0, CIB_NETDEV, get_interface_meshstats,
+	"Retrieve mesh statistics (run command without any to see available ones).");
+
 static int get_interface_meshparam(struct nl80211_state *state,
 				   struct nl_cb *cb,
 				   struct nl_msg *msg,
diff --git a/util.c b/util.c
index e40a2d5..6ceb9d4 100644
--- a/util.c
+++ b/util.c
@@ -236,6 +236,8 @@ static const char *commands[NL80211_CMD_MAX + 1] = {
 	[NL80211_CMD_UNEXPECTED_4ADDR_FRAME] = "unexpected_4addr_frame",
 	[NL80211_CMD_SET_NOACK_MAP] = "set_noack_map",
 	[NL80211_CMD_CH_SWITCH_NOTIFY] = "ch_switch_notify",
+	[NL80211_CMD_GET_MESH_STATS] = "get_mesh_stats",
+
 };
 
 static char cmdbuf[100];
-- 
1.7.5.4

