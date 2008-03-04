Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbYCDOIN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 09:08:13 -0500
Subject: Re: [PATCH, take 2] libertas: implement SSID scanning for
	SIOCSIWSCAN
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200803040738.19911.hs4233@mail.mn-solutions.de>
References: <200802261522.05676.hs4233@mail.mn-solutions.de>
	 <1204571891.16248.1.camel@localhost.localdomain>
	 <200803040738.19911.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 09:04:10 -0500
Message-Id: <1204639450.7183.22.camel@localhost.localdomain> (sfid-20080304_140818_684950_9BC5B31E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-03-04 at 07:38 +0100, Holger Schurig wrote:
> > However, it never found the hidden AP I was using (ie, it
> > never replaced the blank SSID in the iwlist scan results with
> > the actual SSID as I'd expect).  I haven't tracked that down
> > quite yet, but it might be an issue in the scan result
> > handling code or it could be firmware.
> 
> Do you mean that 
> 
> 00:1D:60:14:33:2B   <empty SSID>
> 00:1D:60:14:33:2B   WLAN
> 
> should be unified into
> 
> 00:1D:60:14:33:2B   WLAN
> 
> ???

_If and only if_ the BSSID and all security and flags match, then yes.  

But that wasn't the issue; the issue was that even after doing 'iwlist
eth1 scan ssid hidden-test' the SSID 'hidden-test' was never returned in
the scan results, but the AP's BSSID without an SSID was.  So, assuming
that I know 00:1D:60:14:33:2B is an AP with an ssid of 'hidden-test':

----------------------------------------
iwlist eth1 scan

00:1D:60:14:33:2B   <empty SSID>

iwlist eth1 scan essid hidden-test

00:1D:60:14:33:2B   <empty SSID>

iwlist eth1 scan essid hidden-test

00:1D:60:14:33:2B   <empty SSID>

(repeat...)
----------------------------------------

I need to do some more investigation inside libertas though, because I'm
not confident where the bug may lie.  If it's something in the firmware,
there's not much we can do of course.

> First I wanted to do that, but then I thought that maybe this is 
> erraneous. An AP can have several SSIDs, one of them could be 
> hidden, the other ones not hidden. E.g. this is easy to setup on 
> a Cisco 123x or Cisco 124x access-point.

Right.  I've done that :)

> I also have a "take 3" of this patch now, because I adapted 
> (after a chat with David on IRC) the outstanding patches from 
> libertas-2.6 to wireless-testing. Two of the patches touched 
> scan.c as well, so I rewrote my scan-for-specific-ssid patch to 
> apply on top of the 5 David-Woodhouse-patches.

Yeah, was going to ask that you rebase your patch on top of the ones you
posted from libertas-2.6.

Thanks,
Dan


