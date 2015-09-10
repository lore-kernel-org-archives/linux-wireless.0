Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:34016 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbbIJQnk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2015 12:43:40 -0400
Received: by iofb144 with SMTP id b144so68037734iof.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2015 09:43:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1738409.B3jGDQ6NWL@debian64>
References: <1441908285-606-1-git-send-email-hiroaki.kawai@gmail.com>
	<1738409.B3jGDQ6NWL@debian64>
Date: Fri, 11 Sep 2015 01:43:39 +0900
Message-ID: <CABD3daqOY4MvbWMZGeouFL7an9_446hpxrcWUesEVzC5021pOg@mail.gmail.com> (sfid-20150910_184343_469279_94D734C9)
Subject: Re: [PATCH] carl9170: fix bad rssi reading
From: Hiroaki Kawai <hiroaki.kawai@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

That field is union and referenced as rssi_combined at two lines below.

The status->signal will show up in radiotap IEEE80211_RADIOTAP_DBM_ANTSIGNAL
header field at userland finally.

2015-09-10 22:07 GMT+09:00 Christian Lamparter <chunkeey@googlemail.com>:
> On Thursday, September 10, 2015 06:04:45 PM Hiroaki KAWAI wrote:
>> Fix rssi calculation error which was introduced in otus to ar9170
>> porting.
>>
>> Signed-off-by: Hiroaki KAWAI <hiroaki.kawai@gmail.com>
> Acked-by: Christian Lamparter <chunkeey@googlemail.com>
>
> For reference: Here's the line in the original otus code:
> <http://lxr.free-electrons.com/source/drivers/staging/otus/hal/hpusb.c?v=2.6.33#L818>
>
> This value/result isn't used anywhere, so we could also remove it.
>
>> ---
>>  drivers/net/wireless/ath/carl9170/rx.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/ath/carl9170/rx.c b/drivers/net/wireless/ath/carl9170/rx.c
>> index 924135b..d66533c 100644
>> --- a/drivers/net/wireless/ath/carl9170/rx.c
>> +++ b/drivers/net/wireless/ath/carl9170/rx.c
>> @@ -453,7 +453,7 @@ static void carl9170_rx_phy_status(struct ar9170 *ar,
>>       /* post-process RSSI */
>>       for (i = 0; i < 7; i++)
>>               if (phy->rssi[i] & 0x80)
>> -                     phy->rssi[i] = ((phy->rssi[i] & 0x7f) + 1) & 0x7f;
>> +                     phy->rssi[i] = ((~phy->rssi[i] & 0x7f) + 1) & 0x7f;
>>
>>       /* TODO: we could do something with phy_errors */
>>       status->signal = ar->noise[0] + phy->rssi_combined;
>>
>
