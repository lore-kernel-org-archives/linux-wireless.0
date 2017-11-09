Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-co1nam03on0047.outbound.protection.outlook.com ([104.47.40.47]:5872
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753619AbdKILq5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Nov 2017 06:46:57 -0500
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Vasily Ulyanov <vulyanov@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH] cfg80211: cleanup signal strength units notation
Date: Thu,  9 Nov 2017 14:46:30 +0300
Message-Id: <20171109114630.24712-1-sergey.matyukevich.os@quantenna.com> (sfid-20171109_124702_354019_0BF3DE5B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Both cfg80211_rx_mgmt and cfg80211_report_obss_beacon functions send
reports to userspace using NL80211_ATTR_RX_SIGNAL_DBM attribute w/o
any processing of their input signal values. Which means that in
order to match userspace tools expectations, input signal values
for those functions are supposed to be in dBm units.

This patch cleans up comments, variable names, and trace reports
for those functions, replacing confusing 'mBm' by 'dBm'.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 include/net/cfg80211.h |  4 ++--
 net/wireless/mlme.c    |  6 +++---
 net/wireless/trace.h   | 12 ++++++------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 8b8118a7fadb..54321759aa44 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5576,7 +5576,7 @@ void cfg80211_conn_failed(struct net_device *dev, const u8 *mac_addr,
  * cfg80211_rx_mgmt - notification of received, unprocessed management frame
  * @wdev: wireless device receiving the frame
  * @freq: Frequency on which the frame was received in MHz
- * @sig_dbm: signal strength in mBm, or 0 if unknown
+ * @sig_dbm: signal strength in dBm, or 0 if unknown
  * @buf: Management frame (header + body)
  * @len: length of the frame data
  * @flags: flags, as defined in enum nl80211_rxmgmt_flags
@@ -5755,7 +5755,7 @@ void cfg80211_probe_status(struct net_device *dev, const u8 *addr,
  * @frame: the frame
  * @len: length of the frame
  * @freq: frequency the frame was received on
- * @sig_dbm: signal strength in mBm, or 0 if unknown
+ * @sig_dbm: signal strength in dBm, or 0 if unknown
  *
  * Use this function to report to userspace when a beacon was
  * received. It is not useful to call this when there is no
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index e7c64a8dce54..bbb9907bfa86 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -692,7 +692,7 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 	return rdev_mgmt_tx(rdev, wdev, params, cookie);
 }
 
-bool cfg80211_rx_mgmt(struct wireless_dev *wdev, int freq, int sig_mbm,
+bool cfg80211_rx_mgmt(struct wireless_dev *wdev, int freq, int sig_dbm,
 		      const u8 *buf, size_t len, u32 flags)
 {
 	struct wiphy *wiphy = wdev->wiphy;
@@ -708,7 +708,7 @@ bool cfg80211_rx_mgmt(struct wireless_dev *wdev, int freq, int sig_mbm,
 		cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE);
 	u16 stype;
 
-	trace_cfg80211_rx_mgmt(wdev, freq, sig_mbm);
+	trace_cfg80211_rx_mgmt(wdev, freq, sig_dbm);
 	stype = (le16_to_cpu(mgmt->frame_control) & IEEE80211_FCTL_STYPE) >> 4;
 
 	if (!(stypes->rx & BIT(stype))) {
@@ -735,7 +735,7 @@ bool cfg80211_rx_mgmt(struct wireless_dev *wdev, int freq, int sig_mbm,
 
 		/* Indicate the received Action frame to user space */
 		if (nl80211_send_mgmt(rdev, wdev, reg->nlportid,
-				      freq, sig_mbm,
+				      freq, sig_dbm,
 				      buf, len, flags, GFP_ATOMIC))
 			continue;
 
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index f3353fe5b35b..bcfedd39e7a3 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2544,20 +2544,20 @@ DEFINE_EVENT(cfg80211_netdev_mac_evt, cfg80211_del_sta,
 );
 
 TRACE_EVENT(cfg80211_rx_mgmt,
-	TP_PROTO(struct wireless_dev *wdev, int freq, int sig_mbm),
-	TP_ARGS(wdev, freq, sig_mbm),
+	TP_PROTO(struct wireless_dev *wdev, int freq, int sig_dbm),
+	TP_ARGS(wdev, freq, sig_dbm),
 	TP_STRUCT__entry(
 		WDEV_ENTRY
 		__field(int, freq)
-		__field(int, sig_mbm)
+		__field(int, sig_dbm)
 	),
 	TP_fast_assign(
 		WDEV_ASSIGN;
 		__entry->freq = freq;
-		__entry->sig_mbm = sig_mbm;
+		__entry->sig_dbm = sig_dbm;
 	),
-	TP_printk(WDEV_PR_FMT ", freq: %d, sig mbm: %d",
-		  WDEV_PR_ARG, __entry->freq, __entry->sig_mbm)
+	TP_printk(WDEV_PR_FMT ", freq: %d, sig dbm: %d",
+		  WDEV_PR_ARG, __entry->freq, __entry->sig_dbm)
 );
 
 TRACE_EVENT(cfg80211_mgmt_tx_status,
-- 
2.11.0
