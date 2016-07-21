Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:49758 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751462AbcGUJsa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2016 05:48:30 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Cathy Luo" <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>
Subject: RE: [PATCH 6/9] mwifiex: process rxba_sync event
Date: Thu, 21 Jul 2016 09:48:26 +0000
Message-ID: <7fc6db4ae2f64443b863180bf2b90bf8@SC-EXCH04.marvell.com> (sfid-20160721_114833_964260_1A9532BA)
References: <1468248832-21969-1-git-send-email-akarwar@marvell.com>
	<1468248832-21969-7-git-send-email-akarwar@marvell.com>
 <87mvlex3jx.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87mvlex3jx.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

> From: Kalle Valo [mailto:kvalo@codeaurora.org]
> Sent: Monday, July 18, 2016 10:54 PM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
> Xinming Hu
> Subject: Re: [PATCH 6/9] mwifiex: process rxba_sync event
> 
> Amitkumar Karwar <akarwar@marvell.com> writes:
> 
> > From: Xinming Hu <huxm@marvell.com>
> >
> > Firmware may filter and drop packets under certain condition, for
> > example, ARP SA=DA packet. this event will be used to synchronize the
> > Rx Block Acknowledgment (BA) window bitmap and to fill any holes in
> > driver side.
> >
> > Signed-off-by: Xinming Hu <huxm@marvell.com>
> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> 
> [...]
> 
> > --- a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
> > +++ b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
> > @@ -78,8 +78,15 @@ static int mwifiex_11n_dispatch_amsdu_pkt(struct
> mwifiex_private *priv,
> >   */
> >  static int mwifiex_11n_dispatch_pkt(struct mwifiex_private *priv,
> > void *payload)  {
> > -	int ret = mwifiex_11n_dispatch_amsdu_pkt(priv, payload);
> >
> > +	int ret;
> > +
> > +	if (payload == (void *)MWIFIEX_RX_PKT_DROPPED_IN_FW) {
> > +		mwifiex_dbg(priv->adapter, INFO, "info: fw drop data\n");
> > +		return 0;
> > +	}
> 
> [...]
> 
> > +					mwifiex_dbg(priv->adapter, ERROR,
> > +						    "drop packet,seq=%d\n",
> > +						    seq_num);
> > +
> > +					ret = mwifiex_11n_rx_reorder_pkt
> > +					(priv, seq_num, tlv_rxba->tid,
> > +					 tlv_rxba->mac, 0,
> > +					 (void *)MWIFIEX_RX_PKT_DROPPED_IN_FW);
> 
> [...]
> 
> > +/* Indicate packet has been dropped in FW */
> > +#define MWIFIEX_RX_PKT_DROPPED_IN_FW             0xffffffff
> 
> That pointer magic is rather ugly, why not use a proper boolean?
> 

Thanks for review. I will get rid of this macro and submit updated version.

Regards,
Amitkumar
