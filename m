Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36023 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194Ab1B1VWC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 16:22:02 -0500
Subject: Re: [PATCH] rtlwifi: usb parts should depend on CONFIG_USB
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	George <george0505@realtek.com>, linux-next@vger.kernel.org
In-Reply-To: <4D6C10B0.2090402@lwfinger.net>
References: <alpine.DEB.2.00.1102171354200.16788@ayla.of.borg>
	 <1298922500-21632-1-git-send-email-linville@tuxdriver.com>
	 <1298923731.10109.0.camel@jlt3.sipsolutions.net>
	 <20110228201357.GF2515@tuxdriver.com>  <4D6C10B0.2090402@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Feb 2011 22:21:51 +0100
Message-ID: <1298928111.12230.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-02-28 at 15:16 -0600, Larry Finger wrote:
> On 02/28/2011 02:13 PM, John W. Linville wrote:
> > On Mon, Feb 28, 2011 at 09:08:51PM +0100, Johannes Berg wrote:
> >> On Mon, 2011-02-28 at 14:48 -0500, John W. Linville wrote:
> >>>
> >>> +ifeq ($(CONFIG_USB),y)
> >>> +rtlwifi-objs	+= usb.o
> >>> +endif
> >>
> >> That reads weird, shouldn't
> >>
> >> rtlwifi-$(CONFIG_USB) += usb.o
> >>
> >> do? Or more likely actually use CONFIG_RTL8192CU?
> >
> > Maybe...really just following what Larry already had there for pci...?
> 
> Yes, and that was wrong too.
> 
> It could be either as Johannes wrote it, or

No, what I said won't work for m either, since you'd get

rtlwifi-m += usb.o

Though you can make that work by adding $(rtlwifi-m) manually to the
list of objects later.

johannes

