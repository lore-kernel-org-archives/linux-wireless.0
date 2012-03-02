Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40625 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756115Ab2CBMkj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 07:40:39 -0500
Subject: [PATCH] cfg80211/mac80211: report signal strength for mgmt frames
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Mar 2012 13:40:35 +0100
Message-ID: <1330692035.8542.14.camel@jlt3.sipsolutions.net> (sfid-20120302_134042_979335_4F58CEB1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add the signal strength (in dBm only for now) to
frames that are received via nl80211's various
frame APIs.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/nl80211.h |    6 ++++++
 include/net/cfg80211.h  |    8 +++++---
 net/mac80211/rx.c       |   13 +++++++++++--
 net/wireless/mlme.c     |    7 ++++---
 net/wireless/nl80211.c  |    9 +++++++--
 net/wireless/nl80211.h  |    3 ++-
 6 files changed, 35 insertions(+), 11 deletions(-)

--- a/include/linux/nl80211.h	2012-03-02 13:27:36.000000000 +0100
+++ b/include/linux/nl80211.h	2012-03-02 13:31:24.000000000 +0100
@@ -1197,6 +1197,10 @@ enum nl80211_commands {
  * @NL80211_ATTR_NOACK_MAP: This u16 bitmap contains the No Ack Policy of
  *      up to 16 TIDs.
  *
+ * @NL80211_ATTR_RX_SIGNAL_DBM: signal strength in dBm (as a 32-bit int);
+ *	this attribute is (depending on the driver capabilities) added to
+ *	received frames indicated with %NL80211_CMD_FRAME.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1442,6 +1446,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_NOACK_MAP,
 
+	NL80211_ATTR_RX_SIGNAL_DBM,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
--- a/include/net/cfg80211.h	2012-03-02 13:28:11.000000000 +0100
+++ b/include/net/cfg80211.h	2012-03-02 13:33:02.000000000 +0100
@@ -3186,6 +3186,7 @@ void cfg80211_del_sta(struct net_device
  * cfg80211_rx_mgmt - notification of received, unprocessed management frame
  * @dev: network device
  * @freq: Frequency on which the frame was received in MHz
+ * @sig_dbm: signal strength in mBm, or 0 if unknown
  * @buf: Management frame (header + body)
  * @len: length of the frame data
  * @gfp: context flags
@@ -3198,8 +3199,8 @@ void cfg80211_del_sta(struct net_device
  * This function is called whenever an Action frame is received for a station
  * mode interface, but is not processed in kernel.
  */
-bool cfg80211_rx_mgmt(struct net_device *dev, int freq, const u8 *buf,
-		      size_t len, gfp_t gfp);
+bool cfg80211_rx_mgmt(struct net_device *dev, int freq, int sig_dbm,
+		      const u8 *buf, size_t len, gfp_t gfp);
 
 /**
  * cfg80211_mgmt_tx_status - notification of TX status for management frame
@@ -3312,6 +3313,7 @@ void cfg80211_probe_status(struct net_de
  * @frame: the frame
  * @len: length of the frame
  * @freq: frequency the frame was received on
+ * @sig_dbm: signal strength in mBm, or 0 if unknown
  * @gfp: allocation flags
  *
  * Use this function to report to userspace when a beacon was
@@ -3320,7 +3322,7 @@ void cfg80211_probe_status(struct net_de
  */
 void cfg80211_report_obss_beacon(struct wiphy *wiphy,
 				 const u8 *frame, size_t len,
-				 int freq, gfp_t gfp);
+				 int freq, int sig_dbm, gfp_t gfp);
 
 /*
  * cfg80211_can_beacon_sec_chan - test if ht40 on extension channel can be used
--- a/net/wireless/nl80211.c	2012-03-02 13:27:36.000000000 +0100
+++ b/net/wireless/nl80211.c	2012-03-02 13:32:44.000000000 +0100
@@ -7673,7 +7673,8 @@ bool nl80211_unexpected_4addr_frame(stru
 
 int nl80211_send_mgmt(struct cfg80211_registered_device *rdev,
 		      struct net_device *netdev, u32 nlpid,
-		      int freq, const u8 *buf, size_t len, gfp_t gfp)
+		      int freq, int sig_dbm,
+		      const u8 *buf, size_t len, gfp_t gfp)
 {
 	struct sk_buff *msg;
 	void *hdr;
@@ -7691,6 +7692,8 @@ int nl80211_send_mgmt(struct cfg80211_re
 	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
 	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex);
 	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_FREQ, freq);
+	if (sig_dbm)
+		NLA_PUT_U32(msg, NL80211_ATTR_RX_SIGNAL_DBM, sig_dbm);
 	NLA_PUT(msg, NL80211_ATTR_FRAME, len, buf);
 
 	genlmsg_end(msg, hdr);
@@ -7952,7 +7955,7 @@ EXPORT_SYMBOL(cfg80211_probe_status);
 
 void cfg80211_report_obss_beacon(struct wiphy *wiphy,
 				 const u8 *frame, size_t len,
-				 int freq, gfp_t gfp)
+				 int freq, int sig_dbm, gfp_t gfp)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 	struct sk_buff *msg;
@@ -7975,6 +7978,8 @@ void cfg80211_report_obss_beacon(struct
 	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
 	if (freq)
 		NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_FREQ, freq);
+	if (sig_dbm)
+		NLA_PUT_U32(msg, NL80211_ATTR_RX_SIGNAL_DBM, sig_dbm);
 	NLA_PUT(msg, NL80211_ATTR_FRAME, len, frame);
 
 	genlmsg_end(msg, hdr);
--- a/net/wireless/mlme.c	2012-03-02 13:28:10.000000000 +0100
+++ b/net/wireless/mlme.c	2012-03-02 13:28:13.000000000 +0100
@@ -814,8 +814,8 @@ int cfg80211_mlme_mgmt_tx(struct cfg8021
 				  cookie);
 }
 
-bool cfg80211_rx_mgmt(struct net_device *dev, int freq, const u8 *buf,
-		      size_t len, gfp_t gfp)
+bool cfg80211_rx_mgmt(struct net_device *dev, int freq, int sig_mbm,
+		      const u8 *buf, size_t len, gfp_t gfp)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct wiphy *wiphy = wdev->wiphy;
@@ -854,7 +854,8 @@ bool cfg80211_rx_mgmt(struct net_device
 		/* found match! */
 
 		/* Indicate the received Action frame to user space */
-		if (nl80211_send_mgmt(rdev, dev, reg->nlpid, freq,
+		if (nl80211_send_mgmt(rdev, dev, reg->nlpid,
+				      freq, sig_mbm,
 				      buf, len, gfp))
 			continue;
 
--- a/net/mac80211/rx.c	2012-03-02 13:28:12.000000000 +0100
+++ b/net/mac80211/rx.c	2012-03-02 13:30:48.000000000 +0100
@@ -2182,9 +2182,14 @@ ieee80211_rx_h_mgmt_check(struct ieee802
 	if (rx->sdata->vif.type == NL80211_IFTYPE_AP &&
 	    ieee80211_is_beacon(mgmt->frame_control) &&
 	    !(rx->flags & IEEE80211_RX_BEACON_REPORTED)) {
+	    	int sig = 0;
+
+		if (rx->local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
+			sig = status->signal;
+
 		cfg80211_report_obss_beacon(rx->local->hw.wiphy,
 					    rx->skb->data, rx->skb->len,
-					    status->freq, GFP_ATOMIC);
+					    status->freq, sig, GFP_ATOMIC);
 		rx->flags |= IEEE80211_RX_BEACON_REPORTED;
 	}
 
@@ -2408,6 +2413,7 @@ static ieee80211_rx_result debug_noinlin
 ieee80211_rx_h_userspace_mgmt(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
+	int sig = 0;
 
 	/* skip known-bad action frames and return them in the next handler */
 	if (status->rx_flags & IEEE80211_RX_MALFORMED_ACTION_FRM)
@@ -2420,7 +2426,10 @@ ieee80211_rx_h_userspace_mgmt(struct iee
 	 * it transmitted were processed or returned.
 	 */
 
-	if (cfg80211_rx_mgmt(rx->sdata->dev, status->freq,
+	if (rx->local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
+		sig = status->signal;
+
+	if (cfg80211_rx_mgmt(rx->sdata->dev, status->freq, sig,
 			     rx->skb->data, rx->skb->len,
 			     GFP_ATOMIC)) {
 		if (rx->sta)
--- a/net/wireless/nl80211.h	2012-02-23 17:03:23.000000000 +0100
+++ b/net/wireless/nl80211.h	2012-03-02 13:32:01.000000000 +0100
@@ -92,7 +92,8 @@ void nl80211_send_sta_del_event(struct c
 				gfp_t gfp);
 
 int nl80211_send_mgmt(struct cfg80211_registered_device *rdev,
-		      struct net_device *netdev, u32 nlpid, int freq,
+		      struct net_device *netdev, u32 nlpid,
+		      int freq, int sig_dbm,
 		      const u8 *buf, size_t len, gfp_t gfp);
 void nl80211_send_mgmt_tx_status(struct cfg80211_registered_device *rdev,
 				 struct net_device *netdev, u64 cookie,


