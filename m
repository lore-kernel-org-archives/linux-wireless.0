Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:57276 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaCYBsP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 21:48:15 -0400
Received: by mail-ob0-f170.google.com with SMTP id uz6so6787792obc.15
        for <linux-wireless@vger.kernel.org>; Mon, 24 Mar 2014 18:48:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a84c8a1f-f71b-48ca-9c8e-782c19aef609@email.android.com>
References: <CADqH6VygZFB4HEgcSesZB0cAhB4OvGnST+9mvTjw_QEAD_6QnQ@mail.gmail.com>
	<1384765780.22010.42.camel@porter.coelho.fi>
	<CADqH6VxgwbZkFgEkpiaabKekijeU+e=DMg0VVHoiXBQmjQfE0Q@mail.gmail.com>
	<a84c8a1f-f71b-48ca-9c8e-782c19aef609@email.android.com>
Date: Tue, 25 Mar 2014 09:48:14 +0800
Message-ID: <CADqH6VwvNPCeeXxSTYbbtQ8+Z=2ONXdfYDQUvqRv+W=FjsnC8w@mail.gmail.com> (sfid-20140325_024847_982984_FBF749AC)
Subject: Re: WL12xx support for WL1270 and ti-connectivity firmware
From: Jaya Kumar <jayakumar.lkml@gmail.com>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 25, 2014 at 2:32 AM, Luca Coelho <luca@coelho.fi> wrote:
>> The good news is that
>>the chip is detected and wl12xx/wl12xx_sdio loads. However, I haven't
>>been able to get it to get any scan results and can't associate with
>>any AP (even open).
>
> Usually this happens because you're not getting any interrupts. Are you sure the WLAN IRQ GPIO is correctly configured?
>
> There's nothing very useful in those kids
> It just shows that the scan command was issued but you never got the scan complete interrupt.
>

Hi Luca,

Thanks for your reply. I think the wlan irq gpio is configured. When I
look at /proc/interrupts, I see it increasing each time I try to scan.

I'll try to see how to switch to latest compat.

Thanks,
jaya

root@freescale ~$ modprobe wl12xx
root@freescale ~$ modprobe wl12xx_sdio
add wake up source irq 106
wl1271: loaded
wl1271: initialized
root@freescale ~$ cat /proc/interrupts
           CPU0
 34:          0       GIC  sdma
 51:          0       GIC  snvs_rtc
 55:      48913       GIC  mmc0
 56:        148       GIC  mmc1
 58:         81       GIC  IMX-uart
 63:          2       GIC  spi_imx
 68:        257       GIC  imx-i2c
 69:          0       GIC  imx-i2c
 75:         33       GIC  usb_wakeup, fsl-usb2-udc
 87:        675       GIC  i.MX Timer Tick
112:          0       GIC  imx2-wdt
114:          0       GIC  imx-keypad
121:          0       GIC  dvfs
130:          0       GIC  pxp-irq
391:          0      GPIO  wl1271
Err:          0
root@freescale ~$ ifconfig wlan0 up
wl1271: firmware booted (Rev 6.1.5.50.69)
root@freescale ~$ cat /proc/interrupts
           CPU0
 34:          0       GIC  sdma
 51:          0       GIC  snvs_rtc
 55:      49888       GIC  mmc0
 56:       6032       GIC  mmc1
 58:        121       GIC  IMX-uart
 63:          2       GIC  spi_imx
 68:        257       GIC  imx-i2c
 69:          0       GIC  imx-i2c
 75:         34       GIC  usb_wakeup, fsl-usb2-udc
 87:        732       GIC  i.MX Timer Tick
112:          0       GIC  imx2-wdt
114:          0       GIC  imx-keypad
121:          0       GIC  dvfs
130:          0       GIC  pxp-irq
391:          1      GPIO  wl1271
Err:          0
root@freescale ~$ iwlist wlan0 scan
wlan0     No scan results

root@freescale ~$ iw
-sh: iw: command not found
root@freescale ~$ cat /proc/interrupts
           CPU0
 34:          0       GIC  sdma
 51:          0       GIC  snvs_rtc
 55:      60085       GIC  mmc0
 56:       6248       GIC  mmc1
 58:        176       GIC  IMX-uart
 63:          2       GIC  spi_imx
 68:        257       GIC  imx-i2c
 69:          0       GIC  imx-i2c
 75:         35       GIC  usb_wakeup, fsl-usb2-udc
 87:        806       GIC  i.MX Timer Tick
112:          0       GIC  imx2-wdt
114:          0       GIC  imx-keypad
121:          0       GIC  dvfs
130:          0       GIC  pxp-irq
391:          7      GPIO  wl1271
Err:          0

root@freescale ~$ iwlist wlan0 scan
wlan0     No scan results

root@freescale ~$ cat /proc/interrupts
           CPU0
 34:          0       GIC  sdma
 51:          0       GIC  snvs_rtc
 55:      64141       GIC  mmc0
 56:       6464       GIC  mmc1
 58:        246       GIC  IMX-uart
 63:          2       GIC  spi_imx
 68:        257       GIC  imx-i2c
 69:          0       GIC  imx-i2c
 75:         36       GIC  usb_wakeup, fsl-usb2-udc
 87:        930       GIC  i.MX Timer Tick
112:          0       GIC  imx2-wdt
114:          0       GIC  imx-keypad
121:          0       GIC  dvfs
130:          0       GIC  pxp-irq
391:         13      GPIO  wl1271
Err:          0
