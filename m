Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:44885 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700Ab0K2JvX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 04:51:23 -0500
Subject: Re: [PATCH ] wl12xx: BA receiver support
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Shahar Levi <shahar_levi@ti.com>
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@nokia.com>
In-Reply-To: <1290616392-16532-1-git-send-email-shahar_levi@ti.com>
References: <1290616392-16532-1-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Nov 2010 11:51:15 +0200
Message-ID: <1291024275.4284.4443.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-11-24 at 18:33 +0200, ext Shahar Levi wrote:
> Add new ampdu_action ops to support receiver BA.
> The BA initiator session management in FW independently.
> 
> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
> ---
> Dependencies:
> - BA Initiator patches have a runtime dependency on commit
>    "[RFC v3] wl1271: BA Initiator support"
> 
>  drivers/net/wireless/wl12xx/acx.c   |   38 ++++++++++++++++++++++++++
>  drivers/net/wireless/wl12xx/acx.h   |   21 ++++++++++++++
>  drivers/net/wireless/wl12xx/event.c |    3 +++
>  drivers/net/wireless/wl12xx/event.h |   17 ++++++++++-
>  drivers/net/wireless/wl12xx/main.c  |   50 +++++++++++++++++++++++++++++++++++
>  5 files changed, 128 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
> index 6c433b7..85d87dd 100644
> --- a/drivers/net/wireless/wl12xx/acx.c
> +++ b/drivers/net/wireless/wl12xx/acx.c
> @@ -1359,6 +1359,44 @@ out:
>  	return ret;
>  }
>  
> +/* setup BA session receiver setting in the FW. */
> +int wl1271_acx_set_ba_receiver_session(struct wl1271 *wl, u8 tid_index,
> +				       u16 *ssn, u8 policy)
> +{
> +	struct wl1271_acx_ba_receiver_setup *acx;
> +	int ret;
> +
> +	wl1271_debug(DEBUG_ACX, "acx ba receiver session setting");
> +
> +	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
> +	if (!acx) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	/* Single link for now */
> +	acx->link_id = 1;
> +	acx->tid = tid_index;
> +	acx->enable = policy;
> +	acx->win_size = 0;
> +

Here the window size is configured to 0.

As here the mac80211 does the processing and responding of the add BA
request from the AP, how does the firmware know what window size
eventually was taken into use?

Also, as we already discussed on IRC, the mac80211 currently responds to
the add BA request with the same window size suggested by the AP - in
case of my test AP, this value is 64 - which is too large for the
firmware to cope. So the firmware imposed limit to the window size must
be handled somehow.

-Juuso


