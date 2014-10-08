Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:35444 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933620AbaJHLqf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 07:46:35 -0400
Received: by mail-ig0-f178.google.com with SMTP id h3so1781695igd.17
        for <linux-wireless@vger.kernel.org>; Wed, 08 Oct 2014 04:46:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <be003eea-b253-4eb3-bf08-40d5f6dc629d@email.android.com>
References: <1412135157-13520-1-git-send-email-asselsm@gmail.com>
	<20141001091240.GA2011@redhat.com>
	<CAPuovEJtuJdRakwRhdUjRwrmkfry62wJqd8p2uJQ7L0rB7DoCA@mail.gmail.com>
	<CAPuovEJssghQv=03sn07AuYVvwULq0kSTn9kch53r+VKccy8xA@mail.gmail.com>
	<be003eea-b253-4eb3-bf08-40d5f6dc629d@email.android.com>
Date: Wed, 8 Oct 2014 07:46:33 -0400
Message-ID: <CAPuovEJXkRYyWXZJD7E6_1EqemfJus7Gtr_5PztT6rDtsrRpdw@mail.gmail.com> (sfid-20141008_134644_146909_3563C925)
Subject: Re: [PATCH] rt2x00: rt2x00queue: avoid using more headroom then
 driver requested
From: Mark Asselstine <asselsm@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 5, 2014 at 4:39 AM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
>
>
>
>
> Mark Asselstine <asselsm@gmail.com> schrieb:
>>On Wed, Oct 1, 2014 at 9:42 PM, Mark Asselstine <asselsm@gmail.com>
>>wrote:
>>>
>>> Damn, you are right. I thought I had it licked.
>>>
>>> Unfortunately with the overloaded variable name it was easy to get
>>turned
>>> around. The comments in the code didn't prevent me knotting myself up
>>> either. If you look in in rt2x00.h, struct rt2x00_dev, the comment
>>above the
>>> extra_tx_headroom member says "Extra TX headroom required for
>>alignment
>>> purposes." I would say this is incorrect. This variable is
>>initialized
>>> via rt2x00dev_extra_tx_headroom() with a combination of winfo_size
>>and
>>> desc_size and has nothing to do with alignment.
>>>
>>> At any rate, keeping in mind that rt2x00_dev.hw.extra_tx_headroom
>>> which is used to set the amount of available headroom includes room
>>> for alignment and padding as well as winfo and desc space, and that
>>> rt2x00_dev.extra_tx_headroom doesn't include padding or alignment,
>>you
>>> are correct in that we aren't over spending our headroom. Back to the
>>> drawing board.
>>>
>>>
>>> Mark
>>>
>>> On Wed, Oct 1, 2014 at 5:12 AM, Stanislaw Gruszka
>><sgruszka@redhat.com>
>>> wrote:
>>>>
>>>> On Tue, Sep 30, 2014 at 11:45:57PM -0400, Mark Asselstine wrote:
>>>> > 'struct ieee80211_hw' contains 'extra_tx_headroom' which it
>>defines as
>>>> > "headroom to reserve in each transmit skb for use by the driver".
>>This
>>>> > value is properly setup during rt2x00lib_probe_hw() to account for
>>all
>>>> > the rt2x00lib's purposes, including DMA alignment and L2 pad if
>>>> > needed. As such under all circumstances the proper amount of
>>headroom
>>>> > is allocated to a skb such that under any usage we would not ever
>>use
>>>> > more headroom then is allotted.
>>>> >
>>>> > However rt2x00queue_write_tx_frame() uses up the headroom (via
>>calls
>>>> > to skb_push) allotted for L2 padding (with a potential call to
>>>> > rt2x00queue_insert_l2pad()) and uses up the headroom allotted to
>>DMA
>>>> > alignment (with a potential call to rt2x00queue_align_frame()) and
>>>> > then proceeds to use up 'extra_tx_headroom' (in a call to
>>>> > rt2x00queue_write_tx_data())
>>>> >
>>>> > So the driver has requested just 'extra_tx_headroom' worth of
>>headroom
>>>> > and we have used up 'extra_tx_headroom' + DMA + L2PAD worth. As
>>such
>>>> > it is possible to hit a 'skb_under_panic', where we have used up
>>all
>>>> > the available headroom.
>>>> >
>>>> > Since extra_tx_headroom was calculated as a function of
>>winfo_size,
>>>> > desc_size, RT2X00_L2PAD_SIZE and RT2X00_ALIGN_SIZE we can simply
>>>> > remove the part for alignment and padding and we will know how
>>much is
>>>> > left to use up (for txdesc) and only use that much. Keeping the
>>>> > driver's use of headroom to what it requested via
>>extra_tx_headroom.
>>>> >
>>>> > Signed-off-by: Mark Asselstine <asselsm@gmail.com>
>>>> > ---
>>>> >  drivers/net/wireless/rt2x00/rt2x00queue.c | 15 ++++++++++++---
>>>> >  1 file changed, 12 insertions(+), 3 deletions(-)
>>>> >
>>>> > diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c
>>>> > b/drivers/net/wireless/rt2x00/rt2x00queue.c
>>>> > index 8e68f87..2a48bf5 100644
>>>> > --- a/drivers/net/wireless/rt2x00/rt2x00queue.c
>>>> > +++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
>>>> > @@ -522,6 +522,7 @@ static int rt2x00queue_write_tx_data(struct
>>>> > queue_entry *entry,
>>>> >                                    struct txentry_desc *txdesc)
>>>> >  {
>>>> >       struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
>>>> > +     unsigned int avail_extra_tx_headroom =
>>>> > rt2x00dev->extra_tx_headroom;
>>>> >
>>>> >       /*
>>>> >        * This should not happen, we already checked the entry
>>>> > @@ -538,10 +539,18 @@ static int rt2x00queue_write_tx_data(struct
>>>> > queue_entry *entry,
>>>> >       }
>>>> >
>>>> >       /*
>>>> > -      * Add the requested extra tx headroom in front of the skb.
>>>> > +      * Add room for data at the front of the buffer for txdesc.
>>The
>>>> > space
>>>> > +      * needed for this was accounted for in extra_tx_headroom,
>>we just
>>>> > +      * need to remove the amount allocated for padding and
>>alignment
>>>> > +      * to get what is left for txdesc.
>>>> >        */
>>>> > -     skb_push(entry->skb, rt2x00dev->extra_tx_headroom);
>>>> > -     memset(entry->skb->data, 0, rt2x00dev->extra_tx_headroom);
>>>> > +     if (test_bit(REQUIRE_L2PAD, &rt2x00dev->cap_flags))
>>>> > +             avail_extra_tx_headroom -= RT2X00_L2PAD_SIZE;
>>>> > +     else if (test_bit(REQUIRE_DMA, &rt2x00dev->cap_flags))
>>>> > +             avail_extra_tx_headroom -= RT2X00_ALIGN_SIZE;
>>>> > +
>>>> > +     skb_push(entry->skb, avail_extra_tx_headroom);
>>>> > +     memset(entry->skb->data, 0, avail_extra_tx_headroom);
>>>>
>>>> I don't think patch is correct.
>>>>
>>>> We have rt2x00->extra_tx_headroom and rt2x00->hw->extra_tx_headroom.
>>>> Second value, which we provide as maximum needed headroom to
>>mac80211
>>>> is rt2x00->extra_tx_headrom + RT2X00_L2PAD_SIZE + RT2X00_ALIGN_SIZE.
>>>>
>>>> We really need to reserve rt2x00dev->extra_tx_headroom on TX skb, as
>>>> this is room for metadata needed by H/W and if needed we should
>>reserve
>>>> RT2x00_L2PAD_SIZE and RTX00_ALIGN_SIZE. There should be room for
>>that,
>>>> since we provide bigger rt2x00->hw->extra_tx_headroom to mac80211.
>>>>
>>>> The only possibility to skb_under_panic I can see, is that we
>>retransmit
>>>> frame and try to align it many times, but alignment should not be
>>needed
>>>> once we aligned frame. Hence I'm not sure how those skb_under_panics
>>can
>>>> happen.
>>
>>I am still digging through trying to find a cause for this, without a
>>reproducer I am starting to lose hope on finding the cause.
>>
>>I dug up this old thread
>>http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2010-November/002457.html
>>
>>I am thinking that the cause is an interaction with 80211mac and the
>>rt2x00queue not doing enough to ensure we are sending the skb back in
>>the same state as we get it. Looking at rt2x00lib_txdone() we don't
>>return headroom that may have been taken for frame alignment and we
>>don't account for the extra 4-bytes taken for header_align when the
>>payload_align is larger then the header_align while setting up the
>>l2pad. Do you know why rt2x00 doesn't return frame align space back to
>>the headroom?
>
> If rt2x00 does not remove the alignment from the frame before giving it back
> to mac80211 and the same frame comes into rt2x00 again it should be correctly
> aligned and no additional header space is required. So this should be fine.

Then I would say this definitely hints at a design flaw in
rt2x00queue_insert_l2pad(). Take the following scenario.

* skb's first arrival in rt2x00queue_insert_l2pad(), 3 bytes needed
for frame alignment, 2 bytes for l2pad results in 3 bytes of headroom
taken.
* rt2x00lib_txdone() returns 2 bytes of headroom
* skb's second arrival in rt2x00queue_insert_l2pad(), 0 bytes needed
for frame alignment, 2 bytes for l2pad results in 4 bytes of headroom
taken.
* rt2x00lib_txdone() returns 2 bytes of headroom

Basically as long as any bytes are required for l2pad the headroom
will lose 4 bytes again and again, never being returned by
rt2x00lib_txdone().

Not having spent enough time with the 80211 code I am still figuring
out when the skb is reused but I will get there.

Mark

>
> Helmut
