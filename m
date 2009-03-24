Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:54381 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756116AbZCXTlh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 15:41:37 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2009 12:41:36 -0700
Date: Tue, 24 Mar 2009 11:41:00 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Bob Copeland <me@bobcopeland.com>
CC: Christian Lamparter <chunkeey@web.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [RFC] ath9k's regulatory domain code changes (for ar9170)
Message-ID: <20090324184100.GA29268@tesla> (sfid-20090324_204141_867120_90A898B2)
References: <200903241938.47155.chunkeey@web.de> <b6c5339f0903241159x505fc88ap4d9850fa74733156@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <b6c5339f0903241159x505fc88ap4d9850fa74733156@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 24, 2009 at 11:59:37AM -0700, Bob Copeland wrote:
> On Tue, Mar 24, 2009 at 2:38 PM, Christian Lamparter <chunkeey@web.de> wrote:
> > Hi Luis,
> >
> > This is more or less what I need from ath9k's regulatory domain code.
> > What's your opinion? Would you accept the changes, or do you see
> > a potential conflict/problem with the design?
> 
> FWIW I had done a small bit of rework for sharing with ath5k, and
> Luis has those patches now in somewhat better shape.  The last
> patch set I made is here:
> 
> http://bobcopeland.com/kernel/wl/20090309/

I rebased these on top of the latest wl, and slightly modified them
to apply cleanly with checkpatch and I think I had a few very minor changes.
You can find the latest here:

http://bombadil.infradead.org/~mcgrof/patches/ath5k/ath5k-reg.patch.txt

I thought I was going to be able to work on this last week but that wasn't the
case and it seems I won't get to it this week either. Do any of you guys have
time to pick it up? Only change I'd recommend is to first make ath5k use a
small set of channels as ath9k and ar9170 has, then you can actually debug
regulatory stuff using iw by calling 'iw list' and checking the channel info.
I was going to start with that but saw its a little pain. Essentially the way
I'd do it is to modify ath5k_setup_bands() to remove the channel hw specific
settings and move that stuff to a routine which can be called dynamically upon
channel change (IEEE80211_CONF_CHANGE_CHANNEL) through the mac80211 config
callback. In ath9k we do this with the ath9k_update_ichannel(). The idea
was to eventually condense that down to a ath9k_update_ht_mode() as I think
that's all that would be required. But do do that we'd need to slowly completley
remove ath9k_channel. That's a bit of a challenge, provided you want to make
sure everything else works. But anyway that should give you an idea of where
I was heading if you want to try something similar for ath5k.

Technically speaking it'd be even nice to not have to compute this upon channel
change so that way we save time during a channel change, but that again is a nice
challenge. For example it'd be hot of we wouldn't have to compute the hw value for
the frequency on ath9k every single time as its a static value.

Anyway that's my feedback.

  Luis
