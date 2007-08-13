Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:50781 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761311AbXHMWZ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 18:25:59 -0400
From: Chr <chunkeey@web.de>
To: Michael Wu <flamingice@sourmilk.net>
Subject: Re: Recent linux-wireless git changes have broken my prism54pci card
Date: Tue, 14 Aug 2007 00:25:56 +0200
Cc: Hans de Goede <j.w.r.degoede@hhs.nl>,
	linux-wireless@vger.kernel.org
References: <46BFF10B.1090307@hhs.nl> <46C0474B.2000206@hhs.nl> <200708131314.59141.flamingice@sourmilk.net>
In-Reply-To: <200708131314.59141.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200708140025.56708.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, 13. August 2007, Michael Wu wrote:
> On Monday 13 August 2007 04:58, Hans de Goede wrote:
> > Okay, I still had copies of various git revisions of prism54common.c and .h
> > (aka the culprits) on my laptop. I've run some tests again to make sure I
> > had the right revisions in mind for the breakage (which I had). I've
> > attached 2 patches:
> > diff: with this reversed my speed increases 10x and more importantly when
> > fully loading the link (using scp from a local non wireless ethernet
> > machine) it no longer looses the connection in a couple of seconds
> >
> Hm, I guess either these changes were wrong or exposed some bugs. Can you 
> check what sort of tx rates are being reported in iwconfig before and after 
> that change?
> 
> > diff2, when I do not reverse this one, it still associates, but it no
> > longer receives / or transmits packages. (no dhcp, no ping when manually
> > assigning IP's, etc).
> >
> Not sure.. this patch generally helped things on my hardware. Christian 
> Lamparter might have an idea.
> 

Well not really, It is "fast" as usual here: 
 
scp user@p54pci-pc:/usr/src/dummyzero ./
dummyzero                                                                                                               100%  236MB   1.8MB/s   02:09

iperf:
[  5] local 192.168.1.247 port 5001 connected with 192.168.1.1 port 56253
[  5]  0.0-240.7 sec    597 MBytes  20.8 Mbits/sec


=> need more data...
 
1. Which p54 firmware do you use? (It "must" be 2.7.0.0 for pci/cardbus)
2. What's your "average" txrate and Link Signal Level / Link Quality with and without the patches.
   (see iwconfig)
3. what brand/type of AP do you have? 
-> what does the beacon frame look like? (or: if you don't have a
wlan sniffer / monitor, just run: iwlist wlanX scan )
4. Can you recompile the mac80211 layer with debug options and look for
something like ethX: STA XX:YY:ZZ:AA:BB:CC Average rate: VVV ... in your syslogs?
5. are they any suspicious dmesg outputs when the "network" stops/dies?

Thanks,
	Chr.

