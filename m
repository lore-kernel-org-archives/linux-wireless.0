Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:60594 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326Ab0JHSTB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 14:19:01 -0400
Message-ID: <4CAF607A.4090305@candelatech.com>
Date: Fri, 08 Oct 2010 11:18:34 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] ath5k: Adjust opmode when interfaces are removed.
References: <1286556210-29643-1-git-send-email-greearb@candelatech.com>	<1286556210-29643-2-git-send-email-greearb@candelatech.com>	<AANLkTinXFLL25-r-LUb5vqjNkwoa68xWhN_CaD0KVE=p@mail.gmail.com>	<4CAF5DB3.7070603@candelatech.com> <AANLkTi=abVBncBxEKV4oQNSSm4fS5a-qZ=a38BJRPSg_@mail.gmail.com>
In-Reply-To: <AANLkTi=abVBncBxEKV4oQNSSm4fS5a-qZ=a38BJRPSg_@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/08/2010 11:13 AM, Bob Copeland wrote:
> On Fri, Oct 8, 2010 at 2:06 PM, Ben Greear<greearb@candelatech.com>  wrote:
>> On 10/08/2010 11:03 AM, Bob Copeland wrote:
>>>
>>> On Fri, Oct 8, 2010 at 12:43 PM,<greearb@candelatech.com>    wrote:
>>>>
>>>> @@ -558,6 +577,7 @@ void ath5k_update_bssid_mask(struct ath5k_softc *sc,
>>>> struct ieee80211_vif *vif)
>>>>         memset(&iter_data.mask, 0xff, ETH_ALEN);
>>>>         iter_data.found_active = false;
>>>>         iter_data.need_set_hw_addr = true;
>>>> +       iter_data.opmode = NL80211_IFTYPE_UNSPECIFIED;
>>>>
>>>>         if (vif)
>>>>                 ath_vif_iter(&iter_data, vif->addr, vif);
>>>> @@ -567,6 +587,11 @@ void ath5k_update_bssid_mask(struct ath5k_softc *sc,
>>>> struct ieee80211_vif *vif)
>>>>                                                    &iter_data);
>>>>         memcpy(sc->bssidmask, iter_data.mask, ETH_ALEN);
>>>>
>>>> +       if (update_opmode&&    sc->opmode != iter_data.opmode) {
>>>> +               sc->opmode = iter_data.opmode;
>>>> +               ath_do_set_opmode(sc);
>>>> +       }
>>>> +
>>>
>>> Should we really couple updating bssid mask and configuring
>>> the opmode?  Generally, I dislike adding boolean flags to
>>> functions because it's hard to figure out from the callsite
>>> what is happening (you have to go back to the prototype), and
>>> it usually indicates that the abstraction is a little broken.
>>
>> Well, we need to do the iteration over all VIFS to figure out what to set
>> this
>> too.  Seems doing one iteration v/s doing two is worth the
>> extra flag?
>
> I admit I haven't looked at the context, so I'm not sure how ugly it
> is, but you can often do this kind of thing by inverting the loop:
>
> update_vif_data()
> {
>     for all vifs:
>        compute new bssid&  opmode
>
>     update_bssid(new_bssid)
>     update_opmode(neW_opmode)
> }
>
> and call that instead (even in the single vif case).

I can just always set the opmode if you prefer that.  Maybe
change the name of that method.

I'll work on a patch.

Thanks,
Ben

>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

