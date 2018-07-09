Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:55532 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754398AbeGIJCk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jul 2018 05:02:40 -0400
Message-ID: <1531126957.3298.23.camel@sipsolutions.net> (sfid-20180709_110250_735518_F6254703)
Subject: Re: [PATCH] mac80211: restrict delayed tailroom needed decrement
From: Johannes Berg <johannes@sipsolutions.net>
To: Manikanta Pubbisetty <mpubbise@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 09 Jul 2018 11:02:37 +0200
In-Reply-To: <1531126681-5146-1-git-send-email-mpubbise@codeaurora.org>
References: <1531126681-5146-1-git-send-email-mpubbise@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-07-09 at 14:28 +0530, Manikanta Pubbisetty wrote:
> As explained in ieee80211_delayed_tailroom_dec(), during roam,
> keys of the old AP will be destroyed and new keys will be
> installed. Deletion of the old key causes
> crypto_tx_tailroom_needed_cnt to go from 1 to 0 and the new key
> installation causes a transition from 0 to 1.
> 
> Whenever crypto_tx_tailroom_needed_cnt transitions from 0 to 1,
> we invoke synchronize_net(); the reason for doing this is to avoid
> a race in the TX path as explained in increment_tailroom_need_count().
> This synchronize_net() operation can be slow and can affect the station
> roam time. To avoid this, decrementing the crypto_tx_tailroom_needed_cnt
> is delayed for a while so that upon installation of new key the
> transition would be from 1 to 2 instead of 0 to 1 and thereby
> improving the roam time.

Right.

> This is all correct for a STA iftype, but deferring the tailroom_needed
> decrement for other iftypes may be incorrect.

I don't understand this. What do you mean by "incorrect"?

> For example, let's consider the case of a 4-addr client connecting to
> an AP for which AP_VLAN interface is also created, let the initial
> value for tailroom_needed on the AP be 1.
> 
> * 4-addr client connects to the AP (AP: tailroom_needed = 1)
> * AP will clear old keys, delay decrement of tailroom_needed count
> * AP_VLAN is created, it takes the tailroom count from master
>   (AP_VLAN: tailroom_needed = 1, AP: tailroom_needed = 1)
> * Install new key for the station, assume key is plumbed in the HW,
>   there won't be any change in tailroom_needed count on AP iface
> * Delayed decrement of tailroom_needed count on AP
>   (AP: tailroom_needed = 0, AP_VLAN: tailroom_needed = 1)
> 
> Because of the delayed decrement on AP iface, tailroom_needed count goes
> out of sync between AP(master iface) and AP_VLAN(slave iface) and
> there would be unnecessary tailroom created for the packets going
> through AP_VLAN iface.

This describes a scenario where there's *unnecessary* work done, but not
really one where we have something that's *incorrect*?

Are you saying that you found a problem with this? Did this show up in
some sort of measurements?

> +++ b/net/mac80211/key.c
> @@ -583,7 +583,8 @@ static void __ieee80211_key_destroy(struct ieee80211_key *key,
>  
>  		ieee80211_debugfs_key_remove(key);
>  
> -		if (delay_tailroom) {
> +		if (delay_tailroom &&
> +		    sdata->vif.type == NL80211_IFTYPE_STATION) {
>  			/* see ieee80211_delayed_tailroom_dec */
>  			sdata->crypto_tx_tailroom_pending_dec++;
>  			schedule_delayed_work(&sdata->dec_tailroom_needed_wk,

I think you'd better change the caller, i.e. ieee80211_del_key(), and a
add a comment there that explains what's going on.

But I'm not yet really sure what you're trying to do :-)

johannes
