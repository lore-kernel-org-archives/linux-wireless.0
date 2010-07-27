Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:6187 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753608Ab0G0Jtd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 05:49:33 -0400
Received: from vs3007.wh2.ocn.ne.jp (125.206.180.235)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0554064172
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jul 2010 18:49:32 +0900 (JST)
Subject: [PATCH 1/2] iw: Sync nl80211.h with wireless-testing
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Jul 2010 18:49:32 +0900
Message-ID: <20100727094932.27300.10253.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding antenna attributes.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 nl80211.h |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/nl80211.h b/nl80211.h
index 2c87016..b9de53c 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -731,6 +731,20 @@ enum nl80211_commands {
  *      This is used in association with @NL80211_ATTR_WIPHY_TX_POWER_SETTING
  *      for non-automatic settings.
  *
+ * @NL80211_ATTR_WIPHY_ANTENNA_TX: Bitmap of allowed antennas for transmitting.
+ *	Each bit represents one antenna, starting with antenna 1 at the first
+ *	bit. If the bitmap is zero (0), the TX antenna follows RX diversity.
+ *	If multiple antennas are selected all selected antennas have to be used
+ *	for transmitting (801.11n multiple TX chains).
+ *	Drivers may reject configurations they cannot support.
+ *
+ * @NL80211_ATTR_WIPHY_ANTENNA_RX: Bitmap of allowed antennas for receiving.
+ *	Each bit represents one antenna, starting with antenna 1 at the first
+ *	bit. If multiple antennas are selected in the bitmap, 802.11n devices
+ *	should use multiple RX chains on these antennas, while non-802.11n
+ *	drivers should use antenna diversity between these antennas.
+ *	Drivers may reject configurations they cannot support.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -891,6 +905,9 @@ enum nl80211_attrs {
 	NL80211_ATTR_WIPHY_TX_POWER_SETTING,
 	NL80211_ATTR_WIPHY_TX_POWER_LEVEL,
 
+	NL80211_ATTR_WIPHY_ANTENNA_TX,
+	NL80211_ATTR_WIPHY_ANTENNA_RX,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,

