Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:53514 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758500AbaCSJEv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2014 05:04:51 -0400
Received: by mail-pa0-f41.google.com with SMTP id fa1so8698257pad.28
        for <linux-wireless@vger.kernel.org>; Wed, 19 Mar 2014 02:04:51 -0700 (PDT)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 3/3] cfg80211: slightly clean up of cfg80211_sme_connect()
Date: Wed, 19 Mar 2014 17:04:37 +0800
Message-Id: <2765d477f16c3ade4361cbbbc170f7343b433b23.1395219362.git.gamerh2o@gmail.com> (sfid-20140319_100458_518581_C7DF94BA)
In-Reply-To: <195ce75d7f8c2db484ccea7453147289e880c148.1395219362.git.gamerh2o@gmail.com>
References: <195ce75d7f8c2db484ccea7453147289e880c148.1395219362.git.gamerh2o@gmail.com>
In-Reply-To: <195ce75d7f8c2db484ccea7453147289e880c148.1395219362.git.gamerh2o@gmail.com>
References: <195ce75d7f8c2db484ccea7453147289e880c148.1395219362.git.gamerh2o@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wdev->ssid has already been set in cfg80211_connect() and is equal to
connect->ssid, so the assignment here doesn't hurt. Use connect->ssid
instead of wdev->ssid so it will be consistent with following ssid_len
assignment statement.

If bss is found in cfg80211_get_conn_bss(), wdev->conn->state is set
to CFG80211_CONN_AUTHENTICATE_NEXT in there. So it's not needed to set
it manually to CFG80211_CONN_AUTHENTICATE_NEXT if bss is found in that
function.

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 net/wireless/sme.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index acdcb4a8..c259aa6 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -467,7 +467,7 @@ static int cfg80211_sme_connect(struct wireless_dev *wdev,
 		wdev->conn->auto_auth = false;
 	}
 
-	wdev->conn->params.ssid = wdev->ssid;
+	wdev->conn->params.ssid = connect->ssid;
 	wdev->conn->params.ssid_len = connect->ssid_len;
 
 	/* see if we have the bss already */
@@ -480,7 +480,6 @@ static int cfg80211_sme_connect(struct wireless_dev *wdev,
 
 	/* we're good if we have a matching bss struct */
 	if (bss) {
-		wdev->conn->state = CFG80211_CONN_AUTHENTICATE_NEXT;
 		err = cfg80211_conn_do_work(wdev);
 		cfg80211_put_bss(wdev->wiphy, bss);
 	} else {
-- 
1.8.5.3

