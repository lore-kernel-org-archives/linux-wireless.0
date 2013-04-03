Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sapphire.tuxdriver.com ([70.61.120.61]:44016 "EHLO
	Linville-X1.hq.tuxdriver.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758784Ab3DCRdK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 13:33:10 -0400
Date: Wed, 3 Apr 2013 13:32:48 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Cc: linux-wireless@vger.kernel.org,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 0/4] rtlwifi: usb: improve RX performance and lower CPU
 usage
Message-ID: <20130403173248.GA14611@tuxdriver.com> (sfid-20130403_193314_921728_58F05376)
References: <20130317095831.24983.97107.stgit@localhost6.localdomain6>
 <515C63E4.7020506@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <515C63E4.7020506@iki.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

They are in wireless-next...

commit 657e27656dfb3a99e81c99df6e78e770d7fe0d48
Author: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Date:   Sun Mar 17 11:59:29 2013 +0200

    rtlwifi: usb: add NET_IP_ALIGN padding to RX skb when needed
    
    Add proper alignment at first packet copy, to avoid extra copies made later
    in networking stack.
    
    Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

commit 29bb7013a53d8fc43f79f39d22a15ba8d3e77d9b
Author: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Date:   Sun Mar 17 11:59:24 2013 +0200

    rtlwifi: usb: defer rx processing to tasklet
    
    Move processing of received packets to tasklet from hard-irq context.
    
    Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

commit d7d0f081c48951018133cac38c8c0796f37db727
Author: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Date:   Sun Mar 17 11:59:18 2013 +0200

    rtlwifi: usb: remove extra skb copy on RX path
    
    RX path has extra copying of packets, that can be avoided.
    
    Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

commit 872de8ff04922e4ad95c5af39131ae9fbefe6ac5
Author: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Date:   Sun Mar 17 11:59:13 2013 +0200

    rtlwifi: usb: use usb_alloc_coherent for RX buffers
    
    Use dedicated DMA coherent buffers for RX urbs, to avoid allocation of large
    skbuffs in hard-irq context and improve performance.
    
    Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

On Wed, Apr 03, 2013 at 08:16:20PM +0300, Jussi Kivilinna wrote:
> Any comments on this patchset?
> 
> On 17.03.2013 11:59, Jussi Kivilinna wrote:
> > Patchset improves RX path handling in rtlwifi/usb.c by:
> >  - change to use preallocated DMA coherent URB buffers.
> >  - kill unnessasary skbuff copies.
> >  - defer RX processing to tasklet.
> >  - add proper alignment of skbuff early on.
> > 
> > With this patchset IRQ CPU usage drops from 37% to 25% on ARM system with
> > 1Ghz Cortex-A8, when doing large transfer with rtl8192cu. Tranfer speed
> > appears to be slightly improved too, from 29Mbit to 31Mbit.
> > 
> > ---
> > 
> > Jussi Kivilinna (4):
> >       rtlwifi: usb: use usb_alloc_coherent for RX buffers
> >       rtlwifi: usb: remove extra skb copy on RX path
> >       rtlwifi: usb: defer rx processing to tasklet
> >       rtlwifi: usb: add NET_IP_ALIGN padding to RX skb when needed
> > 
> > 
> >  drivers/net/wireless/rtlwifi/rtl8192cu/trx.c |    2
> >  drivers/net/wireless/rtlwifi/usb.c           |  220 ++++++++++++++++++--------
> >  drivers/net/wireless/rtlwifi/usb.h           |    5 -
> >  3 files changed, 156 insertions(+), 71 deletions(-)
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
