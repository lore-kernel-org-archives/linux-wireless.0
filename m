Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:20919 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762301AbZAPVMp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 16:12:45 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2009 13:12:45 -0800
Date: Fri, 16 Jan 2009 13:12:16 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 03/13] cfg80211: add wiphy_apply_custom_regulatory()
Message-ID: <20090116211216.GM29609@tesla> (sfid-20090116_221250_002558_D7274456)
References: <1232064746-17134-1-git-send-email-lrodriguez@atheros.com> <1232064746-17134-2-git-send-email-lrodriguez@atheros.com> <1232064746-17134-3-git-send-email-lrodriguez@atheros.com> <1232064746-17134-4-git-send-email-lrodriguez@atheros.com> <1232097659.3854.20.camel@johannes> <20090116163646.GG29609@tesla> <1232138270.3745.11.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1232138270.3745.11.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 16, 2009 at 12:37:50PM -0800, Johannes Berg wrote:
> On Fri, 2009-01-16 at 08:36 -0800, Luis R. Rodriguez wrote:
> 
> > > Also, I don't think calling the notifier is
> > > appropriate since the driver just called this function.
> > 
> > Calling the notifier is why we want REGDOM_SET_BY_PROBE. We also technically
> > do not need to call the notifier unless we want to allow for tricks like the
> > one I am using in ath9k to condense the regulatory domains to 5 based on frequency
> > and to let a helper sort out the flags. Without this I believe we'd be forced to
> > use 12 full blown regds.
> 
> I just don't see why the driver couldn't be like this:
> 
> static void helper(...) {...}
> 
> static void ath9k_reg_notifier(...) {
> 	helper(...)
> }
> 
> static void ath9k_something(...) {
> 	apply_custom_regulatory(..)
> 	helper(..)
> }
> 
> so cfg80211 doesn't call back into it but it does it itself. It's
> usually deadlock prone if some called code calls back into the caller
> code.

Sure I'll do it this way then.

  Luis
