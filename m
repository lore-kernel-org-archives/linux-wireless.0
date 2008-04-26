Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43272 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbYDZQCv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Apr 2008 12:02:51 -0400
Subject: RE: [RFC] mac80211: handling Qdisc issues
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rindjunsky, Ron" <ron.rindjunsky@intel.com>
Cc: "Winkler, Tomas" <tomas.winkler@intel.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1879838866982C46A9CB3D56BA49ADEB04D09D98@hasmsx411.ger.corp.intel.com>
References: <1204822307-5111-1-git-send-email-ron.rindjunsky@intel.com>
	 <1206450026.16475.261.camel@johannes.berg>
	 <1879838866982C46A9CB3D56BA49ADEB04B41299@hasmsx411.ger.corp.intel.com>
	 <1206623412.22530.46.camel@johannes.berg>
	 <1879838866982C46A9CB3D56BA49ADEB04B42158@hasmsx411.ger.corp.intel.com>
	 <1208426282.4066.3.camel@johannes.berg>
	 <1879838866982C46A9CB3D56BA49ADEB04CCE9C4@hasmsx411.ger.corp.intel.com>
	 <C07C4589BE74A34981C3C3525EE1F80103BAF061@hasmsx412.ger.corp.intel.com>
	 <1208469393.4066.92.camel@johannes.berg>
	 <C07C4589BE74A34981C3C3525EE1F80103BF5D59@hasmsx412.ger.corp.intel.com>
	 <1209027037.3357.39.camel@johannes.berg>
	 <1879838866982C46A9CB3D56BA49ADEB04D09D98@hasmsx411.ger.corp.intel.com>
Content-Type: text/plain
Date: Sat, 26 Apr 2008 18:02:40 +0200
Message-Id: <1209225760.10943.35.camel@johannes.berg> (sfid-20080426_180309_890636_6FEF00A6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-04-24 at 23:09 +0300, Rindjunsky, Ron wrote:
> >>> such as not using QoS packets when hw->queues < 4.
> >>
> >> We should not advertise QoS in that case.
> 
> > Ok :) I'll look if I can fix it.
> 
> In that case no HT should be published as well.

Yeah. Can you see whether the below patch looks ok to you?


johannes

---
 net/mac80211/iface.c |    3 ++-
 net/mac80211/mlme.c  |   18 ++++++++++++------
 net/mac80211/tx.c    |    4 ++--
 3 files changed, 16 insertions(+), 9 deletions(-)

--- everything.orig/net/mac80211/iface.c	2008-04-24 16:51:05.000000000 +0200
+++ everything/net/mac80211/iface.c	2008-04-24 16:54:14.000000000 +0200
@@ -157,9 +157,10 @@ void ieee80211_if_set_type(struct net_de
 		ifsta->auth_algs = IEEE80211_AUTH_ALG_OPEN |
 			IEEE80211_AUTH_ALG_SHARED_KEY;
 		ifsta->flags |= IEEE80211_STA_CREATE_IBSS |
-			IEEE80211_STA_WMM_ENABLED |
 			IEEE80211_STA_AUTO_BSSID_SEL |
 			IEEE80211_STA_AUTO_CHANNEL_SEL;
+		if (sdata->local->hw.queues >= 4)
+			ifsta->flags |= IEEE80211_STA_WMM_ENABLED;
 
 		msdata = IEEE80211_DEV_TO_SUB_IF(sdata->local->mdev);
 		sdata->bss = &msdata->u.ap;
--- everything.orig/net/mac80211/mlme.c	2008-04-24 16:49:11.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-04-24 16:58:47.000000000 +0200
@@ -282,6 +282,12 @@ static void ieee80211_sta_wmm_params(str
 	int count;
 	u8 *pos;
 
+	if (!(ifsta->flags & IEEE80211_STA_WMM_ENABLED))
+		return;
+
+	if (!wmm_param)
+		return;
+
 	if (wmm_param_len < 8 || wmm_param[5] /* version */ != 1)
 		return;
 	count = wmm_param[6] & 0x0f;
@@ -772,8 +778,10 @@ static void ieee80211_send_assoc(struct 
 		*pos++ = 1; /* WME ver */
 		*pos++ = 0;
 	}
+
 	/* wmm support is a must to HT */
-	if (wmm && sband->ht_info.ht_supported) {
+	if (wmm && (ifsta->flags & IEEE80211_STA_WMM_ENABLED) &&
+	    sband->ht_info.ht_supported) {
 		__le16 tmp = cpu_to_le16(sband->ht_info.cap);
 		pos = skb_put(skb, sizeof(struct ieee80211_ht_cap)+2);
 		*pos++ = WLAN_EID_HT_CAPABILITY;
@@ -2046,7 +2054,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 
 	rate_control_rate_init(sta, local);
 
-	if (elems.wmm_param && (ifsta->flags & IEEE80211_STA_WMM_ENABLED)) {
+	if (elems.wmm_param) {
 		sta->flags |= WLAN_STA_WME;
 		rcu_read_unlock();
 		ieee80211_sta_wmm_params(dev, ifsta, elems.wmm_param,
@@ -2829,10 +2837,8 @@ static void ieee80211_rx_mgmt_beacon(str
 
 	ieee802_11_parse_elems(mgmt->u.beacon.variable, len - baselen, &elems);
 
-	if (elems.wmm_param && (ifsta->flags & IEEE80211_STA_WMM_ENABLED)) {
-		ieee80211_sta_wmm_params(dev, ifsta, elems.wmm_param,
-					 elems.wmm_param_len);
-	}
+	ieee80211_sta_wmm_params(dev, ifsta, elems.wmm_param,
+				 elems.wmm_param_len);
 
 	/* Do not send changes to driver if we are scanning. This removes
 	 * requirement that driver's bss_info_changed function needs to be
--- everything.orig/net/mac80211/tx.c	2008-04-24 16:48:09.000000000 +0200
+++ everything/net/mac80211/tx.c	2008-04-24 16:59:44.000000000 +0200
@@ -1491,8 +1491,8 @@ int ieee80211_subif_start_xmit(struct sk
 		rcu_read_unlock();
 	}
 
-	/* receiver is QoS enabled, use a QoS type frame */
-	if (sta_flags & WLAN_STA_WME) {
+	/* receiver and we are QoS enabled, use a QoS type frame */
+	if (sta_flags & WLAN_STA_WME && local->hw.queues >= 4) {
 		fc |= IEEE80211_STYPE_QOS_DATA;
 		hdrlen += 2;
 	}


