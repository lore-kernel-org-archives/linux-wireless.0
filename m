Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:51546 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750982AbZGTDGR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jul 2009 23:06:17 -0400
Message-ID: <4A63DF0B.4010801@redfish-solutions.com>
Date: Sun, 19 Jul 2009 20:05:47 -0700
From: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Using compat-wireless w/ 2.6.27.26
References: <4A612514.4050708@redfish-solutions.com> <b6c5339f0907190638jc1bdacbo801adcd39a1cf5@mail.gmail.com> <4A635E04.4050204@redfish-solutions.com> <20090719203150.GA9972@hash.localnet>
In-Reply-To: <20090719203150.GA9972@hash.localnet>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland wrote:
> On Sun, Jul 19, 2009 at 10:55:16AM -0700, Philip A. Prindeville wrote:
>> Bob Copeland wrote:
>>> On Fri, Jul 17, 2009 at 9:27 PM, Philip A.
>>>> + iw dev wlan0 interface add ap0 type managed
>>>> + ip link set ap0 up
>>>> + iw dev ap0 connect xxxx
>>>> command failed: Operation not supported (-95)
>>> Why are you adding another interface?  Should be able to use "iw dev wlan0..."
>> Because I might want to run two access points (two SSIDs, anyway) on the same
>> radio...  one with WEP on one VLAN (for Wifi SIP handsets), and one with
>> WPA-PSK2 on another VLAN (for laptops, etc).
> 
> Hmm, I don't know if it matters, but you were creating it as a managed
> interface.  Anyway I don't believe ath5k supports that yet - ath9k might.
> Someone on ath5k-devel was porting the ath9k virtual wiphy stuff to
> ath5k but I haven't heard anything recently.
> 
>> But, if you think there's still a doubt, what to look for in the modinfo?
> 
> If it says "depends: mac80211,cfg80211,ath" then it is probably the right
> one.  It just sounds like this bug:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=12315

Actually, it's saying:

filename:       /lib/modules/2.6.27.26-astlinux/kernel/drivers/net/wireless/ath5k/ath5k.ko
version:        0.6.0 (EXPERIMENTAL)
license:        Dual BSD/GPL
description:    Support for 5xxx series of Atheros 802.11 wireless LAN cards.
author:         Nick Kossifidis
author:         Jiri Slaby
srcversion:     E33724BC42EBC4E7E7714E1
...
depends:        mac80211,cfg80211
vermagic:       2.6.27.26-astlinux preempt mod_unload modversions GEODE
parm:           nohwcrypt:Disable hardware encryption. (int)

"nohwcrypt" is present in the 2.6.30 wireless-compat sources but not in the 2.6.27 drivers, so I'm pretty sure we're looking at the right ones.

And the 0.6.0 version number matches ath5k/base.c in the compat-wireless sources as well.

Not seeing the dependency on "ath", which is strange.  Is that common code that's shared in 2.6.30 for the Atheros drivers?

> The fix was merged after 2.6.30, IIRC, but it should definitely be in
> compat-wireless.  Also check your modules directory for an old ath5k.ko
> sitting in drivers/.../wireless/ath5k.  It should now be in ath/ath5k.
> 
> HTH!
> 

