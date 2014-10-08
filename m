Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:12298 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756441AbaJHMu6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 08:50:58 -0400
Date: Wed, 8 Oct 2014 14:50:50 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Dan Carpenter <dan.carpenter@oracle.com>
cc: Joe Perches <joe@perches.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch] staging: rtl8723au: incorrect use of ether_addr_copy()
In-Reply-To: <20141008124631.GC26918@mwanda>
Message-ID: <alpine.DEB.2.10.1410081449160.2441@hadrien> (sfid-20141008_145104_181315_E2E82C1D)
References: <20141008104014.GA23096@mwanda> <1412771171.3438.25.camel@joe-AO725> <20141008124631.GC26918@mwanda>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Wed, 8 Oct 2014, Dan Carpenter wrote:

> On Wed, Oct 08, 2014 at 05:26:11AM -0700, Joe Perches wrote:
> > On Wed, 2014-10-08 at 13:40 +0300, Dan Carpenter wrote:
> > > The return from myid() isn't aligned correctly for ether_addr_copy().
> >
> > Hey Dan.
> >
> > Actual evidence showing ether_addr_copy conversions
> > may not always be wise.
> >
> > How did you find them?
>
> I was just trying to see how common these kinds of bugs are.  It didn't
> take long to find, but my impression is that they are rare and I got
> lucky.  These kinds of bugs are tricky to find and we don't have any
> tools for it.

Couldn't you just use your favorite matching tool, collect the file names,
compile them, run pahole, and process the output in some way?  It doesn't
give a complete analysis (you don't find all problems), but if you find a
problem it is a real problem.

julia
