Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:50666 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757063AbXGKAZU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2007 20:25:20 -0400
Date: Wed, 11 Jul 2007 02:25:08 +0200
From: Jiri Benc <jbenc@suse.cz>
To: benmcahill@gmail.com
Cc: flamingice@sourmilk.net, linux-wireless@vger.kernel.org,
	ben.m.cahill@intel.com
Subject: Re: [PATCH 1/1] mac80211: Replace overly "sticky" averaging filters  for rssi, signal, noise.
Message-ID: <20070711022508.36db6129@logostar.upir.cz>
In-Reply-To: <11841087052370-git-send-email-ben.m.cahill@intel.com>
References: <11841087052370-git-send-email-ben.m.cahill@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 10 Jul 2007 19:05:05 -0400, benmcahill@gmail.com wrote:
> From: Ben Cahill <ben.m.cahill@intel.com>
> 
> Replace overly "sticky" averaging filters for rssi, signal, noise ...
> 
> In old filter, once initial values were set, it took a large deviation (16)
> in new input values in order to nudge the filter output.  This made signal
> quality displays appear frozen, with (probably) inaccurate data.
> 
> The new filter keeps high-precision (16x) running averages, then quantizes
> them to create the output value.  Each new input value nudges the running
> average a bit, and displays appear reassuringly alive, with accurate data.
> 
> Update comments.
> 
> Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
> ---
>  net/mac80211/ieee80211.c     |   20 ++++++++++++++------
>  net/mac80211/ieee80211_sta.c |    7 +++++++
>  net/mac80211/sta_info.h      |    9 ++++++---
>  3 files changed, 27 insertions(+), 9 deletions(-)
> 
> diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
> index 873ccb0..b838d9c 100644
> --- a/net/mac80211/ieee80211.c
> +++ b/net/mac80211/ieee80211.c
> @@ -3603,12 +3603,20 @@ ieee80211_rx_h_sta_process(struct ieee80211_txrx_data *rx)
>  
>  	sta->rx_fragments++;
>  	sta->rx_bytes += rx->skb->len;
> -	sta->last_rssi = (sta->last_rssi * 15 +
> -			  rx->u.rx.status->ssi) / 16;
> -	sta->last_signal = (sta->last_signal * 15 +
> -			    rx->u.rx.status->signal) / 16;
> -	sta->last_noise = (sta->last_noise * 15 +
> -			   rx->u.rx.status->noise) / 16;
> +
> +	/* Low pass filter:  15/16 current avg + new.
> +	 * Accumulated values here are 16x values sent from driver. */
> +	sta->accum_rssi = sta->accum_rssi - (sta->accum_rssi >> 4) +
> +			  rx->u.rx.status->ssi;
> +	sta->accum_signal = sta->accum_signal - (sta->accum_signal >> 4) +
> +			  rx->u.rx.status->signal;
> +	sta->accum_noise = sta->accum_noise - (sta->accum_noise >> 4) +
> +			  rx->u.rx.status->noise;
> +
> +	/* Quantize the averages (divide by 16) */
> +	sta->last_rssi = sta->accum_rssi >> 4;
> +	sta->last_signal = sta->accum_signal >> 4;
> +	sta->last_noise = sta->accum_noise >> 4;

First, do not obfuscate the code, please. If you want to divide by 16,
divide by 16. The compiler is perfectly capable of optimizing it.

Second, do not obfuscate the algorithm, please. All this does is postponing
the division by 16 in last_rssi = (last_rssi * 15 + status_rssi) / 16 to
a time when last_rssi is actually used.

Please keep all the buzzwords like "high-precision" for yourself and
explain how postponing a division by 16 helps.


(To make my point more clear, the code above could be rewritten as
follows(*):

sta->last_rssi = sta->last_rssi * 15 / 16 +
		 rx->u.rx.status->ssi;
sta->last_signal = sta->last_signal * 15 / 16 +
		   rx->u.rx.status->signal;
sta->last_noise = sta->last_noise * 15 +
		  rx->u.rx.status->noise;

while initializing sta->last_rssi to (16 * bss->rssi) and doing the
division by 16 when passing last_rssi to the user space.)

Thanks.

 Jiri

(*) And without the three additional variables!

>  
>  	if (!(rx->fc & IEEE80211_FCTL_MOREFRAGS)) {
>  		/* Change STA power saving mode only in the end of a frame
> diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
> index b003912..5986183 100644
> --- a/net/mac80211/ieee80211_sta.c
> +++ b/net/mac80211/ieee80211_sta.c
> @@ -1223,9 +1223,16 @@ static void ieee80211_rx_mgmt_assoc_resp(struct net_device *dev,
>  		}
>  		bss = ieee80211_rx_bss_get(dev, ifsta->bssid);
>  		if (bss) {
> +			/* Init signal values from beacon or probe response. */
>  			sta->last_rssi = bss->rssi;
>  			sta->last_signal = bss->signal;
>  			sta->last_noise = bss->noise;
> +
> +			/* Init averaging filter accumulators to 16x values. */
> +			sta->accum_rssi = bss->rssi << 4;
> +			sta->accum_signal = bss->signal << 4;
> +			sta->accum_noise = bss->noise << 4;
> +
>  			ieee80211_rx_bss_put(dev, bss);
>  		}
>  	}
> diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
> index 6a067a0..0ee9212 100644
> --- a/net/mac80211/sta_info.h
> +++ b/net/mac80211/sta_info.h
> @@ -83,9 +83,12 @@ struct sta_info {
>  	unsigned long rx_fragments; /* number of received MPDUs */
>  	unsigned long rx_dropped; /* number of dropped MPDUs from this STA */
>  
> -	int last_rssi; /* RSSI of last received frame from this STA */
> -	int last_signal; /* signal of last received frame from this STA */
> -	int last_noise; /* noise of last received frame from this STA */
> +	int accum_rssi; /* hi-precision running average (rssi * 16) */
> +	int accum_signal; /* hi-precision average (signal-quality * 16) */
> +	int accum_noise; /* hi-precision running average (noise * 16) */
> +	int last_rssi; /* average RSSI of recent frames from this STA */
> +	int last_signal; /* average sig-qual of recent frames from this STA */
> +	int last_noise; /* average noise of recent frames from this STA */
>  	int last_ack_rssi[3]; /* RSSI of last received ACKs from this STA */
>  	unsigned long last_ack;
>  	int channel_use;
> -- 
> 1.5.2
> 


-- 
Jiri Benc
SUSE Labs
