Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:40035 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753208AbeBSRCy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 12:02:54 -0500
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH 3/3] iw: Add getting and setting of TXQ params for phy
Date: Mon, 19 Feb 2018 18:02:24 +0100
Message-Id: <20180219170224.14816-4-toke@toke.dk> (sfid-20180219_180258_678021_884022C3)
In-Reply-To: <20180219170224.14816-1-toke@toke.dk>
References: <20180219170224.14816-1-toke@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds commands to get and set the per-phy TXQ parameters for drivers
that use the intermediate TXQs. These are the settings and statistics that
are also available through /sys/kernel/debug/ieee80211/phyX/aqm.

Sample output:

$ iw phy phy0 get txq
Packet limit:		8192 pkts
Memory limit:		4194304 bytes
Quantum:		300 bytes
Number of queues:	4096
Backlog:		12 pkts
Memory usage:		52224 bytes
Packet limit overflows:	0
Memory limit overflows:	0
Hash collisions:	1

# iw phy phy0 set txq limit 1024
# iw phy phy0 set txq memory_limit 1024000
# iw phy phy0 set txq quantum 1000

Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 info.c |   3 ++
 phy.c  | 116 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 119 insertions(+)

diff --git a/info.c b/info.c
index 1eba5c9..291cf24 100644
--- a/info.c
+++ b/info.c
@@ -609,6 +609,9 @@ broken_combination:
 		if (ext_feature_isset(nla_data(tb), nla_len(tb),
 				      NL80211_EXT_FEATURE_VHT_IBSS))
 			printf("\tDevice supports VHT-IBSS.\n");
+		if (ext_feature_isset(nla_data(tb), nla_len(tb),
+				      NL80211_EXT_FEATURE_TXQS))
+			printf("\tDriver supports FQ-CoDel-enabled intermediate TXQs.\n");
 	}
 
 	if (tb_msg[NL80211_ATTR_TDLS_SUPPORT])
diff --git a/phy.c b/phy.c
index be31820..77df7a7 100644
--- a/phy.c
+++ b/phy.c
@@ -727,3 +727,119 @@ COMMAND(set, antenna, "<bitmap> | all | <tx bitmap> <rx bitmap>",
 	NL80211_CMD_SET_WIPHY, 0, CIB_PHY, handle_antenna,
 	"Set a bitmap of allowed antennas to use for TX and RX.\n"
 	"The driver may reject antenna configurations it cannot support.");
