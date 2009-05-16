Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:38678 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601AbZEPBeJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 21:34:09 -0400
Subject: Re: orinoco_cs and WPA-EAP?
From: Dan Williams <dcbw@redhat.com>
To: Howard Chu <hyc@highlandsun.com>
Cc: Dave <kilroyd@googlemail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <4A0E0579.70507@highlandsun.com>
References: <4A065AFD.8000604@highlandsun.com>
	 <4A0D3A83.4040809@highlandsun.com> <4A0DB0A5.9010301@gmail.com>
	 <4A0DC4A9.8050505@highlandsun.com>  <4A0DD39D.6070001@gmail.com>
	 <1242429170.10933.30.camel@localhost.localdomain>
	 <4A0E0579.70507@highlandsun.com>
Content-Type: text/plain
Date: Fri, 15 May 2009 21:35:03 -0400
Message-Id: <1242437703.10933.55.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-05-15 at 17:14 -0700, Howard Chu wrote:
> Dan Williams wrote:
> > On Fri, 2009-05-15 at 21:42 +0100, Dave wrote:
> >> That message is printed in response to a firmware interrupt. It
> >> indicates "an unsolicited Frame Structure cannot be generated... because
> >> there is not enough Frame Structure buffer space available".
> >>
> >> I suspect that the beacons/probe responses/scan results are either too
> >> large/too frequent for the card to handle, or the firmware can't
> >> decipher them.
> >>
> >> Before enabling wpa_supplicant, can you try scan for your AP (as root):
> >>
> >> iwlist ethX scan essid YYYYY
> 
> That works fine. In fact, just "iwlist scan" returns the same result - only 
> the info for my AP is returned. (There are at least 6 APs visible from an 
> another laptop sitting nearby.)
> 
> >> I'm interested in what it returns, and whether dmesg reports 'Ext scan
> >> results too large' or something similar.
> 
> No, it just continues with the stream of "frame lost" messages:
> 
> eth2: Information frame lost. (10 times, followed by 1
> __ratelimit: 2 callbacks suppressed  (then 10 more frame lost messages, and so on)
> 
> The number in "callbacks suppressed" varies pretty widely, from 2 to 32.
> 
> > Yeah a lot of APs will stuff a ton of info into the IEs these days,
> > including WPS, WPA, 11d, blah blah.  It's not out of the question that
> > the firmware writers didn't anticipate or handle large numbers of IEs in
> > the beacons.  That said, what firmware version is he using?  Maybe
> 
> Using 9.48, I so far haven't found 9.52 for download anywhere.

9.52 AFAIK is only available from Apple Airport drivers if you cut it
out of the .kext on a PPC Mac.

Dan


