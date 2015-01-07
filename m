Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:57933 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbbAGIMb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 03:12:31 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: <linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: Re: [PATCH 17/22] wil6210: add advanced interrupt moderation
References: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<1419320844-23989-18-git-send-email-qca_vkondrat@qca.qualcomm.com>
Date: Wed, 07 Jan 2015 10:12:24 +0200
In-Reply-To: <1419320844-23989-18-git-send-email-qca_vkondrat@qca.qualcomm.com>
	(Vladimir Kondratiev's message of "Tue, 23 Dec 2014 09:47:19 +0200")
Message-ID: <87mw5vt3fb.fsf@kamboji.qca.qualcomm.com> (sfid-20150107_091234_638142_7878D320)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com> writes:

> Add advanced interrupt moderation support available since "Sparrow B0".
> Legacy interrupt moderation used only one counter to moderate tx, rx,
> and misc interrupts.
> Advanced interrupt moderation bypasses misc, and handles separately tx
> and rx interrupts. In addition it has two timers for each interrupt type.
> Max burst duration timer which defines how long to postpone interrupt after
> first event (receive event for rx and tx complete event for tx), and
> interframe timeout which defines how to determine the end of the burst and
> issue interrupt even if the first timer still pending.
> Capabilities flags in wil_priv is set on initialization according to
> HW. The rest of the code checks for advanced interrupt capability bit
> in capabilities flags field.
> Debugfs is split accordingly: "legacy" interrupt moderation remains
> unchanged, new debugs files added for advanced interrupt moderation
> support.
> Module params are aligned to support advanced interrupt moderation
> (tx & rx). When not available (for legacy interrupt moderation) will
> use only rx configuration; Tx configuration will be ignored in this
> case.
>
> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

[...]

> --- a/drivers/net/wireless/ath/wil6210/main.c
> +++ b/drivers/net/wireless/ath/wil6210/main.c
> @@ -33,10 +33,34 @@ static bool no_fw_load = true;
>  module_param(no_fw_load, bool, S_IRUGO | S_IWUSR);
>  MODULE_PARM_DESC(no_fw_load, " do not download FW, use one in on-card flash.");
>  
> -static unsigned int itr_trsh = WIL6210_ITR_TRSH_DEFAULT;
> +static unsigned int tx_interframe_timeout =
> +		WIL6210_ITR_TX_INTERFRAME_TIMEOUT_DEFAULT;
> +
> +module_param(tx_interframe_timeout, uint, S_IRUGO);
> +MODULE_PARM_DESC(tx_interframe_timeout,
> +		 " Interrupt moderation TX interframe timeout, usecs.");
> +
> +static unsigned int rx_interframe_timeout =
> +		WIL6210_ITR_RX_INTERFRAME_TIMEOUT_DEFAULT;
> +
> +module_param(rx_interframe_timeout, uint, S_IRUGO);
> +MODULE_PARM_DESC(rx_interframe_timeout,
> +		 " Interrupt moderation RX interframe timeout, usecs.");
> +
> +static unsigned int tx_max_burst_duration =
> +		WIL6210_ITR_TX_MAX_BURST_DURATION_DEFAULT;
> +
> +module_param(tx_max_burst_duration, uint, S_IRUGO);
> +MODULE_PARM_DESC(tx_max_burst_duration,
> +		 " Interrupt moderation TX max burst duration, usecs.");
> +
> +static unsigned int rx_max_burst_duration =
> +		WIL6210_ITR_RX_MAX_BURST_DURATION_DEFAULT;
> +
> +module_param(rx_max_burst_duration, uint, S_IRUGO);
> +MODULE_PARM_DESC(rx_max_burst_duration,
> +		 " Interrupt moderation RX max burst duration, usecs.");
>  
> -module_param(itr_trsh, uint, S_IRUGO);
> -MODULE_PARM_DESC(itr_trsh, " Interrupt moderation threshold, usecs.");

The number of module parameters feels a little excessive, especially
when you add one more in the following patch. Is it really necessary for
the user to configure all these? Why can't the driver pick good
defaults?

-- 
Kalle Valo
