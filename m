Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37666 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaDHJnK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 05:43:10 -0400
Message-ID: <1396950187.5936.8.camel@jlt4.sipsolutions.net> (sfid-20140408_114315_598856_ECAAC7A1)
Subject: Re: [PATCH] mac80211: fix radar_enabled propagation
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 08 Apr 2014 11:43:07 +0200
In-Reply-To: <CA+BoTQ=H-zYoK5q4j8rKFU-XVXx=ydwjYiWh8ZoFGOCr9LyrVQ@mail.gmail.com> (sfid-20140408_112418_702268_0366F126)
References: <1396609363-24539-1-git-send-email-michal.kazior@tieto.com>
	 <1396946168.5936.0.camel@jlt4.sipsolutions.net>
	 <CA+BoTQ=H-zYoK5q4j8rKFU-XVXx=ydwjYiWh8ZoFGOCr9LyrVQ@mail.gmail.com>
	 (sfid-20140408_112418_702268_0366F126)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Tue, 2014-04-08 at 11:24 +0200, Michal Kazior wrote:
> On 8 April 2014 10:36, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Fri, 2014-04-04 at 13:02 +0200, Michal Kazior wrote:
> >> If chandef had non-HT width it was possible for
> >> radar_enabled update to not be propagated properly
> >> through drv_config(). This happened because
> >> ieee80211_hw_conf_chan() would never see different
> >> local->hw.conf.chandef and local->_oper_chandef.
> >>
> >> This wasn't a problem with HT chandefs because
> >> _oper_chandef width is reset to non-HT in
> >> ieee80211_free_chanctx() making
> >> ieee80211_hw_conf_chan() to kick in.
> >>
> >> This problem led (at least) ath10k to not start
> >> CAC if prior CAC was cancelled and both CACs were
> >> requested for identical non-HT chandefs.
> >>
> >> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> >> ---
> >>  net/mac80211/chan.c | 4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
> >> index 122033d..b472daa 100644
> >> --- a/net/mac80211/chan.c
> >> +++ b/net/mac80211/chan.c
> >> @@ -269,7 +269,7 @@ ieee80211_new_chanctx(struct ieee80211_local *local,
> >>
> >>       if (!local->use_chanctx) {
> >>               local->_oper_chandef = *chandef;
> >> -             ieee80211_hw_config(local, 0);
> >> +             ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
> >
> > I'm not convinced that this is the right way to do this - couldn't
> > ieee80211_hw_conf_chan() detect the radar detection requirement change?
> 
> I agree but on the other hand propagating local->mtx locking
> requirement for using local->radar_detect_enabled in
> ieee80211_hw_conf_chan() (and thus ieee80211_hw_config()) is probably
> going to be a cascade of pain.

Hmm, ok. I guess I don't care all that much, I don't use this code path
any more ;-)

johannes



