Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39591 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbYGaO0h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2008 10:26:37 -0400
Subject: Re: Driver for the FullMAC card
From: Dan Williams <dcbw@redhat.com>
To: Dmitry <dbaryshkov@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <bc64b4640807310715j41bb0029i5c8be73a311ed52@mail.gmail.com>
References: <g6qr98$q28$2@ger.gmane.org>
	 <1217512488.12016.8.camel@localhost.localdomain>
	 <bc64b4640807310715j41bb0029i5c8be73a311ed52@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 31 Jul 2008 10:24:01 -0400
Message-Id: <1217514241.12016.13.camel@localhost.localdomain> (sfid-20080731_162640_362386_AF9C4083)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-07-31 at 18:15 +0400, Dmitry wrote:
> 2008/7/31 Dan Williams <dcbw@redhat.com>:
> > On Wed, 2008-07-30 at 22:51 +0000, Dmitry Baryshkov wrote:
> >> Hi,
> >>
> >> I'd like to work on the Prism2 USB driver (currently maintained as a part of
> >> wlan-ng project) to be able to push it into mainline. The card itself is
> >> a FullMAC card. Where should I start? What parts of 802.11 stacks/API
> >> should I use? There is plenty of information regarding SoftMAC drivers,
> >> but no clear pointers for developing drivers for the FullMAC cards.
> >
> > If you're talking about the same hardware that linux-wlan-ng supported
> > (ie, what Ubuntu ships as prism2_usb) then that hardware can be softmac,
> > actually.  We discussed this a while ago and agreed that a completely
> > new mac80211-based driver for this hardware was the best way to go,
> > rather than trying to stuff USB support into hostap.
> 
> Yes, I was talking about prism2_usb cards. I'll explore how to switch it to
> the softmac.

prism2_usb already uses p80211, which is a softmac stack.  So the cards
are already being driven in softmac mode.  You basically just have to
write a mac80211 driver for the hardware and ignore p80211 completely.

Dan

