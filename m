Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:59082 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941Ab3EHFb1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 May 2013 01:31:27 -0400
Received: from mailout-de.gmx.net ([10.1.76.2]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0MbvXU-1Ut8Ha3Hs6-00JLDN for
 <linux-wireless@vger.kernel.org>; Wed, 08 May 2013 07:31:24 +0200
Message-ID: <5189E31F.2090200@rempel-privat.de> (sfid-20130508_073130_556210_43848BE9)
Date: Wed, 08 May 2013 07:31:11 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Corey Richardson <corey@octayn.net>
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: [ath9k-devel] ath9k_htc works poorly in 3.9
References: <CA++BO6SfpV_7pimE=-TUcbXRX9Xgd8v69B5AQzPQ2g1b82e0FA@mail.gmail.com>
In-Reply-To: <CA++BO6SfpV_7pimE=-TUcbXRX9Xgd8v69B5AQzPQ2g1b82e0FA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 08.05.2013 05:52, schrieb Corey Richardson:
> Initially, I can associate and everything works fine, but after an
> hour or maybe a few, I get deauthenticated, with:
>
> [ 3115.047842] cfg80211: Calling CRDA for country: US
> [ 3116.383330] wlan0: authenticate with 00:14:c2:ae:e1:c0
> [ 3116.480597] wlan0: send auth to 00:14:c2:ae:e1:c0 (try 1/3)
> [ 3119.526272] wlan0: send auth to 00:14:c2:ae:e1:c0 (try 2/3)
> [ 3121.485530] wlan0: deauthenticating from 00:14:c2:ae:e1:c0 by local
> choice (reason=3)
> [ 3123.386841] wlan0: authenticate with 00:14:c2:ae:e1:c0
> [ 3123.483019] wlan0: send auth to 00:14:c2:ae:e1:c0 (try 1/3)
> [ 3126.528663] wlan0: send auth to 00:14:c2:ae:e1:c0 (try 2/3)
> [ 3128.486335] wlan0: deauthenticating from 00:14:c2:ae:e1:c0 by local
> choice (reason=3)
> [ 3130.879429] wlan0: authenticate with 00:14:c2:ae:e1:c0
> [ 3130.976309] wlan0: send auth to 00:14:c2:ae:e1:c0 (try 1/3)
> [ 3130.976512] wlan0: deauthenticating from 00:14:c2:ae:e1:c0 by local
> choice (reason=3)
>
> in dmesg and
>
> May 07 23:32:57 roger NetworkManager[317]: <warn> Connection
> disconnected (reason -4)
> May 07 23:32:57 roger NetworkManager[317]: <info> (wlan0): supplicant
> interface state: completed -> disconnected
> May 07 23:32:58 roger NetworkManager[317]: <info> (wlan0): supplicant
> interface state: disconnected -> scanning
> May 07 23:32:59 roger NetworkManager[317]: <info> (wlan0): supplicant
> interface state: scanning -> authenticating
> May 07 23:32:59 roger NetworkManager[317]: <info> (wlan0): roamed from
> BSSID 00:14:C2:AE:E1:C0 (home1) to (none) ((none))
> May 07 23:33:04 roger NetworkManager[317]: <info> (wlan0): supplicant
> interface state: authenticating -> disconnected
> May 07 23:33:04 roger NetworkManager[317]: <warn> Connection
> disconnected (reason -3)
> May 07 23:33:05 roger NetworkManager[317]: <info> (wlan0): supplicant
> interface state: disconnected -> scanning
> May 07 23:33:06 roger NetworkManager[317]: <info> (wlan0): supplicant
> interface state: scanning -> authenticating
> May 07 23:33:11 roger NetworkManager[317]: <info> (wlan0): supplicant
> interface state: authenticating -> disconnected
> May 07 23:33:11 roger NetworkManager[317]: <warn> Connection
> disconnected (reason -3)
> May 07 23:33:12 roger NetworkManager[317]: <info> (wlan0): supplicant
> interface state: disconnected -> scanning
> May 07 23:33:13 roger NetworkManager[317]: <warn> (wlan0): link timed out.
> May 07 23:33:13 roger NetworkManager[317]: <info> (wlan0): device
> state change: activated -> failed (reason 'SSID not found') [100 120
> 53]
> May 07 23:33:13 roger NetworkManager[317]: <warn> Activation (wlan0)
> failed for connection 'home1'
> May 07 23:33:13 roger NetworkManager[317]: <info> (wlan0): device
> state change: failed -> disconnected (reason 'none') [120 30 0]
> May 07 23:33:13 roger NetworkManager[317]: <info> (wlan0):
> deactivating device (reason 'none') [0]
> May 07 23:33:13 roger NetworkManager[317]: <info> (wlan0): canceled
> DHCP transaction, DHCP client pid 527
> May 07 23:33:14 roger NetworkManager[317]: <info> (wlan0): supplicant
> interface state: scanning -> authenticating
> May 07 23:33:14 roger NetworkManager[317]: <warn> Connection
> disconnected (reason -3)
> May 07 23:33:14 roger NetworkManager[317]: <info> (wlan0): supplicant
> interface state: authenticating -> disconnected
> May 07 23:33:14 roger NetworkManager[317]: <warn> Connection
> disconnected (reason -3)
>
>
> in the journal.
>
> Removing and reinserting the USB stick allows me to reassociate about
> 50% of the time; others need a reboot.
>
> This is a regression from 3.8. It was present in the earlier 3.9 RC's
> after Johannes' fix for idle sequence handling, but not before the
> changes that broke ath9k_htc, so I think something between the patch
> that broke the driver and the patch that fixed it is to blame.


Hi Corey,

only person who can help to fix it is you ;)
Currently I'm trying to reproduce other bug with this driver/firmware 
without luck. Yesterday i started my test, i streamed some hundred 
gigabytes over the air and my system is still working.
My kernel is 3.9.0-wl-00003-g4125f14

If it is an regression, can you please do "git bisect". If you can 
locate the patch which introduced this regression, it will be great.

-- 
Regards,
Oleksij
