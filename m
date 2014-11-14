Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:54238 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161473AbaKNRnk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2014 12:43:40 -0500
Received: by mail-wi0-f181.google.com with SMTP id n3so3465045wiv.2
        for <linux-wireless@vger.kernel.org>; Fri, 14 Nov 2014 09:43:38 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] cfg80211: protect fools returning NULL in add_virtual_intf
Date: Fri, 14 Nov 2014 18:43:28 +0100
Message-Id: <1415987008-3557-1-git-send-email-zajec5@gmail.com> (sfid-20141114_184344_156615_F79F5890)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Callback add_virtual_intf is supposed to return ERR_PTR and trying to
return NULL results in some "Unable to handle kernel paging request",
etc. As it may be complicated to debug & trace, let's catch it (WARN).

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 net/wireless/nl80211.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 1a31736..eeb96c1 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2641,7 +2641,10 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 	wdev = rdev_add_virtual_intf(rdev,
 				nla_data(info->attrs[NL80211_ATTR_IFNAME]),
 				type, err ? NULL : &flags, &params);
-	if (IS_ERR(wdev)) {
+	if (WARN_ON(!wdev)) {
+		nlmsg_free(msg);
+		return -EPROTO;
+	} else if (IS_ERR(wdev)) {
 		nlmsg_free(msg);
 		return PTR_ERR(wdev);
 	}
-- 
1.8.4.5

