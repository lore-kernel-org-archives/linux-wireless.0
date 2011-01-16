Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41547 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab1APLUd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Jan 2011 06:20:33 -0500
Received: by pva4 with SMTP id 4so689718pva.19
        for <linux-wireless@vger.kernel.org>; Sun, 16 Jan 2011 03:20:33 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19762.54371.65123.60502@gargle.gargle.HOWL>
Date: Sun, 16 Jan 2011 16:50:03 +0530
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k_htc: abort tx/rx on fast channel change
In-Reply-To: <1295158794-3088-1-git-send-email-rmanoharan@atheros.com>
References: <1295158794-3088-1-git-send-email-rmanoharan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan wrote:
> -	if (!fastcc)
> +	if (fastcc) {
> +		/* abort pending tx frames */
> +		WMI_CMD(WMI_ABORT_TX_DMA_CMDID);

Why abort instead of stop ?
And if i remember correctly, aborting of TX is enabled
only for the AR9003 family.

> +		WMI_CMD(WMI_ABORT_TXQ_CMDID);

This is exactly the same as DRAIN_TXQ_ALL.

> +		/* Clear receive filter */
> +		ath9k_hw_setrxfilter(ah, 0);

Why should the filter be cleared ?

> +		WMI_CMD(WMI_STOP_DMA_RECV_CMDID);

WMI_STOP_RECV does this already.

> +		WMI_CMD(WMI_RX_LINK_CMDID);

The host should have nothing to do with setting the rx_link
variable on the target. This WMI command should really be
removed.

A little more information on what this patch fixes would be nice.

Sujith
