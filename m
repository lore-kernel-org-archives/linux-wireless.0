Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:51516 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbZKQWES convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 17:04:18 -0500
Received: by iwn8 with SMTP id 8so398918iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 17 Nov 2009 14:04:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B031B48.1090105@roinet.com>
References: <2205.95.222.251.107.1258282369.squirrel@webmail.otaku42.de>
	<43e72e890911161701p61d0db5ag25a1459f900b3ab7@mail.gmail.com>
	<4B02DFF4.1060509@roinet.com> <45e8e6c40911171257m7c687380k6e6e2677fd11f851@mail.gmail.com>
	<43e72e890911171337p4b0d97fcp844266137bb51b56@mail.gmail.com>
	<4B03193E.2080304@roinet.com> <43e72e890911171345q2dc59d66g6ac2a9eec04c577c@mail.gmail.com>
	<4B031B48.1090105@roinet.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 17 Nov 2009 14:04:04 -0800
Message-ID: <43e72e890911171404x1a46d07alb54946768d0f9cf5@mail.gmail.com>
Subject: Re: [Madwifi-devel] Survey: What are you using MadWifi for, and why?
To: David Acker <dacker@roinet.com>
Cc: Andrey Yurovsky <andrey@cozybit.com>,
	Michael Renzmann <mrenzmann@madwifi-project.org>,
	madwifi-devel@lists.sourceforge.net,
	madwifi-users@lists.sourceforge.net,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 17, 2009 at 1:53 PM, David Acker <dacker@roinet.com> wrote:
> Luis R. Rodriguez wrote:
>>
>> On Tue, Nov 17, 2009 at 1:44 PM, David Acker <dacker@roinet.com> wrote:
>>>
>>> It is a non-802.11s protocol that predates 802.11s development by quite
>>> awhile.  It runs over WDS links.  In theory it could run over anything
>>> that
>>> supports dynamic creation and destruction of WDS links.
>>
>> So its a some sort of MadWifi-only hack?
>
> Not at all.  The algorithm runs in user space

OK so not relevant.

> The problem with switching to ath5k would be the loss of performance related
> features (compression, fast frames, turbo),

These are different than "mesh".

> and some required features
> (half/quarter rates are required for some channels on some radios).

How does "mesh" relate to this?

> Also, I
> don't know if ath5k will work on products based on Atheros WiSOCs like
> Ubiquiti's PicoStation and Bullet.

ath5k does not *yet* have SoC support but it may get it at later point.

So let me get this straight.

You have SoC Atheros solutions that use some userspace custom (not
802.11s) solution that use fast frames, compression and turbo, oh and
half/quarter rates? WTF are you doing?

> A lesser issue (more of a pain for me
> than an ath5k issue) is that I have some platforms that use an older kernel
> and moving up to a newer kernel will have to be done without hardware vendor
> support.

For backporting we have compat-wireless, it should allow you to use
even today's bleeding edge even on 2.6.25. It should be possible to
bring this down to 2.6.21 even but not many people are interested in
that it seems. Patches are welcomed though.

  Luis
