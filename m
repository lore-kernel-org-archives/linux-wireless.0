Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55466 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab0IVLJf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 07:09:35 -0400
Received: by fxm3 with SMTP id 3so188719fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Sep 2010 04:09:34 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: pull request: wireless-next-2.6 2010-09-21
Date: Wed, 22 Sep 2010 13:09:28 +0200
Cc: David Miller <davem@davemloft.net>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
References: <20100921201705.GC2448@tuxdriver.com> <201009221227.48500.chunkeey@googlemail.com> <1285151675.3684.13.camel@jlt3.sipsolutions.net>
In-Reply-To: <1285151675.3684.13.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201009221309.29224.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 22 September 2010 12:34:35 Johannes Berg wrote:
> On Wed, 2010-09-22 at 12:27 +0200, Christian Lamparter wrote:
> > On Wednesday 22 September 2010 12:01:17 Johannes Berg wrote:
> > > On Wed, 2010-09-22 at 11:58 +0200, Christian Lamparter wrote:
> > > > On Wednesday 22 September 2010 03:36:14 David Miller wrote:
> > > > > From: "John W. Linville" <linville@tuxdriver.com>
> > > > > Date: Tue, 21 Sep 2010 16:17:05 -0400
> > > > > 
> > > > > Pulled, but I suspect the 'packed' attribute usage is wrong in
> > > > > ath/carl9170 and can just be deleted.
> > > > 
> > > > which __packed do you think can be removed?
> > > 
> > > Well, there are bitfields in packed structs, which is either completely
> > > wrong (think endianness ... never use them to interface with something
> > > outside your own CPU), or needn't be packed.
> >
> > the header files (eeprom.h, wlan.h, hw.h, version.h, phy.h, fwcmd.h, fwdesc.h)
> > are shared with the firmware, firmware tools and the userspace testbench.
* (and of course the driver)

> Oh, ok, so it is indeed used only on the firmware. But then why does it
> need packing? Or is it some interface with the hardware?
yes, the 64-bit hardware descriptor might be one reason.
The other is that I don't want to hit the 320-byte boundary
for standard 1500 octet frames.

(and we get a free out-of-boundary check too.)

Regards,
	Chr
