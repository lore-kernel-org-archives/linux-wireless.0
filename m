Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37094 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbYIHPFm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 11:05:42 -0400
Subject: Re: [PATCH 1/1] mac80211: scan on IBSS mode like on STA mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Ester Kummer <ester.kummer@intel.com>,
	Luis Carlos Cobo <luisca@cozybit.com>
In-Reply-To: <1220885742.31304.67.camel@johannes.berg> (sfid-20080908_165552_656021_8FF20D03)
References: <1220880686-5620-1-git-send-email-tomas.winkler@intel.com>
	 <1220885742.31304.67.camel@johannes.berg>
	 (sfid-20080908_165552_656021_8FF20D03)
Content-Type: text/plain
Date: Mon, 08 Sep 2008 17:05:37 +0200
Message-Id: <1220886337.31304.71.camel@johannes.berg> (sfid-20080908_170546_243399_2C0B190E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-09-08 at 16:55 +0200, Johannes Berg wrote:
> On Mon, 2008-09-08 at 16:31 +0300, Tomas Winkler wrote:
> > From: Ester Kummer <ester.kummer@intel.com>
> > 
> > This patch handle scanning on IBSS mode like on STA mode.
> > When queuing the scan work we don't refer to the return value of
> > ieee80211_sta_start_scan so if we are in the last scan period, we will
> > return 0 to ieee80211_ioctl_siwscan and not -EAGAIN, and then iwlist will
> > call ieee80211_ioctl_giwscan to get the scan results and will not fail.
> 
> 
> Can you explain why? Or can anybody else explain why we do this
> difference at all? And how should mesh behave?

Actually, I do understand the difference now (explanation added below)
and if I'm guessing the problem you're having correctly your patch is
wrong. I think you want something like the patch below (never mind the
fact that it's against scan.c, I'm shuffling code)

johannes

--- everything.orig/net/mac80211/scan.c	2008-09-08 17:01:21.000000000 +0200
+++ everything/net/mac80211/scan.c	2008-09-08 17:03:28.000000000 +0200
@@ -674,24 +674,32 @@ int ieee80211_sta_start_scan(struct ieee
 
 int ieee80211_sta_req_scan(struct ieee80211_sub_if_data *sdata, u8 *ssid, size_t ssid_len)
 {
-	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
 	struct ieee80211_local *local = sdata->local;
 
-	if (sdata->vif.type != IEEE80211_IF_TYPE_STA)
-		return ieee80211_sta_start_scan(sdata, ssid, ssid_len);
-
 	if (local->sta_sw_scanning || local->sta_hw_scanning) {
 		if (local->scan_sdata == sdata)
 			return 0;
 		return -EBUSY;
 	}
 
-	ifsta->scan_ssid_len = ssid_len;
-	if (ssid_len)
-		memcpy(ifsta->scan_ssid, ssid, ssid_len);
-	set_bit(IEEE80211_STA_REQ_SCAN, &ifsta->request);
-	queue_work(local->hw.workqueue, &ifsta->work);
-	return 0;
+	/*
+	 * STA has a state machine that might need to defer scanning
+	 * while it's trying to associate/authenticate, therefore we
+	 * queue it up to the state machine in that case.
+	 */
+	if (sdata->vif.type == IEEE80211_IF_TYPE_STA) {
+		struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+
+		ifsta->scan_ssid_len = ssid_len;
+		if (ssid_len)
+			memcpy(ifsta->scan_ssid, ssid, ssid_len);
+		set_bit(IEEE80211_STA_REQ_SCAN, &ifsta->request);
+		queue_work(local->hw.workqueue, &ifsta->work);
+
+		return 0;
+	}
+
+	return ieee80211_sta_start_scan(sdata, ssid, ssid_len);
 }
 
 


