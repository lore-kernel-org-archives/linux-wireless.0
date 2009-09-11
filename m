Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:40530 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531AbZIKRnX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 13:43:23 -0400
Received: by iwn8 with SMTP id 8so549222iwn.4
        for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2009 10:43:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.01.0909110720210.3654@localhost.localdomain>
References: <1252632895-11914-1-git-send-email-lrodriguez@atheros.com>
	<1252632895-11914-4-git-send-email-lrodriguez@atheros.com>
	<40f31dec0909102316q7902098jbee7fd8d17c3f622@mail.gmail.com>
	<4AA9F22C.3090007@gmail.com> <43e72e890909110023k62a512bejd712a3449cc8328d@mail.gmail.com>
	<alpine.LFD.2.01.0909110720210.3654@localhost.localdomain>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 11 Sep 2009 10:43:06 -0700
Message-ID: <43e72e890909111043m78411058i86e61909a35412f@mail.gmail.com>
Subject: Re: [PATCH 3/4] ath5k: define ath_common ops
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: devel@driverdev.osuosl.org, ath9k-devel@venema.h4ckr.net,
	Jeff Garzik <jeff@garzik.org>, linux-wireless@vger.kernel.org,
	Nick Kossifidis <mickflemm@gmail.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 11, 2009 at 7:24 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Fri, 11 Sep 2009, Luis R. Rodriguez wrote:
>>
>> That is the way I had it originally before submission, and I
>> completely agree its reasonable to not incur additional cost at the
>> expense of having two separate read/write paths, and perhaps we should
>> only incur the extra cost on routines shared between
>> ath9k/ath9k/ath9k_htc. But -- is there really is a measurable cost
>> penalty?
>
> There's a measurable size penalty, at least.

My tests so far yield no performance difference but I'm sure there is
some, maybe as Jouni noted, more visible on embedded systems.

> In fact, if you know what kind of IO op it is (ie "it's always MMIO"),
> you'd be even better using "writel()" directly,

Heh.. you realize I tried to document such a thing a while ago and it
seems you opposed it [1]?

[1] http://lkml.indiana.edu/hypermail/linux/kernel/0709.2/0593.html

  Luis
