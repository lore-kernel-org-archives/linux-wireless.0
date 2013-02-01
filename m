Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34785 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755328Ab3BAOKL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2013 09:10:11 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1U1HJz-0002Nh-Bt
	for linux-wireless@vger.kernel.org; Fri, 01 Feb 2013 15:10:27 +0100
Received: from 93-172-50-241.bb.netvision.net.il ([93.172.50.241])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 01 Feb 2013 15:10:27 +0100
Received: from qca_vkondrat by 93-172-50-241.bb.netvision.net.il with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 01 Feb 2013 15:10:27 +0100
To: linux-wireless@vger.kernel.org
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Subject: Re: [RFC] Expand byte counters in struct station_info
Date: Fri, 01 Feb 2013 16:10 +0200
Message-ID: <kegibi$v88$1@ger.gmane.org> (sfid-20130201_151016_055658_33C8D24B)
References: <6017229.5ECEUbBVAL@lx-vladimir> <1359628924.8415.5.camel@jlt4.sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:

> On Thu, 2013-01-31 at 11:46 +0200, Vladimir Kondratiev wrote:
>> Hi,
>> 
>> Now wifi drivers reports per-station info using struct station_info;
>> and currently for the data counters it has:
>> u32 rx_bytes;
>> u32 tx_bytes;
>> 
>> while for device-wide statistics one can use ndo_get_stats64() to fill
>> 64-bit counters in the struct rtnl_link_stats64, per-station statistics
>> are 32-bit.
>> 
>> This becomes problematic with gigabit speeds now observed for .11ac and
>> .11ad - counters overflown every few seconds.
>> 
>> I'd like to extend rx and tx byte counters to 64-bit.
>> 
>> What is better - expand existing fields in struct station_info as:
>> u64 rx_bytes;
>> u64 tx_bytes;
> 
> This.
> 
>> or add ne ones like:
>> u64 rx_bytes64;
>> u64 tx_bytes64;
> 
> I don't see a reason to do this.
> 
>> 
>> Then, I'll add
>> NL80211_STA_INFO_RX_BYTES64,
>> NL80211_STA_INFO_TX_BYTES64,
>> to the enum nl80211_sta_info
>> 
>> Before doing patch, I'd like to hear comments.
>> Any consideration why is this not to be done or done differently?
> 
> Sounds good to me.
> 
> Two points:
> 
> 1) You should provide the RX_TX_BYTES attributes, but I think only if
> the value fits into 32 bits. That way, we don't report invalid
> information.
> 
> 2a) Need to be careful in downstream drivers/mac80211, they should also
> be converted to use 64-bit counters when gathering the data. Otherwise,
> userspace might assume the value is actually 64-bit, when it rolled over
> in mac80211.
> 
> 2b) An alternative to converting all the non-mac80211 drivers and
> mac80211 would be to add new station info flags: STATION_INFO_TX_BYTES64
> and STATION_INFO_RX_BYTES64. You'd still fill the rx_bytes/tx_bytes
> values, but if the driver sets STATION_INFO_TX_BYTES you'd never use a
> 64-bit attribute in nl80211.
> 
> I think 2a is preferable, but it'd be a bunch of work to make sure to
> catch all drivers, and some devices might not actually have 64-bit
> counters (if the data comes from firmware)? So 2b might be a better
> choice.
> 
> johannes
> 

So, it may be like the following, patch 1 expands counters and patch 2
uses this 64-bit counters for ath6kl - only easy to find driver with
64-bit counters.

Comments?

>From e08b764685cc8887b36f97e2f7957498dbc48b60 Mon Sep 17 00:00:00 2001
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Date: Fri, 1 Feb 2013 16:01:35 +0200
Subject: [PATCH 1/2] wireless: expand per-station byte counters to 64bit

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

>From ec3c391673d70078008213d6243881919c977b07 Mon Sep 17 00:00:00 2001
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Date: Fri, 1 Feb 2013 16:03:34 +0200
Subject: [PATCH 2/2] ath6kl: provide 64-bit per-station byte counters

Internally, 64-bit byte counters maintained for per-station
statistics. Tell to the netlink that full 64-bit value provided

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 4225cca..90b1a93 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1778,14 +1778,16 @@ static int ath6kl_get_station(struct wiphy *wiphy, struct net_device *dev,
 
 	if (vif->target_stats.rx_byte) {
 		sinfo->rx_bytes = vif->target_stats.rx_byte;
-		sinfo->filled |= STATION_INFO_RX_BYTES;
+		sinfo->filled |= STATION_INFO_RX_BYTES |
+				 STATION_INFO_RX_BYTES64;
 		sinfo->rx_packets = vif->target_stats.rx_pkt;
 		sinfo->filled |= STATION_INFO_RX_PACKETS;
 	}
 
 	if (vif->target_stats.tx_byte) {
 		sinfo->tx_bytes = vif->target_stats.tx_byte;
-		sinfo->filled |= STATION_INFO_TX_BYTES;
+		sinfo->filled |= STATION_INFO_TX_BYTES |
+				 STATION_INFO_TX_BYTES64;
 		sinfo->tx_packets = vif->target_stats.tx_pkt;
 		sinfo->filled |= STATION_INFO_TX_PACKETS;
 	}
-- 
1.7.10.4


