Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56285 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab2FXJbM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jun 2012 05:31:12 -0400
Message-ID: <1340530258.4577.4.camel@jlt3.sipsolutions.net> (sfid-20120624_113149_922579_7B3EB009)
Subject: Re: [PATCH 4/6] mac80211: clean up debugging
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: linux-wireless@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>,
	Jason Baron <jbaron@redhat.com>
Date: Sun, 24 Jun 2012 11:30:58 +0200
In-Reply-To: <1340466044.7758.4.camel@joe2Laptop>
References: <1340385525-14487-1-git-send-email-johannes@sipsolutions.net>
	 <1340385525-14487-5-git-send-email-johannes@sipsolutions.net>
	 <1340438536.2274.9.camel@joe2Laptop>
	 <1340456697.4636.1.camel@jlt3.sipsolutions.net>
	 <1340466044.7758.4.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2012-06-23 at 08:40 -0700, Joe Perches wrote:

> > FWIW, I would definitely prefer named rather than bitmap selectors :-)
> 
> (Added Jason and Jim)
> 
> Given it's a debug-only facility, I think bitmap
> selectors sufficient, Maybe adding an external
> utility to map names to bits would be enough to
> not need that feature in the kernel.

I guess the real question isn't whether it should be a bitmap or a name
or whatever, it's how it's implemented. To allay fears about runtime
overhead, I think it would be good to use the jump_label mechanism to
implement it -- I do realise that still has runtime overhead for the
argument preparation, but still.

Looking at the history, it seems that jump labels were at one point used
by reverted to fix gcc 3.3, I'm sure that could be resolved?

Anyway, the point is that if it uses jump labels then we need some sort
of house-keeping structures anyway to be able to enable/disable the
right jump labels. And that could easily have a string attached, which
would make it easier when working with bug reporters etc. since you
don't have to worry about the exact bitmap, you can give them a string
(and if it's wrong, there will be a failure rather than silently getting
the wrong data)

johannes

