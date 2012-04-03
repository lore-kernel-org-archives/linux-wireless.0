Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39488 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291Ab2DCQJ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2012 12:09:27 -0400
Message-ID: <4F7B20B0.6030107@candelatech.com> (sfid-20120403_180930_392020_E41779DB)
Date: Tue, 03 Apr 2012 09:09:20 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@nbd.name>
CC: Felix Fietkau <nbd@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k:  Don't delete key from hw if using sw-crypt.
References: <1333399292-23231-1-git-send-email-greearb@candelatech.com> <4F7AF81F.30903@openwrt.org> <4F7B0CE6.9020300@candelatech.com> <298BE6B2-A128-4CA7-BAD1-56E1073A2847@nbd.name>
In-Reply-To: <298BE6B2-A128-4CA7-BAD1-56E1073A2847@nbd.name>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/03/2012 09:05 AM, Felix Fietkau wrote:
>
> On 03.04.2012, at 16:44, Ben Greear<greearb@candelatech.com>  wrote:
>
>> On 04/03/2012 06:16 AM, Felix Fietkau wrote:
>>> On 2012-04-02 10:41 PM, greearb@candelatech.com wrote:
>>>> From: Ben Greear<greearb@candelatech.com>
>>>>
>>>> This spams logs if we are using large numbers of stations,
>>>> for instance:
>>>>
>>>> ath: wiphy0: keyreset: keycache entry 228 out of range
>>>> ath: wiphy0: keyreset: keycache entry 228 out of range
>>>>
>>>> Signed-off-by: Ben Greear<greearb@candelatech.com>
>>>> ---
>>>> :100644 100644 917032a... 65e7281... M    drivers/net/wireless/ath/ath9k/main.c
>>>>   drivers/net/wireless/ath/ath9k/main.c |    3 +++
>>>>   1 files changed, 3 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
>>>> index 917032a..65e7281 100644
>>>> --- a/drivers/net/wireless/ath/ath9k/main.c
>>>> +++ b/drivers/net/wireless/ath/ath9k/main.c
>>>> @@ -1771,6 +1771,9 @@ static void ath9k_del_ps_key(struct ath_softc *sc,
>>>>       if (!an->ps_key)
>>>>           return;
>>>>
>>>> +    if (ath9k_modparam_nohwcrypt)
>>>> +        return;
>>>> +
>>> This looks wrong to me. ps_key is used for better powersave handling of
>>> both unencrypted and encrypted stations (using the keycache only for tx
>>> filtering on unencrypted stations).
>>
>> Ok..should we just remove the spammy printk when the keycache entry
>> is out of range then?
> I'd say we should figure out why it triggers at all.

I have more than 200 stations associating, and that is more than there
are key-indexes it appears.  I can add a WARN_ON if you'd like to see
a backtrace or any other info...

Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

