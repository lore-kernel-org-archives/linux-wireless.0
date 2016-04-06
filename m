Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0015.hostedemail.com ([216.40.44.15]:56587 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751320AbcDFHW7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 03:22:59 -0400
Message-ID: <1459927376.6715.37.camel@perches.com> (sfid-20160406_092302_163817_86164C53)
Subject: Re: [PATCH 4/7] wil6210: print debug message when transmitting
 while disconnected
From: Joe Perches <joe@perches.com>
To: Maya Erez <qca_merez@qca.qualcomm.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Date: Wed, 06 Apr 2016 00:22:56 -0700
In-Reply-To: <1459855447-17413-5-git-send-email-qca_merez@qca.qualcomm.com>
References: <1459855447-17413-1-git-send-email-qca_merez@qca.qualcomm.com>
	 <1459855447-17413-5-git-send-email-qca_merez@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-04-05 at 14:24 +0300, Maya Erez w
> Network stack can try to transmit data while AP / STA is
> disconnected.
> Change this print-out to debug level as this should not be
> handled as error.

Should probably say something about adding ratelimited
logging functions

> diff --git a/drivers/net/wireless/ath/wil6210/debug.c b/drivers/net/wireless/ath/wil6210/debug.c
[]
> @@ -49,6 +49,23 @@ void __wil_err_ratelimited(struct wil6210_priv *wil, const char *fmt, ...)
>  	}
>  }
>  
> +void __wil_dbg_ratelimited(struct wil6210_priv *wil, const char *fmt, ...)
> +{
> +	if (net_ratelimit()) {

Inverting the test would reduce indentation.

> +		struct net_device *ndev = wil_to_ndev(wil);
> +		struct va_format vaf = {
> +			.fmt = fmt,
> +		};
> +		va_list args;
> +
> +		va_start(args, fmt);
> +		vaf.va = &args;
> +		netdev_dbg(ndev, "%pV", &vaf);
> +		trace_wil6210_log_dbg(&vaf);
> +		va_end(args);
> +	}
> +}

