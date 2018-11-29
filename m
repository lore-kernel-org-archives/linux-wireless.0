Return-Path: <SRS0=Li3M=OI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2E38C43441
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 13:48:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF18420868
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 13:48:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="O5KQ//FP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF18420868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toke.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbeK3AyJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Nov 2018 19:54:09 -0500
Received: from mail.toke.dk ([52.28.52.200]:52655 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726736AbeK3AyJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Nov 2018 19:54:09 -0500
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1543499322; bh=3uiRjPFgWsWtUgd4C98r9WHNzxqcV0vbuvYbfM3108E=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=O5KQ//FPablQrRteomCIKMbp9pp5AtPj6+9a+nLdFBdo+fvp+JE4pYqHJRxzHBdRc
         gpTLHPafXIIZ0PAFpaQT+pdH8yhsqMpWs4KmvYEtrbPWMt/nbU8UyLafOMLOfIh4jN
         ZPQwp5kD/4aRuv93SA8k0MG48u1rYqsoyoig2SMDv5xIHEmWPLBl60V0z2DtscSQyc
         bn1c1QVkF2scAByAJOAK016GETgqPAOnEJMoYumqTykkps0anbQs4r55Grt5hCbsgJ
         D2h912s9Ez6g1mRXoI7Na4n4wXOHpxYuJtmxOVQNlMOorE+TZ7LNQIsHr/dywajFQ9
         fMxgqrIlU4arg==
To:     =?utf-8?Q?Micha=C5=82?= Kazior <kazikcz@gmail.com>
Cc:     lorenzo.bianconi@redhat.com, brouer@redhat.com,
        kvalo@codeaurora.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>, borkmann@iogearbox.net,
        alexei.starovoitov@gmail.com,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [RFC 0/5] add XDP support to mt76x2e/mt76x0e drivers
In-Reply-To: <CABvG-CVFYNaytwaUj9YGVUp38DBP9CVYkoU6EKvbJBPNmtK0Ag@mail.gmail.com>
References: <cover.1543343124.git.lorenzo.bianconi@redhat.com> <8736rla4ow.fsf@purkki.adurom.net> <20181128104436.GA2298@localhost.localdomain> <87bm69v0ol.fsf@toke.dk> <20181128164306.0135ca83@redhat.com> <20181129103054.GA6365@localhost.localdomain> <87sgzkqaip.fsf@toke.dk> <CABvG-CVFYNaytwaUj9YGVUp38DBP9CVYkoU6EKvbJBPNmtK0Ag@mail.gmail.com>
Date:   Thu, 29 Nov 2018 14:48:42 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87mupsq9j9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Micha=C5=82 Kazior <kazikcz@gmail.com> writes:

> On Thu, 29 Nov 2018 at 14:31, Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke=
.dk> wrote:
> [...]
>> >> Option#3 is to say, Wifi XDP is so different that we should create a
>> >> new (enum) bpf_prog_type.  And then still see if we can leverage some
>> >> of the same core-code (as long as it doesn't slowdown performance).
>> >>
>> >
>> > Do you think that Option#3 will be more 'future-proof' respect to
>> > Option#1?
>>
>> My feeling is that WiFi devices are not sufficiently different to
>> warrant a whole new program type. We risk combinatorial explosion for
>> all the stuff that is the same, but now need to be tested for two (or N)
>> types...
>
> I'm not sure if my understanding is correct, but XDP seems like it can
> (and intends to be able to?) act as a general purpose packet
> accelerator (REDIRECT action was mentioned so I'm inferring..). In
> such case you'll need to be able to perform transformations on packets
> too, e.g. strip/prepend vlan tags, gre headers and what have you. The
> 802.3 <-> 802.11 conversion could be treated on equal terms.

Sure, that is perfectly possible. It just needs to be implemented by the
eBPF program being loaded; and there is a facility to shrink/expand the
packet size for encapsulation processing. It's just that since currently
all interfaces process Ethernet frames, this frame type assumption has
kinda been built in. So something needs to be done to handle that.

The minimum is just to ignore the issue and make it up to the program
writer to handle this or risk breaking things, but something a bit
friendlier (such as an ability for the loaded program to indicate which
frame type it is prepared to handle, which can be sanity-checked by the
loader) might be a good idea... Especially if different WiFi devices
will emit different frame types (so we can't just go "it's a WiFi
device, you should know this").

Then there's the additional issue that since mac80211 and/or the driver
may have internal state, we need to expose appropriate helpers for an
XDP program to be able to update this as it's processing packets (before
bypassing the stack, for instance).

-Toke
