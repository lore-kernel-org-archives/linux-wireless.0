Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:42990 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727508AbeIEP0R (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Sep 2018 11:26:17 -0400
Message-ID: <1536144985.3528.7.camel@sipsolutions.net> (sfid-20180905_125638_387926_A072BC02)
Subject: Re: [PATCH] mac80211: use non-zero TID only for QoS frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>
Date: Wed, 05 Sep 2018 12:56:25 +0200
In-Reply-To: <87d0ts6zeb.fsf@toke.dk>
References: <20180905080036.9177-1-johannes@sipsolutions.net>
         <87in3k6zti.fsf@toke.dk> <1536141045.3528.4.camel@sipsolutions.net>
         <87d0ts6zeb.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-09-05 at 11:56 +0200, Toke Høiland-Jørgensen wrote:

> > So basically this gets rid of a corner case that we shouldn't have.
> > Either we should decide that using different TXQs is *always* correct
> > for non-QoS, or - what I thought - that this isn't worth it, and then we
> > should *never* do it.
> 
> Yeah, I agree that this is not worth it. The queue is already
> FQ-CoDel'ed, which gives us most of the benefit of QoS anyway :)

So do I read that as a tentative ack? :)

Felix wasn't really convinced, I think. He also pointed out some drivers
use skb->priority without checking anything, but I'm not sure we can
really squash all the cases of setting skb priority easily?

johannes
