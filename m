Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35607 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbZI3NcK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2009 09:32:10 -0400
Date: Wed, 30 Sep 2009 09:30:51 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [rfkill PATCH] default install to $(PREFIX)/sbin
Message-ID: <20090930133051.GA27626@tuxdriver.com>
References: <1254246097-4490-1-git-send-email-linville@tuxdriver.com> <1254256477.30589.1.camel@johannes.local> <20090929210001.GG2678@tuxdriver.com> <1254258160.30589.21.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1254258160.30589.21.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 29, 2009 at 11:02:40PM +0200, Johannes Berg wrote:
> On Tue, 2009-09-29 at 17:00 -0400, John W. Linville wrote:
> > On Tue, Sep 29, 2009 at 10:34:37PM +0200, Johannes Berg wrote:
> > > On Tue, 2009-09-29 at 13:41 -0400, John W. Linville wrote:
> > > > The rfkill utility isn't generally useful to normal users, so move it to
> > > > /sbin with other system management executables.
> > > 
> > > Seems to me that it's kinda useful, it should be possible for most users
> > > to use the event and query interface if the /dev/rfkill permissions are
> > > set up correctly.
> > 
> > Sure, but (just like ip, ifconfig, or iwconfig) nothing stops people
> > from using them in /sbin or /usr/sbin.  It is just a convention for
> > tools that are more for system management than for day-to-day use.
> > 
> > Hopefully most people will stick with NM or whatever and may stay
> > completely unaware of the rfkill utility. :-)
> 
> So are you going to send an iw patch too? :-)

As you wish...on it's way!

> FWIW I like tools in bin/ since the default paths on most systems for
> users don't include sbin/.

FWIW, Fedora has been including it for normal users for a few
releases now.

I agree that it /bin vs /sbin is not strictly necessary, but it is
standard practice.  I guess it does enable some users to either drop
those tools completely from their path or to order their path to
select alternate versions of tools for whatever reason.  Whatever...

I think Fedora will move iw and rfkill to /sbin in any case.
This enables them to be used before /usr is mounted and makes sure
root has them early in his path.  The posted patches are not strictly
necessary for that, but they slightly simplify the install process.
Plus, I think they are more compliant with standard practices.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
