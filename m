Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44870 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab1JMEiO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Oct 2011 00:38:14 -0400
Received: by wyg34 with SMTP id 34so1404737wyg.19
        for <linux-wireless@vger.kernel.org>; Wed, 12 Oct 2011 21:38:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+icZUXzPSm8FdqMbAm34GEDVM-BADOwY==aYiUegd0uhEnACQ@mail.gmail.com>
References: <1318454295-20573-1-git-send-email-zajec5@gmail.com>
	<CA+icZUXzPSm8FdqMbAm34GEDVM-BADOwY==aYiUegd0uhEnACQ@mail.gmail.com>
Date: Thu, 13 Oct 2011 06:38:12 +0200
Message-ID: <CACna6rxSAr+Totf6gJ5P5kGnyNsbbXwhf-rpEmnRBQJ__2ivGg@mail.gmail.com> (sfid-20111013_063818_545134_4200974D)
Subject: Re: [PATCH 3.2 1/2] Revert "b43: trivial: do not report any link
 quality instead of invalid one"
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: sedat.dilek@gmail.com
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 13 października 2011 00:22 użytkownik Sedat Dilek
<sedat.dilek@googlemail.com> napisał:
> 2011/10/12 Rafał Miłecki <zajec5@gmail.com>:
>> This reverts commit 55ad5962e97430c83d51df36fc18865ee4f78c48.
>>
>> I assumed N is newer than LP, which isn't true. This regressed LP case.
>>
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> ---
>> It seems that wasn't so "trivial", sorry for this regression :|
>> ---
>>  drivers/net/wireless/b43/xmit.c |   12 +++++-------
>>  1 files changed, 5 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
>> index 5f812d1..b8de62c 100644
>> --- a/drivers/net/wireless/b43/xmit.c
>> +++ b/drivers/net/wireless/b43/xmit.c
>> @@ -735,13 +735,11 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
>>        }
>>
>>        /* Link quality statistics */
>> -       if ((chanstat & B43_RX_CHAN_PHYTYPE) >= B43_PHYTYPE_N) {
>> -               /*
>> -               s8 rssi = max(rxhdr->power0, rxhdr->power1);
>> -               TODO: Find out what the rssi value is (dBm or percentage?)
>> -                     and also find out what the maximum possible value is.
>> -                     Fill status.ssi and status.signal fields.
>> -               */
>> +       if ((chanstat & B43_RX_CHAN_PHYTYPE) == B43_PHYTYPE_N) {
>> +//             s8 rssi = max(rxhdr->power0, rxhdr->power1);
>> +               //TODO: Find out what the rssi value is (dBm or percentage?)
>> +               //      and also find out what the maximum possible value is.
>> +               //      Fill status.ssi and status.signal fields.
>>        } else {
>>                status.signal = b43_rssi_postprocess(dev, rxhdr->jssi,
>>                                                  (phystat0 & B43_RX_PHYST0_OFDM),
>> --
>> 1.7.3.4
>>
>
> Commenting style?
> Isn't C99-like commenting not well seen?

This is simple revert, the code was like that before my patch.

My 2/2 patch remove that ugly commenting style.

-- 
Rafał
