Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36100 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751405AbeBAGaO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Feb 2018 01:30:14 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: marcel@holtmann.org, linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Subject: Re: [v5 1/8] rsi: add rx control block to handle rx packets in USB
References: <1513168977-2121-1-git-send-email-amitkarwar@gmail.com>
        <1513168977-2121-2-git-send-email-amitkarwar@gmail.com>
Date: Thu, 01 Feb 2018 08:30:09 +0200
In-Reply-To: <1513168977-2121-2-git-send-email-amitkarwar@gmail.com>
        (Amitkumar Karwar's message of "Wed, 13 Dec 2017 18:12:50 +0530")
Message-ID: <87372lnrwu.fsf@purkki.adurom.net> (sfid-20180201_073019_306020_30598D1C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> writes:

> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>
> Rx bluetooth endpoint shall be added in further patches. Rx control
> block is introduced here to handle Rx packets properly. Separate
> function is written to initialize the RX control blocks.
>
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>

[...]

> +static int rsi_usb_init_rx(struct rsi_hw *adapter)
> +{
> +	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
> +	struct rx_usb_ctrl_block *rx_cb;
> +	u8 idx;
> +
> +	for (idx = 0; idx < MAX_RX_URBS; idx++) {
> +		rx_cb = &dev->rx_cb[idx];
> +
> +		rx_cb->rx_buffer = kzalloc(RSI_USB_BUF_SIZE * 2,
> +					   GFP_KERNEL | GFP_DMA);

Do you really need GFP_DMA? From the documentation:

 "GFP_DMA exists for historical reasons and should be avoided where
  possible."

-- 
Kalle Valo
