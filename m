Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:37970 "EHLO purkki.valot.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776Ab0DMRFb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Apr 2010 13:05:31 -0400
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wl1251: read default MAC address from EEPROM when available
References: <1271110884-18545-1-git-send-email-notasas@gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 13 Apr 2010 20:05:29 +0300
In-Reply-To: <1271110884-18545-1-git-send-email-notasas@gmail.com> (Grazvydas Ignotas's message of "Tue\, 13 Apr 2010 01\:21\:24 +0300")
Message-ID: <87fx2znuzq.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Grazvydas Ignotas <notasas@gmail.com> writes:

> Some wl1251 hardware configurations (like in WG7210 module) have
> EEPROM attached where NVS data is kept, which includes MAC address.
>
> In such configurations, let's read default MAC address from EEPROM,
> instead of using random one.

This also looks good, just one comment:

> +static int wl1251_read_eeprom_byte(struct wl1251 *wl, off_t offset, u8 *data)
> +{
> +	unsigned long timeout;
> +
> +	wl1251_reg_write32(wl, EE_ADDR, offset);
> +	wl1251_reg_write32(wl, EE_CTL, EE_CTL_READ);
> +
> +	/* EE_CTL_READ clears when data is ready */
> +	timeout = jiffies + msecs_to_jiffies(100);
> +	while (1) {
> +		if (!(wl1251_reg_read32(wl, EE_CTL) & EE_CTL_READ))
> +			break;
> +
> +		if (time_after(jiffies, timeout))
> +			return -ETIMEDOUT;
> +
> +		udelay(200);
> +	}

Is the udelay() really needed here? In my opinion msleep(), for
example with a value of 5 ms, would be nicer from system point of
view. It doesn't matter if this function takes few milliseconds
longer, because this is called only in op_start(). What do you think?

-- 
Kalle Valo
