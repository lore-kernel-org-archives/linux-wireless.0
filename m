Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:50226 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756786Ab1D2UId (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 16:08:33 -0400
Received: by mail-ew0-f53.google.com with SMTP id 8so1498915ewy.40
        for <linux-wireless@vger.kernel.org>; Fri, 29 Apr 2011 13:08:31 -0700 (PDT)
Subject: Re: [PATCH 1/2] wl12xx: implement the tx_frames_pending mac80211
 callback
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1303850140-11230-1-git-send-email-arik@wizery.com>
References: <1303850140-11230-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Apr 2011 23:08:28 +0300
Message-ID: <1304107708.12586.163.camel@cumari> (sfid-20110429_220836_197405_7C9AFA88)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-04-26 at 23:35 +0300, Arik Nemtsov wrote:
> Frames are considered pending when they reside in the driver TX queue or
> already queued in the FW.
> 
> This notion of "pending" is appropriate for power save considerations in
> STA mode, but not necessarily in other modes (for instance P2P-GO).
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

Applied, thanks!


> diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
> index dad81f6..3dc89f7 100644
> --- a/drivers/net/wireless/wl12xx/main.c
> +++ b/drivers/net/wireless/wl12xx/main.c
> @@ -3140,6 +3140,28 @@ out:
>  	return ret;
>  }
>  
> +bool wl1271_tx_frames_pending(struct ieee80211_hw *hw)

Added static here to avoid a sparse warning complaining that this
function is not exported but it was also not declared static.

-- 
Cheers,
Luca.

