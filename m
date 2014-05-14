Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:42246 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbaENDSQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2014 23:18:16 -0400
Date: Wed, 14 May 2014 13:18:05 +1000
From: James Cameron <quozl@laptop.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Avinash Patil <patila@marvell.com>
Subject: Re: mwifiex: no wr_port available
Message-ID: <20140514031804.GN12785@us.netrek.org> (sfid-20140514_051819_713011_4BC1A9EE)
References: <20140507120634.GM17490@us.netrek.org>
 <477F20668A386D41ADCC57781B1F70430F70D87C4D@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <477F20668A386D41ADCC57781B1F70430F70D87C4D@SC-VEXCH1.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 13, 2014 at 07:52:47PM -0700, Bing Zhao wrote:
> Hi James,
> 
> > G'day,
> > 
> > Is there a short duration leak of wr_port in
> > mwifiex_sdio_host_to_card()?
> 
> You are right. There is a leak in the error case. Thanks for
> pointing it out.

Thanks.

> > If mwifiex_host_to_card_mp_aggr fails because of is_suspended in
> > mwifiex_write_data_sync, is the wr_port ever released?
> > 
> > Or maybe mp_wr_bitmap is re-read from the card when a download
> > interrupt occurs, or if an upload interrupt occurs after a command is
> > sent.
> 
> A patch has been sent to address this issue.

Reviewed, thanks.  Functionally identical to a patch that I've been
testing locally:

/*
 * Rollback the effects of _get_wr_port above.
 */
static void mwifiex_put_wr_port(struct mwifiex_adapter *adapter, u8 port)
{
	struct sdio_mmc_card *card = adapter->card;

	card->mp_wr_bitmap |= (1 << port);
	card->curr_wr_port = port;
}

...

		if (type == MWIFIEX_TYPE_DATA) {
			mwifiex_put_wr_port(adapter, port);
			adapter->data_sent = false;
		}

You may be interested that rd_port also has possible leak when skb
cannot be allocated.  See mwifiex_process_int_status:

		skb = dev_alloc_skb(rx_len);
		if (!skb)
			return -1;

We have a hack in OLPC production arm-3.5 kernel which restores
rd_port bit, restores int_status.

http://dev.laptop.org/git/olpc-kernel/commit/?h=arm-3.5&id=59fcaf10cce5bbdc370ec1c262b12aeb66ed1dca

-- 
James Cameron
http://quozl.linux.org.au/
