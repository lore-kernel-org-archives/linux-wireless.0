Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:17656 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756072Ab1BCK3m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Feb 2011 05:29:42 -0500
Subject: Re: [PATCH] wl12xx: Add channel 14 to list of supported 2ghz
 channels
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
In-Reply-To: <1294775357-10821-1-git-send-email-arik@wizery.com>
References: <1294775357-10821-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Jan 2011 08:03:05 +0200
Message-ID: <1294812185.18570.44.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-01-11 at 21:49 +0200, ext Arik Nemtsov wrote:
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---
> drivers/net/wireless/wl12xx/main.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
> index 062247e..a7afdca 100644
> --- a/drivers/net/wireless/wl12xx/main.c
> +++ b/drivers/net/wireless/wl12xx/main.c
> @@ -2305,6 +2305,7 @@ static struct ieee80211_channel wl1271_channels[] = {
>  	{ .hw_value = 11, .center_freq = 2462, .max_power = 25 },
>  	{ .hw_value = 12, .center_freq = 2467, .max_power = 25 },
>  	{ .hw_value = 13, .center_freq = 2472, .max_power = 25 },
> +	{ .hw_value = 14, .center_freq = 2484, .max_power = 25 },
>  };
>  
>  /* mapping to indexes for wl1271_rates */

Do the radio-parameter structs (i.e. the INI-file) already have a field
for channel 14? If not, does not adding this channel introduce strange
problems?

We used to have some 4.9GHz channels on the 11a band, which are
theoretically supported but were lacking the respective radio-parameter
fields, which caused some issues and they had to be removed until the
radio-parameter interface is updated.

-Juuso

