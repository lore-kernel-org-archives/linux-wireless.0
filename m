Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f173.google.com ([209.85.221.173]:50991 "EHLO
	mail-qy0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbZFIA07 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2009 20:26:59 -0400
Received: by qyk3 with SMTP id 3so237557qyk.33
        for <linux-wireless@vger.kernel.org>; Mon, 08 Jun 2009 17:27:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <44EE5C37ADC36343B0625A05DD408C485068DEBF69@CHEXMB-01.global.atheros.com>
References: <1244180502-4323-1-git-send-email-lrodriguez@atheros.com>
	<1244180502-4323-2-git-send-email-lrodriguez@atheros.com>
	<20090605063059.GF17632@vasanth-laptop> <43e72e890906050047w71f8e691g479797a54f5fb9a0@mail.gmail.com>
	<20090605075252.GG17632@vasanth-laptop> <20090605182944.GD30211@tesla>
	<44EE5C37ADC36343B0625A05DD408C485068DEBF69@CHEXMB-01.global.atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 8 Jun 2009 17:26:41 -0700
Message-ID: <43e72e890906081726m764f891mc0a46a46b5bc3ac9@mail.gmail.com>
Subject: Re: [PATCH 01/15] ath9k: fix oops by downgrading assert in rc.c
To: Vasanth Thiagarajan <Vasanth.Thiagarajan@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 5, 2009 at 11:55 PM, Vasanth
Thiagarajan<Vasanth.Thiagarajan@atheros.com> wrote:
>
> ________________________________________
>
>> > >> +       /*
>> > >> +        * Fine tuning for when no decent rate was found, the
>> > >> +        * lowest should *not* be used under normal circumstances.
>> > >> +        */
>> > >> +       if (rix == ath_rc_priv->valid_rate_index[0]) {
>> > >> +               DPRINTF(sc, ATH_DBG_RATE, "lowest rate being used, "
>> > >> +                       "disabling MRR\n");
>> > >> +               rates[0].idx = rate_lowest_index(sband, sta);
>> > >> +               /* Disable MRR when ath_rc_ratefind_ht() found rate 0 */
>> > >> +               rates[1].idx = -1;
>> > >> +       }
>> > >
>> > > I think we can still fill other rates (1..3) with the lowest rate
>> > > index as we dont differentiate the situation where the lowest rate
>> > > is chosen truely by the algorithm from this particular case.
>> >
>> > I thought about that as well, but does it really make sense for us to
>> > use MRR with the same lowest rate? That's why I just used one segment.
>> > Thoughts?
>>
>> or we can try for max_retry (4) times. In that case the rate indices of
>> other rates (just not 1) should be made -1 or this segment should
>> moved just below the rate find.
>
> and the next segment [1]
> is set to -1. Please let me know if there is anything else you see needs
> change.
>
> Setting rate index of the rate series[1] is not enough as you are still filling the others rate
> segments(2 and 3) by ath_rc_rate_getidx() in the for..loop, so other segments are also be
> set to -1, but it looks hacky, one clean way of doing this can be, moving you code segment to
> just below ath_rc_ratefind_ht(), like the following diff.
>
>
>        rate_table = sc->cur_rate_table;
>        rix = ath_rc_ratefind_ht(sc, ath_rc_priv, rate_table, &is_probe);
> +
> +       if (rix == ath_rc_priv->valid_rate_index[0]) {
> +               DPRINTF(sc, ATH_DBG_RATE, "lowest rate being used, "
> +                               "disabling MRR\n");
> +
> +               ath_rc_rate_set_series(rate_table, &rates[0], txrc,
> +                                      4, rix, 0);

The above sets the rate[0].idx to rix

> +               rates[0].idx = rate_lowest_index(sband, sta);

and then here we set it to rate_lowest_index(sband, sta) comes up
with. They should be the same, but this just goes to show we need to
clean this better.

ath_rc_rate_set_series() is also doing some flag checks which I'm not
so sure we need to do all the time so I'd like to avoid it. And
there's also that is_probe check and the flags that sets.

> +               goto find_ctrl_rateix;

This seems like a good idea but in fact I also think this is useless,
not sure why mac80211 can't figure this out for us. More cleanup.

> +       }
> +
>        nrix = rix;
>
>        if (is_probe) {
> @@ -933,6 +944,7 @@ static void ath_rc_ratefind(struct ath_softc *sc,
>                rates[0].count = ATH_TXMAXTRY;
>        }
>
> +find_ctrl_rateix:
>        /* Setup RTS/CTS */
>        ath_rc_rate_set_rtscts(sc, rate_table, tx_info);
>  }

I'll respin again.

  Luis
