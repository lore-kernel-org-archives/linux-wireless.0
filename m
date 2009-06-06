Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:55318 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbZFFGz4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Jun 2009 02:55:56 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 05 Jun 2009 23:55:58 -0700
From: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Date: Sat, 6 Jun 2009 12:25:51 +0530
Subject: RE: [PATCH 01/15] ath9k: fix oops by downgrading assert in rc.c
Message-ID: <44EE5C37ADC36343B0625A05DD408C485068DEBF69@CHEXMB-01.global.atheros.com>
References: <1244180502-4323-1-git-send-email-lrodriguez@atheros.com>
 <1244180502-4323-2-git-send-email-lrodriguez@atheros.com>
 <20090605063059.GF17632@vasanth-laptop>
 <43e72e890906050047w71f8e691g479797a54f5fb9a0@mail.gmail.com>
 <20090605075252.GG17632@vasanth-laptop>,<20090605182944.GD30211@tesla>
In-Reply-To: <20090605182944.GD30211@tesla>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


________________________________________

> > >> +       /*
> > >> +        * Fine tuning for when no decent rate was found, the
> > >> +        * lowest should *not* be used under normal circumstances.
> > >> +        */
> > >> +       if (rix == ath_rc_priv->valid_rate_index[0]) {
> > >> +               DPRINTF(sc, ATH_DBG_RATE, "lowest rate being used, "
> > >> +                       "disabling MRR\n");
> > >> +               rates[0].idx = rate_lowest_index(sband, sta);
> > >> +               /* Disable MRR when ath_rc_ratefind_ht() found rate 0 */
> > >> +               rates[1].idx = -1;
> > >> +       }
> > >
> > > I think we can still fill other rates (1..3) with the lowest rate
> > > index as we dont differentiate the situation where the lowest rate
> > > is chosen truely by the algorithm from this particular case.
> >
> > I thought about that as well, but does it really make sense for us to
> > use MRR with the same lowest rate? That's why I just used one segment.
> > Thoughts?
>
> or we can try for max_retry (4) times. In that case the rate indices of
> other rates (just not 1) should be made -1 or this segment should
> moved just below the rate find.

and the next segment [1]
is set to -1. Please let me know if there is anything else you see needs
change.

Setting rate index of the rate series[1] is not enough as you are still filling the others rate
segments(2 and 3) by ath_rc_rate_getidx() in the for..loop, so other segments are also be
set to -1, but it looks hacky, one clean way of doing this can be, moving you code segment to
just below ath_rc_ratefind_ht(), like the following diff.


        rate_table = sc->cur_rate_table;
        rix = ath_rc_ratefind_ht(sc, ath_rc_priv, rate_table, &is_probe);
+
+       if (rix == ath_rc_priv->valid_rate_index[0]) {
+               DPRINTF(sc, ATH_DBG_RATE, "lowest rate being used, "
+                               "disabling MRR\n");
+
+               ath_rc_rate_set_series(rate_table, &rates[0], txrc,
+                                      4, rix, 0);
+               rates[0].idx = rate_lowest_index(sband, sta);
+               goto find_ctrl_rateix;
+       }
+
        nrix = rix;

        if (is_probe) {
@@ -933,6 +944,7 @@ static void ath_rc_ratefind(struct ath_softc *sc,
                rates[0].count = ATH_TXMAXTRY;
        }

+find_ctrl_rateix:
        /* Setup RTS/CTS */
        ath_rc_rate_set_rtscts(sc, rate_table, tx_info);
 }


Vasanth
