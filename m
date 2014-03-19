Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35242 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965274AbaCSPDl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2014 11:03:41 -0400
Received: by mail-pa0-f47.google.com with SMTP id lj1so9016439pab.6
        for <linux-wireless@vger.kernel.org>; Wed, 19 Mar 2014 08:03:41 -0700 (PDT)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 3/3 v2] cfg80211: slightly clean up of cfg80211_sme_connect()
Date: Wed, 19 Mar 2014 23:02:21 +0800
Message-Id: <ab90c7d3201a2a7dac6deb52e15a1d67b7049f96.1395240451.git.gamerh2o@gmail.com> (sfid-20140319_160345_303515_EC19786B)
In-Reply-To: <1395239207.4142.25.camel@jlt4.sipsolutions.net>
References: <1395239207.4142.25.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wdev->ssid_len has already been set in cfg80211_connect() and is equal
to connect->ssid_len. Use wdev->ssid_len instead of connect->ssid_len
so it will be consistent with previous ssid assignment statement.

If bss is found in cfg80211_get_conn_bss(), wdev->conn->state is set
to CFG80211_CONN_AUTHENTICATE_NEXT in there. So it's not needed to set
it manually to CFG80211_CONN_AUTHENTICATE_NEXT if bss is found in that
function.

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---

v2: change the assignment of ssid_len, instead of ssid before.

 net/wireless/sme.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index acdcb4a8..998674f 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -468,7 +468,7 @@ static int cfg80211_sme_connect(struct wireless_dev *wdev,
 	}
 
 	wdev->conn->params.ssid = wdev->ssid;
-	wdev->conn->params.ssid_len = connect->ssid_len;
+	wdev->conn->params.ssid_len = wdev->ssid_len;
 
 	/* see if we have the bss already */
 	bss = cfg80211_get_conn_bss(wdev);
@@ -480,7 +480,6 @@ static int cfg80211_sme_connect(struct wireless_dev *wdev,
 
 	/* we're good if we have a matching bss struct */
 	if (bss) {
-		wdev->conn->state = CFG80211_CONN_AUTHENTICATE_NEXT;
 		err = cfg80211_conn_do_work(wdev);
 		cfg80211_put_bss(wdev->wiphy, bss);
 	} else {
-- 
1.8.5.3

