Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:56850 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab3KRRCz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Nov 2013 12:02:55 -0500
Received: by mail-bk0-f47.google.com with SMTP id mx12so1004490bkb.34
        for <linux-wireless@vger.kernel.org>; Mon, 18 Nov 2013 09:02:53 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>
Subject: [PATCH 2/6] mac80211: fix connection polling
Date: Mon, 18 Nov 2013 19:02:42 +0200
Message-Id: <1384794166-10906-2-git-send-email-egrumbach@gmail.com> (sfid-20131118_180259_620134_4B5151A1)
In-Reply-To: <1384794166-10906-1-git-send-email-egrumbach@gmail.com>
References: <1384794166-10906-1-git-send-email-egrumbach@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Commit 392b9ff ("mac80211: change beacon/connection polling")
removed the IEEE80211_STA_BEACON_POLL flag.

However, it accidentally removed the setting of
IEEE80211_STA_CONNECTION_POLL, making the connection polling
completely useless (the flag is always clear, so the result
is never being checked). Fix it.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d7504ab..b3a3ce3 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1910,6 +1910,8 @@ static void ieee80211_mgd_probe_ap(struct ieee80211_sub_if_data *sdata,
 	if (ifmgd->flags & IEEE80211_STA_CONNECTION_POLL)
 		already = true;
 
+	ifmgd->flags |= IEEE80211_STA_CONNECTION_POLL;
+
 	mutex_unlock(&sdata->local->mtx);
 
 	if (already)
-- 
1.7.9.5

