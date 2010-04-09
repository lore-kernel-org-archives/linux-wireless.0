Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52870 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757419Ab0DIJMm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Apr 2010 05:12:42 -0400
Subject: Re: [PATCH] mac80211: Prevent dynamic ps for rx broadcast frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1270802794-6869-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1270802794-6869-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Apr 2010 11:12:35 +0200
Message-ID: <1270804355.3870.16.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-04-09 at 11:46 +0300, Juuso Oikarinen wrote:
> Currently the dynamic ps timer is restarted for all non-multicast rx data
> frames. Congested networks have lots of broadcast traffic, which will cause
> the power save to remain disabled for much of the time, which causes trouble
> for battery-powered devices.
> 
> Fix this by preventing rx broadcast data frames from restarting the
> dynamic ps timer.
> 
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> ---
>  net/mac80211/rx.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index c0ad7e8..8cdcc4f 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -1786,6 +1786,7 @@ ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
>  
>  	if (ieee80211_is_data(hdr->frame_control) &&
>  	    !is_multicast_ether_addr(hdr->addr1) &&
> +	    !is_broadcast_ether_addr(hdr->addr1) &&
>  	    local->hw.conf.dynamic_ps_timeout > 0 && local->ps_sdata) {

Huh? I'm starting to doubt my own sanity now!

Formal logic:

    (bcast => mcast)
<=> (!mcast => !bcast)

Thus

    (!mcast && !bcast)
<=> (!mcast)

right?

johannes

