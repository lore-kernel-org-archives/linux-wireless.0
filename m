Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:34610 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750717AbdFNOMm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Jun 2017 10:12:42 -0400
Received: by mail-qt0-f194.google.com with SMTP id o21so218370qtb.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jun 2017 07:12:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1497368606.32032.17.camel@synopsys.com>
References: <1497365348-2305-1-git-send-email-amit.karwar@redpinesignals.com> <1497368606.32032.17.camel@synopsys.com>
From: Amitkumar Karwar <amitkarwar@gmail.com>
Date: Wed, 14 Jun 2017 19:42:40 +0530
Message-ID: <CAEhWJFmWu2p=kawNiAKZ+QmWhzLBVkKdmDUi+oC+ffUkEN+vcg@mail.gmail.com> (sfid-20170614_161246_669264_8170AF2B)
Subject: Re: [PATCH 00/20] rsi driver enhancements
To: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "amit.karwar@redpinesignals.com" <amit.karwar@redpinesignals.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Alexey,

On Tue, Jun 13, 2017 at 9:13 PM, Alexey Brodkin
<Alexey.Brodkin@synopsys.com> wrote:
> Hi Amitkumar,
>
> On Tue, 2017-06-13 at 20:18 +0530, Amitkumar Karwar wrote:
>> This patch series includes some fixes and enhancements in Tx and Rx
>> data paths. Connection in open security and data traffic has been
>> verified with SDIO and USB variants of 9113 chipset.
>>
>> Amitkumar Karwar (1):
>>   rsi: correct the logic of deriving queue number
>>
>> Karun Eagalapati (14):
>>   rsi: fix sdio card reset problem
>>   rsi: chip reset for SDIO interface
>>   rsi: correct SDIO disconnect path handling
>>   rsi: card reset for USB interface
>>   rsi: USB tx headroom cleanup
>>   rsi: rename USB endpoint macros
>>   rsi: choose correct endpoint based on queue.
>>   rsi: set immediate wakeup bit
>>   rsi: separate function for management packet descriptor
>>   rsi: rename variable in_sdio_litefi_irq
>>   rsi: Optimise sdio claim and release host
>>   rsi: SDIO Rx packet processing enhancement
>>   rsi: use separate mutex lock for receive thread
>>   rsi: Rename mutex tx_rxlock to the tx_lock.
>>
>> Prameela Rani Garnepudi (1):
>>   rsi: changes in eeprom read frame
>>
>> pavani.muthyala (4):
>>   rsi: management frame descriptor preparation cleanup
>>   rsi: data packet descriptor code cleanup
>>   rsi: data packet descriptor enhancements
>>   rsi: separate function for data packet descriptor
>
> Finally with this patch-set I got new firmware [1] successfully loaded
> in rs9113 module via SDIO (but not via USB, read-on).
> --------------------------->8--------------------------
> rsi_91x: ***** Firmware Loading successful *****
> --------------------------->8--------------------------
>
> Also I may now execute "ifconfig wlan0 up" succesfully:

Good to know this.

> --------------------------->8--------------------------
> # ifconfig wlan0
> wlan0     Link encap:Ethernet  HWaddr 00:23:A7:90:3F:2C
>           UP BROADCAST MULTICAST  MTU:1500  Metric:1
>           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
>           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
>           collisions:0 txqueuelen:1000
>           RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
> --------------------------->8--------------------------
>
> Next thing I tried (and that's what I do with any other wireless
> adapter that supports AP mode) is adding wlan0 to a bridge with eth0
> with subsequent execution of hostapd to get me so-called dumb AP.

AP mode is not supported yet. We will be submitting patches for AP
mode in couple of weeks.

>
> Usually that's what I do:
> --------------------------->8--------------------------
> ifconfig wlan0 up
> ifconfig eth0 up
> brctl addbr br0
> brctl addif br0 eth0
> iw dev wlan0 set 4addr on
> brctl addif br0 wlan0
> brctl show
> ifconfig br0 up
> udhcpc -i br0
> hostapd -B /etc/hostapd.conf
> --------------------------->8--------------------------
>
> But now with rs9113 I got:
> 1)
> --------------------------->8--------------------------
> # iw dev wlan0 set 4addr on
> command failed: Operation not supported (-95)
> --------------------------->8--------------------------
>
> 2)
> --------------------------->8--------------------------
> # hostapd -B /etc/hostapd.conf
> Configuration file: /etc/hostapd.conf
> nl80211: Could not configure driver mode
> nl80211: deinit ifname=wlan0 disabled_11b_rates=0
> nl80211 driver initialization failed.
> wlan0: interface state UNINITIALIZED->DISABLED
> wlan0: AP-DISABLED
> hostapd_free_hapd_data: Interface wlan0 wasn't started
> --------------------------->8--------------------------
>
> For example exactly the same procedure works perfectly fine for
> ath9k_htc-based USB dongles.
>
> Now for USB-case there seems to remain similar problem with firmware loading:
> --------------------------->8--------------------------
> usb 1-1: new high-speed USB device number 2 using ehci-platform
> usb 1-1: config 1 interface 0 altsetting 0 endpoint 0x83 has an invalid bInterval 255, changing to 11
> rsi_91x: rsi_probe: Initialized os intf ops
> rsi_91x: rsi_load_firmware: REGOUT read timedout
> rsi_91x: rsi_load_firmware: Soft boot loader not present
> rsi_91x: rsi_hal_device_init: Failed to load TA instructions
> rsi_91x: rsi_probe: Failed in device init
> rsi_91x: rsi_probe: Failed in probe...Exiting
> RSI-USB WLAN: probe of 1-1:1.0 failed with error -22
> --------------------------->8--------------------------
>
> Any thoughts?

We are reading a ROM register here. If expected signature value is
present, we go ahead and download the firmware. In your case that
value isn't found. This could be USB connection/setup problem. Not
sure if it's related to the problem notified by "endpoint 0x83 has an
invalid bInterval" warning.

Regards,
Amitkumar Karwar
