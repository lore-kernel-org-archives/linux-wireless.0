Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:61196 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933338AbaDINfz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 09:35:55 -0400
Received: by mail-ee0-f45.google.com with SMTP id d17so1885015eek.18
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 06:35:53 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, luca@coelho.fi,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v4 03/13] mac80211: prevent chanctx overcommit
Date: Wed,  9 Apr 2014 15:29:24 +0200
Message-Id: <1397050174-26121-4-git-send-email-michal.kazior@tieto.com> (sfid-20140409_153654_433749_61CEB77C)
In-Reply-To: <1397050174-26121-1-git-send-email-michal.kazior@tieto.com>
References: <1396262371-6466-1-git-send-email-michal.kazior@tieto.com>
 <1397050174-26121-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not allocate more channel contexts than a
driver is capable for currently matching interface
combination.

This allows the ieee80211_vif_reserve_chanctx() to
act as a guard against breaking interface
combinations.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/chan.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 57b8ab1..fcb2cd8 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -9,6 +9,25 @@
 #include "ieee80211_i.h"
 #include "driver-ops.h"
 
+static int ieee80211_num_chanctx(struct ieee80211_local *local)
+{
+	struct ieee80211_chanctx *ctx;
+	int num = 0;
+
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	list_for_each_entry(ctx, &local->chanctx_list, list)
+		num++;
+
+	return num;
+}
+
+static bool ieee80211_can_create_new_chanctx(struct ieee80211_local *local)
+{
+	lockdep_assert_held(&local->chanctx_mtx);
+	return ieee80211_num_chanctx(local) < ieee80211_max_num_channels(local);
+}
+
 static enum nl80211_chan_width ieee80211_get_sta_bw(struct ieee80211_sta *sta)
 {
 	switch (sta->bandwidth) {
@@ -751,13 +770,16 @@ int ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
 			 * context, reserve our current context
 			 */
 			new_ctx = curr_ctx;
-		} else {
+		} else if (ieee80211_can_create_new_chanctx(local)) {
 			/* create a new context and reserve it */
 			new_ctx = ieee80211_new_chanctx(local, chandef, mode);
 			if (IS_ERR(new_ctx)) {
 				ret = PTR_ERR(new_ctx);
 				goto out;
 			}
+		} else {
+			ret = -EBUSY;
+			goto out;
 		}
 	}
 
-- 
1.8.5.3

