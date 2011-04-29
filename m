Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:37108 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007Ab1D2Exq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 00:53:46 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 28 Apr 2011 21:53:19 -0700
Message-ID: <4DBA4454.8080302@atheros.com> (sfid-20110429_065349_460730_F50F7884)
Date: Fri, 29 Apr 2011 10:23:40 +0530
From: Mohammed Shafi <mshajakhan@atheros.com>
MIME-Version: 1.0
To: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>
CC: Mohammed Shajakhan <Mohammed.Shajakhan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>
Subject: Re: [RFC/RFT 3/9] ath9k_hw: define registers/macros to support	Antenna
 diversity
References: <1304000579-5784-1-git-send-email-mshajakhan@atheros.com> <1304000579-5784-4-git-send-email-mshajakhan@atheros.com> <20110429042018.GB26690@vasanth-laptop>
In-Reply-To: <20110429042018.GB26690@vasanth-laptop>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 29 April 2011 09:50 AM, Vasanth Thiagarajan wrote:
> On Thu, Apr 28, 2011 at 07:52:53PM +0530, Mohammed Shafi Shajakhan wrote:
>    
>> From: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>>
>> define few registers and macros to configure/enable Antenna diversity
>> parameters in AR9485
>>
>> Signed-off-by: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>> ---
>>   drivers/net/wireless/ath/ath9k/ar9003_phy.h |   31 ++++++++++++++++++++++++--
>>   drivers/net/wireless/ath/ath9k/hw.h         |    3 ++
>>   2 files changed, 31 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
>> index 2a0d5cb..c4f409f 100644
>> --- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
>> +++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
>> @@ -245,6 +245,9 @@
>>    */
>>   #define AR_BBB_BASE	0x9d00
>>
>> +#define AR_BBB_SIG_DETECT_ANT_FAST_DIV			0x00002000
>> +#define AR_BBB_SIG_DETECT_ANT_FAST_DIV_S		13
>> +
>>   /*
>>    * AGC Register Map
>>    */
>> @@ -261,12 +264,37 @@
>>   #define AR_PHY_EXT_CCA0         (AR_AGC_BASE + 0x20)
>>   #define AR_PHY_RESTART          (AR_AGC_BASE + 0x24)
>>
>> +/*
>> + * Antenna Diversity  settings
>> + */
>>   #define AR_PHY_MC_GAIN_CTRL     (AR_AGC_BASE + 0x28)
>>   #define AR_ANT_DIV_CTRL_ALL	0x7e000000
>>   #define AR_ANT_DIV_CTRL_ALL_S	25
>>   #define AR_ANT_DIV_ENABLE	0x1000000
>>   #define AR_ANT_DIV_ENABLE_S	24
>>
>> +#define AR_PHY_CCK_DETECT       (AR_AGC_BASE + 0x1c0)
>> +#define AR_FAST_DIV_ENABLE	0x2000
>> +#define AR_FAST_DIV_ENABLE_S	13
>>      
> This can be in the original place as it is in order with the
> register offset. This way we can avoid any possible duplication/bug
> in register definition.
>    
Ok Vasanth, I will revert it back.

thanks,
shafi
> Vasanth
> .
>
>    
