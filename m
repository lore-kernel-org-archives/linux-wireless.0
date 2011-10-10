Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:56225 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753292Ab1JJUjI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 16:39:08 -0400
Received: by mail-bw0-f54.google.com with SMTP id zs8so10469085bkb.13
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 13:39:07 -0700 (PDT)
Subject: Re: [PATCH 21/29] wl12xx: add band field to wlvif
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1318234397-21081-22-git-send-email-eliad@wizery.com>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
	 <1318234397-21081-22-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Oct 2011 23:38:58 +0300
Message-ID: <1318279138.9690.421.camel@cumari> (sfid-20111010_223912_364639_64271E1A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-10-10 at 10:13 +0200, Eliad Peller wrote: 
> add band field into the per-interface data.
> 
> mac80211 configures some values (e.g. band, channel)
> globally, while we configure them per-interface.
> 
> In order to make it easier to keep track of the
> configured value for each value while keeping sync
> with mac80211, save these values both globally
> and per-vif.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

[...]


> -static int wl12xx_cmd_roc(struct wl1271 *wl, u8 role_id)
> +static int wl12xx_cmd_roc(struct wl1271 *wl, struct wl12xx_vif *wlvif,
> +			  u8 role_id)

[...]

> -int wl12xx_roc(struct wl1271 *wl, u8 role_id)
> +int wl12xx_roc(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 role_id)

Seems like wl12xx_roc(), which is the only caller of wl12xx_cmd_roc(),
is always called with wlvif->role_id as the role, so it seems a bit
useless to pass role_id separately all the way.


-- 
Cheers,
Luca.

