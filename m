Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53656 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751556AbeCMPQE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 11:16:04 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: Re: [PATCH 01/10] rsi: add support for hardware scan offload
References: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com>
        <1520260620-4694-2-git-send-email-amitkarwar@gmail.com>
Date: Tue, 13 Mar 2018 17:16:00 +0200
In-Reply-To: <1520260620-4694-2-git-send-email-amitkarwar@gmail.com>
        (Amitkumar Karwar's message of "Mon, 5 Mar 2018 20:06:51 +0530")
Message-ID: <87ina00zwv.fsf@purkki.adurom.net> (sfid-20180313_161608_346212_6304D4F4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> writes:

> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>
> With the current approach of scanning, roaming delays
> are observed. Firmware has support for back ground scanning.
> To get this advantage, mac80211 hardware scan is implemented.
> In this method, foreground scan is performed in driver and
> back ground scan is configured to firmware.

To me doesn't like a good idea to duplicate scan functionality in the
driver.

> --- a/drivers/net/wireless/rsi/rsi_91x_main.c
> +++ b/drivers/net/wireless/rsi/rsi_91x_main.c
> @@ -324,6 +324,14 @@ struct rsi_hw *rsi_91x_init(u16 oper_mode)
>  	mutex_init(&common->rx_lock);
>  	mutex_init(&common->tx_bus_mutex);
>  
> +	rsi_init_event(&common->chan_set_event);
> +	rsi_init_event(&common->probe_cfm_event);
> +	rsi_init_event(&common->chan_change_event);
> +	rsi_init_event(&common->cancel_hw_scan_event);

And I'm starting to dislike this rsi_init_event() even more (see my
other mail). In upstream driver's custom abstractions are very much
frowned upon, especially that it makes review harder.

-- 
Kalle Valo
