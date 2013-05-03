Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:63961 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763396Ab3ECTkk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 May 2013 15:40:40 -0400
Received: by mail-lb0-f172.google.com with SMTP id y6so1867920lbh.3
        for <linux-wireless@vger.kernel.org>; Fri, 03 May 2013 12:40:38 -0700 (PDT)
Date: Fri, 3 May 2013 21:40:32 +0200 (CEST)
From: Thommy Jakobsson <thommyj@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	m@bues.ch, piotras@gmail.com, Larry.Finger@lwfinger.net
Subject: Re: [PATCH] B43: Handle DMA RX descriptor underrun
In-Reply-To: <20130503173537.GK2069@tuxdriver.com>
Message-ID: <alpine.DEB.2.02.1305032138330.1312@kelly.ryd.net> (sfid-20130503_214044_519665_611B62CB)
References: <alpine.DEB.2.02.1304231851040.1513@kelly.ryd.net> <CACna6rx1zeBDBC-wq+LMWcB1tupe6bs8Z4_JGdnd6vQNomzFnQ@mail.gmail.com> <20130503173537.GK2069@tuxdriver.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Fri, 3 May 2013, John W. Linville wrote:

> On Wed, Apr 24, 2013 at 09:00:59AM +0200, Rafa? Mi?ecki wrote:
> > 2013/4/23 Thommy Jakobsson <thommyj@gmail.com>:
> > > From: Thommy Jakobsson <thommyj@gmail.com>
> > >
> > > Add handling of rx descriptor underflow. This fixes a fault that could
> > > happen on slow machines, where data is received faster than the CPU can
> > > handle. In such a case the device will use up all rx descriptors and
> > > refuse to send any more data before confirming that it is ok. This
> > > patch enables necessary interrupt to discover such a situation and will
> > > handle them by dropping everything in the ring buffer.
> > 
> > Thanks for working on this, I didn't really got enough time to follow
> > your active discussion actively.
> > 
> > I'll try to test this patch on my devices over the next weekend.
> 
> Any word on this testing?  Should this go to 3.10?
It still runs on my device without any problem. Don't know anything about 
Rafael's testing though

BR,
Thommy Jakobsson
