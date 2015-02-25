Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:63423 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907AbbBYX7A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 18:59:00 -0500
Received: by mail-ob0-f173.google.com with SMTP id uy5so7635024obc.4
        for <linux-wireless@vger.kernel.org>; Wed, 25 Feb 2015 15:58:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150225103311.436f4321@north>
References: <544DB5A8.7090405@openmailbox.org>
	<20141027152026.GB19976@tuxdriver.com>
	<544E8CB4.3000607@rempel-privat.de>
	<20141028134608.GA26283@tuxdriver.com>
	<544FA303.5060303@broadcom.com>
	<544FA627.3000004@rempel-privat.de>
	<5450BEB2.60208@openwrt.org>
	<5461F937.9060004@rempel-privat.de>
	<5463CB6C.3030204@openwrt.org>
	<5463D28F.9080106@lwfinger.net>
	<20150206182915.7467bac7@north>
	<CABikg9yw8Py59KyJ1mP6bfCrMPuup7v9xb1J=_JKC4gT_GS4rA@mail.gmail.com>
	<20150225103311.436f4321@north>
Date: Thu, 26 Feb 2015 00:58:59 +0100
Message-ID: <CABikg9xU+vj_W+TF4d7=x52u8abhkXC0qPGsOgRUMXDhRA0NFQ@mail.gmail.com> (sfid-20150226_005904_836345_571A4AED)
Subject: Re: mt7601u dies during channel switch (was: MediaTek WiFi hardware
 support in upstream kernel)
From: Sergei Antonov <saproj@gmail.com>
To: =?UTF-8?Q?Jakub_Kici=C5=84ski?= <moorray3@wp.pl>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 February 2015 at 10:33, Jakub Kiciński <moorray3@wp.pl> wrote:
> On Wed, 25 Feb 2015 01:49:02 +0100, Sergei Antonov wrote:
>> On 6 February 2015 at 18:29, Jakub Kiciński <moorray3@wp.pl> wrote:
>> > Hello everyone!
>> >
>> > I put together a mac80211 driver for Mediatek MT7601U.  It's partially
>> > based on Felix's mt76, but I'm not sure if it will make sense to merge
>> > the two together.  MT7601U is a pretty old 1x1 bgn chip for USB dongles
>> > and mt76 now only supports the latest and greatest ac APs.
>> >
>> > I'm testing STA functionality right now and it seems to be working ok.
>> > The code is very much a work in progress but if anyone is interested you
>> > can get it here:
>> >
>> > https://github.com/kuba-moo/mt7601u
>>
>> Hi, Jakub! I happen to have 7601 dongle, so I tested you driver. There
>> were some problems, see "dmesg | grep mt7" output:
>
> OK, let me start with a set of basic questions.
>
> What device do you have (brand + model or picture on ebay please;))?

http://www.ebay.de/itm/221662285066

> What's the device ID?

Bus 003 Device 006: ID 148f:7601 Ralink Technology, Corp.

> What platform are you working on?

Linux linux64 3.19.0-05375-gd347efe #17 SMP Sun Feb 15 16:38:24 CET
2015 x86_64 GNU/Linux

> Is this error persistent or a one-time thing?

It is persistent.

> Does the vendor driver work with your device?

Yes. I took DPO_MT7601U_LinuxSTA_3.0.0.4_20130913.tar.bz2, applied
rt2870-mt7601Usta-kuid_t-kgid_t.patch (can bee easily googled, it is
needed to compile for recent kernels) and the device was able to
connect to my AP. The only suspicious thing was that the output to the
console was very verbose. I didn't take time to see if it was just
trace or a sign of a problem. I can repeat this and look more closely.
I can also look deeper into the critical moment between ch1 and ch2
you mention.

> Can you also show content of
> /sys/kernel/debug/ieee80211/phy*/mt76/eeprom_param
> ?

/sys/kernel/debug is empty on my machine.


