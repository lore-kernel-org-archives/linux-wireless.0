Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932161Ab3D2VYa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Apr 2013 17:24:30 -0400
Message-ID: <1367270794.20151.39.camel@dcbw.foobar.com> (sfid-20130429_232435_181899_CC7936EC)
Subject: Re: Intel Centrino Wireless-N 2230 (rev c4) bug
From: Dan Williams <dcbw@redhat.com>
To: Paolo Zaffino <p.zaffino@unicz.it>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, ilw@linux.intel.com
Date: Mon, 29 Apr 2013 16:26:34 -0500
In-Reply-To: <517EDE57.9050401@unicz.it>
References: <517BD02A.5060904@unicz.it> <517EDE57.9050401@unicz.it>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-04-29 at 22:55 +0200, Paolo Zaffino wrote:
> Dear all,
> thanks to your advices I solved all my problems.
> I had more of one service that tried to manage the wifi, it wasn't a bug 
> in the driver.
> I solved with:
> 
> systemctl disable NetworkManager-wait-online.service
> systemctl disable net-auto-wired.service
> systemctl disable net-auto-wireless.service
> 
> Thanks for your advices and for your work on the Linux kernel.

If NetworkManager is running, it expects to be able to control the wifi
device (unless you tell it not to), you tell NM what to do instead of
running wpa_supplicant yourself and configuring it manually through the
supplicant.

Dan

> Best regards.
> Paolo Zaffino
> 
> 
> 
> 
> 
> 
> 
> 
> On 27/04/2013 15:18, Paolo Zaffino wrote:
> > Dear Developers,
> > my name is Paolo Zaffino and I'm an Italian GNU/Linux user.
> > I have an asus NV56 with an Intel Corporation Centrino Wireless-N 2230 
> > (rev c4) wifi card.
> > I installed Arch Linux at 64 bit, my kernel version is the 3.8.7-1 and 
> > I use Gnome with Network Manager.
> > I am facing a strange bug in the wifi driver.
> > I am able to get a working connection to many wifi networks (open and 
> > wpa), but in other cases I can not connect to them or I connect but 
> > every 30 seconds (more o less) the connection drops.
> > In this last case dmesg return this:
> >
> > [   25.459573] iwlwifi 0000:03:00.0: RF_KILL bit toggled to enable radio.
> > [   25.460892] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
> > [   25.468385] iwlwifi 0000:03:00.0: Radio type=0x2-0x0-0x0
> > [   25.846472] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
> > [   25.853963] iwlwifi 0000:03:00.0: Radio type=0x2-0x0-0x0
> > [   26.065675] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
> > [   27.186073] wlp3s0: authenticate with 74:ea:3a:cd:28:42
> > [   27.202371] wlp3s0: send auth to 74:ea:3a:cd:28:42 (try 1/3)
> > [   27.229754] wlp3s0: authenticated
> > [   27.229912] iwlwifi 0000:03:00.0 wlp3s0: disabling HT/VHT due to 
> > WEP/TKIP use
> > [   27.229915] iwlwifi 0000:03:00.0 wlp3s0: disabling HT as WMM/QoS is 
> > not supported by the AP
> > [   27.229916] iwlwifi 0000:03:00.0 wlp3s0: disabling VHT as WMM/QoS 
> > is not supported by the AP
> > [   27.232552] wlp3s0: associate with 74:ea:3a:cd:28:42 (try 1/3)
> > [   27.235911] wlp3s0: RX AssocResp from 74:ea:3a:cd:28:42 
> > (capab=0x431 status=0 aid=8)
> > [   27.237835] wlp3s0: associated
> > [   27.237875] IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready
> > [ 1756.822019] wlp3s0: deauthenticating from 74:ea:3a:cd:28:42 by 
> > local choice (reason=3)
> > [ 1756.828531] cfg80211: Calling CRDA to update world regulatory domain
> > [ 1757.303801] wlp3s0: authenticate with 74:ea:3a:cd:29:13
> > [ 1757.308566] wlp3s0: send auth to 74:ea:3a:cd:29:13 (try 1/3)
> > [ 1757.310340] wlp3s0: authenticated
> > [ 1757.310586] iwlwifi 0000:03:00.0 wlp3s0: disabling HT as WMM/QoS is 
> > not supported by the AP
> > [ 1757.310592] iwlwifi 0000:03:00.0 wlp3s0: disabling VHT as WMM/QoS 
> > is not supported by the AP
> > [ 1757.310598] wlp3s0: waiting for beacon from 74:ea:3a:cd:29:13
> > [ 1757.385290] wlp3s0: associate with 74:ea:3a:cd:29:13 (try 1/3)
> > [ 1757.387810] wlp3s0: RX AssocResp from 74:ea:3a:cd:29:13 
> > (capab=0x431 status=0 aid=13)
> > [ 1757.389812] wlp3s0: associated
> > [ 1757.793015] wlp3s0: deauthenticating from 74:ea:3a:cd:29:13 by 
> > local choice (reason=3)
> > [ 1757.806386] cfg80211: Calling CRDA to update world regulatory domain
> > [ 1758.222639] wlp3s0: authenticate with 74:ea:3a:cd:29:13
> > [ 1758.225663] wlp3s0: send auth to 74:ea:3a:cd:29:13 (try 1/3)
> > [ 1758.228142] wlp3s0: authenticated
> > [ 1758.228424] iwlwifi 0000:03:00.0 wlp3s0: disabling HT as WMM/QoS is 
> > not supported by the AP
> > [ 1758.228436] iwlwifi 0000:03:00.0 wlp3s0: disabling VHT as WMM/QoS 
> > is not supported by the AP
> > [ 1758.230701] wlp3s0: associate with 74:ea:3a:cd:29:13 (try 1/3)
> > [ 1758.233728] wlp3s0: RX AssocResp from 74:ea:3a:cd:29:13 
> > (capab=0x431 status=0 aid=13)
> > [ 1758.236525] wlp3s0: associated
> > [ 1758.761549] wlp3s0: deauthenticating from 74:ea:3a:cd:29:13 by 
> > local choice (reason=3)
> > [ 1758.771562] cfg80211: Calling CRDA to update world regulatory domain
> > [ 1759.206738] wlp3s0: authenticate with 74:ea:3a:cd:28:42
> > [ 1759.211055] wlp3s0: send auth to 74:ea:3a:cd:28:42 (try 1/3)
> > [ 1759.213441] wlp3s0: authenticated
> > [ 1759.213538] iwlwifi 0000:03:00.0 wlp3s0: disabling HT/VHT due to 
> > WEP/TKIP use
> > [ 1759.213540] iwlwifi 0000:03:00.0 wlp3s0: disabling HT as WMM/QoS is 
> > not supported by the AP
> > [ 1759.213541] iwlwifi 0000:03:00.0 wlp3s0: disabling VHT as WMM/QoS 
> > is not supported by the AP
> > [ 1759.215855] wlp3s0: associate with 74:ea:3a:cd:28:42 (try 1/3)
> > [ 1759.218253] wlp3s0: RX AssocResp from 74:ea:3a:cd:28:42 
> > (capab=0x431 status=0 aid=2)
> > [ 1759.220225] wlp3s0: associated
> >
> >
> > I'm here for further infomations about hardware or configurations.
> > Unfortunately this is a nasty problem for me and for a plenty of other 
> > users that are in the same situation.
> > Thank you very much for your great work!
> >
> > Regards.
> > Paolo Zaffino
> >
> 
> 


