Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56604 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933662Ab1LGQlZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Dec 2011 11:41:25 -0500
Subject: Re: [PATCH V2] cfg80211: Fix race in bss timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1323275338-9363-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1323275338-9363-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Dec 2011 17:41:17 +0100
Message-ID: <1323276077.3404.46.camel@jlt3.sipsolutions.net> (sfid-20111207_174137_491886_CDFF9110)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-12-07 at 21:58 +0530, Vasanthakumar Thiagarajan wrote:
> It is quite possible to run into a race in bss timeout where
> the drivers see the bss entry just before notifying cfg80211
> of a roaming event but it got timed out by the time rdev->event_work
> got scehduled from cfg80211_wq. This would result in the following
> WARN-ON() along with the failure to notify the user space of
> the roaming. The other situation which is happening with ath6kl
> that runs into issue is when the driver reports roam to same AP
> event where the AP bss entry already got expired. To fix this,
> move cfg80211_get_bss() from __cfg80211_roamed() to cfg80211_roamed().
> 
> [158645.538384] WARNING: at net/wireless/sme.c:586
> __cfg80211_roamed+0xc2/0x1b1()
> [158645.538810] Call Trace:
> [158645.538838]  [<c1033527>] warn_slowpath_common+0x65/0x7a
> [158645.538917]  [<c14cfacf>] ? __cfg80211_roamed+0xc2/0x1b1
> [158645.538946]  [<c103354b>] warn_slowpath_null+0xf/0x13
> [158645.539055]  [<c14cfacf>] __cfg80211_roamed+0xc2/0x1b1
> [158645.539086]  [<c14beb5b>] cfg80211_process_rdev_events+0x153/0x1cc
> [158645.539166]  [<c14bd57b>] cfg80211_event_work+0x26/0x36
> [158645.539195]  [<c10482ae>] process_one_work+0x219/0x38b
> [158645.539273]  [<c14bd555>] ? wiphy_new+0x419/0x419
> [158645.539301]  [<c10486cb>] worker_thread+0xf6/0x1bf
> [158645.539379]  [<c10485d5>] ? rescuer_thread+0x1b5/0x1b5
> [158645.539407]  [<c104b3e2>] kthread+0x62/0x67
> [158645.539484]  [<c104b380>] ? __init_kthread_worker+0x42/0x42
> [158645.539514]  [<c151309a>] kernel_thread_helper+0x6/0xd
> 
> Reported-by: Kalle Valo <kvalo@qca.qualcomm.com>
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

> @@ -624,32 +617,57 @@ void cfg80211_roamed(struct net_device *dev,
>  		     const u8 *resp_ie, size_t resp_ie_len, gfp_t gfp)
>  {
>  	struct wireless_dev *wdev = dev->ieee80211_ptr;
> +	struct cfg80211_bss *bss;
> +
> +	CFG80211_DEV_WARN_ON(wdev->sme_state != CFG80211_SME_CONNECTED);
> +
> +	bss = cfg80211_get_bss(wdev->wiphy, channel, bssid, wdev->ssid,
> +			       wdev->ssid_len, WLAN_CAPABILITY_ESS,
> +			       WLAN_CAPABILITY_ESS);
> +	if (WARN_ON(!bss))
> +		return;
> +
> +	cfg80211_roamed_bss(dev, bss, req_ie, req_ie_len, resp_ie,
> +			    resp_ie_len, gfp);

Technically, you don't need either of these warnings since you call
cfg80211_roamed_bss() which checks, but I don't really care or mind.

johannes

