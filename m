Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48157 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753947AbaHNLIH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2014 07:08:07 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	Arend van Spriel <arend@broadcom.com>,
	Eliad Peller <eliad@wizery.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 1/2] cfg80211: clarify BSS probe response vs. beacon data
Date: Thu, 14 Aug 2014 13:07:57 +0200
Message-Id: <1408014478-20401-1-git-send-email-johannes@sipsolutions.net> (sfid-20140814_130815_100802_343FF963)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There are a few possible cases of where BSS data came from:
 1) only a beacon has been received
 2) only a probe response has been received
 3) the driver didn't report what it received (this happens when
    using cfg80211_inform_bss[_width]())
 4) both probe response and beacon data has been received

Unfortunately, in the userspace API, a few things weren't there:
 a) there was no way to differentiate cases 1) and 4) above
    without comparing the data of the IEs
 b) the TSF was always from the last frame, instead of being
    exposed for beacon/probe response separately like IEs

Fix this by
   i) exporting a new flag attribute that indicates whether or
      not probe response data has been received - this addresses (a)
  ii) exporting a BEACON_TSF attribute that holds the beacon's TSF
      if a beacon has been received
 iii) not exporting the beacon attributes in case (3) above as that
      would just lead userspace into thinking the data actually came
      from a beacon when that isn't clear

To implement this, track inside the IEs struct whether or not it
(definitely) came from a beacon.

