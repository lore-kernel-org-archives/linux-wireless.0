Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from outbound1a.ore.mailhop.org ([54.213.22.21]:56428 "EHLO
        outbound1a.ore.mailhop.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933575AbcKWVlF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 16:41:05 -0500
Date: Wed, 23 Nov 2016 21:40:53 +0000
From: Jason Cooper <jason@lakedaemon.net>
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: linux-wireless@vger.kernel.org,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        ath9k-devel@qca.qualcomm.com, ath9k-devel@lists.ath9k.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Kalle Valo <kvalo@codeaurora.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: ath9k ARMv7 OOPS in v4.8.6, v4.2.8
Message-ID: <20161123214053.GJ2799@io.lakedaemon.net> (sfid-20161123_224108_624479_D7439D1C)
References: <20161123191539.GF2799@io.lakedaemon.net>
 <20161123195120.GE14217@n2100.armlinux.org.uk>
 <20161123205917.GI2799@io.lakedaemon.net>
 <20161123211745.GF14217@n2100.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161123211745.GF14217@n2100.armlinux.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 23, 2016 at 09:17:45PM +0000, Russell King - ARM Linux wrote:
> On Wed, Nov 23, 2016 at 08:59:17PM +0000, Jason Cooper wrote:
> > As requested on irc:
> 
> Thanks.
> 
> >      7f0:	ea000002 	b	800 <ath_cmn_process_fft+0xac>
> >      7f4:	e7970102 	ldr	r0, [r7, r2, lsl #2]
> >      7f8:	ebfffffe 	bl	0 <relay_buf_full>
> >      7fc:	e0844000 	add	r4, r4, r0
> >      800:	e300a000 	movw	sl, #0
> >      804:	e28b2001 	add	r2, fp, #1
> >      808:	e340a000 	movt	sl, #0
> >      80c:	e3a01004 	mov	r1, #4
> >      810:	e1a0000a 	mov	r0, sl
> >      814:	ebfffffe 	bl	0 <_find_next_bit_le>
> >      818:	e5953000 	ldr	r3, [r5]
> >      81c:	e1500003 	cmp	r0, r3
> >      820:	e1a0b000 	mov	fp, r0
> >      824:	e2802008 	add	r2, r0, #8
> >      828:	bafffff1 	blt	7f4 <ath_cmn_process_fft+0xa0>
> 
> Okay, so i was 0, so running UP probably isn't going to help.  r7 is
> also spec_priv->rfs_chan_spec_scan.
> 
> So, I think the question is... how is this NULL - and has it always
> been NULL...

The problem appears to be that ath_cmn_process_fft() isn't called that
often.  When it is, it crashes in ath_cmn_is_fft_buf_full() because
spec_priv->rfs_chan_spec_scan is NULL when ATH9K_DEBUGFS=n. :-(

I'm running with ATH9K_DEBUGFS=y now.  If it goes a couple of days
without crashing, I'll gin up a patch.

thx,

Jason.
