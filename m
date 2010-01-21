Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.irobot.com ([206.83.81.187]:48327 "EHLO smtp1.irobot.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755023Ab0AUUIW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 15:08:22 -0500
Message-ID: <4B58B432.5050200@irobot.com>
Date: Thu, 21 Jan 2010 12:08:18 -0800
From: Adam Wozniak <awozniak@irobot.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	linux-bluetooth <linux-bluetooth@vger.kernel.org>
Subject: Re: FYI - new compat-wireless based on 2.6.33-rc4
References: <43e72e891001201213x6a2c203dl7121f2dde6d61fb9@mail.gmail.com> 	<4B5897C8.2080006@irobot.com> <43e72e891001211012y4f4c8721t7eb9e0eea0221820@mail.gmail.com>
In-Reply-To: <43e72e891001211012y4f4c8721t7eb9e0eea0221820@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis --

I also seem to be having issues with firmware loading.  Any clues would 
be helpful.

I have a Gumstix Overo Fire with a built in libertas_sdio, and an ar9170usb

It finds the libertas firmware just fine, but not the ar9170 firmware.

I'm using a 2.6.29 kernel.  This worked fine with 
compat-wireless-2009-11-17.  All the firmware files are in /lib/firmware.

Here's some dmesg output:

[   18.834564] lib80211: common routines for IEEE802.11 drivers
[   18.834564] lib80211_crypt: registered algorithm 'NULL'
[   18.951324] libertas_sdio: Libertas SDIO driver
[   18.951354] libertas_sdio: Copyright Pierre Ossman
[   18.974456] libertas_sdio mmc1:0001:1: firmware: requesting 
sd8686_helper.bin
[   21.569885] Generic kernel compatibility enabled based on linux-next 
next-20100113
[   21.583374] libertas_sdio mmc1:0001:1: firmware: requesting sd8686.bin
[   21.845703] cfg80211: Calling CRDA to update world regulatory domain
[   22.728393] ar9170usb 2-2.4:1.0: usb_probe_interface
[   22.728424] ar9170usb 2-2.4:1.0: usb_probe_interface - got id
[   22.818023] usb 2-2.4: reset high speed USB device using ehci-omap 
and address 3
[   23.028930] libertas: 00:19:88:21:57:9e, fw 9.70.3p24, cap 0x00000303
[   23.044372] eth0 (libertas_sdio): not using net_device_ops yet
[   23.091583] libertas: PREP_CMD: command 0x00a3 failed: 2
[   23.107025] libertas: PREP_CMD: command 0x00a3 failed: 2
[   23.107238] libertas: eth0: Marvell WLAN 802.11 adapter
[   23.973846] usb 2-2.4: firmware: requesting ar9170.fw
[   83.974090] usb 2-2.4: ar9170.fw firmware file not found, trying old 
firmware...
[   83.981536] usb 2-2.4: firmware: requesting ar9170-1.fw
[  143.982055] usb 2-2.4: file with init values not found.
[  143.987365] ar9170usb: probe of 2-2.4:1.0 failed with error -2

