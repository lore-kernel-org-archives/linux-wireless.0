Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:56755 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753571Ab0CUVzF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Mar 2010 17:55:05 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1NtT6t-0002KC-IT
	for linux-wireless@vger.kernel.org; Sun, 21 Mar 2010 22:55:03 +0100
Received: from 194.145.183.75 ([194.145.183.75])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 21 Mar 2010 22:55:03 +0100
Received: from nanokk by 194.145.183.75 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 21 Mar 2010 22:55:03 +0100
To: linux-wireless@vger.kernel.org
From: nanok <nanokk@gmx.net>
Subject: Re: Bug: 2.6.32 ath5k, associating with WEP128 AP is unreliable
Date: Sun, 21 Mar 2010 20:49:15 +0000 (UTC)
Message-ID: <loom.20100321T212710-762@post.gmane.org>
References: <4B5CD1FF.4090209@twilightblue.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don Darling <darling.don@...> writes:

> 
> Hello folks,
> 
> I recently tried upgrading to kernel version 2.6.32, but after this 
> upgrade my wireless card became flaky when making connections. In cases 
> where a connection can be established it is  stable, but there are 
> problems when making wireless associations. Downgrading to kernel 
> version 2.6.31 resolves this issue.  I'm not sure at the moment which 
> versions of the ath5k driver maps to these kernel versions.
> 
> Here is a brief description of my system:

hi,

i can confirm don's issue. i have been using several revisions of 2.6.32
(debian, not vanilla, it's true), i have resorted (back) to using
ath-pci
instead (i had been using it before because of the nifty functionality,
but i
switched to ath5k lately because of it being included in the kernel).

reading don's report here, i tried using the 2.6.30 i already have, it
seems
to work fine.

i can test pretty much whatever is needed, so feel free to ask.

here is the working ath5k details:

the laptop is a compaq nc6000,
the card:
lspci | grep -i ath
02:04.0 Ethernet controller: Atheros Communications Inc. Atheros
AR5001X+
Wireless Network Adapter (rev 01)

modinfo ath5k
filename:
/lib/modules/2.6.30-2-686/kernel/drivers/net/wireless/ath5k/ath5k.ko
version:        0.6.0 (EXPERIMENTAL)
license:        Dual BSD/GPL
description:    Support for 5xxx series of Atheros 802.11 wireless LAN
cards.
author:         Nick Kossifidis
author:         Jiri Slaby
srcversion:     EE1D08AEEC0159304E1A703

modinfo mac80211
filename:
/lib/modules/2.6.30-2-686/kernel/net/mac80211/mac80211.ko
license:        GPL
description:    IEEE 802.11 subsystem
depends:        cfg80211
vermagic:       2.6.30-2-686 SMP mod_unload modversions 686
parm:           ieee80211_default_rc_a

 modinfo cfg80211
filename:
/lib/modules/2.6.30-2-686/kernel/net/wireless/cfg80211.ko
description:    wireless configuration support
license:        GPL
author:         Johannes Berg
depends:
vermagic:       2.6.30-2-686 SMP mod_unload modversions 686
parm:           ieee80211_regdom:IEEE 802.11 regulatory domain code
(charp)

problematic ath5k:
filename:
/lib/modules/2.6.32-3-686/kernel/drivers/net/wireless/ath/ath5k/ath5k.ko
version:        0.6.0 (EXPERIMENTAL)
license:        Dual BSD/GPL
description:    Support for 5xxx series of Atheros 802.11 wireless LAN
cards.
author:         Nick Kossifidis
author:         Jiri Slaby
srcversion:     DEA0BE918B6E0D0429CDF27

(same version, 0.6.0, but different src version).

hope this helps

ps: i am also having a seldom kernel panic issue, i cannot confirm if it
has
anything to do with ath5k, but it did happen once or twice when
inserting or
removing the module. i also had issues bringing the interface up after
inserting ath5k, i would get "error 132". again, no idea if any of this
is
related.

--
nanok

ps2: "You have lines longer than 80 characters. Fix that.". huh? why 
doesn't the webform just enforce that instead? very annoying :(

