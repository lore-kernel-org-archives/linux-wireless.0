Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:34781 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750707AbdIEKRA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Sep 2017 06:17:00 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: nbd@nbd.name
Subject: Re: [PATCH 3/3] mac80211: fix VLAN handling with TXQs
In-Reply-To: <1504605297.12380.8.camel@sipsolutions.net>
References: <20170622102030.9795-1-johannes@sipsolutions.net> <20170622102030.9795-3-johannes@sipsolutions.net> <87378lvyfz.fsf@toke.dk> <1504517620.9797.3.camel@sipsolutions.net> <87mv6a35lb.fsf@toke.dk> <1504594708.6667.1.camel@sipsolutions.net> <8760cx34cm.fsf@toke.dk> <1504603125.12380.7.camel@sipsolutions.net> <87zia91nmc.fsf@toke.dk> <1504605297.12380.8.camel@sipsolutions.net>
Date: Tue, 05 Sep 2017 12:16:56 +0200
Message-ID: <87wp5d1mcn.fsf@toke.dk> (sfid-20170905_121703_878794_C0E6803E)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Tue, 2017-09-05 at 11:49 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>=20
>> Ah, so the station is attached to the VLAN interface, not the parent
>> interface?
>
> Doesn't actually matter, but if the VLAN goes where the station belongs
> then either the station must've moved somewhere else or have been
> destroyed, you can't have the station pointing to a VLAN that no longer
> exists :)

Yeah, that makes sense. I was thinking of VLANs as something that was
carried "on top" of the station<->ap connection (so that the VLAN tag is
propagated to the client).

>> I guess that the only case where there is likely to be any
>> significant effects of dropping the whole queue is if someone is
>> sending large amounts of multicast traffic (live video streaming? is
>> that even feasible over WiFi?) while reconfiguring their VLAN setup.
>> That is probably not a terribly common combination...
>
> Right.
>
> Anyway I've applied this with the pointless null check removed.

Cool :)

-Toke
