Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58392 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab1AFViD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 16:38:03 -0500
Message-Id: <20110106213714.894284080@sipsolutions.net>
Date: Thu, 06 Jan 2011 22:36:44 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/4] mac80211: add missing docs for off-chan TX flag
References: <20110106213643.454994320@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The flag is IEEE80211_TX_CTL_TX_OFFCHAN and I had
added that in a previous patch but forgotten docs.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h |    4 ++++
 1 file changed, 4 insertions(+)

--- wireless-testing.orig/include/net/mac80211.h	2011-01-06 22:18:55.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2011-01-06 22:19:53.000000000 +0100
@@ -337,6 +337,10 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TX_CTL_LDPC: tells the driver to use LDPC for this frame
  * @IEEE80211_TX_CTL_STBC: Enables Space-Time Block Coding (STBC) for this
  *	frame and selects the maximum number of streams that it can use.
+ * @IEEE80211_TX_CTL_TX_OFFCHAN: Marks this packet to be transmitted on
+ *	the off-channel channel when a remain-on-channel offload is done
+ *	in hardware -- normal packets still flow and are expected to be
+ *	handled properly by the device.
  *
  * Note: If you have to add new flags to the enumeration, then don't
  *	 forget to update %IEEE80211_TX_TEMPORARY_FLAGS when necessary.


