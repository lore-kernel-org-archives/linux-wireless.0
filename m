Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2661 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab0DYT0j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Apr 2010 15:26:39 -0400
Date: Sun, 25 Apr 2010 15:22:42 -0400
From: me@bobcopeland.com
To: Pedro Francisco <pedrogfrancisco@gmail.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	mickflemm@gmail.com
Subject: Re: ath5k misbehaving affecting other kernel parts unrelated?
Message-ID: <20100425192242.GA27921@hash.localnet>
References: <201004230806.13628.pedrogfrancisco@gmail.com> <201004240956.45899.pedrogfrancisco@gmail.com> <q2p19f34abd1004240509r63449b41l379bc14f5c6eaeae@mail.gmail.com> <201004241828.37489.pedrogfrancisco@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <201004241828.37489.pedrogfrancisco@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 24, 2010 at 06:28:36PM +0100, Pedro Francisco wrote:
> =============================================================================
> [ 2658.663424] BUG kmalloc-4096: Poison overwritten
> [ 2658.663483] 

Ok there are 4 messages here, two of them are definitely 802.11 beacons,
which would point the finger squarely at ath5k.  We had reports of this
some time ago but a few things got rewritten around that time.  I'd guess
the rx DMA code is still subtly broken. 

> 6b 6b kkkkkkkkkkkkkkkk
> [ 2658.664816]   Object 0xed3db0c0:  c4 00 84 00 00 22 43 89 42 69 4e 12 ca 6f 
> 6f 6f �...."C.BiN.�ooo
> [ 4689.945547]   Object 0xed3d9080:  c4 00 70 00 00 22 43 89 42 69 fe 08 eb 14 
> 14 14 �.p.."C.Bi�.�...

Offhand, I'm not sure what pattern these are.

> [14487.165341]   Object 0xed378040:  80 00 00 00 ff ff ff ff ff ff 00 1e 8c 0f 3e af 
> [24370.460011]   Object 0xed3dc100:  80 00 00 00 ff ff ff ff ff ff 00 1e 8c 0f 3e af 

These two are definitely beacons.

-- 
Bob Copeland %% www.bobcopeland.com

