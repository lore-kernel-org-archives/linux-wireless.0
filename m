Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:38428 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037Ab2EaWGk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 18:06:40 -0400
Date: Thu, 31 May 2012 17:06:35 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Arend van Spriel <arend@broadcom.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: [PATCH] b43: ensure ext PA lines are enabled for BCM4331
Message-ID: <20120531220635.GE32179@thinkpad-t410> (sfid-20120601_000645_167271_CF6B1B74)
References: <1338472163-3810-1-git-send-email-seth.forshee@canonical.com>
 <4FC77D25.4060100@hauke-m.de>
 <20120531142652.GA32179@thinkpad-t410>
 <4FC79AFD.6030803@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FC79AFD.6030803@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 31, 2012 at 06:23:25PM +0200, Hauke Mehrtens wrote:
> On 05/31/2012 04:26 PM, Seth Forshee wrote:
> > On Thu, May 31, 2012 at 04:16:05PM +0200, Hauke Mehrtens wrote:
> >> Hi Seth,
> >>
> >> why don't you call this from bcma_pmu_workarounds() in
> >> drivers/bcma/driver_chipcommon_pmu.c instead of calling this from b43? I
> >> think it looks better to call some workarounds on chip common from bcma
> >> and not from b43.
> > 
> > Arend recommended calling it from within b43's start op, but I'm not
> > sure of the reason. Arend?
> > 
> > Agreed though that if there's no need to run it every time the interface
> > is started then bcma_pmu_workarounds() would be a nicer place for it.
> 
> brcmsmac calls the chip specific the workarounds in ai_doattach(), but
> the ones for BCM4313 and BCM43224 are also in bcma_pmu_workarounds(),
> this should be cleaned up to have them just at one place. In some old
> version of brcmsmac the workaround for the BCM4331 was also called from
> ai_doattach() function, but later removed likely because this devices is
> not supported by brcmsmac.
> So if there is not better reason as, the proprietary Broadcom driver
> does so, I would like to see this call in bcma_pmu_workarounds().

I found the SDK code from a router source package, and oddly that code
is clearing those bits in si_doattach(). In fact si_chipcontrl_epa4331()
is never called to enable the ext PA lines, only to disable them. The
sprom code reads the value before disabling them and restores it after
reading from the sprom. Enabling the ext PA pins is what fixes things
for me. Predictably, duplicating this in bcma makes wireless broken all
the time. 

At any rate, it sounds like we're agreed to add the workaround in
bcma_pmu_workarounds(), so I'll redo the patch.

> >> According to some Broadcom code this should also be called for chip_id
> >> 43431 when turning it on and in the sprom code.
> > 
> > I'm having trouble parsing this, specifically the "and in the sprom
> > code" part. Can you clarify?
> 
> In the Broadcom SDK code si_chipcontrl_epa4331(), the same function as
> bcma_chipco_bcm4331_ext_pa_lines_ctl() in bcma, gets called for devices
> with a chip id of 0x4331 and 43431, both seam to be BCM4331 devices. We
> should also call our workarounds for both chip ids.

I'll fix this too.

Thanks,
Seth

