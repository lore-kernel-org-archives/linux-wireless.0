Return-Path: <SRS0=QiZU=RR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79537C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Mar 2019 22:17:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CA682186A
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Mar 2019 22:17:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbfCNWRQ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Mar 2019 18:17:16 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:46971 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbfCNWRQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Mar 2019 18:17:16 -0400
Received: by mail-ed1-f67.google.com with SMTP id n17so5972521edt.13
        for <linux-wireless@vger.kernel.org>; Thu, 14 Mar 2019 15:17:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=LeJLeR6ZkNvZiB3KOeLrsOCt66tbJgEuzwycjLCtJYg=;
        b=ZgRmTTIEkpIiMFtrLBBj2OjN4pRVg2fFI/aDF0MS0yxb0DXtmDDvOfm+A6WXkXZtOR
         ste80R5r1+bSxt7n+YnonwPCZPyXyLB9qS/ZEvZCDlLZKR4p6PeRS4KdSu7Nqs/YKACC
         teKx/ku5+gVM7F+Wo8Kxrw8l64OFUPZT6X0gRiqayS1PHW0Zw3cI/6SPMdpCd4ciXSzQ
         mRTBpfaM+eC9L2syoasxcotOuKJRw4ZyZFl0PeadRL0XxOG/P0Wu2Ru7G0TY2ZX3pioF
         959bhhrEHr5QvmGVfdKjLU0lMXNZOAouNZFJlyuXpT/y+2lx2TSjNeVLk1qUq+MxE/z/
         XmAg==
X-Gm-Message-State: APjAAAU2qJkTGJzGsD8U4txIH6RlNhGTznymlEQHAFZa/zqCyogpth1n
        VRxeiTa0324im9CdxBA9dG7+tDQrd+Y=
X-Google-Smtp-Source: APXvYqxShZAq3wCREZHsEnbumUh6hz7plMzpJpiegbH+NNHHmOJY2HgFdPCdZ+ZMy0+VzBDlIm4ekQ==
X-Received: by 2002:a50:978e:: with SMTP id e14mr422860edb.234.1552601834439;
        Thu, 14 Mar 2019 15:17:14 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id m5sm32466ejk.8.2019.03.14.15.17.13
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 14 Mar 2019 15:17:13 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6B04B18200B; Thu, 14 Mar 2019 23:17:12 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: Re: [RFC] mac80211: rework locking for txq scheduling / airtime fairness
In-Reply-To: <50e3ab54-4e8c-171c-28f0-7e3ad5a02c99@nbd.name>
References: <20190313181531.62539-1-nbd@nbd.name> <87va0mz8nu.fsf@toke.dk> <50e3ab54-4e8c-171c-28f0-7e3ad5a02c99@nbd.name>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 14 Mar 2019 23:17:12 +0100
Message-ID: <87bm2dxfrr.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> On 2019-03-13 23:55, Toke Høiland-Jørgensen wrote:
>> Felix Fietkau <nbd@nbd.name> writes:
>> 
>>> Holding the lock around the entire duration of tx scheduling can
>>> create some nasty lock contention, especially when processing airtime
>>> information from the tx status or the rx path.
>> 
>> Right, I can see how that could become an issue at higher loads than
>> what I tested with :)
> I stumbled onto this when I was doing perf runs with mt76 (before even
> adding support for this API) and I noticed that a visible amount of lock
> contention was caused by mac80211 tx calls being blocked by mt76 tx
> scheduling.
> I wanted to fix these issues by switching to the mac80211 txq scheduling
> API, but when reading the code I noticed that using this API had the
> very same issue I was trying to fix. That's why I made this patch :)

Ah, I see. Well I applaud you making fixing this and switching over mt76
your solution :)

>>> Improve locking by only holding the active_txq_lock for lookups /
>>> scheduling list modifications.
>> 
>> So the (potential) issue I see with this modification is that it
>> requires the driver to ensure that it will not interleave two different
>> scheduling rounds for the same acno. I.e., another call to
>> schedule_start() will reset the round counter and something needs to
>> guarantee that this doesn't happen until the driver has actually
>> finished the previous round.
>> 
>> I am not sure to what extent this would *actually* be a problem. For
>> ath9k, for instance, there's already the in-driver chan_lock (although
>> the call to ieee80211_txq_schedule_start() would then have to be moved
>> into the section covered by that lock). But it does introduce an
>> implicit dependency in the API, which should at least be documented.
> With ath9k it's also protected by the per-txq lock.

Ah, right, that was just moved not removed entirely. Great!

> With ath10k it's protected by having scheduling calls come from the NAPI
> poll function.

Cool.

>> If memory serves, avoiding this implicit dependency was the original
>> reason I had for adding the full lock around everything. I can't think
>> of any other reason right now, but if I do think of something I'll be
>> sure to let you know :)
> I'll change the patch to make this more explicit and resubmit.
> Thanks for your comments.

Sounds good!

-Toke
