Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:36031 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbcFDRWp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2016 13:22:45 -0400
Received: by mail-wm0-f54.google.com with SMTP id n184so36596375wmn.1
        for <linux-wireless@vger.kernel.org>; Sat, 04 Jun 2016 10:22:44 -0700 (PDT)
To: Craig McQueen <craig.mcqueen@innerrange.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: rt2800usb firmware rt2870.bin 0.36 not scanning
Message-ID: <f2d6e3de-826a-c7b6-ac29-16b83be758e8@gmail.com> (sfid-20160604_192320_291090_471FBC39)
Date: Sat, 4 Jun 2016 19:22:42 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Craig McQueen wrote:

> I have a D-Link DWA-140 USB Wi-Fi device which is rt2800 based (5392
> chipset). I'm trying to use it on a BeagleBone Black based system with
> 3.14.x kernel built with Yocto. We're using ConnMan 1.30 at the moment.

Try it with a _desktop x86_64 distribution_ , with a *recent kernel*
as Fedora: (WORK is gnome) https://alt.fedoraproject.org/pub/alt/live-respins/

> We've been finding some instabilities with it periodically disconnecting
> from some networks. So we tried upgrading the firmware file rt2870.bin
> from version 0.29 to 0.36. That seems to be more stable with the
> network. However, we're finding that it initially doesn't connect, until
> the Wi-Fi has been disabled and then re-enabled. '  scan wifi'
> and 'iwlist scan' don't return anything until Wi-Fi has been disabled
> and then re-enabled.

Don't use any wrapper(NM, ConnMan, wicd, ...), usually are buggy. You should
use raw commands "iw" and "wpa_supplicant". Hints:
https://wireless.wiki.kernel.org/en/users/documentation/iw and  wpa_supplicant
always running with "-Dnl80211"

> Have there been any Linux driver changes needed to support this 0.36
> firmware? Does anyone have any pointers on where to look to understand
> this behaviour between 0.29 and 0.36 firmware?

closed source, but old changelogs are available at:
http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2013-September/006391.html

Related to latest firmware releases, ralink/mediatek guys say:
"According to the engineers comment, the firmware didn't change much
these years, just some bbp register update and led stuff."
