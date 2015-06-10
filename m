Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:41187 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbbFJWSR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 18:18:17 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] iw:  Use ifname if available, print new/del/stop events.
Date: Wed, 10 Jun 2015 18:17:55 -0400
Message-Id: <1433974675-19225-1-git-send-email-greearb@candelatech.com> (sfid-20150611_001821_222392_6E13E742)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

If the kernel sends the IFNAME in the netlink message, then
use it to save the call to map ifindex to name (and
potentially fix races, especially when kernel is
busy deleting an interface.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 event.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/event.c b/event.c
index 929854b..b87a076 100644
--- a/event.c
+++ b/event.c
@@ -317,15 +317,22 @@ static int print_event(struct nl_msg *msg, void *arg)
 	nla_parse(tb, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
 		  genlmsg_attrlen(gnlh, 0), NULL);
 
-	if (tb[NL80211_ATTR_IFINDEX] && tb[NL80211_ATTR_WIPHY]) {
+	ifname[0] = 0;
+	if (tb[NL80211_ATTR_IFNAME]) {
+		memset(ifname, 0, sizeof(ifname));
+		strncpy(ifname, nla_data(tb[NL80211_ATTR_IFNAME]), IFNAMSIZ);
+	}
+	else if (tb[NL80211_ATTR_IFINDEX]) {
 		if_indextoname(nla_get_u32(tb[NL80211_ATTR_IFINDEX]), ifname);
+	}
+
+	if (ifname[0] && tb[NL80211_ATTR_WIPHY]) {
 		printf("%s (phy #%d): ", ifname, nla_get_u32(tb[NL80211_ATTR_WIPHY]));
 	} else if (tb[NL80211_ATTR_WDEV] && tb[NL80211_ATTR_WIPHY]) {
 		printf("wdev 0x%llx (phy #%d): ",
 			(unsigned long long)nla_get_u64(tb[NL80211_ATTR_WDEV]),
 			nla_get_u32(tb[NL80211_ATTR_WIPHY]));
-	} else if (tb[NL80211_ATTR_IFINDEX]) {
-		if_indextoname(nla_get_u32(tb[NL80211_ATTR_IFINDEX]), ifname);
+	} else if (ifname[0]) {
 		printf("%s: ", ifname);
 	} else if (tb[NL80211_ATTR_WDEV]) {
 		printf("wdev 0x%llx: ", (unsigned long long)nla_get_u64(tb[NL80211_ATTR_WDEV]));
@@ -599,6 +606,15 @@ static int print_event(struct nl_msg *msg, void *arg)
 		}
 		printf("\n");
 		break;
+	case NL80211_CMD_STOP_AP:
+		printf("stop AP\n");
+		break;
+	case NL80211_CMD_NEW_INTERFACE:
+		printf("new interface\n");
+		break;
+	case NL80211_CMD_DEL_INTERFACE:
+		printf("delete interface\n");
+		break;
 	default:
 		printf("unknown event %d (%s)\n",
 		       gnlh->cmd, command_name(gnlh->cmd));
-- 
1.9.3

