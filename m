Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:17527 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750767AbYAWCAP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jan 2008 21:00:15 -0500
From: bruno randolf <bruno@thinktube.com>
To: ath5k-devel@lists.ath5k.org
Subject: Re: [ath5k-devel] [PATCH] mac80211: enable IBSS merging
Date: Wed, 23 Jan 2008 10:59:47 +0900
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Ivo van Doorn" <ivdoorn@gmail.com>, jirislaby@gmail.com,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Daniel Drake <dsd@gentoo.org>,
	Ulrich Kunitz <kune@deine-taler.de>,
	Johannes Berg <johannes@sipsolutions.net>
References: <20080118125252.6455.41047.stgit@one> <200801222054.23433.IvDoorn@gmail.com> <43e72e890801221232hee414a3ie28d060e823bf28b@mail.gmail.com>
In-Reply-To: <43e72e890801221232hee414a3ie28d060e823bf28b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801231059.48090.bruno@thinktube.com> (sfid-20080123_020021_838554_26D9D529)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 23 January 2008 05:32:05 Luis R. Rodriguez wrote:
> On Jan 22, 2008 2:54 PM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> > Hi,
> >
> > > > > > Then there is a problem for rt2x00. Since the mactime isn't
> > > > > > known. rt2400pci is the _only_ device which has a RX_END_TIME
> > > > > > field in the RX descriptor.
> > > > >
> > > > > one workaround could be to simply use the current TSF at the time
> > > > > in the tasklet or interrupt handler (to be more close to the actual
> > > > > rx time). this should be sufficient to catch most cases where an
> > > > > IBSS merge is necessary - usually the beacon's TSF will be much
> > > > > higher than the local TSF.
> > > >
> > > > Should the driver to this, or should mac80211 handle that?
> > >
> > > The driver should if it has access to some the mactime of the received
> > > packet otherwise yes -- I think mac80211 can handle this using the
> > > supplied get_tsf().
> > >
> > > > Personally I think it is something for the mac80211 layer since the
> > > > driver will give what it can, and can be sure that it is what
> > > > mac80211 expects instead of drivers interpreting what mac80211 might
> > > > want as replacement. If mac80211 needs the TSF value when no mac time
> > > > is given, it could just use the get_tsf() callback function to the
> > > > driver to get the substitute. When the get_tsf() callback is not
> > > > provided, then mac80211 can complain about missing information.

well we can do that, but the closer you record the TSF of a packet after 
reception, the better. this is why i suggested the interrupt handler or the 
drivers rx tasklet. i don't know enough about when mac80211 rx handlers will 
run, but it seems they could be delayed quite a bit (work queue?).
especially for IBSS merges we need to basically compare the TSF of the beaon 
and the local TSF on a usec level. for most cases i guess getting the TSF in 
ieee80211_rx_bss_info() should be sufficient, but it will not merge 100% 
correctly if the time difference between IBSS nodes is small.

> I still think we should inform the user if the user switches to IBSS
> at some point, perhaps better during interface addition if their
> driver's IBSS mode is going to have some issues. How about we add to
> the enum ieee80211_hw_flags a "IEEE80211_HW_RX_MACTIME". Then we can
> warn accordingly during ieee80211_if_add() if the interface type is
> IBSS"
>
> * If driver supports IEEE80211_HW_RX_MACTIME we don't warn anything
> * If IEEE80211_HW_RX_MACTIME is not supported and get_tsf() is
> implemented inform user IBSS merge may not behave accurately
> * If IEEE80211_HW_RX_MACTIME is not supported and get_tsf() is not
> implemented warn IBSS merge will not work

jep, i think that would be best. can we add that in a separate patch?

> We could add:
>
> static inline u64 __approx_mactime(struct ieee80211_local *local) {
>    BUG_ON(!local || !local->ops);
>    return (local->ops->get_tsf) ?
> local->ops->get_tsf(local_to_hw(local)) : -1LLU;
> }
>
> Then in ieee80211_rx_bss_info() we can do something like:
>
> +               if (local->hw.flags & IEEE80211_HW_RX_MACTIME) {
> +                   if (rx_status->flag & RX_FLAG_TSFT)
> +                       mactime = rx_status->mactime;
> +                   else {
> +                     WARN_ON(1);
> +                     mactime = __approx_mactime(local);
> +                  }
> +              else {
> +                     mactime = __approx_mactime(local);
> +         }

i'd prefer to do it without the inline just all in the function. like this:

+               if (rx_status->flag & RX_FLAG_TSFT)
+                       /* in order for correct IBSS merging we need mactime*/
+                       mactime = rx_status->mactime;
+               else if (local && local->ops && local->ops->get_tsf)
+                       /* second best option: get current TSF */
+                       mactime = local->ops->get_tsf(local_to_hw(local));
+               else
+                       /* can't merge without knowing the TSF */
+                       mactime = -1LLU;

comments? should i resend my patch?

bruno
