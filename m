Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40624 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513Ab2CCO5k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Mar 2012 09:57:40 -0500
Message-ID: <4F523162.6070306@openwrt.org> (sfid-20120303_155742_864702_69C6C963)
Date: Sat, 03 Mar 2012 15:57:38 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Mohammed Shafi <shafi.wireless@gmail.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com
Subject: Re: [PATCH 1/5] ath9k_hw: use cold instead of warm reset on AR9280
References: <1330784226-65563-1-git-send-email-nbd@openwrt.org> <CAD2nsn1epfw=N=Np8Ts+G6yF5JTXZXSE4bOL7_jY9mCZG9Cg4Q@mail.gmail.com>
In-Reply-To: <CAD2nsn1epfw=N=Np8Ts+G6yF5JTXZXSE4bOL7_jY9mCZG9Cg4Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-03-03 3:40 PM, Mohammed Shafi wrote:
> Hi Felix,
> 
> On Sat, Mar 3, 2012 at 7:47 PM, Felix Fietkau <nbd@openwrt.org> wrote:
>> Cold reset is more reliable for getting the hardware out of some specific
>> stuck states.
>>
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>> ---
>>  drivers/net/wireless/ath/ath9k/hw.c |   14 ++++++++++----
>>  1 files changed, 10 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
>> index 8c840ca..d582cf7 100644
>> --- a/drivers/net/wireless/ath/ath9k/hw.c
>> +++ b/drivers/net/wireless/ath/ath9k/hw.c
>> @@ -1386,10 +1386,16 @@ static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type)
>>  static bool ath9k_hw_chip_reset(struct ath_hw *ah,
>>                                struct ath9k_channel *chan)
>>  {
>> -       if (AR_SREV_9280(ah) && ah->eep_ops->get_eeprom(ah, EEP_OL_PWRCTRL)) {
>> -               if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON))
>> -                       return false;
>> -       } else if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_WARM))
>> +       int reset_type = ATH9K_RESET_WARM;
>> +
>> +       if (AR_SREV_9280(ah)) {
>> +               if (ah->eep_ops->get_eeprom(ah, EEP_OL_PWRCTRL))
>> +                       reset_type = ATH9K_RESET_POWER_ON;
>> +               else
>> +                       reset_type = ATH9K_RESET_COLD;
>> +       }
> 
> 
> cold reset seems to be applicable for older chip sets like AR9100,
> should this be applicable to AR9280. won't there be any problem if we
> perform cold reset in STA mode.
What kind of issues do you expect from cold reset in STA mode? OpenWrt
has had this patch for a while now, and I didn't notice any issues with it.

- Felix
