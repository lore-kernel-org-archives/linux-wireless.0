Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33654 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754659AbaFDHDf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 03:03:35 -0400
Message-ID: <1401865406.6079.5.camel@jlt4.sipsolutions.net> (sfid-20140604_090337_954817_A513C05F)
Subject: Re: [PATCH] mac80211: allow tx via monitor iface when DFS
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 04 Jun 2014 09:03:26 +0200
In-Reply-To: <CALhHN=qXjGa09JNox5qOvjR6RDv_=N-465cV-LmgU-NCCyA53w@mail.gmail.com> (sfid-20140604_071327_912548_8FB96E1A)
References: <1401443081-10277-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1401825537.4157.43.camel@jlt4.sipsolutions.net>
	 <CALhHN=qXjGa09JNox5qOvjR6RDv_=N-465cV-LmgU-NCCyA53w@mail.gmail.com>
	 (sfid-20140604_071327_912548_8FB96E1A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-06-04 at 07:13 +0200, Janusz Dziedzic wrote:
> On 3 June 2014 21:58, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Fri, 2014-05-30 at 11:44 +0200, Janusz Dziedzic wrote:
> >
> >> +     struct cfg80211_chan_def chandef;
> >>       u16 len_rthdr;
> >>       int hdrlen;
> >>
> >> @@ -1721,9 +1721,9 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
> >>       }
> >>
> >>       if (chanctx_conf)
> >> -             chan = chanctx_conf->def.chan;
> >> +             chandef = chanctx_conf->def;
> >>       else if (!local->use_chanctx)
> >> -             chan = local->_oper_chandef.chan;
> >> +             chandef = local->_oper_chandef;
> >
> > Why are you making a copy of the chandef - wouldn't a pointer work just
> > as well?
> >
> No special reason (chandef is quite small), should I change this to
> pointer and send v2?

Yeah, I agree that it's pretty small, it just seemed odd, like you
wanted to locally modify it or something. I'd prefer a pointer here.

johannes

