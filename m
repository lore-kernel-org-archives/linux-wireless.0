Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:34623 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753610Ab1HKHPV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 03:15:21 -0400
Received: by mail-bw0-f46.google.com with SMTP id 11so987782bke.5
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 00:15:19 -0700 (PDT)
Subject: Re: [PATCH 26/40] wl12xx: add wl1271_cmd_role_start_ibss()
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1312881233-9366-27-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
	 <1312881233-9366-27-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Aug 2011 10:15:16 +0300
Message-ID: <1313046916.2407.791.camel@cumari> (sfid-20110811_091524_967465_687B6E74)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-09 at 12:13 +0300, Eliad Peller wrote: 
> Add wl1271_cmd_role_start_ibss() implementation and defintion.
> This function is used in order to start the IBSS role.
> 
> Stopping the IBSS is done by using the same api as stop STA,
> so there is no need for a separate function.

Not really important now, but maybe we should find a more generic name
for the wl1271_cmd_role_stop_sta() function then.  Or add a nice comment
there saying that it is also used for bss.


> diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
> index 41dee4f..b8d6848 100644
> --- a/drivers/net/wireless/wl12xx/cmd.c
> +++ b/drivers/net/wireless/wl12xx/cmd.c
> @@ -767,12 +767,73 @@ out_free:
>  	kfree(cmd);
>  
>  out:
>  	return ret;
>  }
>  
> +int wl1271_cmd_role_start_ibss(struct wl1271 *wl)
> +{
> +	struct wl1271_cmd_role_start *cmd;
> +	struct ieee80211_bss_conf *bss_conf = &wl->vif->bss_conf;
> +	int ret;
> +
> +	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
> +	if (!cmd) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	wl1271_debug(DEBUG_CMD, "cmd role start ibss %d", wl->role_id);
> +
> +	cmd->role_id = wl->role_id;
> +	if (wl->band == IEEE80211_BAND_5GHZ)
> +		cmd->band |= WL1271_BAND_5GHZ;

This looks wrong.  I didn't see it before, but it was already introduced
in patch 08.  The WL1271_BAND_* definitions are an enumeration defined
like this:

enum wl1271_band {
WL1271_BAND_2_4GHZ = 0,  /* 2.4 Ghz band */
WL1271_BAND_5GHZ = 1,    /* 5 Ghz band */
WL1271_BAND_JAPAN_4_9_GHZ = 2,
WL1271_BAND_DEFAULT = WL1271_BAND_2_4GHZ,
WL1271_BAND_INVALID = 0x7E,
WL1271_BAND_MAX_RADIO = 0x7F,
};

Why are we always ORing the value into cmd->band then? If these commands
can only work in single bands (which is probably the case), then we
should use "cmd->band = WL1271_BAND_5GHZ" instead.  If the commands can
manage more than a band at once, then cmd->band should be a bitmask and
the enumeration should be defined using BIT(0), BIT(1) and so on.


-- 
Cheers,
Luca.

