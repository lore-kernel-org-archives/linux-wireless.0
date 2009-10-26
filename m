Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753762AbZJZUQp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 16:16:45 -0400
Subject: Re: [PATCH 17/19] [RFC, v2] libertas: Kconfig entry for
 libertas+cfg80211
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: Christoph Hellwig <hch@infradead.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <200910260904.12417.hs4233@mail.mn-solutions.de>
References: <20091022133043.185554096@mail.mn-solutions.de>
	 <1256315415.2164.46.camel@localhost.localdomain>
	 <20091025033853.GA25873@infradead.org>
	 <200910260904.12417.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Mon, 26 Oct 2009 13:16:35 -0700
Message-Id: <1256588195.2110.32.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-10-26 at 09:04 +0100, Holger Schurig wrote:
> > How much does mesh actually get used?  AFAICS it's a
> > OLPC-specific one off.
> 
> A good question, I don't know no-one that uses mesh outside of 
> OLPC.

Nobody uses the custom libertas mesh stuff outside OLPC.  I tend to look
at it as just not being a dick, subject to the limitations of testing
ability.  Obviously OLPC are the only ones who can do in-depth testing
of mesh-related changes since those of us outside OLPC only have a few
OLPCs/dongles to mesh together.

> 
> > So unless OLPC people come up and fix it why do people even
> > bother with it? 
> 
> In some way the OLPC people won't be bothered, they don't
> follow linux-git or linux-wireless, they are stuck to some
> old kernel (2.6.25 AFAIK). So they don't even notice :-)

Actually untrue; the *shipping* products are still at 2.6.25, but there
are fairly recent kernel trees, especially for the G1.5 machines (which
admittedly don't have the mesh capability anyway, but they do use the
Libertas sd8686).

> However, they need MESH, so if I now rip MESH out completely
> just because I change some configuration API, that would
> bring more burden to them.

Yeah, I don't think it's normal practice in kernel drivers to just rip
something out that we know people are using, we at least put in a modest
amount of effort to not break it completely.  At least basic sanity
testing of mesh start/stop, and if possible, meshing two machines
together with static IP and making sure they can ping each other.  More
extensive testing needs to be done by the organization set up for that.

Dan


