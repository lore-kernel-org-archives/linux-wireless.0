Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:48448 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030403AbbKECZ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2015 21:25:28 -0500
From: Wei Fang <fangwei1@huawei.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, Wei Fang <fangwei1@huawei.com>
Subject: [PATCH] nl80211: fix compiler warnning
Date: Thu, 5 Nov 2015 10:23:30 +0800
Message-ID: <1446690210-18761-1-git-send-email-fangwei1@huawei.com> (sfid-20151105_032531_410642_ADBC27B7)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the following warning:

net/wireless/nl80211.c: In function ‘__cfg80211_wdev_from_attrs’:
net/wireless/nl80211.c:80: warning: ‘wdev_id’ may be used uninitialized in this function

This can never happen because if have_wdev_id is true, wdev_id
will be set, and if false, the code using wdev_id is not reachable.
Set wdev_id to 0 just to silence the compiler warning.

Signed-off-by: Wei Fang <fangwei1@huawei.com>
---
 net/wireless/nl80211.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5d8748b..7ed3523 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -77,7 +77,7 @@ __cfg80211_wdev_from_attrs(struct net *netns, struct nlattr **attrs)
 	struct wireless_dev *result = NULL;
 	bool have_ifidx = attrs[NL80211_ATTR_IFINDEX];
 	bool have_wdev_id = attrs[NL80211_ATTR_WDEV];
-	u64 wdev_id;
+	u64 wdev_id = 0;
 	int wiphy_idx = -1;
 	int ifidx = -1;
 
-- 
1.7.1

