Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF865C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 11:03:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 823572159D
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 11:03:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="XacXKJzt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 823572159D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toke.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729329AbeI1R0N (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:26:13 -0400
Received: from mail.toke.dk ([52.28.52.200]:37437 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729008AbeI1R0N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 13:26:13 -0400
Date:   Fri, 28 Sep 2018 13:02:55 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1538132577; bh=wsJ6ZQ4XkGA+4C5JFTWeawe1oV9yeOmJ21hgjBTlf6A=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=XacXKJztAAM0GA+Y4vduvaI9X5ro7iO70ntXiHoGeOKt54LGzOY3hRfvj7DAd02Hx
         4t6+G2UXth+yD6jMbTZQ5mHlAxn7hVanqz7Oi4u+UYL06C1X10OPvhDBA9zHcrb1bu
         ThjM+LmdDasqymdjQTl+5QDvY0RIEkP3hvOrR50HCRmLdq2A5S2RJsnqHbRMWhurRv
         DzT2qtJr/sdQcrkTXjsggWXwRNcXjb2x8bvwV1u00YYTOFtmE5aEzIcHUmtxvRz+2j
         D0jz0Ut2e8ni0uhJfbNqRCohi1Ngc/uyje9V2rsCSmaV7vmBlDEgfmw8CiPp36TIHC
         1SQYsnfBVmUEg==
In-Reply-To: <586459da6ec36edc2284df8533915d62@codeaurora.org>
References: <153711966150.9231.13481453399723518107.stgit@alrua-x1> <153711973134.9231.18038849900399644494.stgit@alrua-x1.karlstad.toke.dk> <826b6251746ee4d280d532f4ecdc5aa3@codeaurora.org> <87pnx0haud.fsf@toke.dk> <8f7145bf5abe50194bced025a5e739b9@codeaurora.org> <863bc54fbf04441d38dd53f523300a7e@codeaurora.org> <93015743-5D16-4D79-948F-E2F46CF2450A@toke.dk> <7ba8513b0ec5a7c35b396c7739fc2d7d@codeaurora.org> <87zhw2eyfo.fsf@toke.dk> <5d961a5f61de45b85b1b037bcef9270d@codeaurora.org> <44B09168-C08F-4C85-8D74-D576CCC79880@gmail.com> <586459da6ec36edc2284df8533915d62@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Make-wifi-fast] [PATCH RFC v4 3/4] mac80211: Add airtime accounting and scheduling to TXQs
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Jonathan Morton <chromatix99@gmail.com>
CC:     Kan Yan <kyan@google.com>, make-wifi-fast@lists.bufferbloat.net,
        linux-wireless-owner@vger.kernel.org,
        linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
From:   =?ISO-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@toke.dk>
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <4929C006-3452-4C17-9500-8D7485EB538E@toke.dk>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 28 September 2018 12:47:51 CEST, Rajkumar Manoharan <rmanohar@codeauror=
a=2Eorg> wrote:
>On 2018-09-28 03:35, Jonathan Morton wrote:
>>> On 28 Sep, 2018, at 1:19 pm, Rajkumar Manoharan=20
>>> <rmanohar@codeaurora=2Eorg> wrote:
>>>=20
>>>> This is going to break fairness; we only want to increase deficits=20
>>>> when
>>>> all stations' deficits are negative=2E Hence the two loops=2E Did you
>see
>>>> any problems with those specifically?
>>>=20
>>> No=2E I didn't see any issue but the loop won't exit until one txq=20
>>> becomes positive=2E
>>> Till then the lock won't be released=2E Hence I converged into single=
=20
>>> iteration=2E
>>=20
>> The problem is that the fairness behaviour is changed when there are
>> already positive txqs, but the first one happens to not be positive=2E
>> That's why there were two loops=2E
>>=20
>Yeah=2E=2E Understood=2E we can ignore the cleanup change=2E

Great! I'll fold in the rest, test it with ath9k and submit as a proper pa=
tch :)

-Toke
