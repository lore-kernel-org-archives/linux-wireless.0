Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37190 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab3AaFbr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 00:31:47 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] iw:  Print beacon-loss-event string.
Date: Wed, 30 Jan 2013 21:31:29 -0800
Message-Id: <1359610289-4578-1-git-send-email-greearb@candelatech.com> (sfid-20130131_063151_387238_C974953B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

There are now three possible threshold events.  The old
code assumed only above/below RSSI, and printed out 'low'
for beacon-loss-event.

Fix that, and do so with a switch statement so the compiler
can warn if the enum is further expanded w/out updating this
code.

Shorten 'connection quality monitor' to CQM to keep total string
relatively short.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 6f7027f... cb80bf8... M	event.c
 event.c |   21 +++++++++++++++++----
 1 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/event.c b/event.c
index 6f7027f..cb80bf8 100644
--- a/event.c
+++ b/event.c
@@ -110,7 +110,7 @@ static void parse_cqm_event(struct nlattr **attrs)
 	struct nlattr *cqm[NL80211_ATTR_CQM_MAX + 1];
 	struct nlattr *cqm_attr = attrs[NL80211_ATTR_CQM];
 
-	printf("connection quality monitor event: ");
+	printf("CQM event: ");
 
 	if (!cqm_attr ||
 	    nla_parse_nested(cqm, NL80211_ATTR_CQM_MAX, cqm_attr, cqm_policy)) {
@@ -120,11 +120,24 @@ static void parse_cqm_event(struct nlattr **attrs)
 
 	if (cqm[NL80211_ATTR_CQM_RSSI_THRESHOLD_EVENT]) {
 		enum nl80211_cqm_rssi_threshold_event rssi_event;
+                bool found_one = false;
 		rssi_event = nla_get_u32(cqm[NL80211_ATTR_CQM_RSSI_THRESHOLD_EVENT]);
-		if (rssi_event == NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH)
-			printf("RSSI went above threshold\n");
-		else
+		switch(rssi_event) {
+                case NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH:
+                        printf("RSSI went above threshold\n");
+                        found_one = true;
+                        break;
+                case NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW:
 			printf("RSSI went below threshold\n");
+                        found_one = true;
+                        break;
+                case NL80211_CQM_RSSI_BEACON_LOSS_EVENT:
+			printf("Beacon loss detected\n");
+                        found_one = true;
+                        break;
+                }/* switch */
+                if (!found_one)
+                        printf("Unknown event type: %i\n", rssi_event);
 	} else if (cqm[NL80211_ATTR_CQM_PKT_LOSS_EVENT] &&
 		   attrs[NL80211_ATTR_MAC]) {
 		uint32_t frames;
-- 
1.7.3.4

