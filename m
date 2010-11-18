Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37893 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758229Ab0KRUBs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 15:01:48 -0500
Subject: Re: iwlwifi: fix modular legacy build errors
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4CE5849D.1060705@oracle.com>
References: <1290011797.12056.255.camel@wwguy-huron>
	 <1290012580.3777.1.camel@jlt3.sipsolutions.net>
	 <4CE40CF9.8090404@oracle.com> <1290013876.12056.260.camel@wwguy-huron>
	 <20101118091138.80875baf.randy.dunlap@oracle.com>
	 <1290101760.6131.1.camel@wwguy-ubuntu>
	 <20101118175434.GC2468@tuxdriver.com>  <4CE57EB3.5070902@oracle.com>
	 <1290109607.3801.8.camel@jlt3.sipsolutions.net>
	 <4CE5849D.1060705@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Nov 2010 12:03:17 -0800
Message-ID: <1290110597.3801.10.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-11-18 at 11:55 -0800, Randy Dunlap wrote:

> > iwlcore-objs += $(iwlcore-m)
> > 
> > to your Makefile after the iwl-legacy lines and see if that helps for
> > you as well? It seems that the reason is that iwl-legacy never gets
> 
> Yes, that builds fine.

Ok, thanks. I think I'll just not worry about it and add that then.

> > -iwlagn-$(CONFIG_IWL4965) += iwl-4965.o
> > +iwlagn-$(CONFIG_IWL4965) += iwl-4965.o iwl-legacy.o
> > 
> > Why does that work, but not iwlcore-$(CONFIG_IWL4965)??
> 
> I dunno, but I only tested my erroneous patch when building as loadable
> modules, not builtin.  Testing error on my part.

Actually, I get it -- 4965 cannot be modular. And then I probably never
tested 3945 _only_, but maybe only 4965 _only_ ... oh well. I'll go fix
it.

johannes

