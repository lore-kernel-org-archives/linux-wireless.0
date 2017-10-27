Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:44976 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751457AbdJ0B2B (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Oct 2017 21:28:01 -0400
Received: by mail-ua0-f196.google.com with SMTP id f46so3838372uae.1
        for <linux-wireless@vger.kernel.org>; Thu, 26 Oct 2017 18:28:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171026220013.GC9888@us.netrek.org>
References: <CABkE59DHPoLD5PGRHpKMAwy0w3vR9M_qoHEQ1AkK-ELDcUXD9Q@mail.gmail.com>
 <5f907d16-b889-f7c0-0873-880e5c812ab9@lwfinger.net> <CABkE59A2Cr5mx3W_rkHj+qDtu6t-MQ2V_sJPfuuqF4vbJ7YfmQ@mail.gmail.com>
 <20171026220013.GC9888@us.netrek.org>
From: David Ashley <dashxdr@gmail.com>
Date: Thu, 26 Oct 2017 20:28:00 -0500
Message-ID: <CABkE59BgQ-nk-yQ2XY-T2QTfshQghv3zYiyydnj7t0ek7qSCWQ@mail.gmail.com> (sfid-20171027_032805_508721_E0ACB310)
Subject: Re: RTL usb adapter question
To: James Cameron <quozl@laptop.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I opened up the dongle, it has these things inside (aside from 2 coils
and various resistors and capacitors)
1)
48 pin chip (9 pins, 15 pins, 9 pins, 15 pins)
REALTEK
RTL8188CUS
F6J23P2
GF27 TAIWAN

6 pin chip (3 pins,3 pins)
BZ5JA

40.0 mhz crystal oscillator

I was thinking maybe some serial eeprom would be included, but there wasn't one.

-Dave


