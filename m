Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:35814 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753316Ab0JDIul (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 04:50:41 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 04 Oct 2010 01:50:32 -0700
Date: Mon, 4 Oct 2010 14:26:18 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [PATCH 3/4] ath9k_hw: clean up register write buffering
Message-ID: <20101004085608.GA5931@vmraj-lnx.users.atheros.com>
References: <1286125639-15137-1-git-send-email-nbd@openwrt.org>
 <1286125639-15137-2-git-send-email-nbd@openwrt.org>
 <1286125639-15137-3-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1286125639-15137-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 03, 2010 at 10:37:18PM +0530, Felix Fietkau wrote:
>  static void ath9k_regwrite_flush(void *hw_priv)
>  {
>         struct ath_hw *ah = (struct ath_hw *) hw_priv;
> @@ -397,6 +388,9 @@ static void ath9k_regwrite_flush(void *hw_priv)
>         u32 rsp_status;
>         int r;
> 
> +       if (!atomic_dec_and_test(&priv->wmi->mwrite_cnt))
> +               return;
> +
FMU, Assume that mwrite_cnt > 1 and a reg_read happens after a flush whose value
depends on issued reg_write, the above check skips reg_write.
The buffered commands only issued either mwrite_cnt reaches zero or 
buffer reaches MAX limit.

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
