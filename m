Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50899 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbYJXSeb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2008 14:34:31 -0400
Message-Id: <20081024183321.403860000@sipsolutions.net> (sfid-20081024_203435_218075_94ACBA26)
References: <20081024183219.735241000@sipsolutions.net>
Date: Fri, 24 Oct 2008 20:32:20 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: mcgrof@gmail.com, linux-wireless@vger.kernel.org
Subject: [PATCH 1/4] wireless: make regdom passing semantics simpler
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The regdom struct is given to the core, so it might as well
free it in error conditions.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 Documentation/networking/regulatory.txt |   13 +++----------
 include/net/wireless.h                  |    3 +--
 net/wireless/nl80211.c                  |    5 +----
 net/wireless/reg.c                      |    9 +++++----
 4 files changed, 10 insertions(+), 20 deletions(-)

--- everything.orig/net/wireless/nl80211.c	2008-10-23 09:38:51.000000000 +0200
+++ everything/net/wireless/nl80211.c	2008-10-23 09:41:05.000000000 +0200
@@ -1935,12 +1935,9 @@ static int nl80211_set_reg(struct sk_buf
 	mutex_lock(&cfg80211_drv_mutex);
 	r = set_regdom(rd);
 	mutex_unlock(&cfg80211_drv_mutex);
-	if (r)
-		goto bad_reg;
-
 	return r;
 
-bad_reg:
+ bad_reg:
 	kfree(rd);
 	return -EINVAL;
 }
--- everything.orig/net/wireless/reg.c	2008-10-23 09:38:52.000000000 +0200
+++ everything/net/wireless/reg.c	2008-10-23 09:41:05.000000000 +0200
@@ -605,7 +605,6 @@ int __regulatory_hint(struct wiphy *wiph
 	return r;
 }
 
-/* If rd is not NULL and if this call fails the caller must free it */
 int regulatory_hint(struct wiphy *wiphy, const char *alpha2,
 	struct ieee80211_regdomain *rd)
 {
@@ -690,6 +689,7 @@ void print_regdomain_info(const struct i
 	print_rd_rules(rd);
 }
 
+/* Takes ownership of rd only if it doesn't fail */
 static int __set_regdom(const struct ieee80211_regdomain *rd)
 {
 	/* Some basic sanity checks first */
@@ -750,16 +750,17 @@ static int __set_regdom(const struct iee
 
 /* Use this call to set the current regulatory domain. Conflicts with
  * multiple drivers can be ironed out later. Caller must've already
- * kmalloc'd the rd structure. If this calls fails you should kfree()
- * the passed rd. Caller must hold cfg80211_drv_mutex */
+ * kmalloc'd the rd structure. Caller must hold cfg80211_drv_mutex */
 int set_regdom(const struct ieee80211_regdomain *rd)
 {
 	int r;
 
 	/* Note that this doesn't update the wiphys, this is done below */
 	r = __set_regdom(rd);
-	if (r)
+	if (r) {
+		kfree(rd);
 		return r;
+	}
 
 	/* This would make this whole thing pointless */
 	BUG_ON(rd != cfg80211_regdomain);
--- everything.orig/include/net/wireless.h	2008-10-23 09:38:51.000000000 +0200
+++ everything/include/net/wireless.h	2008-10-23 09:41:05.000000000 +0200
@@ -358,8 +358,7 @@ ieee80211_get_channel(struct wiphy *wiph
  * for a regulatory domain structure for the respective country. If
  * a regulatory domain is build and passed you should set the alpha2
  * if possible, otherwise set it to the special value of "99" which tells
- * the wireless core it is unknown. If you pass a built regulatory domain
- * and we return non zero you are in charge of kfree()'ing the structure.
+ * the wireless core it is unknown.
  *
  * Returns -EALREADY if *a regulatory domain* has already been set. Note that
  * this could be by another driver. It is safe for drivers to continue if
--- everything.orig/Documentation/networking/regulatory.txt	2008-10-23 09:41:29.000000000 +0200
+++ everything/Documentation/networking/regulatory.txt	2008-10-23 09:41:54.000000000 +0200
@@ -167,7 +167,6 @@ struct ieee80211_regdomain mydriver_jp_r
 
 Then in some part of your code after your wiphy has been registered:
 
-	int r;
 	struct ieee80211_regdomain *rd;
 	int size_of_regd;
 	int num_rules = mydriver_jp_regdom.n_reg_rules;
@@ -178,17 +177,11 @@ Then in some part of your code after you
 
 	rd = kzalloc(size_of_regd, GFP_KERNEL);
 	if (!rd)
-	return -ENOMEM;
+		return -ENOMEM;
 
 	memcpy(rd, &mydriver_jp_regdom, sizeof(struct ieee80211_regdomain));
 
-	for (i=0; i < num_rules; i++) {
+	for (i=0; i < num_rules; i++)
 		memcpy(&rd->reg_rules[i], &mydriver_jp_regdom.reg_rules[i],
 			sizeof(struct ieee80211_reg_rule));
-	}
-	r = regulatory_hint(hw->wiphy, NULL, rd);
-	if (r) {
-		kfree(rd);
-		return r;
-	}
-
+	return regulatory_hint(hw->wiphy, NULL, rd);

-- 

