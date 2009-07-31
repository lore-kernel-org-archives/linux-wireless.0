Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:54472 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbZGaAFv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 20:05:51 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2009 17:05:53 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] iw: add beacon hint event parsing
Date: Thu, 30 Jul 2009 17:05:50 -0700
Message-ID: <1248998750-7361-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's a screenshot:

mcgrof@pogo ~ $ iw event

mcgrof@pogo ~ $ sudo iw dev wlan0 scan trigger

phy #0: beacon hint:
phy0 5180 MHz [36]:
	o active scanning enabled
	o beaconing enabled

You'll see this on every channel you find a beacon and a flag
is lifted.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

This patch was sitting in a cave lonely since March 31st, seems we forgot
about it it, poor patch. I rebased it.

 event.c |   69 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 69 insertions(+), 0 deletions(-)

diff --git a/event.c b/event.c
index 2671331..0cd3c75 100644
--- a/event.c
+++ b/event.c
@@ -9,6 +9,38 @@ static int no_seq_check(struct nl_msg *msg, void *arg)
 	return NL_OK;
 }
 
+struct ieee80211_beacon_channel {
+	__u16 center_freq;
+	bool passive_scan;
+	bool no_ibss;
+};
+
+static int parse_beacon_hint_chan(struct nlattr *tb,
+				  struct ieee80211_beacon_channel *chan)
+{
+	struct nlattr *tb_freq[NL80211_FREQUENCY_ATTR_MAX + 1];
+	static struct nla_policy beacon_freq_policy[NL80211_FREQUENCY_ATTR_MAX + 1] = {
+		[NL80211_FREQUENCY_ATTR_FREQ] = { .type = NLA_U32 },
+		[NL80211_FREQUENCY_ATTR_PASSIVE_SCAN] = { .type = NLA_FLAG },
+		[NL80211_FREQUENCY_ATTR_NO_IBSS] = { .type = NLA_FLAG },
+	};
+
+	if (nla_parse_nested(tb_freq,
+			     NL80211_FREQUENCY_ATTR_MAX,
+			     tb,
+			     beacon_freq_policy))
+		return -EINVAL;
+
+	chan->center_freq = nla_get_u32(tb_freq[NL80211_FREQUENCY_ATTR_FREQ]);
+
+	if (tb_freq[NL80211_FREQUENCY_ATTR_PASSIVE_SCAN])
+		chan->passive_scan = true;
+	if (tb_freq[NL80211_FREQUENCY_ATTR_NO_IBSS])
+		chan->no_ibss = true;
+
+	return 0;
+}
+
 static void print_frame(struct print_event_args *args, struct nlattr *attr)
 {
 	uint8_t *frame;
@@ -70,12 +102,21 @@ static void print_frame(struct print_event_args *args, struct nlattr *attr)
 
 static int print_event(struct nl_msg *msg, void *arg)
 {
+#define PARSE_BEACON_CHAN(_attr, _chan) do { \
+	r = parse_beacon_hint_chan(tb[_attr], \
+				   &_chan); \
+	if (r) \
+		return NL_SKIP; \
+} while (0)
 	struct genlmsghdr *gnlh = nlmsg_data(nlmsg_hdr(msg));
 	struct nlattr *tb[NL80211_ATTR_MAX + 1], *nst;
 	struct print_event_args *args = arg;
 	char ifname[100];
 	char macbuf[6*3];
 	__u8 reg_type;
+	struct ieee80211_beacon_channel chan_before_beacon,  chan_after_beacon;
+	__u32 wiphy_idx = 0;
+	int r;
 	int rem_nst;
 	__u16 status;
 
@@ -159,6 +200,33 @@ static int print_event(struct nl_msg *msg, void *arg)
 
 		printf("\n");
 		break;
+	case NL80211_CMD_REG_BEACON_HINT:
+
+		wiphy_idx = nla_get_u32(tb[NL80211_ATTR_WIPHY]);
+
+		memset(&chan_before_beacon, 0, sizeof(chan_before_beacon));
+		memset(&chan_after_beacon, 0, sizeof(chan_after_beacon));
+
+		PARSE_BEACON_CHAN(NL80211_ATTR_FREQ_BEFORE, chan_before_beacon);
+		PARSE_BEACON_CHAN(NL80211_ATTR_FREQ_AFTER, chan_after_beacon);
+
+		if (chan_before_beacon.center_freq != chan_after_beacon.center_freq)
+			break;
+
+		/* A beacon hint is sent _only_ if something _did_ change */
+		printf("beacon hint:\n");
+
+		printf("phy%d %d MHz [%d]:\n",
+		       wiphy_idx,
+		       chan_before_beacon.center_freq,
+		       ieee80211_frequency_to_channel(chan_before_beacon.center_freq));
+
+		if (chan_before_beacon.passive_scan && !chan_after_beacon.passive_scan)
+			printf("\to active scanning enabled\n");
+		if (chan_before_beacon.no_ibss && !chan_after_beacon.no_ibss)
+			printf("\to beaconing enabled\n");
+
+		break;
 	case NL80211_CMD_JOIN_IBSS:
 		mac_addr_n2a(macbuf, nla_data(tb[NL80211_ATTR_MAC]));
 		printf("IBSS %s joined\n", macbuf);
@@ -236,6 +304,7 @@ static int print_event(struct nl_msg *msg, void *arg)
 	}
 
 	return NL_SKIP;
+#undef PARSE_BEACON_CHAN
 }
 
 struct wait_event {
-- 
1.6.3.3

