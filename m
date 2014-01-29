Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:59440 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825AbaA2HBW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 02:01:22 -0500
Received: by mail-ee0-f50.google.com with SMTP id d17so657426eek.37
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jan 2014 23:01:21 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/5] mac80211: fix possible memory leak on AP CSA failure
Date: Wed, 29 Jan 2014 07:56:18 +0100
Message-Id: <1390978581-13273-3-git-send-email-michal.kazior@tieto.com> (sfid-20140129_080148_267878_1A08EAAF)
In-Reply-To: <1390978581-13273-1-git-send-email-michal.kazior@tieto.com>
References: <1390978581-13273-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If CSA for AP interface failed and the interface
was not stopped afterwards another CSA request
would leak sdata->u.ap.next_beacon.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/cfg.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index b503f92..20d4ee6 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3018,12 +3018,13 @@ static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_AP:
 		err = ieee80211_assign_beacon(sdata, sdata->u.ap.next_beacon);
+		kfree(sdata->u.ap.next_beacon);
+		sdata->u.ap.next_beacon = NULL;
+
 		if (err < 0)
 			return;
 
 		changed |= err;
-		kfree(sdata->u.ap.next_beacon);
-		sdata->u.ap.next_beacon = NULL;
 		break;
 	case NL80211_IFTYPE_ADHOC:
 		err = ieee80211_ibss_finish_csa(sdata);
-- 
1.8.5.3

