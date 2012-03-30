Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:36815
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935349Ab2C3VXo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Mar 2012 17:23:44 -0400
Date: Fri, 30 Mar 2012 17:23:39 -0400
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arend van Spriel <arend@broadcom.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] compat: crc8: undef pr_fmt
Message-ID: <20120330212339.GB11929@bombadil.infradead.org> (sfid-20120330_232353_017031_20555ABE)
References: <1333105980.3908.14.camel@jlt3.sipsolutions.net>
 <4F759DE4.6070201@broadcom.com>
 <1333108491.12545.0.camel@jlt3.sipsolutions.net>
 <4F75A3B8.7040501@broadcom.com>
 <1333110510.12545.1.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1333110510.12545.1.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 30, 2012 at 02:28:30PM +0200, Johannes Berg wrote:
> On Fri, 2012-03-30 at 14:14 +0200, Arend van Spriel wrote:
> > On 03/30/2012 01:54 PM, Johannes Berg wrote:
> > > On Fri, 2012-03-30 at 13:49 +0200, Arend van Spriel wrote:
> > >> On 03/30/2012 01:13 PM, Johannes Berg wrote:
> > >>>
> > >>> +#ifdef pr_fmt
> > >>> +#undef pr_fmt
> > >>> +#endif
> > >>>    #define pr_fmt(fmt)		KBUILD_MODNAME ": " fmt
> > >>>
> > >>>    #include<linux/module.h>
> > >>
> > >> Trivial remark. Not really necessary to do the #ifdef. #undef works fine
> > >> if pr_fmt has not been defined.
> > >
> > > Really? I thought it would give a warning then, but couldn't test it
> > > since it was defined for me.
> > >
> > > johannes
> > >
> > >
> > 
> > I made a little test program to confirm my thought, before sending my 
> > previous email. Retried compiling with '-W -Wall -ansi -pedantic' and no 
> > complaints about the #undef.
> 
> Ok. I'm too lazy to send a new patch, but maybe Luis wants to change it
> when he applies it :)

I changed it, and applied, thanks!!!

  Luis
