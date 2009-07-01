Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f188.google.com ([209.85.210.188]:65204 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbZGAROy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 13:14:54 -0400
Received: by yxe26 with SMTP id 26so1459274yxe.33
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jul 2009 10:14:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1246464991.4331.18.camel@localhost>
References: <1246388712.4949.52.camel@localhost> <43e72e890906301217m2dec7bfaqea0472907531d21d@mail.gmail.com>
	<1246396179.4949.76.camel@localhost> <43e72e890906301458y197c5411yfb93ea0089ed49f3@mail.gmail.com>
	<1246464991.4331.18.camel@localhost>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 1 Jul 2009 10:14:37 -0700
Message-ID: <43e72e890907011014v300bcf64u3c7b259173d93588@mail.gmail.com>
Subject: Re: [PATCH] Add prism 2/3 usb adaptor firmware for use with
	staging/wlan-ng driver.
To: Karl Relton <karllinuxtest.relton@ntlworld.com>
Cc: dwmw2@infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 1, 2009 at 9:16 AM, Karl
Relton<karllinuxtest.relton@ntlworld.com> wrote:
> On Tue, 2009-06-30 at 14:58 -0700, Luis R. Rodriguez wrote:
>> On Tue, Jun 30, 2009 at 2:09 PM, Karl
>> Relton<karllinuxtest.relton@ntlworld.com> wrote:
>> > On Tue, 2009-06-30 at 12:17 -0700, Luis R. Rodriguez wrote:
>> >> On Tue, Jun 30, 2009 at 12:05 PM, Karl
>> >> Relton<karllinuxtest.relton@ntlworld.com> wrote:
>> >> > Signed-Off-By: Karl Relton
>> >> > Signed-Off-By: Mark S. Mathews
>> >>
>> >> The commit log is empty. Where is this driver? Is it in staging at
>> >> least? If so does this get users of the driver a usable firmware? What
>> >> is the future of the driver BTW?
>> >>
>> >
>> > Oops - put text in wrong part of patch documentation. I can move this up
>> > to the 'commit log' part.
>> >
>> > The driver is under 'staging' - maintained by Greg Koah-Hartman
>> >
>> > The firmware blob in 'srec' format for prism 2/3 usb adaptors.
>> > The driver will read the srec file using a standard request_firmware()
>> > call, and will convert it into the appropriate binary format and upload to
>> > the adaptor. Note the processing is left to the driver (rather than
>> > pre-compiling) because the driver needs to insert runtime data obtained from
>> > the adaptor into the blob. The appropriate insertion locations are conveyed
>> > by the srec format.
>>
>> Why all the srec->binary conversion? Doesn't this waste space on
>> people's firmware directories?
>>
> Yes, technically it does. The srec file is ~185KB, a binary image would
> be ~64KB.
>
> The reason it was left is that the driver has to do some runtime
> plugging of data into the image

Can you elaborate on this a little. Does the driver currently take the
srec file, append/prepend some data onto it and then run it on the
target CPU?

> , so pre-compilation would have meant
> inventing both a compiler tool and an intermediate format for the driver
> to read and process.

The srec->binary conversion just needs to be done once, and not sure
what the "extra" stuff is that you mention is required, but if its
always the same can't that just be put into a final binary file?

> Putting all the srec processing in the driver was
> more expedient (just meant porting existing userspace code into driver
> space).

At the cost of a firmware file size 3 times the size of the binary file.

  Luis
