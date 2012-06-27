Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40771 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756462Ab2F0IKT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 04:10:19 -0400
Message-ID: <1340784614.8305.8.camel@jlt3.sipsolutions.net> (sfid-20120627_101028_913661_FB5776CB)
Subject: Re: [RFC v3] initial channel context implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 27 Jun 2012 10:10:14 +0200
In-Reply-To: <4FEAB698.5070309@tieto.com>
References: <1340714242-20032-1-git-send-email-michal.kazior@tieto.com>
	 <1340718188.14634.47.camel@jlt3.sipsolutions.net>
	 <4FEAB698.5070309@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-27 at 09:30 +0200, Michal Kazior wrote:

> > How are you planning to proceed from here? I'm happy to pick these up
> > even if you're not going to work on using it right away since I think in
> > that case I would probably be working on using it pretty soon, but if
> > you are planning to work on it that's even better :-)
> 
> The next step is to start using channel contexts in mac80211. I was 
> thinking of using chanctx->channel instead of hw.conf.channel if 
> .assign_vif_chanctx is defined. I expect some issues like using channel 
> before it is set.

Ok. Thinking about this a bit I get a feeling that we should internally
fully convert mac80211 over to channel contexts and not make things
conditional. Then, whenever a new channel context is allocated it will
be the only one and we can set hw.conf.channel/type to its channel(type)
and call hw_config() instead of ... add/change chanctx?

That way, we really only need to make a distinction in the low-level
code that actually calls into the driver, and on a higher level we can
just use the channel contexts everywhere.

The biggest issue here will be CSA handling. I have no idea yet how this
will work in multi-channel, maybe we need to disconnect all other
interfaces on the same channel, or so?

> Hwsim requires .hw_scan and ROC to be implemented to test channel 
> contexts. hw_scan should be simple (if we skip a few things..) but 
> haven't looked into the ROC case yet. It also requires some changes to 
> move channel logic per-vif.

Good points.

johannes

