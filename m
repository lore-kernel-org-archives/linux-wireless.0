Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62979 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795Ab0LFRmS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 12:42:18 -0500
Received: by fxm20 with SMTP id 20so4419240fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Dec 2010 09:42:17 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Wade Fitzpatrick <wade.fitzpatrick@gmail.com>
Subject: Re: ar9170usb slow / poor performance (SOLVED)
Date: Mon, 6 Dec 2010 18:41:57 +0100
Cc: linux-wireless@vger.kernel.org
References: <AANLkTimMx+LG7ivJ4qpyGGysgHOzZ8ySdTrXG3EbxU=F@mail.gmail.com>
In-Reply-To: <AANLkTimMx+LG7ivJ4qpyGGysgHOzZ8ySdTrXG3EbxU=F@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012061841.58047.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 06 December 2010 17:34:15 Wade Fitzpatrick wrote:
> I could not get anything sensible from carl9170. I will keep trying though.
hmm, hard to say what it is? I bet it could be conflicting
stack/driver modules. (i.e.: the driver is from compact-wireless,
whereas the mac80211, or cfg80211 is the original module from 2.6.36) 

> The Otus message comes from arusb_lnx which was loaded automatically
> after ar9170usb. Should I remove the arusb_lnx.ko file?
either that, or add it to the module blacklist (also in /etc/modprobe.d)

> I did not patch the driver as I am not clear what MCS and minstrel_ht are.
<http://en.wikipedia.org/wiki/IEEE_802.11n-2009> #Data Rates

"Data rates up to 600 Mbit/s are achieved only with the maximum of four
spatial streams using a 40 MHz-wide channel. Various modulation schemes
and coding rates are defined by the standard and are represented by a
Modulation and Coding Scheme (MCS) index value."

minstrel* is mac80211's default rate control algorithm.
The original minstrel only supports legacy (802.11a/b/g) data rates
and minstrel_ht only selects 802.11n MCS (index).
 
> Simply unloading the modules and modprobing them again does not work
> reliably. I think it must be due to not reloading the firmware
> properly.
The ar9170usb, otus and all windows-driver firmware will only be uploaded
once (on the first time a driver is loaded). All later upload attempts are
ignored. The problem here is that the firmware program can't be easily
replaced "in-place" without breaking compatibility or functionality.

> I added the mac80211 options to modprobe.conf and after rebooting,
> both wireless dongles are stable and ping times are back to normal for
> the ar9170usb driver.
no need to reboot, you can unload modules with modprobe -r / rmmod
[as long as the modules are not in use, or an other loaded module
depends on it].

> #
> # /etc/modprobe.d/modprobe.conf (for v2.6 kernels)
> #
> options mac80211 ieee80211_default_rc_algo=minstrel

the problem with this is that carl9170 (or any other driver
that relies on minstrel_ht to supply 802.11n MCS rates)
are limited to the legacy rates (and physpeeds of 54Mbit)

> BTW - my AP is a Netgear WNR2000v2
> I can do further testing if you would like me to.
Well, we had a funny incidents with WNDR3700.

<http://www.spinics.net/lists/linux-wireless/msg56581.html>
after some initial problems with WMM, he got it sort-of-working.
This "sort-of" should be fixed now:
<http://www.spinics.net/lists/linux-wireless/msg60612.html>

Best regards,
	Christian
