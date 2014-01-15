Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37607 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaAOJjK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 04:39:10 -0500
Message-ID: <1389778744.4338.2.camel@jlt4.sipsolutions.net> (sfid-20140115_103914_748408_8CC93144)
Subject: Re: [RFC 4/4] cfg80211: implement multi-BSS CSA
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 15 Jan 2014 10:39:04 +0100
In-Reply-To: <CA+BoTQmrFARTcupjCFuz6V=c7fHHgiSurbCfnr79En=LozftFg@mail.gmail.com> (sfid-20140115_075217_586020_C5704A1F)
References: <1389194818-7864-1-git-send-email-michal.kazior@tieto.com>
	 <1389194818-7864-5-git-send-email-michal.kazior@tieto.com>
	 <1389716461.32635.15.camel@jlt4.sipsolutions.net>
	 <CA+BoTQmrFARTcupjCFuz6V=c7fHHgiSurbCfnr79En=LozftFg@mail.gmail.com>
	 (sfid-20140115_075217_586020_C5704A1F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-15 at 07:52 +0100, Michal Kazior wrote:

> So you're basically saying the new attribute should be used as an
> array attribute instead. Sounds good, but..
> 
> What about backward compatibility? Do we not care? Or should we
> preserve old parsing for single-interface CSA (i.e. older hostapd)?

I think we have to preserve the old parsing if the new isn't present,
but that shouldn't be all that difficult?

if (info->attrs[MULTI])
  for_each_attr(a, info->attrs[MULTI])
    parse_nested(a, attrs);
    parse(attrs);
else
  parse(info->attrs);

or something like that, right?

> > is more error prone as it would allow older kernels to parse the whole
> > thing while ignoring the next/more/whatever, so you'd get some weird
> > subset of the intended behaviour. Forcing *all* interfaces into the
> > sub-attribute when more than one is desired (or in fact for a single
> > one, if you're ok with requiring a kernel with support) would IMHO be
> > less error prone.
> 
> From a practical point of view cfg80211 should deny such a request due
> to multi-channel (interface combination) and by (the only CSA
> implementator in upstream) mac80211 due to chanctx->refcount > 1.

Hmm, true. I'd still prefer the other version, the stacked/nested one
kinda makes me uncomfortable ... It'll work, no doubt about it, but the
deep nesting I'm not really happy with.

johannes

