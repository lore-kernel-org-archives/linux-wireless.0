Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33643 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755323AbaFDG7d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 02:59:33 -0400
Message-ID: <1401865158.6079.2.camel@jlt4.sipsolutions.net> (sfid-20140604_085936_171499_D5E40ADF)
Subject: Re: [PATCH 3.14] mac80211: fix AP powersave TX vs. wakeup race
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	mhocko@suse.com
Date: Wed, 04 Jun 2014 08:59:18 +0200
In-Reply-To: <CAB=NE6W=FubasHV6QsAO8Jrdhbh_xM1SmYqCScvRf8g0FY4GHw@mail.gmail.com> (sfid-20140604_040613_250958_CB2BCE5C)
References: <1392886365-31206-1-git-send-email-johannes@sipsolutions.net>
	 <CAB=NE6W=FubasHV6QsAO8Jrdhbh_xM1SmYqCScvRf8g0FY4GHw@mail.gmail.com>
	 (sfid-20140604_040613_250958_CB2BCE5C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-06-03 at 19:05 -0700, Luis R. Rodriguez wrote:

> > +++ b/net/mac80211/tx.c
> > @@ -478,6 +478,19 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
> >                        sta->sta.addr, sta->sta.aid, ac);
> >                 if (tx->local->total_ps_buffered >= TOTAL_MAX_TX_BUFFER)
> >                         purge_old_ps_buffers(tx->local);
> > +
> > +               /* sync with ieee80211_sta_ps_deliver_wakeup */
> > +               spin_lock(&sta->ps_lock);
> > +               /*
> > +                * STA woke up the meantime and all the frames on ps_tx_buf have
> > +                * been queued to pending queue. No reordering can happen, go
> > +                * ahead and Tx the packet.
> > +                */
> > +               if (!test_sta_flag(sta, WLAN_STA_PS_STA)) {
> > +                       spin_unlock(&sta->ps_lock);
> > +                       return TX_CONTINUE;
> > +               }
> > +
> >                 if (skb_queue_len(&sta->ps_tx_buf[ac]) >= STA_MAX_TX_BUFFER) {
> >                         struct sk_buff *old = skb_dequeue(&sta->ps_tx_buf[ac]);
> >                         ps_dbg(tx->sdata,
> 
> This fixes the race for the case where the API introduced via commit
> af81858172cc but that code also *moved* code, the API added simply
> added a new way to let driver to hit a trigger to send buffered
> frames, are we sure that through mechanisms that don't use this API
> this race doesn't exist? That is can we not race between
> ieee80211_rx_h_sta_process() and ieee80211_tx_h_unicast_ps_buf()?

Err, I have no idea what you're trying to say.

Did you mean sta_ps_end() vs. ieee80211_tx_h_unicast_ps_buf()? Those can
*race*, but any outcome will be valid, afaict, given the station flag
tricks. It all goes back to the same (locked) code for manipulating the
queues.

I recently fixed a bug where mac80211 would get into a confused state
and not buffer packets when it would really be required, but that's just
a bug that can be observed over the air, it has no bad consequences
except for that station losing traffic.

johannes

