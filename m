Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:7246 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759030Ab0LNCUH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 21:20:07 -0500
Received: from vs3009.wh2.ocn.ne.jp (125.206.180.237)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-082463204
	for <linux-wireless@vger.kernel.org>; Tue, 14 Dec 2010 11:20:05 +0900 (JST)
Subject: [PATCH 1/2] nl80211: Export available antennas
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 14 Dec 2010 11:20:18 +0900
Message-ID: <20101214022018.2343.8216.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Bruno Randolf <br1@einfach.org>

---

v2:	rebased
---
 include/linux/nl80211.h |    5 +++++
 net/wireless/nl80211.c  |    2 ++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index b8fa25d..63b603c 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -841,6 +841,9 @@ enum nl80211_commands {
  *	the hardware should not be configured to receive on this antenna.
  *	For a more detailed descripton see @NL80211_ATTR_WIPHY_ANTENNA_TX.
  *
+ * @NL80211_ATTR_WIPHY_ANTENNA_AVAIL: Bitmap of antennas which are available for
+ *	configuration via the above parameters.
+ *
  * @NL80211_ATTR_MCAST_RATE: Multicast tx rate (in 100 kbps) for IBSS
  *
  * @NL80211_ATTR_OFFCHANNEL_TX_OK: For management frame TX, the frame may be
@@ -1035,6 +1038,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_KEY_DEFAULT_TYPES,
 
+	NL80211_ATTR_WIPHY_ANTENNA_AVAIL,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 53f0443..87eae15 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -613,6 +613,8 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 			NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_ANTENNA_TX, tx_ant);
 			NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_ANTENNA_RX, rx_ant);
 		}
+		NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_ANTENNA_AVAIL,
+			    dev->wiphy.available_antennas);
 	}
 
 	nl_modes = nla_nest_start(msg, NL80211_ATTR_SUPPORTED_IFTYPES);

