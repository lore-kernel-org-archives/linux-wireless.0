Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:42331 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbeGKTtS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jul 2018 15:49:18 -0400
Received: by mail-oi0-f66.google.com with SMTP id n84-v6so51433461oib.9
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jul 2018 12:43:28 -0700 (PDT)
Subject: Re: [PATCH v2] mac80211: Fix wlan freezes under load at rekey
To: Alexander Wetzel <alexander.wetzel@web.de>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, greearb@candelatech.com,
        s.gottschall@dd-wrt.com
References: <1523258757.3076.5.camel@sipsolutions.net>
 <20180515102202.2021-1-alexander.wetzel@web.de>
 <1529062392.10037.7.camel@sipsolutions.net>
 <bc327c9b-d5f4-2343-9ca5-932e9295c546@web.de>
 <1529357234.3092.57.camel@sipsolutions.net>
 <2de1493a-5439-b9ef-6d06-3895333f01c3@web.de>
 <1530267147.3481.78.camel@sipsolutions.net>
 <bb4d75d3-7f90-1b58-9525-3f5a54cd952e@web.de>
 <1530611484.4735.18.camel@sipsolutions.net>
 <b1913512-7d33-cd9b-5eb5-4d7f367eb41a@web.de>
 <1530662787.4735.59.camel@sipsolutions.net>
 <da9c6878-56ff-3a63-07cf-dae7813173a2@web.de>
 <1139d0cb-28dc-53d2-5371-44dc82fda2db@gmail.com>
 <3c5c2e73-d529-fbd8-ac43-d5ee078643e6@web.de>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <bf8f184a-debb-e6c1-cded-35a89a3fc9e0@gmail.com> (sfid-20180711_214334_136005_FFF04751)
Date: Wed, 11 Jul 2018 14:43:26 -0500
MIME-Version: 1.0
In-Reply-To: <3c5c2e73-d529-fbd8-ac43-d5ee078643e6@web.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Alexander,

On 07/11/2018 12:08 PM, Alexander Wetzel wrote:
> Hi Denis,
> 
>> Hi Alexander,
>>
>>>>> hostapd or wpa_supplicant are "ordering" mac80211 to install a new key
>>>>> and are implementing the state machine and are in a good position to
>>>>> handle the fallout... at least theoretically.
>>>>
>>>> Ideally it would even know beforehand that we don't want to handle the
>>>> PTK rekeying, and then could reconnect instead of going through the
>>>> handshake.
>>>>
>>>
>>> Don't see how we could do that in the kernel, all the relevant
>>> information is handled in the state machine. I guess an API extension
>>> telling hostap/supplicant if we can handle rekeys or not would tbe he
>>> only way to avoid that.
>>>
>>
>> Can the kernel / driver provide some sort of hint to user space that PTK
>> rekey isn’t supported?  We could then have user space deauthenticate
>> with a big warning about what/why this is happening and try to
>> re-connect to the last used BSS.
>>
> 
> Sure. In fact the latest patch is already doing that by returning an
> error when set_key is called for PTK and it's not an initial call.
> Tests with wpa_supplicant shows that this is is then handled like the
> initial key set is failing. Networkmanager prompts for the password and
> wpa_supplicant running without seems to blacklist a reconnect for 15s.

Ideally we shouldn't even get this far.  We really need some kind of 
capability bit on the phy telling userspace whether PTK rekey is 
supported or not.  Then userspace can take proper action based on this 
information.  E.g. if PTK rekey isn't safe, then we can simply issue a 
CMD_DISCONNECT and re-connect to the last BSS.  The kernel doesn't need 
to play any 'tricks'.

The fact that current userspace implementations are broken is 
regrettable and needs to be fixed.

> 
> I kind of liked that solution, but with existing implematations out this
> is indeed awkward to find a "correct" solution.
> 
> The main problem for me currently is to find a correct and still
> acceptable solution. This turned from "let's fix this nasty wlan
> connection freezes" to a projet spanning the complete wlan stack: From
> hardware up to and including the userspace...

Right.  The problem is that this PTK rekey likely 'works' (for some 
definition thereof) in a vast majority of cases, e.g. the link isn't 
broken, so the user doesn't notice.  So, if the kernel starts to 
unilaterally issue disconnects, you will have a lot of grumbling users.

