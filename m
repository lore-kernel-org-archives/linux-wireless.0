Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59482 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab0GHUKz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jul 2010 16:10:55 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1007061316010.6020@xanadu.home>
References: <1278376666-3509-1-git-send-email-ohad@wizery.com>
	<1278376666-3509-12-git-send-email-ohad@wizery.com> <4C32EF19.1000604@nokia.com>
	<AANLkTintIz-N7MwwtqhVq2LR3Ln5JTNYSbJUBSSClcA-@mail.gmail.com>
	<4C3306F4.8060907@nokia.com> <AANLkTin5W52fPzWToRrAzm56SLZI-taSuI16rCEhLWqH@mail.gmail.com>
	<4C333E0D.2070601@nokia.com> <alpine.LFD.2.00.1007061316010.6020@xanadu.home>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 8 Jul 2010 23:10:33 +0300
Message-ID: <AANLkTin7jIAIiN_JHMxX74K-EBDtDNwUQMlIf4C6RCHD@mail.gmail.com>
Subject: Re: [PATCH 11/15] wireless: wl1271: introduce platform device support
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Roger Quadros <roger.quadros@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	"Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	San Mehat <san@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Nicolas and Roger,

On Tue, Jul 6, 2010 at 8:42 PM, Nicolas Pitre <nico@fluxnic.net> wrote:
> On Tue, 6 Jul 2010, Roger Quadros wrote:
> > If the Power enable GPIO can be treated as SDIO slot supply (i.e. vmmc), then
> > the SDIO/MMC core should tackle it, just like it deals with supply for slots
> > with removable cards.
>
...
> Another function pair would be needed instead, which would do almost
> like the suspend/resume code is already doing.  Something like:

Thanks a lot for your review and comments, and for taking the time to
present your approach.

I like it !

It'd allow us to lose the software (or fake if you want ;) card detect
mechanism, which is something that should have been added to each
platform we wanted to support.

We would only need to make it possible to deliver board-specific data
to the function driver (e.g., in the case of the wl1271, we need irq
and board_ref_clock data).  That would require some board-level
platform-data configuration, which will be specific to the controller
to which the device is hardwired to. This data should propagate
through the host controller to the SDIO core so it would eventually be
accessible by the function driver (e.g. via func->dev.pdata).

We'll adapt and post follow-up patches.

Thanks again,
Ohad.
