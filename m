Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f172.google.com ([209.85.212.172]:36719 "EHLO
	mail-vw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbZHLRuw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 13:50:52 -0400
Received: by vws2 with SMTP id 2so173398vws.4
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2009 10:50:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890908121032u52ed53f5u5835dd73d83f8871@mail.gmail.com>
References: <1250096221-11000-1-git-send-email-lrodriguez@atheros.com>
	 <1250096221-11000-4-git-send-email-lrodriguez@atheros.com>
	 <b6c5339f0908121013v4316cfdbsf4e274217555dbe9@mail.gmail.com>
	 <43e72e890908121032u52ed53f5u5835dd73d83f8871@mail.gmail.com>
Date: Wed, 12 Aug 2009 13:50:52 -0400
Message-ID: <b6c5339f0908121050t546471f7obbaf3e20b6b68a75@mail.gmail.com>
Subject: Re: [PATCH 3/3] ath5k: use bit shift operators for cache line size
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 12, 2009 at 1:32 PM, Luis R.
Rodriguez<lrodriguez@atheros.com> wrote:
>>> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
>>> index 63c2b57..2b3cf39 100644
>>> --- a/drivers/net/wireless/ath/ath5k/base.c
>>> +++ b/drivers/net/wireless/ath/ath5k/base.c
>>> @@ -471,7 +471,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
>>>                 * DMA to work so force a reasonable value here if it
>>>                 * comes up zero.
>>>                 */
>>> -               csz = L1_CACHE_BYTES / sizeof(u32);
>>> +               csz = L1_CACHE_BYTES >> 2;
>>>                pci_write_config_byte(pdev, PCI_CACHE_LINE_SIZE, csz);
>>
>> I'm not sure it's better,
>
> I did this for consistency between drivers but yes the advantage with
> a shift is it should be cheaper than a multiplication. Although I am
> not sure if simple multiplications get optimized by either the
> compiler or an architecture to shifts.

It shouldn't matter in the above case -- division by two constants.
In the multiplication by power of 2 constant case, it should also
get optimized by the compiler.  '>> 2' looks like magic though, maybe
a comment to say why?

>> although the whole thing seems bogus to
>> me.  Is there really a modern machine where PCI cache line size should
>> only be four bytes?

To correct above, I misread what it was doing.. it's getting cpu cache
size and dividing by 4 to get the number of words, if cache line size
was zeroed initially.  Ok, I'll go back to sleep now.

Whether needed or not, there's a lot of confusing comments and
voodoo around the stuff (something about 2.4 kernels...) that would
be nice to clear up.

> Whether we remove this though would be a change which should go
> through a separate patch I think.

Yeah, that's reasonable.

-- 
Bob Copeland %% www.bobcopeland.com
