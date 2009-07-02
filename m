Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:4016 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751420AbZGBQ7h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2009 12:59:37 -0400
Subject: Re: [PATCH] Add prism 2/3 usb adaptor firmware for use with
 staging/wlan-ng driver.
From: Karl Relton <karllinuxtest.relton@ntlworld.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1246477614.3681.2103.camel@macbook.infradead.org>
References: <1246388712.4949.52.camel@localhost>
	 <43e72e890906301217m2dec7bfaqea0472907531d21d@mail.gmail.com>
	 <1246396179.4949.76.camel@localhost>
	 <43e72e890906301458y197c5411yfb93ea0089ed49f3@mail.gmail.com>
	 <1246464991.4331.18.camel@localhost>
	 <1246477614.3681.2103.camel@macbook.infradead.org>
Content-Type: text/plain
Date: Thu, 02 Jul 2009 17:59:32 +0100
Message-Id: <1246553972.4328.11.camel@localhost>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-07-01 at 20:46 +0100, David Woodhouse wrote:
> On Wed, 2009-07-01 at 17:16 +0100, Karl Relton wrote:
> > On Tue, 2009-06-30 at 14:58 -0700, Luis R. Rodriguez wrote:
> > > On Tue, Jun 30, 2009 at 2:09 PM, Karl
> > > Relton<karllinuxtest.relton@ntlworld.com> wrote:
> > > > On Tue, 2009-06-30 at 12:17 -0700, Luis R. Rodriguez wrote:
> > > >> On Tue, Jun 30, 2009 at 12:05 PM, Karl
> > > >> Relton<karllinuxtest.relton@ntlworld.com> wrote:
> > > >> > Signed-Off-By: Karl Relton
> > > >> > Signed-Off-By: Mark S. Mathews
> > > >>
> > > >> The commit log is empty. Where is this driver? Is it in staging at
> > > >> least? If so does this get users of the driver a usable firmware? What
> > > >> is the future of the driver BTW?
> > > >>
> > > >
> > > > Oops - put text in wrong part of patch documentation. I can move this up
> > > > to the 'commit log' part.
> > > >
> > > > The driver is under 'staging' - maintained by Greg Koah-Hartman
> > > >
> > > > The firmware blob in 'srec' format for prism 2/3 usb adaptors.
> > > > The driver will read the srec file using a standard request_firmware()
> > > > call, and will convert it into the appropriate binary format and upload to
> > > > the adaptor. Note the processing is left to the driver (rather than
> > > > pre-compiling) because the driver needs to insert runtime data obtained from
> > > > the adaptor into the blob. The appropriate insertion locations are conveyed
> > > > by the srec format.
> > > 
> > > Why all the srec->binary conversion? Doesn't this waste space on
> > > people's firmware directories?
> > > 
> > Yes, technically it does. The srec file is ~185KB, a binary image would
> > be ~64KB.
> > 
> > The reason it was left is that the driver has to do some runtime
> > plugging of data into the image, so pre-compilation would have meant
> > inventing both a compiler tool and an intermediate format for the driver
> > to read and process. Putting all the srec processing in the driver was
> > more expedient (just meant porting existing userspace code into driver
> > space).
> 
> The kernel has support for a binary form of srec files (well, of ihex
> files, which are fairly much the same thing).
> 
> See include/linux/ihex.h and firmware/ihex2fw.c.
>  

Hi David

Thanks for this info.

Assuming the necessary work was done to suitably pre-process srec to a
binary, would the firmware image (with its currently somewhat ambiguous
license statement) be allowed into linux-firmware anyway, or would it
simply not pass the criteria you need to apply?

Karl

