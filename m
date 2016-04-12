Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:35111 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756097AbcDLIwV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2016 04:52:21 -0400
Received: by mail-wm0-f42.google.com with SMTP id a140so44352578wma.0
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2016 01:52:20 -0700 (PDT)
Subject: Re: [PATCH 1/3] cfg80211: Add option to report the bss entry in
 connect result
To: "Kanchanapally, Vidyullatha" <vkanchan@qti.qualcomm.com>,
	johannes@sipsolutions.net
References: <1460367961-11254-1-git-send-email-vkanchan@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
	usdutt@qti.qualcomm.com, amarnath@qca.qualcomm.com
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <570CB741.8060000@broadcom.com> (sfid-20160412_105227_589885_1840E76B)
Date: Tue, 12 Apr 2016 10:52:17 +0200
MIME-Version: 1.0
In-Reply-To: <1460367961-11254-1-git-send-email-vkanchan@qti.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 11-04-16 11:46, Kanchanapally, Vidyullatha wrote:
> From: "Kanchanapally, Vidyullatha" <vkanchan@qti.qualcomm.com>
> 
> Since cfg80211 maintains separate BSS table entries for APs if the same
> BSSID, SSID pair is seen on multiple channels, it is possible that it
> can map the current_bss to a BSS entry on the wrong channel. This
> current_bss will not get flushed unless disconnected and cfg80211
> reports a wrong channel as the associated channel.
> 
> Fix this by introducing a new cfg80211_connect_bss() function which is
> similar to cfg80211_connect_result(), but it includes an additional
> parameter: the bss the STA is connected to. This allows drivers to
> provide the exact bss entry that matches the BSS to which the connection
> was completed.

How does this work? Is the bss table entry filed with channel it sees
the bss during scan or does it use the channel indicated in the
beacon/probe reponse. I would expect the latter. Is the AP beaconing on
multiple channels using the same BSSID?

It would help understand this change with a driver patch.

Regards,
Arend

