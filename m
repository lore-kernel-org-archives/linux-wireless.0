Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:57269 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbYAVUcH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jan 2008 15:32:07 -0500
Received: by py-out-1112.google.com with SMTP id u52so3761221pyb.10
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jan 2008 12:32:06 -0800 (PST)
Message-ID: <43e72e890801221232hee414a3ie28d060e823bf28b@mail.gmail.com> (sfid-20080122_203213_632340_7C117E64)
Date: Tue, 22 Jan 2008 15:32:05 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: [PATCH] mac80211: enable IBSS merging
Cc: "bruno randolf" <bruno@thinktube.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Michael Wu" <flamingice@sourmilk.net>,
	ath5k-devel@lists.ath5k.org, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, "Ulrich Kunitz" <kune@deine-taler.de>,
	"Daniel Drake" <dsd@gentoo.org>
In-Reply-To: <200801222054.23433.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080118125252.6455.41047.stgit@one>
	 <200801211705.24221.IvDoorn@gmail.com>
	 <43e72e890801221147uedf8002oc21840bdd80a157c@mail.gmail.com>
	 <200801222054.23433.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 22, 2008 2:54 PM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
>
> Hi,
>
> > > > > Then there is a problem for rt2x00. Since the mactime isn't known.
> > > > > rt2400pci is the _only_ device which has a RX_END_TIME field in the
> > > > > RX descriptor.
> > > >
> > > > one workaround could be to simply use the current TSF at the time in the
> > > > tasklet or interrupt handler (to be more close to the actual rx time). this
> > > > should be sufficient to catch most cases where an IBSS merge is necessary -
> > > > usually the beacon's TSF will be much higher than the local TSF.
> > >
> > > Should the driver to this, or should mac80211 handle that?
> >
> > The driver should if it has access to some the mactime of the received
> > packet otherwise yes -- I think mac80211 can handle this using the
> > supplied get_tsf().
> >
> > > Personally I think it is something for the mac80211 layer since the driver will
> > > give what it can, and can be sure that it is what mac80211 expects instead of
> > > drivers interpreting what mac80211 might want as replacement.
> > > If mac80211 needs the TSF value when no mac time is given, it could just
> > > use the get_tsf() callback function to the driver to get the substitute. When the
> > > get_tsf() callback is not provided, then mac80211 can complain about missing
> > > information.
> >
> > Agreed, how about something like this modified to Bruno's patch:
> >
> > +               if (rx_status->flag & RX_FLAG_TSFT)
> > +                       mactime = rx_status->mactime;
> > +               else {
> > +                       if (!local->ops->get_tsf) {
> > +                          WARN_ON(1);
> > +                          mactime = -1LLU;
> > +                          if (net_ratelimit())
> > +                             printk(KERN_WARNING "%s: cannot determine if "
> > +                                   "IBSS merge is required", dev->name);
> > +                      }
> > +                      else {
> > +                           if (net_ratelimit())
> > +                             printk("Could not get detailed timestamp
> > of beacon "
> > +                                          during reception, using the
> > driver's TSF timer for mactime\n")
> > +                           mactime = local->ops->get_tsf(local_to_hw(local));
> > +                   }
> > +               }
> >
> > We could just not support IBSS for driver's without a get_tsf(). Thoughts?
>
> I am not sure if we should print error warning messages when the mactime is
> not provided. But other then that I agree with the above change, as it would
> allow rt2x00 to use the IBSS syncing. :)

Ah yes, ignore my printks and instead replace them with better comments :)

I still think we should inform the user if the user switches to IBSS
at some point, perhaps better during interface addition if their
driver's IBSS mode is going to have some issues. How about we add to
the enum ieee80211_hw_flags a "IEEE80211_HW_RX_MACTIME". Then we can
warn accordingly during ieee80211_if_add() if the interface type is
IBSS"

* If driver supports IEEE80211_HW_RX_MACTIME we don't warn anything
* If IEEE80211_HW_RX_MACTIME is not supported and get_tsf() is
implemented inform user IBSS merge may not behave accurately
* If IEEE80211_HW_RX_MACTIME is not supported and get_tsf() is not
implemented warn IBSS merge will not work

We could add:

static inline u64 __approx_mactime(struct ieee80211_local *local) {
   BUG_ON(!local || !local->ops);
   return (local->ops->get_tsf) ?
local->ops->get_tsf(local_to_hw(local)) : -1LLU;
}

Then in ieee80211_rx_bss_info() we can do something like:

+               if (local->hw.flags & IEEE80211_HW_RX_MACTIME) {
+                   if (rx_status->flag & RX_FLAG_TSFT)
+                       mactime = rx_status->mactime;
+                   else {
+                     WARN_ON(1);
+                     mactime = __approx_mactime(local);
+                  }
+              else {
+                     mactime = __approx_mactime(local);
+         }

  Luis
