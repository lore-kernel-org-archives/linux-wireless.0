Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:39962 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757197AbYBLVMi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2008 16:12:38 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH RFT/RFC] b43: Add QOS support
Date: Tue, 12 Feb 2008 22:12:03 +0100
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Stefano Brivio <stefano.brivio@polimi.it>
References: <200802122205.42799.mb@bu3sch.de>
In-Reply-To: <200802122205.42799.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200802122212.03325.mb@bu3sch.de> (sfid-20080212_211242_827404_A22F9FE4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 12 February 2008 22:05:42 Michael Buesch wrote:
> This patch adds QOS support for b43.
> Please comment on this and test this.
> This patch depends on Johannes' "burst time -> txop patch" being _not_ applied.
> One can trivially fix that, though.
> +	for (i = 0; i < ARRAY_SIZE(wl->qos_params); i++) {
> +		params = &(wl->qos_params[i]);
> +		if (params->need_hw_update) {
> +			b43_qos_params_upload(dev, &(params->p),
> +					      qos_shm_offsets[i]);
> +			params->need_hw_update = 1;

Whoopsy, needs to be:
			params->need_hw_update = 0;

> +		}
> +	}
> +
> +	spin_unlock_irqrestore(&wl->irq_lock, flags);
> +	b43_mac_enable(dev);
> +}

> +/* Initialize the core's QOS capabilities */
> +static void b43_qos_init(struct b43_wldev *dev)
> +{
> +	/* Upload the current QOS parameters. */

And here we need a loop setting all "need_hw_update" to 1.

> +	b43_qos_update(dev);
> +	/* Enable QOS support. */
> +	b43_hf_write(dev, b43_hf_read(dev) | B43_HF_EDCF);
> +	b43_write16(dev, B43_MMIO_IFSCTL,
> +		    b43_read16(dev, B43_MMIO_IFSCTL)
> +		    | B43_MMIO_IFSCTL_USE_EDCF);
> +}

-- 
Greetings Michael.
