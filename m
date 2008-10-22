Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41512 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbYJVSuA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 14:50:00 -0400
Subject: [PATCH v2] wireless: fix regdom passing semantics
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1224701263.30459.45.camel@johannes.berg> (sfid-20081022_204756_936331_248EAD4B)
References: <1224579720.5521.2.camel@johannes.berg>
	 <20081022113751.GD6190@tesla>  <1224701263.30459.45.camel@johannes.berg>
	 (sfid-20081022_204756_936331_248EAD4B)
Content-Type: text/plain
Date: Wed, 22 Oct 2008 20:49:54 +0200
Message-Id: <1224701394.30459.48.camel@johannes.berg> (sfid-20081022_205006_103676_AC2037B3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The regdom struct is given to the core, so it might as well
free it in error conditions, the current documentation for
regulatory_hint doesn't note that you need to free it on errors
anyway.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/nl80211.c |    5 +----
 net/wireless/reg.c     |    9 +++++----
 2 files changed, 6 insertions(+), 8 deletions(-)

--- everything.orig/net/wireless/nl80211.c	2008-10-21 10:36:13.000000000 +0200
+++ everything/net/wireless/nl80211.c	2008-10-21 10:41:13.000000000 +0200
@@ -1756,12 +1756,9 @@ static int nl80211_set_reg(struct sk_buf
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
--- everything.orig/net/wireless/reg.c	2008-10-21 10:38:59.000000000 +0200
+++ everything/net/wireless/reg.c	2008-10-21 10:41:13.000000000 +0200
@@ -606,7 +606,6 @@ int __regulatory_hint(struct wiphy *wiph
 	return r;
 }
 
-/* If rd is not NULL and if this call fails the caller must free it */
 int regulatory_hint(struct wiphy *wiphy, const char *alpha2,
 	struct ieee80211_regdomain *rd)
 {
@@ -691,6 +690,7 @@ void print_regdomain_info(const struct i
 	print_rd_rules(rd);
 }
 
+/* Takes ownership of rd only if it doesn't fail */
 static int __set_regdom(const struct ieee80211_regdomain *rd)
 {
 	/* Some basic sanity checks first */
@@ -752,16 +752,17 @@ static int __set_regdom(const struct iee
 
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


