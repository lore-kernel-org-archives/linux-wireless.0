Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50770 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab2LTQcB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2012 11:32:01 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] wireless: remove WARN_ON in __cfg80211_mlme_disassoc
Date: Thu, 20 Dec 2012 11:20:50 -0500
Message-Id: <1356020450-9915-1-git-send-email-linville@tuxdriver.com> (sfid-20121220_173205_878204_BCFB1698)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>

It seems like all this WARN_ON does is generate useless bug reports...?

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/wireless/mlme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 5e8123e..a2e1415 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -514,7 +514,7 @@ static int __cfg80211_mlme_disassoc(struct cfg80211_registered_device *rdev,
 	if (wdev->sme_state != CFG80211_SME_CONNECTED)
 		return -ENOTCONN;
 
-	if (WARN_ON(!wdev->current_bss))
+	if (!wdev->current_bss)
 		return -ENOTCONN;
 
 	memset(&req, 0, sizeof(req));
-- 
1.7.11.7

