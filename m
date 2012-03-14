Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:35032 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab2CNNl5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 09:41:57 -0400
Message-ID: <4F60A024.9060306@mlbassoc.com> (sfid-20120314_144201_660322_3A73BA2E)
Date: Wed, 14 Mar 2012 07:41:56 -0600
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Luciano Coelho <coelho@ti.com>
Subject: Re: Troubles with wl12xx
References: <4F6092FB.6030809@mlbassoc.com>
In-Reply-To: <4F6092FB.6030809@mlbassoc.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-03-14 06:45, Gary Thomas wrote:
> I'm having some issues getting my [newly designed] board to run
> with wl12xx (wl1271 on SDIO) My kernel is 2.6.37 and I'm using
> a compat-wireless snapshot from 2012-02-28
>
> Here's what I see when I boot - looks OK:
> Compat-wireless backport release: compat-wireless-2012-02-28
> Backport based on linux-next.git next-20120228
> cfg80211: Calling CRDA to update world regulatory domain
> wl12xx: loaded
>
> If I bring up the wlan0 interface manually, I can talk to the
> device, scan for access points, etc. All looks good.
>
> The problem comes when I try to negotiate for an address with
> WPA security.
> # ifup wlan0
> wl12xx: firmware booted (Rev 6.3.5.0.98)
> ADDRCONF(NETDEV_UP): wlan0: link is not ready
> udhcpc (v1.19.3) started
> Sending discover...
> wl12xx: down
> Sending discover...
> Sending discover...
> No lease, failing
>
> A few seconds later, everything falls apart. Sorry for the verbosity, but
> the messages changed at the end and I wanted to make sure you saw it all.

A little more information - maybe this helps:
   # ifup -v wlan0
   run-parts /etc/network/if-pre-up.d
   wl12xx: firmware booted (Rev 6.3.5.0.98)
   wl12xx: ERROR watchdog interrupt received! starting recovery.
   wl12xx: Reading FW panic log
   wl12xx: Hardware recovery in progress. FW ver: Rev 6.3.5.0.98 pc: 0x0
     wl12xx: down
   ieee80211 phy0: Hardware restart was requested
   ADDRCONF(NETDEV_UP): wlan0: link is not ready
   wl12xx: ERROR timeout waiting for the hardware to complete initialization
   wl12xx: ERROR timeout waiting for the hardware to complete initialization
   wl12xx: ERROR timeout waiting for the hardware to complete initialization
   wl12xx: ERROR firmware boot failed despite 3 retries
   ifconfig wlan0 up
   udhcpc -R -n -p /var/run/udhcpc.wlan0.pid -i wlan0
   udhcpc (v1.19.3) started
   Sending discover...
   Sending discover...
   Sending discover...
   No lease, failing

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
