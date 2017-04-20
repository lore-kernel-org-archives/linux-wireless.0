Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40854 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S942878AbdDTKyS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Apr 2017 06:54:18 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: Re: [PATCH 06/10] rtlwifi: btcoex: 21a 2ant: run mechanism if status changes or auto adjust is set
References: <20170416190428.23857-1-Larry.Finger@lwfinger.net>
        <20170416190428.23857-7-Larry.Finger@lwfinger.net>
Date: Thu, 20 Apr 2017 13:54:13 +0300
In-Reply-To: <20170416190428.23857-7-Larry.Finger@lwfinger.net> (Larry
        Finger's message of "Sun, 16 Apr 2017 14:04:24 -0500")
Message-ID: <87bmrrbb8q.fsf@purkki.adurom.net> (sfid-20170420_125422_502487_749A5044)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
>
> The driver will periodically ask the coex, and the coex only runs the
> mechanism when the status was changed or the auto adjust is set.
>
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Pkshih <pkshih@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>

[...]

> @@ -4200,7 +4200,14 @@ void ex_btc8821a2ant_periodical(struct btc_coexist *btcoexist)
>  			 "[BTCoex], ****************************************************************\n");
>  	}
>  
> +#ifdef BT_AUTO_REPORT_ONLY_8821A_2ANT
>  	btc8821a2ant_query_bt_info(btcoexist);
> +#else
>  	btc8821a2ant_monitor_bt_ctr(btcoexist);
>  	btc8821a2ant_monitor_wifi_ctr(btcoexist);
> +
> +	if (btc8821a2ant_is_wifi_status_changed(btcoexist) ||
> +	    coex_dm->auto_tdma_adjust)
> +		btc8821a2ant_run_coexist_mechanism(btcoexist);
> +#endif

This ifdef looks fishy. Why is it needed?

In general I would expect to see ifdefs only for Kconfig options or
defines which value comes from core kernel.

-- 
Kalle Valo
