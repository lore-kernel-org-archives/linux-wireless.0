Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64645 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab0FLE2E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jun 2010 00:28:04 -0400
Received: by pwi1 with SMTP id 1so1098558pwi.19
        for <linux-wireless@vger.kernel.org>; Fri, 11 Jun 2010 21:28:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimuFeal0x-j3wZ3MpP0lnLZfX8lO1R45nF74DCx@mail.gmail.com>
References: <AANLkTinpYdb9Q_AEdUc7gvEIcxZoCFyVaKMIi6c_Sf9n@mail.gmail.com>
	<AANLkTinPM1byJy-y8GChXbAdYQuCvgiQRISWfmBRKoJu@mail.gmail.com>
	<AANLkTimuFeal0x-j3wZ3MpP0lnLZfX8lO1R45nF74DCx@mail.gmail.com>
From: Assim Deodia <assim.deodia@gmail.com>
Date: Sat, 12 Jun 2010 09:57:43 +0530
Message-ID: <AANLkTinRyKGntYZ7dqRWTql3dIfzEHEf5yFPfYL-D6sg@mail.gmail.com>
Subject: Re: no eth0 on using libertas_tf + F11 on OLPC XO-1
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In my system eth0 is the wireless interface. There is no wlan0. and
after loading libertas_tf there is neither wlan0 nor eth0 interface.

I also tried renaming the eth0 to wlan0 in
/etc/udev/rules.d/70-persistent-net.rules and renaming
/etc/sysconfig/network-scripts/*-eth* to *-wlan*. Now i have wlan
interface which also disappears on loading libertas_tf.



2010/6/12 Gábor Stefanik <netrolller.3d@gmail.com>:
> On Fri, Jun 11, 2010 at 10:08 PM, Assim Deodia <assim.deodia@gmail.com> wrote:
>> Hi All,
>>
>> I am having some issues loading libertas_tf on XO-1 with kernel 2.6.31.
>>
>> 1) after unloading libertas and usb8xxx modules when i modprobe
>> libertas_tf module eth0 (wireless interface) disappears. and instead
>> wmaster0 appears. but iwconfig show  wmaster0 does not have wireless
>> extensions. lsmod shows libertas_tf and libertas_tf_usb module loaded.
>> No error in system logs. no error by modprobe. but no wireless
>> interface. Do i have to pass any parameter while loading libertas_tf?
>> I have also tried installing all the firmware versions from
>> http://dev.laptop.org/pub/firmware/libertas/thinfirm/ just to be sure.
>> I have installed the kernel after build its RPM
>> (http://dev.laptop.org/~assim/kernel_rpms/) on XO itself.
>>
>> 2) I also tried blacklisting libertas and usb8xxx modules but still
>> they are loading at boot time. again no error in logs.
>>
>> I am stuck as i am not getting any error message at all.
>>
>> --
>> Assim Deodia
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> With libertas_tf, it is completely normal to have no eth0 interface,
> as it is a mac80211 driver, and thus registers interfaces with the
> "wlan" prefix, rather than "eth". So, you should be seeing a "wlan0"
> interface.
>
> --
> Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
>



-- 
Assim Deodia
Software Developer
One97 Communications Ltd, Noida
P: + 91 120 4770770
M: + 91 9911804112

Let’s Get Talking!
