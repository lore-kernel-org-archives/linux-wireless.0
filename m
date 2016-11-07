Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36830 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932294AbcKGO76 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Nov 2016 09:59:58 -0500
From: Benjamin Berg <benjamin@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, sw@simonwunderlich.de,
        Benjamin Berg <benjamin.berg@open-mesh.com>
Subject: [PATCH 8/8] Print frequency of radar events.
Date: Mon,  7 Nov 2016 15:59:43 +0100
Message-Id: <20161107145943.16761-9-benjamin@sipsolutions.net> (sfid-20161107_160002_275193_3256178B)
In-Reply-To: <20161107145943.16761-1-benjamin@sipsolutions.net>
References: <20161107145943.16761-1-benjamin@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Benjamin Berg <benjamin.berg@open-mesh.com>

Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Benjamin Berg <benjamin.berg@open-mesh.com>
---
 event.c | 48 +++++++++++++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 23 deletions(-)

diff --git a/event.c b/event.c
index 446debb..8014d73 100644
--- a/event.c
+++ b/event.c
@@ -584,30 +584,32 @@ static int print_event(struct nl_msg *msg, void *arg)
 				   nla_data(tb[NL80211_ATTR_VENDOR_DATA]),
 				   nla_len(tb[NL80211_ATTR_VENDOR_DATA]));
 		break;
-	case NL80211_CMD_RADAR_DETECT:
-		printf("radar event ");
-		if (tb[NL80211_ATTR_RADAR_EVENT]) {
-			switch (nla_get_u32(tb[NL80211_ATTR_RADAR_EVENT])) {
-				case NL80211_RADAR_DETECTED:
-					printf("(radar detected)");
-					break;
-				case NL80211_RADAR_CAC_FINISHED:
-					printf("(cac finished)");
-					break;
-				case NL80211_RADAR_CAC_ABORTED:
-					printf("(cac aborted)");
-					break;
-				case NL80211_RADAR_NOP_FINISHED:
-					printf("(nop finished)");
-					break;
-				default:
-					printf("(unknown)");
-					break;
-			};
-		} else {
-			printf("(unknown)");
+	case NL80211_CMD_RADAR_DETECT: {
+			enum nl80211_radar_event event_type;
+			uint32_t freq;
+
+			if (!tb[NL80211_ATTR_RADAR_EVENT] || !tb[NL80211_ATTR_WIPHY_FREQ])
+				printf("BAD radar event");
+			freq = nla_get_u32(tb[NL80211_ATTR_WIPHY_FREQ]);
+			event_type = nla_get_u32(tb[NL80211_ATTR_RADAR_EVENT]);
+
+			switch (event_type) {
+			case NL80211_RADAR_DETECTED:
+				printf("%d MHz: radar detected\n", freq);
+				break;
+			case NL80211_RADAR_CAC_FINISHED:
+				printf("%d MHz: CAC finished\n", freq);
+				break;
+			case NL80211_RADAR_CAC_ABORTED:
+				printf("%d MHz: CAC was aborted\n", freq);
+				break;
+			case NL80211_RADAR_NOP_FINISHED:
+				printf("%d MHz: NOP finished\n", freq);
+				break;
+			default:
+				printf("%d MHz: unknown radar event\n", freq);
+			}
 		}
-		printf("\n");
 		break;
 	case NL80211_CMD_DEL_WIPHY:
 		printf("delete wiphy\n");
-- 
2.10.2
