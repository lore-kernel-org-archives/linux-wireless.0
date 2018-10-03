Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A10A0C00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 08:41:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A95320684
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 08:41:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="n2+DPPfC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3A95320684
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toke.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727216AbeJCP2m (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 11:28:42 -0400
Received: from mail.toke.dk ([52.28.52.200]:50531 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727001AbeJCP2l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 11:28:41 -0400
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1538556077; bh=XelobgcAyHyNTIb7hBc/SCUKZ2qrU4b5tBJr0Fqe5Ig=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=n2+DPPfCs9h8hgljoYtu69JBwoXgp4FdlhwmVusIVFy03b4DKb4mn1vf41L9lkiiB
         wzO+72gURrhKHiCq5iR8a0HWqSqWPCkEv23vU86Hh5qi6wbvAYDPGereQaC6msZ0N1
         QqKrO0S8yX09wTnORFJGob/OXU6BfFJVvpi/Z7q37HGl1qduknnqJMQo/EsAtNOr+1
         qvkA/GYEtt9mrudx1nSL0YuuS5mgo6pEoPAxoO/O2dv51qkWzdSFCoIDfmZ2PNPRJL
         CuaoD8FHXb3/l7K/96z3Fiui4UGX20uJdZ8QMVNy6Q8A5lvfRz28F2bbrQl0S06HKP
         C7quJJsckB6Sw==
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc:     Jonathan Morton <chromatix99@gmail.com>, Kan Yan <kyan@google.com>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless-owner@vger.kernel.org,
        linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
Subject: Re: [Make-wifi-fast] [PATCH RFC v4 3/4] mac80211: Add airtime accounting and scheduling to TXQs
In-Reply-To: <08dabe69e625c11f70b217ae9695c7f4@codeaurora.org>
References: <153711966150.9231.13481453399723518107.stgit@alrua-x1> <153711973134.9231.18038849900399644494.stgit@alrua-x1.karlstad.toke.dk> <826b6251746ee4d280d532f4ecdc5aa3@codeaurora.org> <87pnx0haud.fsf@toke.dk> <8f7145bf5abe50194bced025a5e739b9@codeaurora.org> <863bc54fbf04441d38dd53f523300a7e@codeaurora.org> <93015743-5D16-4D79-948F-E2F46CF2450A@toke.dk> <7ba8513b0ec5a7c35b396c7739fc2d7d@codeaurora.org> <87zhw2eyfo.fsf@toke.dk> <5d961a5f61de45b85b1b037bcef9270d@codeaurora.org> <44B09168-C08F-4C85-8D74-D576CCC79880@gmail.com> <586459da6ec36edc2284df8533915d62@codeaurora.org> <4929C006-3452-4C17-9500-8D7485EB538E@toke.dk> <0531def170ef7f9cadcf85a6dc9af22b@codeaurora.org> <87a7nwbvwu.fsf@toke.dk> <a5a7e11d6913c32385cc74ea3d0e1c76@codeaurora.org> <877ej0b2d8.fsf@toke.dk> <30cf3754fa970aa1af11791c2625a7c9@codeaurora.org> <08dabe69e625c11f70b217ae9695c7f4@codeaurora.org>
Date:   Wed, 03 Oct 2018 10:41:16 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87d0sre82b.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

> On 2018-10-02 16:07, Rajkumar Manoharan wrote:
>> On 2018-10-02 12:00, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
>>>> I noticed a race condition b/w sta cleanup and kick_airtime tasklet.
>>>>>> How do you plan to exit kick_airtime gracefully during sta_cleanup?
>>>>>=20
>>>>> Ah, right, there's a lot of stuff going on before we get to=20
>>>>> purge_txq.
>>>>> Hmm, I guess we should either make sure we remove the station from
>>>>> active_txqs earlier in the sta cleanup process, or maybe it'd enough=
=20
>>>>> to
>>>>> just check the removed flag in the tasklet?
>>>>>=20
>>>>> Does the below patch fix the issue?
>>>>>=20
>>>>=20
>>>> No. Attaching backtrace. Any clue?
>>>=20
>>> Ah, that's my bad. Just having a 'continue' there can make the=20
>>> function
>>> loop forever. Oops. Try something like this instead?
>>>=20
>>=20
>> But 'continue' also used in other places. Will give a try but I think=20
>> that
>> calling drv_wake_tx_queue within iteration is dangerous as it alters
>> the list. no?
>>=20
> How about below change? Just schedule first txq and remaining will be
> scheduled later by driver upon tx-compl.

Your mail client seems to be mangling the patch somewhat, but I think I
see what your intention is. And yeah, just waking a single TXQ and
letting TX-completion do the rest is a good idea; will fold that into
the next version :)

-Toke
