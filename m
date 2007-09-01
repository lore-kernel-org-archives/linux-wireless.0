Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:43357 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752030AbXIAJAQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 05:00:16 -0400
Message-ID: <46D92A1C.4050308@warmcat.com>
Date: Sat, 01 Sep 2007 10:00:12 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: radiotap injection bugs & extending it
References: <1188609135.7585.105.camel@johannes.berg>
In-Reply-To: <1188609135.7585.105.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:

> struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
> [...]
> tx->sta = sta_info_get(local, hdr->addr1);
> [...]
> __ieee80211_parse_tx_radiotap(..)
> 
> which seems a bit weird. Shouldn't we grab the sta only after removing
> the radiotap stuff? :)

Yes it's wrong, hdr is also dereferenced once more while the radiotap
header is still in place.  I made a little patch I will send in a
moment, if you already did it then ignore the patch.

> Also, after doing more work on mac80211 I now again have hostapd running
> via monitor interfaces. However, there's a bit of a problem there.

You are definitely on fire at the moment Johannes.

> After a few changes to mac80211, I have these TX handlers:
>         ieee80211_tx_h_check_assoc,
>         ieee80211_tx_h_sequence,
>         ieee80211_tx_h_ps_buf,
>         ieee80211_tx_h_select_key,
>         ieee80211_tx_h_michael_mic_add,
>         ieee80211_tx_h_fragment,
>         ieee80211_tx_h_encrypt,
>         ieee80211_tx_h_rate_ctrl,
>         ieee80211_tx_h_misc,
>         ieee80211_tx_h_load_stats,
> 
> Of these, check_assoc should be skipped unconditionally for injected
> packets. sequence should be done, ps_buf I'm not sure about though I
> suppose that if the STA really goes into powersave very quickly then
> hostapd would need ps_buf.
> 
> Then we have select_key (and mic adding/encrypt depends on it) which
> should IMHO depend on IEEE80211_RADIOTAP_F_WEP; fragment could depend on
> IEEE80211_RADIOTAP_F_FRAG. rate_ctrl should depend on the presence of
> the IEEE80211_RADIOTAP_RATE field, if it was present then rate_ctrl is
> skipped. This addresses this TODO item:
>            * TODO: auto-select when the rate field is not present!
> 
> misc does a few things:
> retry should be taken from IEEE80211_RADIOTAP_DATA_RETRIES if present or
> otherwise automatically assigned, cts/rts should be taken from the
> radiotap TX flags IEEE80211_RADIOTAP_F_TX_CTS and
> IEEE80211_RADIOTAP_F_TX_RTS or automatically determined.

Sounds great to me.  I guess you are up for doing this?

> This is basically it, except for short preamble setting. That is a bit
> of a problem, however, because it's not a tristate in radiotap and we
> want a tristate (long/short/automatic). Ideas on this item?

No idea about it here.

-Andy
