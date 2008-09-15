Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650AbYIOOHH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 10:07:07 -0400
Subject: Re: [RFC] mac80211: notify the user space about low signal quality
From: Dan Williams <dcbw@redhat.com>
To: Helmut Schaa <hschaa@suse.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200809151435.28933.hschaa@suse.de>
References: <200809151416.07552.hschaa@suse.de>
	 <200809151435.28933.hschaa@suse.de>
Content-Type: text/plain
Date: Mon, 15 Sep 2008 10:07:31 -0400
Message-Id: <1221487652.10177.23.camel@localhost.localdomain> (sfid-20080915_160726_772226_B6B6BC19)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-09-15 at 14:35 +0200, Helmut Schaa wrote:
> This patch adds a new wext event that notifies the user space about a low
> signal quality. The currently used indicator is as follows: If three
> successive beacons are received with a signal quality lower then 40%
> user space gets informed.
> 
> Any ideas about which indicators should be used? Comments?

So why does this need a new event?  Can't wpa_supplicant monitor the
signal quality (or level/noise if the driver doesn't provide "quality")
and do what it needs to do without any changes to the kernel at all?

That's what any userspace process already does.  If you're concerned
about polling or something, we could fix that by sending periodic
quality events (which would rock! then I don't have to poll in NM) on a
standardized basis with a sliding scale of frequency based on the signal
strength reported by the card like so:

1 - 10%: every 2 seconds
11 - 20%: every 3 seconds
21 - 30%: every 4 seconds
31 - 100%: every 5 seconds

Stuff can still poll if it really really wants to.  I'm concerned about
adding arbitrary "roaming thresholds" to the stack, since that can
certainly mean different things to different programs.  It's not
necessarily a system-wide value, and adding it as another tweakable
seems unnecessary.

We've already got IWEVQUAL, why don't we use it?

Dan

> Signed-off-by: Helmut Schaa <hschaa@suse.de>
> ---
> diff --git a/include/linux/wireless.h b/include/linux/wireless.h
> index d7958f9..6229aa2 100644
> --- a/include/linux/wireless.h
> +++ b/include/linux/wireless.h
> @@ -294,6 +294,7 @@
>  #define SIOCSIWPOWER	0x8B2C		/* set Power Management settings */
>  #define SIOCGIWPOWER	0x8B2D		/* get Power Management settings */
>  
> +
>  /* WPA : Generic IEEE 802.11 informatiom element (e.g., for WPA/RSN/WMM).
>   * This ioctl uses struct iw_point and data buffer that includes IE id and len
>   * fields. More than one IE may be included in the request. Setting the generic
> @@ -389,6 +390,8 @@
>  					 * pre-authentication
>  					 * (struct iw_pmkid_cand) */
>  
> +#define IWEVROAM	0x8C0A		/* roaming threshold exceeded */
> +
>  #define IWEVFIRST	0x8C00
>  #define IW_EVENT_IDX(cmd)	((cmd) - IWEVFIRST)
>  
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index 3912fba..c05f70c 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -351,6 +351,7 @@ struct ieee80211_if_sta {
>  	u32 supp_rates_bits[IEEE80211_NUM_BANDS];
>  
>  	int wmm_last_param_set;
> +	unsigned int roam_threshold_count;
>  };
>  
>  struct ieee80211_if_mesh {
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 2e55208..e67fe56 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -45,6 +45,7 @@
>  
>  #define IEEE80211_IBSS_MAX_STA_ENTRIES 128
>  
> +#define IEEE80211_ROAMING_QUALITY_THRESHOLD 40
>  
>  /* utils */
>  static int ecw2cw(int ecw)
> @@ -1659,6 +1660,27 @@ static void ieee80211_rx_mgmt_probe_resp(struct ieee80211_sub_if_data *sdata,
>  	}
>  }
>  
> +static void ieee80211_rx_check_threshold(struct ieee80211_sub_if_data *sdata,
> +					 int freq)
> +{
> +	union iwreq_data wrqu;
> +	struct ieee80211_bss *bss;
> +	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
> +	bss = ieee80211_rx_bss_get(sdata->local, ifsta->bssid, freq,
> +				   ifsta->ssid, ifsta->ssid_len);
> +
> +	if (bss->qual < IEEE80211_ROAMING_QUALITY_THRESHOLD) {
> +		if (++(ifsta->roam_threshold_count) > 3) {
> +			printk(KERN_DEBUG "%s roaming theshold exceeded\n",
> +			       sdata->dev->name);
> +			memset(&wrqu, 0, sizeof(wrqu));
> +			wireless_send_event(sdata->dev, IWEVROAM, &wrqu, NULL);
> +		}
> +	} else
> +		ifsta->roam_threshold_count = 0;
> +
> +	ieee80211_rx_bss_put(sdata->local, bss);
> +}
>  
>  static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
>  				     struct ieee80211_mgmt *mgmt,
> @@ -1711,6 +1733,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
>  					       &bss_info);
>  	}
>  
> +	ieee80211_rx_check_threshold(sdata, rx_status->freq);
>  	ieee80211_bss_info_change_notify(sdata, changed);
>  }
>  
> diff --git a/net/wireless/wext.c b/net/wireless/wext.c
> index d98ffb7..c2feebb 100644
> --- a/net/wireless/wext.c
> +++ b/net/wireless/wext.c
> @@ -387,6 +387,9 @@ static const struct iw_ioctl_description standard_event[] = {
>  		.token_size	= 1,
>  		.max_tokens	= sizeof(struct iw_pmkid_cand),
>  	},
> +	[IWEVROAM	- IWEVFIRST] = {
> +		.header_type	= IW_HEADER_TYPE_ADDR,
> +	},
>  };
>  static const unsigned standard_event_num = ARRAY_SIZE(standard_event);
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

