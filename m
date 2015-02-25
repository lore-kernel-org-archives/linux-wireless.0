Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:44793 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbbBYAtD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 19:49:03 -0500
Received: by mail-oi0-f43.google.com with SMTP id z81so575605oif.2
        for <linux-wireless@vger.kernel.org>; Tue, 24 Feb 2015 16:49:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150206182915.7467bac7@north>
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
Date: Wed, 25 Feb 2015 01:49:02 +0100
Message-ID: <CABikg9yw8Py59KyJ1mP6bfCrMPuup7v9xb1J=_JKC4gT_GS4rA@mail.gmail.com> (sfid-20150225_014907_655794_A4E7A460)
Subject: Re: MediaTek WiFi hardware support in upstream kernel
From: Sergei Antonov <saproj@gmail.com>
To: =?UTF-8?Q?Jakub_Kici=C5=84ski?= <moorray3@wp.pl>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6 February 2015 at 18:29, Jakub Kiciński <moorray3@wp.pl> wrote:
> Hello everyone!
>
> I put together a mac80211 driver for Mediatek MT7601U.  It's partially
> based on Felix's mt76, but I'm not sure if it will make sense to merge
> the two together.  MT7601U is a pretty old 1x1 bgn chip for USB dongles
> and mt76 now only supports the latest and greatest ac APs.
>
> I'm testing STA functionality right now and it seems to be working ok.
> The code is very much a work in progress but if anyone is interested you
> can get it here:
>
> https://github.com/kuba-moo/mt7601u

Hi, Jakub! I happen to have 7601 dongle, so I tested you driver. There
were some problems, see "dmesg | grep mt7" output:

[    3.174960] mt7601u 3-5:1.0: ASIC revision: 76010001  MAC revision: 76010500
[    3.181705] mt7601u 3-5:1.0: Firmware Version: 0.1.00 Build: 7640
Build time: 201302052146____
[    3.573018] mt7601u 3-5:1.0: Warning: unsupported EEPROM version 0d
[    3.574853] mt7601u 3-5:1.0: EEPROM ver:0d fae:00
[    3.816647] usbcore: registered new interface driver mt7601u
[   10.461251] mt7601u_add_interface idx:0
[   10.463193] mt7601u_bss_info_changed 0000000e
[   10.469748] mt7601u_conf_tx 03 <- 0000
[   10.473738] mt7601u_conf_tx 02 <- 0001
[   10.477856] mt7601u_conf_tx 01 <- 0002
[   10.481980] mt7601u_conf_tx 00 <- 0003
[   10.486849] mt7601u_bss_info_changed 00002000
[   10.488671] mt7601u_config ffffffff ch:1
[   10.504305] mt76_configure_filter changed:0 total:80000000
[   10.508327] mt76_configure_filter changed:0 total:80000000
[   10.550671] mt76_configure_filter changed:0 total:80000000
[   10.616870] mt7601u_config 00000100 ch:1
[   10.619449] mt76_configure_filter changed:10 total:80000010
[   10.621541] mt7601u_config 00000040 ch:1
[   10.692407] mt7601u_config 00000040 ch:2
[   10.992113] mt7601u 3-5:1.0: Warning: mt7601u_mcu_wait_resp retrying
[   11.291819] mt7601u 3-5:1.0: Warning: mt7601u_mcu_wait_resp retrying
[   11.591524] mt7601u 3-5:1.0: Warning: mt7601u_mcu_wait_resp retrying
[   11.891230] mt7601u 3-5:1.0: Warning: mt7601u_mcu_wait_resp retrying
[   12.190936] mt7601u 3-5:1.0: Warning: mt7601u_mcu_wait_resp retrying
[   12.192790] mt7601u 3-5:1.0: Error: mt7601u_mcu_wait_resp timed out
[   12.194491] mt7601u_config 00000040 ch:3
[   12.694660] mt7601u 3-5:1.0: Error: send MCU cmd failed:-110
[   12.696360] mt7601u_config 00000040 ch:4
[   13.194210] mt7601u 3-5:1.0: Error: send MCU cmd failed:-110
[   13.195873] mt7601u_config 00000040 ch:5
[   13.693674] mt7601u 3-5:1.0: Error: send MCU cmd failed:-110
[   13.695283] mt7601u_config 00000040 ch:6
[   14.193225] mt7601u 3-5:1.0: Error: send MCU cmd failed:-110
[   14.194808] mt7601u_config 00000040 ch:7
[   14.692677] mt7601u 3-5:1.0: Error: send MCU cmd failed:-110
[   14.694374] mt7601u_config 00000040 ch:8
[   15.192232] mt7601u 3-5:1.0: Error: send MCU cmd failed:-110
[   15.193766] mt7601u_config 00000040 ch:9
[   15.691688] mt7601u 3-5:1.0: Error: send MCU cmd failed:-110
[   15.693268] mt7601u_config 00000040 ch:10
[   16.191318] mt7601u 3-5:1.0: Error: send MCU cmd failed:-110
[   16.192891] mt7601u_config 00000040 ch:11
[   16.690710] mt7601u 3-5:1.0: Error: send MCU cmd failed:-110
[   16.692282] mt7601u_config 00000040 ch:12
[   17.190270] mt7601u 3-5:1.0: Error: send MCU cmd failed:-110
[   17.191771] mt7601u_config 00000040 ch:13
[   17.689713] mt7601u 3-5:1.0: Error: send MCU cmd failed:-110
[   17.691243] mt7601u_config 00000040 ch:14
[   18.189290] mt7601u 3-5:1.0: Error: send MCU cmd failed:-110
[   18.190810] mt7601u_config 00000040 ch:1
[   18.688839] mt7601u 3-5:1.0: Error: send MCU cmd failed:-110
[   18.690304] mt76_configure_filter changed:0 total:80000000
[   18.692461] mt7601u_config 00000100 ch:1

Is it because of "unsupported EEPROM version 0d"?
