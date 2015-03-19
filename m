Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:47302 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750993AbbCSQ7v convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2015 12:59:51 -0400
From: Avinash Patil <patila@marvell.com>
To: "quozl@laptop.org" <quozl@laptop.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Cathy Luo <cluo@marvell.com>, Zhaoyang Liu <liuzy@marvell.com>,
	Chin-Ran Lo <crlo@marvell.com>, Plus Chen <pchen@marvell.com>,
	Shengzhen Li <szli@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>
Date: Thu, 19 Mar 2015 09:59:25 -0700
Subject: RE: [PATCHv2 9/9] mwifiex: delay skb allocation for RX until cmd53
 over
Message-ID: <CBACCFA0AEB13A41977475BCF3E896FC6674840672@SC-VEXCH2.marvell.com> (sfid-20150319_175954_769471_C2F03245)
References: <1426248479-28451-1-git-send-email-patila@marvell.com>
 <1426248479-28451-10-git-send-email-patila@marvell.com>
 <20150313072010.GU17299@us.netrek.org>
In-Reply-To: <20150313072010.GU17299@us.netrek.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi James,

> -----Original Message-----
> From: quozl@laptop.org [mailto:quozl@laptop.org]
> Sent: Friday, March 13, 2015 12:50 PM
> To: Avinash Patil
> Cc: linux-wireless@vger.kernel.org; Amitkumar Karwar; Cathy Luo; Zhaoyang Liu;
> Chin-Ran Lo; Plus Chen; Shengzhen Li; Nishant Sarmukadam
> Subject: Re: [PATCHv2 9/9] mwifiex: delay skb allocation for RX until cmd53
> over
> 
> On Fri, Mar 13, 2015 at 05:37:59PM +0530, Avinash Patil wrote:
> > From: Zhaoyang Liu <liuzy@marvell.com>
> >
> > This patch moves SKB allocation for RX packets from current place i.e.
> > after reading MP regs to place where we already have read data from
> > SDIO bus ie after cmd53.
> >
> > mp_rx_aggr_setup has been modified accordingly to set skb_arr to NULL.
> >
> > Signed-off-by: Zhaoyang Liu <liuzy@marvell.com>
> > Signed-off-by: Shengzhen Li <szli@marvell.com>
> > Reviewed-by: Amitkumar Karwar <akarwar@marvell.com>
> > Reviewed-by: Cathy Luo <cluo@marvell.com>
> > Reviewed-by: Avinash Patil <patila@marvell.com>
> > ---
> >  drivers/net/wireless/mwifiex/sdio.c | 59
> > ++++++++++++++++++-------------------
> >  drivers/net/wireless/mwifiex/sdio.h |  8 ++---
> >  2 files changed, 33 insertions(+), 34 deletions(-)
> >
> > diff --git a/drivers/net/wireless/mwifiex/sdio.c
> > b/drivers/net/wireless/mwifiex/sdio.c
> > index fdeeb67..330e9d0 100644
> > --- a/drivers/net/wireless/mwifiex/sdio.c
> > +++ b/drivers/net/wireless/mwifiex/sdio.c
> 
> [snip]
> 
> > @@ -1538,24 +1550,11 @@ static int mwifiex_process_int_status(struct
> mwifiex_adapter *adapter)
> >  					rx_len);
> >  				return -1;
> >  			}
> > -			rx_len = (u16) (rx_blocks * MWIFIEX_SDIO_BLOCK_SIZE);
> >
> > -			skb = mwifiex_alloc_dma_align_buf(rx_len,
> > -							  GFP_KERNEL |
> > -							  GFP_DMA);
> > -
> > -			if (!skb) {
> > -				dev_err(adapter->dev, "%s: failed to alloc skb",
> > -					__func__);
> > -				return -1;
> > -			}
> 
> I like it.
> 
> Because I continue to have problems with dev_alloc_skb failing, and the
> "return -1;" that you are removing doesn't seem to leave the card and driver
> in a useful state.
> 
> Your patch is hopefully an improvement.
> 
> Have you done any testing of response after skb allocation failure before and
> after your patch?

Yes; we have tested skb allocation failures but only for stability purposes. Unfortunately data path would still remain stuck after such allocation failures. We are working on a fix to ensure data patch also recovers in this case and soon submit a patch.
> --
> James Cameron
> http://quozl.linux.org.au/

-Avinash
