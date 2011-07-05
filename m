Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:47166 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449Ab1GEEs0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 00:48:26 -0400
Message-ID: <4E129788.4040803@openwrt.org> (sfid-20110705_064829_330956_36318C5E)
Date: Tue, 05 Jul 2011 11:48:08 +0700
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	ath5k-devel@lists.ath5k.org
Subject: Re: [PATCH v2 1/8] ath5k: add missing checks for rfgain probe
References: <1309835484-26653-1-git-send-email-nbd@openwrt.org> <CAFtRNNwK_LjP_2cAp0macP+8My4nzextWMNz9pLTKRW6V8tDjw@mail.gmail.com>
In-Reply-To: <CAFtRNNwK_LjP_2cAp0macP+8My4nzextWMNz9pLTKRW6V8tDjw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-07-05 11:46 AM, Nick Kossifidis wrote:
> 2011/7/5 Felix Fietkau<nbd@openwrt.org>:
>>  rfgain probe is only necessary for OFDM operation on AR5111 and AR5112.
>>
>>  Signed-off-by: Felix Fietkau<nbd@openwrt.org>
>>  ---
>>    drivers/net/wireless/ath/ath5k/phy.c |   10 ++++++----
>>    1 files changed, 6 insertions(+), 4 deletions(-)
>>
>>  diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
>>  index 5544191..d0bfcad 100644
>>  --- a/drivers/net/wireless/ath/ath5k/phy.c
>>  +++ b/drivers/net/wireless/ath/ath5k/phy.c
>>  @@ -1604,11 +1604,13 @@ int ath5k_hw_phy_calibrate(struct ath5k_hw *ah,
>>          int ret;
>>
>>          if (ah->ah_radio == AR5K_RF5110)
>>  -               ret = ath5k_hw_rf5110_calibrate(ah, channel);
>>  -       else {
>>  -               ret = ath5k_hw_rf511x_iq_calibrate(ah);
>>  +               return ath5k_hw_rf5110_calibrate(ah, channel);
>>  +
>>  +       ret = ath5k_hw_rf511x_iq_calibrate(ah);
>>  +
>>  +       if ((ah->ah_radio == AR5K_RF5112 || ah->ah_radio == AR5K_RF5112)&&
>
> You probably mean
> ah->ah_radio == AR5K_RF5111 || ah->ah_radio == AR5K_RF5112
You're right. I need to be more careful with copy&paste ;)
Will send a v3 once you've looked over the other patches.

- Felix
