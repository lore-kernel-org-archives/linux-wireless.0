Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:53219 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbbFKTyO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 15:54:14 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] iw:  print beacon-loss and wiphy delete events.
Date: Thu, 11 Jun 2015 15:54:11 -0400
Message-Id: <1434052451-19501-1-git-send-email-greearb@candelatech.com> (sfid-20150611_215432_176435_D841E0FF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This is nicer than messages about unknown events.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 event.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/event.c b/event.c
index b87a076..2c9694d 100644
--- a/event.c
+++ b/event.c
@@ -140,15 +140,22 @@ static void parse_cqm_event(struct nlattr **attrs)
 
 		if (!found_one)
 			printf("Unknown event type: %i\n", rssi_event);
-	} else if (cqm[NL80211_ATTR_CQM_PKT_LOSS_EVENT] &&
-		   attrs[NL80211_ATTR_MAC]) {
-		uint32_t frames;
-		char buf[3*6];
-
-		frames = nla_get_u32(cqm[NL80211_ATTR_CQM_PKT_LOSS_EVENT]);
-		mac_addr_n2a(buf, nla_data(attrs[NL80211_ATTR_MAC]));
-		printf("peer %s didn't ACK %d packets\n", buf, frames);
-	} else
+	} else if (cqm[NL80211_ATTR_CQM_PKT_LOSS_EVENT]) {
+		if (attrs[NL80211_ATTR_MAC]) {
+			uint32_t frames;
+			char buf[3*6];
+
+			frames = nla_get_u32(cqm[NL80211_ATTR_CQM_PKT_LOSS_EVENT]);
+			mac_addr_n2a(buf, nla_data(attrs[NL80211_ATTR_MAC]));
+			printf("peer %s didn't ACK %d packets\n", buf, frames);
+		}
+		else {
+			printf("PKT-LOSS-EVENT did not have MAC attribute!\n");
+		}
+	} else if (cqm[NL80211_ATTR_CQM_BEACON_LOSS_EVENT]) {
+		printf("beacon loss\n");
+	}
+	else
 		printf("unknown event\n");
 }
 
@@ -615,6 +622,9 @@ static int print_event(struct nl_msg *msg, void *arg)
 	case NL80211_CMD_DEL_INTERFACE:
 		printf("delete interface\n");
 		break;
+	case NL80211_CMD_DEL_WIPHY:
+		printf("delete wiphy\n");
+		break;
 	default:
 		printf("unknown event %d (%s)\n",
 		       gnlh->cmd, command_name(gnlh->cmd));
-- 
1.9.3

