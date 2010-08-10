Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44116 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586Ab0HJHvF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Aug 2010 03:51:05 -0400
Message-Id: <20100810074700.762364520@sipsolutions.net>
Date: Tue, 10 Aug 2010 09:46:42 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 5/5] cfg80211: check if WEP is available for shared key auth
References: <20100810074637.034583799@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When shared key auth is requested, cfg80211
should verify that the device is capable of
WEP crypto which is required.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- wireless-testing.orig/net/wireless/nl80211.c	2010-08-08 11:32:20.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2010-08-08 11:32:28.000000000 +0200
@@ -3604,6 +3604,21 @@ static int nl80211_authenticate(struct s
 	if (err)
 		goto unlock_rtnl;
 
+	if (key.idx >= 0) {
+		int i;
+		bool ok = false;
+		for (i = 0; i < rdev->wiphy.n_cipher_suites; i++) {
+			if (key.p.cipher == rdev->wiphy.cipher_suites[i]) {
+				ok = true;
+				break;
+			}
+		}
+		if (!ok) {
+			err = -EINVAL;
+			goto out;
+		}
+	}
+
 	if (!rdev->ops->auth) {
 		err = -EOPNOTSUPP;
 		goto out;


