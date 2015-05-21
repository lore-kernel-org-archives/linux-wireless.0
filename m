Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43247 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbbEUIbD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 04:31:03 -0400
Message-ID: <1432197058.2343.7.camel@sipsolutions.net> (sfid-20150521_103108_304915_750836E9)
Subject: Re: [PATCH v2 2/2] mac80211: prevent possible crypto tx tailroom
 corruption
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 21 May 2015 10:30:58 +0200
In-Reply-To: <CA+BoTQkpjDodKNdSvj2ZdKemXU_2E39MVGZPob8+jkjBGESEfg@mail.gmail.com> (sfid-20150521_101657_739944_260917A1)
References: <1431349503-5461-1-git-send-email-michal.kazior@tieto.com>
	 <1431508609-9841-1-git-send-email-michal.kazior@tieto.com>
	 <1431508609-9841-2-git-send-email-michal.kazior@tieto.com>
	 <1432127653.19214.12.camel@sipsolutions.net>
	 <CA+BoTQkpjDodKNdSvj2ZdKemXU_2E39MVGZPob8+jkjBGESEfg@mail.gmail.com>
	 (sfid-20150521_101657_739944_260917A1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-05-21 at 10:16 +0200, Michal Kazior wrote:

> >>       rtnl_lock();
> >> +     list_for_each_entry(sdata, &local->interfaces, list)
> >> +             cancel_delayed_work_sync(&sdata->dec_tailroom_needed_wk);
> >
> > Would it make sense to just flush the work here? That way we don't have
> > to do all the other things.
> 
> Hmm.. dec_tailroom_needed_wk is queued on system workqueue now so
> there's no feasible way of flushing it (restart_work is on a system
> workqueue as well). It'd need to be moved to local->workqueue. I guess
> that would work too.

flush_work()?

johannes

