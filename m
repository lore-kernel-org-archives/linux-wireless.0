Return-Path: <SRS0=mfDp=N2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 943CEC43441
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 17:24:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5696A21582
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 17:24:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="WLMS9fgB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5696A21582
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toke.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388351AbeKPDdK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 15 Nov 2018 22:33:10 -0500
Received: from mail.toke.dk ([52.28.52.200]:44483 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388265AbeKPDdJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Nov 2018 22:33:09 -0500
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1542302665; bh=+61GhQNjnU8wdyMTs/FDeoj8smhkEy+LIIT7JyOcQ8I=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=WLMS9fgBj7/v8CdJxutgr4scinP9Us1dkY6uB3ClTzI6CLvv5qyQZnJBC+2LF5HgK
         ux+LLl6G6Y6qqNjuUOGnZBFGpZaCH7300v/U6mIP1/m1bwFszCL+MWiDFWcDQ7qz/t
         6t0dYkbjYJ+zu1thTtxucSt4bn+Qmoq6TBrewo58TAVGZ+pI0tOs0YO55SonK9Zogs
         KbxiUq8Adg3uuVf+VlNNfp4/YBF5oX/wPLg8ytZkIJIIxhdLu/FlK2955OxZKY8xMm
         1LWZoBCGOivT2i+KhcMT7Gx6ORIWDcuk2afSdvrNT7l5qYZyXMZtwyRzQMLDl+z0EC
         yfNDQQlr1KXtg==
To:     Felix Fietkau <nbd@nbd.name>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Cc:     make-wifi-fast@lists.bufferbloat.net
Subject: Re: [PATCH v3 3/6] mac80211: Add airtime accounting and scheduling to TXQs
In-Reply-To: <8e7847ff-4c88-10ae-2223-2fc7321641d9@nbd.name>
References: <1542063113-22438-1-git-send-email-rmanohar@codeaurora.org> <1542063113-22438-4-git-send-email-rmanohar@codeaurora.org> <e5344cad-2a18-a938-f2ed-43870027251c@nbd.name> <871s7nv9pl.fsf@toke.dk> <8e7847ff-4c88-10ae-2223-2fc7321641d9@nbd.name>
Date:   Thu, 15 Nov 2018 09:24:22 -0800
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87sh02tfsp.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> On 2018-11-14 18:40, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>> This part doesn't really make much sense to me, but maybe I'm
>>> misunderstanding how the code works.
>>> Let's assume we have a driver like ath9k or mt76, which tries to keep a
>>> number of aggregates in the hardware queue, and the hardware queue is
>>> currently empty.
>>> If the current txq entry is kept at the head of the schedule list,
>>> wouldn't the code just pull from that one over and over again, until
>>> enough packets are transmitted by the hardware and their tx status
>>> processed?
>>> It seems to me that while fairness is still preserved in the long run,
>>> this could lead to rather bursty scheduling, which may not be
>>> particularly latency friendly.
>>=20
>> Yes, it'll be a bit more bursty when the hardware queue is completely
>> empty. However, when a TX completion comes back, that will adjust the
>> deficit of that sta and cause it to be rotated on the next dequeue. This
>> obviously relies on the fact that the lower-level hardware queue is
>> sufficiently shallow to not add a lot of latency. But we want that to be
>> the case anyway. In practice, it works quite well for ath9k, but not so
>> well for ath10k because it has a large buffer in firmware.
>>=20
>> If we requeue the TXQ at the end of the list, a station that is taking
>> up too much airtime will fail to be throttled properly, so the
>> queue-at-head is kinda needed to ensure fairness...
> Thanks for the explanation, that makes sense to me. I have an idea on
> how to mitigate the burstiness within the driver. I'll write it down in
> pseudocode, please let me know if you think that'll work.

I don't think it will, unfortunately. For example, consider the case
where there are two stations queued; one with a large negative deficit
(say, -10ms), and one with a positive deficit.

In this case, we really need to throttle the station with a negative
deficit. But if the driver loops and caches txqs, we'll get something
like the following:

- First driver loop iteration: returns TXQ with positive deficit.
- Second driver loop iteration: Only the negative-deficit TXQ is in the
  mac80211 list, so it will loop until that TXQ's deficit turns positive
  and return it.

Because of this, the negative-deficit station won't be throttled, and we
won't get fairness.

How many frames will mt76 queue up below the driver point? I.e., how
much burstiness are you expecting this will introduce on that driver?

Taking a step back, it's clear that it would be good to be able to
dequeue packets to multiple STAs at once (we need that for MU-MIMO on
ath10k as well). However, I don't think we can do that with the
round-robin fairness scheduler; so we are going to need a different
algorithm. I *think* it may be possible to do this with a virtual-time
scheduler, but I haven't sat down and worked out the details yet...

-Toke