+
+static int handle_set_txq(struct nl80211_state *state,
+			  struct nl_msg *msg,
+			  int argc, char **argv,
+			  enum id_input id)
+{
+	unsigned int argval;
+	char *end;
+
+	if (argc != 2)
+		return 1;
+
+	if (!*argv[0] || !*argv[1])
+		return 1;
+
+	argval = strtoul(argv[1], &end, 10);
+
+	if (*end)
+		return 1;
+
+	if (!argval)
+		return 1;
+
+	if (strcmp("limit", argv[0]) == 0)
+		NLA_PUT_U32(msg, NL80211_ATTR_TXQ_LIMIT, argval);
+	else if (strcmp("memory_limit", argv[0]) == 0)
+		NLA_PUT_U32(msg, NL80211_ATTR_TXQ_MEMORY_LIMIT, argval);
+	else if (strcmp("quantum", argv[0]) == 0)
+		NLA_PUT_U32(msg, NL80211_ATTR_TXQ_QUANTUM, argval);
+	else
+		return -1;
+
+	return 0;
+ nla_put_failure:
+	return -ENOBUFS;
+}
+COMMAND(set, txq, "limit <packets> | memory_limit <bytes> | quantum <bytes>",
+	NL80211_CMD_SET_WIPHY, 0, CIB_PHY, handle_set_txq,
+	"Set TXQ parameters. The limit and memory_limit are global queue limits\n"
+	"for the whole phy. The quantum is the DRR scheduler quantum setting.\n"
+	"Valid values: 1 - 2**32");
+
+static int print_txq_handler(struct nl_msg *msg, void *arg)
+{
+	struct nlattr *attrs[NL80211_ATTR_MAX + 1];
+	struct genlmsghdr *gnlh = nlmsg_data(nlmsg_hdr(msg));
+	struct nlattr *txqstats_info[NL80211_TXQ_STATS_MAX + 1], *txqinfo;
+	static struct nla_policy txqstats_policy[NL80211_TXQ_STATS_MAX + 1] = {
+		[NL80211_TXQ_STATS_BACKLOG_PACKETS] = { .type = NLA_U32 },
+		[NL80211_TXQ_STATS_BACKLOG_BYTES] = { .type = NLA_U32 },
+		[NL80211_TXQ_STATS_OVERLIMIT] = { .type = NLA_U32 },
+		[NL80211_TXQ_STATS_OVERMEMORY] = { .type = NLA_U32 },
+		[NL80211_TXQ_STATS_COLLISIONS] = { .type = NLA_U32 },
+		[NL80211_TXQ_STATS_MAX_FLOWS] = { .type = NLA_U32 },
+	};
+
+	nla_parse(attrs, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
+		  genlmsg_attrlen(gnlh, 0), NULL);
+
+
+	if (attrs[NL80211_ATTR_TXQ_LIMIT])
+		printf("Packet limit:\t\t%u pkts\n",
+			nla_get_u32(attrs[NL80211_ATTR_TXQ_LIMIT]));
+	if (attrs[NL80211_ATTR_TXQ_MEMORY_LIMIT])
+		printf("Memory limit:\t\t%u bytes\n",
+			nla_get_u32(attrs[NL80211_ATTR_TXQ_MEMORY_LIMIT]));
+	if (attrs[NL80211_ATTR_TXQ_QUANTUM])
+		printf("Quantum:\t\t%u bytes\n",
+			nla_get_u32(attrs[NL80211_ATTR_TXQ_QUANTUM]));
+
+	if (attrs[NL80211_ATTR_TXQ_STATS]) {
+		if (nla_parse_nested(txqstats_info, NL80211_TXQ_STATS_MAX,
+				     attrs[NL80211_ATTR_TXQ_STATS],
+				     txqstats_policy)) {
+			printf("failed to parse nested TXQ stats attributes!");
+			return 0;
+		}
+		txqinfo = txqstats_info[NL80211_TXQ_STATS_MAX_FLOWS];
+		if (txqinfo)
+			printf("Number of queues:\t%u\n", nla_get_u32(txqinfo));
+
+		txqinfo = txqstats_info[NL80211_TXQ_STATS_BACKLOG_PACKETS];
+		if (txqinfo)
+			printf("Backlog:\t\t%u pkts\n", nla_get_u32(txqinfo));
+
+		txqinfo = txqstats_info[NL80211_TXQ_STATS_BACKLOG_BYTES];
+		if (txqinfo)
+			printf("Memory usage:\t\t%u bytes\n", nla_get_u32(txqinfo));
+
+		txqinfo = txqstats_info[NL80211_TXQ_STATS_OVERLIMIT];
+		if (txqinfo)
+			printf("Packet limit overflows:\t%u\n", nla_get_u32(txqinfo));
+
+		txqinfo = txqstats_info[NL80211_TXQ_STATS_OVERMEMORY];
+		if (txqinfo)
+			printf("Memory limit overflows:\t%u\n", nla_get_u32(txqinfo));
+		txqinfo = txqstats_info[NL80211_TXQ_STATS_COLLISIONS];
+		if (txqinfo)
+			printf("Hash collisions:\t%u\n", nla_get_u32(txqinfo));
+	}
+	return NL_SKIP;
+}
+
+static int handle_get_txq(struct nl80211_state *state,
+			  struct nl_msg *msg,
+			  int argc, char **argv,
+			  enum id_input id)
+{
+	nla_put_flag(msg, NL80211_ATTR_SPLIT_WIPHY_DUMP);
+	nlmsg_hdr(msg)->nlmsg_flags |= NLM_F_DUMP;
+	register_handler(print_txq_handler, NULL);
+	return 0;
+}
+COMMAND(get, txq, "",
+	NL80211_CMD_GET_WIPHY, 0, CIB_PHY, handle_get_txq,
+	"Get TXQ parameters.");
-- 
2.16.1
