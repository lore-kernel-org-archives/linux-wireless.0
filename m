Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:23138 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932754AbaEPOGN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2014 10:06:13 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k:  improve vdev map handling.
References: <1398882179-17100-1-git-send-email-greearb@candelatech.com>
	<878uq16e08.fsf@kamboji.qca.qualcomm.com>
	<53761A35.2000308@candelatech.com>
Date: Fri, 16 May 2014 17:06:05 +0300
In-Reply-To: <53761A35.2000308@candelatech.com> (Ben Greear's message of "Fri,
	16 May 2014 07:01:25 -0700")
Message-ID: <87bnux4y42.fsf@kamboji.qca.qualcomm.com> (sfid-20140516_160632_904282_51530BC4)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> On 05/16/2014 06:37 AM, Kalle Valo wrote:
>
>>> -	ar->free_vdev_map &= ~BIT(arvif->vdev_id);
>>> +	ar->free_vdev_map &= ~(1 << arvif->vdev_id);
>> 
>> Why remove the BIT()? Not that it matters much, I just think it's easier
>> to read when BIT() macro is used. Would be good to convert all cases to
>> use BIT anyway, but that's for a separate patch.
>
> BIT doesn't work on 64-bit numbers (ie, if vdev_id > 31)

Oh, I didn't know that. Too bad, but then removing it makes sense.

> and it takes a long time to figure out exactly what it does (try
> grepping for BIT). Open-coding means much easier to fully understand
> the code.

All Linux engineers should know what BIT() does. If not, they should
learn that ;)

>>> -	ar->free_vdev_map |= 1 << (arvif->vdev_id);
>>> +	ar->free_vdev_map |= (1 << arvif->vdev_id);
>> 
>> Do we need the parenthesis?
>
> No, though I like them visually.  It's at least more useful than
> the previous placement.
>
> I can respin the patch w/out them and with the == 0 and such.

Thanks.

-- 
Kalle Valo
