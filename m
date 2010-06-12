Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39932 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab0FLBja convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jun 2010 21:39:30 -0400
Received: by fxm8 with SMTP id 8so1211700fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 11 Jun 2010 18:39:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinPM1byJy-y8GChXbAdYQuCvgiQRISWfmBRKoJu@mail.gmail.com>
References: <AANLkTinpYdb9Q_AEdUc7gvEIcxZoCFyVaKMIi6c_Sf9n@mail.gmail.com>
	<AANLkTinPM1byJy-y8GChXbAdYQuCvgiQRISWfmBRKoJu@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sat, 12 Jun 2010 03:39:09 +0200
Message-ID: <AANLkTimuFeal0x-j3wZ3MpP0lnLZfX8lO1R45nF74DCx@mail.gmail.com>
Subject: Re: no eth0 on using libertas_tf + F11 on OLPC XO-1
To: Assim Deodia <assim.deodia@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 11, 2010 at 10:08 PM, Assim Deodia <assim.deodia@gmail.com> wrote:
> Hi All,
>
> I am having some issues loading libertas_tf on XO-1 with kernel 2.6.31.
>
> 1) after unloading libertas and usb8xxx modules when i modprobe
> libertas_tf module eth0 (wireless interface) disappears. and instead
> wmaster0 appears. but iwconfig show  wmaster0 does not have wireless
> extensions. lsmod shows libertas_tf and libertas_tf_usb module loaded.
> No error in system logs. no error by modprobe. but no wireless
> interface. Do i have to pass any parameter while loading libertas_tf?
> I have also tried installing all the firmware versions from
> http://dev.laptop.org/pub/firmware/libertas/thinfirm/ just to be sure.
> I have installed the kernel after build its RPM
> (http://dev.laptop.org/~assim/kernel_rpms/) on XO itself.
>
> 2) I also tried blacklisting libertas and usb8xxx modules but still
> they are loading at boot time. again no error in logs.
>
> I am stuck as i am not getting any error message at all.
>
> --
> Assim Deodia
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

With libertas_tf, it is completely normal to have no eth0 interface,
as it is a mac80211 driver, and thus registers interfaces with the
"wlan" prefix, rather than "eth". So, you should be seeing a "wlan0"
interface.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
