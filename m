Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0163.hostedemail.com ([216.40.44.163]:53630 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932758AbaLBDoN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2014 22:44:13 -0500
Message-ID: <1417491850.4894.10.camel@perches.com> (sfid-20141202_044417_057975_0C6B8A75)
Subject: Re: [PATCH 2/9] wil6210: add handling of RX HTRSH interrupt
From: Joe Perches <joe@perches.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Date: Mon, 01 Dec 2014 19:44:10 -0800
In-Reply-To: <1417440803-26883-3-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1417440803-26883-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1417440803-26883-3-git-send-email-qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-12-01 at 15:33 +0200, Vladimir Kondratiev wrote:
> In addition there's a rate limitted warning message.

limited.

I think this _ratelimited bit should be a separate patch.
(and a suggestion / comment below too)

> diff --git a/drivers/net/wireless/ath/wil6210/debug.c b/drivers/net/wireless/ath/wil6210/debug.c
[]
> +void wil_err_ratelimited(struct wil6210_priv *wil, const char *fmt, ...)
> +{
> +	if (net_ratelimit()) {
> +		struct net_device *ndev = wil_to_ndev(wil);
> +		struct va_format vaf = {
> +			.fmt = fmt,
> +		};
> +		va_list args;
> +
> +		va_start(args, fmt);
> +		vaf.va = &args;
> +		netdev_err(ndev, "%pV", &vaf);
> +		trace_wil6210_log_err(&vaf);
> +		va_end(args);
> +	}
> +}
[]
> diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
[]
> @@ -475,6 +476,8 @@ void wil_dbg_trace(struct wil6210_priv *wil, const char *fmt, ...);
>  __printf(2, 3)
>  void wil_err(struct wil6210_priv *wil, const char *fmt, ...);
>  __printf(2, 3)
> +void wil_err_ratelimited(struct wil6210_priv *wil, const char *fmt, ...);
> +__printf(2, 3)
>  void wil_info(struct wil6210_priv *wil, const char *fmt, ...);
>  #define wil_dbg(wil, fmt, arg...) do { \
>  	netdev_dbg(wil_to_ndev(wil), fmt, ##arg); \

I think it'd be simpler and smaller to use a macro:

#define wil_err_ratelimited(wil, fmt, ...)		\
do {							\
	if (net_ratelimit())				\
		wil_err(wil, fmt, ##__VA_ARGS__);	\
} while (0)