Reported-by: William Seto
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h       |  2 ++
 include/uapi/linux/nl80211.h | 16 ++++++++++++++--
 net/wireless/nl80211.c       | 16 ++++++++++++----
 net/wireless/scan.c          |  6 ++++--
 4 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7b8dac3efe8f..77b85a89abca 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1503,12 +1503,14 @@ enum cfg80211_signal_type {
  * @tsf: TSF contained in the frame that carried these IEs
  * @rcu_head: internal use, for freeing
  * @len: length of the IEs
+ * @from_beacon: these IEs are known to come from a beacon
  * @data: IE data
  */
 struct cfg80211_bss_ies {
 	u64 tsf;
 	struct rcu_head rcu_head;
 	int len;
+	bool from_beacon;
 	u8 data[];
 };
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index f1db15b9c041..d097568da690 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3055,14 +3055,20 @@ enum nl80211_bss_scan_width {
  * @NL80211_BSS_BSSID: BSSID of the BSS (6 octets)
  * @NL80211_BSS_FREQUENCY: frequency in MHz (u32)
  * @NL80211_BSS_TSF: TSF of the received probe response/beacon (u64)
+ *	(if @NL80211_BSS_PRESP_DATA is present then this is known to be
+ *	from a probe response, otherwise it may be from the same beacon
+ *	that the NL80211_BSS_BEACON_TSF will be from)
  * @NL80211_BSS_BEACON_INTERVAL: beacon interval of the (I)BSS (u16)
  * @NL80211_BSS_CAPABILITY: capability field (CPU order, u16)
  * @NL80211_BSS_INFORMATION_ELEMENTS: binary attribute containing the
  *	raw information elements from the probe response/beacon (bin);
- *	if the %NL80211_BSS_BEACON_IES attribute is present, the IEs here are
- *	from a Probe Response frame; otherwise they are from a Beacon frame.
+ *	if the %NL80211_BSS_BEACON_IES attribute is present and the data is
+ *	different then the IEs here are from a Probe Response frame; otherwise
+ *	they are from a Beacon frame.
  *	However, if the driver does not indicate the source of the IEs, these
  *	IEs may be from either frame subtype.
+ *	If present, the @NL80211_BSS_PRESP_DATA attribute indicates that the
+ *	data here is known to be from a probe response, without any heuristics.
  * @NL80211_BSS_SIGNAL_MBM: signal strength of probe response/beacon
  *	in mBm (100 * dBm) (s32)
  * @NL80211_BSS_SIGNAL_UNSPEC: signal strength of the probe response/beacon
@@ -3074,6 +3080,10 @@ enum nl80211_bss_scan_width {
  *	yet been received
  * @NL80211_BSS_CHAN_WIDTH: channel width of the control channel
  *	(u32, enum nl80211_bss_scan_width)
+ * @NL80211_BSS_BEACON_TSF: TSF of the last received beacon (u64)
+ *	(not present if no beacon frame has been received yet)
+ * @NL80211_BSS_PRESP_DATA: the data in @NL80211_BSS_INFORMATION_ELEMENTS and
+ *	@NL80211_BSS_TSF is known to be from a probe response (flag attribute)
  * @__NL80211_BSS_AFTER_LAST: internal
  * @NL80211_BSS_MAX: highest BSS attribute
  */
@@ -3091,6 +3101,8 @@ enum nl80211_bss {
 	NL80211_BSS_SEEN_MS_AGO,
 	NL80211_BSS_BEACON_IES,
 	NL80211_BSS_CHAN_WIDTH,
+	NL80211_BSS_BEACON_TSF,
+	NL80211_BSS_PRESP_DATA,
 
 	/* keep last */
 	__NL80211_BSS_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 13997c954249..fc84f5c0c1a3 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6034,7 +6034,6 @@ static int nl80211_send_bss(struct sk_buff *msg, struct netlink_callback *cb,
 	const struct cfg80211_bss_ies *ies;
 	void *hdr;
 	struct nlattr *bss;
-	bool tsf = false;
 
 	ASSERT_WDEV_LOCK(wdev);
 
@@ -6061,18 +6060,27 @@ static int nl80211_send_bss(struct sk_buff *msg, struct netlink_callback *cb,
 		goto nla_put_failure;
 
 	rcu_read_lock();
+	/* indicate whether we have probe response data or not */
+	if (rcu_access_pointer(res->proberesp_ies) &&
+	    nla_put_flag(msg, NL80211_BSS_PRESP_DATA))
+		goto fail_unlock_rcu;
+
+	/* this pointer prefers to be pointed to probe response data
+	 * but is always valid
+	 */
 	ies = rcu_dereference(res->ies);
 	if (ies) {
 		if (nla_put_u64(msg, NL80211_BSS_TSF, ies->tsf))
 			goto fail_unlock_rcu;
-		tsf = true;
 		if (ies->len && nla_put(msg, NL80211_BSS_INFORMATION_ELEMENTS,
 					ies->len, ies->data))
 			goto fail_unlock_rcu;
 	}
+
+	/* and this pointer is always (unless driver didn't know) beacon data */
 	ies = rcu_dereference(res->beacon_ies);
-	if (ies) {
-		if (!tsf && nla_put_u64(msg, NL80211_BSS_TSF, ies->tsf))
+	if (ies && ies->from_beacon) {
+		if (nla_put_u64(msg, NL80211_BSS_BEACON_TSF, ies->tsf))
 			goto fail_unlock_rcu;
 		if (ies->len && nla_put(msg, NL80211_BSS_BEACON_IES,
 					ies->len, ies->data))
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 0798c62e6085..9b68ff01cd7a 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -918,11 +918,12 @@ cfg80211_inform_bss_width(struct wiphy *wiphy,
 	 * override the IEs pointer should we have received an earlier
 	 * indication of Probe Response data.
 	 */
-	ies = kmalloc(sizeof(*ies) + ielen, gfp);
+	ies = kzalloc(sizeof(*ies) + ielen, gfp);
 	if (!ies)
 		return NULL;
 	ies->len = ielen;
 	ies->tsf = tsf;
+	ies->from_beacon = false;
 	memcpy(ies->data, ie, ielen);
 
 	rcu_assign_pointer(tmp.pub.beacon_ies, ies);
@@ -982,11 +983,12 @@ cfg80211_inform_bss_width_frame(struct wiphy *wiphy,
 	if (!channel)
 		return NULL;
 
-	ies = kmalloc(sizeof(*ies) + ielen, gfp);
+	ies = kzalloc(sizeof(*ies) + ielen, gfp);
 	if (!ies)
 		return NULL;
 	ies->len = ielen;
 	ies->tsf = le64_to_cpu(mgmt->u.probe_resp.timestamp);
+	ies->from_beacon = !ieee80211_is_probe_resp(mgmt->frame_control);
 	memcpy(ies->data, mgmt->u.probe_resp.variable, ielen);
 
 	if (ieee80211_is_probe_resp(mgmt->frame_control))
-- 
2.0.0

