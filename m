Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1980 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966718Ab0B0Ase (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2010 19:48:34 -0500
Date: Fri, 26 Feb 2010 19:48:10 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Andrew Blaich <ablaich@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Ath5k and Retransmissions (Retries)
Message-ID: <20100227004810.GB13107@hash.localnet>
References: <6b5e31691002250640k154a1f22xa46bac547c69b250@mail.gmail.com> <b6c5339f1002250951q7ad35de6g2a15f7c77e454b9a@mail.gmail.com> <6b5e31691002250959o576e203ena04858c8c9a76486@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6b5e31691002250959o576e203ena04858c8c9a76486@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 25, 2010 at 12:59:50PM -0500, Andrew Blaich wrote:
(top posting undone)
> The main file I focused on was net/mac80211/rc80211minstrel.c, but I
> have tried forcing retry values through the other portions of the
> code.
> 
> I have tried setting the counts in the MRR array (ar[i].count) in the
> minstrel_get_rate function, but that hasn't appeared to work,
> additionally I tried limiting the max retry count.  I have had luck in
> altering the rate used by changing the index value fed into ar[i].idx.
>  Maybe my issue is with the MRR array.

Well, this should work.  The ath5k side of this is ath5k_txbuf_setup:

      ret = ah->ah_setup_tx_desc(ah, ds, pktlen,
            ieee80211_get_hdrlen_from_skb(skb),
            get_hw_packet_type(skb),
            (sc->power_level * 2),
            hw_rate,
            info->control.rates[0].count, keyidx, ah->ah_tx_ant, flags,
            cts_rate, duration);

info->control.rates[0] is the TX rate (which may be different
for e.g. rts/cts frames than the one from the rate controller),
and the mrr rates are set up just after that:

       ah->ah_setup_mrr_tx_desc(ah, ds,
                mrr_rate[0], mrr_tries[0],
                mrr_rate[1], mrr_tries[1],
                mrr_rate[2], mrr_tries[2]);


The .count field in the mac80211 rate struct is the number of
tries, not retries, to be precise.

> next entry in the MRR array ar[1].idx=-1 so as to not try any rate,
> and then the count to 0 does this disable the rest of the MRR array,
> or is it possible the hardware is populating the array with other
> values?

That should be the case due to memset and get_alt_retry_rate semantics,
but if you suspect a problem you can printk in the above spots.

If the hardware doesn't respect those, there is some bug somewhere.

(Also see hw->max_rate_tries in ath5k_pci_probe()).

-- 
Bob Copeland %% www.bobcopeland.com

