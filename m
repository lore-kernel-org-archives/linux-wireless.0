Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f179.google.com ([209.85.161.179]:32965 "EHLO
	mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932397AbcCSVDM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Mar 2016 17:03:12 -0400
Received: by mail-yw0-f179.google.com with SMTP id h65so34391452ywe.0
        for <linux-wireless@vger.kernel.org>; Sat, 19 Mar 2016 14:03:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3054426.yRobc0R5Xb@debian64>
References: <CAG4k0fCqB1KNLyHV5--pi1nSoDPnV3qM-yTB0T2jmgbnjmqvww@mail.gmail.com>
	<CAG4k0fCd7Q-0Nz+XH1U-A9jwFRdX_SbVJNO=m_qP_ZpVADQkVw@mail.gmail.com>
	<CAG4k0fDJ6KjK14Ja5fKpy8L4aGzWVwLTOGT6EvkVEDwS9qVdhw@mail.gmail.com>
	<3054426.yRobc0R5Xb@debian64>
Date: Sat, 19 Mar 2016 23:03:11 +0200
Message-ID: <CAG4k0fCd01XNNUVsGW09wy1ctiPgV6zBvu52xa9Qm_OeMGphRQ@mail.gmail.com> (sfid-20160319_220316_877638_76D968D0)
Subject: Re: carl1970: stops working at random periods on Ubuntu 15.05
From: alexander nekrasov <i.sinister@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've tried device on another computer booting from flashdrive with
Ubuntu 13.10 (kernel 3.8 as far as I remember) and bind/unbind work
OK. Then i booted on my computer from the same flash and everything
worked OK. So it seems its kernel/usb-system/driver issue. Another
thing that makes me think so is that only reboot helps to restore
device - if it would be device - plugging/unplugging would be enought

On 12 March 2016 at 22:59, Christian Lamparter <chunkeey@googlemail.com> wrote:
> On Friday, March 11, 2016 09:12:40 AM alexander nekrasov wrote:
>> Thanks for an answer, Christian! Adapter is getting hot sometimes
>> indeed. Also my adapter is usb2.0 but it was on extender with another
>> usb1.1 device. I plugged it into motherboards port directly but issue
>> still continue to happens. I  also tried reload host controller but it
>> did not help.
> In that case, this might be a problem with the host controller on your
> motherboard. I say "might", because it could also be that the ar9170
> device is damaged or that something else is going on. Can you test the
> device on a different PC and test if it fails in the same way?
>
> Other than that, there's not much you can do (easily). If you want
> to investigate the issue further, you would need probe the FUSB200
> in the device. The only place you can do that is within the firmware
> as the USB subsystem is breaking down. The firmware can be downloaded
> from [0]. The register to look at is 0x1E110C (AR9170_USB_REG_DMA_STATUS).
>
> There are a few error bits that can be checked.
>
> Bit 24: Error when the upstream DMA access the data bus.
> Bit 25: Error when the upstream DMA access the command bus.
> Bit 26: Error when the downstream DMA access the data bus.
> Bit 27: Error when the downstream DMA access the command bus.
> Bit 28: Error when the CPU access the data bus.
> Bit 29: Error when the CPU access the command bus.
>
> If any of those bits are set, it's probably time to issue a
> firmware reboot (set fw.reboot to 1 or directly call "reboot();").
>
> That said, I don't have high hopes. In your logs, the carl9170
> driver is already trying to reset the device... and failing since
> it is unable to communicate with the device.
>
>> However I discovered strange behavior. Here is my
>> scenario:
>> 1. boot system
>> 2. check device is displayed by 'lsusb' and 'lsusb -t'
>> 3. unbind and bind root hub where device is plugged into
>> 4. this time 'lsusb' does list device and 'lsusb -t' does not
>>
>> Is it ok?
>>
>> After unbind/bind device definitely is not working - there is led
>> indicator and it is off. Should I 'enable' device after binding root
>> hub with another command?
>
> I would suggest you also contact the linux-usb mailing list [1].
> They may be able to debug why the host controller is not responding
> to the bind and unbind.
>
> [0] <https://wireless.wiki.kernel.org/en/users/drivers/carl9170.fw>
> [1] <http://www.linux-usb.org/mailing.html>
