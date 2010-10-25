Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from igloo.linux.gr ([62.1.205.36]:54184 "EHLO igloo.linux.gr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518Ab0JYRr5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Oct 2010 13:47:57 -0400
Date: Mon, 25 Oct 2010 19:44:20 +0200
From: Serafeim Zanikolas <sez@debian.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	herton@mandriva.com.br, joe@perches.com, davem@davemloft.net,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: rtl818x: request DMA-able memory
Message-ID: <20101025174420.GA3425@mobee>
References: <1287952327-9924-1-git-send-email-sez@debian.org>
 <4CC5851D.1040204@lwfinger.net>
 <4CC5900A.2050209@users.sourceforge.net>
 <20101025142232.GC2414@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20101025142232.GC2414@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 25, 2010 at 10:22:32AM -0400, John W. Linville wrote:
> On Mon, Oct 25, 2010 at 03:11:22PM +0100, Hin-Tak Leung wrote:
> > 
> > 
> > Larry Finger wrote:
> > >On 10/24/2010 03:32 PM, Serafeim Zanikolas wrote:
> > >>Despite the indicated intention in comment, the kmalloc() call was not
> > >>explicitly requesting memory from ZONE_DMA.
> > >>
> > >>Signed-off-by: Serafeim Zanikolas <sez@debian.org>
> > >>---
> > >> drivers/net/wireless/rtl818x/rtl8187_dev.c |    3 ++-
> > >> 1 files changed, 2 insertions(+), 1 deletions(-)
> > >>
> > >>diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
> > >>index 38fa824..771794d 100644
> > >>--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
> > >>+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
> > >>@@ -1343,7 +1343,8 @@ static int __devinit rtl8187_probe(struct usb_interface *intf,
> > >> 	priv->is_rtl8187b = (id->driver_info == DEVICE_RTL8187B);
> > >> 	/* allocate "DMA aware" buffer for register accesses */
> > >>-	priv->io_dmabuf = kmalloc(sizeof(*priv->io_dmabuf), GFP_KERNEL);
> > >>+	priv->io_dmabuf = kmalloc(sizeof(*priv->io_dmabuf),
> > >>+				  GFP_DMA | GFP_KERNEL);
> > >> 	if (!priv->io_dmabuf) {
> > >> 		err = -ENOMEM;
> > >> 		goto err_free_dev;
> > >
> > >ACK.
> > >
> > >Larry
> > 
> > Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>
> > 
> > I had a quick look for similiar constructs and AFAIK only the
> > b43/b43legacy drivers uses DMA buffers. Seems to be a rare practice.
> > Is that something we should or should not do?
> 
> It doesn't mean what you think it means.  It is a relic of the past,
> used to indicate memory below 16MB so that ISA devices could do DMA.

Right. Sorry for the noise.

-S
