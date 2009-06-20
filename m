Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.wellnetcz.com ([212.24.148.102]:48817 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbZFTKbR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Jun 2009 06:31:17 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] Wireless: nl80211, fix lock imbalance
Date: Sat, 20 Jun 2009 12:31:11 +0200
Message-Id: <1245493871-28817-1-git-send-email-jirislaby@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't forget to unlock cfg80211_mutex in one fail path of
nl80211_set_wiphy.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 net/wireless/nl80211.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2416856..a62a190 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -447,6 +447,7 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 
 	rdev = __cfg80211_drv_from_info(info);
 	if (IS_ERR(rdev)) {
+		mutex_unlock(&cfg80211_mutex);
 		result = PTR_ERR(rdev);
 		goto unlock;
 	}
-- 
1.6.3.2

