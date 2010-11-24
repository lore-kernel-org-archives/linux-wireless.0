Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:30439 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751409Ab0KXFel (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 00:34:41 -0500
Received: from vs3017.wh2.ocn.ne.jp (125.206.180.250)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0553986879
	for <linux-wireless@vger.kernel.org>; Wed, 24 Nov 2010 14:34:39 +0900 (JST)
Subject: [PATCH v2] cfg80211: Add documentation for antenna ops
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 24 Nov 2010 14:34:41 +0900
Message-ID: <20101124053441.25150.71136.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Bruno Randolf <br1@einfach.org>
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

