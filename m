Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4520 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965395AbXHGVGF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2007 17:06:05 -0400
Received: from ra.tuxdriver.com (ra.tuxdriver.com [127.0.0.1])
	by ra.tuxdriver.com (8.14.0/8.13.7) with ESMTP id l77L5rdd001563
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 7 Aug 2007 17:05:58 -0400
Received: (from uucp@localhost)
	by ra.tuxdriver.com (8.14.0/8.14.0/Submit) with UUCP id l77KjDCA001299
	for linux-wireless@vger.kernel.org; Tue, 7 Aug 2007 16:45:13 -0400
Received: from linville-t43.mobile (localhost.localdomain [127.0.0.1])
	by linville-t43.mobile (8.14.1/8.13.8) with ESMTP id l77KXFGd018348
	for <linux-wireless@vger.kernel.org>; Tue, 7 Aug 2007 16:33:15 -0400
Received: (from linville@localhost)
	by linville-t43.mobile (8.14.1/8.14.1/Submit) id l77KXFdq018347
	for linux-wireless@vger.kernel.org; Tue, 7 Aug 2007 16:33:15 -0400
Date: Tue, 7 Aug 2007 16:33:15 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: probe for hidden SSIDs in pre-auth scan
Message-ID: <20070807203315.GG3330@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: John W. Linville <linville@tuxdriver.com>

Probe for hidden SSIDs if initiating pre-authentication scan and SSID
is set for STA interface.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
The ternary conditionals are a bit ugly.  I guess I could recode it
with temp vars initialized before calling ieee80211_sta_start_scan.

Any other complaints?

 net/mac80211/ieee80211_sta.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 007dd08..9f467cc 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -3217,7 +3217,10 @@ static int ieee80211_sta_config_auth(struct net_device *dev,
 		return 0;
 	} else {
 		if (ifsta->state != IEEE80211_AUTHENTICATE) {
-			ieee80211_sta_start_scan(dev, NULL, 0);
+			ieee80211_sta_start_scan(dev, ifsta->auto_ssid_sel ?
+							NULL : ifsta->ssid,
+						 ifsta->auto_ssid_sel ?
+							0 : ifsta->ssid_len);
 			ifsta->state = IEEE80211_AUTHENTICATE;
 			set_bit(IEEE80211_STA_REQ_AUTH, &ifsta->request);
 		} else
-- 
John W. Linville
linville@tuxdriver.com
