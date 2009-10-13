Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:54877 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761081AbZJMT0u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 15:26:50 -0400
Received: by iwn10 with SMTP id 10so2943081iwn.4
        for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2009 12:26:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20091012T120512-386@post.gmane.org>
References: <loom.20091012T120512-386@post.gmane.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 13 Oct 2009 12:25:53 -0700
Message-ID: <43e72e890910131225p431125f5p50d2b583696e6b8c@mail.gmail.com>
Subject: Re: ar9170 network interface initialization failure
To: oshi <oshi@trego.co.il>
Cc: linux-wireless@vger.kernel.org,
	Christian Lamparter <chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 12, 2009 at 3:05 AM, oshi <oshi@trego.co.il> wrote:
> Hello,
>
> I am trying to enable a Ubiquity SR71 device on x86 - ubuntu 9.04 (kernel
> headers 2.6.28-15).
>
> I built and installed compat-wireless-2009-10-09 on my machine.
> ar9170 module is loaded and a network interface is created.
>
> However when I try to bring up the interface, an error occurs:
>
> ifconfig wlan3 up
> SIOCSIFFLAGS: Operation not permitted
>
> I managed to trace down the error to  a failure in usb_submit_urb() called from
> ar9170_init_mac().
>
>
> [70247.612064] usb 2-1: new high speed USB device using ehci_hcd and address 10
> [70247.779863] usb 2-1: config 1 interface 0 altsetting 0 bulk endpoint 0x4 has
> invalid maxpacket 64
> [70247.792411] usb 2-1: configuration #1 chosen from 1 choice
> [70247.910900] usb 2-1: reset high speed USB device using ehci_hcd and address 10
> [70249.084059] usb 2-1: firmware: requesting ar9170.fw
> [70249.096406] usb 2-1: ar9170.fw firmware file not found, trying old firmware...
> [70249.096416] usb 2-1: firmware: requesting ar9170-1.fw
> [70249.138585] usb 2-1: firmware: requesting ar9170-2.fw
> [70249.568392] ath: EEPROM regdomain: 0x0
> [70249.568397] ath: EEPROM indicates default country code should be used
> [70249.568402] ath: doing EEPROM country->regdmn map search
> [70249.568408] ath: country maps to regdmn code: 0x3a
> [70249.568413] ath: Country alpha2 being used: US
> [70249.568418] ath: Regpair used: 0x3a
> [70249.568792] phy2: Selected rate control algorithm 'minstrel'
> [70249.572212] ar9170_usb_exec_cmd line 399
> [70249.572488] ar9170_usb_exec_cmd line 399
> [70249.572820] Registered led device: ar9170-phy2::tx
> [70249.572883] Registered led device: ar9170-phy2::assoc
> [70249.572890] usb 2-1: Atheros AR9170 is registered as 'phy2'
> [70249.588769] udev: renamed network interface wlan0 to wlan3
> [70254.388224] ar9170_op_start 1259
> [70254.388231] ar9170_init_mac 147
> [70254.388257] ar9170_usb_exec_cmd usb_submit_urb err -1

Hm, when usb_submit_urb err() fails on  ar9170_usb_exec_cmd() I
believe you should get a dump stack and all, not sure why you are only
getting this.

But the more important question is how you managed to compile
compat-wireless for ar9170 on a 2.6.28 kernel, we enable it on
compat-wireless only for kernels >= 2.6.29. Here is the config.mk
excerpt:

ifndef CONFIG_COMPAT_WIRELESS_28
CONFIG_AR9170_USB=m
CONFIG_AR9170_LEDS=y
endif

That is -- if you don't need 2.6.28 compat stuff enable ar9170. Also
2.6.28 does not have CONFIG_AR9170_USB.. hmm. How did you compile
this?

  Luis
