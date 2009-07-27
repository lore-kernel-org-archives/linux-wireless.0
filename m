Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:26021 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755565AbZG0CKV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jul 2009 22:10:21 -0400
Subject: Re: [PATCH] ipw2x00: Write outside array bounds
From: Zhu Yi <yi.zhu@intel.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw2100-devel@lists.sourceforge.net"
	<ipw2100-devel@lists.sourceforge.net>,
	Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4A6B7DB0.7090902@gmail.com>
References: <4A6B7DB0.7090902@gmail.com>
Content-Type: text/plain
Date: Mon, 27 Jul 2009 10:10:20 +0800
Message-Id: <1248660620.3747.102.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2009-07-26 at 05:48 +0800, Roel Kluin wrote:
> channel_index loops up to IPW_SCAN_CHANNELS, but is used after being
> incremented. This might be able to access 1 past the end of the array
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Thanks. Do you think below patch is better?

Thanks,
-yi

diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index 2dc1cdb..07f171c 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -6226,7 +6226,7 @@ static void ipw_add_scan_channels(struct ipw_priv *priv,
 			};
 
 			u8 channel;
-			while (channel_index < IPW_SCAN_CHANNELS) {
+			while (channel_index < IPW_SCAN_CHANNELS - 1) {
 				channel =
 				    priv->speed_scan[priv->speed_scan_pos];
 				if (channel == 0) {


> ---
> diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
> index 44c29b3..d1c9d6d 100644
> --- a/drivers/net/wireless/ipw2x00/ipw2200.c
> +++ b/drivers/net/wireless/ipw2x00/ipw2200.c
> @@ -6249,7 +6249,10 @@ static void ipw_add_scan_channels(struct ipw_priv *priv,
>  
>  				channels[channel - 1] = 1;
>  				priv->speed_scan_pos++;
> -				channel_index++;
> +
> +				if (++channel_index >= IPW_SCAN_CHANNELS)
> +					break;
> +
>  				scan->channels_list[channel_index] = channel;
>  				index =
>  				    ieee80211_channel_to_index(priv->ieee, channel);

