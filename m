Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51362 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab0H0LNh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 07:13:37 -0400
Subject: Re: [PATCH 4/4] mac80211: allow changing port control protocol
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1282907259-30825-5-git-send-email-juuso.oikarinen@nokia.com>
References: <1282907259-30825-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1282907259-30825-5-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Aug 2010 13:13:30 +0200
Message-ID: <1282907610.4377.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-08-27 at 14:07 +0300, Juuso Oikarinen wrote:

> @@ -855,6 +855,8 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
>  	sdata->dev->netdev_ops = &ieee80211_dataif_ops;
>  	sdata->wdev.iftype = type;
>  
> +	sdata->control_port_protocol = cpu_to_be16(ETH_P_PAE);
> +

I believe we may also need to set control_port_no_encrypt to false here,
or we'll run into issues with interface type switching after it had been
true?

johannes

