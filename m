Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:54653 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751961AbZA1CBR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 21:01:17 -0500
Date: Tue, 27 Jan 2009 17:36:35 -0800
From: Greg KH <greg@kroah.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: stable@kernel.org, andrey@cozybit.com,
	linux-wireless@vger.kernel.org, Keir <keirlawson@gmail.com>
Subject: Re: [stable] ath5k mesh in 2.6.28?
Message-ID: <20090128013635.GA12223@kroah.com> (sfid-20090128_030123_197340_0BAC4C8C)
References: <e27b78a40901230530h192a8030l6905089df2a5822d@mail.gmail.com> <b6c5339f0901230717h605d2fbaibda8b720c6191abf@mail.gmail.com> <e27b78a40901230725r4dc40975t8e4cb9f481df1702@mail.gmail.com> <20090123153305.M33802@bobcopeland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090123153305.M33802@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 23, 2009 at 11:26:15AM -0500, Bob Copeland wrote:
> > 2009/1/23 Bob Copeland <me@bobcopeland.com>:
> > > On Fri, Jan 23, 2009 at 8:30 AM, Keir <keirlawson@gmail.com> wrote:
> > >> Hi,
> > >>
> > >> According to the 802.11s website it seems to claim that mesh
> > >> networking is supported for ath5k devices in kernel 2.6.28, however,
> > >> upon running ifconfig mesh0 up (having previously created the mesh
> > >> device using iw) I get "SIOCSIFFLAGS: Operation not supported".
> [...]
> > >
> > > Mesh was enabled for 2.6.29 via b706e65b40417e03c2451bb3f92488f3736843fa,
> > > so if you need it in 2.6.28 you can ask Greg to pick it up for stable.
> >
> > I would really like support in 2.6.28, but I don't want to
> > inconvenience anyone... who's Greg?  What I would really like is ath5k
> > mesh support in a stable kernel, the wireless-testing kernel I'm
> > currently using is too unstable for my testing.
> 
> Your other option is to use compat-wireless with 2.6.28.  That might
> be easier.  However, fixing mesh in 2.6.28 isn't a huge change and it
> doesn't change any paths for any other opmode, so we might as well
> ask...
> 
> Hi stable hackers,
> 
> Would you consider taking b706e65b40417e03c2451bb3f92488f3736843fa,
> "ath5k: fix mesh point operation" for 2.6.28-stable?  It's a new feature 
> compared to 2.6.27, so not a regression per se; however, ath5k advertises
> mesh support in wiphy->interface_modes but doesn't make good on that 
> promise when it comes to actually setting up such an interface.
> 
> Here's a rebased patch on top of 2.6.28:
> 
> >From 8569edccf7c900aecfaa32ccd4e84c56fb0460c4 Mon Sep 17 00:00:00 2001
> From: Andrey Yurovsky <andrey@cozybit.com>
> Date: Mon, 13 Oct 2008 18:23:07 -0700
> Subject: [PATCH] ath5k: fix mesh point operation
> 
> This patch fixes mesh point operation (thanks to YanBo for pointing
> out the problem): make mesh point interfaces start beaconing when
> they come up and configure the RX filter in mesh mode so that mesh
> beacons and action frames are received.  Add mesh point to the check
> in ath5k_add_interface.  Tested with multiple AR5211 cards.
> 
> Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
> Acked-by: Nick Kossifidis <mickflemm@gmail.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Now queued up, thanks for the backport.

greg k-h
