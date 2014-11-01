Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:33805 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbaKALnW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2014 07:43:22 -0400
Received: by mail-la0-f42.google.com with SMTP id gq15so7523334lab.15
        for <linux-wireless@vger.kernel.org>; Sat, 01 Nov 2014 04:43:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CBACCFA0AEB13A41977475BCF3E896FC667010ED48@SC-VEXCH2.marvell.com>
References: <CAFf6pmS5w5jDr6O_ut7k5P6xbd9q9q1+H4iucihO2E8rq5kGfQ@mail.gmail.com>
	<CBACCFA0AEB13A41977475BCF3E896FC667010ED48@SC-VEXCH2.marvell.com>
Date: Sat, 1 Nov 2014 19:43:20 +0800
Message-ID: <CAFf6pmSBMBbhXrPPF+hoR49-aZt8ZLcfpM2qsFAXh4mFzQfWDA@mail.gmail.com> (sfid-20141101_124326_328307_91ADCF50)
Subject: Re: p2p doesn't work at 5GHz by using mwifiex driver
From: QW <qiuyew@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Avinash,

I am configuring the host not only as GC but also GO. The error occurs
by both roles.

The patch is already applied, but the TX error still occurs.

Below the p2p.conf I use:
------------------------------
ctrl_interface=/var/run/wpa_supplicant
ctrl_interface_group=root
eapol_version=2
update_config=1
device_name=mrvltest
device_type=1-0050F204-1
config_methods="keypad push_button virtual_display"
p2p_go_intent=0
persistent_reconnect=1
p2p_go_ht40=1
p2p_no_group_iface=1
country=US
-----------------------------------

Below a script I use to init the interface and start wpa_supplicant:
-----------------------------------
#!/bin/sh
WIFI_PATH=/home/root/
ifdown wlan0 down
killall wpa_supplicant

sleep 2
#Marvell wifi
rmmod mwifiex_sdio
rmmod mwifiex
rmmod cfg80211

sleep 2
insmod $WIFI_PATH/Marv/cfg80211.ko
insmod $WIFI_PATH/Marv/mwifiex.ko # reg_alpha2="US"
insmod $WIFI_PATH/Marv/mwifiex_sdio.ko

sleep 2
iw phy phy0 interface add wlan0 type __p2pcl

ifup wlan0
sleep 3

wpa_supplicant -iwlan0 -Dnl80211 -c/home/root/Marv/p2p.conf &
------------------------------

The steps I build the p2p-connection as follow:
1. run the init script, start wpa_cli
2. run p2p_find and see Wi-Fi Direct STA available in the smartphone
3. run p2p_connect <peer mac addr> pbc go_intent=15 (or without
go_intent) /or click connect STA on smartphone
4. click accept on the smartphone / or run p2p_connect <peer mac addr> pbc

Below the link of error log by pastebin (both as GO and GC):
http://pastebin.com/8zxYAtuX

As I mentioned in former Email, I test the same module with my x86
platform with same FW but driver from kernel 3.17.1, this issue never
occurs.

If I start wpa_supplicant with a sta conf, the host can connect my 5G
router without problem.
If I set a force_channel (freq=5745 for example) by p2p_connect, it
returns FAIL- UNSUPPORTED CHANNEL.
This channel seems however available in
/debugfs/ieee80211/phy0/ht40allow_map (host also connects the 5G
router at 5745Mhz).
My guess would be, it has something to do with regulatory, but I don't
know how to locate it.

Any idea?

BTW, the host uses yocto as build env and all patches to the host
should be already applied.

Thanks!

Cheers,
Qiuye

On Sun, Oct 26, 2014 at 10:15 PM, Avinash Patil <patila@marvell.com> wrote:
> Hi QW,
>
> Are you configuring P2P client or P2P GO?
> We recently have fixed one TX timeout issue. Can you please check if this patch helps:
>
> http://git.kernel.org/cgit/linux/kernel/git/linville/wireless-testing.git/commit/drivers/net/wireless/mwifiex?id=d76744a93246eccdca1106037e8ee29debf48277
>
> If this patch does not work for you, could you please share your p2p configuration file and steps?
>
> Thanks,
> Avinash
>
> -----Original Message-----
> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of QW
> Sent: Sunday, October 26, 2014 5:30 PM
> To: linux-wireless@vger.kernel.org
> Subject: p2p doesn't work at 5GHz by using mwifiex driver
>
> Hi All,
>
> I have a wifi/BT combo module with Marvell's SD8787 dual frequency (2.4GHz and 5GHz) chipset on it.
>
> When I try to build a p2p connection with other 5Ghz capable wireless device (Nexus 4), the connection will never be built at 5GHz.
> Same module I install on a linux-pc platform with kernel version
> 3.17.1 has no problem to build a 5G p2p connection.
>
> The firmware I am using is from the Marvell git repo at git://git.marvell.com/mwifiex-firmware.git
> Using this latest commit:
>
> commit 3f45b8c4cc1eb1d102bc3486b19677332dd215ab
> Author: Avinash Patil <patila@marvell.com>
> Date:   Fri Sep 12 21:05:15 2014 +0530
>
> linux-firmware: update Marvell SD8787 firmware version p52
>
> Version 14.66.35.p52
> Note that this version doesn't support BT-AMP.
> The image can be downloaded through either WLAN or Bluetooth.
>
> Signed-off-by: Avinash Patil <patila@marvell.com>
> Signed-off-by: Frank Huang <frankh@marvell.com>
>
> With iw phy phy0 info, I can see that 5GHz frequency is listed. And I can also use this module to connect a 5G wireless router without problem.
>
> The mwifiex driver is from kernel version 3.10.44, which is not allowed to be upgraded to the latest kernel version. I cannot use backports either, due to the 3.10 version.
>
> Besides, there is an sdio error occurs very often when a p2p connection is being built:
>
> [20525.984188] mwifiex_sdio mmc0:0001:1: 2022598 : Tx timeout(#1), bss_type-num = 2-0
>
> then the p2p connection will be failed to be built with the error:
>
> <3>P2P-GROUP-FORMATION-FAILURE
> <3>P2P-GROUP-REMOVED wlan0 GO reason=FORMATION_FAILED
>
> I don't know if this is related to the no-5GHz issue.
>
> Any ideas? Thanks!
>
> Cheers,
> Qiuye
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
