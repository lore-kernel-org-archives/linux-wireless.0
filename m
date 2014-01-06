Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:11378
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751063AbaAFJJj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 04:09:39 -0500
Date: Mon, 6 Jan 2014 10:09:20 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Johannes Berg <johannes@sipsolutions.net>
cc: Julia Lawall <julia.lawall@lip6.fr>,
	Ben Greear <greearb@candelatech.com>,
	Joe Perches <joe@perches.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	kernel-janitors@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/11]  use ether_addr_equal_64bits
In-Reply-To: <1388999147.5891.2.camel@jlt4.sipsolutions.net>
Message-ID: <alpine.DEB.2.10.1401061007160.2079@hadrien> (sfid-20140106_100946_544482_2A2E13CB)
References: <1388427307-8691-1-git-send-email-Julia.Lawall@lip6.fr>   <1388427307-8691-5-git-send-email-Julia.Lawall@lip6.fr>   <1388429761.4410.1.camel@jlt4.sipsolutions.net>   <alpine.DEB.2.02.1312302057420.2209@localhost6.localdomain6>  
 <1388438724.4573.2.camel@jlt4.sipsolutions.net>   <20131230215701.GA4938@khazad-dum.debian.net>   <1388445188.18164.0.camel@jlt4.sipsolutions.net>  <1388445422.26796.38.camel@joe-AO722>  <alpine.DEB.2.02.1312310726540.1930@localhost6.localdomain6>
 <52C2E8BA.6000800@candelatech.com>  <alpine.DEB.2.10.1312311704320.2074@hadrien>  <52C2F056.1020005@candelatech.com>  <alpine.DEB.2.10.1312311732080.2074@hadrien> <1388999147.5891.2.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 6 Jan 2014, Johannes Berg wrote:

> On Tue, 2013-12-31 at 17:40 +0100, Julia Lawall wrote:
>
> > > If nothing else, then some run-time code that calculates the offset off
> > > and asserts if it is broken in module initialization or similar might
> > > be good enough.
> >
> > Could be OK.  Something right in or after the structure declaration would
> > be nicest.
>
> I don't think you can put a BUILD_BUG_ON() into the structure
> declaration (it's code, not declarations), but I think you could just
> put
>
> BUILD_BUG_ON(sizeof(struct foo) - offsetof(struct foo, addr) < 8);
>
> with the user(s?) and that should catch the scenario I was worrying
> about?

OK, thanks.  That is what I had in mind.  But I was hoping to be able to
put it with the structure.  Perhaps there is a way to make a macro that
expands to a dummy function that contains the BUILD_BUG_ON?  But I guess
that would waste space?

I think that 8 should be 16?

julia
