Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:5876 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078AbZIRQuJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2009 12:50:09 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John W Linville <linville@tuxdriver.com>
Subject: [RFC] nl80211: introduce NL80211_ATTR_SCAN_EXPIRE
Date: Fri, 18 Sep 2009 18:49:22 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200909181849.22302.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This attribute allows user-space to override or turn of the default
BSS expiration time for NL80211_CMD_GET_SCAN.

It also allows to set an expiration for NL80211_CMD_TRIGGER_SCAN. Setting
the expiration to 0 will clean the whole BSS list.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

---

Currently, I'm using the user-space AS-IS. Maybe I should do

  export = nla_get_u32(..) * HZ

or, if we want to specify this in ms:

  export = nla_get_u32(..) * HZ / 1000

???


A simple demo patch for iw that swaps behavior (expire all BSS at scan time,
never expire at dump time) is here:

 xx iw.orig/scan.c      2009-09-18 16:28:07.000000000 +0200
 xx iw/scan.c   2009-09-18 16:45:41.000000000 +0200
 xx -102,6 +102,8 @@ static int handle_scan(struct nl80211_st
         if (have_freqs)
                 nla_put_nested(msg, NL80211_ATTR_SCAN_FREQUENCIES, freqs);

 +       NLA_PUT_U32(msg, 83 /* NL80211_ATTR_SCAN_EXPIRE */, 0);
 +
         err = 0;
   nla_put_failure:
         nlmsg_free(ssids);
 xx -871,7 +873,10 @@ static int handle_scan_dump(struct nl802

         nl_cb_set(cb, NL_CB_VALID, NL_CB_CUSTOM, print_bss_handler,
                   &scan_params);
 +       NLA_PUT_U32(msg, 83 /* NL80211_ATTR_SCAN_EXPIRE */, 0);
         return 0;
 +nla_put_failure:
 +       return 2;
  }

 static int handle_scan_combined(struct nl80211_state *state,


Index: linux-wl/net/wireless/core.h
===================================================================
--- linux-wl.orig/net/wireless/core.h	2009-09-18 14:49:42.000000000 +0200
+++ linux-wl/net/wireless/core.h	2009-09-18 17:31:05.000000000 +0200
@@ -270,7 +270,9 @@ void ieee80211_set_bitrate_flags(struct 
 void wiphy_update_regulatory(struct wiphy *wiphy,
 			     enum nl80211_reg_initiator setby);
 
-void cfg80211_bss_expire(struct cfg80211_registered_device *dev);
+#define IEEE80211_SCAN_RESULT_EXPIRE	(15 * HZ)
+
+void cfg80211_bss_expire(struct cfg80211_registered_device *dev, int expire);
 void cfg80211_bss_age(struct cfg80211_registered_device *dev,
                       unsigned long age_secs);
 
Index: linux-wl/net/wireless/nl80211.c
===================================================================
--- linux-wl.orig/net/wireless/nl80211.c	2009-09-18 14:49:42.000000000 +0200
+++ linux-wl/net/wireless/nl80211.c	2009-09-18 17:36:04.000000000 +0200
@@ -138,6 +138,7 @@ static struct nla_policy nl80211_policy[
 	[NL80211_ATTR_CIPHER_SUITE_GROUP] = { .type = NLA_U32 },
 	[NL80211_ATTR_WPA_VERSIONS] = { .type = NLA_U32 },
 	[NL80211_ATTR_PID] = { .type = NLA_U32 },
+	[NL80211_ATTR_SCAN_EXPIRE] = { .type = NLA_U32 },
 };
 
 /* policy for the attributes */
@@ -2945,6 +2946,13 @@ static int nl80211_trigger_scan(struct s
 		goto out;
 	}
 
+	if (info->attrs[NL80211_ATTR_SCAN_EXPIRE]) {
+		u32 expire = nla_get_u32(info->attrs[NL80211_ATTR_SCAN_EXPIRE]);
+		spin_lock_bh(&rdev->bss_lock);
+		cfg80211_bss_expire(rdev, expire);
+		spin_unlock_bh(&rdev->bss_lock);
+	}
+
 	if (info->attrs[NL80211_ATTR_SCAN_FREQUENCIES]) {
 		n_channels = validate_scan_freqs(
 				info->attrs[NL80211_ATTR_SCAN_FREQUENCIES]);
@@ -3158,11 +3166,13 @@ static int nl80211_dump_scan(struct sk_b
 	int ifidx = cb->args[0];
 	int start = cb->args[1], idx = 0;
 	int err;
+	u32 expire = IEEE80211_SCAN_RESULT_EXPIRE;
+
+	err = nlmsg_parse(cb->nlh, GENL_HDRLEN + nl80211_fam.hdrsize,
+			  nl80211_fam.attrbuf, nl80211_fam.maxattr,
+			  nl80211_policy);
 
 	if (!ifidx) {
-		err = nlmsg_parse(cb->nlh, GENL_HDRLEN + nl80211_fam.hdrsize,
-				  nl80211_fam.attrbuf, nl80211_fam.maxattr,
-				  nl80211_policy);
 		if (err)
 			return err;
 
@@ -3187,9 +3197,20 @@ static int nl80211_dump_scan(struct sk_b
 
 	wdev = dev->ieee80211_ptr;
 
+	/*
+	 * If expire is set (the default), expire the BSS list before
+	 * returning values. However, user-space can set a different
+	 * expire time via NL80211_ATTR_SCAN_EXPIRE. It can also set
+	 * no expire-time at all, then we skip the expiration.
+	 */
+	if (!err && nl80211_fam.attrbuf[NL80211_ATTR_SCAN_EXPIRE])
+		expire =
+		nla_get_u32(nl80211_fam.attrbuf[NL80211_ATTR_SCAN_EXPIRE]);
+
 	wdev_lock(wdev);
 	spin_lock_bh(&rdev->bss_lock);
-	cfg80211_bss_expire(rdev);
+	if (expire)
+		cfg80211_bss_expire(rdev, expire);
 
 	list_for_each_entry(scan, &rdev->bss_list, list) {
 		if (++idx <= start)
Index: linux-wl/net/wireless/scan.c
===================================================================
--- linux-wl.orig/net/wireless/scan.c	2009-09-18 14:49:42.000000000 +0200
+++ linux-wl/net/wireless/scan.c	2009-09-18 17:32:08.000000000 +0200
@@ -16,8 +16,6 @@
 #include "nl80211.h"
 #include "wext-compat.h"
 
-#define IEEE80211_SCAN_RESULT_EXPIRE	(15 * HZ)
-
 void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak)
 {
 	struct cfg80211_scan_request *request;
@@ -121,7 +119,7 @@ void cfg80211_bss_age(struct cfg80211_re
 }
 
 /* must hold dev->bss_lock! */
-void cfg80211_bss_expire(struct cfg80211_registered_device *dev)
+void cfg80211_bss_expire(struct cfg80211_registered_device *dev, int expire)
 {
 	struct cfg80211_internal_bss *bss, *tmp;
 	bool expired = false;
@@ -129,7 +127,11 @@ void cfg80211_bss_expire(struct cfg80211
 	list_for_each_entry_safe(bss, tmp, &dev->bss_list, list) {
 		if (atomic_read(&bss->hold))
 			continue;
-		if (!time_after(jiffies, bss->ts + IEEE80211_SCAN_RESULT_EXPIRE))
+		/*
+		 * If expire==0, then expire all BSS from the list,
+		 * else only expire those that are older than expire.
+		 */
+		if (expire && !time_after(jiffies, bss->ts + expire))
 			continue;
 		list_del(&bss->list);
 		rb_erase(&bss->rbn, &dev->bss_tree);
@@ -970,9 +972,11 @@ static int ieee80211_scan_results(struct
 	char *current_ev = buf;
 	char *end_buf = buf + len;
 	struct cfg80211_internal_bss *bss;
+	u32 expire = IEEE80211_SCAN_RESULT_EXPIRE;
 
 	spin_lock_bh(&dev->bss_lock);
-	cfg80211_bss_expire(dev);
+	if (expire)
+		cfg80211_bss_expire(dev, expire);
 
 	list_for_each_entry(bss, &dev->bss_list, list) {
 		if (buf + len - current_ev <= IW_EV_ADDR_LEN) {
Index: linux-wl/include/linux/nl80211.h
===================================================================
--- linux-wl.orig/include/linux/nl80211.h	2009-09-18 15:10:53.000000000 +0200
+++ linux-wl/include/linux/nl80211.h	2009-09-18 15:11:44.000000000 +0200
@@ -481,6 +481,7 @@ enum nl80211_commands {
  * @NL80211_ATTR_SCAN_SSIDS: nested attribute with SSIDs, leave out for passive
  *	scanning and include a zero-length SSID (wildcard) for wildcard scan
  * @NL80211_ATTR_BSS: scan result BSS
+ * @NL80211_ATTR_SCAN: expire time for cached bss list
  *
  * @NL80211_ATTR_REG_INITIATOR: indicates who requested the regulatory domain
  * 	currently in effect. This could be any of the %NL80211_REGDOM_SET_BY_*
@@ -714,6 +715,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_PID,
 
+	NL80211_ATTR_SCAN_EXPIRE,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,

-- 
http://www.holgerschurig.de
