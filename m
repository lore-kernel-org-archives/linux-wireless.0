Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f202.google.com ([209.85.223.202]:42079 "EHLO
	mail-iw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab0CGRVo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Mar 2010 12:21:44 -0500
Received: by iwn40 with SMTP id 40so217361iwn.1
        for <linux-wireless@vger.kernel.org>; Sun, 07 Mar 2010 09:21:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1267857349.2243.158.camel@localhost.localdomain>
References: <4B9024DE.308@jacobs-university.de>
	 <c1545bb51003041638v28e5fe9me336735fc940e1ea@mail.gmail.com>
	 <1267857349.2243.158.camel@localhost.localdomain>
Date: Sun, 7 Mar 2010 09:21:43 -0800
Message-ID: <c1545bb51003070921r7d9bd1a5v3a43d3034ab56219@mail.gmail.com>
Subject: Re: Mesh support for gumstix's wireless (Marvell 88W8385 wireless
	chip with CF interface)
From: Andrey Yurovsky <yurovsky@gmail.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Darko Makreshanski <d.makreshanski@jacobs-university.de>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 5, 2010 at 10:35 PM, Dan Williams <dcbw@redhat.com> wrote:
> On Thu, 2010-03-04 at 16:38 -0800, Andrey Yurovsky wrote:
>> On Thu, Mar 4, 2010 at 1:23 PM, Darko Makreshanski
>> <d.makreshanski@jacobs-university.de> wrote:
>> > 1. will mesh networking work with the 88W8385 chip on gumstix with the
>> > libertas driver?
>>
>> No.  The OLPC uses an 88w8288 with in-firmware mesh on the USB
>> variant.  That firmware won't run on other chips.
>
> I assume you mean 88w8388 :)

Yes, sorry about the typo. The '2' and '3' keys are, of course, right
next to each other ; )

>> > 3. if not, is it possible to make the libertas_tf driver work with this
>> > chip?
>>
>> No.  That driver only supports the 88w8388 USB variant with special
>> firmware.  Your chip is a full-MAC device and therefore cannot use the
>> mac80211 mesh stack (and there isn't a special firmware to make it do
>> something else).

By the way, you could try using the USB host on your Gumstix board
with the rt2x00 or zd1211rw cards, those are soft-MAC and at least
used to work with mesh mode.

  -Andrey
