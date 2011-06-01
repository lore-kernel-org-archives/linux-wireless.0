Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:53693 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161735Ab1FAIwZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 04:52:25 -0400
Message-ID: <4DE5FDB0.3060406@openwrt.org> (sfid-20110601_105232_803658_08C4C52A)
Date: Wed, 01 Jun 2011 10:52:00 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: Re: [RFC 20/32] ath9k: set NF limits for AR9330
References: <1306870643-7935-1-git-send-email-juhosg@openwrt.org> <1306870643-7935-21-git-send-email-juhosg@openwrt.org> <4DE573AF.8060405@openwrt.org>
In-Reply-To: <4DE573AF.8060405@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011.06.01. 1:03 keltezéssel, Felix Fietkau írta:
> On 2011-05-31 9:37 PM, Gabor Juhos wrote:
>> Signed-off-by: Gabor Juhos<juhosg@openwrt.org>
>> ---
>>   drivers/net/wireless/ath/ath9k/ar9003_phy.c |    5 ++++-
>>   drivers/net/wireless/ath/ath9k/ar9003_phy.h |    2 ++
>>   2 files changed, 6 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
>> b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
>> index a0ca1eb..eb18b63 100644
>> --- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
>> +++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
>> @@ -1089,7 +1089,10 @@ static void ar9003_hw_set_nf_limits(struct ath_hw *ah)
>>   {
>>       ah->nf_2g.max = AR_PHY_CCA_MAX_GOOD_VAL_9300_2GHZ;
>>       ah->nf_2g.min = AR_PHY_CCA_MIN_GOOD_VAL_9300_2GHZ;
>> -    ah->nf_2g.nominal = AR_PHY_CCA_NOM_VAL_9300_2GHZ;
>> +    if (AR_SREV_9300(ah))
>> +        ah->nf_2g.nominal = AR_PHY_CCA_NOM_VAL_9330_2GHZ;
> Typo in the SREV check?

Yes, definitely.

Thanks,
Gabor
