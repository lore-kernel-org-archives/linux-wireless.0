Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:37653 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800Ab0JETul convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 15:50:41 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 05 Oct 2010 12:50:32 -0700
Date: Tue, 5 Oct 2010 12:50:39 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Felix Fietkau <nbd@openwrt.org>
CC: =?iso-8859-1?Q?Bj=F6rn?= Smedman <bjorn.smedman@venatech.se>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [RFC] ath9k: Insert wmb before linking dma
 descriptors
Message-ID: <20101005195039.GD11831@tux>
References: <alpine.DEB.2.00.1010042059130.29449@vtdt3>
 <20101005131744.GB4074@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <20101005131744.GB4074@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 05, 2010 at 06:17:44AM -0700, John W. Linville wrote:
> On Mon, Oct 04, 2010 at 10:55:08PM +0200, Björn Smedman wrote:
> > Hi all,
> > 
> > I've been looking at how ath9k does DMA and comparing with the
> > recommendations in the Linux kernel documentation for the DMA API[1]. To
> > me it looks like we risk setting up incorrect DMA descriptors on
> > platforms that can reorder writes because all data in the descriptor may
> > not be written to memory before the descriptor is linked into the DMA
> > chain.
> > 
> > The patch below attempts to remove this risk by inserting a write memory
> > barrier between where we set up a descriptor and where we add it to the 
> > DMA chain. My hope is that this may solve some of the harder chip lockups 
> > on MIPS but more testing is required to determine if it has this effect.
> > 
> > Any thoughts?
> > 
> > /Björn
> > 
> > 1. http://www.mjmwired.net/kernel/Documentation/DMA-API.txt
> 
> I think this seems OK...?

Felix is more familiar with this area so I'll let him chime with
his ACK/NACK.

  Luis
