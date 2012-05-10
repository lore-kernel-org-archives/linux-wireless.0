Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:60819 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760325Ab2EJReD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 13:34:03 -0400
Message-ID: <1336671240.22495.20.camel@joe2Laptop> (sfid-20120510_194820_414705_9F9306DD)
Subject: Re: [PATCH 1/4] iwlwifi: Add __printf argument checking to __iwl_dbg
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Thu, 10 May 2012 10:34:00 -0700
In-Reply-To: <1336668634.4334.23.camel@jlt3.sipsolutions.net>
References: <1336665952-24363-1-git-send-email-johannes@sipsolutions.net>
	 <1336665952-24363-2-git-send-email-johannes@sipsolutions.net>
	 <1336667905.22495.18.camel@joe2Laptop>
	 <1336668634.4334.23.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-05-10 at 18:50 +0200, Johannes Berg wrote:
> On Thu, 2012-05-10 at 09:38 -0700, Joe Perches wrote:
> > Add gcc format and argument printf checking
> > to reduce future defect introduction.
[]
> >  #if defined(CONFIG_IWLWIFI_DEBUG) || defined(CONFIG_IWLWIFI_DEVICE_TRACING)
> > +__printf(5, 6)
> >  void __iwl_dbg(struct device *dev,
> >  	       u32 level, bool limit, const char *function,
> >  	       const char *fmt, ...);
> 
> But that looks a bit odd to me? It would seem more natural to me to put
> the attribute after the parameter list?

It's an attribute of the function and
this style is used almost everywhere
in the kernel.

