Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34381 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab3HZUAW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Aug 2013 16:00:22 -0400
Date: Mon, 26 Aug 2013 15:56:55 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: Tobias Waldekranz <tobias@waldekranz.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mwifiex: add missing endian conversions
Message-ID: <20130826195655.GD1923@tuxdriver.com> (sfid-20130826_220025_893086_4444025F)
References: <20130826071806.GA3035@gmail.com>
 <477F20668A386D41ADCC57781B1F70430EAF1FEDA3@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <477F20668A386D41ADCC57781B1F70430EAF1FEDA3@SC-VEXCH1.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 26, 2013 at 12:27:06PM -0700, Bing Zhao wrote:
> Hi Tobias,
> 
> > Fixes multiple locations where a little endian host is assumed during
> > ser/des of messages sent to/received from the chip.
> 
> Thanks for your patch.
> It doesn't apply to wireless or wireless-next trees.
> 
> Which git tree are you using?

I got it to apply with a little trying.

> > 
> > Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> > ---
> >  drivers/net/wireless/mwifiex/11n_aggr.c    | 2 +-
> >  drivers/net/wireless/mwifiex/main.h        | 2 +-
> >  drivers/net/wireless/mwifiex/sdio.c        | 6 +++---
> >  drivers/net/wireless/mwifiex/sta_cmdresp.c | 2 +-
> >  4 files changed, 6 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
> > index a78e065..b53c73c 100644
> > --- a/drivers/net/wireless/mwifiex/11n_aggr.c
> > +++ b/drivers/net/wireless/mwifiex/11n_aggr.c
> > @@ -69,7 +69,7 @@ mwifiex_11n_form_amsdu_pkt(struct sk_buff *skb_aggr,
> >  	memcpy(&tx_header->eth803_hdr, skb_src->data, dt_offset);
> > 
> >  	/* Copy SNAP header */
> > -	snap.snap_type = *(u16 *) ((u8 *)skb_src->data + dt_offset);
> > +	snap.snap_type = le16_to_cpu(*(__le16 *) ((u8 *)skb_src->data + dt_offset));
> 
> This line exceeds 80 characters. Please break it to two lines.

Please submit a new patch to fix this.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
