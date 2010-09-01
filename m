Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63024 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab0IAUIj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Sep 2010 16:08:39 -0400
MIME-Version: 1.0
In-Reply-To: <CE761E84DADF2947A4AF22FB8D97A4732A516CE8@shsmsx501.ccr.corp.intel.com>
References: <1281532770-27545-1-git-send-email-ohad@wizery.com>
 <1281532770-27545-4-git-send-email-ohad@wizery.com> <CE761E84DADF2947A4AF22FB8D97A4732A516CE8@shsmsx501.ccr.corp.intel.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 1 Sep 2010 23:08:14 +0300
Message-ID: <AANLkTi=4U0AwLeXg=fSUViGvaCnJeXGYvJ=7pkGK+fFX@mail.gmail.com>
Subject: Re: [RFC/PATCH 3/6] mmc: add general runtime PM support
To: "Gao, Yunpeng" <yunpeng.gao@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	Ido Yariv <ido@wizery.com>, San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Nicolas Pitre <nico@fluxnic.net>
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Yunpeng,

Sorry for the late reply (vacation..).

On Thu, Aug 26, 2010 at 12:42 PM, Gao, Yunpeng <yunpeng.gao@intel.com> wrote:
> It seems the power_save callback is not implemented (Null pointer) yet for both mmc and sdio. Does it mean that the power_save callback will be implemented in future or just don't need at all? Thanks.

Yes, currently seems it is not needed.

> But seems it doesn't provide a runtime PM example on host controller driver side. To my understanding, once the functions (mmc card or sdio devices) and mmc/sdio bus enter into rumtime suspend, it should then make the host controller enter into runtime suspend, too. Any ideas on how to achieve this? Thanks.

This should already be taken care of by the PM core:

When a device is suspended (e.g. our sdio/mmc card), an idle request
is sent by the PM core to its parent device (in our case, that would
be the host controller).
Now, if the host controller driver has enabled runtime PM, its idle
handler would be called so it could act upon it.
Similarly, when the card is resumed, the PM core will first invoke its
host controller parent's resume handler.

For an (initial) reference example of enabling runtime PM in a host
controller driver (omap_hsmmc), you can take a look at Kevin Hilman's
pm-wip/mmc branch of:
git://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-omap-pm.git

Btw I have an updated version of this patchset - I am about to start
testing it (will make sure your scenario works too) and then soon
after post it here for review.

Thanks,
Ohad.

>
> Best Regards,
> Yunpeng Gao
