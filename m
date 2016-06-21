Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:35230 "EHLO
	mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbcFUKWH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2016 06:22:07 -0400
Received: by mail-it0-f49.google.com with SMTP id g127so14349693ith.0
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jun 2016 03:22:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160621094146.GA3196@w1.fi>
References: <CAGRGNgWOScCrLPyqRNus2319BPOehv3awQChoHw=RRMcSDUqzQ@mail.gmail.com>
 <1466470940-25229-1-git-send-email-julian.calaby@gmail.com> <20160621094146.GA3196@w1.fi>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 21 Jun 2016 20:16:00 +1000
Message-ID: <CAGRGNgUyDrf=DKdR1iEt+RFQ0M8hFsCwDVD3LdyBrDEwFpf6=w@mail.gmail.com> (sfid-20160621_122213_076195_CE25EFAE)
Subject: Re: [PATCH] ath9k: Support 4.9Ghz channels on AR9580 adapter.
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	ath9k-devel@lists.ath9k.org, Ben Greear <greearb@candelatech.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jouni,

On Tue, Jun 21, 2016 at 7:41 PM, Jouni Malinen <j@w1.fi> wrote:
> On Tue, Jun 21, 2016 at 11:02:20AM +1000, Julian Calaby wrote:
>> I've only done this work as I hate to see people's efforts go to
>> waste and I feel that there's enough roadblocks in the way of
>> actually using this functionality that casual idiots won't be able
>> to.
>
> Are these really ready to go to the upstream kernel in this state and
> without the other changes that would be needed to operate correctly?
> What is the use case for these and how have these been tested?

This patch is a edited version (adding the Kconfig option) of Ben's
patch. I picked it up as he seemed to have given up on it and I could
see nothing directly wrong with the patch.

>> This is compile tested only as I cannot test this for real as I lack
>> both the hardware and license required.
>
> I don't think this is sufficient when touching this type of area. I
> would not apply these without proper testing and full set of
> functionality being available. I see no point in ath9k defining
> additional channels if all those new channels can cause is harm and not
> correct functionality. This channel list addition looks like the easiest
> part to handle compared to the other patches needed for 4.9 GHz and this
> would be the last patch on my list to get accepted..

It isn't, Ben himself has said that fractional MHz need to be
supported for this to be 100% correct, however I believe that defining
the channels is minimally sufficient for his purposes. I do know he's
done more work than this, however I can't pick that up as getting it
ready for upstream requires testing I can't do.

>> diff --git a/drivers/net/wireless/ath/ath9k/common-init.c b/drivers/net/wireless/ath/ath9k/common-init.c
>> +#ifdef ATH9K_49_GHZ_CHAN
>> +     /* 4.9Ghz channels, public safety channels, license is required in US
>> +      * and most other regulatory domains!
>> +      */
>> +     CHAN5G(4915, 38), /* Channel 183 */
>> +     CHAN5G(4920, 39), /* Channel 184 */
>> +     CHAN5G(4925, 40), /* Channel 185 */
>> +     CHAN5G(4935, 41), /* Channel 187 */
>> +     CHAN5G(4940, 42), /* Channel 188 */
>> +     CHAN5G(4945, 43), /* Channel 189 */
>> +     CHAN5G(4960, 44), /* Channel 192 */
>> +     CHAN5G(4970, 45), /* Channel 194 */
>> +     CHAN5G(4980, 46), /* Channel 196 */
>
> Where are these channels defined and are these really correct
> frequencies for them? Please note that many of the 4.9 GHz channels have
> channel starting frequencies like 4.9375 GHz and 4.0025 GHz, i.e.,
> fractional MHz.. While US public safety may not have all those cases,
> even there are some 0.5 MHz cases. In addition, those channel numbers
> sound more like some of the channels defined in Japan rather than US
> public safety operating class. In addition, some of these channels seem
> to be outside the US public safety range.

>From my perspective, this is enough to reject the patch outright. I
assumed the frequencies and numbers were correct, which is why I
picked it up.

> Is this trying to add 4.9 GHz channels in general for multiple different
> use cases? And if so, what are those use cases? Or is this only for some
> public safety cases? And if so, for which regulatory domains?

I believe he has a client that requires this support in a Linux kernel.

> To be frank, I really don't see how this would be even close to a state
> that should be accepted into the upstream tree.

Fair enough I'm dropping this.

Kalle, I've marked this as rejected and archived on Patchwork.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
