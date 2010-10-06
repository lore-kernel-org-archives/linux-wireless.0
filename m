Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62441 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758136Ab0JFBOK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 21:14:10 -0400
Received: by iwn5 with SMTP id 5so9024710iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 05 Oct 2010 18:14:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201010061010.46430.br1@einfach.org>
References: <20101005095510.3083.46174.stgit@tt-desk> <20101005095521.3083.87663.stgit@tt-desk>
 <20101005201407.GI11831@tux> <201010061010.46430.br1@einfach.org>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 5 Oct 2010 18:13:49 -0700
Message-ID: <AANLkTimsfQuaDKK-HW1OOi6srOuKbbihQiw37KJMTzyH@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH 3/5] ath9k: Use common cycle counters
To: Bruno Randolf <br1@einfach.org>
Cc: Vasanth Thiagarajan <Vasanth.Thiagarajan@atheros.com>,
	"adrian@freebsd.org" <adrian@freebsd.org>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 5, 2010 at 6:10 PM, Bruno Randolf <br1@einfach.org> wrote:
> On Wed October 6 2010 05:14:07 Luis R. Rodriguez wrote:
>> On Tue, Oct 05, 2010 at 02:55:21AM -0700, Bruno Randolf wrote:
>> > Update ath9k to use the common cycle counters.
>> >
>> > This also includes other changes from Felix Fietkaus "[PATCH 2/4]
>> > ath9k_hw: merge codepaths that access the cycle counter registers".
>> >
>> > Compile tested only. ath9k team please review...
>>
>> Can you move locking to be specific to the core part of
>> the driver instead of the ath9k_hw ?
>
> i'm not sure if i understand what you mean. locking is now implemented in
> ath_common.

Hrm...

>> We try to avoid locking
>> all over the hardware code. Even ath9k_iowrite32() and
>> ath9k_ioread32() are core driver helpers, not part of the
>> hw code.
>
> but, we need to make sure the cycle counters are always accessed exclusively.
> e.g. ANI runs from a timer (in ath9k, afaik), and updates the cycle counters.
> at the same time a user might issue a survey, or your debug print may be
> executed, which would want to access the same counters. we need to make sure
> the counters are not updated while they are read, etc...

That's fine, its just please keep any spin_lock calls away from ath9k_hw module.

  Luis
