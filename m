Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:36338 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751020AbeEBNHd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 09:07:33 -0400
Date: Wed, 2 May 2018 15:07:26 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: [RFC 06/18] mt76x2: introduce mt76x2_mac_load_tx_status routine
Message-ID: <20180502130726.GA13887@redhat.com> (sfid-20180502_151314_065630_A283C7F0)
References: <cover.1525096206.git.lorenzo.bianconi@redhat.com>
 <9d50bf4d74ec52e141dd112768570e15a481ad2e.1525096206.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9d50bf4d74ec52e141dd112768570e15a481ad2e.1525096206.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 30, 2018 at 04:12:21PM +0200, Lorenzo Bianconi wrote:
> Add mt76x2_mac_load_tx_status routine since tx stats register map is
> shared between usb and pci based devices but usb devices do not have a
> tx stat irq line as pcie ones and it is necessary to load tx statistics
> using a workqueue
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt76x2_mac.c | 43 +++++++++++++++----------
>  1 file changed, 26 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
> index d18315652583..0ddc84525ffa 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
> @@ -515,6 +515,28 @@ mt76x2_send_tx_status(struct mt76x2_dev *dev, struct mt76x2_tx_status *stat,
>  	rcu_read_unlock();
>  }
>  
> +static struct mt76x2_tx_status
> +mt76x2_mac_load_tx_status(struct mt76x2_dev *dev)
> +{
> +	struct mt76x2_tx_status stat = {};
> +	u32 stat1, stat2;
> +
> +	stat2 = mt76_rr(dev, MT_TX_STAT_FIFO_EXT);
> +	stat1 = mt76_rr(dev, MT_TX_STAT_FIFO);
> +
> +	stat.valid = !!(stat1 & MT_TX_STAT_FIFO_VALID);
> +	stat.success = !!(stat1 & MT_TX_STAT_FIFO_SUCCESS);
> +	stat.aggr = !!(stat1 & MT_TX_STAT_FIFO_AGGR);
> +	stat.ack_req = !!(stat1 & MT_TX_STAT_FIFO_ACKREQ);
> +	stat.wcid = FIELD_GET(MT_TX_STAT_FIFO_WCID, stat1);
> +	stat.rate = FIELD_GET(MT_TX_STAT_FIFO_RATE, stat1);
> +
> +	stat.retry = FIELD_GET(MT_TX_STAT_FIFO_EXT_RETRY, stat2);
> +	stat.pktid = FIELD_GET(MT_TX_STAT_FIFO_EXT_PKTID, stat2);
> +
> +	return stat;
> +}
> +

Just two minor points. We do not need fill structure if stat is
not valid. Also returning mt76x2_tx_status structure might require
full copy of it. Returning boolean indicator of validity and pass
pointer to struct mt76x2_tx_status to the subroutine would be more
efficient.

Regards
Stanislaw
