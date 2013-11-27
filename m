Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27961 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754146Ab3K0CbV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Nov 2013 21:31:21 -0500
Subject: [PATCH] WIFI: handle a neglected case in nl80211_new_interface()
From: Chao Bi <chao.bi@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Nov 2013 11:00:54 +0800
Message-ID: <1385521254.23222.8.camel@bichao> (sfid-20131127_033143_526457_BFC897B1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In nl80211_new_interface(), it calls rdev_add_virtual_intf() to create
a new interface, however, it only checks whether returned value is err
code, but doesn't check if returned value is NULL. The returned value
could be NULL, for example, memory allocation failed when creating a
new interface.

when get a NULL returned value,  nl80211_new_interface() is expected to
return but it actually runs down to access the NULL pointer, this could
lead to a panic.

Signed-off-by: Chao Bi <chao.bi@intel.com>
---
 net/wireless/nl80211.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a1eb210..27feeaf 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2512,7 +2512,7 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 	wdev = rdev_add_virtual_intf(rdev,
 				nla_data(info->attrs[NL80211_ATTR_IFNAME]),
 				type, err ? NULL : &flags, &params);
-	if (IS_ERR(wdev)) {
+	if (!wdev || IS_ERR(wdev)) {
 		nlmsg_free(msg);
 		return PTR_ERR(wdev);
 	}
-- 
1.7.9.5



