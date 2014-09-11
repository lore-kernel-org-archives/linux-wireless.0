Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:59520 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751300AbaIKKtd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 06:49:33 -0400
Message-ID: <1410432565.23822.11.camel@dubbel> (sfid-20140911_124936_358088_A44B7821)
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Berg, Johannes" <johannes@sipsolutions.net>
Date: Thu, 11 Sep 2014 13:49:25 +0300
In-Reply-To: <CA+BoTQ=dqQz1epo=-odvVQjOx0K-yLNtivufE5BKBK9+QV2wGQ@mail.gmail.com>
References: <1410418181.14130.7.camel@dubbel>
	 <CA+BoTQ=dqQz1epo=-odvVQjOx0K-yLNtivufE5BKBK9+QV2wGQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: CSA broken with !use_chanctx drivers?
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-09-11 at 11:28 +0200, Michal Kazior wrote:
> On 11 September 2014 08:49, Luca Coelho <luca@coelho.fi> wrote:
> > Hi Michal,
> >
> > Johannes and I were checking the channel switch code (namely to see if
> > implementing the drv_channel_switch op was fine in our case) and we saw
> > that CSA with non-chanctx drivers seems to be broken.
> >
> > In commit 4c3ebc56 (mac80211: use chanctx reservation for STA CSA) we
> > lost this piece of code:
> >
> > diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> > index eccc849..931330b 100644
> > --- a/net/mac80211/mlme.c
> > +++ b/net/mac80211/mlme.c
> > @@ -940,52 +940,70 @@ static void ieee80211_chswitch_work(struct work_struct *work)
> > [...]
> > -       if (!local->use_chanctx) {
> > -               local->_oper_chandef = sdata->csa_chandef;
> > -               /* Call "hw_config" only if doing sw channel switch.
> > -                * Otherwise update the channel directly
> > -                */
> > -               if (!local->ops->channel_switch)
> > -                       ieee80211_hw_config(local, 0);
> > -               else
> > -                       local->hw.conf.chandef = local->_oper_chandef;
> > -       }
> > -
> >
> > It seems that we're not updating the chandef in non-chanctx drivers.  Or
> > are we missing something?
> 
> Hmm.. ieee80211_hw_config() is called in
> ieee80211_chsw_switch_hwconf() now. The special treatment of
> drv_channel_switch() drivers is gone though - can that be a big
> problem?

Ah, I see now.  The only difference is that now you do both things (i.e.
call hw_config() and set hw.conf.chandef) regardless of whether
drv_channel_switch() is implemented.


> From what I've tested just now it seems iwldvm (3.17-rc2, fw
> 18.168.6.1) calls ieee80211_chswitch_done() almost immediately most of
> the time. This obviously ends up with beacon loss with larger CS
> count. With small CS count it works though. This doesn't seem to be
> related to the missing hw_confg().

The hw_config() call is not really missing, right? We're actually now
calling it even for drivers that implement drv_channel_switch()
(previously we wouldn't).

I don't know why iwldvm is finalizing the channel switch almost
immediately... It doesn't make much sense, because all the traffic until
the switch will be lost.  Unless the CSA is marked as "quiet", because
then nobody should be transmitting and it doesn't really matter when you
switched.

Anyway, I don't think the problem is that we call hw_config() now,
because that is done *after* chswitch_done() is called.


> Now that I think it's probably a good idea to make multi-vif CSA
> mutually exlusive with drv_channel_switch() based STA CSA..

In the iwlmvm driver, we have to do the actual context switch when we
decide to, not exactly at TBTT count=0 as mac80211 does with "software
channel switch".  The way I solved this (will be upstreamed soon, I
believe) is that I implement a dummy drv_channel_switch().  I only do
this to prevent mac80211 from starting its own timer, allowing me to
call ieee80211_chswitch_done() when I need to.

--
Luca.

