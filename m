Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12543 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751607AbdAROtY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Jan 2017 09:49:24 -0500
Date: Wed, 18 Jan 2017 15:44:47 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Daniel Golle <daniel@makrotopia.org>
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: Re: [PATCH v2 08/14] rt2x00: rt2800mmio: add a workaround for
 spurious TX_FIFO_STATUS interrupts
Message-ID: <20170118144446.GA22837@redhat.com> (sfid-20170118_154928_090258_51C7474E)
References: <874m114lwq.fsf@codeaurora.org>
 <20170116030535.GA32238@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170116030535.GA32238@makrotopia.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 16, 2017 at 04:05:47AM +0100, Daniel Golle wrote:
>  irqreturn_t rt2800mmio_interrupt(int irq, void *dev_instance)
>  {
>  	struct rt2x00_dev *rt2x00dev = dev_instance;
>  	u32 reg, mask;
> +	u32 txstatus = 0;
>  
> -	/* Read status and ACK all interrupts */
> +	/* Read status */
>  	rt2x00mmio_register_read(rt2x00dev, INT_SOURCE_CSR, &reg);
> +
> +	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_TX_FIFO_STATUS)) {
> +		/* Due to unknown reason the hardware generates a
> +		 * TX_FIFO_STATUS interrupt before the TX_STA_FIFO
> +		 * register contain valid data. Read the TX status
> +		 * here to see if we have to process the actual
> +		 * request.
> +		 */
> +		rt2x00mmio_register_read(rt2x00dev, TX_STA_FIFO, &txstatus);
> +		if (rt2800mmio_txstatus_is_spurious(rt2x00dev, txstatus)) {
> +			/* Remove the TX_FIFO_STATUS bit so it won't be
> +			 * processed in this turn. The hardware will
> +			 * generate another IRQ for us.
> +			 */
> +			rt2x00_set_field32(&reg,
> +					   INT_SOURCE_CSR_TX_FIFO_STATUS, 0);
> +		}
> +	}
> +
> +	/* ACK interrupts */
>  	rt2x00mmio_register_write(rt2x00dev, INT_SOURCE_CSR, reg);

I think spurious TX_STA_FIFO problem happen because we first ACK
interrupt and then read in bulk all statuses from TX_STA_FIFO
register, while hardware generate new interrupt (as previous
was ACKed), then in new interrupt we have no more statues to
read.

This is inherently racy situation and first ACK interrupt and
then read statuses is safer than reverse order which make risk we
will have pending status and not get interrupt about that.

Hence I think we should not apply this patch.

Stanislaw 
