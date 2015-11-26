Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35758 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632AbbKZJkI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 04:40:08 -0500
Message-ID: <1448530804.2167.4.camel@sipsolutions.net> (sfid-20151126_104013_459733_939A714B)
Subject: Re: [PATCH v7] Add new mac80211 driver mwlwifi.
From: Johannes Berg <johannes@sipsolutions.net>
To: David Lin <dlin@marvell.com>, Kalle Valo <kvalo@codeaurora.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Chor Teck Law <ctlaw@marvell.com>,
	Pete Hsieh <peteh@marvell.com>
Date: Thu, 26 Nov 2015 10:40:04 +0100
In-Reply-To: <097ef0472294430d98940ad601a4aade@SC-EXCH02.marvell.com>
References: <b11fd1b49b274142b85296c11c634635@SC-EXCH02.marvell.com>
	 <1448018530.3141.25.camel@sipsolutions.net>
	 <097ef0472294430d98940ad601a4aade@SC-EXCH02.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-11-26 at 08:27 +0000, David Lin wrote:

> > Since you do this in .probe, you should consider loading the
> > firmware asynchronously.
> > 
> 
> I hope I can postpone this modification later.

I don't feel strongly about this one - otoh it's not really
complicated.

> > > +#ifdef CONFIG_SUPPORT_MFG
> > 
> > This Kconfig variable doesn't exist.
> > 
> 
> The compile variable is used privately by Marvell and our customers
> in production line.

Yeah, still. Make it a proper Kconfig variable, defaulting to off and
hidden under something, or remove it. It's extremely misleading to have
something called CONFIG_* when it's not a Kconfig variable.

> Mac80211 does not support mesh AMSDU now, we implement this function
> in mwlwifi driver for the time being. Except for mesh AMSDU, we still
> leverage mac80211 to handle data AMSDU.

You're allowed to modify mac80211.

> > What's going on here? Why are you modifying the action frames on
> > the fly??!
> > 
> 
> Due to mwlwifi supports Tx/Rx AMSDU, these frames are modified to
> inform client that we support AMSDU.
> 

Ditto - you're allowed to modify mac80211. We actually have a patch
like this already:
https://git.kernel.org/cgit/linux/kernel/git/jberg/mac80211-
next.git/commit/?id=99e7ca44bb910f0cbfda5d9008e8517df0ebc939

johannes
