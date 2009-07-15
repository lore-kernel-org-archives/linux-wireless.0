Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:52356 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbZGOICR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 04:02:17 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, kalle.valo@nokia.com,
	Niko Jokinen <ext-niko.k.jokinen@nokia.com>
Subject: [PATCH] nl80211: Memory leak fixed
Date: Wed, 15 Jul 2009 11:00:53 +0300
Message-Id: <1247644853-11638-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Niko Jokinen <ext-niko.k.jokinen@nokia.com>

Potential memory leak via msg pointer in nl80211_get_key() function.

Signed-off-by: Niko Jokinen <ext-niko.k.jokinen@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 net/wireless/nl80211.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 6dad3e7..9beaed8 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1215,7 +1215,7 @@ static int nl80211_get_key(struct sk_buff *skb, struct genl_info *info)
 
 	if (IS_ERR(hdr)) {
 		err = PTR_ERR(hdr);
-		goto out;
+		goto free_msg;
 	}
 
 	cookie.msg = msg;
@@ -1230,7 +1230,7 @@ static int nl80211_get_key(struct sk_buff *skb, struct genl_info *info)
 				&cookie, get_key_callback);
 
 	if (err)
-		goto out;
+		goto free_msg;
 
 	if (cookie.error)
 		goto nla_put_failure;
@@ -1241,6 +1241,7 @@ static int nl80211_get_key(struct sk_buff *skb, struct genl_info *info)
 
  nla_put_failure:
 	err = -ENOBUFS;
+ free_msg:
 	nlmsg_free(msg);
  out:
 	cfg80211_unlock_rdev(rdev);
-- 
1.5.6.5

