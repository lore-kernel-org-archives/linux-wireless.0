Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:57091 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755172AbcGHPyL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 11:54:11 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: <linux-wireless@vger.kernel.org>,
	<make-wifi-fast@lists.bufferbloat.net>,
	<ath9k-devel@lists.ath9k.org>, Tim Shepard <shep@alum.mit.edu>,
	Felix Fietkau <nbd@nbd.name>
Subject: Re: [v3] ath9k: Switch to using mac80211 intermediate software queues.
References: <ac5b5bc6532d4fe7ae3198124ecce7fc@euamsexm01a.eu.qualcomm.com>
Date: Fri, 08 Jul 2016 17:53:38 +0200
In-Reply-To: <ac5b5bc6532d4fe7ae3198124ecce7fc@euamsexm01a.eu.qualcomm.com>
	(Kalle Valo's message of "Fri, 8 Jul 2016 16:26:54 +0200")
Message-ID: <87wpkwktx9.fsf@toke.dk> (sfid-20160708_175440_930421_1ED0A2E5)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Toke Høiland-Jørgensen wrote:
>> This switches ath9k over to using the mac80211 intermediate software
>> queueing mechanism for data packets. It removes the queueing inside the
>> driver, except for the retry queue, and instead pulls from mac80211 when
>> a packet is needed. The retry queue is used to store a packet that was
>> pulled but can't be sent immediately.
>> 
>> The old code path in ath_tx_start that would queue packets has been
>> removed completely, as has the qlen limit tunables (since there's no
>> longer a queue in the driver to limit).
>> 
>> Based on Tim's original patch set, but reworked quite thoroughly.
>> 
>> Cc: Tim Shepard <shep@alum.mit.edu>
>> Cc: Felix Fietkau <nbd@nbd.name>
>> Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
>
> Nice work.

Thanks :)

> Because this is such a significant change, and to maximise testing
> time, I'm planning to queue this for 4.9 (so I would apply this to
> ath-next in 3-4 weeks after the merge window closes). But anyone who
> wants to test this can use master-pending branch from my ath.git tree
> (uses wireless-testing as the baseline). Sounds good?

Sounds good to me. I'm planning on backporting this and Michael's
mac80211 FQ-CoDel patches to 4.4 and post them for inclusion in LEDE.
Hopefully that will get it some more testing as well.

> Testing and review feedback very welcome!

My own evaluation results are here:
https://blog.tohojo.dk/2016/06/fixing-the-wifi-performance-anomaly-on-ath9k.html
-- I see aggregate throughput to multiple stations improve by a factor
of ~3 and latency under load decrease by a factor of ~10 now that we can
take advantage of the mac80211 FQ-CoDel patches.

-Toke
