Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56572 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751237AbeBMFdN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Feb 2018 00:33:13 -0500
From: Venkateswara Naralasetty <vnaralas@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Venkateswara Naralasetty <vnaralas@codeaurora.org>
Subject: [PATCHv2 1/3] cfg80211: send ack_signal to user in probe client response
Date: Tue, 13 Feb 2018 11:03:06 +0530
Message-Id: <1518499986-10606-1-git-send-email-vnaralas@codeaurora.org> (sfid-20180213_063619_181065_C5757F65)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch provides support to get ack signal in probe client response
and in station info from user.

Signed-off-by: Venkateswara Naralasetty <vnaralas@codeaurora.org>
---
v2:
* addressed Johannes comments

 include/net/cfg80211.h       | 7 ++++++-
 include/uapi/linux/nl80211.h | 3 +++
 net/wireless/nl80211.c       | 8 ++++++--
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7d49cd0..56e905c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1147,6 +1147,7 @@ struct cfg80211_tid_stats {
  * @rx_duration: aggregate PPDU duration(usecs) for all the frames from a peer
  * @pertid: per-TID statistics, see &struct cfg80211_tid_stats, using the last
  *	(IEEE80211_NUM_TIDS) index for MSDUs not encapsulated in QoS-MPDUs.
+ * @ack_signal: signal strength (in dBm) of the last ACK frame.
  */
 struct station_info {
 	u64 filled;
@@ -1191,6 +1192,7 @@ struct station_info {
 	u64 rx_duration;
 	u8 rx_beacon_signal_avg;
 	struct cfg80211_tid_stats pertid[IEEE80211_NUM_TIDS + 1];
+	s8 ack_signal;
 };
 
 #if IS_ENABLED(CONFIG_CFG80211)
@@ -5838,10 +5840,13 @@ bool cfg80211_rx_unexpected_4addr_frame(struct net_device *dev,
  * @addr: the address of the peer
  * @cookie: the cookie filled in @probe_client previously
  * @acked: indicates whether probe was acked or not
+ * @ack_signal: signal strength (in dBm) of the ACK frame.
+ * @is_valid_ack_signal: indicates the ack_signal is valid or not.
  * @gfp: allocation flags
  */
 void cfg80211_probe_status(struct net_device *dev, const u8 *addr,
-			   u64 cookie, bool acked, gfp_t gfp);
+			   u64 cookie, bool acked, s32 ack_signal,
+			   bool is_valid_ack_signal, gfp_t gfp);
 
 /**
  * cfg80211_report_obss_beacon - report beacon from other APs
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index ca3d5a6..c13c843 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2626,6 +2626,7 @@ enum nl80211_attrs {
 	NL80211_ATTR_EXTERNAL_AUTH_SUPPORT,
 
 	NL80211_ATTR_NSS,
+	NL80211_ATTR_ACK_SIGNAL,
 
 	/* add attributes here, update the policy in nl80211.c */
 
@@ -2947,6 +2948,7 @@ enum nl80211_sta_bss_param {
  * @NL80211_STA_INFO_RX_DURATION: aggregate PPDU duration for all frames
  *	received from the station (u64, usec)
  * @NL80211_STA_INFO_PAD: attribute used for padding for 64-bit alignment
+ * @NL80211_STA_INFO_ACK_SIGNAL: signal strength of the last ACK frame(u8, dBm)
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
  */
@@ -2985,6 +2987,7 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_TID_STATS,
 	NL80211_STA_INFO_RX_DURATION,
 	NL80211_STA_INFO_PAD,
+	NL80211_STA_INFO_ACK_SIGNAL,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index cc6ec5b..707f4a2 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4486,6 +4486,7 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 	PUT_SINFO_U64(RX_DROP_MISC, rx_dropped_misc);
 	PUT_SINFO_U64(BEACON_RX, rx_beacon);
 	PUT_SINFO(BEACON_SIGNAL_AVG, rx_beacon_signal_avg, u8);
+	PUT_SINFO(ACK_SIGNAL, ack_signal, u8);
 
 #undef PUT_SINFO
 #undef PUT_SINFO_U64
@@ -15006,7 +15007,8 @@ void cfg80211_sta_opmode_change_notify(struct net_device *dev, const u8 *mac,
 EXPORT_SYMBOL(cfg80211_sta_opmode_change_notify);
 
 void cfg80211_probe_status(struct net_device *dev, const u8 *addr,
-			   u64 cookie, bool acked, gfp_t gfp)
+			   u64 cookie, bool acked, s32 ack_signal,
+			   bool is_valid_ack_signal, gfp_t gfp)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
@@ -15031,7 +15033,9 @@ void cfg80211_probe_status(struct net_device *dev, const u8 *addr,
 	    nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, addr) ||
 	    nla_put_u64_64bit(msg, NL80211_ATTR_COOKIE, cookie,
 			      NL80211_ATTR_PAD) ||
-	    (acked && nla_put_flag(msg, NL80211_ATTR_ACK)))
+	    (acked && nla_put_flag(msg, NL80211_ATTR_ACK)) ||
+	    (is_valid_ack_signal && nla_put_s32(msg, NL80211_ATTR_ACK_SIGNAL,
+						ack_signal)))
 		goto nla_put_failure;
 
 	genlmsg_end(msg, hdr);
-- 
2.7.4
