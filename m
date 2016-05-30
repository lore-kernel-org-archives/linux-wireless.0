Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:50467 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933302AbcE3N1L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 May 2016 09:27:11 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	make-wifi-fast@lists.bufferbloat.net,
	"ath9k-devel\@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [Make-wifi-fast] [RFC] ath9k: Measure per-station airtime usage
References: <87pos9dj2y.fsf@toke.dk>
	<CA+BoTQnzaE0hF7ja+BCT6-_WuMgG+e_Ln_G7PWh5TwHJ2ixVFA@mail.gmail.com>
Date: Mon, 30 May 2016 15:27:06 +0200
In-Reply-To: <CA+BoTQnzaE0hF7ja+BCT6-_WuMgG+e_Ln_G7PWh5TwHJ2ixVFA@mail.gmail.com>
	(Michal Kazior's message of "Mon, 30 May 2016 14:35:37 +0200")
Message-ID: <87bn3nvfpx.fsf@toke.dk> (sfid-20160530_152740_277871_C548C6F1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

>> +void ath_debug_tx_airtime(struct ath_softc *sc,
>> +                         struct ath_node *an,
>> +                         struct ath_tx_status *ts)
>> +{
>> +       struct ath_airtime_stats *astats;
>> +
>> +       rcu_read_lock();
>> +
>> +       astats = &an->airtime_stats;
>> +       astats->tx_airtime += ts->duration;
>
> I'm not ath9k expert but this seems to be oblivious to tx retries. The
> ts->duration is acquired from the last used tx rate for given frame.
> Or am I missing something?

No, don't think you are. Wasn't sure what exactly that duration field
included, but I think you're right that it doesn't factor in retries.

> I think you should use ts->ts_rateindex and ts->ts_longretry to factor
> in retries (see ath_tx_rc_status).

I'll go digging. Thanks, this was exactly the kind of feedback I had
hoped for! :)

-Toke
