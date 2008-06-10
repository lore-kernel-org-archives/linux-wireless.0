Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.225]:2085 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303AbYFJO3S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2008 10:29:18 -0400
Received: by rv-out-0506.google.com with SMTP id k40so919730rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jun 2008 07:29:18 -0700 (PDT)
Message-ID: <19f34abd0806100729h7a060012h91e81248c9c7cdca@mail.gmail.com> (sfid-20080610_162928_123152_B57CA136)
Date: Tue, 10 Jun 2008 16:29:17 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: BUG: NULL pointer dereference at 00000000 -- IP: [<f8e783d5>] :b43:b43_dma_mapping_error+0x16/0x155
Cc: "Miles Lane" <miles.lane@gmail.com>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200806101623.34082.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <a44ae5cd0806100709rf4602f2x587631852502c0b5@mail.gmail.com>
	 <200806101623.34082.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 10, 2008 at 4:23 PM, Michael Buesch <mb@bu3sch.de> wrote:
> On Tuesday 10 June 2008 16:09:37 Miles Lane wrote:
>> BUG: unable to handle kernel NULL pointer dereference at 00000000
>> IP: [<f8e783d5>] :b43:b43_dma_mapping_error+0x16/0x155
>
>
> It seems to crash at
>  60 extern const struct dma_mapping_ops *dma_ops;
>  61
>  62 static inline int dma_mapping_error(dma_addr_t dma_addr)
>  63 {
>  64         if (dma_ops->mapping_error)
>  65                 return dma_ops->mapping_error(dma_addr);
>  66
>  67         return (dma_addr == bad_dma_address);
>  68 }

No, this is wrong.

/* Check if a DMA mapping address is invalid. */
static bool b43_dma_mapping_error(struct b43_dmaring *ring,
                                  dma_addr_t addr,
                                  size_t buffersize, bool dma_to_device)
{
        if (unlikely(dma_mapping_error(ring->dev->dev->dma_dev, addr)))

It crashes on this line ---^


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
