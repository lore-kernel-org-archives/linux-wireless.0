Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:46525 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439AbZGASfV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 14:35:21 -0400
Subject: Re: [PATCH] Add prism 2/3 usb adaptor firmware for use with
 staging/wlan-ng driver.
From: Dan Williams <dcbw@redhat.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Dave <kilroyd@googlemail.com>,
	Karl Relton <karllinuxtest.relton@ntlworld.com>,
	dwmw2@infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890907011112l220874bbu8db8808f666bbd4d@mail.gmail.com>
References: <1246388712.4949.52.camel@localhost>
	 <43e72e890906301217m2dec7bfaqea0472907531d21d@mail.gmail.com>
	 <1246396179.4949.76.camel@localhost>
	 <43e72e890906301458y197c5411yfb93ea0089ed49f3@mail.gmail.com>
	 <1246464991.4331.18.camel@localhost> <4A4BA21F.1070101@gmail.com>
	 <43e72e890907011112l220874bbu8db8808f666bbd4d@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 01 Jul 2009 14:35:00 -0400
Message-Id: <1246473300.30522.10.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-07-01 at 11:12 -0700, Luis R. Rodriguez wrote:
> On Wed, Jul 1, 2009 at 10:51 AM, Dave<kilroyd@googlemail.com> wrote:
> > Karl Relton wrote:
> >> On Tue, 2009-06-30 at 14:58 -0700, Luis R. Rodriguez wrote:
> >>> Why all the srec->binary conversion? Doesn't this waste space on
> >>> people's firmware directories?
> >>>
> >> Yes, technically it does. The srec file is ~185KB, a binary image would
> >> be ~64KB.
> >>
> >> The reason it was left is that the driver has to do some runtime
> >> plugging of data into the image, so pre-compilation would have meant
> >> inventing both a compiler tool and an intermediate format for the driver
> >> to read and process. Putting all the srec processing in the driver was
> >> more expedient (just meant porting existing userspace code into driver
> >> space).
> >
> > I can't find the wlan_ng request_firmware call in my wireless-testing
> > tree (week or so old). Is that new?
> >
> > From what I can tell the wlan_ng, hostap and orinoco drivers all program
> > firmware that has the same basic format. Hostap doesn't use
> > request_firmware, and gives userspace the control over the write
> > sequence. orinoco places a very simple header in front of the binary image.
> >
> > Do we really want to add srec processing to the driver (or even the kernel)?
> >
> > It would be nice if the FW image was in the same format for orinoco and
> > wlan_ng, as the prism firmware ought to work on non-USB prism cards, and
> > we should be able to make orinoco use it.
> 
> I never got the wlan_ng stuff.. Anyway now it is under
> drivers/staging/wlan-ng. I was under the impression it targeted some
> devices not covered by hostapd or orinoco, is that no the case?

It targets USB devices.  Neither orinoco or hostap handle USB devices,
largely because USB is asynchronous and neither orinoco or hostap are
built to communicate with the firmware asynchronously.  I'm a bit
skeptical of linux-wlan-ng ever getting out of staging because it
really, really should be ported to hostap, but if that doesn't happen,
it should really really get ported to cfg80211 first to ensure we don't
just add *another* WEXT implementation to the pool.  That's really all I
care about, I don't want another WEXT-based driver accepted; I want all
the new ones using cfg80211.

Dan


