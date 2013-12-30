Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0187.hostedemail.com ([216.40.44.187]:45205 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932343Ab3L3XRI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Dec 2013 18:17:08 -0500
Message-ID: <1388445422.26796.38.camel@joe-AO722> (sfid-20131231_001730_120059_1E375805)
Subject: Re: [PATCH 4/11]  use ether_addr_equal_64bits
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Julia Lawall <julia.lawall@lip6.fr>,
	kernel-janitors@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Date: Mon, 30 Dec 2013 15:17:02 -0800
In-Reply-To: <1388445188.18164.0.camel@jlt4.sipsolutions.net>
References: <1388427307-8691-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1388427307-8691-5-git-send-email-Julia.Lawall@lip6.fr>
	 <1388429761.4410.1.camel@jlt4.sipsolutions.net>
	 <alpine.DEB.2.02.1312302057420.2209@localhost6.localdomain6>
	 <1388438724.4573.2.camel@jlt4.sipsolutions.net>
	 <20131230215701.GA4938@khazad-dum.debian.net>
	 <1388445188.18164.0.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-12-31 at 00:13 +0100, Johannes Berg wrote:
> On Mon, 2013-12-30 at 19:57 -0200, Henrique de Moraes Holschuh wrote:
> > On Mon, 30 Dec 2013, Johannes Berg wrote:
> > > On Mon, 2013-12-30 at 20:58 +0100, Julia Lawall wrote:
> > > > > Is there any way we could catch (sparse, or some other script?) that
> > > > > struct reorganising won't break the condition needed ("within a
> > > > > structure that contains at least two more bytes")?
> > > > 
> > > > What kind of reorganizing could happen?  Do you mean that the programmer 
> > > > might do at some time in the future, or something the compiler might do?
> > > 
> > > I'm just thinking of a programmer, e.g. changing a struct like this:
> > > 
> > >  struct foo {
> > >    u8 addr[ETH_ALEN];
> > > -  u16 dummy;
> > >  };

I don't know of a way to catch that.
Anyone else?

