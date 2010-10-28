Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:53233 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761435Ab0J1Szn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Oct 2010 14:55:43 -0400
Subject: Re: [PATCH] wl1271: set wl->vif only if add_interface succeeded.
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1288106769-11990-1-git-send-email-eliad@wizery.com>
References: <1288106769-11990-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Oct 2010 21:56:59 +0300
Message-ID: <1288292219.3414.28.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-10-26 at 17:26 +0200, ext Eliad Peller wrote:
> set wl->vif to the newly created interface only after the firmware booted
> successfully. on the way - make the function flow more clear.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Looks good.  Just one comment below.


>  drivers/net/wireless/wl12xx/wl1271_main.c |   32 +++++++++++++++++-----------
>  1 files changed, 19 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
> index c54887c..2599157 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_main.c
> +++ b/drivers/net/wireless/wl12xx/wl1271_main.c
> @@ -950,18 +950,18 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
>  	struct wiphy *wiphy = hw->wiphy;
>  	int retries = WL1271_BOOT_RETRIES;
>  	int ret = 0;
> +	bool booted = false;
>  
>  	wl1271_debug(DEBUG_MAC80211, "mac80211 add interface type %d mac %pM",
>  		     vif->type, vif->addr);
>  
>  	mutex_lock(&wl->mutex);
>  	if (wl->vif) {
> +		wl1271_error("multiple vifs are not supported yet");

I don't think we should use wl1271_error here.  This will cause a lot of
information to be printed out and look bad.  It is not an error if
someone tries to add a new vif when we already have one.  Use
wl1271_debug instead.


-- 
Cheers,
Luca.

