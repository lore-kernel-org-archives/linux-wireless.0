Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35058 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932942Ab2AITa0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 14:30:26 -0500
Message-ID: <4F0B4049.4070306@qca.qualcomm.com> (sfid-20120109_203033_802179_3AE86DB9)
Date: Mon, 9 Jan 2012 21:30:17 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 2/8] ath6kl: Re-architect suspend mode handling in ath6kl_sdio_suspend()
References: <1326098182-9103-1-git-send-email-rmani@qca.qualcomm.com> <1326098182-9103-3-git-send-email-rmani@qca.qualcomm.com>
In-Reply-To: <1326098182-9103-3-git-send-email-rmani@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/09/2012 10:36 AM, rmani@qca.qualcomm.com wrote:
> From: Raja Mani <rmani@qca.qualcomm.com>
> 
> Dynamic suspend mode selection logic based on the host sdio
> controller capability (MMC_PM_KEEP_POWER and MMC_PM_WAKE_SDIO_IRQ)
> is completely removed.

What's the reason for this change? This loses all the automatic
detection we have. I would hope that we could keep the existing
detection capability and use the module parameter to override the
detection logic or something like that.

The driver should be as automatic as possible and the suspend_mode
module parameter should be used to override something.

> Additionally, new logic is added to have backup retry.
> In other words, If the driver fails to enter into either
> WOW (or) DEEP SLEEP mode, it would give a try in CUT POWER mode.

So the function now has a loop. To me that sounds very confusing and
error prone. What's the reason for this?

Kalle
