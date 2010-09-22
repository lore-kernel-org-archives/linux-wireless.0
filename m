Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53948 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab0IVKel (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 06:34:41 -0400
Subject: Re: pull request: wireless-next-2.6 2010-09-21
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: David Miller <davem@davemloft.net>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <201009221227.48500.chunkeey@googlemail.com>
References: <20100921201705.GC2448@tuxdriver.com>
	 <201009221158.13806.chunkeey@googlemail.com>
	 <1285149677.3684.12.camel@jlt3.sipsolutions.net>
	 <201009221227.48500.chunkeey@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Sep 2010 12:34:35 +0200
Message-ID: <1285151675.3684.13.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-09-22 at 12:27 +0200, Christian Lamparter wrote:
> On Wednesday 22 September 2010 12:01:17 Johannes Berg wrote:
> > On Wed, 2010-09-22 at 11:58 +0200, Christian Lamparter wrote:
> > > On Wednesday 22 September 2010 03:36:14 David Miller wrote:
> > > > From: "John W. Linville" <linville@tuxdriver.com>
> > > > Date: Tue, 21 Sep 2010 16:17:05 -0400
> > > > 
> > > > Pulled, but I suspect the 'packed' attribute usage is wrong in
> > > > ath/carl9170 and can just be deleted.
> > > 
> > > which __packed do you think can be removed?
> > 
> > Well, there are bitfields in packed structs, which is either completely
> > wrong (think endianness ... never use them to interface with something
> > outside your own CPU), or needn't be packed.
> 
> ah,
> 
> the header files (eeprom.h, wlan.h, hw.h, version.h, phy.h, fwcmd.h, fwdesc.h)
> are shared with the firmware, firmware tools and the userspace testbench.

Oh, ok, so it is indeed used only on the firmware. But then why does it
need packing? Or is it some interface with the hardware?

johannes

