Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41385 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698Ab3CQWHp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Mar 2013 18:07:45 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr12so4504075wgb.35
        for <linux-wireless@vger.kernel.org>; Sun, 17 Mar 2013 15:07:44 -0700 (PDT)
Date: Sun, 17 Mar 2013 23:07:37 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4] mac80211/minstrel_ht: add support for using CCK rates
Message-ID: <20130317220737.GB7031@gobelin> (sfid-20130317_230750_570776_7DBA2488)
References: <1360749068-3977-1-git-send-email-nbd@openwrt.org>
 <20130312094119.GA23062@magnum.frso.rivierawaves.com>
 <1363361818.8656.20.camel@jlt4.sipsolutions.net>
 <20130317212302.GA6886@gobelin>
 <514639B3.4050700@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <514639B3.4050700@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 17, 2013 at 10:46:27PM +0100, Felix Fietkau wrote:
> On 2013-03-17 10:23 PM, Karl Beldan wrote:
> > On Fri, Mar 15, 2013 at 04:36:58PM +0100, Johannes Berg wrote:
> >> On Tue, 2013-03-12 at 10:41 +0100, Karl Beldan wrote:
> >> > On Wed, Feb 13, 2013 at 10:51:08AM +0100, Felix Fietkau wrote:
> >> > > When MCS rates start to get bad in 2.4 GHz because of long range or
> >> > > strong interference, CCK rates can be a lot more robust.
> >> > > 
> >> > > This patch adds a pseudo MCS group containing CCK rates (long preamble
> >> > > in the lower 4 slots, short preamble in the upper slots).
> >> > > 
> >> > With this, mac80211 might send CCK rates with IEEE80211_TX_CTL_AMPDU set.
> >> > For aggregates, if we don't currently set NO_CCK, at the very least the
> >> > 1st rate index should belong to an MCS_GROUP.
> >> 
> >> I guess that depends on how you expect rate control to work ... I'd
> >> kinda expect the driver to skip aggregation then? I think only ath9k
> >> even uses minstrel + aggregation?
> >> 
> > 
> > This changes the meaning of IEEE80211_TX_CTL_AMPDU.
> > With this there are more possible RC feedback pitfalls with the tx statuses 
> > IEEE80211_TX_{CTL,STAT}_AMPDU flags.
> > Regarding the drivers using minstrel + aggregation I can't really say, I
> > know ath9k runs ok with it and at work I settled for minstrel too with a
> > driver for our IP on a demo board.
> It's important that the IEEE80211_TX_CTL_AMPDU flag is still set,
> because the frame is still part of the BlockAck window, just sent with a
> rate that doesn't allow aggregating it with other frames, so it is still
> part of the A-MPDU session.
The best way I could look at it was that it would let drivers know the frame is 
being transmitted under BA, but it still changes the meaning and thus
the handling of the flag. 
Frankly, if the meaning "officially" becomes "this frames is being 
transmitted under BA", as the code behaves, and you seem to say, I am all 
for it ;)
 
Karl