Just to clarify, I'm not arguing against this necessarily.  I can see 
why issuing a disconnect is a good idea for many reasons (e.g. security, 
etc.)  But, I would expect a lot of user backlash if this is done, and 
given that this has been an issue for many years, I wonder if its the 
right way of handling this?

> 
> It's fun to learn how that interacts (if not very fast), I'm stuggling
> finding the best way forward here. Whatever we do has undesired
> consequences.
> Maybe I'm missing something, but here the high level options we have in
> my opinion:
> 
> 1) Keep it as it is and solve that in a indefinite future when we and
> the world implement the ieee802.11 2012 addition, to use key 0+1 for PTK
> and 2+3 for GTK
> - rekey has a extrem high probability of freezing connections and
> leaking a few clear text packets for years (decades?) to come
> + The issue is fixed at the core

It would seem to me that 0+1 rekey is a separate issue that needs to be 
supported in both kernel and userspace anyway.

> 
> 2) Make it worse, like some (most) Windows systems/cards seem to handle
> it by encrypting EAPOL #4 with the NEW key, breaking the handshake and
> forcing a reconnect.
> - break something more to fix a problem sounds like a insane approach
> + This seems to be quite common and therefore well "tested" (based on my
> very limited data on that)

This seems awful.  And then if you're unlucky someone will come in and 
tell you that the kernel has to maintain this 'legacy' behavior forever. 
  So things can't ever be fixed.

Plus, as I already mentioned above, some users 'think' that PTK rekey 
already works just fine.

> 
> 3) Fix what we can in mac80211 but keep the API stable
> - Without driver actions still many drivers will be "undefined" and even
> if they are not freezing leak packets
> + This will reduce the problems to a fraction of what is is today with
> only a mac80211 update
> 
> 4) Redesign the mac80211 rekey handling and interaction with drivers to
> only rekey if it is save and decline when not.
> + We only have to touch the kernel
> - any supplicant (whatever runs the wpa state machine) may get errors
> where the programmes did not expect them, leading to unexpected side
> effects.
> 
> 5) The full-stack solution: Update the API for the userpace
> + We do not have to "trick" the wpa state machine to disconnect, the
> programmers of it have to code it.
> - Well, it must be suppurted from the wpa state machine. If not we still
> have to handle the rekey somehow or we accept freezes/cleartext leaks...
> 
> The last two solutions will also need some "fallback" when a secure
> rekey is not possible and/or the user is runing an old state machine not
> knowing about the new way...
> 

My vote is for something along the lines of 5.  I realize there are no 
good solutions here, but this really should be fixed by a combination of 
userspace and kernel working properly together.  If this isn't possible, 
then perhaps the whole rekey should be done in the kernel and userspace 
should be given no chance to make a bad decision.

> 
>>>> So I think we're probably better off accepting the set_key but not
>>>> actually using it, and instead disconnecting... even if that's awkward
>>>> and should come with a big comment :-)
>>>
>>> Instead of returning an error I'll change the code to accept the rekey
>>> but do nothing with it. (Basically delete the new key and keep the old
>>> active).
>>> And of course calling ieee80211_set_disassoc() prior to return "success".
>>>
>>> Let's see how the supplicant will react on a disassoc while doing a
>>> rekey...
>>>
>>
>> This sounds pretty awful actually.  Now that wpa_s is not the only game
>> in town, can we stop resorting to these tactics?
> 
> Nothing of it is wpa_supplicat/hostap specifiy. Only my current "test"
> environment is using it, simply due to the fact that I tracked the issue
> down in that environment.
> Everything besides ath9k as an AP running hostapd and a iwldvm card
> running wpa_supplicant is mostly untested. And even there I have some
> areas marked for follow up after we find a solution acceptable for the
> kernel...
> 
> Do you have any other software you think I should add to my prelimitary
> tests? If possible I'll happy to extend the test of the patches with those.
> 

You can try:
https://git.kernel.org/pub/scm/network/wireless/iwd.git/

We would be happy to implement whatever 'proper' userspace behavior / 
kernel api that this discussion leads to.

Regards,
-Denis