>> [    3.174960] mt7601u 3-5:1.0: ASIC revision: 76010001  MAC revision: 76010500
>> [    3.181705] mt7601u 3-5:1.0: Firmware Version: 0.1.00 Build: 7640
>> Build time: 201302052146____
>> [    3.573018] mt7601u 3-5:1.0: Warning: unsupported EEPROM version 0d
>> [    3.574853] mt7601u 3-5:1.0: EEPROM ver:0d fae:00
>> [    3.816647] usbcore: registered new interface driver mt7601u
>> [   10.461251] mt7601u_add_interface idx:0
>> [   10.463193] mt7601u_bss_info_changed 0000000e
>> [   10.469748] mt7601u_conf_tx 03 <- 0000
>> [   10.473738] mt7601u_conf_tx 02 <- 0001
>> [   10.477856] mt7601u_conf_tx 01 <- 0002
>> [   10.481980] mt7601u_conf_tx 00 <- 0003
>> [   10.486849] mt7601u_bss_info_changed 00002000
>> [   10.488671] mt7601u_config ffffffff ch:1
>> [   10.504305] mt76_configure_filter changed:0 total:80000000
>> [   10.508327] mt76_configure_filter changed:0 total:80000000
>> [   10.550671] mt76_configure_filter changed:0 total:80000000
>> [   10.616870] mt7601u_config 00000100 ch:1
>> [   10.619449] mt76_configure_filter changed:10 total:80000010
>> [   10.621541] mt7601u_config 00000040 ch:1
>> [   10.692407] mt7601u_config 00000040 ch:2
>> [   10.992113] mt7601u 3-5:1.0: Warning: mt7601u_mcu_wait_resp retrying
>> [   11.291819] mt7601u 3-5:1.0: Warning: mt7601u_mcu_wait_resp retrying
>> [   11.591524] mt7601u 3-5:1.0: Warning: mt7601u_mcu_wait_resp retrying
>> [   11.891230] mt7601u 3-5:1.0: Warning: mt7601u_mcu_wait_resp retrying
>> [   12.190936] mt7601u 3-5:1.0: Warning: mt7601u_mcu_wait_resp retrying
>> [   12.192790] mt7601u 3-5:1.0: Error: mt7601u_mcu_wait_resp timed out
>
> Firmware clearly died somewhere between switch to channel 1 and to
> channel 2...  I made some changes to the FW loading routine, I will try
> to check the traces later today to confirm that I didn't break anything.
>
>> Is it because of "unsupported EEPROM version 0d"?
>
> Don't think so.  It's just for compatibility with vendor driver,
> they warn too.  All new devices have EEPROM ver == 0x0d though.  I plan
> to ask MediaTek about it in a week or two (Chinese New Year) and
> remove the warning.

I did 'git pull' now, recompiled the driver, rebooted. Here is the
relevant piece of dmesg output:

[   10.931816] mt7601u_add_interface idx:0
[   10.933012] mt7601u_bss_info_changed 0000000e
[   10.934126] [prot transition] mode:0000 bgprot:0 non-gf:0 non-ht:0
[   10.937859] mt7601u_conf_tx 03 <- 0000
[   10.942100] mt7601u_conf_tx 02 <- 0001
[   10.945173] mt7601u_conf_tx 01 <- 0002
[   10.949340] mt7601u_conf_tx 00 <- 0003
[   10.952607] mt7601u_bss_info_changed 00002000
[   10.953611] mt7601u_config ffffffff ch:1
[   10.967710] mt76_configure_filter changed:0 total:80000000
[   10.967725] IPv6: ADDRCONF(NETDEV_UP): wlan1: link is not ready
[   10.970070] mt76_configure_filter changed:0 total:80000000
[   10.980384] cfg80211: Calling CRDA to update world regulatory domain
[   11.012397] mt76_configure_filter changed:0 total:80000000
[   11.080505] mt7601u_config 00000100 ch:1
[   11.082447] mt76_configure_filter changed:10 total:80000010
[   11.083827] mt7601u_config 00000040 ch:1
[   11.128025] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.2
domain=0x0007 address=0x00000000c99a6000 flags=0x0010]
[   11.129175] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.2
domain=0x0007 address=0x00000000c99a6040 flags=0x0010]
[   11.155951] mt7601u_config 00000040 ch:2
[   11.455658] mt7601u 3-5:1.0: Warning: mt7601u_mcu_wait_resp retrying
[   11.755362] mt7601u 3-5:1.0: Warning: mt7601u_mcu_wait_resp retrying
[   12.055067] mt7601u 3-5:1.0: Warning: mt7601u_mcu_wait_resp retrying
[   12.354758] mt7601u 3-5:1.0: Warning: mt7601u_mcu_wait_resp retrying
[   12.654476] mt7601u 3-5:1.0: Warning: mt7601u_mcu_wait_resp retrying
[   12.655597] mt7601u 3-5:1.0: Error: mt7601u_mcu_wait_resp timed out
[   12.656593] mt7601u_config 00000040 ch:3
[   13.154228] mt7601u 3-5:1.0: Error: send MCU cmd failed:-110
[   13.155318] mt7601u_config 00000040 ch:4
[   13.653709] mt7601u 3-5:1.0: Error: send MCU cmd failed:-110

Note the two messages about IO_PAGE_FAULT in device 00:12.2. This
device is a USB controller:
[    2.181191] ehci-pci 0000:00:12.2: EHCI Host Controller
But this controller is not guilty :), it works fine with other USB devices.

Don't know if it matters, there are two wlan devices in my computer:
wlan0 - ath9k, my main PCI WiFi card.
wlan1 - mt7601u, the device I'm testing.
