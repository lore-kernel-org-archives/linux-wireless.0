Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:42255 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962Ab1BAVYQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 16:24:16 -0500
To: David Gnedt <david.gnedt@davizone.at>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: Re: [PATCH 03/18] wl1251: fix scan behaviour while not associated
References: <4D45A598.20709@davizone.at> <4D45B7BA.9080402@davizone.at>
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 01 Feb 2011 23:24:15 +0200
In-Reply-To: <4D45B7BA.9080402@davizone.at> (David Gnedt's message of "Sun\, 30 Jan 2011 20\:10\:50 +0100")
Message-ID: <87d3nbcutc.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Gnedt <david.gnedt@davizone.at> writes:

> With a dissacociated card I often encoutered very long scan delays.
>
> My guess is that it has something to do with the cards DTIM handling and
> another firmware bug mentioned in the TI WLAN driver, which is described as
> the card may never end scanning if the channel is overloaded because it
> can't send probe requests. I think the firmware somehow also tries to
> receive DTIM messages when the BSSID is not set. Therefore most of the time
> it waits for DTIM messages and can't do scanning work.
>
> Anyway we can workaround this misbehaviour by setting the HIGH_PRIORITY
> bit for scans in disassociated state.

Now that's a weird problem. I wonder this wasn't reported with the
fremantle kernels. How often did you see the problem?

> --- a/drivers/net/wireless/wl1251/cmd.c
> +++ b/drivers/net/wireless/wl1251/cmd.c
> @@ -419,7 +419,10 @@ int wl1251_cmd_scan(struct wl1251 *wl, u8 *ssid, size_t ssid_len,
>  	struct wl1251_cmd_scan *cmd;
>  	int i, ret = 0;
>  
> -	wl1251_debug(DEBUG_CMD, "cmd scan");
> +	wl1251_debug(DEBUG_CMD, "cmd scan channels %d ssid(%d) '%s'",
> +		     n_channels, ssid_len, ssid);

ssid is not a valid string and hence you cannot print it with %s.

> +	/*
> +	 * Use high priority scan when not associated to prevent fw issue
> +	 * causing never-ending scans (sometimes 20+ minutes).
> +	 * Note: This bug may be caused by the fw's DTIM handling.
> +	 */
> +	if (is_zero_ether_addr(wl->bssid))
> +		cmd->params.scan_options |= WL1251_SCAN_OPT_PRIORITY_HIGH;

Can you resend the patch with just this part and the accompanying
defines, please? It's better to have debug messages improvements in a
separate patch.

-- 
Kalle Valo
