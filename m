Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33920 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbcFQOKY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2016 10:10:24 -0400
Received: by mail-oi0-f68.google.com with SMTP id a64so13936704oii.1
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jun 2016 07:10:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <30beabff-a8c6-5431-be09-8f2f83ffc974@nbd.name>
References: <20160617090929.31606-1-toke@toke.dk> <20160617090929.31606-2-toke@toke.dk>
 <30beabff-a8c6-5431-be09-8f2f83ffc974@nbd.name>
From: Dave Taht <dave.taht@gmail.com>
Date: Fri, 17 Jun 2016 07:10:17 -0700
Message-ID: <CAA93jw78dCOsWnsR8ZuGDZJ6PigmZfU3nr-TjhdA0agH6M3OcQ@mail.gmail.com> (sfid-20160617_161028_005337_67AE88CE)
Subject: Re: [ath9k-devel] [PATCH 1/2] ath9k: use mac80211 intermediate
 software queues
To: Felix Fietkau <nbd@nbd.name>
Cc: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	make-wifi-fast@lists.bufferbloat.net,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Tim Shepard <shep@alum.mit.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>  struct ath_atx_tid {
>>       struct list_head list;
>> +     struct sk_buff_head i_q;
> Do we really need a third queue here? Instead of adding yet another
> layer of queueing here, I think we should even get rid of buf_q.

Less queues, more filling!

>
> Channel context based queue handling can be dealt with by
> stopping/starting relevant queues on channel context changes.

what can be done to reduce the impact of channel scans?

http://blog.cerowrt.org/post/disabling_channel_scans/

> buf_q becomes unnecessary when you remove all code in the drv_tx
> codepath that moves frames to the intermediate queue.
>
> Any frame that was pulled from the intermediate queue and prepared for
> tx, but which can't be sent right now can simply be queued to retry_q.
>
> This will also help with getting the diffstat insertion/deletion ratio
> under control ;)

The ideas here can apply elsewhere, also. Are you still actively
working with the mt76?

Anything else "out there" besides that and the ath5k worth looking at?

Am I seeing patches and firmware changes for better statistic keeping
on the ath10k that look promising for airtime fairness... or am I
delusional?

> elsewhere powersave was mentioned

How big can a powersave queue get?
