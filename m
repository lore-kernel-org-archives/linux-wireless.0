Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:43813 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030233Ab2ERMDW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2012 08:03:22 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 6/6] mac80211: reuse channels for channel context
Date: Fri, 18 May 2012 14:03:09 +0200
Message-ID: <1337342589-10617-7-git-send-email-michal.kazior@tieto.com> (sfid-20120518_140329_307722_FE5C3E17)
In-Reply-To: <1337342589-10617-1-git-send-email-michal.kazior@tieto.com>
References: <1337342589-10617-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reuse channels with compatible channel types. Some
channel types are compatible and can be used
concurrently.

Change-Id: I30665b42ea141ed63bba94be6fd2755c7e16589d
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/chan.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 030d44e..75549bc 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -162,6 +162,7 @@ ieee80211_find_channel_context(struct ieee80211_local *local,
 			       enum nl80211_channel_type channel_type)
 {
 	struct ieee80211_channel_context *ctx;
+	enum nl80211_channel_type compat_type;
 	int i;
 
 	if (WARN_ON(!channel))
@@ -169,10 +170,20 @@ ieee80211_find_channel_context(struct ieee80211_local *local,
 
 	for (i = 0; i < IEEE80211_MAX_CHANNEL_CONTEXTS; i++) {
 		ctx = &local->channel_contexts[i];
+		compat_type = ctx->channel_type;
+
 		if (ctx->channel != channel)
 			continue;
 		if (ctx->channel_type != channel_type)
 			continue;
+		if (!ieee80211_channel_types_are_compatible(ctx->channel_type,
+							    channel_type,
+							    &compat_type))
+			continue;
+		if (ctx->channel_type != compat_type) {
+			ctx->channel_type = compat_type;
+			drv_change_channel_type(local, ctx);
+		}
 
 		return ctx;
 	}
-- 
1.7.0.4

