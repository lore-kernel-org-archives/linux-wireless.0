Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:41828 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933182AbbJIQO3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2015 12:14:29 -0400
Subject: Re: [PATCH] mac80211: Take bitrates into account when building IEs.
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <1442610145-8759-1-git-send-email-greearb@candelatech.com>
 <1444296337.2131.9.camel@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <5617E7E5.9070401@candelatech.com> (sfid-20151009_181433_457505_C8EC993B)
Date: Fri, 9 Oct 2015 09:14:29 -0700
MIME-Version: 1.0
In-Reply-To: <1444296337.2131.9.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/08/2015 02:25 AM, Johannes Berg wrote:
> On Fri, 2015-09-18 at 14:02 -0700, greearb@candelatech.com wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> If a user restricts the rateset for some reason, then the
>> probe requests should not advertise rates that are not
>> selected by the user.
>>
>> To implement this, we save the requested bitrates at
>> the mac80211 level and take it into account when building
>> the IEs.
>>
>> This allows one to create a more realistic /b mode
>> station on modern hardware, for instance.  Good for
>> testing, and likely good for other things as well.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>> ---
>>   include/net/mac80211.h     |  4 ++
>>   net/mac80211/cfg.c         |  3 ++
>>   net/mac80211/ieee80211_i.h | 15 ++++++-
>>   net/mac80211/scan.c        | 26 ++++++++++++-
>>   net/mac80211/util.c        | 97 ++++++++++++++++++++++++++++++++++++++++++----
>>   5 files changed, 135 insertions(+), 10 deletions(-)
>>
>> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
>> index d52914b..be069bd 100644
>> --- a/include/net/mac80211.h
>> +++ b/include/net/mac80211.h
>> @@ -1838,10 +1838,14 @@ struct ieee80211_hw {
>>    * struct ieee80211_scan_request - hw scan request
>>    *
>>    * @ies: pointers different parts of IEs (in req.ie)
>> + * @disable_ht: Ensure nothing related to HT is in the probe request?
>> + * @disable_vht: Ensure nothing related to VHT is in the probe request?
>
> what's with the question marks? :)

Cause it's a boolean?  Easily remedied either way.

>
> I don't really see why it should be in this struct - the driver
> shouldn't have to access it even for hardware scan?

ath10k firmware wants to add it's own IEs when doing hardware
scan.  It has flags to the scan request that determines what IEs
it will build...so I was using these booleans to determine how to
build the ath10k scan-request message.

>
>> +++ b/net/mac80211/cfg.c
>> @@ -2466,6 +2466,9 @@ static int ieee80211_set_bitrate_mask(struct wiphy *wiphy,
>>   > 	> if (!ieee80211_sdata_running(sdata))
>>   > 	> 	> return -ENETDOWN;
>>
>> +> 	> memcpy(&sdata->cfg_bitrate_mask, mask, sizeof(*mask));
>> +> 	> sdata->cfg_bitrate_mask_set = true;
>
>
> I'm not entirely convinced of this ...
>
> The documentation for @NL80211_CMD_SET_TX_BITRATE_MASK doesn't really
> state this - it clearly states it's for TX only. Settings it up this
> way now might be rather confusing.
>
> Consider P2P for example, the bitrate mask might be set w/o CCK, but
> perhaps other networks can be found?

How about a new flag to 'set-bitrates' logic that tells the mac80211
stack whether the bitrates mask is for probe-requests and similar
vs being for actually just tx-rate-mask limitations?

Then it should be fully backwards compat with existing behaviour, and also
give the new behaviour that I want.  In my case, I think this is better anyway
because I might want to fix tx-rate at 6Mbps but allow at least the
basic rates to be used for probe requests and such.

This approach should let us re-use the bulk of the rates parsing logic
in iw and/or hostapd/supplicant (and the kernel, for that matter).

>
>> +> 	> /* Store bitrate mask configured from user-space */
>> +> 	> struct cfg80211_bitrate_mask cfg_bitrate_mask;
>> +> 	> bool cfg_bitrate_mask_set; /* Has user set the mask? */
>
> I'm also not really happy with such stateful API in general. If you set
> this, and forget to reset it ...
>
> Obviously that's already the case for the TX bitrates, but it's
> typically used in pretty restricted situations.
>
> Perhaps, for the use case you're considering, it would make more sense
> to be able to in general change the device capabilities in some way?

Changing the device won't help me I think..I want to have multiple vdevs
on the same radio using different rate-encoding schemes...so one
STA/VAP will be /b, next /b/g, and another /n, all on the same
radio.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

