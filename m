Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:28638 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752438Ab0LFDpj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Dec 2010 22:45:39 -0500
Received: from vs3007.wh2.ocn.ne.jp (125.206.180.235)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-0276967136
	for <linux-wireless@vger.kernel.org>; Mon,  6 Dec 2010 12:45:37 +0900 (JST)
Subject: [PATCH 2/3] nl80211: Export available antennas
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 06 Dec 2010 12:45:35 +0900
Message-ID: <20101206034535.11462.70791.stgit@localhost6.localdomain6>
In-Reply-To: <20101206034529.11462.48097.stgit@localhost6.localdomain6>
References: <20101206034529.11462.48097.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 include/linux/nl80211.h |    5 +++++
 net/wireless/nl80211.c  |    2 ++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 68fc25f..5f64fd6 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -833,6 +833,9 @@ enum nl80211_commands {
  *	the hardware should not be configured to receive on this antenna.
  *	For a more detailed descripton see @NL80211_ATTR_WIPHY_ANTENNA_TX.
  *
+ * @NL80211_ATTR_WIPHY_ANTENNA_AVAIL: Bitmap of antennas which are available for
+ *	configuration via the above parameters.
+ *
  * @NL80211_ATTR_MCAST_RATE: Multicast tx rate (in 100 kbps) for IBSS
  *
  * @NL80211_ATTR_OFFCHANNEL_TX_OK: For management frame TX, the frame may be
@@ -1017,6 +1020,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_OFFCHANNEL_TX_OK,
 
+	NL80211_ATTR_WIPHY_ANTENNA_AVAIL,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4854df9..1d49d75 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -555,6 +555,8 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 			NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_ANTENNA_TX, tx_ant);
 			NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_ANTENNA_RX, rx_ant);
 		}
+		NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_ANTENNA_AVAIL,
+			    dev->wiphy.available_antennas);
 	}
 
 	nl_modes = nla_nest_start(msg, NL80211_ATTR_SUPPORTED_IFTYPES);

