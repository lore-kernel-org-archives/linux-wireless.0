Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44455 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab2FWKmN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jun 2012 06:42:13 -0400
Received: by obbuo13 with SMTP id uo13so3322265obb.19
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jun 2012 03:42:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALx5=V8s54ytfRVT2hscXCYRCj1MTdvKjM1jFa-OwxAyUMKFLw@mail.gmail.com>
References: <CALx5=V--5TEC2J39xdJn1fxLbmgEXsWwxbAVaXMsw=Lk2WxKRg@mail.gmail.com>
	<CAD2nsn04Bi5aNMBMLWGm9uQwTXzT8GnDfHZcBP8-+vMEgqBCag@mail.gmail.com>
	<CALx5=V-MEZVNkQ0SqqtLqBcDG_Dkp1V6XjiZEv4BBSVn9JQpCw@mail.gmail.com>
	<CALx5=V-L83VUcRddP=hk_vB4AK5+uZ5Gcdbg+HSbhvqNurrMbQ@mail.gmail.com>
	<CAD2nsn35gDLLP3Wkn9qpG5UhxUGPOcn1q_kpP2WexjQ1+LvXFg@mail.gmail.com>
	<CALx5=V-+aCcOMXHPrxmqVHwaiosNurT17gHBTi0mTdYJ6bZRMA@mail.gmail.com>
	<CAD2nsn2KrgLh-Oth-npUjY59bh2ycpEv7UocfXH0uE27TD19fQ@mail.gmail.com>
	<CALx5=V8s54ytfRVT2hscXCYRCj1MTdvKjM1jFa-OwxAyUMKFLw@mail.gmail.com>
Date: Sat, 23 Jun 2012 16:12:12 +0530
Message-ID: <CAD2nsn0qmRtwQGqG3GizxuPbPX_xh7Fwvgd9DchQuwA1T66XQA@mail.gmail.com> (sfid-20120623_124216_815684_2C002F82)
Subject: Re: Atheros [168c 0034] can't enable wireless button LED.
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Matt Chen <machen@suse.com>
Cc: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 22, 2012 at 2:45 PM, Matt Chen <machen@suse.com> wrote:
> Hi Mohammed,
>
> 2012/6/20 Mohammed Shafi <shafi.wireless@gmail.com>:
>> Hi Matt,
>>
>>> Both 0x2f and 0x2d can work fine to me of enabling
>>> wiphy_rfkill_start_polling() in gpio.c:ath_start_rfkill_poll().
>>>
>>> 1) with 0x2f
>>>   0x404c address would change when press wifi button
>>>   rfkill block : yes -> 0x00000455
>>>   rfkill block : no   -> 0x00000c55
>>> 2) with 0x2d
>>>   0x404c address would change when press wifi button
>>>   rfkill block : yes -> 0x00000455
>>>   rfkill block : no   -> 0x00000c55
>>>
>>>
>>> But I don't see the LED is changing, it is staying OFF (Amber).
>>
>> not sure about that, but i think rfkill is working for both of us
>> i told 0xeed changes to 0x6ed for me
>>
>> you got 0x455 changes to 0xc55
>>
>> BIT 12(GPIO pin 11 seems to toggle  4 ->C), you can confirm by rfkill list
> Would it be the patch to fix it ? or it is just a workaround to prove
> the rfkill_poll can be enabled ?

ideally, this should have been properly hard coded in the EEPROM stuff itself.
i think you got a very brand new AR9462 just when it came to the market :)
its a kind of workaround only.

-- 
thanks,
shafi
