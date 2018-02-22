Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:41905 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753189AbeBVKTN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Feb 2018 05:19:13 -0500
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH v2] iw: Print TXQ statistics for stations and interfaces
Date: Thu, 22 Feb 2018 11:18:48 +0100
Message-Id: <20180222101848.18772-1-toke@toke.dk> (sfid-20180222_111917_344823_74B1235A)
In-Reply-To: <20180219170224.14816-1-toke@toke.dk>
References: <20180219170224.14816-1-toke@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds printing of TXQ statistics for stations and interfaces when
supplied by the kernel. For stations, another section is added when verbose
mode is enabled; for interfaces, the multicast queue information is always
printed when available.

This is the information also available through debugfs in
/sys/kernel/debug/ieee80211/phyX/netdev:Y/aqm and
/sys/kernel/debug/ieee80211/phyX/netdev:Y/stations/*/aqm.

Sample output:

$ iw dev wlp2s0 station dump -v
Station xx:xx:xx:xx:xx:xx (on wlp2s0)
[...]
	TXQs:
		TID	qsz-byt	qsz-pkt	flows	drops	marks	overlmt	hashcol	tx-bytes	tx-packets
		0	0	0	0	0	0	0	0	0		0
		1	0	0	0	0	0	0	0	0		0
		2	0	0	0	0	0	0	0	0		0
		3	0	0	0	0	0	0	0	0		0
		4	0	0	0	0	0	0	0	0		0
		5	0	0	0	0	0	0	0	0		0
		6	0	0	0	0	0	0	0	0		0
		7	0	0	0	0	0	0	0	0		0
		8	0	0	0	0	0	0	0	0		0
		9	0	0	0	0	0	0	0	0		0
		10	0	0	0	0	0	0	0	0		0
		11	0	0	0	0	0	0	0	0		0
		12	0	0	0	0	0	0	0	0		0
		13	0	0	0	0	0	0	0	0		0
		14	0	0	0	0	0	0	0	0		0
		15	0	0	0	0	0	0	0	0		0
[...]

$ iw dev wlp2s0 info
Interface wlp2s0
	ifindex 9
	wdev 0x1
	addr xx:xx:xx:xx:xx:xx
	type AP
	wiphy 0
	channel 165 (5825 MHz), width: 20 MHz, center1: 5825 MHz
	txpower 24.00 dBm
	multicast TXQ:
		qsz-byt	qsz-pkt	flows	drops	marks	overlmt	hashcol	tx-bytes	tx-packets
		0	0	72	0	0	0	0	7380		72

Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
v2:
  - Correctly handle variable indent of 'iw dev' output

 interface.c |  6 +++++
 iw.h        |  2 ++
 station.c   | 88 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 95 insertions(+), 1 deletion(-)

diff --git a/interface.c b/interface.c
index a19c83f..712bbdc 100644
--- a/interface.c
+++ b/interface.c
@@ -441,6 +441,12 @@ static int print_iface_handler(struct nl_msg *msg, void *arg)
 		       indent, txp / 100, txp % 100);
 	}
 
+	if (tb_msg[NL80211_ATTR_TXQ_STATS]) {
+		char buf[150];
+		parse_txq_stats(buf, sizeof(buf), tb_msg[NL80211_ATTR_TXQ_STATS], 1, -1, indent);
+		printf("%s\tmulticast TXQ:%s\n", indent, buf);
+	}
+
 	return NL_SKIP;
 }
 
diff --git a/iw.h b/iw.h
index ee7ca20..47aa27d 100644
--- a/iw.h
+++ b/iw.h
@@ -183,6 +183,8 @@ unsigned char *parse_hex(char *hex, size_t *outlen);
 int parse_keys(struct nl_msg *msg, char **argv, int argc);
 int parse_freqchan(struct chandef *chandef, bool chan, int argc, char **argv, int *parsed);
 enum nl80211_chan_width str_to_bw(const char *str);
+int parse_txq_stats(char *buf, int buflen, struct nlattr *tid_stats_attr, int header,
+		    int tid, const char *indent);
 int put_chandef(struct nl_msg *msg, struct chandef *chandef);
 
 void print_ht_mcs(const __u8 *mcs);
diff --git a/station.c b/station.c
index f836d0a..0d2c1ba 100644
--- a/station.c
+++ b/station.c
@@ -43,6 +43,79 @@ static void print_power_mode(struct nlattr *a)
 	}
 }
 
+int parse_txq_stats(char *buf, int buflen, struct nlattr *tid_stats_attr, int header,
+		    int tid, const char *indent)
+{
+	struct nlattr *txqstats_info[NL80211_TXQ_STATS_MAX + 1], *txqinfo;
+	static struct nla_policy txqstats_policy[NL80211_TXQ_STATS_MAX + 1] = {
+		[NL80211_TXQ_STATS_BACKLOG_BYTES] = { .type = NLA_U32 },
+		[NL80211_TXQ_STATS_BACKLOG_PACKETS] = { .type = NLA_U32 },
+		[NL80211_TXQ_STATS_FLOWS] = { .type = NLA_U32 },
+		[NL80211_TXQ_STATS_DROPS] = { .type = NLA_U32 },
+		[NL80211_TXQ_STATS_ECN_MARKS] = { .type = NLA_U32 },
+		[NL80211_TXQ_STATS_OVERLIMIT] = { .type = NLA_U32 },
+		[NL80211_TXQ_STATS_COLLISIONS] = { .type = NLA_U32 },
+		[NL80211_TXQ_STATS_TX_BYTES] = { .type = NLA_U32 },
+		[NL80211_TXQ_STATS_TX_PACKETS] = { .type = NLA_U32 },
+	};
+	char *pos = buf;
+	if (nla_parse_nested(txqstats_info, NL80211_TXQ_STATS_MAX, tid_stats_attr,
+			     txqstats_policy)) {
+		printf("failed to parse nested TXQ stats attributes!");
+		return 0;
+	}
+
+	if (header)
+		pos += snprintf(buf, buflen, "\n%s\t%s\tqsz-byt\t"
+				"qsz-pkt\tflows\tdrops\tmarks\toverlmt\t"
+				"hashcol\ttx-bytes\ttx-packets", indent,
+				tid >= 0 ? "TID" : "");
+
+	pos += snprintf(pos, buflen - (pos - buf), "\n%s\t", indent);
+	if (tid >= 0)
+		pos += snprintf(pos, buflen - (pos - buf), "%d", tid);
+
+
+	txqinfo = txqstats_info[NL80211_TXQ_STATS_BACKLOG_BYTES];
+	if (txqinfo)
+		pos += snprintf(pos, buflen - (pos - buf), "\t%u",
+				nla_get_u32(txqinfo));
+	txqinfo = txqstats_info[NL80211_TXQ_STATS_BACKLOG_PACKETS];
+	if (txqinfo)
+		pos += snprintf(pos, buflen - (pos - buf), "\t%u",
+				nla_get_u32(txqinfo));
+	txqinfo = txqstats_info[NL80211_TXQ_STATS_FLOWS];
+	if (txqinfo)
+		pos += snprintf(pos, buflen - (pos - buf), "\t%u",
+				nla_get_u32(txqinfo));
+	txqinfo = txqstats_info[NL80211_TXQ_STATS_DROPS];
+	if (txqinfo)
+		pos += snprintf(pos, buflen - (pos - buf), "\t%u",
+				nla_get_u32(txqinfo));
+	txqinfo = txqstats_info[NL80211_TXQ_STATS_ECN_MARKS];
+	if (txqinfo)
+		pos += snprintf(pos, buflen - (pos - buf), "\t%u",
+				nla_get_u32(txqinfo));
+	txqinfo = txqstats_info[NL80211_TXQ_STATS_OVERLIMIT];
+	if (txqinfo)
+		pos += snprintf(pos, buflen - (pos - buf), "\t%u",
+				nla_get_u32(txqinfo));
+	txqinfo = txqstats_info[NL80211_TXQ_STATS_COLLISIONS];
+	if (txqinfo)
+		pos += snprintf(pos, buflen - (pos - buf), "\t%u",
+				nla_get_u32(txqinfo));
+	txqinfo = txqstats_info[NL80211_TXQ_STATS_TX_BYTES];
+	if (txqinfo)
+		pos += snprintf(pos, buflen - (pos - buf), "\t%u",
+				nla_get_u32(txqinfo));
+	txqinfo = txqstats_info[NL80211_TXQ_STATS_TX_PACKETS];
+	if (txqinfo)
+		pos += snprintf(pos, buflen - (pos - buf), "\t\t%u",
+				nla_get_u32(txqinfo));
+
+	return pos - buf;
+
+}
 void parse_tid_stats(struct nlattr *tid_stats_attr)
 {
 	struct nlattr *stats_info[NL80211_TID_STATS_MAX + 1], *tidattr, *info;
@@ -51,8 +124,11 @@ void parse_tid_stats(struct nlattr *tid_stats_attr)
 		[NL80211_TID_STATS_TX_MSDU] = { .type = NLA_U64 },
 		[NL80211_TID_STATS_TX_MSDU_RETRIES] = { .type = NLA_U64 },
 		[NL80211_TID_STATS_TX_MSDU_FAILED] = { .type = NLA_U64 },
+		[NL80211_TID_STATS_TXQ_STATS] = { .type = NLA_NESTED },
 	};
 	int rem, i = 0;
+	char txqbuf[2000] = {}, *pos = txqbuf;
+	int buflen = sizeof(txqbuf), foundtxq = 0;
 
 	printf("\n\tMSDU:\n\t\tTID\trx\ttx\ttx retries\ttx failed");
 	nla_for_each_nested(tidattr, tid_stats_attr, rem) {
@@ -61,7 +137,7 @@ void parse_tid_stats(struct nlattr *tid_stats_attr)
 			printf("failed to parse nested stats attributes!");
 			return;
 		}
-		printf("\n\t\t%d", i++);
+		printf("\n\t\t%d", i);
 		info = stats_info[NL80211_TID_STATS_RX_MSDU];
 		if (info)
 			printf("\t%llu", (unsigned long long)nla_get_u64(info));
@@ -74,7 +150,17 @@ void parse_tid_stats(struct nlattr *tid_stats_attr)
 		info = stats_info[NL80211_TID_STATS_TX_MSDU_FAILED];
 		if (info)
 			printf("\t\t%llu", (unsigned long long)nla_get_u64(info));
+		info = stats_info[NL80211_TID_STATS_TXQ_STATS];
+		if (info) {
+			pos += parse_txq_stats(pos, buflen - (pos - txqbuf), info, !foundtxq, i, "\t");
+			foundtxq = 1;
+		}
+
+		i++;
 	}
+
+	if (foundtxq)
+		printf("\n\tTXQs:%s", txqbuf);
 }
 
 void parse_bss_param(struct nlattr *bss_param_attr)
-- 
2.16.2
