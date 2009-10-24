Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:34880 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545AbZJXPcj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Oct 2009 11:32:39 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: ath5k: no further txbuf available, dropping packet
Date: Sat, 24 Oct 2009 17:32:38 +0200
Cc: Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
References: <200910231608.18676.mb@bu3sch.de> <20091024131929.GB31897@hash.localnet> <200910241705.39104.mb@bu3sch.de>
In-Reply-To: <200910241705.39104.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200910241732.40651.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 24 October 2009 17:05:37 Michael Buesch wrote:
> On Saturday 24 October 2009 15:19:29 Bob Copeland wrote:
> > On Fri, Oct 23, 2009 at 04:08:16PM +0200, Michael Buesch wrote:
> > > ath5k breaks in AP mode after some operation time and keeps throwing
> > > this message:
> > > 
> > > [2096249.446071] ath5k phy0: no further txbuf available, dropping packet
> > > 
> > > Driver is yesterday's compat-wireless on 2.6.31.1
> > 
> > Ok looked a bit more at this.  I don't see a leak, but I think the
> > txbufs aren't getting reaped.  Otherwise, we should reenable the queues
> > when we get back 40 TX completion interrupts.
> > 
> > I'm a bit short on time to track it down, but one thing to try is
> > commenting out the following from ath5k_beacon_send (will break buffering
> > but you can test non-ps clients):
> > 
> >         skb = ieee80211_get_buffered_bc(sc->hw, sc->vif);
> >         while (skb) {
> >                 ath5k_tx_queue(sc->hw, skb, sc->cabq);
> >                 skb = ieee80211_get_buffered_bc(sc->hw, sc->vif);
> >         }
> > 
> 
> I didn't try this, yet, but PS buffering seems to be broken anyway.
> If I connect the n810 (which does PS) to the ath5k AP, I cannot ping
> the n810 unless I also transfer (ping) _from_ the n810 simultaneously.
> I did not monitor the traffic, yet, but to me it seems the AP is unable
> to notify that the PS device should wake up (TIM problems?). By pinging from
> the n810, I frequently force-wakeup the device, so traffic to the device
> also works (more or less).
> 

Ok on the monitor log it looks like the ath5k AP simply sends data while
the STA is in PS, instead of buffering it and updating the TIM.
So if I ping the STA, it keeps sending packets and doesn't set the TIM,
but don't get any repsonse of course, because the STA is power saving.
If I simultaneously ping from the STA, the buffering and TIM handling suddenly
seems to start working. The AP indicates traffic via TIM and the STA sends PS polls.

-- 
Greetings, Michael.
