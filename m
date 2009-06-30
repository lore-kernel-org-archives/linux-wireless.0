Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.243]:11636 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbZF3V6a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2009 17:58:30 -0400
Received: by an-out-0708.google.com with SMTP id d40so832752and.1
        for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2009 14:58:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1246396179.4949.76.camel@localhost>
References: <1246388712.4949.52.camel@localhost> <43e72e890906301217m2dec7bfaqea0472907531d21d@mail.gmail.com>
	<1246396179.4949.76.camel@localhost>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 30 Jun 2009 14:58:13 -0700
Message-ID: <43e72e890906301458y197c5411yfb93ea0089ed49f3@mail.gmail.com>
Subject: Re: [PATCH] Add prism 2/3 usb adaptor firmware for use with
	staging/wlan-ng driver.
To: Karl Relton <karllinuxtest.relton@ntlworld.com>
Cc: dwmw2@infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 30, 2009 at 2:09 PM, Karl
Relton<karllinuxtest.relton@ntlworld.com> wrote:
> On Tue, 2009-06-30 at 12:17 -0700, Luis R. Rodriguez wrote:
>> On Tue, Jun 30, 2009 at 12:05 PM, Karl
>> Relton<karllinuxtest.relton@ntlworld.com> wrote:
>> > Signed-Off-By: Karl Relton
>> > Signed-Off-By: Mark S. Mathews
>>
>> The commit log is empty. Where is this driver? Is it in staging at
>> least? If so does this get users of the driver a usable firmware? What
>> is the future of the driver BTW?
>>
>
> Oops - put text in wrong part of patch documentation. I can move this up
> to the 'commit log' part.
>
> The driver is under 'staging' - maintained by Greg Koah-Hartman
>
> The firmware blob in 'srec' format for prism 2/3 usb adaptors.
> The driver will read the srec file using a standard request_firmware()
> call, and will convert it into the appropriate binary format and upload to
> the adaptor. Note the processing is left to the driver (rather than
> pre-compiling) because the driver needs to insert runtime data obtained from
> the adaptor into the blob. The appropriate insertion locations are conveyed
> by the srec format.

Why all the srec->binary conversion? Doesn't this waste space on
people's firmware directories?

  Luis
