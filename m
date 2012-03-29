Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50169 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933379Ab2C2TPI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2012 15:15:08 -0400
Message-ID: <1333048488.3575.12.camel@jlt3.sipsolutions.net> (sfid-20120329_211512_298737_E80907F0)
Subject: Re: [PATCH 4/4] mac80211: notify driver of rate control updates
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 29 Mar 2012 21:14:48 +0200
In-Reply-To: <CAB3XZEcRej38SN_QKrUE0mF_Wd2MbfXUSPOHihC8EG2bsaxwkQ@mail.gmail.com> (sfid-20120329_211345_131703_477D0953)
References: <20120328085835.902687300@sipsolutions.net>
	 <20120328085901.436280820@sipsolutions.net>
	 <CAB3XZEcRej38SN_QKrUE0mF_Wd2MbfXUSPOHihC8EG2bsaxwkQ@mail.gmail.com>
	 (sfid-20120329_211345_131703_477D0953)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-03-29 at 21:13 +0200, Eliad Peller wrote:
> >  *
> > + * @sta_rc_update: Notifies the driver of changes to the bitrates that can be
> > + *     used to transmit to the station. The changes are advertised with bits
> > + *     from &enum ieee80211_rate_control_changed and the values are reflected
> > + *     in the station data. This callback should only be used when the driver
> > + *     uses hardware rate control (%IEEE80211_HW_HAS_RATE_CONTROL) since
> > + *     otherwise the rate control algorithm is notified directly.
> > + *     Must be atomic.
> > + *
> it's either atomic...
> 
> > +static inline void drv_sta_rc_update(struct ieee80211_local *local,
> > +                                    struct ieee80211_sub_if_data *sdata,
> > +                                    struct ieee80211_sta *sta, u32 changed)
> > +{
> > +       might_sleep();
> 
> or might sleep :)

Oh wow, it must be atomic since it's potentially in the RX path. I guess
the other path (the more common one) doesn't require atomic. Good catch,
thanks!

johannes

