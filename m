Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753538Ab1JTQJX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Oct 2011 12:09:23 -0400
Date: Thu, 20 Oct 2011 18:09:00 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211:  Fix off-channel problem in work task.
Message-ID: <20111020160859.GC2293@redhat.com> (sfid-20111020_180927_083424_F4DCC491)
References: <1319049876-16243-1-git-send-email-greearb@candelatech.com>
 <20111020145852.GB2293@redhat.com>
 <4EA03CCF.6090604@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4EA03CCF.6090604@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 20, 2011 at 08:22:55AM -0700, Ben Greear wrote:
> On 10/20/2011 07:58 AM, Stanislaw Gruszka wrote:
> >On Wed, Oct 19, 2011 at 11:44:36AM -0700, greearb@candelatech.com wrote:
> >>From: Ben Greear<greearb@candelatech.com>
> >>
> >>The ieee80211_cfg_on_oper_channel method compared the
> >>current hardware config as well as the desired hardware
> >>config.  In most cases, this is proper, but when deciding
> >>whether to go back on-channel, if the hardware is not
> >>configured on-channel, but logically it *should* be
> >>on-channel, then we must go on-channel.
> >>
> >>This patch adds a flag to the ieee80211_cfg_on_oper_channel
> >>logic to disable comparing the actual hardware so we do not
> >>have to create another tricky method with similar logic.
> >>
> >>Reported-by: Eliad Peller<eliad@wizery.com>
> >>Signed-off-by: Ben Greear<greearb@candelatech.com>
> >
> >I much more prefer previous one-line patch from Eliad
> >http://news.gmane.org/find-root.php?message_id=%3c1311607763%2d12603%2d3%2dgit%2dsend%2demail%2deliad%40wizery.com%3e
> >
> >this one seems to provide unneeded code complexity, but
> >behaviour i.e. number of channel switches in hardware
> >is the same.
> 
> I believe it's possible to set tmp_channel to NULL and not actually
> change the on/off channel configuration, and my patch should allow us to
> skip a hardware config in that case.
> 
> However, this might only be possible if we are in this code while
> scanning, and currently, I don't believe we can be in this work
> code while scanning.

So you want to optimize a case that is not even possible at present.
Do you know that "premature optimization is the root of all evil" ? :-)

I'm not quite against by that change, but I would like to have -stable
fixes, since bug we are talking about not only annoys people by warning,
but also disallow to associate to wireless network. I prefer that we
apply Eliad patches and cc -stable and do possible further optimization
on top of that (ideally if some measurement will be available that show
optimization really works).

Thanks
Stanislaw
