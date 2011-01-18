Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59655 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab1ARKmh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 05:42:37 -0500
Subject: Re: [PATCH 2/5] mac80211: initialize radar params + add driver API
From: Johannes Berg <johannes@sipsolutions.net>
To: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	lrodriguez@atheros.com, nbd@openwrt.org, dubowoj@neratec.com,
	zefir.kurtisi@neratec.com, simon.wunderlich@saxnet.de
In-Reply-To: <20110117161133.6EEA42080@mx.techwires.net>
References: <201101171621.29863.bernhard.schmidt@saxnet.de>
	 <20110117161133.6EEA42080@mx.techwires.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Jan 2011 11:43:22 +0100
Message-ID: <1295347402.3563.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-17 at 10:16 +0100, Bernhard Schmidt wrote:

> @@ -1241,6 +1244,8 @@ static int ieee80211_set_channel(struct wiphy *wiphy,
>  	if (sdata && sdata->vif.type != NL80211_IFTYPE_MONITOR)
>  		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_HT);
>  
> +	ieee80211_radar_detection_enable(local, chan);
> +

So you're ignoring the return value -- that doesn't seem right at all.
Also, if the driver doesn't implement detection, you should probably
reject using the channel.

johannes

