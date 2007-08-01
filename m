Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:58146 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761931AbXHAMX0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2007 08:23:26 -0400
Date: Wed, 1 Aug 2007 14:23:18 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Andy Green <andy@warmcat.com>, linux-wireless@vger.kernel.org,
	James Ketrenos <jketreno@linux.intel.com>
Subject: Re: Rate control over multiple devices
Message-ID: <20070801142318.7234c63b@griffin.suse.cz>
In-Reply-To: <1185969255.21901.11.camel@johannes.berg>
References: <46AFB779.4040003@warmcat.com>
	<20070801004543.GD4719@tuxdriver.com>
	<1185960764.14279.2.camel@johannes.berg>
	<20070801134624.481eb856@griffin.suse.cz>
	<1185969255.21901.11.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 01 Aug 2007 13:54:15 +0200, Johannes Berg wrote:
> I suppose you mean this patch
> http://article.gmane.org/gmane.linux.kernel.wireless.general/2303

Yes. But I'd like to see a solution to the problem reported by Andy in
the patch. One of the possible solutions could be adding a "this is a
special rate control alg which shouldn't be selected automatically"
flag to rate control algs and not selecting such algorithms in
ieee80211_try_rate_control_ops_get when 'name' is NULL. Should be easy
to implement.

> > > Of course, in a perfect world we'd have a 'default' rate control setting
> > > somewhere and apply that for drivers that have rate_control==NULL, while
> > > default would default to 'simple' to avoid the issue above.

That's a possible solution too, though not an ideal one. Currently, you
can use module alias to change default rate control algorithm - at
least for simple setups. This would break it.

> > I'd really like to see that in the patch. Seems to be a real issue.
> 
> Except that we have no API for that (should be in cfg80211.)

We will need an API for changing of rate control alg from the user
space, sure - but that's not an issue here, this patch is purely
mac80211 thing.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
