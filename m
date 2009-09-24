Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:40707 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbZIXKVL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 06:21:11 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH, v2]: nl80211: report age of scan results
Date: Thu, 24 Sep 2009 12:21:01 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200909241221.01456.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Linux keeps scan results up to 15 seconds. This can be a problem for fast
moving clients: they get back stale data. But if the kernel reports the age
of the BSS items, then user-space can simply weed out old entries by itself.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

---

v2: renamed NL80211_BSS_AGE_MS to NL80211_BSS_SEEN_MS_AGO to underline that
    it's a relativene time

--- linux-wl.orig/include/linux/nl80211.h
+++ linux-wl/include/linux/nl80211.h
@@ -1277,6 +1277,7 @@
  * @NL80211_BSS_SIGNAL_UNSPEC: signal strength of the probe response/beacon
  *	in unspecified units, scaled to 0..100 (u8)
  * @NL80211_BSS_STATUS: status, if this BSS is "used"
+ * @NL80211_BSS_SEEN_MS_AGO: age of this BSS entry in ms
  * @__NL80211_BSS_AFTER_LAST: internal
  * @NL80211_BSS_MAX: highest BSS attribute
  */
@@ -1291,6 +1292,7 @@
 	NL80211_BSS_SIGNAL_MBM,
 	NL80211_BSS_SIGNAL_UNSPEC,
 	NL80211_BSS_STATUS,
+	NL80211_BSS_SEEN_MS_AGO,
 
 	/* keep last */
 	__NL80211_BSS_AFTER_LAST,
--- linux-wl.orig/net/wireless/nl80211.c
+++ linux-wl/net/wireless/nl80211.c
@@ -3105,6 +3105,8 @@
 		NLA_PUT_U16(msg, NL80211_BSS_BEACON_INTERVAL, res->beacon_interval);
 	NLA_PUT_U16(msg, NL80211_BSS_CAPABILITY, res->capability);
 	NLA_PUT_U32(msg, NL80211_BSS_FREQUENCY, res->channel->center_freq);
+	NLA_PUT_U32(msg, NL80211_BSS_SEEN_MS_AGO,
+		jiffies_to_msecs(jiffies - intbss->ts));
 
 	switch (rdev->wiphy.signal_type) {
 	case CFG80211_SIGNAL_TYPE_MBM:

-- 
http://www.holgerschurig.de
