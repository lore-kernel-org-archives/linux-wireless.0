Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35475 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963AbaHLTEB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Aug 2014 15:04:01 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: kvalo@adurom.com, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] cfg80211: clarify BSS probe response vs. beacon data
Date: Tue, 12 Aug 2014 21:03:38 +0200
Message-Id: <1407870219-1720-1-git-send-email-johannes@sipsolutions.net> (sfid-20140812_210406_116021_BFA846C0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There are a few possible cases of where BSS data came from:
 1) only a beacon has been received
 2) only a probe response has been received
 3) the driver didn't report what it received (this happens
    when using cfg80211_inform_bss[_width]())
 4) both probe response and beacon data has been received

Unfortunately, in the userspace API, a few things weren't
there:
 a) there was no way to differentiate cases 1) and 4) above
    without comparing the data of the IEs
 b) the TSF was always from the last frame, instead of being
    exposed for beacon/probe response separately like IEs

Fix this by
   i) exporting a new flag attribute that indicates whether
      or not probe response data has been received - this
      addresses (a)
  ii) exporting a BEACON_TSF attribute that holds the beacon's
      TSF if a beacon has been received
 iii) not exporting the beacon attributes in case (3) above
      as that would just lead userspace into thinking the
      data actually came from a beacon when that isn't clear

Reported-by: William Seto
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/uapi/linux/nl80211.h | 16 ++++++++++++++--
 net/wireless/core.h          |  2 ++
 net/wireless/nl80211.c       | 16 ++++++++++++----
 net/wireless/scan.c          | 10 ++++++++++
 4 files changed, 38 insertions(+), 6 deletions(-)

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
diff --git a/net/wireless/core.h b/net/wireless/core.h
index e9afbf10e756..08d17c1c5a47 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -127,6 +127,8 @@ struct cfg80211_internal_bss {
 	unsigned long refcount;
 	atomic_t hold;
 
+	bool known_frame_type;
+
 	/* must be last because of priv member */
 	struct cfg80211_bss pub;
 };
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 13997c954249..2fdb8bc01a32 100644
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
+	if (intbss->known_frame_type && ies) {
+		if (nla_put_u64(msg, NL80211_BSS_BEACON_TSF, ies->tsf))
 			goto fail_unlock_rcu;
 		if (ies->len && nla_put(msg, NL80211_BSS_BEACON_IES,
 					ies->len, ies->data))
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 0798c62e6085..b5904bae74f2 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -925,6 +925,10 @@ cfg80211_inform_bss_width(struct wiphy *wiphy,
 	ies->tsf = tsf;
 	memcpy(ies->data, ie, ielen);
 
+	/* assume from beacon in absence of info - needed so it's freed,
+	 * but see known_frame_type below - we set it to false so no
+	 * assumptions are made
+	 */
 	rcu_assign_pointer(tmp.pub.beacon_ies, ies);
 	rcu_assign_pointer(tmp.pub.ies, ies);
 
@@ -937,6 +941,9 @@ cfg80211_inform_bss_width(struct wiphy *wiphy,
 	if (res->pub.capability & WLAN_CAPABILITY_ESS)
 		regulatory_hint_found_beacon(wiphy, channel, gfp);
 
+	/* assume drivers don't mix and match too badly */
+	res->known_frame_type = false;
+
 	trace_cfg80211_return_bss(&res->pub);
 	/* cfg80211_bss_update gives us a referenced result */
 	return &res->pub;
@@ -1011,6 +1018,9 @@ cfg80211_inform_bss_width_frame(struct wiphy *wiphy,
 	if (res->pub.capability & WLAN_CAPABILITY_ESS)
 		regulatory_hint_found_beacon(wiphy, channel, gfp);
 
+	/* assume drivers don't mix and match too badly */
+	res->known_frame_type = true;
+
 	trace_cfg80211_return_bss(&res->pub);
 	/* cfg80211_bss_update gives us a referenced result */
 	return &res->pub;
-- 
2.0.0

