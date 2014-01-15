Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:53330 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbaAOMQp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 07:16:45 -0500
Received: by mail-ee0-f43.google.com with SMTP id c41so820611eek.16
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jan 2014 04:16:44 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 1/9] mac80211: fix possible memory leak on AP CSA failure
Date: Wed, 15 Jan 2014 13:04:46 +0100
Message-Id: <1389787494-7361-2-git-send-email-michal.kazior@tieto.com> (sfid-20140115_131649_916537_EA527EE4)
In-Reply-To: <1389787494-7361-1-git-send-email-michal.kazior@tieto.com>
References: <1389787494-7361-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If CSA for AP interface failed and the interface
was not stopped afterwards another CSA request
would leak sdata->u.ap.next_beacon.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/cfg.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 543b18f..8c78572 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2987,6 +2987,21 @@ cfg80211_beacon_dup(struct cfg80211_beacon_data *beacon)
 	return new_beacon;
 }
 
+static int ieee80211_ap_finish_csa(struct ieee80211_sub_if_data *sdata)
+{
+	int err;
+
+	err = ieee80211_assign_beacon(sdata, sdata->u.ap.next_beacon);
+	kfree(sdata->u.ap.next_beacon);
+	sdata->u.ap.next_beacon = NULL;
+
+	if (err < 0)
+		return err;
+
+	ieee80211_bss_info_change_notify(sdata, err);
+	return 0;
+}
+
 void ieee80211_csa_finalize_work(struct work_struct *work)
 {
 	struct ieee80211_sub_if_data *sdata =
@@ -3020,15 +3035,9 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 	sdata->vif.csa_active = false;
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_AP:
-		err = ieee80211_assign_beacon(sdata, sdata->u.ap.next_beacon);
+		err = ieee80211_ap_finish_csa(sdata);
 		if (err < 0)
 			goto unlock;
-
-		changed |= err;
-		kfree(sdata->u.ap.next_beacon);
-		sdata->u.ap.next_beacon = NULL;
-
-		ieee80211_bss_info_change_notify(sdata, err);
 		break;
 	case NL80211_IFTYPE_ADHOC:
 		ieee80211_ibss_finish_csa(sdata);
-- 
1.8.4.rc3

