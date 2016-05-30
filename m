Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:36897 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbcE3Mfj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 May 2016 08:35:39 -0400
Received: by mail-wm0-f47.google.com with SMTP id z87so69716352wmh.0
        for <linux-wireless@vger.kernel.org>; Mon, 30 May 2016 05:35:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87pos9dj2y.fsf@toke.dk>
References: <87pos9dj2y.fsf@toke.dk>
Date: Mon, 30 May 2016 14:35:37 +0200
Message-ID: <CA+BoTQnzaE0hF7ja+BCT6-_WuMgG+e_Ln_G7PWh5TwHJ2ixVFA@mail.gmail.com> (sfid-20160530_143542_929226_D0C42902)
Subject: Re: [Make-wifi-fast] [RFC] ath9k: Measure per-station airtime usage
From: Michal Kazior <michal.kazior@tieto.com>
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	make-wifi-fast@lists.bufferbloat.net,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26 May 2016 at 15:50, Toke Høiland-Jørgensen <toke@toke.dk> wrote:
> This is my attempt to add per-station airtime usage accounting to ath9k.
> For now I just export it to a new debugfs entry, but my plan is to use
> it to make (station) scheduling decisions. However, before attempting
> that I would like some feedback from someone more familiar with the
> ath9k than me as to whether this way of measuring airtime usage is
> likely to give reasonable results.
>
> I realise that there's probably some things I'm missing, but an initial
> test run indicates that the values are at least in the right ballpark (I
> get a total of ~170k usecs of measured airtime per 200 ms sampling
> interval when running three simultaneous TCP streams to three different
> stations).
>
> So can anyone comment on whether I'm on the right track here? And
> possibly provide some more detail as to what I'm missing and how to
> remedy that?
[...]
>
> +void ath_debug_tx_airtime(struct ath_softc *sc,
> +                         struct ath_node *an,
> +                         struct ath_tx_status *ts)
> +{
> +       struct ath_airtime_stats *astats;
> +
> +       rcu_read_lock();
> +
> +       astats = &an->airtime_stats;
> +       astats->tx_airtime += ts->duration;

I'm not ath9k expert but this seems to be oblivious to tx retries. The
ts->duration is acquired from the last used tx rate for given frame.
Or am I missing something?

I think you should use ts->ts_rateindex and ts->ts_longretry to factor
in retries (see ath_tx_rc_status).


Michał