> Reviewed-by: Jouni Malinen <jouni@qca.qualcomm.com>
> Signed-off-by: Vidyullatha Kanchanapally <vkanchan@qti.qualcomm.com>
> Signed-off-by: Sunil Dutt <usdutt@qti.qualcomm.com>
> ---
>  include/net/cfg80211.h | 39 +++++++++++++++++++++++++++++++++++----
>  net/wireless/core.h    |  1 +
>  net/wireless/sme.c     | 28 ++++++++++++++++++++++------
>  net/wireless/util.c    |  2 +-
>  4 files changed, 59 insertions(+), 11 deletions(-)
> 
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 858a97ec..51f177c 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -4648,6 +4648,32 @@ static inline void cfg80211_testmode_event(struct sk_buff *skb, gfp_t gfp)
>  #endif
>  
>  /**
> + * cfg80211_connect_bss - notify cfg80211 of connection result
> + *
> + * @dev: network device
> + * @bssid: the BSSID of the AP
> + * @bss: entry of bss to which STA got connected to, can be obtained
> + *	through cfg80211_get_bss (may be %NULL)
> + * @req_ie: association request IEs (maybe be %NULL)
> + * @req_ie_len: association request IEs length
> + * @resp_ie: association response IEs (may be %NULL)
> + * @resp_ie_len: assoc response IEs length
> + * @status: status code, 0 for successful connection, use
> + *      %WLAN_STATUS_UNSPECIFIED_FAILURE if your device cannot give you
> + *      the real status code for failures.
> + * @gfp: allocation flags
> + *
> + * It should be called by the underlying driver whenever connect() has
> + * succeeded. This is similar to cfg80211_connect_result(), but with the
> + * option of identifying the exact bss entry for the connection. Only one of
> + * these functions should be called.
> + */
> +void cfg80211_connect_bss(struct net_device *dev, const u8 *bssid,
> +			  struct cfg80211_bss *bss, const u8 *req_ie,
> +			  size_t req_ie_len, const u8 *resp_ie,
> +			  size_t resp_ie_len, u16 status, gfp_t gfp);
> +
> +/**
>   * cfg80211_connect_result - notify cfg80211 of connection result
>   *
>   * @dev: network device
> @@ -4664,10 +4690,15 @@ static inline void cfg80211_testmode_event(struct sk_buff *skb, gfp_t gfp)
>   * It should be called by the underlying driver whenever connect() has
>   * succeeded.
>   */
> -void cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
> -			     const u8 *req_ie, size_t req_ie_len,
> -			     const u8 *resp_ie, size_t resp_ie_len,
> -			     u16 status, gfp_t gfp);
> +static inline void
> +cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
> +			const u8 *req_ie, size_t req_ie_len,
> +			const u8 *resp_ie, size_t resp_ie_len,
> +			u16 status, gfp_t gfp)
> +{
> +	cfg80211_connect_bss(dev, bssid, NULL, req_ie, req_ie_len, resp_ie,
> +			     resp_ie_len, status, gfp);
> +}
>  
>  /**
>   * cfg80211_roamed - notify cfg80211 of roaming
> diff --git a/net/wireless/core.h b/net/wireless/core.h
> index 64c70e4..f3b0a07 100644
> --- a/net/wireless/core.h
> +++ b/net/wireless/core.h
> @@ -214,6 +214,7 @@ struct cfg80211_event {
>  			const u8 *resp_ie;
>  			size_t req_ie_len;
>  			size_t resp_ie_len;
> +			struct cfg80211_bss *bss;
>  			u16 status;
>  		} cr;
>  		struct {
> diff --git a/net/wireless/sme.c b/net/wireless/sme.c
> index 1fba416..da97424d 100644
> --- a/net/wireless/sme.c
> +++ b/net/wireless/sme.c
> @@ -753,19 +753,32 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
>  	kfree(country_ie);
>  }
>  
> -void cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
> -			     const u8 *req_ie, size_t req_ie_len,
> -			     const u8 *resp_ie, size_t resp_ie_len,
> -			     u16 status, gfp_t gfp)
> +/* Consumes bss object one way or another */
> +void cfg80211_connect_bss(struct net_device *dev, const u8 *bssid,
> +			  struct cfg80211_bss *bss, const u8 *req_ie,
> +			  size_t req_ie_len, const u8 *resp_ie,
> +			  size_t resp_ie_len, u16 status, gfp_t gfp)
>  {
>  	struct wireless_dev *wdev = dev->ieee80211_ptr;
>  	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
>  	struct cfg80211_event *ev;
>  	unsigned long flags;
>  
> +	if (bss) {
> +		/* Make sure the bss entry provided by the driver is valid. */
> +		struct cfg80211_internal_bss *ibss = bss_from_pub(bss);
> +
> +		if (WARN_ON(list_empty(&ibss->list))) {
> +			cfg80211_put_bss(wdev->wiphy, bss);
> +			return;
> +		}
> +	}
> +
>  	ev = kzalloc(sizeof(*ev) + req_ie_len + resp_ie_len, gfp);
> -	if (!ev)
> +	if (!ev) {
> +		cfg80211_put_bss(wdev->wiphy, bss);
>  		return;
> +	}
>  
>  	ev->type = EVENT_CONNECT_RESULT;
>  	if (bssid)
> @@ -780,6 +793,9 @@ void cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
>  		ev->cr.resp_ie_len = resp_ie_len;
>  		memcpy((void *)ev->cr.resp_ie, resp_ie, resp_ie_len);
>  	}
> +	if (bss)
> +		cfg80211_hold_bss(bss_from_pub(bss));
> +	ev->cr.bss = bss;
>  	ev->cr.status = status;
>  
>  	spin_lock_irqsave(&wdev->event_lock, flags);
> @@ -787,7 +803,7 @@ void cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
>  	spin_unlock_irqrestore(&wdev->event_lock, flags);
>  	queue_work(cfg80211_wq, &rdev->event_work);
>  }
> -EXPORT_SYMBOL(cfg80211_connect_result);
> +EXPORT_SYMBOL(cfg80211_connect_bss);
>  
>  /* Consumes bss object one way or another */
>  void __cfg80211_roamed(struct wireless_dev *wdev,
> diff --git a/net/wireless/util.c b/net/wireless/util.c
> index 9f440a9..fb45750 100644
> --- a/net/wireless/util.c
> +++ b/net/wireless/util.c
> @@ -950,7 +950,7 @@ void cfg80211_process_wdev_events(struct wireless_dev *wdev)
>  				ev->cr.resp_ie, ev->cr.resp_ie_len,
>  				ev->cr.status,
>  				ev->cr.status == WLAN_STATUS_SUCCESS,
> -				NULL);
> +				ev->cr.bss);
>  			break;
>  		case EVENT_ROAMED:
>  			__cfg80211_roamed(wdev, ev->rm.bss, ev->rm.req_ie,
> 
