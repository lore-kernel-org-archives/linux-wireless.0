Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:56887 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbXJASUQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Oct 2007 14:20:16 -0400
Date: Mon, 1 Oct 2007 11:18:17 -0700
To: Dan Williams <dcbw@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>,
	linux-wireless@vger.kernel.org
Subject: Re: wext 64-bit: network manager and wpa_supplicant
Message-ID: <20071001181817.GA27179@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
References: <1190292526.18521.52.camel@johannes.berg> <20070920165545.GA29452@bougret.hpl.hp.com> <1190307669.18521.94.camel@johannes.berg> <20070920205602.GA15373@bougret.hpl.hp.com> <1191248290.4490.21.camel@xo-3E-67-34.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1191248290.4490.21.camel@xo-3E-67-34.localdomain>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 01, 2007 at 10:18:10AM -0400, Dan Williams wrote:
> On Thu, 2007-09-20 at 13:56 -0700, Jean Tourrilhes wrote:
> > 
> > 	Well, as it happens, 0.6.5 uses wpa_supplicant for the scan if
> > it's available (more below).
> 
> This is mainly to ensure that wpa_supplicant and NM scan in a
> coordinated manner.  Otherwise you get into a situation where
> wpa_supplicant scans, and NM's scan timer happens to fall right after
> wpa_supplicant's, and the driver gets two back-to-back scan requests
> (maybe the second one even overlaps the first).  Makes drivers confused.

	Yes, I fully agree with this decision, it look to me the right
way to do it.

> > 	I'm currently stuck because I don't have a box handy to try
> > NetworkManager on, most of my boxes are without all the Gnome
> > overhead. I'll try to fix that, but it may take a few days.
> > 	Meanwhile, I made a few patch just for you for NetworkManager
> > 0.6.5. I could not even try to compile it (./configure dependancy), so
> > beware.
> 
> I think you already did the patch and sent it, and it was committed on
> March 2, 2007 to NM CVS.  Unfortunately, I don't think we've cut a
> release of NM "stable" (which would be 0.6.5) for a long time, which is
> probably quite overdue.  Most distros should be shipping a 0.6.5
> snapshot at least.

	The patch last march was for the "scanning" code. The new
patch is for the "event" code. Yes, last march, I totally forgot about
the event code, sorry about that.
	From my casual glance around, most distro ship what they call
"0.6.5". The fact that it's not a release means that all those "0.6.5"
are probably not the exact same version, as they are most likely at
different CVS time. This looks to me like the receipe for some
confusion. I personally don't know which "0.6.5" are good and which
are not, I assume most are good, but without looking at the actual
code, who knows...
	In other words, if you eventually do a release, you may want
to call it "0.6.6".

> Dan

	Have fun...

	Jean
