Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:37730 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbaATOZj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 09:25:39 -0500
Received: by mail-ee0-f44.google.com with SMTP id c13so3454395eek.31
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jan 2014 06:25:38 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/7] mac80211: fix possible memory leak on AP CSA failure
Date: Mon, 20 Jan 2014 15:21:04 +0100
Message-Id: <1390227670-19030-2-git-send-email-michal.kazior@tieto.com> (sfid-20140120_152543_342213_F9F85BDD)
In-Reply-To: <1390227670-19030-1-git-send-email-michal.kazior@tieto.com>
References: <1390227670-19030-1-git-send-email-michal.kazior@tieto.com>
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
index 65dac7f..62bf6c4 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2988,6 +2988,21 @@ cfg80211_beacon_dup(struct cfg80211_beacon_data *beacon)
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
 void ieee80211_csa_finish(struct ieee80211_vif *vif)
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
@@ -3019,15 +3034,9 @@ static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 	sdata->vif.csa_active = false;
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_AP:
-		err = ieee80211_assign_beacon(sdata, sdata->u.ap.next_beacon);
+		err = ieee80211_ap_finish_csa(sdata);
 		if (err < 0)
 			return;
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

