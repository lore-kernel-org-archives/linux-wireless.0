Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:35870 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752478AbcIAUz5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Sep 2016 16:55:57 -0400
Subject: Re: Ath10k probe response error related to mac80211 commit.
To: Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <cf9852df-6d14-baf6-af0a-9cc78c448fde@candelatech.com>
 <1472752911.9608.11.camel@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <c7eb32b4-84c5-41ae-1fe6-89df7cbbe7d4@candelatech.com> (sfid-20160901_225605_420948_427DBF6F)
Date: Thu, 1 Sep 2016 11:23:50 -0700
MIME-Version: 1.0
In-Reply-To: <1472752911.9608.11.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/01/2016 11:01 AM, Johannes Berg wrote:
>
>> If someone has any idea of why this patch might trigger it, please
>> let me know.
>> I'll keep digging in the meantime...
>>
>>      Revert "mac80211: don't advertise NL80211_FEATURE_FULL_AP_CLIENT_STATE"
>>
>
> With a sufficiently recent hostapd/wpa_supplicant, the patch will cause
> a station entry to be added to the firmware before sending the
> authentication frame.
>
> Why, of all frames, probe response frames should be corrupted I don't
> know - I could imagine auth/assoc replies being treated differently
> since they are now with a station entry rather than without.

Could easily be that others are corrupted too, but since probe resp is bad,
the association will not proceed.

>
>> This only breaks AP mode (station mode works fine).
>
> It also has no impact on anything but AP mode, as even indicated by the
> name of the flag :)

Heh, I spent 4 days tracking this down, so I wanted to be precise in
my bug report :)

> Anyway, I was pretty sure this was safe and it does help other drivers
> to have the full state, but I guess you can make the driver opt out of
> the flag again (just unset it before register_hw).

The result I see is that there is an extra 10 bytes at the end of the frame on
air.  But, it looks like the exact same pkt is sent to the firmware both with
and without this patch.  Maybe the firmware is using the wrong tid or something
like that due to how the station is created differently with this patch.

Since this only happens (as far as I know) with my modified firmware, then
I will try to fix it there.  Or, possibly I can change ath10k driver to flip this
mac80211 flag when loading my firmware variant if firmware cannot be easily fixed.

Thanks for the info,
--Ben

>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
