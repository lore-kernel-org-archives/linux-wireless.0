Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57447 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab2EPVDx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 17:03:53 -0400
Message-ID: <1337202227.18519.19.camel@jlt3.sipsolutions.net> (sfid-20120516_230356_898194_5450EFA3)
Subject: Re: [PATCH 3/3] iwlwifi: add __printf argument checking
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Wed, 16 May 2012 23:03:47 +0200
In-Reply-To: <1337201904.10019.21.camel@joe2Laptop> (sfid-20120516_225829_821547_833CA746)
References: <1337200851-20469-1-git-send-email-johannes@sipsolutions.net>
	 <1337200851-20469-4-git-send-email-johannes@sipsolutions.net>
	 <1337201904.10019.21.camel@joe2Laptop>
	 (sfid-20120516_225829_821547_833CA746)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-05-16 at 13:58 -0700, Joe Perches wrote:

> > Change-Id: I7a2ffcd3f625ff29c65519b0c3d474bace884f9d
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > Reviewed-on: http://git-mwg.jer.intel.com/gerrit/2022
> > Tested-by: Jenkins
> > Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> 
> Trivial comments:
> 
> Odd Reviewed-on: and Tested-by: lines.
> The intel.com link does not resolve here too.

Meh, second time I've messed this up... It's not supposed to, so I guess
that's good. I'll send a new version of this.

> > diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
> []
> > @@ -38,10 +38,10 @@ static inline bool iwl_have_debug_level(u32 level)
> >  }
> >  
> >  void __iwl_err(struct device *dev, bool rfkill_prefix, bool only_trace,
> > -		const char *fmt, ...);
> > -void __iwl_warn(struct device *dev, const char *fmt, ...);
> > -void __iwl_info(struct device *dev, const char *fmt, ...);
> > -void __iwl_crit(struct device *dev, const char *fmt, ...);
> > +		const char *fmt, ...) __printf(4, 5);
> > +void __iwl_warn(struct device *dev, const char *fmt, ...) __printf(2, 3);
> > +void __iwl_info(struct device *dev, const char *fmt, ...) __printf(2, 3);
> > +void __iwl_crit(struct device *dev, const char *fmt, ...) __printf(2, 3);
> 
> As far as I know, there are very few in-kernel uses of
> __printf after the function prototype (6 out of 183).
> 
> $ git grep -E "\b__printf\s*\(\s*\w+\s*,\s*\w+\s*\)\s*;" | wc -l
> 6
> $ git grep -E "\b__printf\s*\(\s*\w+\s*,\s*\w+\s*\)" | wc -l
> 183
> 
> I'd prefer to keep the __printf before the return type.

Well, maybe now it's 3 more? :-)

To me, before looks really strange, and while maybe __printf is almost
always before, if you do the same grep with, say, __releases() or
__acquires(), it's almost always after, so ...

johannes

