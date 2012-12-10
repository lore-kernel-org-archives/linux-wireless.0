Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:36364 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab2LJVGe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 16:06:34 -0500
Received: by mail-vc0-f174.google.com with SMTP id d16so2913111vcd.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2012 13:06:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAMfPB_xV4fCK=G12EYKxgEDBYnOEEe45AmTFCBx67pKP4y+aYQ@mail.gmail.com>
References: <CAMfPB_wtsXjxFkY6M4cNjxDK678DV4VPjwDRzVOtgrf-4jDL-Q@mail.gmail.com>
	<50C61570.6040006@lwfinger.net>
	<CAMfPB_xV4fCK=G12EYKxgEDBYnOEEe45AmTFCBx67pKP4y+aYQ@mail.gmail.com>
Date: Mon, 10 Dec 2012 22:06:33 +0100
Message-ID: <CAMfPB_xBUDwmoHy4RiPZiCN7itYTHW9+n9eMj89YRrg-FkZrgQ@mail.gmail.com> (sfid-20121210_220636_824621_8CB467B1)
Subject: Re: 8192cu misbehaviours with RTL8188RU chipset
From: Alessandro Lannocca <alessandro.lannocca@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

P.S. I also tested a clean tree (no patches) with the same results.

2012/12/10 Alessandro Lannocca <alessandro.lannocca@gmail.com>:
> Thank you Larry for your suggestion, however I can't get any debug log
> out of my machine, it's probably an ubuntu fault (or I'm missing
> something); I even tried switching from rsyslogd to sysklogd and all
> debug=[1...5] combintations, all to no avail.
>
> This is my actual <modprobe -v rtl8192cu debug=4> output:
>
> <snip>
> insmod /lib/modules/3.5.0-19-generic/updates/net/wireless/cfg80211.ko
> insmod /lib/modules/3.5.0-19-generic/updates/net/mac80211/mac80211.ko
> insmod /lib/modules/3.5.0-19-generic/updates/drivers/net/wireless/rtlwifi/rtlwifi.ko
> insmod /lib/modules/3.5.0-19-generic/updates/drivers/net/wireless/rtlwifi/rtl8192c/rtl8192c-common.ko
> insmod /lib/modules/3.5.0-19-generic/updates/drivers/net/wireless/rtlwifi/rtl8192cu/rtl8192cu.ko
> debug=4
> </snip>
>
> Attached you can find dmesg i grepped from my (now virtualized) test
> system. kern.log/syslog don't offer any more info.
>
> After some more testing this is the situation:
>
> - Card goes mute some seconds after a succesfull disconnection
> (interval between disconnection and muting seems random, some seconds
> however)
> - Card doesn't correctly see associated clients in monitor mode (wpa
> networks, don't know if this applies to wep aswell), it corretly sees
> itself associated and only get its own 4-way wpa handshake, not
> others.
> - Led is fixed all the time, it should blink during rx/tx
> - regd.c has only a bunch of countries coded, if I set my regdom to IT
> I can't get chans 12-13 to work, while if I set it to EC (Italy is an
> ETSI member) I get proper channel list.
> - maximum txpower is hardcorded to 20dBm in regd.c, it isn't possible
> to modify it accordingly to regdom.
>
> As a side note, commit 4f03c1ed8901a01ad4abcef95c02c007a2d481c2 is
> giving some headaches in monitor mode, due to the fact that it renders
> impossible to switch channels while a mon* and a wlan* interface
> coexist (however this is not a bug, just my 2 cents)
>
> If you're willing to tell me which distribution/version combo you're
> using I would be very happy to virtualize it and get some useful debug
> info out of it, also I'm currently targeting compat-wireless 3.6.8-1;
> although these issues remains in daily snapshots until at least last
> week, feel free to tell me which  version should I be targeting.
>
> Thank you all for your time .
>
> Alex
>
> 2012/12/10 Larry Finger <Larry.Finger@lwfinger.net>:
>
>> Are you sure your patches are correct? The location that you used affects
>> *every* driver that uses mac80211, not just rtl8192cu.
>>
>> I just tested by having rtl8192cu unloaded, then I loaded it with 'sudo
>> modprobe -v rtl8192cu debug=5'. When I did that and plugged in the device,
>> my log was immediately "flooded" with the following:
>>
>> [ 3269.706508] rtl8192cu: Chip version 0x10
>> [ 3270.130396] rtl8192cu: MAC address: 00:1f:1f:c8:8e:cb
>> [ 3270.130423] rtl8192cu: Board Type 0
>> [ 3270.131246] rtlwifi: rx_max_size 15360, rx_urb_num 8, in_ep 1
>> [ 3270.131827] rtl8192cu: Loading firmware rtlwifi/rtl8192cufw.bin
>> [ 3270.132914] rtlwifi:rtl_fw_cb():<0-0> Firmware callback routine entered!
>> [ 3270.137746] ieee80211 phy2: Selected rate control algorithm 'rtl_rc'
>> [ 3270.150347] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0>
>> GPIO_IN=0b
>> [ 3270.150366] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> N-SS RF
>> =0
>> [ 3270.150373] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0>
>> pHalData->bHwRadioOff and eRfPowerStateToSet do not match:
>> pHalData->bHwRadioOff 0, eRfPowerStateToSet 0
>> [ 3270.150379] rtlwifi: wireless switch is on
>> [ 3270.150977] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0>
>> GPIO_IN=0b
>> [ 3270.150984] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> N-SS RF
>> =0
>> [ 3270.150990] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0>
>> pHalData->bHwRadioOff and eRfPowerStateToSet do not match:
>> pHalData->bHwRadioOff 0, eRfPowerStateToSet 0
>> [ 3270.608096] rtl8192cu:_rtl92cu_init_power_on():<0-0> Autoload Done!
>> [ 3270.617855] rtl8192cu: MAC auto ON okay!
>> [ 3270.723379] rtl8192cu: Tx queue select: 0x05
>> [ 3270.723591] rtl8192cu:rtl92c_set_network_type():<0-0> Set Network type to
>> NO LINK!
>> [ 3270.726441] rtl8192c_common:rtl92c_phy_set_bw_mode():<0-0> FALSE driver
>> sleep or unload
>> [ 3270.727029] rtl8192c_common:rtl92c_download_fw():<0-0> Firmware
>> Version(63), Signature(0x88c1),Size(32)
>> [ 3270.727251] rtl8192c_common:_rtl92c_write_fw():<0-0> FW size is 15982
>> bytes
>> [ 3270.745940] rtl8192c_common:_rtl92c_fw_free_to_go():<0-0> Checksum report
>> OK ! REG_MCUFWDL:0x00030004
>> [ 3270.751440] rtl8192c_common:_rtl92c_fw_free_to_go():<0-0> Polling FW
>> ready success!! REG_MCUFWDL:0x000300c6
>> [ 3270.751443] rtl8192c_common:rtl92c_download_fw():<0-0> Firmware is ready
>> to run!
>> [ 3270.751446] rtl8192cu:_rtl92cu_phy_config_mac_with_headerfile():<0-0>
>> Read Rtl819XMACPHY_Array
>> [ 3270.751448] rtl8192cu:_rtl92cu_phy_config_mac_with_headerfile():<0-0>
>> Img:RTL8192CEMAC_2T_ARRAY
>> [ 3270.757884] rtl8192c_common:_rtl92c_phy_bb8192c_config_parafile():<0-0>
>> ==>
>> [ 3270.757889] rtl8192c_common:rtl92c_phy_set_bb_reg():<0-0> regaddr(0x24),
>> bitmask(0xffffffff), data(0x11800f)
>> [ 3270.757968] rtl8192c_common:rtl92c_phy_set_bb_reg():<0-0> regaddr(0x24),
>> bitmask(0xffffffff), data(0x11800f)
>>
>> As you can see, that is about 1 second worth of logging. I suggest that you
>> use "debug=4" to start with. It is a lot less like "drinking from a
>> firehose".
>>
>> Larry
>>
