Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48749 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab0JENaI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 09:30:08 -0400
Date: Tue, 5 Oct 2010 09:17:44 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?iso-8859-1?Q?Bj=F6rn?= Smedman <bjorn.smedman@venatech.se>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@venema.h4ckr.net
Subject: Re: [RFC] ath9k: Insert wmb before linking dma descriptors
Message-ID: <20101005131744.GB4074@tuxdriver.com>
References: <alpine.DEB.2.00.1010042059130.29449@vtdt3>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <alpine.DEB.2.00.1010042059130.29449@vtdt3>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 04, 2010 at 10:55:08PM +0200, Björn Smedman wrote:
> Hi all,
> 
> I've been looking at how ath9k does DMA and comparing with the
> recommendations in the Linux kernel documentation for the DMA API[1]. To
> me it looks like we risk setting up incorrect DMA descriptors on
> platforms that can reorder writes because all data in the descriptor may
> not be written to memory before the descriptor is linked into the DMA
> chain.
> 
> The patch below attempts to remove this risk by inserting a write memory
> barrier between where we set up a descriptor and where we add it to the 
> DMA chain. My hope is that this may solve some of the harder chip lockups 
> on MIPS but more testing is required to determine if it has this effect.
> 
> Any thoughts?
> 
> /Björn
> 
> 1. http://www.mjmwired.net/kernel/Documentation/DMA-API.txt

I think this seems OK...?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
