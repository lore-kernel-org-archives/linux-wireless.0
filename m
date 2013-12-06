Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:46727 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab3LFEuj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 23:50:39 -0500
Message-ID: <52A15777.5000508@huawei.com> (sfid-20131206_055047_191951_1BB6BFF7)
Date: Fri, 6 Dec 2013 12:49:59 +0800
From: Wang Weidong <wangweidong1@huawei.com>
MIME-Version: 1.0
To: <johannes@sipsolutions.net>, <linville@tuxdriver.com>,
	David Miller <davem@davemloft.net>
CC: <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>
Subject: [PATCH] wireless: fix build warning of used uninitialized variable
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

nl80211.c: In function __cfg80211_wdev_from_attrs
nl80211.c:77: warning: wdev_id may be used uninitialized in this function

Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
---
 net/wireless/nl80211.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 138dc3b..6894229 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -74,7 +74,7 @@ __cfg80211_wdev_from_attrs(struct net *netns, struct nlattr **attrs)
 	struct wireless_dev *result = NULL;
 	bool have_ifidx = attrs[NL80211_ATTR_IFINDEX];
 	bool have_wdev_id = attrs[NL80211_ATTR_WDEV];
-	u64 wdev_id;
+	u64 wdev_id = 0;
 	int wiphy_idx = -1;
 	int ifidx = -1;
 
-- 
1.6.0.2


