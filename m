Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f171.google.com ([209.85.220.171]:34620 "EHLO
	mail-fx0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab0CGPgq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Mar 2010 10:36:46 -0500
Received: by fxm19 with SMTP id 19so2352590fxm.1
        for <linux-wireless@vger.kernel.org>; Sun, 07 Mar 2010 07:36:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1267949782.15192.13.camel@mj>
References: <c785bba31003060945j22be2e78pfeaa1bcd39fcba2c@mail.gmail.com>
	<69e28c911003061007y258ec349laa802810e0517de4@mail.gmail.com>
	<1267949782.15192.13.camel@mj>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sun, 7 Mar 2010 16:36:23 +0100
Message-ID: <69e28c911003070736t678cf6ccld0fe6dc332f4380d@mail.gmail.com>
Subject: Re: Realtek rtl8188 support?
To: Pavel Roskin <proski@gnu.org>
Cc: Paul Thomas <pthomas8589@gmail.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/3/7 Pavel Roskin <proski@gnu.org>:
> On Sat, 2010-03-06 at 19:07 +0100, Gábor Stefanik wrote:
>> Doesn't the RTL8192SU driver handle this chipset already?
>
> Yes, I was able to test it.  I followed instructions from this site:
> http://blog.xff.lt/2009/12/28/canyon-cnp-wf518n2-usb-wireless-linux/
>
> I added the ID
>
> diff --git a/drivers/staging/rtl8192su/r8192U_core.c b/drivers/staging/rtl8192su/r8192U_core.c
> index 6f424fe..bec729f 100644
> --- a/drivers/staging/rtl8192su/r8192U_core.c
> +++ b/drivers/staging/rtl8192su/r8192U_core.c
> @@ -130,6 +130,7 @@ static struct usb_device_id rtl8192_usb_id_tbl[] = {
>        {USB_DEVICE(0x06f8, 0xe031)},
>        //92SU
>        {USB_DEVICE(0x0bda, 0x8172)},
> +       {USB_DEVICE(0x0bda, 0x8171)},
>        {}
>  };
>
>
> Then I downloaded the driver from
> http://xff.lt/stuff/canyon-wifi/rtl8192se_linux_2.6.0013.1204.2009.tar.gz
>
> I took rtl8192sfw.bin from it and put it to /lib/firmware/RTL8192SU (not
> RTL8192SE as in the archive).
>
> I was able to load the driver, bring the interface up and scan.  I could
> not connect to an AP with CCMP for some reason:
>
> # wpa_supplicant -c /etc/wpa_supplicant/mike1.conf -i wlan29 -D wext
> ioctl[SIOCSIWPMKSA]: Invalid argument
> ioctl[SIOCSIWPMKSA]: Invalid argument
> CTRL-EVENT-SCAN-RESULTS
> CTRL-EVENT-SCAN-RESULTS
> Trying to associate with 00:25:9c:28:15:62 (SSID='mike1' freq=2437 MHz)
> ioctl[SIOCSIWFREQ]: Operation not supported
> Association request to the driver failed

Maybe with an actual RTL8192SU firmware it would work... just my 2 HUF.

>
> But I was able to connect to an unsecured AP:
>
> wlan29    802.11b/g/n  li  ESSID:"mike2"
>          Mode:Managed  Frequency=2.437 GHz  Access Point: 00:26:5A:C2:4C:3D
>          Bit Rate=130 Mb/s
>          Retry min limit:7   RTS thr:off   Fragment thr:off
>          Encryption key:off
>          Power Management:off
>          Link Quality=89/100  Signal level=-56 dBm  Noise level=-114 dBm
>          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>          Tx excessive retries:0  Invalid misc:0   Missed beacon:0
>
> I could also use the firmware called rtl8192sfw492.bin by renaming it to
> rtl8192sfw.bin.
>
> --
> Regards,
> Pavel Roskin
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
