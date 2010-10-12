Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57626 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756705Ab0JLCKq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 22:10:46 -0400
Message-ID: <4CB3C3A3.5040309@candelatech.com>
Date: Mon, 11 Oct 2010 19:10:43 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Bruno Randolf <br1@einfach.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ath5k:  Adjust opmode when interfaces are removed.
References: <1286564475-10105-1-git-send-email-greearb@candelatech.com> <201010121044.39093.br1@einfach.org>
In-Reply-To: <201010121044.39093.br1@einfach.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/11/2010 06:44 PM, Bruno Randolf wrote:
> On Sat October 9 2010 04:01:15 greearb@candelatech.com wrote:

>> +
>> +	/* Calculate combined mode - when APs are active, operate in AP mode.
>> +	 * Otherwise use the mode of the new interface. This can currently
>> +	 * only deal with combinations of APs and STAs. Only one ad-hoc
>> +	 * interfaces is allowed above.
>
> the comment reference to "above" does not make sense here any more.

This patch is already in..but I can send a followup cleanup patch.


>
>> +	 */
>> +	if (avf->opmode == NL80211_IFTYPE_AP)
>> +		iter_data->opmode = NL80211_IFTYPE_AP;
>> +	else
>> +		if (iter_data->opmode == NL80211_IFTYPE_UNSPECIFIED)
>> +			iter_data->opmode = avf->opmode;
>>   }
>>
>> -void ath5k_update_bssid_mask(struct ath5k_softc *sc, struct ieee80211_vif
>> *vif) +static void ath_do_set_opmode(struct ath5k_softc *sc)
>> +{
>> +	struct ath5k_hw *ah = sc->ah;
>> +	ath5k_hw_set_opmode(ah, sc->opmode);
>> +	ATH5K_DBG(sc, ATH5K_DEBUG_MODE, "mode setup opmode %d (%s)\n",
>> +		  sc->opmode,
>> +		  ath_opmode_to_string(sc->opmode) ?
>> +		  ath_opmode_to_string(sc->opmode) : "UKNOWN");
>> +}
>
> what's the point of this function? just to add the debug print?

Yes.  At one point, I had it being called from several places..but now it's
called from only one place currently, I think.  I could make it explicitly
inline code if someone cared.

>> -	/* Set combined mode - when APs are configured, operate in AP mode.
>> -	 * Otherwise use the mode of the new interface. This can currently
>> -	 * only deal with combinations of APs and STAs. Only one ad-hoc
>> -	 * interfaces is allowed above.
>> -	 */
>> -	if (sc->num_ap_vifs)
>> -		sc->opmode = NL80211_IFTYPE_AP;
>> -	else
>> -		sc->opmode = vif->type;
>> -
>> -	ath5k_hw_set_opmode(ah, sc->opmode);
>> -
>
> i think it makes sense to set the opmode here. and also do the same in
> ath5k_remove_interface. that way we figure out the opmode when interfaces are
> added/removed.

It calls ath5k_mode_setup(sc, vif), which sets rx filter, updates bssid mask,
and sets the opmode.


>> @@ -2905,7 +2919,7 @@ ath5k_remove_interface(struct ieee80211_hw *hw,
>>   	else if (avf->opmode == NL80211_IFTYPE_ADHOC)
>>   		sc->num_adhoc_vifs--;
>>
>> -	ath5k_update_bssid_mask(sc, NULL);
>> +	ath5k_update_bssid_mask_and_opmode(sc, NULL);
>>   	mutex_unlock(&sc->lock);

And that recalculates opmode and bssid mask on removal.

Or maybe I'm mis-understanding your suggestion?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
