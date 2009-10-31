Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:34129 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757591AbZJaBll (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 21:41:41 -0400
Date: Fri, 30 Oct 2009 21:41:45 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: David Woodhouse <dwmw2@infradead.org>
cc: Christian Lamparter <chunkeey@googlemail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	<linville@tuxdriver.com>, <libertas-dev@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>, <dcbw@redhat.com>,
	<davem@davemloft.net>
Subject: Re: [PATCH] libertas if_usb: Fix crash on 64-bit machines
In-Reply-To: <1256928681.4030.112.camel@macbook.infradead.org>
Message-ID: <Pine.LNX.4.44L0.0910302138500.29480-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 30 Oct 2009, David Woodhouse wrote:

> On Fri, 2009-10-30 at 19:44 +0100, Christian Lamparter wrote:
> > 
> > that's just a fill-in macro.
> > AFAICT usb_submit_urb does the tricky dma mapping.
> 
> Ah, that makes sense. In that case, all we need to do is make
> map_urb_for_dma() do the right thing.

map_urb_for_dma() does little more than call dma_map_single().  That's 
what you'll have to fix.

Alan Stern

