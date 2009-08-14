Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f175.google.com ([209.85.210.175]:56406 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563AbZHNPbP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 11:31:15 -0400
Received: by yxe5 with SMTP id 5so1959988yxe.33
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2009 08:31:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200908141150.54153.chunkeey@web.de>
References: <1250215295-11253-1-git-send-email-lrodriguez@atheros.com>
	<200908141150.54153.chunkeey@web.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 14 Aug 2009 08:30:55 -0700
Message-ID: <43e72e890908140830t299126efk694514fc20a4db26@mail.gmail.com>
Subject: Re: [RFT] ar9170: downgrade BUG_ON() on unexpected mdpu
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 14, 2009 at 2:50 AM, Christian Lamparter<chunkeey@web.de> wrote:
> On Friday 14 August 2009 04:01:35 Luis R. Rodriguez wrote:
>> If someone pulls the harware out while RX'ing a lot of traffic
>> I would funky data may be passed, BUG_ON() seems pretty extreme
>> so lets just drop the frame as we do when the length does not
>> meet our criteria for processing.
>>
>> Cc: Christian Lamparter <chunkeey@web.de>
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>> ---
>>
>> This one depends on my previous patch.
>>
>>  drivers/net/wireless/ath/ar9170/main.c |    7 +++++--
>>  1 files changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
>> index 75c317d..0bbbc36 100644
>> --- a/drivers/net/wireless/ath/ar9170/main.c
>> +++ b/drivers/net/wireless/ath/ar9170/main.c
>> @@ -1068,8 +1068,11 @@ static void ar9170_handle_mpdu(struct ar9170 *ar, u8 *buf, int len)
>>               break;
>>
>>       default:
>> -             BUG_ON(1);
>> -             break;
>> +             if (ar9170_nag_limiter(ar))
>> +                     printk(KERN_ERR "%s: rx'd unexpected "
>> +                            "type of MPDU.\n",
>> +                            wiphy_name(ar->hw->wiphy));
>> +             return;
>>       }
>
> no, this is really impossible! really!
>
> But let's take a closer look why should be so:
>
> the switch goes like this:
>> switch (mac->status & AR9170_RX_STATUS_MPDU_MASK) {
> mac->status is a u8 and AND with AR9170_RX_STATUS_MPDU_MASK.
>
> AR9170_RX_STATUS_MPDU_MASK (etc.) is #define in hw.h
> and it's a 0x30 _mask_.
>
> This leaves only four possibilities: 0x00, 0x10, 0x20, 0x30.
>
>>case AR9170_RX_STATUS_MPDU_FIRST: (case 0x20:)
>>case AR9170_RX_STATUS_MPDU_LAST: (case 0x10:)
>>case AR9170_RX_STATUS_MPDU_MIDDLE: (case 0x30:)
>>case AR9170_RX_STATUS_MPDU_SINGLE: (case 0x00:)
>
> so the default case is a deadly dead code path here ;-).
> And the reason why you see it was because some checker tool kept
> complaining about unlikely _corner_ cases.

heh thanks!

  Luis
