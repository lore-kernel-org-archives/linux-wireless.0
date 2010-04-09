Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56749 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806Ab0DIHoV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Apr 2010 03:44:21 -0400
Subject: Re: [PATCH] mac80211: Prevent starting of hw scan if it is already
 in progress
From: Johannes Berg <johannes@sipsolutions.net>
To: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1270725792-581-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
References: <1270725792-581-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Apr 2010 09:44:16 +0200
Message-ID: <1270799056.3870.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-04-08 at 14:23 +0300, Teemu Paasikivi wrote:
> Added checking of status of scanning to ieee80211_scan_work when hw
> scanning is used. It is possible to scan_work get executed while scan
> has already been started. Previously this has led to a state where, when
> the driver returned EBUSY, the stack aborted scan while hw was left
> scanning. That has caused warnings from ieee80211_scan_completed when
> the scan actually has been completed.
> 
> Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
> ---
>  net/mac80211/ieee80211_i.h |    1 +
>  net/mac80211/scan.c        |    8 +++++++-
>  2 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index 741fb8b..1d14f7c 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -756,6 +756,7 @@ struct ieee80211_local {
>  	/* Scanning and BSS list */
>  	struct mutex scan_mtx;
>  	unsigned long scanning;
> +	bool hw_scan_continue;
>  	struct cfg80211_ssid scan_ssid;
>  	struct cfg80211_scan_request *int_scan_req;
>  	struct cfg80211_scan_request *scan_req, *hw_scan_req;
> diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
> index 75a8597..4e4bad0 100644
> --- a/net/mac80211/scan.c
> +++ b/net/mac80211/scan.c
> @@ -265,12 +265,14 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
>  
>  	was_hw_scan = test_bit(SCAN_HW_SCANNING, &local->scanning);
>  	if (was_hw_scan && !aborted && ieee80211_prep_hw_scan(local)) {
> +		local->hw_scan_continue =  true;
>  		ieee80211_queue_delayed_work(&local->hw,
>  					     &local->scan_work, 0);
>  		mutex_unlock(&local->scan_mtx);
>  		return;
>  	}
>  
> +	local->hw_scan_continue = false;
>  	kfree(local->hw_scan_req);
>  	local->hw_scan_req = NULL;
>  
> @@ -652,7 +654,11 @@ void ieee80211_scan_work(struct work_struct *work)
>  	}
>  
>  	if (local->hw_scan_req) {
> -		int rc = drv_hw_scan(local, local->hw_scan_req);
> +		int rc = 0;
> +
> +		if (!local->scanning || local->hw_scan_continue)
> +			rc = drv_hw_scan(local, local->hw_scan_req);
> +

So Luis says he can make something similar happen with SW scan, where we
call drv_sw_scan_start twice?

johannes

