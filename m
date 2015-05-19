Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:35978 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413AbbESMhR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 08:37:17 -0400
Received: by wizk4 with SMTP id k4so115742701wiz.1
        for <linux-wireless@vger.kernel.org>; Tue, 19 May 2015 05:37:16 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/2] mac80211: guard against invalid ptr deref
Date: Tue, 19 May 2015 14:37:01 +0200
Message-Id: <1432039021-29666-2-git-send-email-michal.kazior@tieto.com> (sfid-20150519_143722_532835_CFFBA0F8)
In-Reply-To: <1432039021-29666-1-git-send-email-michal.kazior@tieto.com>
References: <1432039021-29666-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Without "cfg80211: ignore netif running state when
changing iftype" it was possible for mac80211 to
crash the system due to an unexpected (and
incorrect) flow.

Even with cfg80211 being fixed it still makes
sense to add a sanity check just in case.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/cfg.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 3469bbdc891c..74cc789f9c8e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1395,6 +1395,12 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 		vlansdata = IEEE80211_DEV_TO_SUB_IF(params->vlan);
 
 		if (params->vlan->ieee80211_ptr->use_4addr) {
+			if (vlansdata->vif.type != NL80211_IFTYPE_AP_VLAN) {
+				WARN_ON(1);
+				err = -EINVAL;
+				goto out_err;
+			}
+
 			if (vlansdata->u.vlan.sta) {
 				err = -EBUSY;
 				goto out_err;
-- 
2.1.4

