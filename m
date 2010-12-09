Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33267 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab0LIOR5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 09:17:57 -0500
Subject: Re: [PATCH] ath: fix build break with ATH_DBG_WARN_ON_ONCE
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Ben Greear <greearb@candelatech.com>
In-Reply-To: <1291903927-5406-1-git-send-email-linville@tuxdriver.com>
References: <4D00DDEA.7040907@hauke-m.de>
	 <1291903927-5406-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Dec 2010 15:17:52 +0100
Message-ID: <1291904272.3540.10.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-12-09 at 09:12 -0500, John W. Linville wrote:

> diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
> index 3eb95e2..45d4d91 100644
> --- a/drivers/net/wireless/ath/ath.h
> +++ b/drivers/net/wireless/ath/ath.h
> @@ -272,7 +272,7 @@ ath_dbg(struct ath_common *common, enum ATH_DEBUG dbg_mask,
>  	return 0;
>  }
>  #define ATH_DBG_WARN(foo, arg...) do {} while (0)
> -#define ATH_DBG_WARN_ON_ONCE(foo) do {} while (0)
> +#define ATH_DBG_WARN_ON_ONCE(foo) ({ 0; })

That'll fix the build error, but wouldn't you need (foo) for correctness
instead?

johannes

