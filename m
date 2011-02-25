Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52998 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932549Ab1BYOph (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 09:45:37 -0500
Date: Fri, 25 Feb 2011 09:32:44 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Joe Gunn <armadefuego@yahoo.com>
Cc: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2.6.38-rc6-wl 1/1] orinoco: Drop scan results with
 unknown channels
Message-ID: <20110225143244.GA15897@tuxdriver.com>
References: <557082.85443.qm@web57406.mail.re1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <557082.85443.qm@web57406.mail.re1.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 25, 2011 at 02:08:49AM -0800, Joe Gunn wrote:
> If the frequency can not be mapped to a channel structure log it and drop it.

FWIW, the Signed-off-by goes here.  No need to repost, I'll fix it...

> ---
> The driver was getting an error return from the frequency map. The invalid freq
> uency was not in the frequency table, so the channel structure returned null. T
> his test fro that case and does not allow the packet to continue up the stack.
> ---
> diff --git a/drivers/net/wireless/orinoco/scan.c b/drivers/net/wireless/orinoco
> /scan.c
> index 86cb54c..e99ca1c 100644
> --- a/drivers/net/wireless/orinoco/scan.c
> +++ b/drivers/net/wireless/orinoco/scan.c
> @@ -111,6 +111,11 @@ static void orinoco_add_hostscan_result(struct orinoco_pri
> vate *priv,
>  
>  	freq = ieee80211_dsss_chan_to_freq(le16_to_cpu(bss->a.channel));
>  	channel = ieee80211_get_channel(wiphy, freq);
> +	if (!channel) {
> +		printk(KERN_DEBUG "Invalid channel designation %04X(%04X)",
> +			bss->a.channel, freq);
> +		return;	/* Then ignore it for now */
> +	}
>  	timestamp = 0;
>  	capability = le16_to_cpu(bss->a.capabilities);
>  	beacon_interval = le16_to_cpu(bss->a.beacon_interv);
> 
> Signed-off-by: Joseph J. Gunn <armadefuego@yahoo.com>
> 
> 
> 
>       
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
