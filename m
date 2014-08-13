Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:49291 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698AbaHMNLZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Aug 2014 09:11:25 -0400
From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: linux-wireless@vger.kernel.org
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [PATCH] event: Handle NEW_WIPHY/DEL_WIPHY events properly
Date: Wed, 13 Aug 2014 16:10:13 +0300
Message-Id: <1407935413-19600-1-git-send-email-tomasz.bursztyka@linux.intel.com> (sfid-20140813_151128_106201_AD1DBE10)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A NEW_WIPHY event can be either a new device event or a renaming event
thus precising it in the output. A proper differenciation would require
iw to dump all the existing wiphy devices first to be able to know when
NEW_WIPHY is a newly created device or just a rename, but that's out of
the scope of event.c
Besides that, DEL_WIPHY is a known event, thus handling it as it should.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 event.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/event.c b/event.c
index 6775eb2..4dab241 100644
--- a/event.c
+++ b/event.c
@@ -310,7 +310,10 @@ static int print_event(struct nl_msg *msg, void *arg)
 
 	switch (gnlh->cmd) {
 	case NL80211_CMD_NEW_WIPHY:
-		printf("renamed to %s\n", nla_get_string(tb[NL80211_ATTR_WIPHY_NAME]));
+		printf("new or renamed device: %s\n", nla_get_string(tb[NL80211_ATTR_WIPHY_NAME]));
+		break;
+	case NL80211_CMD_DEL_WIPHY:
+		printf("%s deleted\n", nla_get_string(tb[NL80211_ATTR_WIPHY_NAME]));
 		break;
 	case NL80211_CMD_TRIGGER_SCAN:
 		printf("scan started\n");
-- 
1.8.5.5

