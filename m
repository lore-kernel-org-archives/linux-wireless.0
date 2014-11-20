Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39782 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755849AbaKTUiI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2014 15:38:08 -0500
Date: Thu, 20 Nov 2014 21:38:05 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 1/4] cfg80211: leave invalid channels on regdomain
	change
Message-ID: <20141120203805.GQ24486@wotan.suse.de> (sfid-20141120_213812_048125_761A8FCB)
References: <1415895219-19848-1-git-send-email-arik@wizery.com> <1416496620.8557.4.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1416496620.8557.4.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 20, 2014 at 04:17:00PM +0100, Johannes Berg wrote:
> On Thu, 2014-11-13 at 18:13 +0200, Arik Nemtsov wrote:
> > When the regulatory settings change, some channels might become invalid.
> > Disconnect interfaces acting on these channels, after giving userspace
> > code a grace period to leave them.
> 
> So as we discussed, I think you should add a note here that the flag
> only works for some interface types, and prohibit setting the flag when
> unsupported ones are supported. Then you can also remove the message and
> just put in a WARN_ON(1) or something since you can't really get to that
> code path.
> 
> IMHO that's a reasonable trade-off between generalisation and not doing
> all the work now especially since you can't validate it over Intel hw
> for other interface types - if anyone else needs/wants the flag then
> they can add those interface types and change the conditions.

I'd prefer to see this addressed if possible and the flag to let one to
opt out rather than opt in.

  Luis
