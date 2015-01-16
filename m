Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41473 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbbAPLrr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 06:47:47 -0500
Message-ID: <1421408863.9214.7.camel@sipsolutions.net> (sfid-20150116_124753_185182_1A4D77DA)
Subject: Re: [RFCv2 1/6] mac80211: ibss, fix chandef setup for HT40
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 16 Jan 2015 12:47:43 +0100
In-Reply-To: <CALhHN=payu27bPU+G5txsFkm6N=w_FL+LA8dVZAO96bwXXqiAg@mail.gmail.com> (sfid-20150116_122423_433250_51B24379)
References: <1421404724-32326-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1421405364.9214.1.camel@sipsolutions.net>
	 <CALhHN=payu27bPU+G5txsFkm6N=w_FL+LA8dVZAO96bwXXqiAg@mail.gmail.com>
	 (sfid-20150116_122423_433250_51B24379)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-01-16 at 12:24 +0100, Janusz Dziedzic wrote:
> On 16 January 2015 at 11:49, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Fri, 2015-01-16 at 11:38 +0100, Janusz Dziedzic wrote:
> >> In some cases when used HT40+/HT40-, center_freq1
> >> was configured incorrectly. Next this couse
> >
> > couse?
> >
> >> @@ -407,10 +407,15 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
> >>       switch (sdata->u.ibss.chandef.width) {
> >>       case NL80211_CHAN_WIDTH_20_NOHT:
> >>       case NL80211_CHAN_WIDTH_20:
> >> -     case NL80211_CHAN_WIDTH_40:
> >>               chan_type = cfg80211_get_chandef_type(&sdata->u.ibss.chandef);
> >>               cfg80211_chandef_create(&chandef, cbss->channel, chan_type);
> >>               break;
> >
> > Sorry, I don't see the bug. "Sometimes"?
> >
> > cfg80211_get_chandef_type() will return HT40+/- correctly according to
> > the chandef, and then you'll use it again to create the chandef - should be OK.
> >
> >> +       case NL80211_CHAN_WIDTH_40:
> >> +               cfg80211_chandef_create(&chandef, cbss->channel,
> >> +                                       NL80211_CHAN_WIDTH_20_NOHT);
> >> +               chandef.width = sdata->u.ibss.chandef.width;
> >> +               chandef.center_freq1 =
> >> sdata->u.ibss.chandef.center_freq1;
> >> +               break;
> >
> > Please don't mix chantype stuff and chandef stuff ... just create the
> > chandef manually if you must. I really think the code above should have
> > worked though, unless it's using the wrong inputs somehow.
> >
> This is scenario:
> 
> 1) first ibss HT20 run on 5180
> 2) second ibss configured HT40+ using 36 channel
> 3) supplicant detect OBSS and decide to switch 40 and HT40-
> 4) this code confgure chandef->center_freq1 = 5170
> 5) reg_can_beacon() then fail and we fall back to NOHT_20

Sounds more like we store and use invalid data?

johannes

