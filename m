Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:46454 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756930Ab2FUMDo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 08:03:44 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Kazior Michal <Michal.Kazior@tieto.com>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC v2 7/7] mac80211: reuse channels for channel context
Date: Thu, 21 Jun 2012 14:03:36 +0200
Message-ID: <1340280216-18807-8-git-send-email-michal.kazior@tieto.com> (sfid-20120621_140350_607892_44CD1453)
In-Reply-To: <1340280216-18807-1-git-send-email-michal.kazior@tieto.com>
References: <1340280216-18807-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kazior Michal <Michal.Kazior@tieto.com>

Reuse channels with compatible channel types. Some
channel types are compatible and can be used
concurrently.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/chan.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 63b7cb7..97be454 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -167,6 +167,7 @@ ieee80211_find_chanctx(struct ieee80211_local *local,
 		       enum ieee80211_chanctx_mode mode)
 {
 	struct ieee80211_chanctx *ctx;
+	enum nl80211_channel_type compat_type;
 
 	if (mode == IEEE80211_CHANCTX_EXCLUSIVE)
 		return NULL;
@@ -174,12 +175,22 @@ ieee80211_find_chanctx(struct ieee80211_local *local,
 		return NULL;
 
 	list_for_each_entry(ctx, &local->chanctx_list, list) {
+		compat_type = ctx->conf.channel_type;
+
 		if (ctx->conf.mode == IEEE80211_CHANCTX_EXCLUSIVE)
 			continue;
 		if (ctx->conf.channel != channel)
 			continue;
 		if (ctx->conf.channel_type != channel_type)
 			continue;
+		if (!ieee80211_channel_types_are_compatible(ctx->conf.channel_type,
+							    channel_type,
+							    &compat_type))
+			continue;
+		if (ctx->conf.channel_type != compat_type) {
+			ctx->conf.channel_type = compat_type;
+			drv_change_chantype(local, ctx);
+		}
 
 		return ctx;
 	}
-- 
1.7.0.4

