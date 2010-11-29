Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50633 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab0K2Spe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 13:45:34 -0500
Subject: Re: [PATCH for-2.6.37?] mac80211: ignore non-bcast mcast managment
 frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Saqeb Akhter <saqeb.akhter@gmail.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	linville@tuxdriver.com
In-Reply-To: <201011291937.25195.chunkeey@googlemail.com>
References: <AANLkTimN3X_e4fZhUSoTs-GmQ9kmaJUrgnxAu8=W2dT_@mail.gmail.com>
	 <201010021332.09809.chunkeey@googlemail.com>
	 <201011291814.58230.chunkeey@googlemail.com>
	 <201011291937.25195.chunkeey@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Nov 2010 19:45:30 +0100
Message-ID: <1291056330.3532.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-11-29 at 19:37 +0100, Christian Lamparter wrote:

> @@ -1999,6 +1999,10 @@ ieee80211_rx_h_mgmt_check(struct ieee80211_rx_data *rx)
>  	if (!ieee80211_is_mgmt(mgmt->frame_control))
>  		return RX_DROP_MONITOR;
>  
> +	if (is_multicast_ether_addr(mgmt->da) &&
> +	    !is_broadcast_ether_addr(mgmt->da))
> +		return RX_DROP_MONITOR;
> +

I'm not sure we should do this here since the nl80211 hook is later?

johannes

