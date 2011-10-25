Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:41532 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755728Ab1JYPzg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 11:55:36 -0400
Date: Tue, 25 Oct 2011 18:55:27 +0300
From: Jouni Malinen <j@w1.fi>
To: Guy Eilam <guy@wizery.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 2/2] mac80211: fix race condition between assoc_done
 and first EAP packet
Message-ID: <20111025155527.GA12326@jm.kir.nu> (sfid-20111025_175539_751572_1D685F3D)
References: <1313583495-9695-1-git-send-email-guy@wizery.com>
 <1313583495-9695-2-git-send-email-guy@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1313583495-9695-2-git-send-email-guy@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 17, 2011 at 03:18:15PM +0300, Guy Eilam wrote:
> Allocation of the relevant station info struct before actually
> sending the association request and setting it with a new
> dummy_sta flag solve this problem.

> This dummy station entry is not seen by normal sta_info_get()
> calls, only by sta_info_get_bss_rx().
> The driver is not notified for the first insertion of the
> dummy station. The driver is notified only after the association
> is complete and the dummy flag is removed from the station entry.

I'm seeing issues with that dummy entry not getting removed and every
consecutive association attempt failing since ieee80211_pre_assoc()
fails to insert the new dummy station entry (sta_info_insert() returns
-EEXIST).

This happens at least in the case where association comeback mechanism
is used and the association fails:

[17726.918932] wlan0: authenticate with 00:03:7f:12:2a:14 (try 1)
[17726.921063] wlan0: authenticated
[17726.921079] ieee80211 phy0: device now idle
[17726.922992] ieee80211 phy0: Allocated STA 00:03:7f:12:2a:14
[17726.923000] ieee80211 phy0: Inserted dummy STA 00:03:7f:12:2a:14
[17726.930772] ieee80211 phy0: device no longer idle - working
[17726.941184] wlan0: associate with 00:03:7f:12:2a:14 (try 1)
[17726.945652] wlan0: RX ReassocResp from 00:03:7f:12:2a:14 (capab=0x411 status=30 aid=1)
[17726.945657] wlan0: 00:03:7f:12:2a:14 rejected association temporarily; comeback duration 1000 TU (1024 ms)
[17727.968031] wlan0: associate with 00:03:7f:12:2a:14 (try 2)
[17727.970915] wlan0: deauthenticated from 00:03:7f:12:2a:14 (Reason: 6)

Note: There is no "Removed STA" message here, i.e., __sta_info_destroy()
does not get called because we do not get to the ieee80211_assoc_done()
work in this case.. Is that the main issue here? Or should that dummy
STA entry be removed somewhere else in this type of case? Or should
ieee80211_pre_assoc() just accept -EEXIST and allow the new association
to continue?

The next connection attempt fails:

[18016.942906] wlan0: authenticate with 00:03:7f:12:2a:14 (try 1)
[18016.945114] wlan0: authenticated
[18016.945130] ieee80211 phy0: device now idle
[18016.945344] ieee80211 phy0: Allocated STA 00:03:7f:12:2a:14
[18016.945353] ieee80211 phy0: Destroyed STA 00:03:7f:12:2a:14
[18016.945356] wlan0: failed to insert Dummy STA entry for the AP (error -17)

and the dummy entry gets finally removed only when the interface is set
down:

[18036.716235] wlan0: deauthenticating from 00:03:7f:12:2a:14 by local choice (reason=3)
[18036.780038] ieee80211 phy0: Removed STA 00:03:7f:12:2a:14
[18036.780050] ieee80211 phy0: Destroyed STA 00:03:7f:12:2a:14

> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index d6470c7..60a6f27 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
>  
> +/* create and insert a dummy station entry */
> +static int ieee80211_pre_assoc(struct ieee80211_sub_if_data *sdata,
> +				u8 *bssid) {
> +	struct sta_info *sta;
> +	int err;
> +
> +	sta = sta_info_alloc(sdata, bssid, GFP_KERNEL);
> +	if (!sta) {
> +		printk(KERN_DEBUG "%s: failed to alloc STA entry for"
> +			   " the AP\n", sdata->name);
> +		return -ENOMEM;
> +	}
> +
> +	sta->dummy = true;
> +
> +	err = sta_info_insert(sta);
> +	sta = NULL;
> +	if (err) {
> +		printk(KERN_DEBUG "%s: failed to insert Dummy STA entry for"
> +		       " the AP (error %d)\n", sdata->name, err);
> +		return err;
> +	}

This is the place where the consecutive connections fail..

> @@ -2468,12 +2501,16 @@ static enum work_done_result ieee80211_assoc_done(struct ieee80211_work *wk,
>  		if (!ieee80211_assoc_success(wk, mgmt, skb->len)) {
>  			mutex_unlock(&wk->sdata->u.mgd.mtx);
>  			/* oops -- internal error -- send timeout for now */
> +			sta_info_destroy_addr(wk->sdata, cbss->bssid);
>  			cfg80211_send_assoc_timeout(wk->sdata->dev,
>  						    wk->filter_ta);
>  			return WORK_DONE_DESTROY;
>  		}
>  
>  		mutex_unlock(&wk->sdata->u.mgd.mtx);
> +	} else {
> +		/* assoc failed - destroy the dummy station entry */
> +		sta_info_destroy_addr(wk->sdata, cbss->bssid);
>  	}

And this is the place where I guess the dummy entry was supposed to get
removed, but it wasn't in the assoc comeback case.

This makes it quite painful to run any IEEE 802.11w testing.. Making
ieee80211_pre_assoc() ignore EEXIST works around the issues, but a more
proper fix could be to make sure that the dummy entry gets removed when
we stop trying to associate in whatever ways that may happen.

-- 
Jouni Malinen                                            PGP id EFC895FA
