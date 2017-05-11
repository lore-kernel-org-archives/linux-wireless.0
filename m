Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37006 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751405AbdEKSfP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 May 2017 14:35:15 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: Re: [v2 07/11] rsi: Add usb multi-byte read operation
References: <1494336614-2107-1-git-send-email-amit.karwar@redpinesignals.com>
        <1494336614-2107-8-git-send-email-amit.karwar@redpinesignals.com>
Date: Thu, 11 May 2017 21:35:10 +0300
In-Reply-To: <1494336614-2107-8-git-send-email-amit.karwar@redpinesignals.com>
        (Amitkumar Karwar's message of "Tue, 9 May 2017 19:00:10 +0530")
Message-ID: <87bmqzs0m9.fsf@kamboji.qca.qualcomm.com> (sfid-20170511_203519_128484_00D990BF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> writes:

> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>
> USB multibyte read will be used in the new firmware loading method
> for RS9113 chipset.
>
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>

[...]

> +static int rsi_usb_read_register_multiple(struct rsi_hw *adapter, u32 addr,
> +					  u8 *data, u16 count)
> +{
> +	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
> +	u8 *buf;
> +	u16 transfer;
> +	int status;
> +
> +	if (!addr)
> +		return -EINVAL;
> +
> +	buf = kzalloc(4096, GFP_KERNEL);
> +	if (!buf)
> +		return -ENOMEM;
> +
> +	while (count) {
> +		transfer = min_t(u16, count, 4096);

A minor thing, no need to resend just because of this. But a define for
4096 would be nice.

-- 
Kalle Valo
