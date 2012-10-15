Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38379 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab2JOLCt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 07:02:49 -0400
Message-ID: <1350299004.27801.4.camel@jlt4.sipsolutions.net> (sfid-20121015_130253_529671_84021D2F)
Subject: Re: unloading WiFi modules is usually triggering kernel crash
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Pedro Francisco <pedrogfrancisco@gmail.com>,
	ML linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 15 Oct 2012 13:03:24 +0200
In-Reply-To: <20121012121333.GA30816@redhat.com>
References: <CAJZjf_wv=+HKLwnH-=rvx9h=0jEGzoCrd-a8GOW-QnXfOVgc_g@mail.gmail.com>
	 <20120807102208.GA12589@redhat.com>
	 <CAJZjf_xVOKjVYYXxsWf6Z+KaTDi_3ZDqvBMyzMETfbkpWUgWFQ@mail.gmail.com>
	 <CAJZjf_xVzQmpLHd=KQ0qc77QxdpE0a7xjGTNo2Sw6BM8miwe7A@mail.gmail.com>
	 <20121003143029.GF2259@redhat.com>
	 <CAJZjf_xZC2473B2SQAKFfc7m6SSeEK7z7N-GaUsZUNV-K9c=Ww@mail.gmail.com>
	 <20121012121333.GA30816@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-10-12 at 14:13 +0200, Stanislaw Gruszka wrote:
> On Tue, Oct 09, 2012 at 10:14:40AM +0100, Pedro Francisco wrote:
> > So, I'm guessing this means it is related to what you found on iwlwifi
> > (even if I'm on iwlegacy)?
> 
> Yes, this seems to be cfg80211 problem. I think crash happen because
> cfg80211 is in disassociate state (i.e. has wdev->current_bss NULL) and
> erroneously mac80211 stays in associate state. So while we unload
> module cfg80211_mlme_down() we do not call ieee80211_deauth().
> 
> I think this state mishmash happens because wrong behaviour on
>  __cfg80211_mlme_deauth(). Below patch try to correct that.
> Can you check if it prevent a crash? On my environment I can 
> not reproduce this problem reliably.

Ugh, yeah, what was I thinking with the code below ... ??


> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index ab78b53..9b99b60 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -1218,6 +1218,7 @@ struct cfg80211_deauth_request {
>  	const u8 *ie;
>  	size_t ie_len;
>  	u16 reason_code;
> +	bool local_state_change;
>  };
>  
>  /**
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index e714ed8..e510a33 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -3549,6 +3549,7 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
>  {
>  	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
>  	u8 frame_buf[IEEE80211_DEAUTH_FRAME_LEN];
> +	bool tx = !req->local_state_change;
>  
>  	mutex_lock(&ifmgd->mtx);
>  
> @@ -3565,12 +3566,12 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
>  	if (ifmgd->associated &&
>  	    ether_addr_equal(ifmgd->associated->bssid, req->bssid)) {
>  		ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
> -				       req->reason_code, true, frame_buf);
> +				       req->reason_code, tx, frame_buf);
>  	} else {
>  		drv_mgd_prepare_tx(sdata->local, sdata);
>  		ieee80211_send_deauth_disassoc(sdata, req->bssid,
>  					       IEEE80211_STYPE_DEAUTH,
> -					       req->reason_code, true,
> +					       req->reason_code, tx,
>  					       frame_buf);
>  	}
>  
> diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
> index 3df195a..4954010 100644
> --- a/net/wireless/mlme.c
> +++ b/net/wireless/mlme.c
> @@ -457,21 +457,11 @@ int __cfg80211_mlme_deauth(struct cfg80211_registered_device *rdev,
>  		.reason_code = reason,
>  		.ie = ie,
>  		.ie_len = ie_len,
> +		.local_state_change = local_state_change,
>  	};
>  
>  	ASSERT_WDEV_LOCK(wdev);
>  
> -	if (local_state_change) {
> -		if (wdev->current_bss &&
> -		    ether_addr_equal(wdev->current_bss->pub.bssid, bssid)) {
> -			cfg80211_unhold_bss(wdev->current_bss);
> -			cfg80211_put_bss(&wdev->current_bss->pub);
> -			wdev->current_bss = NULL;
> -		}
> -
> -		return 0;
> -	}
> -


This looks fine to me. Probably needs Cc: stable?

Then again, maybe if the deauth request is for a BSS that *isn't* the
current BSS we should "swallow" it in cfg80211? IOW, something like

if (local_state_change && (!wdev->current_bss ||
			   !ether_addr_equal(...))
	return 0;

since neither mac80211 nor cfg80211 track authentication... Doesn't
matter much though.

johannes

