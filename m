Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:37981 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab1D2FV2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 01:21:28 -0400
Received: from mail.atheros.com ([10.234.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 28 Apr 2011 22:21:01 -0700
Message-ID: <4DBA4AD2.4090801@atheros.com> (sfid-20110429_072133_355849_6BA6CFFB)
Date: Fri, 29 Apr 2011 10:51:22 +0530
From: Mohammed Shafi <mshajakhan@atheros.com>
MIME-Version: 1.0
To: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>
CC: Mohammed Shajakhan <Mohammed.Shajakhan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>
Subject: Re: [RFC/RFT 1/9] ath9k_hw: make antenna diversity modules chip	specific
References: <1304000579-5784-1-git-send-email-mshajakhan@atheros.com> <1304000579-5784-2-git-send-email-mshajakhan@atheros.com> <20110429041018.GA26690@vasanth-laptop>
In-Reply-To: <20110429041018.GA26690@vasanth-laptop>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 29 April 2011 09:40 AM, Vasanth Thiagarajan wrote:
> On Thu, Apr 28, 2011 at 07:52:51PM +0530, Mohammed Shafi Shajakhan wrote:
>    
>> From: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>>
>> this is necessary to support Antenna diversity and combining in new chip
>> sets such as AR9485, previously Antenna diversity support is available
>> only in AR9285
>>
>> Signed-off-by: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>> ---
>>   drivers/net/wireless/ath/ath9k/ar9002_mac.c |    2 ++
>>   drivers/net/wireless/ath/ath9k/ar9002_phy.c |    8 ++++----
>>   drivers/net/wireless/ath/ath9k/hw-ops.h     |   12 ++++++++++++
>>   drivers/net/wireless/ath/ath9k/hw.h         |   15 +++++++++++----
>>   4 files changed, 29 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/ar9002_mac.c b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
>> index c338efb..106714d 100644
>> --- a/drivers/net/wireless/ath/ath9k/ar9002_mac.c
>> +++ b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
>> @@ -458,4 +458,6 @@ void ar9002_hw_attach_mac_ops(struct ath_hw *ah)
>>   	ops->clr11n_aggr = ar9002_hw_clr11n_aggr;
>>   	ops->set11n_burstduration = ar9002_hw_set11n_burstduration;
>>   	ops->set_clrdmask = ar9002_hw_set_clrdmask;
>> +	ops->antdiv_comb_conf_get = ar9002_hw_antdiv_comb_conf_get;
>> +	ops->antdiv_comb_conf_set = ar9002_hw_antdiv_comb_conf_set;
>>      
> This should be part of phy_ops.
>    
Ok I will move it to phy_ops.

thanks,
shafi

> Vasanth
>
> .
>
>    
