Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42437 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbaA2NQF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 08:16:05 -0500
Message-ID: <1391001359.4143.18.camel@jlt4.sipsolutions.net> (sfid-20140129_141609_221811_234D4E71)
Subject: Re: [PATCH v3 2/2] cfg80211: regulatory introduce maximum bandwidth
 calculation
From: Johannes Berg <johannes@sipsolutions.net>
To: Jonas Gorski <jogo@openwrt.org>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	mcgrof@do-not-panic.com
Date: Wed, 29 Jan 2014 14:15:59 +0100
In-Reply-To: <CAOiHx=nXngrZMyV4S7mg36+CV5xpDUr=025JrBi6be49YEPVWA@mail.gmail.com>
References: <1390645452-2495-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1390645452-2495-2-git-send-email-janusz.dziedzic@tieto.com>
	 <CAOiHx=nXngrZMyV4S7mg36+CV5xpDUr=025JrBi6be49YEPVWA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[please trim quotes]

> > @@ -671,8 +728,16 @@ static int reg_rules_intersect(const struct ieee80211_reg_rule *rule1,
> >                                          freq_range2->start_freq_khz);
> >         freq_range->end_freq_khz = min(freq_range1->end_freq_khz,
> >                                        freq_range2->end_freq_khz);
> > -       freq_range->max_bandwidth_khz = min(freq_range1->max_bandwidth_khz,
> > -                                           freq_range2->max_bandwidth_khz);
> > +
> > +       max_bandwidth1 = freq_range1->max_bandwidth_khz;
> > +       if (!max_bandwidth1)
> > +               max_bandwidth1 = reg_get_max_bandwidth(rd1, rule1);
> > +
> > +       max_bandwidth2 = freq_range1->max_bandwidth_khz;
> 
> I guess you want to use freq_range2 here ...

That does seem likely :)

> > +       if (!max_bandwidth1)
> 
> and check max_bandwidth2 here.
> 
> > +               max_bandwidth2 = reg_get_max_bandwidth(rd2, rule2);
> > +
> > +       freq_range->max_bandwidth_khz = min(max_bandwidth1, max_bandwidth2);

I'm not sure if you shouldn't do the reg_get_max_bandwidth() on the
result though rather than on the input domains? But I haven't thought
hard about it.

joahnnes

