Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4784 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757968AbYCYSHA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2008 14:07:00 -0400
Date: Tue, 25 Mar 2008 13:36:28 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: silently accept deletion of non-existant key
Message-ID: <20080325173628.GA3026@tuxdriver.com> (sfid-20080325_180708_792698_7A42DE90)
References: <1206459795-18167-1-git-send-email-linville@tuxdriver.com> <1206462125.16475.303.camel@johannes.berg> <20080325163751.GA19318@tuxdriver.com> <200803251812.45916.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200803251812.45916.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 25, 2008 at 06:12:45PM +0100, Michael Buesch wrote:
> On Tuesday 25 March 2008 17:37:51 John W. Linville wrote:
> > On Tue, Mar 25, 2008 at 05:22:05PM +0100, Johannes Berg wrote:
> > > 
> > > On Tue, 2008-03-25 at 11:43 -0400, John W. Linville wrote:
> > > > From: John W. Linville <linville@linville-t41.local>
> > > > 
> > > > Otherwise, 'iwconfig wlan0 key off' with no key set results in:
> > > > 
> > > > 	Error for wireless request "Set Encode" (8B2A) :
> > > > 	    SET failed on device wlan0 ; No such file or directory.
> > > 
> > > And what is the problem with us telling iwconfig that there was no key?
> > > You should argue for iwconfig ignoring that particular problem, but I
> > > don't think we should do so in the kernel.
> > 
> > Why is it a problem?  How does it hurt anything?  How is it useful
> > to return an error?
> > 
> > FWIW, other drivers seem to accept it.  I don't see why we need to
> > complain.
> 
> Well, it makes sense to return an error in this case, but if common
> practice is to ignore it in old WE based drivers, we should adhere to that
> to preserve userspace ABI compatibility.
> 
> So the real question is: Is there any userspace program that relies on
> this ABI detail?

That seems unlikely.  The only times I recall seeing this reported
is when a mac80211-based driver is used.  If there was something
depending on it, other drivers would be doing it, and I/we would see
this "error" reported elsewhere.

FWIW, the iwconfig semantic is "disabling encryption", not "deleting
the key".  Disabling encryption that is already disabled should be
treated as a no-op, not as an error.

John
-- 
John W. Linville
linville@tuxdriver.com
