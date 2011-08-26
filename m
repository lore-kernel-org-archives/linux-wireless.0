Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42477 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab1HZJAE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 05:00:04 -0400
Received: by vws1 with SMTP id 1so2727440vws.19
        for <linux-wireless@vger.kernel.org>; Fri, 26 Aug 2011 02:00:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E562608.9060700@broadcom.com>
References: <CAGwCZhqDBZ4QGC_+3Bdbk=vRCnr0=sVdyR3J7WWqExf_hZQpLA@mail.gmail.com>
	<4E54C87A.4080407@broadcom.com>
	<CAGwCZhrYA2e_dVf6uHDaTfC35m2wopdLCOit8UFDa8D9v_v3Tw@mail.gmail.com>
	<4E562608.9060700@broadcom.com>
Date: Fri, 26 Aug 2011 17:00:03 +0800
Message-ID: <CAGwCZhrkiu_yS1kSeEZqkznJeG3=+xdjgPAyhSLKjyXNwq9StA@mail.gmail.com> (sfid-20110826_110008_920134_0C8FE1E9)
Subject: Re: force wifi radio to sleep immediately
From: Hao Han <hhanwm@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you very much. Another related question is:

When a wireless interface works in master mode with new firmware
"fw_bcm4329_apsta.bin" launched, is there any way to set power mode to
PM_OFF, PM_FAST, PM_MAX?

My ultimate goal is to let the interface to sleep even in master mode.
Right now, I try to use "dev_wlc_ioctl(dev, WLC_SET_PM, &pm,
sizeof(pm))", but it doesn't work.

BTW, my test device is Nexus One and the broadcom driver is BCM4329.

Best,
Hao

On Thu, Aug 25, 2011 at 6:38 PM, Arend van Spriel <arend@broadcom.com> wrote:
> On 08/24/2011 12:12 PM, Hao Han wrote:
>>
>> Thank you for your quick reply, Gr. AvS.
>>
>> According to my understanding, in power save mode (PSM), the station
>> will go to sleep immediately (i.e. maintaining a very low power) after
>> sending packet with pwr mgt bit in 802.11 mac header setting to 1.
>>
>> My question is if we can force the station to go to such a low power
>> level by calling some function.
>>
>> It seems to me that it costs extra time to disable/enable the radio,
>> right? I hope to do it very quickly.
>>
>> I appreicate your help!
>>
>> Best,
>> Hao
>
> I see. Your question is really about power save, which involves more that
> the radio. Power save is a process better left to the device so there is no
> interface in place to force that upon a driver/device.
>
> Gr. AvS
>
> --
> Almost nobody dances sober, unless they happen to be insane.
> -- H.P. Lovecraft --
>
>
>
