Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39132 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab3GHSbk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 14:31:40 -0400
Message-ID: <1373308289.8312.17.camel@jlt4.sipsolutions.net> (sfid-20130708_203143_166710_D5854B48)
Subject: Re: Replacement for local->hw.conf.channel
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 08 Jul 2013 20:31:29 +0200
In-Reply-To: <51DB0302.5050201@candelatech.com>
References: <51D4BB56.9070401@candelatech.com>
	  (sfid-20130704_020129_998241_BE6D0EF6) <1372922870.8235.0.camel@jlt4.sipsolutions.net>
	 <51DB0302.5050201@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-07-08 at 11:20 -0700, Ben Greear wrote:
> On 07/04/2013 12:27 AM, Johannes Berg wrote:
> > On Wed, 2013-07-03 at 17:01 -0700, Ben Greear wrote:
> >> I'm trying to port some patches forward to 3.10....
> >>
> >> I am trying to find the current channel for a radio.  Since
> >> hw.conf.channel no longer exists, what is the best way to
> >> go about this?
> >
> > Well there's hw.conf.chandef.chan now I think, but that can be NULL and
> > generic mac80211 code must not use it. There's no single current channel
> > any more, you want vif->chanctx or so.
> 
>  From looking at the scanning code (line 542 or so), it appears
> 
> local->_oper_chandef.chan
> 
> might work?

No, don't use that in any new code. It's purely for compatibility with
drivers that aren't converted to channel contexts (yet).

> In 3.9, ath9k_htc was giving me a null channel in the code below:
> 
> 	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
> 	if (chanctx_conf)
> 		channel = chanctx_conf->def.chan;
> 	else
> 		channel = NULL;

Well that of course happens if the vif isn't bound to a channel context.

johannes

