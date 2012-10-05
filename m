Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2395 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754441Ab2JEVDI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 17:03:08 -0400
Message-ID: <506F4AFE.2090301@broadcom.com> (sfid-20121005_230313_260604_BBB76C81)
Date: Fri, 5 Oct 2012 23:02:54 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Felix Fietkau" <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net, mcgrof@qca.qualcomm.com
Subject: Re: [PATCH 3.7 1/2] cfg80211: fix antenna gain handling
References: <1349286707-64433-1-git-send-email-nbd@openwrt.org>
 <20121005202220.GA1929@tuxdriver.com>
In-Reply-To: <20121005202220.GA1929@tuxdriver.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/05/2012 10:22 PM, John W. Linville wrote:
> Anyone object?  I suspect that Johannes may be a little more
> busy/distracted than usual for the next few days/weeks...
>
> John
>
> On Wed, Oct 03, 2012 at 07:51:46PM +0200, Felix Fietkau wrote:
>> When not intersecting, orig->chan_mag is initialized to zero. Because of
>> that, the regulatory antenna gain limit never gets set.
>>
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>> Cc: stable@vger.kernel.org
>> ---
>>   net/wireless/reg.c |    3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
>> index 3b8cbbc..1a16f19 100644
>> --- a/net/wireless/reg.c
>> +++ b/net/wireless/reg.c
>> @@ -915,8 +915,7 @@ static void handle_channel(struct wiphy *wiphy,
>>
>>   	chan->beacon_found = false;
>>   	chan->flags = flags | bw_flags | map_regdom_flags(reg_rule->flags);
>> -	chan->max_antenna_gain = min(chan->orig_mag,
>> -		(int) MBI_TO_DBI(power_rule->max_antenna_gain));

Just reading the commit message, I would think it better to initialize 
chan->orig_mag to INT_MAX. Just my 0.02$

Gr. AvS

>> +	chan->max_antenna_gain = (int) MBI_TO_DBI(power_rule->max_antenna_gain);
>>   	chan->max_reg_power = (int) MBM_TO_DBM(power_rule->max_eirp);
>>   	if (chan->orig_mpwr) {
>>   		/*
>> --
>> 1.7.9.6 (Apple Git-31.1)
>>
>>
>


