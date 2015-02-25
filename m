Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.9]:18627 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866AbbBYJdP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 04:33:15 -0500
Date: Wed, 25 Feb 2015 10:33:11 +0100
From: Jakub =?UTF-8?B?S2ljacWEc2tp?= <moorray3@wp.pl>
To: Sergei Antonov <saproj@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: mt7601u dies during channel switch (was: MediaTek WiFi hardware
 support in upstream kernel)
Message-ID: <20150225103311.436f4321@north> (sfid-20150225_103321_268839_40F03E44)
In-Reply-To: <CABikg9yw8Py59KyJ1mP6bfCrMPuup7v9xb1J=_JKC4gT_GS4rA@mail.gmail.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 25 Feb 2015 01:49:02 +0100, Sergei Antonov wrote:
> On 6 February 2015 at 18:29, Jakub Kiciński <moorray3@wp.pl> wrote:
> > Hello everyone!
> >
> > I put together a mac80211 driver for Mediatek MT7601U.  It's partially
> > based on Felix's mt76, but I'm not sure if it will make sense to merge
> > the two together.  MT7601U is a pretty old 1x1 bgn chip for USB dongles
> > and mt76 now only supports the latest and greatest ac APs.
> >
> > I'm testing STA functionality right now and it seems to be working ok.
> > The code is very much a work in progress but if anyone is interested you
> > can get it here:
> >
> > https://github.com/kuba-moo/mt7601u
> 
> Hi, Jakub! I happen to have 7601 dongle, so I tested you driver. There
> were some problems, see "dmesg | grep mt7" output:

OK, let me start with a set of basic questions.

What device do you have (brand + model or picture on ebay please;))?
What's the device ID?
What platform are you working on?
Is this error persistent or a one-time thing?
Does the vendor driver work with your device?
Can you also show content of
/sys/kernel/debug/ieee80211/phy*/mt76/eeprom_param
?

> [    3.174960] mt7601u 3-5:1.0: ASIC revision: 76010001  MAC revision: 76010500
> [    3.181705] mt7601u 3-5:1.0: Firmware Version: 0.1.00 Build: 7640
> Build time: 201302052146____
> [    3.573018] mt7601u 3-5:1.0: Warning: unsupported EEPROM version 0d
> [    3.574853] mt7601u 3-5:1.0: EEPROM ver:0d fae:00
> [    3.816647] usbcore: registered new interface driver mt7601u
> [   10.461251] mt7601u_add_interface idx:0
> [   10.463193] mt7601u_bss_info_changed 0000000e
> [   10.469748] mt7601u_conf_tx 03 <- 0000
> [   10.473738] mt7601u_conf_tx 02 <- 0001
> [   10.477856] mt7601u_conf_tx 01 <- 0002
> [   10.481980] mt7601u_conf_tx 00 <- 0003
> [   10.486849] mt7601u_bss_info_changed 00002000
> [   10.488671] mt7601u_config ffffffff ch:1
> [   10.504305] mt76_configure_filter changed:0 total:80000000
> [   10.508327] mt76_configure_filter changed:0 total:80000000
> [   10.550671] mt76_configure_filter changed:0 total:80000000
> [   10.616870] mt7601u_config 00000100 ch:1
> [   10.619449] mt76_configure_filter changed:10 total:80000010
> [   10.621541] mt7601u_config 00000040 ch:1
> [   10.692407] mt7601u_config 00000040 ch:2
> [   10.992113] mt7601u 3-5:1.0: Warning: mt7601u_mcu_wait_resp retrying
> [   11.291819] mt7601u 3-5:1.0: Warning: mt7601u_mcu_wait_resp retrying
> [   11.591524] mt7601u 3-5:1.0: Warning: mt7601u_mcu_wait_resp retrying
> [   11.891230] mt7601u 3-5:1.0: Warning: mt7601u_mcu_wait_resp retrying
> [   12.190936] mt7601u 3-5:1.0: Warning: mt7601u_mcu_wait_resp retrying
> [   12.192790] mt7601u 3-5:1.0: Error: mt7601u_mcu_wait_resp timed out

Firmware clearly died somewhere between switch to channel 1 and to
channel 2...  I made some changes to the FW loading routine, I will try
to check the traces later today to confirm that I didn't break anything.

> Is it because of "unsupported EEPROM version 0d"?

Don't think so.  It's just for compatibility with vendor driver,
they warn too.  All new devices have EEPROM ver == 0x0d though.  I plan
to ask MediaTek about it in a week or two (Chinese New Year) and
remove the warning.
