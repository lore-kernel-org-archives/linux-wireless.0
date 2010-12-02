Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:2223 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756133Ab0LBHXu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 02:23:50 -0500
Received: from vs3000.wh2.ocn.ne.jp (125.206.180.163)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-0535584628
	for <linux-wireless@vger.kernel.org>; Thu,  2 Dec 2010 16:23:49 +0900 (JST)
Subject: [PATCH] cfg80211: Add documentation for antenna ops
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: nbd@openwrt.org, mcgrof@gmail.com, linux-wireless@vger.kernel.org
Date: Thu, 02 Dec 2010 16:23:12 +0900
Message-ID: <20101202072312.6635.67167.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The last patch with the same title was for mac80211 ops, accidentally.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 include/net/cfg80211.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 49a7c53..6b2af7a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1154,6 +1154,13 @@ struct cfg80211_pmksa {
  * @mgmt_frame_register: Notify driver that a management frame type was
  *	registered. Note that this callback may not sleep, and cannot run
  *	concurrently with itself.
+ *
+ * @set_antenna: Set antenna configuration (tx_ant, rx_ant) on the device.
+ *	Parameters are bitmaps of allowed antennas to use for TX/RX. Drivers may
+ *	reject TX/RX mask combinations they cannot support by returning -EINVAL
+ *	(also see nl80211.h @NL80211_ATTR_WIPHY_ANTENNA_TX).
+ *
+ * @get_antenna: Get current antenna configuration from device (tx_ant, rx_ant).
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy);

