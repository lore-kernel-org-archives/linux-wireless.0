Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:14375 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934252Ab3JPNbs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Oct 2013 09:31:48 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 6/7] ath10k: fix device initialization routine
References: <1381858196-17000-1-git-send-email-michal.kazior@tieto.com>
	<1381858196-17000-7-git-send-email-michal.kazior@tieto.com>
Date: Wed, 16 Oct 2013 16:31:42 +0300
In-Reply-To: <1381858196-17000-7-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 15 Oct 2013 10:29:55 -0700")
Message-ID: <877gdd735t.fsf@kamboji.qca.qualcomm.com> (sfid-20131016_153159_274520_2BF48697)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Hardware revision 2 does not support cold reset
> correctly. As such it would sometimes lead to host
> machine freeze or data bus errors.
>
> The patch introduces warm reset function which is
> used instead of the cold reset one. It also moves
> the reset before interrupts are being set up to
> prevent any kind of spurious interrupts from being
> handled.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

> +	/* reset CE */
> +	addr = ar_pci->mem + RTC_SOC_BASE_ADDRESS + SOC_RESET_CONTROL_ADDRESS;
> +	val = ioread32(addr);
> +	val |= SOC_RESET_CONTROL_CE_RST_MASK;
> +	iowrite32(val, addr);
> +	val = ioread32(addr);
> +	msleep(10);
> +
> +	/* unreset CE */
> +	val &= ~SOC_RESET_CONTROL_CE_RST_MASK, addr;
> +	iowrite32(val, addr);

This looks wrong, I assume it was supposed to be this:

val &= ~SOC_RESET_CONTROL_CE_RST_MASK;

-- 
Kalle Valo
