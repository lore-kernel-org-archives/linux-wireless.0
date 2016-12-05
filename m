Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37867 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751605AbcLEVfL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 16:35:11 -0500
Date: Tue, 6 Dec 2016 00:34:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: kvalo@codeaurora.org, devel@driverdev.osuosl.org,
        Ping-Ke Shih <pkshih@realtek.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 10/14] rtlwifi: Add BTC_TRACE_STRING to new btcoex
Message-ID: <20161205213447.GJ8176@mwanda> (sfid-20161205_223517_078106_AE53D3A6)
References: <20161202014833.6856-1-Larry.Finger@lwfinger.net>
 <20161202014833.6856-11-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161202014833.6856-11-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 01, 2016 at 07:48:29PM -0600, Larry Finger wrote:
> --- wireless-drivers-next.orig/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> +++ wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> @@ -27,6 +27,29 @@
>  
>  #include	"../wifi.h"
>  
> +#ifdef CONFIG_RTLWIFI_DEBUG
> +
> +#define BTC_SPRINTF(ptr, ...)	snprintf(ptr, ##__VA_ARGS__)
> +#define BTC_TRACE(fmt)						\
> +do {								\
> +	struct rtl_priv *rtlpriv = gl_bt_coexist.adapter;	\
> +	if (!rtlpriv)					\
> +		break;						\
> +	RT_TRACE_STRING(rtlpriv, COMP_COEX, DBG_LOUD, fmt);	\
> +} while (0)
> +

This sort of macro is exactly when the rtl drivers spent so long in
staging...  Subsystems should not invent their own tracing but in
particular these macros are so very very ugly.

It's just super frustrating to even look at this...

There are a lot of staging drivers I feel good about when they leave.
The HyperV drivers.  The IIO stuff.  A lot of the media stuff and
generally the media tree is getting better and better.  I like comedi
and unisys, those are in staging, but they are great and could move out
any time as far as I'm concerned.

But this patch just makes me super discouraged.  What are we doing???

regards,
dan carpenter
