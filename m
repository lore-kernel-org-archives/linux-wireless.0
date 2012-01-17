Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:56941 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751255Ab2AQKTq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 05:19:46 -0500
Received: by lahc1 with SMTP id c1so1417518lah.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 Jan 2012 02:19:44 -0800 (PST)
From: Pontus Fuchs <pontus.fuchs@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Remove dummy STA on deauth
Date: Tue, 17 Jan 2012 11:19:37 +0100
Message-Id: <1326795577-29650-1-git-send-email-pontus.fuchs@gmail.com> (sfid-20120117_111950_717206_DA4AE268)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Under certain conditions a dummy STA entry could be left in the
station list. This causes subsequent connection attempts to fail.

Logs look like this:

authenticate with 00:23:69:aa:dd:7b (try 1)
authenticated
failed to insert Dummy STA entry for the AP (error -17)
deauthenticating from 00:23:69:aa:dd:7b by local choice (reason=2)

Fix this by making sure to remove the dummy STA on deauth.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
---

The problem was introduced by the following commit added in v3.1:
mac80211: fix race condition between assoc_done and first EAP packet

This problem is fixed in the recent patch series from 
Johannes Berg: [PATCH 0/8] more station handling refactoring

If you need a smaller fix this might fit you.

 net/mac80211/mlme.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index ecb4c84..8bd8d4d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2751,6 +2751,7 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_work *wk;
+	struct sta_info *dummy;
 	u8 bssid[ETH_ALEN];
 	bool assoc_bss = false;
 
@@ -2810,6 +2811,11 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 	if (assoc_bss)
 		sta_info_flush(sdata->local, sdata);
 
+	/* Make sure to remove dummy STA if it's there */
+	dummy = sta_info_get_bss_rx(sdata, req->bss->bssid);
+	if (dummy)
+		sta_info_destroy_addr(sdata, req->bss->bssid);
+
 	mutex_lock(&sdata->local->mtx);
 	ieee80211_recalc_idle(sdata->local);
 	mutex_unlock(&sdata->local->mtx);
-- 
1.7.5.4

