Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41617 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab0GIIdK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jul 2010 04:33:10 -0400
MIME-Version: 1.0
In-Reply-To: <4C36DA04.3090209@nokia.com>
References: <1278376666-3509-1-git-send-email-ohad@wizery.com>
	<1278376666-3509-12-git-send-email-ohad@wizery.com> <4C32EF19.1000604@nokia.com>
	<AANLkTintIz-N7MwwtqhVq2LR3Ln5JTNYSbJUBSSClcA-@mail.gmail.com>
	<4C3306F4.8060907@nokia.com> <AANLkTin5W52fPzWToRrAzm56SLZI-taSuI16rCEhLWqH@mail.gmail.com>
	<4C333E0D.2070601@nokia.com> <alpine.LFD.2.00.1007061316010.6020@xanadu.home>
	<AANLkTin7jIAIiN_JHMxX74K-EBDtDNwUQMlIf4C6RCHD@mail.gmail.com>
	<4C36DA04.3090209@nokia.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 9 Jul 2010 11:32:47 +0300
Message-ID: <AANLkTik7eGRREWlokHenj-hGlwJXwc7IBWpSqNpoMwGI@mail.gmail.com>
Subject: Re: [PATCH 11/15] wireless: wl1271: introduce platform device support
To: Roger Quadros <roger.quadros@nokia.com>
Cc: Nicolas Pitre <nico@fluxnic.net>,
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

Hi Roger,

On Fri, Jul 9, 2010 at 11:12 AM, Roger Quadros <roger.quadros@nokia.com> wrote:
> You are already
> creating a new platform device for wl1271_sdio just to pass platform_data

With the new approach, I can remove this platform device altogether,
and completely rely on the sdio function device for driver probing (as
it was before). I just need to add this little support of delivering
small bits of platform data - the mechanism should be simple and
generic, and would considerably simplify the driver.

> I think this case is specific to wl1271.

Yes, it is.

There's an hw issue with the wl1271's in-band interrupt, so we can't
use it (the issue is fixed in the wl1281 btw).

But we also have to deliver the reference clock info to the driver,
which is board-specific data, and would be relevant to all wl12xx
devices.

Thanks,
Ohad.
