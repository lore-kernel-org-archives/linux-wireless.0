Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f43.google.com ([209.85.161.43]:49234 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab0LMKMn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 05:12:43 -0500
Received: by fxm18 with SMTP id 18so6046727fxm.2
        for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 02:12:42 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH v2 5/7] ath9k_hw: fix PA predistortion training power selection
Date: Mon, 13 Dec 2010 11:52:49 +0100
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com, vasanth@atheros.com
References: <1292226056-56008-1-git-send-email-nbd@openwrt.org> <1292226056-56008-4-git-send-email-nbd@openwrt.org> <1292226056-56008-5-git-send-email-nbd@openwrt.org>
In-Reply-To: <1292226056-56008-5-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201012131152.50095.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 13 December 2010 08:40:54 Felix Fietkau wrote:
>
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
> index cdca4c3..69f7792 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
> @@ -30,9 +30,69 @@ void ar9003_paprd_enable(struct ath_hw *ah, bool val)
> +
> +static int get_streams(int mask)
> +{
> +	return !!(mask & BIT(0)) + !!(mask & BIT(1)) + !!(mask & BIT(2));
> +}
> +
I think there's a generic library function for that:
hweight[8|16|32].

Also, some CPUs have a special "population count" instruction
and hweight* takes full advantage of that too. 

Regards,
	Chr
