Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41506 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757041Ab1BAOhC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 09:37:02 -0500
Subject: Re: [RFC] mac80211: do not restart ps timer during scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1296570892-7074-1-git-send-email-rmanoharan@atheros.com>
References: <1296570892-7074-1-git-send-email-rmanoharan@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 15:36:58 +0100
Message-ID: <1296571018.3989.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-02-01 at 20:04 +0530, Rajkumar Manoharan wrote:
> While leaving oper channel, STA informs sleep state to AP to
> stop sending data. Before sending ack for the nullfunc, AP is
> still sending the data to STA which restarts ps_timer that
> is causing unnecessary nullfunc exchange on timer expiry
> when the STA is on offchannel. So don't restart ps_timer
> on data reception during scan. This issue was identified by
> the following warning.
> 
> WARNING: at net/mac80211/tx.c:661 invoke_tx_handlers+0xf07/0x1330 [mac80211]
> wlan0: Dropped data frame as no usable bitrate found while scanning and
> associated. Target station: 00:03:7f:0b:a6:1b on 5 GHz band
> Call Trace:
>   [<ffffffffa0413ba7>] invoke_tx_handlers+0xf07/0x1330 [mac80211]
>   [<ffffffffa0414056>] ieee80211_tx+0x86/0x2c0 [mac80211]
>   [<ffffffffa0414345>] ieee80211_xmit+0xb5/0x1d0 [mac80211]
>   [<ffffffffa04037e0>] ieee80211_dynamic_ps_enable_work+0x0/0xb0 [mac80211]
>   [<ffffffffa04158cf>] ieee80211_tx_skb+0x4f/0x60 [mac80211]
>   [<ffffffffa04026e6>] ieee80211_send_nullfunc+0x46/0x60 [mac80211]
>   [<ffffffffa0403885>] ieee80211_dynamic_ps_enable_work+0xa5/0xb0 [mac80211]
> 
> Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
> ---
>  net/mac80211/rx.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index 7185c93..0e02ce9 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -1929,7 +1929,9 @@ ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
>  	dev->stats.rx_bytes += rx->skb->len;
>  
>  	if (local->ps_sdata && local->hw.conf.dynamic_ps_timeout > 0 &&
> -	    !is_multicast_ether_addr(((struct ethhdr *)rx->skb->data)->h_dest)) {
> +	    !is_multicast_ether_addr(
> +		    ((struct ethhdr *)rx->skb->data)->h_dest) &&
> +	    !local->scanning) {

What if we're off-channel due to other work like P2P?

johannes

