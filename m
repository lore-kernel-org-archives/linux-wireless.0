Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:35161 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476Ab0JEFbA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 01:31:00 -0400
From: "Gabay, Benzy" <benzyg@ti.com>
To: Luciano Coelho <luciano.coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Date: Tue, 5 Oct 2010 00:30:31 -0500
Subject: RE: [PATCH 24/25] wl1271: Optimize scan duration
Message-ID: <676FD6AA0F002F49B89E70F0C5EFD22C135AD3C603@dlee04.ent.ti.com>
References: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
 <1285576669-8070-25-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1285576669-8070-25-git-send-email-luciano.coelho@nokia.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Juuso,

> 
> From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> 
> Currently then dwell times for each channel in scans is set to an
> overly
> long value, and excessive number of probe-requests are transmitted on
> each
> channel (for active scans.)
> 
> Based on testing, comparable results can be received with smaller
> dwell-time,
> and, with fever probe-requests - in fact, reducing the number of probe-
> requests
> to 2 seems to increase the number of found results.

I think that this does not making any sense. Less prob requests should give you back less results. As less beacons/prob responses are getting back to the station.
I think also that office with 70 AP is not a normal environment to test and optimize numbers.
I would suggest to re-test in a 1-6 AP environment which is making more sense for both home and enterprise environment.

