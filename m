Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25976 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab1KGVFF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 16:05:05 -0500
Message-ID: <4EB847FC.9040209@qca.qualcomm.com> (sfid-20111107_220510_431867_CC543B1D)
Date: Mon, 7 Nov 2011 23:05:00 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Raja Mani <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 10/11] ath6kl: Remove WARN_ON msg in Suspend path
References: <1320643547-3578-1-git-send-email-rmani@qca.qualcomm.com> <1320643547-3578-11-git-send-email-rmani@qca.qualcomm.com>
In-Reply-To: <1320643547-3578-11-git-send-email-rmani@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/07/2011 07:25 AM, Raja Mani wrote:
> In the current code, WOW resume is executed first from RX path
> and ar->state is moved to ATH6KL_STATE_ON. When platform calls
> ath6kl_sdio_resume() in CFG resume context, that time ar->state
> could have moved to ON state. Printing WARN_ON(1) is void in
> this context. Hence removing this.
> 
> Once WOW resume is removed from RX path, This WARN_ON msg can be
> reverted.

I changed places with this and patch 9. This is to avoid useless
warnings during bisect.

Kalle
