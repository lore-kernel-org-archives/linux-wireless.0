Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f196.google.com ([209.85.222.196]:55530 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbZHERtn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 13:49:43 -0400
Received: by pzk34 with SMTP id 34so202336pzk.4
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2009 10:49:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1249491866.6902.23.camel@johannes.local>
References: <2f1373ed0908042145pc83adc5qd968e3bf8d0ce3c7@mail.gmail.com>
	 <175701.5780.qm@web55308.mail.re4.yahoo.com>
	 <20090805165021.GA20338@tuxdriver.com>
	 <1249491866.6902.23.camel@johannes.local>
Date: Wed, 5 Aug 2009 10:49:44 -0700
Message-ID: <445f43ac0908051049wb32ea49r3e8894fd99f4ae60@mail.gmail.com>
Subject: Re: Status of 802.11s in wireless-testing?
From: Javier Cardona <javier@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	xxiao <austinxxh-ath9k@yahoo.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Wed, Aug 5, 2009 at 10:04 AM, Johannes Berg<johannes@sipsolutions.net> wrote:
> Right now, except from the stuff Luis had broken and fixed, the real
> problem is that there are a bunch of bugs that appear to have been in
> the code forever, just never noticed -- for instance the code can end up
> calling synchronize_rcu() in an atomic section.

I agree that there is a bug in that would cause a synchronize_rcu() in
an atomic section when the mpath table grows beyond a certain size.
The bug was there since the first submission of the mesh code, yes.

However, the "bunch of bugs that appear to have been in the code
forever" are, I believe, regressions.  In particular we've identified:
 - Airtime Link Metric broken (fix in progress)
 - Forwarding path broken (fixed here:
http://marc.info/?l=linux-wireless&m=124698982910794&w=2)
 - mpath pending queue broken (fixed here:
http://marc.info/?l=linux-wireless&m=124717648406661&w=2)
 - PREQ notification broken (fixed here:
http://marc.info/?l=linux-wireless&m=124752948320455&w=2)

We've been busy with those but the synchronize_rcu fix is next in our list.

> This is the reason for disabling it -- it can splatter all over the
> scheduler if that happens, and it's not clear to me that it cannot
> happen. It seems not to happen in _most_ scenarios, but I've certainly
> caused it to happen by not beaconing, for instance.

I also agree with your assessment of the severity of the bug.
Hopefully we'll get to fix it really soon so we can re-enable mesh
again.

Thanks,
