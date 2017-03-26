Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:59183 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751571AbdCZSvZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 26 Mar 2017 14:51:25 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <glkwg-linux-wireless@m.gmane.org>)
        id 1csDFx-0001zf-7A
        for linux-wireless@vger.kernel.org; Sun, 26 Mar 2017 20:51:13 +0200
To: linux-wireless@vger.kernel.org
From: Dennis New <dennisn@dennisn.mooo.com>
Subject: Re: wlan0 keeps deauthenticating DEAUTH_LEAVING about every minute
Date: Sun, 26 Mar 2017 14:51:04 -0400
Message-ID: <20170326145104.ca03fee3e90230e7fb5e02d3@dennisn.mooo.com> (sfid-20170326_205303_628859_6E6C0D7E)
References: <20170324213237.6f122a9173fa464a5d936f9d@dennisn.mooo.com>
        <77d7e7a0-b529-ad29-9584-da51c68a5917@lwfinger.net>
        <20170326134324.046ad0d4cc3c7dd9da5c56b1@dennisn.mooo.com>
        <98e61d2c-97af-0a67-a4bb-abac16765006@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
In-Reply-To: <98e61d2c-97af-0a67-a4bb-abac16765006@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 26 Mar 2017 20:47:41 +0200, Arend Van Spriel wrote:
> 
> 
> On 26-3-2017 19:43, Dennis New wrote:
> > On Sun, 26 Mar 2017 11:00:12 -0500, Larry Finger wrote:
> >> ...  provide information regarding what specific card you have. The
> >> appropriate stanza from "lspci -nn" has that information.
> >>
> >> I do not normally run a b43 wireless NIC, but I did pull out an
> >> ancient laptop that uses the PCMCIA version of a BCM4318 with PCI
> >> ID of 14e4:4318. Running kernel 4.10.0, I do see periodic drops. My
> >> period is 120 sec and the drop is a reason 7, not reason 3 as you
> >> see. Another difference is that I see the drops with kernel 4.8.0
> >> as well. With the earlier kernel, the drop period is closer to 60
> >> sec, but it is not as regular.
> > 
> > Huh. I also have that BCM4318 card, but not PCMCIA.
> > 
> > 06:02.0 Network controller [0280]: Broadcom Corporation BCM4318
> > [AirForce One 54g] 802.11g Wireless LAN Controller [14e4:4318] (rev
> > 02) Subsystem: AMBIT Microsystem Corp. Aspire 3022WLMi, 5024WLMi,
> > 5020 [1468:0311] Flags: bus master, fast devsel, latency 64, IRQ 9
> > Memory at c0304000 (32-bit, non-prefetchable) [size=8K] Kernel
> > driver in use: b43-pci-bridge
> > 
> > These past few days I seem to have had some "success" by simply
> > putting a 60 second sleep in my bootup scripts before bringing up
> > my wlan0 interface. (Ie. I haven't been getting any deauths after
> > doing this.)
> 
> Interesting. I assume you are using wpa_supplicant so can you make a
> supplicant log of that with and without the 60 second sleep.

The same thing happens even without wpa_supplicant. Simply doing "iw
wlan0 connect BlablaAP" .... it will still mysteriously deauthenticate
after a minute (usually).
