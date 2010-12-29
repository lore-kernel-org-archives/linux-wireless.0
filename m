Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42270 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab0L2JPo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Dec 2010 04:15:44 -0500
Subject: Re: [PATCH 3/4] mwl8k: Set mac80211 rx status flags appropriately
 when hw crypto is enabled
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, mwl8k-devel@cozybit.com,
	buytenh@wantstofly.org, Nishant Sarmukadam <nishants@marvell.com>,
	yogesh powar <yogeshp@marvell.com>
In-Reply-To: <1293577297-25755-4-git-send-email-thomas@cozybit.com>
References: <1293577297-25755-1-git-send-email-thomas@cozybit.com>
	 <1293577297-25755-4-git-send-email-thomas@cozybit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Dec 2010 10:15:42 +0100
Message-ID: <1293614142.3546.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-12-28 at 15:01 -0800, Thomas Pedersen wrote:
> From: Nishant Sarmukadam <nishants@marvell.com>
> 
> When hw crypto is enabled, set rx status flags appropriately depending on
> whether hw crypto is enabled for a particular bss.
> Also report MIC errors to mac80211, so that counter measures can be
> initiated

> +	if ((rxd->rx_status != MWL8K_8366_AP_RXSTAT_GENERAL_DECRYPT_ERR) &&
> +		(rxd->rx_status & MWL8K_8366_AP_RXSTAT_DECRYPT_ERR_MASK) &&
> +		(rxd->rx_status & MWL8K_8366_AP_RXSTAT_TKIP_DECRYPT_MIC_ERR))
> +			status->flag |= RX_FLAG_MMIC_ERROR;

It's not my driver, so I don't care a whole lot, but this patch has some
pretty messed up indentation.

johannes

