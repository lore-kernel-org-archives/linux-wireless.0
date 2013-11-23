Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:43038 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab3KWJj2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Nov 2013 04:39:28 -0500
Received: by mail-wi0-f171.google.com with SMTP id ca18so1736484wib.10
        for <linux-wireless@vger.kernel.org>; Sat, 23 Nov 2013 01:39:26 -0800 (PST)
Date: Sat, 23 Nov 2013 10:38:44 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] mac80211_hwsim: claim CSA support for AP
Message-ID: <20131123093844.GA3895@magnum.frso.rivierawaves.com> (sfid-20131123_103935_321128_2B138D54)
References: <1385111186-19551-1-git-send-email-karl.beldan@gmail.com>
 <20131122104527.GD8527@magnum.frso.rivierawaves.com>
 <201311221308.11994.sw@simonwunderlich.de>
 <20131122140533.GA24796@magnum.frso.rivierawaves.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20131122140533.GA24796@magnum.frso.rivierawaves.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 22, 2013 at 03:05:33PM +0100, Karl Beldan wrote:
> On Fri, Nov 22, 2013 at 01:08:11PM +0100, Simon Wunderlich wrote:
> > Hello Karl,
> > 
> > > 
> > > Hmm, I thought the CSA code would make ieee80211_beacon_get_tim return
> > > NULL (or do something alike) after the last ieee80211_beacon_get_tim
> > > returned a beacon with a null CSA count until the config is done - but
> > > it seems it doesn't - in that case this change would be race prone.
> > > Did I miss something ?
> > 
> > No, you have to do the check yourself (as you appearently did). In ath9k I'm 
> > checking if the CSA finished before scheduling the next beacon. Can you do the 
> > same for hwsim? Where do you see the race?
> > 
> Hi Simon,
> 
> I would see a race in such scenario: {{{
> cmd: stack/channel_switch(count=1);
> 
> bcn-intr: driver/beacon_get();
> 	vif->csa_active  == true
> 	ieee80211_csa_is_complete(); // == true
> 		ieee80211_csa_finish(); // schedules csa work
> 
> bcn-intr: driver/beacon_get(); // beacon but on the old channel
> 	vif->csa_active  still true
> 	ieee80211_csa_is_complete(); // still true
> 
> csa worker: csa_finalize_work(); ----> too late
> 		change_channel(); ----> too late
> }}}
> 
> To prevent this, I thought that there was something like : {{{
> 
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 3e2dfcb..97b0382 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -2405,7 +2405,7 @@ void ieee80211_csa_finish(struct ieee80211_vif *vif)
>  }
>  EXPORT_SYMBOL(ieee80211_csa_finish);
>  
> -static void ieee80211_update_csa(struct ieee80211_sub_if_data *sdata,
> +static bool ieee80211_update_csa(struct ieee80211_sub_if_data *sdata,
>  				 struct beacon_data *beacon)
>  {
>  	struct probe_resp *resp;
> @@ -2428,14 +2428,14 @@ static void ieee80211_update_csa(struct ieee80211_sub_if_data *sdata,
>  		beacon_data_len = beacon->head_len;
>  		break;
>  	default:
> -		return;
> +		return false;
>  	}
>  	if (WARN_ON(counter_offset_beacon >= beacon_data_len))
> -		return;
> +		return false;
>  
>  	/* warn if the driver did not check for/react to csa completeness */
>  	if (WARN_ON(beacon_data[counter_offset_beacon] == 0))
> -		return;
> +		return false;
>  
>  	beacon_data[counter_offset_beacon]--;
>  
> @@ -2446,11 +2446,13 @@ static void ieee80211_update_csa(struct ieee80211_sub_if_data *sdata,
>  		/* if nl80211 accepted the offset, this should not happen. */
>  		if (WARN_ON(!resp)) {
>  			rcu_read_unlock();
> -			return;
> +			return true;
>  		}
>  		resp->data[counter_offset_presp]--;
>  		rcu_read_unlock();
>  	}
> +
> +	return true;
>  }
>  
>  bool ieee80211_csa_is_complete(struct ieee80211_vif *vif)
> @@ -2540,7 +2542,8 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
>  
>  		if (beacon) {
>  			if (sdata->vif.csa_active)
> -				ieee80211_update_csa(sdata, beacon);
> +				if (!ieee80211_update_csa(sdata, beacon))
> +					goto out;
>  
>  ... blah blah for mesh .. ibss ..
> }}}
> ..  Of course there are other means to achieve this, just an example.
> 
> However I might have overlooked some things in the CSA code so ..
> 
Sorry, I was not very clear.
What I meant is that, my change for hwsim is not correct because it
assumed something like what's above that would prevent beacon_get() to
return a beacon when csa is under completion. Instead, it should check
for csa completion prior to getting the beacon.

Checking your ath9k change for CSA, I am under the impression this is
possible ? : {{{
ath9k_channel_switch_beacon()
ath9k_beacon_tasklet()
        ath9k_csa_is_finished() // ret false
..
ath9k_beacon_tasklet()
        ath9k_csa_is_finished() // sets sc->csa_vif to NULL, ret true
                ieee80211_csa_finish() // schedules csa work

ath9k_beacon_tasklet()
        ath9k_csa_is_finished() // ret false because sc->csa_vif==NULL

csa_finalize_work() // too late
}}}

 
Karl
