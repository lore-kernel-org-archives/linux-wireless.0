Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:55496 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756402AbZKQWjk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 17:39:40 -0500
Received: by iwn8 with SMTP id 8so425112iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 17 Nov 2009 14:39:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B032390.3080501@roinet.com>
References: <2205.95.222.251.107.1258282369.squirrel@webmail.otaku42.de>
	<43e72e890911161701p61d0db5ag25a1459f900b3ab7@mail.gmail.com>
	<4B02DFF4.1060509@roinet.com> <45e8e6c40911171257m7c687380k6e6e2677fd11f851@mail.gmail.com>
	<43e72e890911171337p4b0d97fcp844266137bb51b56@mail.gmail.com>
	<4B03193E.2080304@roinet.com> <43e72e890911171345q2dc59d66g6ac2a9eec04c577c@mail.gmail.com>
	<4B031B48.1090105@roinet.com> <43e72e890911171404x1a46d07alb54946768d0f9cf5@mail.gmail.com>
	<4B032390.3080501@roinet.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 17 Nov 2009 14:39:26 -0800
Message-ID: <43e72e890911171439q74f30bc2t3e6f4ada19a85594@mail.gmail.com>
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

On Tue, Nov 17, 2009 at 2:28 PM, David Acker <dacker@roinet.com> wrote:
> Luis R. Rodriguez wrote:
>>
>> On Tue, Nov 17, 2009 at 1:53 PM, David Acker <dacker@roinet.com>
>> wrote:

>>> The problem with switching to ath5k would be the loss of
>>> performance related features (compression, fast frames, turbo),
>>
>> These are different than "mesh".
>
> Yes, but it would be good if these features were supported over WDS
> links (and on AP to STA links where both support the features).

Someone would just have to step up to:

1) implement these features
2) support them

>> So let me get this straight.
>>
>> You have SoC Atheros solutions that use some userspace custom (not
>> 802.11s) solution that use fast frames, compression and turbo, oh and
>>  half/quarter rates? WTF are you doing?
>
> Lol, it isn't as crazy as it sounds.  I have meshing running on various
> platforms. Some use miniPCI atheros based radios, some are SoC based.  I
> believe I misspoke when I said half/quarter rates.  It is better to say half
> width (10 MHz) or quarter width (5 MHz) channels.

OK well this could be supported, and welcomed someone just needs to work on it.

> There are several miniPCI
> based radios that require half or quarter width channels on some channels.

That *require* this?

> For example, the Ubiquiti XR7 requires quarter width channels on two of its
> four available channels.

Regulatory wise? What's the restriction based on?

> The XR9 requires half width channels on two if its
> four available channels.

Same here, what's the restriction based on?

I'll note that CRDA is channel agnostic, it just is cognizant of max
allowed regulatory width, whether you use smaller width channels is
left up to cfg80211 then. So supporting custom channel settings would
just be a matter of listing the supported hardware configurations of
list of channels and target widths.

>> For backporting we have compat-wireless, it should allow you to use even
>> today's bleeding edge even on 2.6.25. It should be possible to bring this
>> down to 2.6.21 even but not many people are interested in that it seems.
>> Patches are welcomed though.
>
> Thanks.  I am trying to decide which is more painful: porting a recent
> kernel to the hardware or porting compat-wireless down to 2.6.18.

FWIW there are patches/code for 2.6.21..2.6.24 there is just a small
gap of code needed based on changes since circa 2.6.31 to add backport
support for 2.6.21..2.6.24. In other words -- it shouldn't be too bad
to get at least to 2.6.21. Not sure about 2.6.19 and 2.6.18 for PCI.

  Luis
