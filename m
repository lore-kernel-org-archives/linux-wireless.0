Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50548 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab0JEOTo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 10:19:44 -0400
Subject: [PATCH] nl80211: fix remain-on-channel documentation
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Oct 2010 16:19:42 +0200
Message-ID: <1286288382.3641.12.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The documentation for NL80211_CMD_REMAIN_ON_CHANNEL
isn't accurate, an interface index is required by
the command. Update it accordingly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/nl80211.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- wireless-testing.orig/include/linux/nl80211.h	2010-10-05 15:00:30.000000000 +0200
+++ wireless-testing/include/linux/nl80211.h	2010-10-05 15:00:49.000000000 +0200
@@ -315,8 +315,8 @@
  *	channel for the specified amount of time. This can be used to do
  *	off-channel operations like transmit a Public Action frame and wait for
  *	a response while being associated to an AP on another channel.
- *	%NL80211_ATTR_WIPHY or %NL80211_ATTR_IFINDEX is used to specify which
- *	radio is used. %NL80211_ATTR_WIPHY_FREQ is used to specify the
+ *	%NL80211_ATTR_IFINDEX is used to specify which interface (and thus
+ *	radio) is used. %NL80211_ATTR_WIPHY_FREQ is used to specify the
  *	frequency for the operation and %NL80211_ATTR_WIPHY_CHANNEL_TYPE may be
  *	optionally used to specify additional channel parameters.
  *	%NL80211_ATTR_DURATION is used to specify the duration in milliseconds


