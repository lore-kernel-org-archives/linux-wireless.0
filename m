Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41232 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751711AbdFUO5Y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Jun 2017 10:57:24 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: Re: [PATCH 11/11] rtlwifi: btcoexist control to enter/leave LPS
References: <20170618161249.6146-1-Larry.Finger@lwfinger.net>
        <20170618161249.6146-12-Larry.Finger@lwfinger.net>
Date: Wed, 21 Jun 2017 17:57:19 +0300
In-Reply-To: <20170618161249.6146-12-Larry.Finger@lwfinger.net> (Larry
        Finger's message of "Sun, 18 Jun 2017 11:12:49 -0500")
Message-ID: <878tklo0c0.fsf@purkki.adurom.net> (sfid-20170621_165728_426305_B74ED6A3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> From: Ping-Ke Shih <pkshih@realtek.com>
>
> To yield better user experience, have btcoex control LPS's parameters.
>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>

[...]

> -	u8 rlbm, power_state = 0, byte5 = 0x40;
> +	u8 rlbm, power_state = 0, byte5 = 0;

[...]

> +			if ((rlbm == 2) && (byte5 & BIT(4))) {
> +				/* Keep awake interval to 1 to prevent from
> +				 * decreasing coex performance
> +				 */
> +				awake_intvl = 2;
> +				rlbm = 2;
> +			}

These kind of magic values (byte5 & BIT(4)) don't really belong in
upstream drivers and I'm seeing way too much of those in rtlwifi.

I'm not going to drop this patch because of this but please make an
effort to do packet parsing properly, for example with help of structs
and defines/enums.

-- 
Kalle Valo
