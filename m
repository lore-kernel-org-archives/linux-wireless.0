Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46561 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715Ab0IQND3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Sep 2010 09:03:29 -0400
Subject: Re: [PATCH] ath9k : Fix for displaying the channel number
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1284728486-1058-1-git-send-email-mshajakhan@atheros.com>
References: <1284728486-1058-1-git-send-email-mshajakhan@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Sep 2010 15:03:14 +0200
Message-ID: <1284728594.3735.32.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-09-17 at 18:31 +0530, Mohammed Shafi Shajakhan wrote:

> +static inline int center_freq_to_channel(struct ath_wiphy *aphy)
> +{
> +	struct ieee80211_channel *chan = aphy->hw->conf.channel ;
> +	
> +	if (chan->center_freq == 2484) {
> +		return 14;
> +	}
> +	
> +	if (chan->center_freq < 2484) {
> +		return (chan->center_freq -2407) / 5;
> +	}
> +
> +	return (chan->center_freq  - 5000) / 5;	

This function already exists elsewhere in the kernel.

johannes

