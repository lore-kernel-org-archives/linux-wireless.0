Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:33576 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754126Ab2JHUw5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Oct 2012 16:52:57 -0400
Message-ID: <50733D22.80407@openwrt.org> (sfid-20121008_225312_440521_0D4E9B0B)
Date: Mon, 08 Oct 2012 22:52:50 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, arend@broadcom.com
Subject: Re: [PATCH v2 3.7 1/2] cfg80211: fix antenna gain handling
References: <1349527254-41080-1-git-send-email-nbd@openwrt.org> <20121008183758.GJ3354@lenteja.do-not-panic.com>
In-Reply-To: <20121008183758.GJ3354@lenteja.do-not-panic.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-10-08 8:37 PM, Luis R. Rodriguez wrote:
> On Sat, Oct 06, 2012 at 02:40:53PM +0200, Felix Fietkau wrote:
>> No driver initializes chan->max_antenna_gain to something sensible, and
>> the only place where it is being used right now is inside ath9k. This
>> leads to ath9k potentially using less tx power than it can use.
>> 
>> Rather than going through every single driver, this patch initializes
>> chan->orig_mag in wiphy_register(), ignoring whatever value the driver
>> left in there. If a driver for some reason wishes to limit it independent
>> from regulatory rulesets, it can do so internally.
>> 
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>> Cc: stable@vger.kernel.org
>> ---
>>  net/wireless/core.c |    3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>> 
>> diff --git a/net/wireless/core.c b/net/wireless/core.c
>> index 443d4d7..3f72530 100644
>> --- a/net/wireless/core.c
>> +++ b/net/wireless/core.c
>> @@ -526,8 +526,7 @@ int wiphy_register(struct wiphy *wiphy)
>>  		for (i = 0; i < sband->n_channels; i++) {
>>  			sband->channels[i].orig_flags =
>>  				sband->channels[i].flags;
>> -			sband->channels[i].orig_mag =
>> -				sband->channels[i].max_antenna_gain;
>> +			sband->channels[i].orig_mag = INT_MAX;
> 
> The commit log for a stable patch should describe the impact of not applying
> it. In this case perhaps not being able to associate to APs due to unnecessary
> power limitations -- but again that itself would only be true if some other
> code used it in a way that it should not. I rather fix that if such cases
> exist.
I did mention that not applying this patch can in some circumstances
lead to using lower tx power. I think it's obvious that this impairs
performance/range.

> Now the purpose of orig_mag is to allow drivers to spit out to kernel and
> eventually userspace if we want it what it knows about the value of the
> embedded antenna gain. The regulatory code for antenna gain is useful for us in
> that it is the maximum allowed antenna gain values.
If that was the purpose, then the implementation completely fails at
treating it as such. Remember, that 'mag' stands for *maximum* antenna
gain, not effective antenna gain or something. It is indeed treated as a
regulatory maximum, and since only driver code uses the
regulatory-capped maximum antenna gain, it does not make sense to allow
the driver to set anything here initially.

> This code itself hasn't been widely used throughout code but as you point out
> ath9k does use it given that we can populate the antenna gain with what we read
> from EEPROM and that in fact should *not* be reducing the max power from ath9k
> but instead *helping* it in case it is smaller than the max allowed.
I think you're confusing what the EEPROM says vs. what orig_mag really
means. orig_mag means maximum allowable antenna gain at max. tx power
that is still compliant. The eeprom value contains the antenna gain of
the current system. These are two completely different things, and
storing anything from the EEPROM in chan->max_antenna_gain makes no
sense at all.

> In retrospect there are a few things we can do here to improve this and use
> this more efficiently. The orig_mag should be used by wiphy_register() as is.
> Then upon wiphy_register() it calls wiphy_regulatory_register() and that
> handles with anything regarding regulatory on the device. How about we change
> this so that within wiphy_regulatory_register() (or regulatory change,
> handle_channel()) we review if the device's antenna gain is over the regulatory
> domain max allowed antenna gain and if it is we kick back simply mute the
> device only allowing RX. If the device is changed to a regulatory domain that
> allows for the antenna gain registered for the device then we unmute it. This
> would in turn allow doing dynamic updates of the antenna gain as it seems you
> want to introduce API for later, we'd end up checking for the newly supplied
> antenna gain (and ensure that that value is higher than the embedded on on
> EEPROM).
Sorry, but that makes no sense to me, you're solving a nonexistant
problem. The antenna gain value from EEPROM is already handled properly.
If the code detects that EEPROM antenna gain is n dBi over the
regulatory antenna gain, it reduces tx power by n dBm. Muting the card
in that case sounds weird and completely unnecessary to me.

- Felix
