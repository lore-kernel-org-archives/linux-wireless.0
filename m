Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:45317 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751955Ab0KXDE5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 22:04:57 -0500
Received: from vs3005.wh2.ocn.ne.jp (125.206.180.233)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-0273547894
	for <linux-wireless@vger.kernel.org>; Wed, 24 Nov 2010 12:04:55 +0900 (JST)
Subject: [PATCH] cfg80211: Add documentation for antenna ops
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 24 Nov 2010 12:04:57 +0900
Message-ID: <20101124030457.19018.33023.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


---
 include/net/mac80211.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 5b0fff2..08e4db6 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1745,6 +1745,13 @@ enum ieee80211_ampdu_mlme_action {
  *	completion of the channel switch.
  *
  * @napi_poll: Poll Rx queue for incoming data frames.
+ *
+ * @set_antenna: Set antenna configuration (tx_ant, rx_ant) on the device.
+ *	Parameters are bitmaps of allowed antennas to use for TX/RX. Drivers may
+ *	reject TX/RX mask combinations they cannot support by returning -EINVAL
+ *	(also see nl80211.h @NL80211_ATTR_WIPHY_ANTENNA_TX).
+ *
+ * @get_antenna: Get current antenna configuration from device (tx_ant, rx_ant).
  */
 struct ieee80211_ops {
 	int (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);

