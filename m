Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:50943 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754808AbZEOXMG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 19:12:06 -0400
Subject: Re: orinoco_cs and WPA-EAP?
From: Dan Williams <dcbw@redhat.com>
To: Dave <kilroyd@googlemail.com>
Cc: Howard Chu <hyc@highlandsun.com>, linux-wireless@vger.kernel.org
In-Reply-To: <4A0DD39D.6070001@gmail.com>
References: <4A065AFD.8000604@highlandsun.com>
	 <4A0D3A83.4040809@highlandsun.com> <4A0DB0A5.9010301@gmail.com>
	 <4A0DC4A9.8050505@highlandsun.com>  <4A0DD39D.6070001@gmail.com>
Content-Type: text/plain
Date: Fri, 15 May 2009 19:12:50 -0400
Message-Id: <1242429170.10933.30.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-05-15 at 21:42 +0100, Dave wrote:
> Howard Chu wrote:
> > Dave wrote:
> >> Howard Chu wrote:
> >>> Sigh, nothing's ever easy. After abandoning the CTX714 I mentioned in an
> >>> earlier email, I find that the Thinkpad T42 I got from eBay came with some
> >>> kind of Orinoco 802.11B mini-PCI card installed. Ubuntu Jaunty's 2.6.28 kernel
> >>> loads up the orinoco_cs driver for this card. It appears that this driver only
> >>> supports WPA-PSK, and I use WPA-EAP on my home wlan. Has anyone done any work
> >>> on supporting WPA-EAP for this card?
> >>
> >> Note that the card only supports TKIP, so it won't work if the AP
> >> doesn't offer it.
> > 
> > Thanks, that may have been the issue I was facing at first. My AP was 
> > configured for CCMP. I've now set it to TKIP and seem to be getting further. 
> > But now when I start wpa_supplicant I see a stream of "Information frame lost" 
> > messages in dmesg that pretty much never end (interspersed once in a while 
> > with ratelimit messages). I wonder if this laptop's mini-PCI slot is hosed or 
> > something.
> 
> That message is printed in response to a firmware interrupt. It
> indicates "an unsolicited Frame Structure cannot be generated... because
> there is not enough Frame Structure buffer space available".
> 
> I suspect that the beacons/probe responses/scan results are either too
> large/too frequent for the card to handle, or the firmware can't
> decipher them.
> 
> Before enabling wpa_supplicant, can you try scan for your AP (as root):
> 
> iwlist ethX scan essid YYYYY
> 
> I'm interested in what it returns, and whether dmesg reports 'Ext scan
> results too large' or something similar.

Yeah a lot of APs will stuff a ton of info into the IEs these days,
including WPS, WPA, 11d, blah blah.  It's not out of the question that
the firmware writers didn't anticipate or handle large numbers of IEs in
the beacons.  That said, what firmware version is he using?  Maybe
Apple's firmware fixes that or something?  Would be interesting if the
reporter could boot up an old iBook with an Airport card and see if that
works.

Dan


