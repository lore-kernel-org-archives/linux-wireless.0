Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:55967 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbZBVRQR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Feb 2009 12:16:17 -0500
Received: by nf-out-0910.google.com with SMTP id d21so360500nfb.21
        for <linux-wireless@vger.kernel.org>; Sun, 22 Feb 2009 09:16:15 -0800 (PST)
Date: Sun, 22 Feb 2009 18:10:33 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, Bob Copeland <me@bob>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
Message-ID: <20090222171032.GD6003@nowhere> (sfid-20090222_181622_243350_8A5283CD)
References: <20090222111807.GB5538@silver.sucs.org> <49A13E91.1090601@gmail.com> <20090222122036.GC5538@silver.sucs.org> <20090222144742.GA6078@nowhere> <20090222170201.GA27360@silver.sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090222170201.GA27360@silver.sucs.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 22, 2009 at 05:02:01PM +0000, Sitsofe Wheeler wrote:
> On Sun, Feb 22, 2009 at 03:47:44PM +0100, Frederic Weisbecker wrote:
> > On Sun, Feb 22, 2009 at 12:20:36PM +0000, Sitsofe Wheeler wrote:
> > > On Sun, Feb 22, 2009 at 01:01:21PM +0100, Jiri Slaby wrote:
> > > > The unsupported jumbo message might be a clue. When we jump to the next: 
> > > > label, the buffer is at the end of the list in software, while in 
> > > > hardware it isn't. In theory, we might hit the bug with rx buffers 
> > > > exhaustion, because the test (bf_last == bf) doesn't work as expected then.
> > > 
> > > This seems to be happening somewhat regularly now - I've got a small
> > > collections of the warnings (I'll include them below in case they are
> > > any help):
> > > 
> > > [ 7435.711659] ath5k phy0: unsupported jumbo
> > > [ 8125.567136] ath5k phy0: noise floor calibration timeout (2417MHz)
> > > [ 9596.212322] ath5k phy0: unsupported jumbo
> > > [10697.497598] ath5k phy0: unsupported jumbo
> > > [11207.740975] =============================================================================
> > > [11207.740986] BUG kmalloc-4096: Poison overwritten
> > > [11207.740991] -----------------------------------------------------------------------------
> > > [11207.740994] 
> > > [11207.740999] INFO: 0xd7060010-0xd7060053. First byte 0x80 instead of 0x6b
> > > [11207.741014] INFO: Allocated in dev_alloc_skb+0x21/0x40 age=4990 cpu=0 pid=0
> > > [11207.741023] INFO: Freed in skb_release_data+0x5e/0x90 age=893 cpu=0 pid=508
> > > [11207.741030] INFO: Slab 0xc133dd80 objects=7 used=5 fp=0xd7060000 flags=0x400020c3
> > > [11207.741036] INFO: Object 0xd7060000 @offset=0 fp=0xd70640c0
> 
> > Looks like it happens with ath5k driver.
> > Well, I have an atheros card, so I'm testing it.
> 
> Good luck! I've just switched to a different location (with faster wifi
> and more single network access points ) and I've been totally unable to
> reproduce this warning.

I have some troubles with kmemcheck, so I give up for now.
Well, by reading the kmemcheck documentation, it tells that there can be some false
positives so...

 
> If there's some debug output that I produce that will help you let me
> know...


Since we are not sure this is a real bug, I'm not sure it would be interesting.

Well, I will see that later.
Thanks.


> -- 
> Sitsofe | http://sucs.org/~sits/



