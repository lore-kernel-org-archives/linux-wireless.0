Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:40237 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbZHZUt4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 16:49:56 -0400
From: Michael Buesch <mb@bu3sch.de>
To: =?iso-8859-1?q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: [PATCH] b43: Fix and update LP-PHY code
Date: Wed, 26 Aug 2009 22:49:50 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1251312686-32067-1-git-send-email-netrolller.3d@gmail.com> <200908262242.50729.mb@bu3sch.de> <69e28c910908261347u375f2f5cu74672b9f4b073738@mail.gmail.com>
In-Reply-To: <69e28c910908261347u375f2f5cu74672b9f4b073738@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200908262249.52408.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 26 August 2009 22:47:12 Gábor Stefanik wrote:
> 2009/8/26 Michael Buesch <mb@bu3sch.de>:
> > On Wednesday 26 August 2009 20:51:25 Gábor Stefanik wrote:
> >> -Fix a few nasty typos (b43_phy_* operations instead of b43_radio_*)
> >>  in the channel tune routines.
> >> -Fix some typos & spec errors found by MMIO tracing.
> >> -Optimize b43_phy_write & b43_phy_mask/set/maskset to use
> >>  only the minimal number of MMIO accesses. (Write is possible
> >>  using a single 32-bit MMIO write, while set/mask/maskset can
> >>  be done in 3 16-bit MMIOs).
> >
> > Why does it matter? PHY access is not done in any hotpath. So why
> > not prefer simple code over optimized code?
> 
> This is how the MIPS/hybrid driver does it, I simply updated the code
> for parity.

I think _if_ we do it (I'm not sure if it's worth it), we should certainly
do it in a completely separate patch.

> 
> >
> >> -Set the default channel back to 1, as the bug forcing us to use
> >>  channel 7 is now fixed.
> >
> > And, everything in its own patch, please. I don't see a reason for
> > patching unrelated things in one big patch.
> 
> Well, this patch is already in wireless-testing, so doing that would

When did I ack it?
Note that I _do_ have a life and I was not able to check mail for the past 9 hours.
So please give me an ack latency of one day, at least.

-- 
Greetings, Michael.
