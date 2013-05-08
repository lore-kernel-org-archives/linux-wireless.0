Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:57291 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab3EHI5Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 May 2013 04:57:25 -0400
Message-ID: <1368003440.8279.16.camel@jlt4.sipsolutions.net> (sfid-20130508_105730_657881_7A942C36)
Subject: Re: [PATCH] mac80211: refine ieee80211_rx() context requirement
From: Johannes Berg <johannes@sipsolutions.net>
To: Wei.Yang@windriver.com
Cc: linux-wireless@vger.kernel.org, wei.wyang@windriver.com
Date: Wed, 08 May 2013 10:57:20 +0200
In-Reply-To: <518A112F.3070903@windriver.com>
References: <1368001892-18068-1-git-send-email-Wei.Yang@windriver.com>
	  <1368002161.8279.14.camel@jlt4.sipsolutions.net>
	  (sfid-20130508_103612_210241_E3587283) <1368002236.8279.15.camel@jlt4.sipsolutions.net>
	 <518A112F.3070903@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-05-08 at 16:47 +0800, wyang1 wrote:
> On 05/08/2013 04:37 PM, Johannes Berg wrote:
> > On Wed, 2013-05-08 at 10:36 +0200, Johannes Berg wrote:
> >> On Wed, 2013-05-08 at 16:31 +0800, Wei.Yang@windriver.com wrote:
> >>> From: Wei Yang <Wei.Yang@windriver.com>
> >>>
> >>> In case of RT kernel, the return value of softirq_count() always
> >>> equal to 0, we need to use in_serving_softirq to decide whether
> >>> the current context is in softirq context.
> >>> -	WARN_ON_ONCE(softirq_count() == 0);
> >>> +	WARN_ON_ONCE(!in_serving_softirq());
> >> As I understand the code, I don't believe this change to be correct. The
> >> function can happily run with softirqs disabled (e.g.
> >> local_bh_disable()), for example by being called via ieee80211_rx_ni().
> >> As I understand in_serving_softirq(), it checks that it's actually
> >> inside handling a softirq, no?
> > Arguably, it should be
> > 	WARN_ON_ONCE(!in_softirq());
> >
> > but that's equivalent:
> 
> Yeah, but the softirq is threaded in rt kernel, the softirq_count always 
> return 0. The warning should always happen with rt kernel.

So maybe then the RT kernel defines in_softirq() appropriately and you
should submit a patch to change to using that? I find it hard to believe
that the RT kernel breaks _all_ the softirq APIs, but hey, I know
nothing about RT :-)

johannes

