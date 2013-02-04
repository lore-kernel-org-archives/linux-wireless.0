Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:25944 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001Ab3BDLx0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 06:53:26 -0500
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 1/2] wireless: expand per-station byte counters to 64bit
Date: Mon, 4 Feb 2013 13:53:11 +0200
Message-ID: <1359978792-7121-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130204_125330_118178_E755F29A)
In-Reply-To: <1359978792-7121-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1359978792-7121-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In per-station statistics, present 32bit counters are too small
for practical purposes - with gigabit speeds, it get overlapped
every few seconds.

Expand counters in the struct station_info to be 64-bit.
Driver can still fill only 32-bit and indicate in @filled
only bits like STATION_INFO_[TR]X_BYTES; in case driver provides
full 64-bit counter, it should also set in @filled
bit STATION_INFO_[TR]RX_BYTES64

Netlink sends both 32-bit and 64-bit counters, if present, to not break
user space.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 include/net/cfg80211.h       |   12 ++++++++----
 include/uapi/linux/nl80211.h |    4 ++++
 net/wireless/nl80211.c       |   10 +++++++++-
 3 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 36e076e..bcb6b70 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -672,8 +672,10 @@ struct station_parameters {
  * @STATION_INFO_SIGNAL: @signal filled
  * @STATION_INFO_TX_BITRATE: @txrate fields are filled
  *  (tx_bitrate, tx_bitrate_flags and tx_bitrate_mcs)
- * @STATION_INFO_RX_PACKETS: @rx_packets filled
- * @STATION_INFO_TX_PACKETS: @tx_packets filled
+ * @STATION_INFO_RX_PACKETS: @rx_packets filled with 32-bit value
+ * @STATION_INFO_TX_PACKETS: @tx_packets filled with 32-bit value
+ * @STATION_INFO_RX_PACKETS64: @rx_packets filled with 64-bit value
+ * @STATION_INFO_TX_PACKETS64: @tx_packets filled with 64-bit value
  * @STATION_INFO_TX_RETRIES: @tx_retries filled
  * @STATION_INFO_TX_FAILED: @tx_failed filled
  * @STATION_INFO_RX_DROP_MISC: @rx_dropped_misc filled
@@ -714,6 +716,8 @@ enum station_info_flags {
 	STATION_INFO_LOCAL_PM		= 1<<21,
 	STATION_INFO_PEER_PM		= 1<<22,
 	STATION_INFO_NONPEER_PM		= 1<<23,
+	STATION_INFO_RX_BYTES64		= 1<<24,
+	STATION_INFO_TX_BYTES64		= 1<<25,
 };
 
 /**
@@ -835,8 +839,8 @@ struct station_info {
 	u32 filled;
 	u32 connected_time;
 	u32 inactive_time;
-	u32 rx_bytes;
-	u32 tx_bytes;
+	u64 rx_bytes;
+	u64 tx_bytes;
 	u16 llid;
 	u16 plid;
 	u8 plink_state;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 5b7dbc1..5c7d54c 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1851,6 +1851,8 @@ enum nl80211_sta_bss_param {
  * @NL80211_STA_INFO_INACTIVE_TIME: time since last activity (u32, msecs)
  * @NL80211_STA_INFO_RX_BYTES: total received bytes (u32, from this station)
  * @NL80211_STA_INFO_TX_BYTES: total transmitted bytes (u32, to this station)
+ * @NL80211_STA_INFO_RX_BYTES64: total received bytes (u64, from this station)
+ * @NL80211_STA_INFO_TX_BYTES64: total transmitted bytes (u64, to this station)
  * @NL80211_STA_INFO_SIGNAL: signal strength of last received PPDU (u8, dBm)
  * @NL80211_STA_INFO_TX_BITRATE: current unicast tx rate, nested attribute
  * 	containing info as possible, see &enum nl80211_rate_info
@@ -1903,6 +1905,8 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_LOCAL_PM,
 	NL80211_STA_INFO_PEER_PM,
 	NL80211_STA_INFO_NONPEER_PM,
+	NL80211_STA_INFO_RX_BYTES64,
+	NL80211_STA_INFO_TX_BYTES64,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b5978ab..b3a9c8e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3059,10 +3059,18 @@ static int nl80211_send_station(struct sk_buff *msg, u32 portid, u32 seq,
 		goto nla_put_failure;
 	if ((sinfo->filled & STATION_INFO_RX_BYTES) &&
 	    nla_put_u32(msg, NL80211_STA_INFO_RX_BYTES,
-			sinfo->rx_bytes))
+			(u32)sinfo->rx_bytes))
 		goto nla_put_failure;
 	if ((sinfo->filled & STATION_INFO_TX_BYTES) &&
 	    nla_put_u32(msg, NL80211_STA_INFO_TX_BYTES,
+			(u32)sinfo->tx_bytes))
+		goto nla_put_failure;
+	if ((sinfo->filled & STATION_INFO_RX_BYTES64) &&
+	    nla_put_u64(msg, NL80211_STA_INFO_RX_BYTES64,
+			sinfo->rx_bytes))
+		goto nla_put_failure;
+	if ((sinfo->filled & STATION_INFO_TX_BYTES64) &&
+	    nla_put_u32(msg, NL80211_STA_INFO_TX_BYTES64,
 			sinfo->tx_bytes))
 		goto nla_put_failure;
 	if ((sinfo->filled & STATION_INFO_LLID) &&
-- 
1.7.10.4

