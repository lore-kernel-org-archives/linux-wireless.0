Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52151 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123Ab2GFVfH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 17:35:07 -0400
Message-ID: <1341610508.16893.26.camel@jlt3.sipsolutions.net> (sfid-20120706_233512_865958_C612DA41)
Subject: Re: [RFC 0/3] mac80211 scanning restructuring
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 06 Jul 2012 23:35:08 +0200
In-Reply-To: <4FF758DB.5010206@candelatech.com>
References: <1341608733-7503-1-git-send-email-johannes@sipsolutions.net>
	 <4FF758DB.5010206@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-07-06 at 14:30 -0700, Ben Greear wrote:
> On 07/06/2012 02:05 PM, Johannes Berg wrote:
> > I decided that with multi-channel coming and thus us using more
> > virtual interfaces, the scanning code was going to be the first
> > victim of some factoring ;-)
> >
> > Please review. The only thing that isn't quite clear to me is
> > whether or not I can really remove the channel == oper_channel
> > check, but it's only applied to probe resp/beacon frames so it
> > seems a bit pointless to try to keep it?
> 
> For what it's worth, I don't see any problems with the patches.

:-)
I think you should see much fewer calls to cfg80211 with this when
beacons are received, when you have many virtual interfaces, but I'm not
sure how you'd see that unless you carefully measure CPU utilization.

> Another enhancement I was thinking about would be to allow
> vifs to piggy-back on other vif's scans.  Instead of
> returning EBUSY when another vif is already scanning, just
> register to receive the scanning vif's results when it finishes.

Hmm, yes, technically that's possible. However, you'd have to verify
that it used exactly the same scan parameters, which seems like a lot of
overhead? Given that we give you the scan parameters in the nl80211
event when the scan finishes (at least I think we do), you could even do
this optimisation in userspace, when -EBUSY is returned?

johannes

