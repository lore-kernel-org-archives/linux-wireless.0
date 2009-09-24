Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:49092 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbZIXI4E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 04:56:04 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH]: nl80211: report age of scan results
Date: Thu, 24 Sep 2009 10:55:51 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200909241055.51604.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Linux keeps scan results up to 15 seconds. This can be a problem for fast
moving client: they get back stale data. But if the kernel reports the
age of some BSS, then user-space can simply weed out old entries.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

---

One question was if I should specify the age in ms, or if I should specify
an absolute time. In the end I thought age in ms is better suited.

If an absolute time would sent with every BSS item, then user-space would
need an additional call to time() to find out which BSS items are too old.
Now it can use the milliseconds directly.

The case there user-space wants an absolute time ("At what hour did I get
the last probe response from this AP?") seems to be a more theoretical
problem. But if info is wanted, *THEN* you can call time() and substract the
reported bss-item-age from it.


Index: linux-wl/include/linux/nl80211.h
===================================================================
--- linux-wl.orig/include/linux/nl80211.h	2009-09-24 09:19:03.000000000 +0200
+++ linux-wl/include/linux/nl80211.h	2009-09-24 09:19:42.000000000 +0200
@@ -1277,6 +1277,7 @@ enum nl80211_channel_type {
  * @NL80211_BSS_SIGNAL_UNSPEC: signal strength of the probe response/beacon
  *	in unspecified units, scaled to 0..100 (u8)
  * @NL80211_BSS_STATUS: status, if this BSS is "used"
+ * @NL80211_BSS_AGE_MS: age of this BSS entry in ms
  * @__NL80211_BSS_AFTER_LAST: internal
  * @NL80211_BSS_MAX: highest BSS attribute
  */
@@ -1291,6 +1292,7 @@ enum nl80211_bss {
 	NL80211_BSS_SIGNAL_MBM,
 	NL80211_BSS_SIGNAL_UNSPEC,
 	NL80211_BSS_STATUS,
+	NL80211_BSS_AGE_MS,
 
 	/* keep last */
 	__NL80211_BSS_AFTER_LAST,
Index: linux-wl/net/wireless/nl80211.c
===================================================================
--- linux-wl.orig/net/wireless/nl80211.c	2009-09-24 09:19:03.000000000 +0200
+++ linux-wl/net/wireless/nl80211.c	2009-09-24 09:37:40.000000000 +0200
@@ -3105,6 +3105,7 @@ static int nl80211_send_bss(struct sk_bu
 		NLA_PUT_U16(msg, NL80211_BSS_BEACON_INTERVAL, res->beacon_interval);
 	NLA_PUT_U16(msg, NL80211_BSS_CAPABILITY, res->capability);
 	NLA_PUT_U32(msg, NL80211_BSS_FREQUENCY, res->channel->center_freq);
+	NLA_PUT_U32(msg, NL80211_BSS_AGE_MS, jiffies_to_msecs(jiffies - intbss->ts));
 
 	switch (rdev->wiphy.signal_type) {
 	case CFG80211_SIGNAL_TYPE_MBM:

-- 
http://www.holgerschurig.de
