Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42240 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758986AbYJVSz7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 14:55:59 -0400
Subject: [PATCH] wireless: update regulatory sample code
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 22 Oct 2008 20:55:52 +0200
Message-Id: <1224701752.30459.53.camel@johannes.berg> (sfid-20081022_205621_814527_E767F34E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update the same code for the recent changes. I did this as a
separate patch to avoid removing a lot of sample code only
to add it back again in the next patch.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 Documentation/networking/regulatory.txt |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

--- everything.orig/Documentation/networking/regulatory.txt	2008-10-22 20:51:50.000000000 +0200
+++ everything/Documentation/networking/regulatory.txt	2008-10-22 20:54:12.000000000 +0200
@@ -131,7 +131,7 @@ are expected to do this during initializ
 
 	r = zd_reg2alpha2(mac->regdomain, alpha2);
 	if (!r)
-		regulatory_hint(hw->wiphy, alpha2, NULL);
+		regulatory_hint(alpha2);
 
 Example code - drivers providing a built in regulatory domain:
 --------------------------------------------------------------
@@ -178,17 +178,14 @@ Then in some part of your code after you
 
 	rd = kzalloc(size_of_regd, GFP_KERNEL);
 	if (!rd)
-	return -ENOMEM;
+		return -ENOMEM;
 
 	memcpy(rd, &mydriver_jp_regdom, sizeof(struct ieee80211_regdomain));
 
-	for (i=0; i < num_rules; i++) {
-		memcpy(&rd->reg_rules[i], &mydriver_jp_regdom.reg_rules[i],
-			sizeof(struct ieee80211_reg_rule));
-	}
-	r = regulatory_hint(hw->wiphy, NULL, rd);
-	if (r) {
-		kfree(rd);
-		return r;
-	}
+	for (i=0; i < num_rules; i++)
+		memcpy(&rd->reg_rules[i],
+		       &mydriver_jp_regdom.reg_rules[i],
+		       sizeof(struct ieee80211_reg_rule));
 
+	regulatory_struct_hint(rd, BIT(IEEE80211_BAND_2GHZ) |
+				   BIT(IEEE80211_BAND_5GHZ));


