Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:38549 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295AbbKYN7c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2015 08:59:32 -0500
Received: by wmec201 with SMTP id c201so71307218wme.1
        for <linux-wireless@vger.kernel.org>; Wed, 25 Nov 2015 05:59:31 -0800 (PST)
From: Sven Eckelmann <sven@open-mesh.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Julian Calaby <julian.calaby@gmail.com>,
	Sven Eckelmann <sven@open-mesh.com>
Subject: [PATCH v3 3/4] iw: use get_cf1 and struct chanmode for ocb
Date: Wed, 25 Nov 2015 14:59:17 +0100
Message-Id: <1448459959-23641-3-git-send-email-sven@open-mesh.com> (sfid-20151125_145935_867994_19E65E29)
In-Reply-To: <1448459959-23641-1-git-send-email-sven@open-mesh.com>
References: <1448459959-23641-1-git-send-email-sven@open-mesh.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The struct chanmode and the function get_cf1 is already used by ibss and
mesh. Also use it for ocb to make it consistent for for all join functions.

Signed-off-by: Sven Eckelmann <sven@open-mesh.com>
---
v3:
 * split patch into two different patches (0001/0002) as request by
   Julian Calaby <julian.calaby@gmail.com>
 * change join_ocb to also use get_cf1
 * move NOHT to the last entry in the mesh/ibss join usage texts as
   requested by Julian Calaby <julian.calaby@gmail.com>
v2:
 * rebase from v4.3-ish version to current master

 ocb.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/ocb.c b/ocb.c
index 767eb82..bcf0474 100644
--- a/ocb.c
+++ b/ocb.c
@@ -13,14 +13,16 @@ static int join_ocb(struct nl80211_state *state,
 	unsigned long freq;
 	char *end;
 	unsigned int i;
-	static const struct {
-		const char *name;
-		unsigned int width;
-	} *chanmode_selected, chanmode[] = {
+	const struct chanmode *chanmode_selected = NULL;
+	static const struct chanmode chanmode[] = {
 		{ .name = "5MHz",
-		  .width = NL80211_CHAN_WIDTH_5	},
+		  .width = NL80211_CHAN_WIDTH_5,
+		  .freq1_diff = 0,
+		  .chantype = -1 },
 		{ .name = "10MHz",
-		  .width = NL80211_CHAN_WIDTH_10 },
+		  .width = NL80211_CHAN_WIDTH_10,
+		  .freq1_diff = 0,
+		  .chantype = -1 },
 	};
 
 	if (argc < 2)
@@ -45,7 +47,8 @@ static int join_ocb(struct nl80211_state *state,
 	if (chanmode_selected) {
 		NLA_PUT_U32(msg, NL80211_ATTR_CHANNEL_WIDTH,
 			    chanmode_selected->width);
-		NLA_PUT_U32(msg, NL80211_ATTR_CENTER_FREQ1, freq);
+		NLA_PUT_U32(msg, NL80211_ATTR_CENTER_FREQ1,
+			    get_cf1(chanmode_selected, freq));
 
 		argv++;
 		argc--;
-- 
2.6.2

