Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625AbXJAOXl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Oct 2007 10:23:41 -0400
Subject: Re: wext 64-bit: network manager and wpa_supplicant
From: Dan Williams <dcbw@redhat.com>
To: jt@hpl.hp.com
Cc: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070920205602.GA15373@bougret.hpl.hp.com>
References: <1190292526.18521.52.camel@johannes.berg>
	 <20070920165545.GA29452@bougret.hpl.hp.com>
	 <1190307669.18521.94.camel@johannes.berg>
	 <20070920205602.GA15373@bougret.hpl.hp.com>
Content-Type: text/plain
Date: Mon, 01 Oct 2007 10:18:10 -0400
Message-Id: <1191248290.4490.21.camel@xo-3E-67-34.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-09-20 at 13:56 -0700, Jean Tourrilhes wrote:
> On Thu, Sep 20, 2007 at 07:01:09PM +0200, Johannes Berg wrote:
> > 
> > > 	Then, I modified NetworkManaged to use libiw for scan
> > > parsing. The idea was to simplify NetworkManager and fix the 32-64 bit
> > > bug, plus a few other potential gotchas. The first version of
> > > NetworkManager to include that fix is 0.6.5. But, I've just realised
> > > that I did not convert event parsing, which could be an issue, I'll
> > > try to work on that.
> > > 	Note that the other big issue is that, if wpa_supplicant is
> > > present, NetworkManager will request the scan from it, and won't use
> > > its internal code, so all those fixes are useless. Maybe there should
> > > be a control to force NetworkManager to use its own scan code when
> > > needed.
> > 
> > Does NM always use wpa_supplicant even in 0.6.5? I thought only later
> > versions deferred everything to it.
> 
> 	That was my assumption as well, and the reason I spent time
> doing my patch. However, after your bug report, and before replying to
> you, I went back looking at the code, to verify.
> 	Well, as it happens, 0.6.5 uses wpa_supplicant for the scan if
> it's available (more below).

This is mainly to ensure that wpa_supplicant and NM scan in a
coordinated manner.  Otherwise you get into a situation where
wpa_supplicant scans, and NM's scan timer happens to fall right after
wpa_supplicant's, and the driver gets two back-to-back scan requests
(maybe the second one even overlaps the first).  Makes drivers confused.

> > > 	As far as I know, Debian testing (Lenny) has those
> > > packages. Of course, I would not mind if you could test all this,
> > > verify that the packages are the right version and that iwlist works
> > > properly. If iwlist does not work, the rest will never works.
> > 
> > iwlist works fine on my quad G5 box, but NM doesn't. I suppose then it
> > does use wpa_supplicant.
> 
> 	Ok, we are making slow progress, but at least we are making
> progress. We are highly dependant on good bug reports.
> 
> > > 	With respect to wpa_supplicant. Well, I sent multiple e-mail
> > > to Jouni to inform him about this. My personaly inclination would be
> > > to rip the custom parsing code of wpa_supplicant and use libiw
> > > instead, but Jouni will never accept that. Maybe you should use
> > > xsupplicant instead.
> > 
> > Can't really use xsupplicant, since NM relies on it and we want the
> > kernel to rely more on wpa_supplicant (or another userspace MLME
> > implementation). Is it really hard to fix the parsing code in
> > wpa_supplicant? I'm not familiar with the workaround at all.
> 
> 	Ask Jouni ?
> 	For someone familiar with it, it's actually trivial, you just
> have to follow the patch for Wireless Tools. But for somebody
> unfamiliar, there is a huge learning curve.
> 	That's classical : all the eyes are on the kernel, and nobody
> care about userspace. We really should have more people familiar with
> the guts of wpa_supplicant.
> 
> > > 	Ok, I see what's happening. That would just prevent you to set
> > > authentication information, but that is not the root caause of your
> > > problems. I'll puch a fix ASAP to John.
> > 
> > Not sure, this seems to make wpa_supplicant unhappy enough to not even
> > start doing anything. But then I configured it for WPA.
> 
> 	Patch sent. Can't do harm anyway.
> 
> > johannes
> 
> 	I'm currently stuck because I don't have a box handy to try
> NetworkManager on, most of my boxes are without all the Gnome
> overhead. I'll try to fix that, but it may take a few days.
> 	Meanwhile, I made a few patch just for you for NetworkManager
> 0.6.5. I could not even try to compile it (./configure dependancy), so
> beware.

I think you already did the patch and sent it, and it was committed on
March 2, 2007 to NM CVS.  Unfortunately, I don't think we've cut a
release of NM "stable" (which would be 0.6.5) for a long time, which is
probably quite overdue.  Most distros should be shipping a 0.6.5
snapshot at least.

Dan

> 	The first patch fix the event parsing code to use the libiw
> helpers. As you can see, this dramatically reduce the code
> complexity. However, as this code does not use the payload of events,
> it should not have been affected by the 32-64 bit issue.
> 
> 	The second patch force NetworkManager to always use its own
> scanning code. This is a quick hack, I don't know what will be the
> interaction with wpa_supplicant and I don't know when this part of
> NetworkManager was last tested.
> 	In theory, with that change, you should start to see a list of
> networks in NetworkManager.
> 
> 	Have fun...
> 
> 	Jean

