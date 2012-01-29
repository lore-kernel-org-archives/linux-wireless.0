Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:43932 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab2A2Ov1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jan 2012 09:51:27 -0500
From: Antonio Quartulli <ordex@autistici.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Antonio Quartulli <ordex@autistici.org>
Subject: [PATCH] iw: add support for NL80211_CMD_SET_STATION event
Date: Sun, 29 Jan 2012 15:50:35 +0100
Message-Id: <1327848635-28174-1-git-send-email-ordex@autistici.org> (sfid-20120129_155153_946799_883D006A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch makes iw print an appropriate message in case of
NL80211_CMD_SET_STATION event. Involved flag with their values are printed too.

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
---
 event.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/event.c b/event.c
index bc39662..21cd426 100644
--- a/event.c
+++ b/event.c
@@ -188,6 +188,7 @@ static int print_event(struct nl_msg *msg, void *arg)
 	struct genlmsghdr *gnlh = nlmsg_data(nlmsg_hdr(msg));
 	struct nlattr *tb[NL80211_ATTR_MAX + 1], *nst;
 	struct print_event_args *args = arg;
+	struct nl80211_sta_flag_update *sta_flags_upd;
 	char ifname[100];
 	char macbuf[6*3];
 	__u8 reg_type;
@@ -317,6 +318,17 @@ static int print_event(struct nl_msg *msg, void *arg)
 			printf("\to beaconing enabled\n");
 
 		break;
+	case NL80211_CMD_SET_STATION:
+		mac_addr_n2a(macbuf, nla_data(tb[NL80211_ATTR_MAC]));
+		printf("set station %s\n", macbuf);
+		if (tb[NL80211_ATTR_STA_FLAGS2]) {
+			sta_flags_upd = nla_data(tb[NL80211_ATTR_STA_FLAGS2]);
+			printf("\tflag_mask =\t0x%.8x\n"
+			       "\tflag_set =\t0x%.8x\n",
+			       sta_flags_upd->mask, sta_flags_upd->set);
+		} else
+			printf("\tno flags set\n");
+		break;
 	case NL80211_CMD_NEW_STATION:
 		mac_addr_n2a(macbuf, nla_data(tb[NL80211_ATTR_MAC]));
 		printf("new station %s\n", macbuf);
-- 
1.7.3.4

