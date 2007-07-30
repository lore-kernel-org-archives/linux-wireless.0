Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:64977 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967865AbXG3Sin (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jul 2007 14:38:43 -0400
Date: Mon, 30 Jul 2007 11:37:29 -0700
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Masakazu Mokuno <mokuno@sm.sony.co.jp>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] remove duplicated ioctl entries in compat_ioctl.c
Message-ID: <20070730183729.GB7332@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
References: <20070727191053.GA7572@tuxdriver.com> <20070727215847.GA17991@bougret.hpl.hp.com> <20070730145358.327D.MOKUNO@sm.sony.co.jp> <20070730144726.GA6586@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070730144726.GA6586@tuxdriver.com>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 30, 2007 at 10:47:26AM -0400, John W. Linville wrote:
> On Mon, Jul 30, 2007 at 09:02:56PM +0900, Masakazu Mokuno wrote:
> 
> > In second half of the mail, I understood the he asked how about keeping
> > used one (COMPATIBLE_IOCTL) instead of HANDLE_IOCTL one, considering
> > compatibilities.  As I can esteem the idea that sometimes the compatibilities
> > are more important than changing something and I didn't think my patch
> > could address all problems of the issue and I had much time to test more,
> > I replied with the intention that I didn't stick to the patch if all
> > userland application could work around perfectly.
> 
> Masakazu-san,
> 
> Thank you very much for your thorough explanation of the situation.
> I apologize for having been a bit slow to grasp what you were doing.
> 
> I agree that the HANDLE_IOCTL version seems correct.  As you correctly
> understood, my concern was that we not break anything new in the
> process of fixing this bug.
> 
> Have you tested the both the old and the new wireless-tools on
> a kernel with your patch applied?  Both 32- and 64-bit versions?
> Do they all work equally well?
> 
> Thanks,
> 
> John

	Using SIOCSIWSCAN is probably a bad idea to test, because
there is the extra problem of alignement *within* the data, on top of
the pointer problem.
	Testing with SIOCGIWSTATS or SIOCGIWPRIV would narrow down to
only the pointer problem, and the kernel fix should work with both old
and new version of the Wireless Tools. It's simple to test, either you
are getting valid data or garbage, the only issue is that some drivers
may be returning garbage for those calls.
	Johannes told me (in the thread I linked) that the
HANDLE_IOCTL was improving things (and that how we discovered the
alignement problem). But, Johannes did not do exhaustive testing and I
would welcome more testing, for sure.
	Have fun...

	Jean
