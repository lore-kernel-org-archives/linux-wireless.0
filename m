Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:58958 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358Ab0KGKSk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Nov 2010 05:18:40 -0500
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: Re: [PATCH 2/3] wl1251: add runtime PM support for SDIO
References: <1288822429-24541-1-git-send-email-notasas@gmail.com>
	<1288822429-24541-3-git-send-email-notasas@gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Sun, 07 Nov 2010 12:18:37 +0200
In-Reply-To: <1288822429-24541-3-git-send-email-notasas@gmail.com> (Grazvydas Ignotas's message of "Thu\,  4 Nov 2010 00\:13\:48 +0200")
Message-ID: <87d3qhzbb6.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Grazvydas Ignotas <notasas@gmail.com> writes:

> Add runtime PM support, similar to how it's done for wl1271.
> This allows to power down the card when the driver is loaded but
> network is not in use.

Few minor comments:

> +	/* Undo decrement done above in wl1271_probe */

Should be wl1251_probe().

> +static int wl1251_suspend(struct device *dev)
> +{
> +	/*
> +	 * Tell MMC/SDIO core it's OK to power down the card
> +	 * (if it isn't already), but not to remove it completely
> +	 */
> +	return 0;
> +}

Sorry, I'm not familiar with pm_ops and I don't fully understand the
comment above. Does the comment mean that by returning 0 we can
accomplish all that? Or instead is it a fixme comment that we should
do that, but it's not implemented yet?

-- 
Kalle Valo
