Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:62397 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbaJIDeX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 23:34:23 -0400
Received: by mail-ig0-f176.google.com with SMTP id hn15so10342966igb.3
        for <linux-wireless@vger.kernel.org>; Wed, 08 Oct 2014 20:34:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPuovEKn+Lz3dqSZPhgd+-F4=n6tTOYyg3MDQ=E5yntGM8zYZg@mail.gmail.com>
References: <1412135157-13520-1-git-send-email-asselsm@gmail.com>
	<20141001091240.GA2011@redhat.com>
	<CAPuovEJtuJdRakwRhdUjRwrmkfry62wJqd8p2uJQ7L0rB7DoCA@mail.gmail.com>
	<CAPuovEJssghQv=03sn07AuYVvwULq0kSTn9kch53r+VKccy8xA@mail.gmail.com>
	<be003eea-b253-4eb3-bf08-40d5f6dc629d@email.android.com>
	<CAPuovEJXkRYyWXZJD7E6_1EqemfJus7Gtr_5PztT6rDtsrRpdw@mail.gmail.com>
	<20141008130006.GB5186@redhat.com>
	<CAPuovEKn+Lz3dqSZPhgd+-F4=n6tTOYyg3MDQ=E5yntGM8zYZg@mail.gmail.com>
Date: Wed, 8 Oct 2014 23:34:22 -0400
Message-ID: <CAPuovE+vAp9W3xBi6z3TDz51rKESXMuOT9Ow7ZX3Sm7dYQ+mFg@mail.gmail.com> (sfid-20141009_053427_113364_69563334)
Subject: Re: [PATCH] rt2x00: rt2x00queue: avoid using more headroom then
 driver requested
From: Mark Asselstine <asselsm@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 8, 2014 at 3:52 PM, Mark Asselstine <asselsm@gmail.com> wrote:
> On Wed, Oct 8, 2014 at 9:00 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>>
>> On Wed, Oct 08, 2014 at 07:46:33AM -0400, Mark Asselstine wrote:
>> > > If rt2x00 does not remove the alignment from the frame before giving it back
>> > > to mac80211 and the same frame comes into rt2x00 again it should be correctly
>> > > aligned and no additional header space is required. So this should be fine.
>> >
>> > Then I would say this definitely hints at a design flaw in
>> > rt2x00queue_insert_l2pad(). Take the following scenario.
>> >
>> > * skb's first arrival in rt2x00queue_insert_l2pad(), 3 bytes needed
>> > for frame alignment, 2 bytes for l2pad results in 3 bytes of headroom
>> > taken.
>> Not quite realistic assumption - header length will have to be odd then.
>>
>> But if such situation would happen we will have:
>>
>> header_align=2, payload_align=3, l2pad=3
>>
>> Since payload_align will be bigger than header_align, header_align will
>> be increased to 6.
>>
>> Header will be moved by 6 bytes, frame will be moved by 3 bytes,
>> between header and frame there will be l2pad equal to 3.
>>
>> > * rt2x00lib_txdone() returns 2 bytes of headroom
>> Return 3 bytes.
>>
>> > * skb's second arrival in rt2x00queue_insert_l2pad(), 0 bytes needed
>> > for frame alignment, 2 bytes for l2pad results in 4 bytes of headroom
>> > taken.
>> Header will be moved by 3 bytes.
>>
>> > * rt2x00lib_txdone() returns 2 bytes of headroom
>> Return 3 bytes.
>>
>> > Basically as long as any bytes are required for l2pad the headroom
>> > will lose 4 bytes again and again, never being returned by
>> > rt2x00lib_txdone().
>>
>> I think that's not true - you made a few mistakes in your scenario,
>> but perhaps I'm wrong :-)
>
> No just me being an idiot. I had thought
>  frame == header + l2pad + payload
> not
>  frame == payload
>

By the way, I assumed that this due to the name and contents of
rt2x00queue_align_frame(). Where all the data (header and payload) are
aligned to a 4-byte boundary and the function is name 'align_frame'. I
assume your interpretation is the correct one, can you confirm?

Mark

> With this straight your numbers makes sense and my scenario is
> incorrect. We don't continue to eat in to the headroom but rather take
> and return a small bit.
>
> Thanks for your patience, it has been a while since I have been
> working on this stuff. I am still motivated to hunt this issue down,
> you might just need to correct me along the way.
>
> Mark
>
>>
>> Stanislaw
