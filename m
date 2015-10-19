Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:32968 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbbJSWUH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2015 18:20:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1ZoImi-00013T-QS
	for linux-wireless@vger.kernel.org; Tue, 20 Oct 2015 00:20:04 +0200
Received: from cpc10-rdng23-2-0-cust836.15-3.cable.virginm.net ([80.7.139.69])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2015 00:20:04 +0200
Received: from allcoms by cpc10-rdng23-2-0-cust836.15-3.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2015 00:20:04 +0200
To: linux-wireless@vger.kernel.org
From: Dan MacDonald <allcoms@gmail.com>
Subject: =?utf-8?b?bGliZXJ0YXNfY3M=?= TX lockups
Date: Mon, 19 Oct 2015 22:14:04 +0000 (UTC)
Message-ID: <loom.20151020T001231-593@post.gmane.org> (sfid-20151020_002012_484973_2AEB661B)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Linux wireless devs!

I'm having probs maintaining a stable connection with the libertas_cs
driver. When I use wifi for more than a few seconds I start to get errors like:

libertas_cs 0.0 wlan0: TX lockup detected

I get this error when I connect with iw, iwconfig, netctl or networkmanager,
with or without wpa_supplicant / encryption under both Linux 3.11.3 and
4.2.3. I am trying to use a SparkLAN WCFM-100 under Arch Linux ARM on my
olde SHARP Zaurus SL-C3000, of course! :)

The libertas homepage (
http://linuxwireless.sipsolutions.net/en/users/Drivers/libertas/ ) says I
should extract the firmware to use my device. Although I can download the
tools source, running `make` in the fwcutter dir fails because it needs to
download http://files.gumstix.com/cf8385-5.0.16.p0-26306.tbz which no longer
exists. To work around this I have copied cf8385.bin and cf8385_helper.bin
from my laptop's libertas firmware directory into the kernel firmware
directory on my Zaurus which at least gets the card activated by the kernel.

I should prob also mention that Linux prints something like this whenever I
plug the card in:

Oct 14 20:22:06 alarm kernel: pcmcia_socket pcmcia_socket0: pccard: PCMCIA
card inserted into slot 0
Oct 14 20:22:06 alarm kernel: pcmcia 0.0: pcmcia: registering new device
pcmcia0.0 (IRQ: 201)
Oct 14 20:22:06 alarm kernel: cfg80211: Calling CRDA to update world
regulatory domain
Oct 14 20:22:06 alarm kernel: lib80211: common routines for IEEE802.11 drivers
Oct 14 20:22:06 alarm kernel: lib80211_crypt: registered algorithm 'NULL'
Oct 14 20:22:06 alarm kernel: libertas_cs 0.0 (unregistered net_device):
00:0e:8e:11:68:50, fw 5.0.20p2, cap 0x00000303
Oct 14 20:22:06 alarm kernel: libertas_cs 0.0 (unregistered net_device):
PREP_CMD: command 0x00a3 failed: 2
Oct 14 20:22:06 alarm kernel: libertas_cs 0.0 (unregistered net_device):
PREP_CMD: command 0x10ac failed: 2
Oct 14 20:22:07 alarm kernel: libertas_cs 0.0 (unregistered net_device):
PREP_CMD: command 0x00a3 failed: 2
Oct 14 20:22:07 alarm kernel: libertas_cs 0.0 wlan0: Marvell WLAN 802.11 adapter

Could my problems be caused by incorrect firmware or might I have a faulty
wifi card? If I need to use fwcutter to extract the firmware, where can I
get the required archives from?

Thanks for your help!

