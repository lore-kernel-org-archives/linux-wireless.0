Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:25643 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab0DYUf6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Apr 2010 16:35:58 -0400
Message-ID: <4BD4A639.8000703@gmail.com>
Date: Sun, 25 Apr 2010 22:29:45 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: me@bobcopeland.com
CC: Pedro Francisco <pedrogfrancisco@gmail.com>,
	Vegard Nossum <vegard.nossum@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	mickflemm@gmail.com
Subject: Re: ath5k misbehaving affecting other kernel parts unrelated?
References: <201004230806.13628.pedrogfrancisco@gmail.com> <201004240956.45899.pedrogfrancisco@gmail.com> <q2p19f34abd1004240509r63449b41l379bc14f5c6eaeae@mail.gmail.com> <201004241828.37489.pedrogfrancisco@gmail.com> <20100425192242.GA27921@hash.localnet>
In-Reply-To: <20100425192242.GA27921@hash.localnet>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/25/2010 09:22 PM, me@bobcopeland.com wrote:
> On Sat, Apr 24, 2010 at 06:28:36PM +0100, Pedro Francisco wrote:
>> =============================================================================
>> [ 2658.663424] BUG kmalloc-4096: Poison overwritten
>> [ 2658.663483] 
> 
> Ok there are 4 messages here, two of them are definitely 802.11 beacons,
> which would point the finger squarely at ath5k.  We had reports of this
> some time ago but a few things got rewritten around that time.  I'd guess
> the rx DMA code is still subtly broken. 
> 
>> 6b 6b kkkkkkkkkkkkkkkk
>> [ 2658.664816]   Object 0xed3db0c0:  c4 00 84 00 00 22 43 89 42 69 4e 12 ca 6f 
>> 6f 6f �...."C.BiN.�ooo
>> [ 4689.945547]   Object 0xed3d9080:  c4 00 70 00 00 22 43 89 42 69 fe 08 eb 14 
>> 14 14 �.p.."C.Bi�.�...
> 
> Offhand, I'm not sure what pattern these are.

These are CTS frames. So I think ath5k is to blame too :/.

regards,
-- 
js
