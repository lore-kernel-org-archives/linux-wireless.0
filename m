Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:44708 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbaBFTBj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Feb 2014 14:01:39 -0500
Received: by mail-we0-f180.google.com with SMTP id u57so1633469wes.11
        for <linux-wireless@vger.kernel.org>; Thu, 06 Feb 2014 11:01:38 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Eytan Lifshitz <eytan.lifshitz@intel.com>
Subject: [PATCH] mac80211: fix memory leak
Date: Thu,  6 Feb 2014 21:01:32 +0200
Message-Id: <1391713292-7378-1-git-send-email-egrumbach@gmail.com> (sfid-20140206_200142_880830_89B2D3D9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eytan Lifshitz <eytan.lifshitz@intel.com>

In case ieee80211_prep_connection() fails to dereference
sdata->vif.chanctx_conf, the function returns and doesn't
free new_sta. fixed.

Signed-off-by: Eytan Lifshitz <eytan.lifshitz@intel.com>
---
 net/mac80211/mlme.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index b640cd6..da4b09e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3792,6 +3792,7 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 		chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 		if (WARN_ON(!chanctx_conf)) {
 			rcu_read_unlock();
+			sta_info_free(local, new_sta);
 			return -EINVAL;
 		}
 		rate_flags = ieee80211_chandef_rate_flags(&chanctx_conf->def);
-- 
1.7.9.5

