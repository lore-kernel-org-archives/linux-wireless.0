Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.6 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61378C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 07:52:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10C7621748
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 07:52:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="uw1gTQ71"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 10C7621748
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toke.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728883AbeI1OO0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 10:14:26 -0400
Received: from mail.toke.dk ([52.28.52.200]:56995 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728376AbeI1OO0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 10:14:26 -0400
Date:   Fri, 28 Sep 2018 09:51:55 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1538121116; bh=vtK1zDr0EAG5AZ4i9XMILu7fJqnYCpBb3LDf8Hhyxj8=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=uw1gTQ71d+Rm0VneTHf3w60LZUSrtePgOhCkym1dFIdoDE+ej5DiYVKBpCVvUdbrv
         ek3SuN8U9EGhZ4IFXydxLmuMpsvDeYpDpIWUlWOqCOrOnHfN6JP3hefU4gIEIXU21A
         0UeVehstKjR93Dqm90exo4aZxLWveHzETPKmGmWGYJ3+g+xclicAOKxx5KN+Fulbkh
         bjMaMulfO3/JNa5otBJOlLEZbA3lTOCOqthBHty5iuf3BVy890qkEsqo587l09xOCy
         mCE1flFj9uEjYAAc+tIbX09DpXjlArtosG34GUliVdWeZrTIHpk8Y3EbUplgCbjgwa
         kYbM+TXiTuqeQ==
In-Reply-To: <863bc54fbf04441d38dd53f523300a7e@codeaurora.org>
References: <153711966150.9231.13481453399723518107.stgit@alrua-x1> <153711973134.9231.18038849900399644494.stgit@alrua-x1.karlstad.toke.dk> <826b6251746ee4d280d532f4ecdc5aa3@codeaurora.org> <87pnx0haud.fsf@toke.dk> <8f7145bf5abe50194bced025a5e739b9@codeaurora.org> <863bc54fbf04441d38dd53f523300a7e@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH RFC v4 3/4] mac80211: Add airtime accounting and scheduling to TXQs
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>
CC:     linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        Kan Yan <kyan@google.com>, linux-wireless-owner@vger.kernel.org
From:   =?ISO-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@toke.dk>
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <93015743-5D16-4D79-948F-E2F46CF2450A@toke.dk>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 28 September 2018 07:29:03 CEST, Rajkumar Manoharan <rmanohar@codeauror=
a=2Eorg> wrote:
>On 2018-09-26 17:09, Rajkumar Manoharan wrote:
>> On 2018-09-26 02:22, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>> Rajkumar Manoharan <rmanohar@codeaurora=2Eorg> writes:
>
>> :( Yeah=2E=2E=2E I got confused with attached soft lockup in ARM platfo=
rm=2E
>>=20
>Toke,
>
>Cause for the soft lockup exposed in multi client scenario is due to
>mixed order of fq_lock and active_txqs_lock=2E In wake_tx_queue or=20
>push_pending
>case, driver acquires active_txq_lock first by schedule_start and=20
>followed by
>fq_lock in tx_dequeue=2E The same order should be maintained in sta=20
>cleanup=2E
>Below change fixed the issue=2E

Ah, great find! I'll fold this into the next version, thanks!

-Toke
