Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18720 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab2FRJ6L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 05:58:11 -0400
Message-ID: <4FDEFBA8.40807@qca.qualcomm.com> (sfid-20120618_115837_997029_1F2965A7)
Date: Mon, 18 Jun 2012 15:28:00 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	<stable@vger.kernel.org>,
	Rolf Offermanns <rolf.offermanns@gmx.net>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Subject: Re: [PATCH] ath9k_hw: avoid possible infinite loop in ar9003_get_pll_sqsum_dvc
References: <1340005410-11256-1-git-send-email-mohammed@qca.qualcomm.com> <20120618080453.GA3818@vmraj-lnx.qca.qualcomm.com>
In-Reply-To: <20120618080453.GA3818@vmraj-lnx.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Raj,

On Monday 18 June 2012 01:34 PM, Rajkumar Manoharan wrote:
> On Mon, Jun 18, 2012 at 01:13:30PM +0530, Mohammed Shafi Shajakhan wrote:
>> From: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>>
>> "ath9k: Fix softlockup in AR9485" with commit id
>> 64bc1239c790e051ff677e023435d770d2ffa174 fixed the reported
>> issue, yet its better to avoid the possible infinite loop
>> in ar9003_get_pll_sqsum_dvc by having a timeout as suggested
>> by ath9k maintainers.
>> http://www.spinics.net/lists/linux-wireless/msg92126.html.
>> Based on my testing PLL's locking measurement is done in
>> ~200us (2 iterations).
>>
>> Cc: stable@vger.kernel.org
>> Cc: Rolf Offermanns<rolf.offermanns@gmx.net>
>> Cc: Sujith Manoharan<c_manoha@qca.qualcomm.com>
>> Cc: Senthil Balasubramanian<senthilb@qca.qualcomm.com>
>> Signed-off-by: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>> ---
>>   drivers/net/wireless/ath/ath9k/hw.c |   14 +++++++++++++-
>>   1 files changed, 13 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
>> index 784baee..a42c26f 100644
>> --- a/drivers/net/wireless/ath/ath9k/hw.c
>> +++ b/drivers/net/wireless/ath/ath9k/hw.c
>> @@ -773,13 +773,25 @@ static void ath9k_hw_init_qos(struct ath_hw *ah)
>>
>>   u32 ar9003_get_pll_sqsum_dvc(struct ath_hw *ah)
>>   {
>> +	struct ath_common *common = ath9k_hw_common(ah);
>> +	int i = 0;
>> +
>>   	REG_CLR_BIT(ah, PLL3, PLL3_DO_MEAS_MASK);
>>   	udelay(100);
>>   	REG_SET_BIT(ah, PLL3, PLL3_DO_MEAS_MASK);
>>
>> -	while ((REG_READ(ah, PLL4)&  PLL4_MEAS_DONE) == 0)
>> +	while ((REG_READ(ah, PLL4)&  PLL4_MEAS_DONE) == 0) {
>> +
>>   		udelay(100);
>>
>> +		if (WARN_ON_ONCE(i>= 100)) {
>> +			ath_err(common, "PLL4 meaurement not done\n");
>> +			break;
>> +		}
>> +
>> +		i++;
> How did you come up with 100 as max limit to break the loop?
>

i assumed its a sufficient arbitrary max value to confirm that the PLL 
locking measurement does not happens. Based on my quite a few of 
tests(idle associated, with traffic)PLL immediately locksup in 200us (2 
iterations). As per your suggestion i will quickly check with the 
System's team if we can give a proper value, rather than 100 * 100 us as 
timeout. thanks for reviewing it!

-- 
thanks,
shafi
