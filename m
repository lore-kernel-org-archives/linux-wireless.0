Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:48819 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab2FTJjJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 05:39:09 -0400
Received: by vcbf11 with SMTP id f11so3706749vcb.19
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jun 2012 02:39:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALx5=V-L83VUcRddP=hk_vB4AK5+uZ5Gcdbg+HSbhvqNurrMbQ@mail.gmail.com>
References: <CALx5=V--5TEC2J39xdJn1fxLbmgEXsWwxbAVaXMsw=Lk2WxKRg@mail.gmail.com>
	<CAD2nsn04Bi5aNMBMLWGm9uQwTXzT8GnDfHZcBP8-+vMEgqBCag@mail.gmail.com>
	<CALx5=V-MEZVNkQ0SqqtLqBcDG_Dkp1V6XjiZEv4BBSVn9JQpCw@mail.gmail.com>
	<CALx5=V-L83VUcRddP=hk_vB4AK5+uZ5Gcdbg+HSbhvqNurrMbQ@mail.gmail.com>
Date: Wed, 20 Jun 2012 15:09:07 +0530
Message-ID: <CAD2nsn35gDLLP3Wkn9qpG5UhxUGPOcn1q_kpP2WexjQ1+LvXFg@mail.gmail.com> (sfid-20120620_114002_552047_9FB6FD0E)
Subject: Re: Atheros [168c 0034] can't enable wireless button LED.
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Matt Chen <machen@suse.com>
Cc: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Matt,


>> I do
>> 1) echo 0x402c > regidx
>>     watch -n 1 regval
>> 2) echo 0x404c > regidx
>>    watch -n1 regval
>>> i remember testing it in a acer laptop, it was working.
>> Both 1) and 2) shows no different in their value no matter how I press
>> the wifi button. :(

if hardrfkill is enabled it should toggle. you are using it as  in a
built card right ?
if GPIO11 is not connected to Vcc or ground it would not toggle.
need to check it out its a regression.

> I found it is not enabling the
> wiphy_rfkill_start_polling() in gpio.c:ath_start_rfkill_poll(struct
> ath_softc *sc).
> The condition for (ah->caps.hw_caps & ATH9K_HW_CAP_RFSILENT) is failed.
> Any direction I can dig further ? :)

can you please try this if you can see anything

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 51398f0..d732044 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3002,7 +3002,14 @@ static u32 ath9k_hw_ar9300_get_eeprom(struct ath_hw *ah,
          case EEP_OP_MODE:
                  return pBase->opCapFlags.opFlags;
          case EEP_RF_SILENT:
-               return pBase->rfSilent;
+//             return pBase->rfSilent;
+               return 0x2f;
+               /* bit 0 rfkill_enable - 1
+                * bit 1  rfkill_polarity - 1
+                * bit 2,3,4,5 gpio pin select - 1011
+                * so 1011 11
+                *  0x2f
+                */
          case EEP_TX_MASK:

please try with returning 0x2d (polarity 0 )

think i was testing this i got

"in my pci extender i always the got value of '0x6ed' for the 'reg
0x404c' and when i used the card as a inbuilt one i got '0xeed' and
'0x6ed'(when i toggle rfkill in the acer laptop)."
pls let me know if its still not working, i can check with again the
inbuilt stuff

>>>>
>>>> --
>>>> Thank you.
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>>
>>> --
>>> thanks,
>>> shafi
>>>
>>
>>
>>
>> --
>> Thank you.
>
>
>
> --
> Thank you.



-- 
thanks,
shafi
