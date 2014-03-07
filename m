Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41776 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbaCGOoc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2014 09:44:32 -0500
Message-ID: <1394203467.4653.15.camel@jlt4.sipsolutions.net> (sfid-20140307_154447_867076_45F239E2)
Subject: Re: [PATCH 3/3] mac80211: compute chanctx refcount dynamically
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>,
	"Zhao, Gang" <gamerh2o@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 07 Mar 2014 15:44:27 +0100
In-Reply-To: <1394191196-6425-3-git-send-email-michal.kazior@tieto.com> (sfid-20140307_122532_789476_71C0C158)
References: <1394191196-6425-1-git-send-email-michal.kazior@tieto.com>
	 <1394191196-6425-3-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140307_122532_789476_71C0C158)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-03-07 at 12:19 +0100, Michal Kazior wrote:
> It doesn't make much sense to have a manually
> managed chanctx refcount. It isn't performance
> critical and it can't be even used outside the
> protection of chanctx_mtx.
> 
> With future enhancements to channel contenxt
> (namely reservations) refcount accounting will
> become more complex and having manually managed
> refcount is going to be error-prone and confusing.
> 
> The refcount is now equal to the number of vifs it
> is assigned to. However in the future this will
> change so keep the refcount/num_assigned_vifs
> functions split now.

Alright, all of this looks fine, but we have a ton of churn in this area
right now, and I've been sick and not as attentive as usual. Somebody
also recently posted patches to refactor the recalc_* functions for
channel contexts, which is sure to conflict with this.

With Luca and myself both also travelling for the next ~week, what's
your preference on how to work this out? I likely won't be merging much
while I'm not at home.

At least one of you will probably have to rebase the patches, and while
I don't really care who does it or in which order they go in, I didn't
really want to say that only in over a week from now.

Maybe one of you can just put a git tree somewhere in the meantime
(forked from mac80211-next) and collect those CSA/chanctx-related
patches in there? So far, I think most patches I've seen fly by looked
fine (from their description, I haven't had a chance to look into them
in too much detail.)

Of course I don't mind if you want to just wait for me to be back, I'm
happy to do the merging and then complain about patches that need
rebasing, just be warned that that would likely only happen after the
17th.

johannes

