Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89ECFC43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 09:04:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B930215EB
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 09:04:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="M/s0nxfm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2B930215EB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toke.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728944AbeI1P1M (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 11:27:12 -0400
Received: from mail.toke.dk ([52.28.52.200]:38193 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbeI1P1M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 11:27:12 -0400
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1538125464; bh=CRs3mB0TfBB0vzX9QUaDyH4VopRtcUTVxr7MpUAh6gM=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=M/s0nxfmpnDz/SScodF1v2/KKguEiHp0MntLQ+UgiZMB7Aqe+q2CP1IAW/8ypfC+M
         ZPVlw3YuQ6umcaZy9uJq+av7AmS0JTNXj37vnxVQMrXwaTySbl+h4tAdJJ01OTTpHx
         9j/mridv8bA3qKS+pua5BtB3N7a9ZqXusqKrtg+hEIOzbmxggWwrww/zDfIpU6B97S
         ZWR2bksVN+L4gx7RNqH3X1Db9LFoZBAgXTVBqY23i/7yV1RZ8+U095zTs37duJKG2s
         AEvph5uB66Nwxe2T0HNwMqEjR7cnmux2+sX9JjoQcUtyOtrBb3hW21bY1wLmHCp1fs
         V0+NkbeY//mDQ==
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] mac80211: TDLS: fix skb queue/priority assignment
In-Reply-To: <1538119050.14416.55.camel@sipsolutions.net>
References: <20180905113402.7665-1-johannes@sipsolutions.net> <1536147453.3528.11.camel@sipsolutions.net> <87k1o05g04.fsf@toke.dk> <1536147683.3528.12.camel@sipsolutions.net> <1536147865.3528.14.camel@sipsolutions.net> <87efe8yvju.fsf@toke.dk> <1536150812.3528.15.camel@sipsolutions.net> <87bm9cyuou.fsf@toke.dk> <1538119050.14416.55.camel@sipsolutions.net>
Date:   Fri, 28 Sep 2018 11:04:23 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87mus2at7s.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2018-09-05 at 14:50 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>
> (uh, sorry, bit late ...)
>
>> > The problem isn't so much how we handle it in mac80211 for the queuein=
g,
>> > but how we deal with things like A-MSDU and how we present it to the
>> > driver ... for iwlwifi at least we'd really like to have only data
>> > frames so we can map it directly to the hardware queue ...
>>=20
>> Ah, I see. No, then just putting them at the head of a different TXQ
>> probably won't work...
>>=20
>> Are you mapping TXQs to hardware queues dynamically as they empty and
>> re-fill? Presumably you'll have cases where you don't have enough HWQs?
>
> Depends on the hardware. Newer hardware has basically unlimited HWQs
> (something on the order of 512 IIRC).
>
> Older hardware sort of maps them dynamically, but not too dynamic, we
> also have 32 (ish) queues there. We only free them if we need a new one
> and don't have one, and yes, theoretically we can run out and then we
> may have to share a single hardware queue for multiple TXQs, but it
> basically never happens in practice.

Right, gotcha, thanks for the explanation :)

-Toke
