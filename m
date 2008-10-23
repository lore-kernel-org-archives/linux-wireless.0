Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39372 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755705AbYJWGpd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2008 02:45:33 -0400
Subject: [PATCH] mac80211: fix two kernel-doc warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 23 Oct 2008 08:45:29 +0200
Message-Id: <1224744329.5865.15.camel@johannes.berg> (sfid-20081023_084603_268923_7F561D5E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

One parameter wasn't described and one I forgot to update when
renaming it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- everything.orig/include/net/mac80211.h	2008-10-23 08:43:41.000000000 +0200
+++ everything/include/net/mac80211.h	2008-10-23 08:44:28.000000000 +0200
@@ -291,7 +291,7 @@ enum mac80211_rate_control_flags {
  *
  * @idx: rate index to attempt to send with
  * @flags: rate control flags (&enum mac80211_rate_control_flags)
- * @limit: number of retries before fallback
+ * @count: number of tries in this rate before going to the next rate
  *
  * A value of -1 for @idx indicates an invalid rate and, if used
  * in an array of retry rates, that no more rates should be tried.
@@ -1903,6 +1903,8 @@ struct ieee80211_sta *ieee80211_find_sta
  * @short_preamble: whether mac80211 will request short-preamble transmission
  *	if the selected rate supports it
  * @max_rate_idx: user-requested maximum rate (not MCS for now)
+ * @skb: the skb that will be transmitted, the control information in it needs
+ *	to be filled in
  */
 struct ieee80211_tx_rate_control {
 	struct ieee80211_hw *hw;


