Return-Path: <SRS0=MtVb=O3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0A54C43387
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 19:19:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 753662184C
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 19:19:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="xZ43BixQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726914AbeLRTTZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 18 Dec 2018 14:19:25 -0500
Received: from mail.toke.dk ([52.28.52.200]:55733 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726600AbeLRTTZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Dec 2018 14:19:25 -0500
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1545160763; bh=GqsMS3ElIA3PSRhZpzxFTUnGgEDmN94KCYxOyKI0zEs=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=xZ43BixQ3aSRf3/h1iJJ7++7IA9js/QkYgMcZsUmB1lEf7GzG2Q2IO5uV5hc/wUxv
         1Lp4SBlOh1nKFjsK1XH3FHKzK49NPGWZvwaojjfrHKPBq9Cwu++Oc55v8uRx93VxZJ
         UaGe77p201mHXFFmyy8X9HJfSvh+rBuiibKTtm2PS+QQDkzbShDD1lH8pbrqfuCgrm
         eiD7GUDHIRTNVIhWqF5uEk9skKRuC3xNsE4YcR8Fy20Me8VWqqDTL6vE8DCY4BIRNh
         KTjkttdSRyL6OrUFeAB65fKSyPMJNEPWcFNeQppzZDLYYgMrJgC1g/SsaPRKAnop0Y
         Kj6GKXch10tMw==
To:     Johannes Berg <johannes@sipsolutions.net>, Louie Lu <me@louie.lu>,
        rmanohar@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        make-wifi-fast@lists.bufferbloat.net
Subject: Re: [Make-wifi-fast] [PATCH v3 3/6] mac80211: Add airtime accounting and scheduling to TXQs
In-Reply-To: <5d46e8942ea151b211651588db3dacb97e6e5a53.camel@sipsolutions.net>
References: <1542063113-22438-1-git-send-email-rmanohar@codeaurora.org> <1542063113-22438-4-git-send-email-rmanohar@codeaurora.org> <CADMDV=zX4NuyDS+C==c8iq7FagGLFOoQ-Fjf=x-zmehJAz8=zQ@mail.gmail.com> <87va4ytgff.fsf@toke.dk> <5d46e8942ea151b211651588db3dacb97e6e5a53.camel@sipsolutions.net>
Date:   Tue, 18 Dec 2018 20:19:18 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87a7l2hccp.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2018-11-15 at 09:10 -0800, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Louie Lu <me@louie.lu> writes:
>>=20
>> > Hi Rajkumar, Toke,
>> >=20
>> > I found the series (v3,4/6) remove the debugfs remove reset station's
>> > airtime method, and didn't added at here.
>> >=20
>> > Not sure how to help this kind of situation, do I need a separate
>> > patch to fix this, or posting the patch here is fine?
>>=20
>> This is fine; we can fold it into the next version. Thanks :)
>
> Just FYI - I'm going to assume, given this comment and the long
> discussion, that there will be a next version :)

Yes. Got caught up in moving before I managed to get another version
out. Will get around to it eventually, promise! :)

-Toke