> 
> Configure more optimal values for per channel dwell times. Comparison
> for the
> different scan configurations (in my current office environment):
> 
> dwell-time 60000   3x probe-req == ~60 results
>            40000   3x probe-req == ~50 results
>            30000   3x probe-req == ~40 results
> 
> dwell-time 60000   2x probe-req == ~70 results
>            40000   2x probe-req == ~60 results
>            30000   2x probe-req == ~58 results
> 
> The above are results for a cumulative 3 scan run. For individual
> scans, the
> number of results drop slightly more.
> 
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
> Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
> ---
>  drivers/net/wireless/wl12xx/wl1271_conf.h |   39
> +++++++++++++++++++++++++++++
>  drivers/net/wireless/wl12xx/wl1271_main.c |    9 ++++++-
>  drivers/net/wireless/wl12xx/wl1271_scan.c |   18 +++++++++---
>  drivers/net/wireless/wl12xx/wl1271_scan.h |    3 --
>  4 files changed, 60 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/wireless/wl12xx/wl1271_conf.h
> b/drivers/net/wireless/wl12xx/wl1271_conf.h
> index feb493e..ab716f5 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_conf.h
> +++ b/drivers/net/wireless/wl12xx/wl1271_conf.h
> @@ -1016,6 +1016,44 @@ struct conf_roam_trigger_settings {
>  	u8 avg_weight_snr_data;
>  };
> 
> +struct conf_scan_settings {
> +	/*
> +	 * The minimum time to wait on each channel for active scans
> +	 *
> +	 * Range: 0 - 65536 tu
> +	 */
> +	u16 min_dwell_time_active;
> +
> +	/*
> +	 * The maximum time to wait on each channel for active scans
> +	 *
> +	 * Range: 0 - 65536 tu
> +	 */
> +	u16 max_dwell_time_active;
> +
> +	/*
> +	 * The maximum time to wait on each channel for passive scans
> +	 *
> +	 * Range: 0 - 65536 tu
> +	 */
> +	u16 min_dwell_time_passive;
> +
> +	/*
> +	 * The maximum time to wait on each channel for passive scans
> +	 *
> +	 * Range: 0 - 65536 tu
> +	 */
> +	u16 max_dwell_time_passive;
> +
> +	/*
> +	 * Number of probe requests to transmit on each active scan
> channel
> +	 *
> +	 * Range: u8
> +	 */
> +	u16 num_probe_reqs;
> +
> +};
> +
>  struct conf_drv_settings {
>  	struct conf_sg_settings sg;
>  	struct conf_rx_settings rx;
> @@ -1024,6 +1062,7 @@ struct conf_drv_settings {
>  	struct conf_itrim_settings itrim;
>  	struct conf_pm_config_settings pm_config;
>  	struct conf_roam_trigger_settings roam_trigger;
> +	struct conf_scan_settings scan;
>  };
> 
>  #endif
> diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c
> b/drivers/net/wireless/wl12xx/wl1271_main.c
> index 3f4e154..dcbd6f5 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_main.c
> +++ b/drivers/net/wireless/wl12xx/wl1271_main.c
> @@ -232,7 +232,14 @@ static struct conf_drv_settings default_conf = {
>  		.avg_weight_rssi_data         = 10,
>  		.avg_weight_snr_beacon        = 20,
>  		.avg_weight_snr_data          = 10
> -	}
> +	},
> +	.scan = {
> +		.min_dwell_time_active        = 7500,
> +		.max_dwell_time_active        = 30000,
> +		.min_dwell_time_passive       = 30000,
> +		.max_dwell_time_passive       = 60000,
> +		.num_probe_reqs               = 2,
> +	},
>  };
> 
>  static void __wl1271_op_remove_interface(struct wl1271 *wl);
> diff --git a/drivers/net/wireless/wl12xx/wl1271_scan.c
> b/drivers/net/wireless/wl12xx/wl1271_scan.c
> index 37f9ccb..5c76b79 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_scan.c
> +++ b/drivers/net/wireless/wl12xx/wl1271_scan.c
> @@ -64,6 +64,7 @@ static int wl1271_get_scan_channels(struct wl1271
> *wl,
>  				    struct basic_scan_channel_params *channels,
>  				    enum ieee80211_band band, bool passive)
>  {
> +	struct conf_scan_settings *c = &wl->conf.scan;
>  	int i, j;
>  	u32 flags;
> 
> @@ -91,10 +92,17 @@ static int wl1271_get_scan_channels(struct wl1271
> *wl,
>  			wl1271_debug(DEBUG_SCAN, "beacon_found %d",
>  				     req->channels[i]->beacon_found);
> 
> -			channels[j].min_duration =
> -				cpu_to_le32(WL1271_SCAN_CHAN_MIN_DURATION);
> -			channels[j].max_duration =
> -				cpu_to_le32(WL1271_SCAN_CHAN_MAX_DURATION);
> +			if (!passive) {
> +				channels[j].min_duration =
> +					cpu_to_le32(c->min_dwell_time_active);
> +				channels[j].max_duration =
> +					cpu_to_le32(c->max_dwell_time_active);
> +			} else {
> +				channels[j].min_duration =
> +					cpu_to_le32(c->min_dwell_time_passive);
> +				channels[j].max_duration =
> +					cpu_to_le32(c->max_dwell_time_passive);
> +			}
>  			channels[j].early_termination = 0;
>  			channels[j].tx_power_att = req->channels[i]-
> >max_power;
>  			channels[j].channel = req->channels[i]->hw_value;
> @@ -151,7 +159,7 @@ static int wl1271_scan_send(struct wl1271 *wl, enum
> ieee80211_band band,
>  	cmd->params.rx_filter_options =
>  		cpu_to_le32(CFG_RX_PRSP_EN | CFG_RX_MGMT_EN |
> CFG_RX_BCN_EN);
> 
> -	cmd->params.n_probe_reqs = WL1271_SCAN_PROBE_REQS;
> +	cmd->params.n_probe_reqs = wl->conf.scan.num_probe_reqs;
>  	cmd->params.tx_rate = cpu_to_le32(basic_rate);
>  	cmd->params.tid_trigger = 0;
>  	cmd->params.scan_tag = WL1271_SCAN_DEFAULT_TAG;
> diff --git a/drivers/net/wireless/wl12xx/wl1271_scan.h
> b/drivers/net/wireless/wl12xx/wl1271_scan.h
> index bb7af2a..6d57127 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_scan.h
> +++ b/drivers/net/wireless/wl12xx/wl1271_scan.h
> @@ -40,11 +40,8 @@ void wl1271_scan_complete_work(struct work_struct
> *work);
>  #define WL1271_SCAN_OPT_ACTIVE         0
>  #define WL1271_SCAN_OPT_PASSIVE	       1
>  #define WL1271_SCAN_OPT_PRIORITY_HIGH  4
> -#define WL1271_SCAN_CHAN_MIN_DURATION  30000  /* TU */
> -#define WL1271_SCAN_CHAN_MAX_DURATION  60000  /* TU */
>  #define WL1271_SCAN_BAND_2_4_GHZ 0
>  #define WL1271_SCAN_BAND_5_GHZ 1
> -#define WL1271_SCAN_PROBE_REQS 3
> 
>  #define WL1271_SCAN_TIMEOUT    10000 /* msec */
> 
> --



Thank You
=========
Benzy Gabay
OMAP-WLAN Lead
Texas Instruments
