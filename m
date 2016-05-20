Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:38580 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbcETEwZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2016 00:52:25 -0400
Received: by mail-wm0-f53.google.com with SMTP id n129so64264385wmn.1
        for <linux-wireless@vger.kernel.org>; Thu, 19 May 2016 21:52:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <wrfjinyayf2i.fsf@redhat.com>
References: <1463594249-19524-1-git-send-email-dlenski@gmail.com> <wrfjinyayf2i.fsf@redhat.com>
From: Daniel Lenski <dlenski@gmail.com>
Date: Thu, 19 May 2016 21:51:43 -0700
Message-ID: <CAOw_LSHnV+244fT7YvEoV+7VSH_+OoGFmZSdGK4a3NqB407VGQ@mail.gmail.com> (sfid-20160520_065229_695494_D665154D)
Subject: Re: [PATCH] rtl8xxxu: increase polling timeout for firmware startup
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

You're welcome, and thanks for writing this great driver. It really
makes a huge difference for stability of the Yoga 13 wifi!

Unfortunately, I ran into a case today where even 5000 loops was not
enough after a cold boot. 5000 loops meant about 1.5 second delay
between finishing the firmware checksum poll, while waiting for the
firmware to start. It now appears to me that the number of required
polling loops must be strongly bimodal.

I added some logging, so that the driver reports to me the number of
loops required for the firmware to start.

[    7.726197] usb 1-1.4: Vendor: Realtek
[    7.726200] usb 1-1.4: Product: 802.11n WLAN Adapter
[    7.726203] usb 1-1.4: RTL8723AU rev B (TSMC) 1T1R, TX queues 2,
WiFi=1, BT=1, GPS=0, HI PA=0
[    7.726204] usb 1-1.4: RTL8723AU MAC: 20:16:d8:ce:5e:29
[    7.726206] usb 1-1.4: rtl8xxxu: Loading firmware
rtlwifi/rtl8723aufw_B_NoBT.bin
[    7.747313] usb 1-1.4: Firmware revision 31.0 (signature 0x2302)
[    7.842450] usb 1-1.4: Firmware checksum poll completed after 0 loops
[    9.271023] usb 1-1.4: Firmware failed to start after 5000 loops
[    9.271026] usb 1-1.4: Enabling HT_20_40 on the 2.4GHz band

After manual rmmod and modprobe, the firmware startup then completes
in a small number of loops (23 is most common):

[  207.334435] usbcore: deregistering interface driver rtl8xxxu
[  207.337394] usb 1-1.4: rtl8xxxu_int_complete: Error -108
[  207.342254] usb 1-1.4: disconnecting
[  207.586628] usb 1-1.4: Vendor: Realtek
[  207.586638] usb 1-1.4: Product: 802.11n WLAN Adapter
[  207.586646] usb 1-1.4: RTL8723AU rev B (TSMC) 1T1R, TX queues 2,
WiFi=1, BT=1, GPS=0, HI PA=0
[  207.586651] usb 1-1.4: RTL8723AU MAC: 20:16:d8:ce:5e:29
[  207.586657] usb 1-1.4: rtl8xxxu: Loading firmware
rtlwifi/rtl8723aufw_B_NoBT.bin
[  207.586748] usb 1-1.4: Firmware revision 31.0 (signature 0x2302)
[  207.669288] usb 1-1.4: Firmware checksum poll completed after 0 loops
[  207.675421] usb 1-1.4: Firmware ready to start after 23 loops
[  208.118745] usb 1-1.4: Enabling HT_20_40 on the 2.4GHz band

After wakeup from suspend, the firmware startup again completes in 23 loops:

[  281.660333] usb 1-1.4: Vendor: Realtek
[  281.660337] usb 1-1.4: Product: 802.11n WLAN Adapter
[  281.660343] usb 1-1.4: RTL8723AU rev B (TSMC) 1T1R, TX queues 2,
WiFi=1, BT=1, GPS=0, HI PA=0
[  281.660347] usb 1-1.4: RTL8723AU MAC: 20:16:d8:ce:5e:29
[  281.660351] usb 1-1.4: rtl8xxxu: Loading firmware
rtlwifi/rtl8723aufw_B_NoBT.bin
[  281.660369] usb 1-1.4: Firmware revision 31.0 (signature 0x2302)
[  281.742107] usb 1-1.4: Firmware checksum poll completed after 0 loops
[  281.748214] usb 1-1.4: Firmware ready to start after 23 loops
[  282.191088] usb 1-1.4: Enabling HT_20_40 on the 2.4GHz band
[  282.192740] PM: Finishing wakeup.

I would like to do some more testing and logging try to better map the
bimodal distribution, but I can't figure out a way to automatically
produce a large number of cold boots.

Thanks,
Dan

On May 18, 2016 7:08 PM, "Jes Sorensen" <Jes.Sorensen@redhat.com> wrote:
>
> Dan Lenski <dlenski@gmail.com> writes:
> > Here is a patch to increase the polling timeout for rtl8xxxu firmware
> > startup.
> >
> > This patch now applies cleanly to Jes Sorensen's rtl8xxxu-devel tree
> > (86c89dd4782030c4f9e0c82424a8b92f9fdb35aa).
> >
> > The patch to make this a module parameter was removed.
> >
> > Dan Lenski (1):
> >   rtl8xxxu: Increase default polling timeout for firmware startup
> >
> >  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Dan,
>
> Thanks for the patch, I'll apply it shortly.
>
> Cheers,
> Jes
