Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36160 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab2DCOo6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2012 10:44:58 -0400
Message-ID: <4F7B0CE6.9020300@candelatech.com> (sfid-20120403_164502_215873_7DBA99CB)
Date: Tue, 03 Apr 2012 07:44:54 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k:  Don't delete key from hw if using sw-crypt.
References: <1333399292-23231-1-git-send-email-greearb@candelatech.com> <4F7AF81F.30903@openwrt.org>
In-Reply-To: <4F7AF81F.30903@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/03/2012 06:16 AM, Felix Fietkau wrote:
> On 2012-04-02 10:41 PM, greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> This spams logs if we are using large numbers of stations,
>> for instance:
>>
>> ath: wiphy0: keyreset: keycache entry 228 out of range
>> ath: wiphy0: keyreset: keycache entry 228 out of range
>>
>> Signed-off-by: Ben Greear<greearb@candelatech.com>
>> ---
>> :100644 100644 917032a... 65e7281... M	drivers/net/wireless/ath/ath9k/main.c
>>   drivers/net/wireless/ath/ath9k/main.c |    3 +++
>>   1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
>> index 917032a..65e7281 100644
>> --- a/drivers/net/wireless/ath/ath9k/main.c
>> +++ b/drivers/net/wireless/ath/ath9k/main.c
>> @@ -1771,6 +1771,9 @@ static void ath9k_del_ps_key(struct ath_softc *sc,
>>   	if (!an->ps_key)
>>   	    return;
>>
>> +	if (ath9k_modparam_nohwcrypt)
>> +		return;
>> +
> This looks wrong to me. ps_key is used for better powersave handling of
> both unencrypted and encrypted stations (using the keycache only for tx
> filtering on unencrypted stations).

Ok..should we just remove the spammy printk when the keycache entry
is out of range then?

THanks,
Ben

>
> - Felix


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
