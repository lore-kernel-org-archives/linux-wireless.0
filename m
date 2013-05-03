Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33772 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758925Ab3ECRfr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 May 2013 13:35:47 -0400
Date: Fri, 3 May 2013 13:35:37 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Thommy Jakobsson <thommyj@gmail.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	m@bues.ch, piotras@gmail.com, Larry.Finger@lwfinger.net
Subject: Re: [PATCH] B43: Handle DMA RX descriptor underrun
Message-ID: <20130503173537.GK2069@tuxdriver.com> (sfid-20130503_193553_116529_943FF204)
References: <alpine.DEB.2.02.1304231851040.1513@kelly.ryd.net>
 <CACna6rx1zeBDBC-wq+LMWcB1tupe6bs8Z4_JGdnd6vQNomzFnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACna6rx1zeBDBC-wq+LMWcB1tupe6bs8Z4_JGdnd6vQNomzFnQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 24, 2013 at 09:00:59AM +0200, Rafał Miłecki wrote:
> 2013/4/23 Thommy Jakobsson <thommyj@gmail.com>:
> > From: Thommy Jakobsson <thommyj@gmail.com>
> >
> > Add handling of rx descriptor underflow. This fixes a fault that could
> > happen on slow machines, where data is received faster than the CPU can
> > handle. In such a case the device will use up all rx descriptors and
> > refuse to send any more data before confirming that it is ok. This
> > patch enables necessary interrupt to discover such a situation and will
> > handle them by dropping everything in the ring buffer.
> 
> Thanks for working on this, I didn't really got enough time to follow
> your active discussion actively.
> 
> I'll try to test this patch on my devices over the next weekend.

Any word on this testing?  Should this go to 3.10?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
