Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63386 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563Ab0GVL1p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 07:27:45 -0400
Date: Thu, 22 Jul 2010 13:26:50 +0200
From: Dan Carpenter <error27@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Benoit PAPILLAULT <benoit.papillault@free.fr>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch -next] wireless: remove unneeded variable from
	regulatory_hint_11d()
Message-ID: <20100722112650.GE17585@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The "rd" variable isn't needed any more since 4f366c5dabcb 
"wireless: only use alpha2 regulatory information from country IE"

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 48baf28..ec4e76f 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1492,7 +1492,6 @@ void regulatory_hint_11d(struct wiphy *wiphy,
 			 u8 *country_ie,
 			 u8 country_ie_len)
 {
-	struct ieee80211_regdomain *rd = NULL;
 	char alpha2[2];
 	enum environment_cap env = ENVIRON_ANY;
 	struct regulatory_request *request;
@@ -1529,7 +1528,7 @@ void regulatory_hint_11d(struct wiphy *wiphy,
 
 	request = kzalloc(sizeof(struct regulatory_request), GFP_KERNEL);
 	if (!request)
-		goto free_rd_out;
+		goto out;
 
 	request->wiphy_idx = get_wiphy_idx(wiphy);
 	request->alpha2[0] = alpha2[0];
@@ -1543,8 +1542,6 @@ void regulatory_hint_11d(struct wiphy *wiphy,
 
 	return;
 
-free_rd_out:
-	kfree(rd);
 out:
 	mutex_unlock(&reg_mutex);
 }
