Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41296 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756412Ab0BBTtv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2010 14:49:51 -0500
Subject: Re: [PATCH] mac80211: fix deferred hardware scan requests
From: Johannes Berg <johannes@sipsolutions.net>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1265136878-5844-1-git-send-email-reinette.chatre@intel.com>
References: <1265136878-5844-1-git-send-email-reinette.chatre@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Feb 2010 20:49:43 +0100
Message-ID: <1265140183.29119.82.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-02-02 at 10:54 -0800, Reinette Chatre wrote:

> mac80211 will defer the handling of scan requests if it is busy
> with management work at the time. The scan requests are
> deferred and run after the work has completed. When this occurs
> there are currently two problems.
> 
> * The scan request for hardware scan is not fully populated with
>   the band and channels to scan not initialized.
> * When the scan is queued the state is not correctly updated to
>   reflect that a scan is in progress. The problem here is that when
>   the driver completes the scan and calls ieee80211_scan_completed()
>   a warning will be triggered since mac80211 was not aware that a scan
>   was in progress.

Good analysis, thanks.

> Both issues are fixed here by first ensuring that scan request is fully
> initialized before it is queued and next by setting the scanning state
> correctly before it is queued for execution.

> * I would like to confirm one change I made in ieee80211_work_work. From
>   what I can tell software scanning does not expect the scanning state to
>   be set in ieee80211_scan_work, but hardware scanning does. Is this
>   correct?

I think so, but I kinda think it makes that code rely too much on the
internals.

> * This is a proposed fix for
>   http://bugzilla.kernel.org/show_bug.cgi?id=15119, which is tracked as a
>   regression. The user is having some system problems and is not able to
>   test it.
> 
> * This is an important fix to get in, otherwise wireless will become a top
>   performer on kerneloops.org.

Well said ;)

Thanks to your analysis of the problem, and the remain-on-channel work,
I was able to reproduce the problem, and the following seems to fix it
for me; what do you think?

johannes


--- wireless-testing.orig/net/mac80211/scan.c	2010-02-02 20:37:28.000000000 +0100
+++ wireless-testing/net/mac80211/scan.c	2010-02-02 20:39:35.000000000 +0100
@@ -345,6 +345,14 @@ static int __ieee80211_start_scan(struct
 	if (local->scan_req)
 		return -EBUSY;
 
+	local->scan_req = req;
+	local->scan_sdata = sdata;
+
+	if (!list_empty(&local->work_list)) {
+		/* wait for the work to finish/time out */
+		return 0;
+	}
+
 	if (local->ops->hw_scan) {
 		u8 *ies;
 
@@ -353,8 +361,11 @@ static int __ieee80211_start_scan(struct
 				req->n_channels * sizeof(req->channels[0]) +
 				2 + IEEE80211_MAX_SSID_LEN + local->scan_ies_len +
 				req->ie_len, GFP_KERNEL);
-		if (!local->hw_scan_req)
+		if (!local->hw_scan_req) {
+			local->scan_req = NULL;
+			local->scan_sdata = NULL;
 			return -ENOMEM;
+		}
 
 		local->hw_scan_req->ssids = req->ssids;
 		local->hw_scan_req->n_ssids = req->n_ssids;
@@ -366,14 +377,6 @@ static int __ieee80211_start_scan(struct
 		local->hw_scan_band = 0;
 	}
 
-	local->scan_req = req;
-	local->scan_sdata = sdata;
-
-	if (!list_empty(&local->work_list)) {
-		/* wait for the work to finish/time out */
-		return 0;
-	}
-
 	if (local->ops->hw_scan)
 		__set_bit(SCAN_HW_SCANNING, &local->scanning);
 	else


