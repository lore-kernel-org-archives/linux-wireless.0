Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38778
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932508AbZJ3SQo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 14:16:44 -0400
Date: Fri, 30 Oct 2009 11:17:08 -0700 (PDT)
Message-Id: <20091030.111708.60089475.davem@davemloft.net>
To: dwmw2@infradead.org
Cc: linville@tuxdriver.com, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org, dcbw@redhat.com,
	stern@rowland.harvard.edu
Subject: Re: [PATCH] libertas if_usb: Fix crash on 64-bit machines
From: David Miller <davem@davemloft.net>
In-Reply-To: <1256924714.4030.44.camel@macbook.infradead.org>
References: <1256924714.4030.44.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Woodhouse <dwmw2@infradead.org>
Date: Fri, 30 Oct 2009 17:45:14 +0000

> On a 64-bit kernel, skb->tail is an offset, not a pointer. The libertas
> usb driver passes it to usb_fill_bulk_urb() anyway, causing interesting
> crashes. Fix that by using skb->data instead.
> 
> This highlights a problem with usb_fill_bulk_urb(). It doesn't notice
> when dma_map_single() fails and return the error to its caller as it
> should. In fact it _can't_ currently return the error, since it returns
> void.
> 
> So this problem was showing up only at unmap time, after we'd already
> suffered memory corruption by doing DMA to a bogus address.
> 
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> Cc: stable@kernel.org

Acked-by: David S. Miller <davem@davemloft.net>
