Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.212.179]:47770 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab1E3JcY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 May 2011 05:32:24 -0400
Received: by pxi2 with SMTP id 2so2367556pxi.10
        for <linux-wireless@vger.kernel.org>; Mon, 30 May 2011 02:32:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1306746186.3745.1.camel@jlt3.sipsolutions.net>
References: <cover.1306586311.git.gwingerde@gmail.com>
	<201105281647.35855.helmut.schaa@googlemail.com>
	<4DE288DB.7040309@gmail.com>
	<201105300955.43779.helmut.schaa@googlemail.com>
	<1306746186.3745.1.camel@jlt3.sipsolutions.net>
Date: Mon, 30 May 2011 11:32:23 +0200
Message-ID: <BANLkTinu9dBnBdYb7_bxdVUkTfzJ2cO9OQ@mail.gmail.com> (sfid-20110530_113227_656209_4461114F)
Subject: Re: [rt2x00-users] [PATCH 1/3] rt2x00: Serialize TX operations on a queue.
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 30, 2011 at 11:03 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2011-05-30 at 09:55 +0200, Helmut Schaa wrote:
>
>> > >> AFAICT not all tx calls from mac80211 are protected by local_bh_disable/enable. I believe
>> > >> that this is the case for the "process" context tx calls from
>> > >
>> > >> ieee80211_subif_start_xmit
>> > >
>> > > This should only be called from the network softirq and thus doesn't require bottom halves
>> > > to be disabled (AFAIK).
>> > >
>> > >> and
>> > >> ieee80211_monitor_start_xmit.
>> > >
>> > > Same here.
>> >
>> > Hmm, are you sure about this?
>>
>> Maybe Johannes can clarify this for us ;)
>
> The above assertion ("not all TX calls are protected") is wrong.
>
>> Johannes, are all calls to the drivers tx callback done in softirq context or
>> adequately protected by local_bh_disable/enable? Or is this presumption wrong?
>
> All of them are invoked with BHs disabled.
>
> Cf. ieee80211_tx_skb(), which is the only function that can be called
> from process context. The _start_xmit functions listed above are called
> by the networking layer and always invoked with BHs disabled.
>

OK. Thanks for the clarification. I'll update the patch to use
spin_lock / spin_unlock instead
of spin_lock_bh / spin_unlock_bh when I return home on Wednesday.

As a follow-up question, is it valid that mac80211 calls the driver's
tx function simultaneously
for multiple frames, or are we experiencing an issue with mac80211 here?
We are experiencing in rt2x00 that our tx function is called while it
is already running, leading
to races in the queue handling when enqueuing the frame for the hw.

---
Gertjan
