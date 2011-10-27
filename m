Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50668 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab1J0MpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Oct 2011 08:45:12 -0400
Subject: [PATCH] cfg80211: annotate cfg80211_inform_bss
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Samuel Ortiz <samuel@sortiz.org>,
	Bing Zhao <bzhao@marvell.com>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	Dan Williams <dcbw@redhat.com>,
	Arend Van Spriel <arend@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Oct 2011 14:45:02 +0200
Message-ID: <1319719502.3944.5.camel@jlt3.sipsolutions.net> (sfid-20111027_144516_718621_80550823)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This function returns a referenced BSS struct
(or NULL), annotate with __must_check. It seems
that a lot of drivers get this completely wrong
and leak all BSS structs as a result.

Reported-by: Adam Mikuta <Adam.Mikuta@tieto.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
CC lots of driver maintainers who need to fix this bug.

 include/net/cfg80211.h |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/include/net/cfg80211.h	2011-10-27 14:05:17.000000000 +0200
+++ b/include/net/cfg80211.h	2011-10-27 14:42:51.000000000 +0200
@@ -2651,8 +2651,10 @@ void cfg80211_sched_scan_stopped(struct
  *
  * This informs cfg80211 that BSS information was found and
  * the BSS should be updated/added.
+ *
+ * NOTE: Returns a referenced struct, must be released with cfg80211_put_bss()!
  */
-struct cfg80211_bss*
+struct cfg80211_bss * __must_check
 cfg80211_inform_bss_frame(struct wiphy *wiphy,
 			  struct ieee80211_channel *channel,
 			  struct ieee80211_mgmt *mgmt, size_t len,
@@ -2674,8 +2676,10 @@ cfg80211_inform_bss_frame(struct wiphy *
  *
  * This informs cfg80211 that BSS information was found and
  * the BSS should be updated/added.
+ *
+ * NOTE: Returns a referenced struct, must be released with cfg80211_put_bss()!
  */
-struct cfg80211_bss*
+struct cfg80211_bss * __must_check
 cfg80211_inform_bss(struct wiphy *wiphy,
 		    struct ieee80211_channel *channel,
 		    const u8 *bssid,


