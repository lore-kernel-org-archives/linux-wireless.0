Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:56725 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757198Ab1LNMdg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 07:33:36 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Alexander Simon <an.alexsimon@googlemail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] mac80211: free skb on error path of ieee80211_ibss_join()
Date: Wed, 14 Dec 2011 13:33:30 +0100
Message-Id: <1323866010-10079-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20111214_133340_911249_60DB3C23)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Our new return also created a memleak. The skb should be freed before
returning an error.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
 net/mac80211/ibss.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 0fc9752..fe0e91e 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -995,6 +995,7 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 		if (!ieee80211_set_channel_type(sdata->local, sdata,
 					       params->channel_type)) {
 			mutex_unlock(&sdata->u.ibss.mtx);
+			kfree_skb(skb);
 			return -EINVAL;
 		}
 	}
-- 
1.7.7.3

