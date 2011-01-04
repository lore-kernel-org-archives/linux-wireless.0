Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38567 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab1ADMCf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 07:02:35 -0500
Subject: [PATCH] mac80211: add remain-on-channel docs
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Jan 2011 13:02:32 +0100
Message-ID: <1294142552.3511.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add documentation for the new callbacks that I
forgot in the patch adding the callbacks.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- wireless-testing.orig/include/net/mac80211.h	2011-01-04 12:58:16.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2011-01-04 13:01:20.000000000 +0100
@@ -1753,6 +1753,16 @@ enum ieee80211_ampdu_mlme_action {
  *	(also see nl80211.h @NL80211_ATTR_WIPHY_ANTENNA_TX).
  *
  * @get_antenna: Get current antenna configuration from device (tx_ant, rx_ant).
+ *
+ * @remain_on_channel: Starts an off-channel period on the given channel, must
+ *	call back to ieee80211_ready_on_channel() when on that channel. Note
+ *	that normal channel traffic is not stopped as this is intended for hw
+ *	offload. Frames to transmit on the off-channel channel are transmitted
+ *	normally except for the %IEEE80211_TX_CTL_TX_OFFCHAN flag. When the
+ *	duration (which will always be non-zero) expires, the driver must call
+ *	ieee80211_remain_on_channel_expired(). This callback may sleep.
+ * @cancel_remain_on_channel: Requests that an ongoing off-channel period is
+ *	aborted before it expires. This callback may sleep.
  */
 struct ieee80211_ops {
 	int (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);


