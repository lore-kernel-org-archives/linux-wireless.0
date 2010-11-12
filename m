Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35441 "EHLO nbd.name"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755894Ab0KLTgb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 14:36:31 -0500
Message-ID: <4CDD971D.5080204@openwrt.org>
Date: Fri, 12 Nov 2010 20:35:57 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: Wojciech Dubowik <dubowoj@neratec.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 9/9] ath5k: AHB port. Fix reset and interrupts for AHB
 type of devices.
References: <5575430.811289486702581.JavaMail.wlan@CHBU500181>	<12495562.1171289487502962.JavaMail.wlan@CHBU500181> <AANLkTinE7LE7OXOq+DrUQfwOAjckaV5A3JbGUSD3vp9h@mail.gmail.com>
In-Reply-To: <AANLkTinE7LE7OXOq+DrUQfwOAjckaV5A3JbGUSD3vp9h@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-11-12 8:16 PM, Bob Copeland wrote:
> On Thu, Nov 11, 2010 at 9:58 AM, Wojciech Dubowik <dubowoj@neratec.com> wrote:
>> On WiSoc we cannot access mac register before it is resetted.
>> Otherwise it will crash hardware.
>>
>> Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
>> ---
>>  drivers/net/wireless/ath/ath5k/base.c  |    7 ++-
>>  drivers/net/wireless/ath/ath5k/reset.c |  113 ++++++++++++++++++++++++-------
>>  2 files changed, 93 insertions(+), 27 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
>> index 13d5da5..00ebb81 100644
>> --- a/drivers/net/wireless/ath/ath5k/base.c
>> +++ b/drivers/net/wireless/ath/ath5k/base.c
>> @@ -2175,7 +2175,8 @@ ath5k_intr(int irq, void *dev_id)
>>        unsigned int counter = 1000;
>>
>>        if (unlikely(test_bit(ATH_STAT_INVALID, sc->status) ||
>> -                               !ath5k_hw_is_intr_pending(ah)))
>> +               ((ath5k_get_bus_type(ah) != ATH_AHB) &&
>> +                               !ath5k_hw_is_intr_pending(ah))))
>>                return IRQ_NONE;
>>
> 
> Hrm, we really don't want to sprinkle these special cases all around
> the driver.  Perhaps it'd be better to make sure ATH_STAT_INVALID
> isn't set until the soc is ready.  And, in other cases, using
> capability bits or something?  Bus type seems a bit crude.
> 
>> @@ -2241,6 +2242,10 @@ ath5k_intr(int irq, void *dev_id)
>>                                tasklet_schedule(&sc->rf_kill.toggleq);
>>
>>                }
>> +
>> +               if(ath5k_get_bus_type(ah) == ATH_AHB)
>> +                       break;
>> +
>>        } while (ath5k_hw_is_intr_pending(ah) && --counter > 0);
> 
> Why?
I think I had this in one of my old patches, because occasionally the
device would get duplicate interrupt events (causing the kernel IRQ code
to eventually disable the interrupt completely).

>> @@ -536,6 +590,9 @@ static void ath5k_hw_set_sleep_clock(struct ath5k_hw *ah, bool enable)
>>        struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
>>        u32 scal, spending, usec32;
>>
>> +       if(ath5k_get_bus_type(ah) == ATH_AHB)
>> +               enable = false;
>> +
> 
> Do you need this hunk?  We never enable the sleep clock for AP mode.
> 
What does this have to do with AP mode? Some people use these devices in
station mode.
If I remember correctly, these devices have problems with sleep clock,
maybe because parts of the WMAC clock overlap with the CPU clock
(they're inside the same chip after all).

- Felix
