Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f172.google.com ([209.85.222.172]:43144 "EHLO
	mail-pz0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138Ab0AUURn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 15:17:43 -0500
MIME-Version: 1.0
In-Reply-To: <4B58B432.5050200@irobot.com>
References: <43e72e891001201213x6a2c203dl7121f2dde6d61fb9@mail.gmail.com>
	<4B5897C8.2080006@irobot.com> <43e72e891001211012y4f4c8721t7eb9e0eea0221820@mail.gmail.com>
	<4B58B432.5050200@irobot.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 21 Jan 2010 12:17:23 -0800
Message-ID: <43e72e891001211217t17ffed80i2d5bc6f923b56210@mail.gmail.com>
Subject: Re: FYI - new compat-wireless based on 2.6.33-rc4
To: Adam Wozniak <awozniak@irobot.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	linux-bluetooth <linux-bluetooth@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 21, 2010 at 12:08 PM, Adam Wozniak <awozniak@irobot.com> wrote:
> Luis --
>
> I also

BTW Haukes posted a fix for the compile build against ARM. Try that.
That patch applies to compat.git but you should be able to mangle it
to apply to compat-wireless easily too.

> seem to be having issues with firmware loading.  Any clues would be
> helpful.
>
> I have a Gumstix Overo Fire with a built in libertas_sdio, and an ar9170usb
>
> It finds the libertas firmware just fine, but not the ar9170 firmware.
>
> I'm using a 2.6.29 kernel.  This worked fine with
> compat-wireless-2009-11-17.  All the firmware files are in /lib/firmware.
>
> Here's some dmesg output:
>
> [   18.834564] lib80211: common routines for IEEE802.11 drivers
> [   18.834564] lib80211_crypt: registered algorithm 'NULL'
> [   18.951324] libertas_sdio: Libertas SDIO driver
> [   18.951354] libertas_sdio: Copyright Pierre Ossman
> [   18.974456] libertas_sdio mmc1:0001:1: firmware: requesting
> sd8686_helper.bin
> [   21.569885] Generic kernel compatibility enabled based on linux-next
> next-20100113
> [   21.583374] libertas_sdio mmc1:0001:1: firmware: requesting sd8686.bin
> [   21.845703] cfg80211: Calling CRDA to update world regulatory domain
> [   22.728393] ar9170usb 2-2.4:1.0: usb_probe_interface
> [   22.728424] ar9170usb 2-2.4:1.0: usb_probe_interface - got id
> [   22.818023] usb 2-2.4: reset high speed USB device using ehci-omap and
> address 3
> [   23.028930] libertas: 00:19:88:21:57:9e, fw 9.70.3p24, cap 0x00000303
> [   23.044372] eth0 (libertas_sdio): not using net_device_ops yet
> [   23.091583] libertas: PREP_CMD: command 0x00a3 failed: 2
> [   23.107025] libertas: PREP_CMD: command 0x00a3 failed: 2
> [   23.107238] libertas: eth0: Marvell WLAN 802.11 adapter
> [   23.973846] usb 2-2.4: firmware: requesting ar9170.fw
> [   83.974090] usb 2-2.4: ar9170.fw firmware file not found, trying old
> firmware...

OK so it failed here, you may want to try to debug udev stuff now
then, what distribution do you have? Where are your udev rules put?
Where is the original udev rule for firmware for your box?

You can debug udev stuff by using 'udevadm monitor'

  Luis
