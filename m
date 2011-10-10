Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:45146 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753031Ab1JJSUL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 14:20:11 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so2168511eye.33
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 11:20:09 -0700 (PDT)
Subject: Re: [PATCH 05/29] wl12xx: move bitrate_masks into wlvif
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1318234397-21081-6-git-send-email-eliad@wizery.com>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
	 <1318234397-21081-6-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Oct 2011 21:20:06 +0300
Message-ID: <1318270806.9690.373.camel@cumari> (sfid-20111010_202016_169493_D5B37D70)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-10-10 at 10:12 +0200, Eliad Peller wrote: 
> move bitrate_masks into the per-interface data, rather than
> being global.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

[...]

> diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
> index 102a8a5..ff653e8 100644
> --- a/drivers/net/wireless/wl12xx/cmd.c
> +++ b/drivers/net/wireless/wl12xx/cmd.c
> @@ -1111,15 +1111,16 @@ out:
>  	return ret;
>  }
>  
> -int wl1271_cmd_build_probe_req(struct wl1271 *wl,
> +int wl1271_cmd_build_probe_req(struct wl1271 *wl, struct wl12xx_vif *wlvif,
>  			       const u8 *ssid, size_t ssid_len,
>  			       const u8 *ie, size_t ie_len, u8 band)

If struct wl12xx_vif contains a pointer to wl, can't you pass only wlvif
to all these functions instead of passing both?


-- 
Cheers,
Luca.

