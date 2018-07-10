Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:40675 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732272AbeGJVNw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Jul 2018 17:13:52 -0400
Received: by mail-oi0-f65.google.com with SMTP id w126-v6so45380345oie.7
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jul 2018 14:12:59 -0700 (PDT)
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
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <1139d0cb-28dc-53d2-5371-44dc82fda2db@gmail.com> (sfid-20180710_231511_756627_56DDA513)
Date: Tue, 10 Jul 2018 16:05:34 -0500
MIME-Version: 1.0
In-Reply-To: <da9c6878-56ff-3a63-07cf-dae7813173a2@web.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Alexander,

>>> hostapd or wpa_supplicant are "ordering" mac80211 to install a new key
>>> and are implementing the state machine and are in a good position to
>>> handle the fallout... at least theoretically.
>>
>> Ideally it would even know beforehand that we don't want to handle the
>> PTK rekeying, and then could reconnect instead of going through the
>> handshake.
>>
> 
> Don't see how we could do that in the kernel, all the relevant
> information is handled in the state machine. I guess an API extension
> telling hostap/supplicant if we can handle rekeys or not would tbe he
> only way to avoid that.
> 

Can the kernel / driver provide some sort of hint to user space that PTK 
rekey isn’t supported?  We could then have user space deauthenticate 
with a big warning about what/why this is happening and try to 
re-connect to the last used BSS.

>> So I think we're probably better off accepting the set_key but not
>> actually using it, and instead disconnecting... even if that's awkward
>> and should come with a big comment :-)
> 
> Instead of returning an error I'll change the code to accept the rekey
> but do nothing with it. (Basically delete the new key and keep the old
> active).
> And of course calling ieee80211_set_disassoc() prior to return "success".
> 
> Let's see how the supplicant will react on a disassoc while doing a rekey...
> 

This sounds pretty awful actually.  Now that wpa_s is not the only game 
in town, can we stop resorting to these tactics?

Regards,
-Denis
