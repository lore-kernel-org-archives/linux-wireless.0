Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:35650 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab1CJEV2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2011 23:21:28 -0500
Received: by vxi39 with SMTP id 39so1210245vxi.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 Mar 2011 20:21:27 -0800 (PST)
From: Mark Mentovai <mark@moxienet.com>
Content-Type: text/plain; charset=windows-1252
Subject: Re: [PATCH 2/4] ath9k: fix stopping tx dma on reset
Date: Wed, 9 Mar 2011 23:21:24 -0500
Message-Id: <5AF19632-CBB6-497C-8B47-1522BA6EA9F9@moxienet.com>
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
To: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1082)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> --- a/drivers/net/wireless/ath/ath9k/mac.c
[...]
> +bool ath9k_hw_abort_tx_dma(struct ath_hw *ah)
[...]
> +	for (q = 0; q < AR_NUM_QCU; q++) {
> +		for (i = 1000; i > 0; i--) {
> +			if (!ath9k_hw_numtxpending(ah, q))
> +				break;
> +
> +			udelay(5);
> +		}
> +	}
> +	if (!i)
> +		return false;

Awesome-looking patch set.

What’s the return value of this function supposed to mean? As written, it only returns false there’s anything left pending on the final queue. Notably, if the inner loop ran for all 999 iterations and ath9k_hw_numtxpending never returned false, the code above would effectively ignore that condition.

I’m less concerned about the return value (because it actually seems that the function could be declared void, you don’t use the return value anywhere) than I am about the REG_CLR_BIT and REG_WRITE operations that follow. It seems that you might be either missing those in cases where they should happen, or performing them in cases where they shouldn’t. Did you mean to leave AR_Q_TXD set when something is left pending on the final hardware queue?