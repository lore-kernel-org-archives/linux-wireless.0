Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:54945 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751515AbdJ1VcV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 28 Oct 2017 17:32:21 -0400
Received: by mail-wm0-f54.google.com with SMTP id r68so9496373wmr.3
        for <linux-wireless@vger.kernel.org>; Sat, 28 Oct 2017 14:32:20 -0700 (PDT)
Subject: Re: Commit 0711d638 breaks mwifiex
To: Johannes Berg <johannes@sipsolutions.net>,
        Brian Norris <briannorris@chromium.org>
Cc: Jesse Sung <jesse.sung@canonical.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ilan Peer <ilan.peer@intel.com>,
        Anthony Wong <anthony.wong@canonical.com>,
        Jason Yen <jason.yen@canonical.com>, Terry.Wey@dell.com,
        linux-wireless@vger.kernel.org, Ganapathi Bhat <gbhat@marvell.com>
References: <CAH10aOifYo=g8oLC3D=QcmVw28EqNotxuNRsprJGNP5ceEYLag@mail.gmail.com>
 <1508233890.10607.70.camel@sipsolutions.net>
 <CAH10aOj8xTPDyEufGS47hytnT8RSL+qSbiRVmePrMpaaUu7gPQ@mail.gmail.com>
 <1508237298.10607.76.camel@sipsolutions.net>
 <20171026211313.GA46251@google.com>
 <1509135034.2283.8.camel@sipsolutions.net>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <98bea6e4-146e-4fdf-77fc-1c53d40088e7@broadcom.com> (sfid-20171028_233226_144506_63191432)
Date: Sat, 28 Oct 2017 23:32:18 +0200
MIME-Version: 1.0
In-Reply-To: <1509135034.2283.8.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27-10-17 22:10, Johannes Berg wrote:
> Hi,
> 
>> IIUC, mwifiex hasn't told the firmware to do anything at this point --
>> the -EALREADY check is practically the first thing it does within
>> connect(). So it just quits the connect() request and tries to carry on
>> as usual. It will only do something different if the upper layers tell
>> it to do so afterward (e.g., calling disconnect()).
> 
> Yeah, that makes sense.
> 
>> Yes, that's definitely what's happening. And it's explicitly called out
>> in the supplicant's nl80211 driver that this is intentional:
>>
>> [...]
> 
> Right.
> 
>> This is the main code path for supplicant commands like "Reattach",
>> which boil down to (for non SME drivers):
>>
>> wpas_request_connection()
>>    ...
>>   -> wpa_supplicant_connect()
>>     -> wpa_supplicant_associate()
>>       -> wpas_start_assoc_cb()
>>         -> wpa_drv_associate()
>>           -> wpa_driver_nl80211_associate()
>>             -> wpa_driver_nl80211_connect()
>>
>> Now for the part I'm not so familiar with: is this really the *expected*
>> flow for full-MAC drivers in reattach, reassociate, and roaming flows?
>> All of those seem to boil down to this same connect() (and fallback to
>> disconnect()+connect() if -EALREADY) flow.
> 
> We never implemented a "ROAM" command, so there's not all that much
> choice.
> 
>> But it doesn't seem like all full-MAC drivers do the same thing. Some
>> seem to just blaze ahead with a connect attempt (maybe some firmwares
>> automatically interpret this for us?) and never return -EALREADY at all.
> 
> Agree, some seem to just do some form of roaming on this, which really
> just means they disconnect internally - or perhaps they even try to
> roam if it's the same network?
> 
>> Sorry if this is slightly off-topic, but I'm trying to understand what
>> the general expectations are here, based on my relatively narrow
>> experience with a few drivers.
> 
> I don't really know either! There aren't that many direct cfg80211
> drivers that don't use mac80211, so there's not that much experience.
> 
> You're probably well positioned to say what the behaviour _should_ be
> though? :-)
> 
> I tend to think we should actually do the EALREADY from cfg80211, so
> that wpa_s will always be forced to go through this roundabout code
> path, but also finally implement a ROAM command, to let drivers have
> that option?
> 
> Note also that we've always sort of envisioned that drivers
> implementing CONNECT would do BSS selection themselves, but I think
> there's no automatic way of doing that with wpa_s, and it may not even
> be desirable in many cases (unless you really need the power saving
> advantage) since it gets us into a situation where we have all these
> different algorithms etc.

wpa_s can issue a CONNECT without bssid (nor bssid_hint) leaving it up 
to the driver to select the BSS. I am pretty sure I hit that scenario 
although not sure what exact criteria are for wpa_s. Maybe it depended 
on WIPHY_FLAG_SUPPORTS_FW_ROAM.

Regarding BSS selection I added bss_select feature. An effort which 
actually was triggered by a chromebook project. Guess the number of 
drivers implementing that can be counted on one ...finger ;-)

Regards,
Arend
