Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52421 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933129Ab3CMTAc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 15:00:32 -0400
Date: Wed, 13 Mar 2013 14:46:57 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	alessandro.lannocca@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH for 3.9] rtlwifi: rtl8192cu: Fix problem that prevents
 reassociation
Message-ID: <20130313184656.GD19917@tuxdriver.com> (sfid-20130313_200036_550577_5633E1FE)
References: <51409b0d.AKkQggbo18xQwrFd%Larry.Finger@lwfinger.net>
 <5140ACCB.4050408@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5140ACCB.4050408@iki.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 13, 2013 at 06:43:55PM +0200, Jussi Kivilinna wrote:
> On 13.03.2013 17:28, Larry Finger wrote:
> > The driver was failing to clear the BSSID when a disconnect happened. That
> > prevented a reconnection. This problem is reported at
> > https://bugzilla.redhat.com/show_bug.cgi?id=789605,
> > https://bugzilla.redhat.com/show_bug.cgi?id=866786,
> > https://bugzilla.redhat.com/show_bug.cgi?id=906734, and
> > https://bugzilla.kernel.org/show_bug.cgi?id=46171.
> > 
> > Thanks to Jussi Kivilinna for making the critical observation
> > that led to the solution.
> > 
> > Reported-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
> > Tested-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
> > Tested-by: Alessandro Lannocca <alessandro.lannocca@gmail.com>
> > Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> > Cc: Stable <stable@vger.kernel.org>
> > ---
> > 
> > John,
> > 
> > As you can see by the number of bug reports, this patch should be
> > pushed as soon as possible.
> > 
> > Thanks,
> > 
> > Larry
> > ---
> > 
> >  base.h         |    3 +
> >  pci.c          |    2 -
> 
> Seems like leak from another patch/change?

I edited-out those bits...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
