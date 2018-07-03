Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:54982 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932272AbeGCXsG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jul 2018 19:48:06 -0400
Message-ID: <1530661681.4735.51.camel@sipsolutions.net> (sfid-20180704_014809_286316_C34CEF86)
Subject: Re: [PATCH] mac80211: don't put null-data frames on the normal TXQ
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter Oh <peter.oh@bowerswilkins.com>,
        linux-wireless@vger.kernel.org
Cc: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Felix Fietkau <nbd@nbd.name>
Date: Wed, 04 Jul 2018 01:48:01 +0200
In-Reply-To: <e9813f60-5cf5-a4bf-5906-623282319991@bowerswilkins.com>
References: <20180703124725.30917-1-johannes@sipsolutions.net>
         <e9813f60-5cf5-a4bf-5906-623282319991@bowerswilkins.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-07-03 at 13:40 -0700, Peter Oh wrote:
> 
> On 07/03/2018 05:47 AM, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > Since (QoS) NDP frames shouldn't be put into aggregation nor are
> > assigned real sequence numbers, etc. it's better to treat them as
> > non-data packets and not put them on the normal TXQs, for example
> > when building A-MPDUs they need to be treated specially,
> 
> To be treated specially at which layer, mac80211 or drivers?

They cannot be put into an A-MPDU, so you need to skip them when
building A-MPDUs.

> Are you seeing any issues other than complexity of handling NDP or is it 
> just improvement?

I'm not actually running any hardware on my development setup that would
use TXQs today. However, I'm starting to work on converting iwlwifi to
it, and if we put the NDPs on there it means we no longer can schedule
the TXQ to a single hardware queue.

Similarly, I think for other drivers it would be a complexity reduction
and possibly performance improvement with aggregation because you no
longer need to check if the next frame is an NDP and if yes, finish the
open A-MPDU and put both frames on the HW queue.

That said, I hadn't looked much at the drivers. Seems the situation is
worse than I thought, with those not doing it so well.

ath10k appears to not do aggregation in the host, and I guess the data
isn't split over multiple queues so the firmware has to determine/buffer
it some other way. No idea how that would work.

I see no evidence of ath9k doing this correctly, so this might fix a bug
there, but I may have missed it.

mt76 also appears to behave erroneously: if the txq is marked with
aggregation it will even update the mtxq->agg_ssn to 0x10 for QoS NDPs,
because those always have seqno 0; in mt76_check_agg_ssn:
	mtxq->agg_ssn = le16_to_cpu(hdr->seq_ctrl) + 0x10;

johannes
