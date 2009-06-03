Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44748 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882AbZFCTa4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 15:30:56 -0400
Date: Wed, 3 Jun 2009 15:24:54 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dave <kilroyd@googlemail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Samuel Ortiz <samuel@sortiz.org>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: [PATCH] cfg80211: fix Kconfig for users of cfg80211
Message-ID: <20090603192453.GI3317@tuxdriver.com>
References: <1244046631.4862.34.camel@johannes.local> <4A26CBD3.8050009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4A26CBD3.8050009@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 03, 2009 at 08:15:31PM +0100, Dave wrote:
> Johannes Berg wrote:
> >  * iwm doesn't depend on cfg80211 or wireless extensions
> >  * rndis wlan selects cfg80211 - needs to depend
> >  * mac80211 selects cfg80211 - needs to depend
> 
> Hmm. Consider:
> 
> 1. User using a rndis_wlan device on old kernel with cfg80211 unselected.
> 2. Upgrades kernel with make old_config
> 
> Result: the rndis_wlan driver is no longer configured to build.
> 
> I don't think it's a big issue, as you can reconfigure and rebuild as
> soon as you realise. But you may have to 'realise' without google access.
> 
> The only reason I'm thinking of this is because orinoco may be in the
> same boat shortly. Ditto other wireless drivers as they get converted.
> So I had a play with Kconfig. How about something like the patch below
> instead?
> 
> cfg80211 should just get autoselected in the most appropriate mode, and
> drivers get the same restrictions as cfg80211. The option setting
> appears to work fine, but I haven't done any build testing.
> 
> It might be possible to chain things like this, so mac80211 could be
> done in the same way. But I guess we wouldn't want too much of this
> going on...

This patch reminds me of why I hate Kconfig...

If you decide to post it for merging, please include a thorough
description of how it works for those of us with sore brains.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
