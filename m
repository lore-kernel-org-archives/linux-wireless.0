Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58820 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751009AbdISOt1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Sep 2017 10:49:27 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>
Subject: Re: [PATCH] rsi: sdio suspend and resume support
References: <1504102172-5262-1-git-send-email-amitkarwar@gmail.com>
Date: Tue, 19 Sep 2017 17:49:22 +0300
In-Reply-To: <1504102172-5262-1-git-send-email-amitkarwar@gmail.com>
        (Amitkumar Karwar's message of "Wed, 30 Aug 2017 19:39:32 +0530")
Message-ID: <87h8vylp59.fsf@purkki.adurom.net> (sfid-20170919_164932_200435_DD8293C5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> writes:

> From: Karun Eagalapati <karun256@gmail.com>
>
> SDIO suspend and resume handlers are implemented and verified
> that device works after suspend/resume cycle.
>
> Signed-off-by: Karun Eagalapati <karun256@gmail.com>
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>

[...]

> +static int rsi_sdio_disable_interrupts(struct sdio_func *pfunc)
> +{
> +	struct rsi_hw *adapter = sdio_get_drvdata(pfunc);
> +	u8 isr_status = 0, data = 0;
> +	int ret;
> +
> +	rsi_dbg(INFO_ZONE, "Waiting for interrupts to be cleared..");
> +	do {
> +		rsi_sdio_read_register(adapter, RSI_FN1_INT_REGISTER,
> +				       &isr_status);
> +		rsi_dbg(INFO_ZONE, ".");
> +	} while (isr_status);

Never ending loops in kernel are always a bad idea, better to add a
reasonable timeout if/when something goes wrong.

-- 
Kalle Valo
