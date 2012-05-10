Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58173 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760725Ab2EJRkQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 13:40:16 -0400
Message-ID: <1336671612.4334.25.camel@jlt3.sipsolutions.net> (sfid-20120510_194033_942177_9B203746)
Subject: Re: [PATCH 1/4] iwlwifi: Add __printf argument checking to __iwl_dbg
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Thu, 10 May 2012 19:40:12 +0200
In-Reply-To: <1336671240.22495.20.camel@joe2Laptop>
References: <1336665952-24363-1-git-send-email-johannes@sipsolutions.net>
	 <1336665952-24363-2-git-send-email-johannes@sipsolutions.net>
	 <1336667905.22495.18.camel@joe2Laptop>
	 <1336668634.4334.23.camel@jlt3.sipsolutions.net>
	 <1336671240.22495.20.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-05-10 at 10:34 -0700, Joe Perches wrote:
> On Thu, 2012-05-10 at 18:50 +0200, Johannes Berg wrote:
> > On Thu, 2012-05-10 at 09:38 -0700, Joe Perches wrote:
> > > Add gcc format and argument printf checking
> > > to reduce future defect introduction.
> []
> > >  #if defined(CONFIG_IWLWIFI_DEBUG) || defined(CONFIG_IWLWIFI_DEVICE_TRACING)
> > > +__printf(5, 6)
> > >  void __iwl_dbg(struct device *dev,
> > >  	       u32 level, bool limit, const char *function,
> > >  	       const char *fmt, ...);
> > 
> > But that looks a bit odd to me? It would seem more natural to me to put
> > the attribute after the parameter list?
> 
> It's an attribute of the function and
> this style is used almost everywhere
> in the kernel.

I also found that for the inline, it *has* to be there. Checkpatch
doesn't like it though if I put it in the same line as "static inline
void" ;-)

johannes

