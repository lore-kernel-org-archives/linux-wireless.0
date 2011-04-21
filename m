Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:53052 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753911Ab1DUIXd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 04:23:33 -0400
Subject: Re: [PATCH V2 2/4] mwl8k: Add timestamp information for tx packets
From: Nishant Sarmukadam <nishants@marvell.com>
Reply-To: <nishants@marvell.com>
To: Lennert Buytenhek <buytenh@wantstofly.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Pradeep Nemavat <pnemavat@marvell.com>
In-Reply-To: <20110421074209.GX1897@wantstofly.org>
References: <1303231582-17333-1-git-send-email-nishants@marvell.com>
	 <1303231582-17333-2-git-send-email-nishants@marvell.com>
	 <20110421074209.GX1897@wantstofly.org>
Content-Type: text/plain
Date: Thu, 21 Apr 2011 13:45:10 +0530
Message-ID: <1303373710.24017.46.camel@localhost.localdomain>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Thu, 2011-04-21 at 00:42 -0700, Lennert Buytenhek wrote:
> On Tue, Apr 19, 2011 at 10:16:20PM +0530, Nishant Sarmukadam wrote:
> 
> > From: Pradeep Nemavat <pnemavat@marvell.com>
> > 
> > Timestamp tx packets using a HW micro-second timer.
> > This timestamp will be compared to the current timestamp
> > in the hardware and if the difference is greater than 500ms,
> > the packet will be dropped.
> > 
> > Signed-off-by: Pradeep Nemavat <pnemavat@marvell.com>
> > Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
> > ---
> >  drivers/net/wireless/mwl8k.c |   12 ++++++++++++
> >  1 files changed, 12 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
> > index 7968301..aca0139 100644
> > --- a/drivers/net/wireless/mwl8k.c
> > +++ b/drivers/net/wireless/mwl8k.c
> > @@ -1792,6 +1792,14 @@ static inline void mwl8k_tx_count_packet(struct ieee80211_sta *sta, u8 tid)
> >  		tx_stats->pkts++;
> >  }
> >  
> > +/* HW micro second timer register
> > + * located at offset 0xA600. This
> > + * will be used to timestamp tx
> > + * packets.
> > + */
> > +
> > +#define	MWL8K_HW_TIMER_REGISTER	(priv->regs + 0xA600)
> 
> 1. Ugly implicit 'priv' argument here. :-(
> 
>    Please just do something like:
> 
>  #define  MWL8K_A2H_INT_RX_READY                  (1 << 1)
>  #define  MWL8K_A2H_INT_TX_DONE                   (1 << 0)
> +
> +/* Misc registers */
> +#define MWL8K_HW_TIMER_REGISTER		0x0000a600
> 
>  #define MWL8K_A2H_EVENTS        (MWL8K_A2H_INT_DUMMY | \
>                                   MWL8K_A2H_INT_CHNL_SWITCHED | \
> 
>    and then just use it as ioread32(priv->regs + MWL8K_HW_TIMER_REGISTER).
> 
> 
Ok, will send out patch set V3 incorporating this change. 

> 2. Does this register exist on 8687/superfly3, or is it SJ only?

Yes, this does exist on 8687 and superfly3 as well. 


