Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55217 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031528Ab2COQCL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 12:02:11 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] cfg80211: allow CFG80211_SIGNAL_TYPE_UNSPEC in station_info
Date: Thu, 15 Mar 2012 11:58:07 -0400
Message-Id: <1331827087-21339-1-git-send-email-linville@tuxdriver.com> (sfid-20120315_170217_051587_178152BF)
In-Reply-To: <1331825203.3432.25.camel@jlt3.sipsolutions.net>
References: <1331825203.3432.25.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The station_info struct had demanded dBm signal values, but the
cfg80211 wireless extensions implementation was also accepting
"unspecified" (i.e. RSSI) unit values while the nl80211 code was
completely unaware of them.  Resolve this by formalling allowing the
"unspecified" units while making nl80211 ignore them.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
The switch statement could be an if, but used it because I copied it
from elsewhere in the file and because we might (?) want to support a
different attribute to report the unspecified unit values through
nl80211?

 include/net/cfg80211.h |    4 ++--
 net/wireless/nl80211.c |   29 +++++++++++++++++++----------
 2 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index a067d30..4263a62 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -605,8 +605,8 @@ struct sta_bss_parameters {
  * @llid: mesh local link id
  * @plid: mesh peer link id
  * @plink_state: mesh peer link state
- * @signal: signal strength of last received packet in dBm
- * @signal_avg: signal strength average in dBm
+ * @signal: the signal strength, type depends on the wiphy's signal_type
+ * @signal_avg: avg signal strength, type depends on the wiphy's signal_type
  * @txrate: current unicast bitrate from this station
  * @rxrate: current unicast bitrate to this station
  * @rx_packets: packets received from this station
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index afeea32..3105c77 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2349,7 +2349,9 @@ nla_put_failure:
 }
 
 static int nl80211_send_station(struct sk_buff *msg, u32 pid, u32 seq,
-				int flags, struct net_device *dev,
+				int flags,
+				struct cfg80211_registered_device *rdev,
+				struct net_device *dev,
 				const u8 *mac_addr, struct station_info *sinfo)
 {
 	void *hdr;
@@ -2388,12 +2390,18 @@ static int nl80211_send_station(struct sk_buff *msg, u32 pid, u32 seq,
 	if (sinfo->filled & STATION_INFO_PLINK_STATE)
 		NLA_PUT_U8(msg, NL80211_STA_INFO_PLINK_STATE,
 			    sinfo->plink_state);
-	if (sinfo->filled & STATION_INFO_SIGNAL)
-		NLA_PUT_U8(msg, NL80211_STA_INFO_SIGNAL,
-			   sinfo->signal);
-	if (sinfo->filled & STATION_INFO_SIGNAL_AVG)
-		NLA_PUT_U8(msg, NL80211_STA_INFO_SIGNAL_AVG,
-			   sinfo->signal_avg);
+	switch (rdev->wiphy.signal_type) {
+	case CFG80211_SIGNAL_TYPE_MBM:
+		if (sinfo->filled & STATION_INFO_SIGNAL)
+			NLA_PUT_U8(msg, NL80211_STA_INFO_SIGNAL,
+				   sinfo->signal);
+		if (sinfo->filled & STATION_INFO_SIGNAL_AVG)
+			NLA_PUT_U8(msg, NL80211_STA_INFO_SIGNAL_AVG,
+				   sinfo->signal_avg);
+		break;
+	default:
+		break;
+	}
 	if (sinfo->filled & STATION_INFO_TX_BITRATE) {
 		if (!nl80211_put_sta_rate(msg, &sinfo->txrate,
 					  NL80211_STA_INFO_TX_BITRATE))
@@ -2486,7 +2494,7 @@ static int nl80211_dump_station(struct sk_buff *skb,
 		if (nl80211_send_station(skb,
 				NETLINK_CB(cb->skb).pid,
 				cb->nlh->nlmsg_seq, NLM_F_MULTI,
-				netdev, mac_addr,
+				dev, netdev, mac_addr,
 				&sinfo) < 0)
 			goto out;
 
@@ -2531,7 +2539,7 @@ static int nl80211_get_station(struct sk_buff *skb, struct genl_info *info)
 		return -ENOMEM;
 
 	if (nl80211_send_station(msg, info->snd_pid, info->snd_seq, 0,
-				 dev, mac_addr, &sinfo) < 0) {
+				 rdev, dev, mac_addr, &sinfo) < 0) {
 		nlmsg_free(msg);
 		return -ENOBUFS;
 	}
@@ -7482,7 +7490,8 @@ void nl80211_send_sta_event(struct cfg80211_registered_device *rdev,
 	if (!msg)
 		return;
 
-	if (nl80211_send_station(msg, 0, 0, 0, dev, mac_addr, sinfo) < 0) {
+	if (nl80211_send_station(msg, 0, 0, 0,
+				 rdev, dev, mac_addr, sinfo) < 0) {
 		nlmsg_free(msg);
 		return;
 	}
-- 
1.7.4.4

