Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58034 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932428AbcDYNbA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2016 09:31:00 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Mon, 25 Apr 2016 16:30:58 +0300
From: merez@codeaurora.org
To: Joe Perches <joe@perches.com>
Cc: qca_merez <qca_merez@qca.qualcomm.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, wil6210 <wil6210@qca.qualcomm.com>,
	linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH 4/7] wil6210: print debug message when transmitting while
 disconnected
In-Reply-To: <1460341847.1800.68.camel@perches.com>
References: <1459855447-17413-1-git-send-email-qca_merez@qca.qualcomm.com>
 <1459855447-17413-5-git-send-email-qca_merez@qca.qualcomm.com>
 <1459927376.6715.37.camel@perches.com>
 <22bd7713a48b46e2bb2f1ec67ad6c409@euamsexm01a.eu.qualcomm.com>
 <1460341847.1800.68.camel@perches.com>
Message-ID: <ae4d9c13a189b5939bdb40de800f6110@codeaurora.org> (sfid-20160425_153105_765715_9915247C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-04-11 05:30, Joe Perches wrote:
> On Sun, 2016-04-10 at 19:17 +0000, qca_merez wrote:
>> On 4/6/2016 10:22 AM, Joe Perches wrote:
>> >
>> > On Tue, 2016-04-05 at 14:24 +0300, Maya Erez w
>> > >
>> > > +void __wil_dbg_ratelimited(struct wil6210_priv *wil, const char
> *fmt, 
>> > > +...) {
>> > > +	if (net_ratelimit()) {
>> >
>> > Inverting the test would reduce indentation.
>> I preferred to have the same implementation as in wil_err_ratelimited.
> 
> That's easy enough.
> 
> Maybe:
> ---
>  drivers/net/wireless/ath/wil6210/debug.c   | 55
> ++++++++++++++----------------
>  drivers/net/wireless/ath/wil6210/wil6210.h |  8 ++---
>  2 files changed, 30 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/wil6210/debug.c
> b/drivers/net/wireless/ath/wil6210/debug.c
> index 3249562..de1e932 100644
> --- a/drivers/net/wireless/ath/wil6210/debug.c
> +++ b/drivers/net/wireless/ath/wil6210/debug.c
> @@ -17,61 +17,58 @@
>  #include "wil6210.h"
>  #include "trace.h"
>  
> -void wil_err(struct wil6210_priv *wil, const char *fmt, ...)
> +void wil_err(const struct wil6210_priv *wil, const char *fmt, ...)
>  {
> -	struct net_device *ndev = wil_to_ndev(wil);
> -	struct va_format vaf = {
> -		.fmt = fmt,
> -	};
> +	struct va_format vaf;
>  	va_list args;
>  
>  	va_start(args, fmt);
> +	vaf.fmt = fmt;
>  	vaf.va = &args;
> -	netdev_err(ndev, "%pV", &vaf);
> +	netdev_err(wil_to_ndev(wil), "%pV", &vaf);
>  	trace_wil6210_log_err(&vaf);
>  	va_end(args);
>  }
>  
> -void wil_err_ratelimited(struct wil6210_priv *wil, const char *fmt, 
> ...)
> +void wil_err_ratelimited(const struct wil6210_priv *wil, const char 
> *fmt,
> ...)
>  {
> -	if (net_ratelimit()) {
> -		struct net_device *ndev = wil_to_ndev(wil);
> -		struct va_format vaf = {
> -			.fmt = fmt,
> -		};
> -		va_list args;
> +	struct va_format vaf;
> +	va_list args;
> +
> +	if (!net_ratelimit())
> +		return;
>  
> -		va_start(args, fmt);
> -		vaf.va = &args;
> -		netdev_err(ndev, "%pV", &vaf);
> -		trace_wil6210_log_err(&vaf);
> -		va_end(args);
> -	}
> +	va_start(args, fmt);
> +	vaf.fmt = fmt;
> +	vaf.va = &args;
> +	netdev_err(wil_to_ndev(wil), "%pV", &vaf);
> +	trace_wil6210_log_err(&vaf);
> +	va_end(args);
>  }
>  
> -void wil_info(struct wil6210_priv *wil, const char *fmt, ...)
> +void wil_info(const struct wil6210_priv *wil, const char *fmt, ...)
>  {
> -	struct net_device *ndev = wil_to_ndev(wil);
> -	struct va_format vaf = {
> -		.fmt = fmt,
> -	};
> +	struct va_format vaf;
>  	va_list args;
>  
> +	if (!net_ratelimit())
> +		return;
> +
>  	va_start(args, fmt);
> +	vaf.fmt = fmt;
>  	vaf.va = &args;
> -	netdev_info(ndev, "%pV", &vaf);
> +	netdev_info(wil_to_ndev(wil), "%pV", &vaf);
>  	trace_wil6210_log_info(&vaf);
>  	va_end(args);
>  }
>  
> -void wil_dbg_trace(struct wil6210_priv *wil, const char *fmt, ...)
> +void wil_dbg_trace(const struct wil6210_priv *wil, const char *fmt, 
> ...)
>  {
> -	struct va_format vaf = {
> -		.fmt = fmt,
> -	};
> +	struct va_format vaf;
>  	va_list args;
>  
>  	va_start(args, fmt);
> +	vaf.fmt = fmt;
>  	vaf.va = &args;
>  	trace_wil6210_log_dbg(&vaf);
>  	va_end(args);
> diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h
> b/drivers/net/wireless/ath/wil6210/wil6210.h
> index 4d699ea4..e2b62b1 100644
> --- a/drivers/net/wireless/ath/wil6210/wil6210.h
> +++ b/drivers/net/wireless/ath/wil6210/wil6210.h
> @@ -633,13 +633,13 @@ struct wil6210_priv {
>  #define ndev_to_wil(n) (wdev_to_wil(n->ieee80211_ptr))
>  
>  __printf(2, 3)
> -void wil_dbg_trace(struct wil6210_priv *wil, const char *fmt, ...);
> +void wil_dbg_trace(const struct wil6210_priv *wil, const char *fmt, 
> ...);
>  __printf(2, 3)
> -void wil_err(struct wil6210_priv *wil, const char *fmt, ...);
> +void wil_err(const struct wil6210_priv *wil, const char *fmt, ...);
>  __printf(2, 3)
> -void wil_err_ratelimited(struct wil6210_priv *wil, const char *fmt, 
> ...);
> +void wil_err_ratelimited(const struct wil6210_priv *wil, const char 
> *fmt,
> ...);
>  __printf(2, 3)
> -void wil_info(struct wil6210_priv *wil, const char *fmt, ...);
> +void wil_info(const struct wil6210_priv *wil, const char *fmt, ...);
>  #define wil_dbg(wil, fmt, arg...) do { \
>  	netdev_dbg(wil_to_ndev(wil), fmt, ##arg); \
>  	wil_dbg_trace(wil, fmt, ##arg); \
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-wireless"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks for your suggestion, I currently changed wil_dbg_ratelimited only 
and will
change the other functions in a separate patch.
-- 
Maya Erez
Qualcomm Israel, Inc. on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
