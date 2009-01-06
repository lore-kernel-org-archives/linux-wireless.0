Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:63607 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbZAFPWJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 10:22:09 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2009 07:22:09 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [RFC 1/4] cfg80211: add a wiphy specific regulatory domain cache
Date: Tue, 6 Jan 2009 07:21:59 -0800
Message-ID: <1231255322-13100-2-git-send-email-lrodriguez@atheros.com> (sfid-20090106_162214_503727_D9525B3E)
In-Reply-To: <1231255322-13100-1-git-send-email-lrodriguez@atheros.com>
References: <1231255322-13100-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows drivers to keep around cache their own regulatory domain
structure queried from CRDA. This allows drivers to deal with conflicts
through their reg_notifier(). A driver can now also choose to always stick
to their queried regulatory domain if so desired.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/net/wireless.h |    6 ++++++
 net/wireless/reg.c     |   26 ++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/include/net/wireless.h b/include/net/wireless.h
index aedefa5..f57f12f 100644
--- a/include/net/wireless.h
+++ b/include/net/wireless.h
@@ -187,6 +187,10 @@ struct ieee80211_supported_band {
  * 	we will disregard the first regulatory hint (when the
  * 	initiator is %REGDOM_SET_BY_CORE).
  * @reg_notifier: the driver's regulatory notification callback
+ * @regd: the driver's regulatory domain, if one was requested via
+ * 	the regulatory_hint() API. This can be used by the driver
+ *	on the reg_notifier() if it chooses to ignore future
+ *	regulatory domain changes caused by other drivers.
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -213,6 +217,8 @@ struct wiphy {
 
 	/* fields below are read-only, assigned by cfg80211 */
 
+	const struct ieee80211_regdomain *regd;
+
 	/* the item in /sys/class/ieee80211/ points to this,
 	 * you need use set_wiphy_dev() (see below) */
 	struct device dev;
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 4f87753..fe6fb18 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1235,6 +1235,30 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 	}
 
 	if (!last_request->intersect) {
+
+		struct ieee80211_regdomain *regd;
+
+		if (last_request->initiator != REGDOM_SET_BY_DRIVER) {
+			reset_regdomains();
+			cfg80211_regdomain = rd;
+			return 0;
+		}
+
+		/* For a driver hint, lets copy the regulatory domain the
+		 * driver wanted to the wiphy to deal with conflicts or allow
+		 * the driver itself to decide whether or not it wants to ignore
+		 * specific user updates through the reg_notifier() */
+
+		BUG_ON(last_request->wiphy->regd);
+
+		regd = kzalloc(sizeof(rd), GFP_KERNEL);
+		if (!regd)
+			return -ENOMEM;
+
+		memcpy(regd, rd, sizeof(rd));
+
+		last_request->wiphy->regd = regd;
+
 		reset_regdomains();
 		cfg80211_regdomain = rd;
 		return 0;
@@ -1333,6 +1357,8 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 /* Caller must hold cfg80211_drv_mutex */
 void reg_device_remove(struct wiphy *wiphy)
 {
+	if (wiphy->regd)
+		kfree(wiphy->regd);
 	if (!last_request || !last_request->wiphy)
 		return;
 	if (last_request->wiphy != wiphy)
-- 
1.6.1.rc3.51.g5832d

