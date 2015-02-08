Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:32860 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbbBHKgT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Feb 2015 05:36:19 -0500
Received: by mail-wi0-f181.google.com with SMTP id fb4so11141659wid.2
        for <linux-wireless@vger.kernel.org>; Sun, 08 Feb 2015 02:36:18 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: clear sdata->radar_required
Date: Sun,  8 Feb 2015 12:36:07 +0200
Message-Id: <1423391767-1185-1-git-send-email-eliad@wizery.com> (sfid-20150208_113622_728248_299988A9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If ieee80211_vif_use_channel() fails, we have to clear
sdata->radar_required (which we might have just set).

Failing to do it results in stale radar_required field
which prevents starting new scan requests.

Reported-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/chan.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 35b11e1..f3a8708 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -1508,6 +1508,8 @@ static void __ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
 	if (ieee80211_chanctx_refcount(local, ctx) == 0)
 		ieee80211_free_chanctx(local, ctx);
 
+	sdata->radar_required = 0;
+
 	/* Unreserving may ready an in-place reservation. */
 	if (use_reserved_switch)
 		ieee80211_vif_use_reserved_switch(local);
@@ -1566,6 +1568,9 @@ int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
 	ieee80211_recalc_smps_chanctx(local, ctx);
 	ieee80211_recalc_radar_chanctx(local, ctx);
  out:
+	if (ret)
+		sdata->radar_required = 0;
+
 	mutex_unlock(&local->chanctx_mtx);
 	return ret;
 }
-- 
1.8.5.2.229.g4448466.dirty

