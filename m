Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f175.google.com ([209.85.216.175]:55260 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbbA3Jmy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 04:42:54 -0500
Received: by mail-qc0-f175.google.com with SMTP id c9so19629009qcz.6
        for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2015 01:42:53 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] iw: print human readable radar events
Date: Fri, 30 Jan 2015 10:42:44 +0100
Message-Id: <1422610964-23252-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20150130_104258_683029_0D1F5AB2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 event.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/event.c b/event.c
index c175c66..71ab7f7 100644
--- a/event.c
+++ b/event.c
@@ -565,6 +565,31 @@ static int print_event(struct nl_msg *msg, void *arg)
 				   nla_data(tb[NL80211_ATTR_VENDOR_DATA]),
 				   nla_len(tb[NL80211_ATTR_VENDOR_DATA]));
 		break;
+	case NL80211_CMD_RADAR_DETECT:
+		printf("radar event ");
+		if (tb[NL80211_ATTR_RADAR_EVENT]) {
+			switch (nla_get_u32(tb[NL80211_ATTR_RADAR_EVENT])) {
+				case NL80211_RADAR_DETECTED:
+					printf("(radar detected)");
+					break;
+				case NL80211_RADAR_CAC_FINISHED:
+					printf("(cac finished)");
+					break;
+				case NL80211_RADAR_CAC_ABORTED:
+					printf("(cac aborted)");
+					break;
+				case NL80211_RADAR_NOP_FINISHED:
+					printf("(nop finished)");
+					break;
+				default:
+					printf("(unknown)");
+					break;
+			};
+		} else {
+			printf("(unknown)");
+		}
+		printf("\n");
+		break;
 	default:
 		printf("unknown event %d (%s)\n",
 		       gnlh->cmd, command_name(gnlh->cmd));
-- 
1.8.4.5

