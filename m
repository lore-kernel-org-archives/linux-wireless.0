Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:8192 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755148Ab0LPC3r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 21:29:47 -0500
Received: from vs3003.wh2.ocn.ne.jp (125.206.180.231)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0924186584
	for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 11:29:45 +0900 (JST)
Subject: [PATCH 2/3] nl80211: Export available antennas
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: dhalperi@cs.washington.edu, linux-wireless@vger.kernel.org
Date: Thu, 16 Dec 2010 11:30:28 +0900
Message-ID: <20101216023028.24356.25352.stgit@localhost6.localdomain6>
In-Reply-To: <20101216023022.24356.22416.stgit@localhost6.localdomain6>
References: <20101216023022.24356.22416.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Export the information which antennas are available for configuration as TX or
RX antennas via nl80211.

Signed-off-by: Bruno Randolf <br1@einfach.org>

---

v3:	rebased and updated for separate RX and TX availablility
v2:	rebased
---
 include/linux/nl80211.h |    9 +++++++++
 net/wireless/nl80211.c  |    5 +++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 1cee56b..a6e1ec5 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -844,6 +844,12 @@ enum nl80211_commands {
  *	the hardware should not be configured to receive on this antenna.
  *	For a more detailed descripton see @NL80211_ATTR_WIPHY_ANTENNA_TX.
  *
+ * @NL80211_ATTR_WIPHY_ANTENNA_AVAIL_TX: Bitmap of antennas which are available
+ *	for configuration as TX antennas via the above parameters.
+ *
+ * @NL80211_ATTR_WIPHY_ANTENNA_AVAIL_RX: Bitmap of antennas which are available
+ *	for configuration as RX antennas via the above parameters.
+ *
  * @NL80211_ATTR_MCAST_RATE: Multicast tx rate (in 100 kbps) for IBSS
  *
  * @NL80211_ATTR_OFFCHANNEL_TX_OK: For management frame TX, the frame may be
@@ -1040,6 +1046,9 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_MAX_REMAIN_ON_CHANNEL_DURATION,
 
+	NL80211_ATTR_WIPHY_ANTENNA_AVAIL_TX,
+	NL80211_ATTR_WIPHY_ANTENNA_AVAIL_RX,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 087397b..ad3ca7d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -605,6 +605,11 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 	if (dev->wiphy.flags & WIPHY_FLAG_CONTROL_PORT_PROTOCOL)
 		NLA_PUT_FLAG(msg, NL80211_ATTR_CONTROL_PORT_ETHERTYPE);
 
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_ANTENNA_AVAIL_TX,
+		    dev->wiphy.available_antennas_tx);
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_ANTENNA_AVAIL_RX,
+		    dev->wiphy.available_antennas_rx);
+
 	if ((dev->wiphy.available_antennas_tx ||
 	     dev->wiphy.available_antennas_rx) && dev->ops->get_antenna) {
 		u32 tx_ant = 0, rx_ant = 0;

