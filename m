Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:37672 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933294AbZHVTK5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Aug 2009 15:10:57 -0400
Received: by ey-out-2122.google.com with SMTP id 22so376669eye.37
        for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2009 12:10:58 -0700 (PDT)
Message-ID: <4A9043E5.8070205@gmail.com>
Date: Sat, 22 Aug 2009 21:15:49 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] nl80211: jump to out_err upon unsupported iftype
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jump to out_err when the iftype is not supported.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 634496b..c6fc083 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1998,7 +1998,7 @@ static int nl80211_dump_mpath(struct sk_buff *skb,
 
 	if (netdev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT) {
 		err = -EOPNOTSUPP;
-		goto out;
+		goto out_err;
 	}
 
 	while (1) {
