Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49635 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756779Ab2FTPlm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 11:41:42 -0400
Message-ID: <1340206900.4655.77.camel@jlt3.sipsolutions.net> (sfid-20120620_174145_415683_6C6E5A20)
Subject: Re: [PATCH 1/2] cfg80211: Support for automatic channel selection
 in AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: Vivek Natarajan <nataraja@qca.qualcomm.com>,
	jouni@qca.qualcomm.com, kvalo@qca.qualcomm.com,
	linux-wireless@vger.kernel.org
Date: Wed, 20 Jun 2012 17:41:40 +0200
In-Reply-To: <CAJqpcCQ34PFxAapy0q1WCQQO8NehV+niwEHpbbTDL+e=rJ7X=w@mail.gmail.com> (sfid-20120620_114256_209959_B1E0B5E9)
References: <1340017242-6436-1-git-send-email-nataraja@qca.qualcomm.com>
	 <1340182500.4655.47.camel@jlt3.sipsolutions.net>
	 <CAJqpcCQ34PFxAapy0q1WCQQO8NehV+niwEHpbbTDL+e=rJ7X=w@mail.gmail.com>
	 (sfid-20120620_114256_209959_B1E0B5E9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-20 at 15:12 +0530, Vivek Natarajan wrote:

> >> For P2P, the operating channel needs to be known before group negotiation starts.
> >> This is true in case of P2P GO or client. It needs a separate p2p command from
> >> wpa_cli to get the acs-based best channel information from the driver.
> >
> > So .. is there any reason to not do only the second, and then pass that
> > channel back here instead?
> 
> So, what you recommend is, for both AP and P2P GO modes, the logic
> should be to request the driver for best channel, then the best
> channel information event to be passed to userspace and then starting
> the AP/GO mode of operation.

That's what I'm thinking, yes.

> The current ath6kl firmware has some limitation for getting this
> channel information separately and hence not yet implemented this.
> Moreover this needs to be a synchronous operation: to request and get
> the event for best channel after a full cycle of channel assessment is
> done.

Right, but if you're working on this surely you can do without this
particular patch for now?

The reason I'm talking about this is the channel concurrency framework
that Michal is working on, which would conflict somehow with this I
think.

johannes

