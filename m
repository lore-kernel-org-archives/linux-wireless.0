Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:56772 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755731Ab1KHOGd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 09:06:33 -0500
Received: by mail-bw0-f50.google.com with SMTP id zu17so522587bkb.23
        for <linux-wireless@vger.kernel.org>; Tue, 08 Nov 2011 06:06:31 -0800 (PST)
Subject: Re: [PATCH] wl12xx: fix wl12xx_scan_sched_scan_ssid_list() check
 that all given ssids are in filters
From: Luciano Coelho <coelho@ti.com>
To: Eyal Shapira <eyal@wizery.com>, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1320760486-19700-1-git-send-email-eyal@wizery.com>
References: <1320760486-19700-1-git-send-email-eyal@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 16:06:28 +0200
Message-ID: <1320761188.19479.10.camel@cumari> (sfid-20111108_150636_531693_D6D54BD7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-11-08 at 15:54 +0200, Eyal Shapira wrote: 
> A minor fix for the check that verifies that all given SSIDs (in req) exist
> in the filters (the match sets)
> 
> Signed-off-by: Eyal Shapira <eyal@wizery.com>
> ---
>  drivers/net/wireless/wl12xx/scan.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
> index 128ccb7..fc29c67 100644
> --- a/drivers/net/wireless/wl12xx/scan.c
> +++ b/drivers/net/wireless/wl12xx/scan.c
> @@ -559,7 +559,7 @@ wl12xx_scan_sched_scan_ssid_list(struct wl1271 *wl,
>  						break;
>  					}
>  				/* Fail if SSID isn't present in the filters */
> -				if (j == req->n_ssids) {
> +				if (j == cmd->n_ssids) {
>  					ret = -EINVAL;
>  					goto out_free;
>  				}

Just to clarify.  My comment:
> Acked-by: Luciano Coelho <coelho@ti.com>
> 
> John, can you apply this to 3.2, please?

...was about this patch.  Eyal's email was delivered to me, but vger
rejected it, so he had to resend it.

-- 
Cheers,
Luca.

