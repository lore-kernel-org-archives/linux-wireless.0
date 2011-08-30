Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36266 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755724Ab1H3QjE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 12:39:04 -0400
Message-ID: <4E5D1221.7020705@openwrt.org> (sfid-20110830_183908_828072_212D4647)
Date: Tue, 30 Aug 2011 18:38:57 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com
Subject: Re: [PATCH 3.1] ath9k_hw: fix calibration on 5 ghz
References: <1314605174-66206-1-git-send-email-nbd@openwrt.org> <CAJ-Vmonvcrd49rQbgeyO3HCLxkTbww3mTypR87CuPBiu9uwhHA@mail.gmail.com>
In-Reply-To: <CAJ-Vmonvcrd49rQbgeyO3HCLxkTbww3mTypR87CuPBiu9uwhHA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Got confirmation that this is indeed the correct fix.
John, please merge this patch

On 2011-08-29 11:01 AM, Adrian Chadd wrote:
> Can we please hold off of this until we know if this is indeed the correct fix?
>
> Ie, I'm not sure yet whether 5ghz fast clock (which clocks the mac/bb
> like it was doing 2.4ghz) needs the dual ADCs enabled or not.
> It may be that something is being incorrectly disabled when the
> fastclock initvals are being written over the normal 5ghz values.
>
> Thanks,
>
>
> Adrian
>
> On 29 August 2011 16:06, Felix Fietkau<nbd@openwrt.org>  wrote:
>>  ADC calibrations cannot run on 5 GHz with fast clock enabled. They
>>  need to be disabled, otherwise they'll hang and IQ mismatch calibration
>>  will not be run either.
>>
>>  Signed-off-by: Felix Fietkau<nbd@openwrt.org>
>>  Reported-by: Adrian Chadd<adrian@freebsd.org>
>>  Cc: stable@kernel.org
>>  ---
>>    drivers/net/wireless/ath/ath9k/ar9002_calib.c |    3 ++-
>>    1 files changed, 2 insertions(+), 1 deletions(-)
>>
>>  diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
>>  index 2d4c091..2d394af 100644
>>  --- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
>>  +++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
>>  @@ -41,7 +41,8 @@ static bool ar9002_hw_is_cal_supported(struct ath_hw *ah,
>>          case ADC_DC_CAL:
>>                  /* Run ADC Gain Cal for non-CCK&  non 2GHz-HT20 only */
>>                  if (!IS_CHAN_B(chan)&&
>>  -                   !(IS_CHAN_2GHZ(chan)&&  IS_CHAN_HT20(chan)))
>>  +                   !((IS_CHAN_2GHZ(chan) || IS_CHAN_A_FAST_CLOCK(ah, chan))&&
>>  +                     IS_CHAN_HT20(chan)))
>>                          supported = true;
>>                  break;
>>          }
>>  --
>>  1.7.3.2
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

