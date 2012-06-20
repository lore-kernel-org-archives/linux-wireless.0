Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:39520 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709Ab2FTIxx convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-wireless@vger.kernel.org:0:0>);
	Wed, 20 Jun 2012 04:53:53 -0400
Received: by vcbf11 with SMTP id f11so3690046vcb.19
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jun 2012 01:53:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALx5=V-MEZVNkQ0SqqtLqBcDG_Dkp1V6XjiZEv4BBSVn9JQpCw@mail.gmail.com>
References: <CALx5=V--5TEC2J39xdJn1fxLbmgEXsWwxbAVaXMsw=Lk2WxKRg@mail.gmail.com>
	<CAD2nsn04Bi5aNMBMLWGm9uQwTXzT8GnDfHZcBP8-+vMEgqBCag@mail.gmail.com>
	<CALx5=V-MEZVNkQ0SqqtLqBcDG_Dkp1V6XjiZEv4BBSVn9JQpCw@mail.gmail.com>
Date: Wed, 20 Jun 2012 16:53:45 +0800
Message-ID: <CALx5=V-L83VUcRddP=hk_vB4AK5+uZ5Gcdbg+HSbhvqNurrMbQ@mail.gmail.com> (sfid-20120620_105357_181145_71E90662)
Subject: Re: Atheros [168c 0034] can't enable wireless button LED.
From: Matt Chen <machen@suse.com>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mohammed,

2012/6/20 Matt Chen <machen@suse.com>:
> Hi Mohammed,
>
> 2012/6/19 Mohammed Shafi <shafi.wireless@gmail.com>:
>> Hi Matt,
>>
>>> I tested the latest kernel v3.5-rc3 ath9k for the Atheros [168c 0034],
>>> code name is Miami. I found no matter how I press the wifi button to
>>> enable/disable the wifi, it doesn't work to me.
>>> Even I found the rfkill status for this interface is not changing.
>>
>> its a AR9462please poke at the register  #define AR_GPIO_IN  -> 0x402c : 0x404c)
> I do
> 1) echo 0x402c > regidx
>     watch -n 1 regval
> 2) echo 0x404c > regidx
>    watch -n1 regval
>> i remember testing it in a acer laptop, it was working.
> Both 1) and 2) shows no different in their value no matter how I press
> the wifi button. :(
I found it is not enabling the
wiphy_rfkill_start_polling() in gpio.c:ath_start_rfkill_poll(struct
ath_softc *sc).
The condition for (ah->caps.hw_caps & ATH9K_HW_CAP_RFSILENT) is failed.
Any direction I can dig further ? :)
>>>
>>> --
>>> Thank you.
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>> --
>> thanks,
>> shafi
>>
>
>
>
> --
> Thank you.



-- 
Thank you.
