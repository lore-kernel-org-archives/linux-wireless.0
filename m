Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45507 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab2B0PtW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 10:49:22 -0500
Received: by pbcup15 with SMTP id up15so2183305pbc.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Feb 2012 07:49:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1330357575.3483.57.camel@jlt3.sipsolutions.net>
References: <1330343374.3483.46.camel@jlt3.sipsolutions.net>
	<CAGXE3d_SNsrA-KLuPVe_TWnbaVGK3ABr_4TWbtJWU568=BgWbw@mail.gmail.com>
	<1330357575.3483.57.camel@jlt3.sipsolutions.net>
Date: Mon, 27 Feb 2012 16:49:22 +0100
Message-ID: <CAGXE3d8KtDZyCY_QGNFpkh7VjXRrRrt2-2WvPXY+ExEs==sGGg@mail.gmail.com> (sfid-20120227_164925_315011_A979258B)
Subject: Re: mac80211 queue handling in multi-channel
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Eliad Peller <eliad@wizery.com>, Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 27, 2012 at 4:46 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2012-02-27 at 16:38 +0100, Helmut Schaa wrote:
>> On Mon, Feb 27, 2012 at 12:49 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > Then of course, the driver needs to tell mac80211 about queue mapping.
>> > For this, there's one global queue:
>> >  * off-channel TX queue
>> > Additionally, there are per-interface queues:
>> >  * 4 per AC
>> >  * CAB for this interface
>>
>> Ralink devices have only the 4 hw queues and no CAB queue. So, would
>> each interface point to the same hw queue or would the driver have to do
>> some sort of translation?
>
> No, just like today I'd expect each interface to point to the same hw
> queue. In fact, even in devices that do have more queues I would expect
> multiple interfaces to point to the same hw queue, if they share
> channels.
>
> This will be somewhat tricky when an the mapping isn't static, but for
> that the netdev queues can be stopped and then the reassignment is
> probably not so much of a problem.

Ok.

>> Also Ralink devices don't have a CAB queue :)
>
> You just said that ;-)
>
> But in that case I suppose the CAB queue would simply point to the BE
> queue or so as well. But I think they are also quite broken wrt. sending
> multicast-after-DTIM anyway, no?

Yep, that's done in a tasklet using the BE queue at the moment. Not the
perfect solution ...

In any case I'd then expect this to
> either point to a "virtual" queue that the driver simply has in
> software, or to the real BE queue, depending on the desired queue-full
> semantics.

Ok, fine with me.

Helmut
