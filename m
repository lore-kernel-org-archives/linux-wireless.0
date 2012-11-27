Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:50044 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758478Ab2K0JNy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 04:13:54 -0500
Message-ID: <1354007594.950.56.camel@cumari.coelho.fi> (sfid-20121127_101359_538936_54F4C6FB)
Subject: Re: [PATCH 11/11] wlcore/wl18xx/wl12xx: add recovery settings to
 conf
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: <linux-wireless@vger.kernel.org>,
	Yair Shapira <yair.shapira@ti.com>
Date: Tue, 27 Nov 2012 11:13:14 +0200
In-Reply-To: <1353945950-3899-12-git-send-email-arik@wizery.com>
References: <1353945950-3899-1-git-send-email-arik@wizery.com>
	 <1353945950-3899-12-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-26 at 18:05 +0200, Arik Nemtsov wrote:
> From: Yair Shapira <yair.shapira@ti.com>
> 
> add support for recovery settings including bug_on_recovery and
> no_recovery options.
> 
> These options can now be set using wl18xx-conf.bin file and wlconf
> tool.
> 
> Signed-off-by: Yair Shapira <yair.shapira@ti.com>
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

[...]

> diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
> index a48a36c..56f20d6 100644
> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c
[...]
> @@ -306,6 +306,8 @@ out:
>  static void wlcore_adjust_conf(struct wl1271 *wl)
>  {
>  	/* Adjust settings according to optional module parameters */
> +
> +	/* Firmware Log Settings */

This comment is useless and doesn't follow the coding style.  I'll
remove it when applying.

> @@ -321,6 +323,13 @@ static void wlcore_adjust_conf(struct wl1271 *wl)
>  			wl1271_error("Unknown fwlog parameter %s", fwlog_param);
>  		}
>  	}
> +
> +	/* Recovery Settings */

Same here.

--
Luca.

