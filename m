Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54468 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab2CHMvq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 07:51:46 -0500
Message-ID: <4F58AB5A.3050708@qca.qualcomm.com> (sfid-20120308_135149_691379_525F64C4)
Date: Thu, 8 Mar 2012 18:21:38 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<Mohammed@venema.h4ckr.net>, <ath9k-devel@lists.ath9k.org>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>
Subject: Re: [ath9k-devel] [RFC 1/1] ath9k_hw: Fix enabling of MCI and RTT
References: <1331201325-17706-1-git-send-email-mohammed@qca.qualcomm.com> <20312.43226.814441.345911@gargle.gargle.HOWL>
In-Reply-To: <20312.43226.814441.345911@gargle.gargle.HOWL>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sujith,

On Thursday 08 March 2012 06:10 PM, Sujith Manoharan wrote:
> Mohammed Shafi Shajakhan wrote:
>> +
>> +	if (AR_SREV_9462(ah)) {
>> +		ah->ent_mode = REG_READ(ah, AR_ENT_OTP);
>> +		if (!(ah->ent_mode&  AR_ENT_OTP_49GHZ_DISABLE))
>> +			pCap->hw_caps |= ATH9K_HW_CAP_MCI;
>> +	}
>> +
>> +	if (AR_SREV_9462_20(ah))
>> +		pCap->hw_caps |= ATH9K_HW_CAP_RTT;
>
> ah->ent_mode is already being updated earlier in ath9k_hw_fill_cap_info(),
> so there is no need to read AR_ENT_OTP again.

did notice the check AR9300_20_LATER :). just thought if we change 
something and 'ent_mode' holds some other value. anyway will just leave 
the check.

>
> Sujith


-- 
thanks,
shafi
