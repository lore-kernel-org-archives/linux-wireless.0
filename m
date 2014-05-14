Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:38626 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752872AbaENDzN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2014 23:55:13 -0400
From: Bing Zhao <bzhao@marvell.com>
To: "quozl@laptop.org" <quozl@laptop.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Avinash Patil <patila@marvell.com>
Date: Tue, 13 May 2014 20:54:53 -0700
Subject: RE: mwifiex: no wr_port available
Message-ID: <477F20668A386D41ADCC57781B1F70430F70D87C6F@SC-VEXCH1.marvell.com> (sfid-20140514_055746_702395_32182AEE)
References: <20140507120634.GM17490@us.netrek.org>
 <477F20668A386D41ADCC57781B1F70430F70D87C4D@SC-VEXCH1.marvell.com>
 <20140514031804.GN12785@us.netrek.org>
In-Reply-To: <20140514031804.GN12785@us.netrek.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi James,

> > > If mwifiex_host_to_card_mp_aggr fails because of is_suspended in
> > > mwifiex_write_data_sync, is the wr_port ever released?
> > >
> > > Or maybe mp_wr_bitmap is re-read from the card when a download
> > > interrupt occurs, or if an upload interrupt occurs after a command is
> > > sent.
> >
> > A patch has been sent to address this issue.
> 
> Reviewed, thanks.  Functionally identical to a patch that I've been
> testing locally:

Thanks!

> 
> /*
>  * Rollback the effects of _get_wr_port above.
>  */
> static void mwifiex_put_wr_port(struct mwifiex_adapter *adapter, u8 port)
> {
> 	struct sdio_mmc_card *card = adapter->card;
> 
> 	card->mp_wr_bitmap |= (1 << port);
> 	card->curr_wr_port = port;
> }

Yeah, that's the same fix.

> 
> ...
> 
> 		if (type == MWIFIEX_TYPE_DATA) {
> 			mwifiex_put_wr_port(adapter, port);
> 			adapter->data_sent = false;
> 		}
> 
> You may be interested that rd_port also has possible leak when skb
> cannot be allocated.  See mwifiex_process_int_status:
> 
> 		skb = dev_alloc_skb(rx_len);
> 		if (!skb)
> 			return -1;
> 
> We have a hack in OLPC production arm-3.5 kernel which restores
> rd_port bit, restores int_status.
> 
> http://dev.laptop.org/git/olpc-kernel/commit/?h=arm-3.5&id=59fcaf10cce5bbdc370ec1c262b12aeb66ed1dca

The rd_port/int_status change looks correct. But what issue did you encounter prior to applying the change "cache the read bitmap at the time of the interrupt rather than when the interrupt status bits are handled"?

Thanks,
Bing

