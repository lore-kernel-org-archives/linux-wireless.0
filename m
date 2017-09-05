Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:50771 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750911AbdIEJCx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Sep 2017 05:02:53 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: nbd@nbd.name
Subject: Re: [PATCH 3/3] mac80211: fix VLAN handling with TXQs
In-Reply-To: <1504594708.6667.1.camel@sipsolutions.net>
References: <20170622102030.9795-1-johannes@sipsolutions.net> <20170622102030.9795-3-johannes@sipsolutions.net> <87378lvyfz.fsf@toke.dk> <1504517620.9797.3.camel@sipsolutions.net> <87mv6a35lb.fsf@toke.dk> <1504594708.6667.1.camel@sipsolutions.net>
Date: Tue, 05 Sep 2017 11:02:49 +0200
Message-ID: <8760cx34cm.fsf@toke.dk> (sfid-20170905_110257_268325_D7B14DCB)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Mon, 2017-09-04 at 16:23 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>=20
>> Hmm, not apart from agreeing with you that it would be better to not
>> drop everything when removing a VLAN. Not sure how often this
>> happens, though (and hence how big of a problem it is). What happens
>> in scenarios where hostapd is setup to automatically generate a bunch
>> of VLANs for every client, for instance?
>
> I'm not sure. However, I think it's less bad than one might guess
> since it really should only affect multicast frames, right? All
> unicast frames should go directly to the per-STA TXQ.

Ah, right, that is the interface txq that is being purged. Gotcha.

But, erm, what happens with unicast traffic sent on the VLAN interface
when it goes down? Shouldn't that be purged from the per-station TXQs as
well?

> Right now, with TXQ, encrypted VLANs are completely broken, so surely
> it's a step in the right direction?

Yeah, fair point ;)

One nit with the patch:

> -	tx.sdata =3D vif_to_sdata(info->control.vif);
> +	if (info->control.vif)
> +		tx.sdata =3D vif_to_sdata(info->control.vif);

Why the conditional assignment? The code below unconditionally
dereferences tx.sdata, so if info->control.vif is null it is going to
crash anyway?

-Toke
