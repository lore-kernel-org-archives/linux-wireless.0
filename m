Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f175.google.com ([209.85.210.175]:60556 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbZGaSAF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 14:00:05 -0400
Received: by yxe5 with SMTP id 5so251698yxe.33
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2009 11:00:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1249062751.14242.2.camel@johannes.local>
References: <1249001028-15110-1-git-send-email-lrodriguez@atheros.com>
	<1249062751.14242.2.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 31 Jul 2009 10:59:44 -0700
Message-ID: <43e72e890907311059s18363461kd69f9c8783fa3d4c@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: fix regression on beacon world roaming feature
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 31, 2009 at 10:52 AM, Johannes
Berg<johannes@sipsolutions.net> wrote:
> On Thu, 2009-07-30 at 17:43 -0700, Luis R. Rodriguez wrote:
>> A regression was added through patch a4ed90d6:
>>
>> "cfg80211: respect API on orig_flags on channel for beacon hint"
>>
>> We did indeed respect _orig flags but the intention was not clearly
>> stated in the commit log. This patch fixes firmware issues picked
>> up by iwlwifi when we lift passive scan of beaconing restrictions
>> on channels its EEPROM has been configured to always enable.
>>
>> By doing so though we also disallowed beacon hints on devices
>> registering their wiphy with custom world regulatory domains
>> enabled, this happens to be currently ath5k, ath9k and ar9170.
>> The passive scan and beacon restrictions on those devices would
>> never be lifted even if we did find a beacon and the hardware did
>> support such enhancements when world roaming.
>>
>> Since Johannes indicates iwlwifi firmware cannot be changed to
>> allow beacon hinting we set up a flag now to specifically allow
>> drivers to disable beacon hints for devices which cannot use them.
>>
>> We enable the flag on iwlwifi to disable beacon hints and by default
>> enable it for all other drivers. It should be noted beacon hints lift
>> passive scan flags and beacon restrictions when we receive a beacon from
>> an AP on any 5 GHz non-DFS channels, and channels 12-14 on the 2.4 GHz
>> band. We don't bother with channels 1-11 as those channels are allowed
>> world wide.
>>
>> This should fix world roaming for ath5k, ath9k and ar9170, thereby
>> improving scan time when we receive the first beacon from any AP,
>> and also enabling beaconing operation (AP/IBSS/Mesh) on cards which
>> would otherwise not be allowed to do so. Drivers not using custom
>> regulatory stuff (wiphy_apply_custom_regulatory()) were not affected
>> by this as the orig_flags for the channels would have been cleared
>> upon wiphy registration.
>
> Ok, so after all the discussion this seems like the best option after
> all.
>
> Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

Thanks for the review.

> except I'm not sure about this bit:
>
>>         chan->beacon_found = true;
>>
>> +       if (wiphy->disable_beacon_hints)
>> +               return;
>
> seems like the if might need to be before beacon_found=true?

Nope, we need to ensure chan->beacon_found is set so that we don't
bother processing a beacon on this channel anymore. It saves iwlwifi
from triggering beacon hints onto the workqueue.

  Luis
