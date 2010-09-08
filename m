Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37508 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714Ab0IHIMj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 04:12:39 -0400
Received: by qyk36 with SMTP id 36so4303286qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 01:12:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201009080850.22338.helmut.schaa@googlemail.com>
References: <1283902212.5071.11.camel@mj>
	<201009080850.22338.helmut.schaa@googlemail.com>
Date: Wed, 8 Sep 2010 10:12:37 +0200
Message-ID: <AANLkTimFYCKGe2v9JF-aBozoKvHnUDw6B6Uj2K6rAwKk@mail.gmail.com>
Subject: Re: rt61pci: oops in rt2x00lib_txdone(), entry->skb is NULL
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Am Mittwoch 08 September 2010 schrieb Pavel Roskin:
>> wireless-testing.git as of yesterday has a problem with rt61pci.  After
>> a minute of web browsing, the kernel reports an oops in
>> rt2x00lib_txdone() and no more traffic goes through.  That system used
>> to run a month old wireless-testing.git identified as 2.6.35-rc6-wl, and
>> it didn't have that problem.
>>
>> The oops happens on this line:
>> enum data_queue_qid qid = skb_get_queue_mapping(entry->skb);
>>
>> When it happens, entry->skb is NULL.  I cannot reproduce the problem by
>> ping, even by flood ping, but using a web browser on a moderately
>> complex site (e.g. cnn.com) triggers the oops reliably within a minute
>> or so.
>>
>> The architecture is x86_64, it's a multicore system, SMP is enabled in
>> the kernel.
>>
>> If there are no good ideas what it might be, I'll try to find time to
>> bisect the bug.
>
> Seems like this was introduced by "rt2x00: Add helper function for
> reporting tx status". At least the last hunk looks suspicious.
>
> Pavel, could you please try this patch?
>
> Thanks,
> Helmut
>
> diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
> index 8b67cfd..80f80a0 100644
> --- a/drivers/net/wireless/rt2x00/rt61pci.c
> +++ b/drivers/net/wireless/rt2x00/rt61pci.c
> @@ -2106,7 +2106,7 @@ static void rt61pci_txdone(struct rt2x00_dev *rt2x00dev)
>                                "TX status report missed for entry %d\n",
>                                entry_done->entry_idx);
>
> -                       rt2x00lib_txdone_noinfo(entry, TXDONE_UNKNOWN);
> +                       rt2x00lib_txdone_noinfo(entry_done, TXDONE_UNKNOWN);
>                        entry_done = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
>                }
>

Nice catch, this is indeed an obvious bug :S

Ivo
