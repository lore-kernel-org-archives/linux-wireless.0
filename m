Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43092 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751033AbeC0HcP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 03:32:15 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: <pkshih@realtek.com>
Cc: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 12/15] rtlwifi: btcoex: Add 8822b 1ant/2ant coex files
References: <20180228030718.19510-1-pkshih@realtek.com>
        <20180228030718.19510-13-pkshih@realtek.com>
Date: Tue, 27 Mar 2018 10:32:10 +0300
In-Reply-To: <20180228030718.19510-13-pkshih@realtek.com>
        (pkshih@realtek.com's message of "Wed, 28 Feb 2018 11:07:15 +0800")
Message-ID: <87h8p2otxh.fsf@purkki.adurom.net> (sfid-20180327_093223_553843_0D52AD26)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<pkshih@realtek.com> writes:

> From: Ping-Ke Shih <pkshih@realtek.com>
>
> There are two or three physical antenna in 8822be WiFi modules, so btcoex
> introduce two coex files to handle these two cases.
>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> ---
>  .../realtek/rtlwifi/btcoexist/halbtc8822b1ant.c    | 5327 +++++++++++++++++++
>  .../realtek/rtlwifi/btcoexist/halbtc8822b1ant.h    |  413 ++
>  .../realtek/rtlwifi/btcoexist/halbtc8822b2ant.c    | 5370 ++++++++++++++++++++
>  .../realtek/rtlwifi/btcoexist/halbtc8822b2ant.h    |  434 ++
>  4 files changed, 11544 insertions(+)

Huge patches like this are pain to review. I'm going to split this into
two sets, patches 1-11 and patches 12-15.

> +/* ************************************************************
> + * Description:
> + *
> + * This file is for RTL8822B Co-exist mechanism
> + *
> + * History
> + * 2012/11/15 Cosa first check in.

The history feels useless to me.

> + *
> + * *************************************************************/
> +
> +/* ************************************************************
> + * include files
> + * *************************************************************/
> +/*only for rf4ce*/
> +#include "halbt_precomp.h"
> +
> +/* ************************************************************
> + * Global variables, these are static variables
> + * *************************************************************/

Also extensive use of "******" lines is not really upstream style.

> +static struct coex_dm_8822b_1ant	glcoex_dm_8822b_1ant;
> +static struct coex_dm_8822b_1ant	*coex_dm = &glcoex_dm_8822b_1ant;
> +static struct coex_sta_8822b_1ant	glcoex_sta_8822b_1ant;
> +static struct coex_sta_8822b_1ant	*coex_sta = &glcoex_sta_8822b_1ant;
> +static struct rfe_type_8822b_1ant	gl_rfe_type_8822b_1ant;
> +static struct rfe_type_8822b_1ant	*rfe_type = &gl_rfe_type_8822b_1ant;
> +
> +static const char *const glbt_info_src_8822b_1ant[] = {
> +	"BT Info[wifi fw]",
> +	"BT Info[bt rsp]",
> +	"BT Info[bt auto report]",
> +};
> +
> +static u32 glcoex_ver_date_8822b_1ant = 20180112;
> +static u32 glcoex_ver_8822b_1ant = 0x59;
> +static u32 glcoex_ver_btdesired_8822b_1ant = 0x56;

Having static variables like this means that this will not work if there
are two or more device per host, right? IIRC we discussed this before,
so what's the plan to solve that? 

In upstream drivers there should not be artificial limitations like one
device per host. Is that even checked anywhere or will it just be buggy
if there are more than one device?

-- 
Kalle Valo