On 10/26/17, James Cameron <quozl@laptop.org> wrote:
> Base on your evidence, I'd say the device is different to others and
> has firmware included.
>
> On Thu, Oct 26, 2017 at 04:45:54PM -0500, David Ashley wrote:
>> OK I'm completely baffled.
>>
>> I have explicitly removed all rtlwifi/ firmware files from the root
>> filesystem and yet the usb dongle still works, even after a power
>> cycle. How can it possibly be getting its firmware file????????
>>
>> Here are the relevant kernel messages. There is no file
>> rtl8192cufw.bin anywhere for the kernel to find...
>> root@30046:~# ls -l /lib/firmware/rtlwifi/
>> total 0
>>
>> I have ensured there is no *OTHER* route to the internet such that the
>> driver (or udev) can magically get the firmware file from the
>> internet...
>>
>> Here's other info that may be useful...
>>
>> root@30046:~# zcat /proc/config.gz | grep FIRM
>> CONFIG_PREVENT_FIRMWARE_BUILD=y
>> CONFIG_FIRMWARE_IN_KERNEL=y
>> CONFIG_EXTRA_FIRMWARE="am335x-pm-firmware.elf
>> am335x-bone-scale-data.bin am335x-evm-scale-data.bin
>> am43x-evm-scale-data.bin"
>> CONFIG_EXTRA_FIRMWARE_DIR="firmware"
>> # CONFIG_LIBERTAS_THINFIRM is not set
>> # CONFIG_FIRMWARE_MEMMAP is not set
>> # CONFIG_TEST_FIRMWARE is not set
>> root@30046:~# cat /proc/version
>> Linux version 4.1.19-bone20 (dash@DaveDesktop) (gcc version 5.4.0
>> 20160609 (Ubuntu/Linaro 5.4.0-6ubuntu1~16.04.4) ) #2 Tue Oct 3
>> 17:25:35 CDT 2017
>> root@30046:~# lsusb
>> Bus 001 Device 002: ID 7392:7811 Edimax Technology Co., Ltd EW-7811Un
>> 802.11n Wireless Adapter [Realtek RTL8188CUS]
>>
>> ... ifconfig
>> wlan0     Link encap:Ethernet  HWaddr 74:da:38:61:f1:2c
>>           inet addr:192.168.10.31  Bcast:192.168.10.255
>> Mask:255.255.255.0
>>           inet6 addr: fe80::76da:38ff:fe61:f12c/64 Scope:Link
>>           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
>>           RX packets:509 errors:0 dropped:0 overruns:0 frame:0
>>           TX packets:146 errors:0 dropped:0 overruns:0 carrier:0
>>           collisions:0 txqueuelen:1000
>>           RX bytes:60812 (59.3 KiB)  TX bytes:16365 (15.9 KiB)
>>
>>
>>
>>
>> [    9.663796] rtl8192cu: Chip version 0x10
>> [    9.745394] cfg80211: Calling CRDA to update world regulatory domain
>> [    9.844311] random: nonblocking pool is initialized
>> [    9.877851] rtl8192cu: MAC address: 74:da:38:61:f1:2c
>> [    9.877883] rtl8192cu: Board Type 0
>> [    9.877989] rtl_usb: rx_max_size 15360, rx_urb_num 8, in_ep 1
>> [    9.878098] rtl8192cu: Loading firmware rtlwifi/rtl8192cufw_TMSC.bin
>> [    9.878249] usb 1-1: Direct firmware load for
>> rtlwifi/rtl8192cufw_TMSC.bin failed with error -2
>> [    9.889781] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
>> [    9.890862] usbcore: registered new interface driver rtl8192cu
>> [    9.897667] usb 1-1: Direct firmware load for
>> rtlwifi/rtl8192cufw.bin failed with error -2
>> [    9.906030] rtlwifi: Loading alternative firmware
>> rtlwifi/rtl8192cufw.bin
>> [    9.906037] rtlwifi: Firmware rtlwifi/rtl8192cufw_TMSC.bin not
>> available
>> [   11.316476] rtl8192cu: MAC auto ON okay!
>> [   11.333847] rtl8192cu: Tx queue select: 0x05
>> [   12.364722] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
>> [   12.905367] cfg80211: Calling CRDA to update world regulatory domain
>> [   13.413043] rtl8192cu: MAC auto ON okay!
>> [   13.430371] rtl8192cu: Tx queue select: 0x05
>> [   15.795679] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
>> [   16.065356] cfg80211: Calling CRDA to update world regulatory domain
>> [   19.225333] cfg80211: Calling CRDA to update world regulatory domain
>> [   21.582749] wlan0: authenticate with 70:4d:7b:1d:91:40
>> [   21.600676] wlan0: send auth to 70:4d:7b:1d:91:40 (try 1/3)
>> [   21.605390] wlan0: authenticated
>> [   21.615431] wlan0: associate with 70:4d:7b:1d:91:40 (try 1/3)
>> [   21.667523] wlan0: RX AssocResp from 70:4d:7b:1d:91:40 (capab=0x411
>> status=0 aid=5)
>> [   21.669000] wlan0: associated
>> [   21.669671] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
>> [   22.385320] cfg80211: Calling CRDA to update world regulatory domain
>> [   25.545336] cfg80211: Calling CRDA to update world regulatory domain
>> [   28.705312] cfg80211: Calling CRDA to update world regulatory domain
>> [   31.865335] cfg80211: Calling CRDA to update world regulatory domain
>> [   35.025348] cfg80211: Exceeded CRDA call max attempts. Not calling
>> CRDA
>>
>>
>> Thanks!!!!!!
>> -Dave
>>
>> On 10/25/17, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> > On 10/25/2017 01:43 PM, David Ashley wrote:
>> >> I'm trying to understand how the linux kernel loads RTL8188CUS
>> >> firmware
>> >> rtlwifi: Loading alternative firmware rtlwifi/rtl8192cufw.bin
>> >> when that file isn't available anywhere in my embedded system's
>> >> filesystem.
>> >>
>> >> Basically I'm trying to understand the theory. We have a product that
>> >> is making use of the device
>> >>
>> >> Bus 001 Device 007: ID 7392:7811 Edimax Technology Co., Ltd
>> >> EW-7811Un802.11n Wireless Adapter [Realtek RTL8188CUS]
>> >>
>> >> It has not been especially reliable. I've never provided firmware
>> >> files for the device in the root filesystem. I've started to pay
>> >> attention to the kernel error messages. Now the kernel drivers seem to
>> >> be loading the rtlwifi/rtl8192cufw_TMSC.bin file and I'm trying to
>> >> understand if this is actually working, if it makes any difference in
>> >> reliability...
>> >>
>> >> It's like I can't figure out how the usb dongle even worked without
>> >> its firmware file...
>> >>
>> >> My working theory is that the usb dongle comes from the factory with a
>> >> hardcoded firmware file (rtlwifi/rtl8192cufw.bin) but it is buggy or
>> >> inferior. And the performance and reliability can be improved if the
>> >> driver successfully manages to load the rtl8192cufw_TMSC.bin file. I
>> >> don't know if the firmware load persists across a power cycle (my
>> >> assumption is it doesn't).
>> >
>> > There is NO firmware coded by the factory in the device. It only has
>> > enough
>> >
>> > intelligence to load the real firmware. The exact file that it loads is
>> > determined by the model. If you provide the appropriate section of the
>> > output of
>> > dmesg where the above firmware messages occur, and a file listing of
>> > /lib/firmware/rtlwifi/, I can tell you what firmware is being loaded.
>> >
>> > No, firmware will not persist across a power failure.
>> >
>> > The driver has never been particularly reliable, and the USB group at
>> > Realtek
>> > seems not to care. You might try their other driver, but you will be on
>> > your
>> >
>> > own, as I will not support that particular piece of ****.
>> >
>> > Please reply to all on any followups.
>> >
>> > Larry
>> >
>> >
>
> --
> James Cameron
> http://quozl.netrek.org/
>
