Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45397 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab0DZMbC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 08:31:02 -0400
Subject: Re: [RFC PATCHv3 1/2] mac80211: Determine dynamic PS timeout based
 on ps-qos network latency
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1272284587.6205.10424.camel@wimaxnb.nmp.nokia.com>
References: <1271409274-17162-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1271409274-17162-2-git-send-email-juuso.oikarinen@nokia.com>
	 <1271688177.23671.1.camel@jlt3.sipsolutions.net>
	 <1271740120.6205.5733.camel@wimaxnb.nmp.nokia.com>
	 <1271925939.3605.7.camel@jlt3.sipsolutions.net>
	 <1271926547.6205.8870.camel@wimaxnb.nmp.nokia.com>
	 <1271927257.3605.18.camel@jlt3.sipsolutions.net>
	 <1271928576.6205.8919.camel@wimaxnb.nmp.nokia.com>
	 <1272282845.3619.25.camel@jlt3.sipsolutions.net>
	 <1272283483.6205.10416.camel@wimaxnb.nmp.nokia.com>
	 <1272283911.3619.29.camel@jlt3.sipsolutions.net>
	 <1272284587.6205.10424.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Apr 2010 14:30:59 +0200
Message-ID: <1272285059.3619.31.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-04-26 at 15:23 +0300, Juuso Oikarinen wrote:

> Heh, I could in turn say that you think too little about power
> consumption :) This particular thing, dynamic ps timer, has a *huge*
> effect on the total power consumption just because it's so frequent.

Heh :)

> I'm basically open for any means to tell cfg80211 that it should
> sacrifice service quality in the name of saving as much power as it can
> (apart from shutting the thing down :). Can you give me a hint on what
> you would consider an acceptable way to do this?

Well personally I'm happy with this approach.

I just fear that at one point, somebody will tweak the algorithm, and
you will have deeply ingrained assumptions about where the cutoff points
are in your userland software, which will cause all kinds of grief.

johannes

