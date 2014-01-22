Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41806 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbaAVSv5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 13:51:57 -0500
Message-ID: <1390416713.4334.46.camel@jlt4.sipsolutions.net> (sfid-20140122_195201_153333_6E92E552)
Subject: Re: [PATCH] mac80211: send {add,del}ba on AC_VO like other mgmt
 frames, as per spec
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Wed, 22 Jan 2014 19:51:53 +0100
In-Reply-To: <20140122164122.GC18365@magnum.frso.rivierawaves.com> (sfid-20140122_174223_742162_FF2E246A)
References: <1390391564-18481-1-git-send-email-karl.beldan@gmail.com>
	 <1390394079.4334.30.camel@jlt4.sipsolutions.net>
	 <20140122130924.GA18365@magnum.frso.rivierawaves.com>
	 <CAGXE3d_V2vST4nkFLUeXgTwbzB_GfPYM3HzBC1QjLuG_=LP2Kw@mail.gmail.com>
	 <20140122152845.GB18365@magnum.frso.rivierawaves.com>
	 <CAGXE3d8_qukp_gb4P0PnJkQJT8MtsypYgzPojE+RqpzEK_R62Q@mail.gmail.com>
	 <20140122164122.GC18365@magnum.frso.rivierawaves.com>
	 (sfid-20140122_174223_742162_FF2E246A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-22 at 17:41 +0100, Karl Beldan wrote:

> > >> If a DELBA is sent as AC_VO it might get received before the last AMPDU
> > >> of the BlockAck session. So, the pending AMPDUs will get dropped at the
> > >> receiver.
> > >>
> > >> In theory this could also be avoided by properly flushing all pending AMPDUs
> > >> of the TID in question from the hw queues or by waiting for the tx status
> > >> of all pending AMPDUs.

Let's get the issue straight first.

The (current) documentation for the TX_STOP ampdu actions says:

 * @IEEE80211_AMPDU_TX_STOP_CONT: stop TX aggregation but continue
transmitting
 *      queued packets, now unaggregated. After all packets are
transmitted the
 *      driver has to call ieee80211_stop_tx_ba_cb_irqsafe().
 * @IEEE80211_AMPDU_TX_STOP_FLUSH: stop TX aggregation and flush all
packets,
 *      called when the station is removed. There's no need or reason to
call
 *      ieee80211_stop_tx_ba_cb_irqsafe() in this case as mac80211
assumes the
 *      session is gone and removes the station.
 * @IEEE80211_AMPDU_TX_STOP_FLUSH_CONT: called when TX aggregation is
stopped
 *      but the driver hasn't called ieee80211_stop_tx_ba_cb_irqsafe()
yet and
 *      now the connection is dropped and the station will be removed.
Drivers
 *      should clean up and drop remaining packets when this is called.

I say "current" because we only completed this fairly recently (couple
months ago?) to make it complete with the three different possibilities.

Therefore, I don't think there's a need to ever *flush* the queues,
although the term "flush" is getting confusing and we should probably
call this IEEE80211_AMPDU_TX_STOP_DROP instead of _FLUSH, as that's what
it really means, drop all the remaining frames (if any.)

Given the fact that we only send the frame from
ieee80211_stop_tx_ba_cb() I don't see any problem. Even if we were to
send the frame directly after calling the ampdu_action, it seems it
would be fine, since the callback (now) requires sending the remaining
frames unaggregated. (Given that, I'm not even sure why we required the
packets to be sent unaggregated, Emmanuel, do you remember?)

> Callers of ieee80211_stop_tx_ba_cb_irqsafe are:
> ath9k
> ath9k_htc
> carl9170
> wcn36xx
> brcm80211
> iwlegacy
> iwlwifi
> mwl8k
> rt2x00
> rtlwifi
> 
> Johannes, what is your impression ?

I'm pretty sure iwlwifi should be safe. ath9k/htc/carl9170/wcn36xx are
probably fine, I can't really say anything about the other ones. I'd
guess brcm80211 should be OK since it builds aggregates in software and
should be able to easily stop transmitting aggregates. But see above - I
don't see how even if the driver didn't stop sending aggregates it could
be wrong. Unless the driver called ieee80211_stop_tx_ba_cb() immediately
but didn't actually stop sending. That's pretty much a bug anyway
though.

johannes

