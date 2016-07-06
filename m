Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:53107 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650AbcGFOqA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 10:46:00 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Felix Fietkau <nbd@nbd.name>
Cc: Tim Shepard <shep@alum.mit.edu>, linux-wireless@vger.kernel.org,
	make-wifi-fast@lists.bufferbloat.net, ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH] ath9k: Switch to using mac80211 intermediate software
	queues.
References: <E1bJYSp-0001M8-00@www.xplot.org> <87lh1hnvn6.fsf@toke.dk>
	<2c4c9821-fea6-fc95-f6a3-cf95e703cce6@nbd.name>
Date: Wed, 06 Jul 2016 16:45:52 +0200
In-Reply-To: <2c4c9821-fea6-fc95-f6a3-cf95e703cce6@nbd.name> (Felix Fietkau's
	message of "Wed, 6 Jul 2016 15:23:49 +0200")
Message-ID: <87vb0in7tr.fsf@toke.dk> (sfid-20160706_164604_420504_3E26839A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> writes:

>> Well, presumably the upper layers won't try to transmit anything through
>> the old TX path if the start/stop logic is implemented properly. The
>> chanctx code already seems to call the ieee80211_{start,stop}_queue()
>> functions when changing context, so not sure what else is needed. Guess
>> I'll go see if I can provoke an actual triggering of the bug, unless
>> Felix elaborates on what he means before I get around to it (poke,
>> Felix? :)).
> Then I guess the logic in ath_tx_start was a leftover from a time before
> some queue related rework happened to the chanctx code.
> In that case you can simply remove the chanctx related software queueing
> stuff from ath_tx_start.

Awesome. I'll double-check that I can't get the WARN_ON to trigger, then
send a v2 :)

-Toke
