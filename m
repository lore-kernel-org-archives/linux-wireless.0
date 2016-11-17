Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:34991 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750813AbcKQU4t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 15:56:49 -0500
Received: by mail-wm0-f42.google.com with SMTP id a197so336302223wmd.0
        for <linux-wireless@vger.kernel.org>; Thu, 17 Nov 2016 12:56:49 -0800 (PST)
Subject: Re: [PATCH] RFC: Universal scan proposal
To: dimitrysh@google.com, linux-wireless@vger.kernel.org
References: <94eb2c110db85c2379054172dad0@google.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <7645397c-c9cd-f7ac-4add-fae580c485e9@broadcom.com> (sfid-20161117_215653_491794_C8F9C3ED)
Date: Thu, 17 Nov 2016 21:56:44 +0100
MIME-Version: 1.0
In-Reply-To: <94eb2c110db85c2379054172dad0@google.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16-11-2016 23:47, dimitrysh@google.com wrote:
> From 68a9d37a4c7e9dc7a90a6e922cdea52737a98d66 Mon Sep 17 00:00:00 2001
> From: Dmitry Shmidt <dimitrysh@google.com>
> Date: Wed, 16 Nov 2016 14:27:26 -0800
> Subject: [PATCH] RFC: Universal scan proposal
> 
>   Currently we have sched scan with possibility of various
> intervals. We would like to extend it to support also
> different types of scan.
>   In case of powerful wlan CPU, all this functionality
> can be offloaded.
>   In general case FW processes additional scan requests
> and puts them into queue based on start time and interval.
> Once current request is fulfilled, FW adds it (if interval != 0)
> again to the queue with proper interval. If requests are
> overlapping, new request can be combined with either one before,
> or one after, assuming that requests are not mutually exclusive.
>   Combining requests is done by combining scan channels, ssids,
> bssids and types of scan result. Once combined request was fulfilled
> it will be reinserted as two (or three) different requests based on
> their type and interval.
>   Each request has attribute:
> Type: connectivity / location

Don't see this type in the patch below (guess it was a last minute
addition ;-) ).

> Report: none / batch / immediate
>   Request may have priority and can be inserted into
> the head of the queue.
>   Types of scans:
> - Normal scan
> - Scheduled scan
> - Hotlist (BSSID scan)
> - Roaming
> - AutoJoin

Don't see the last one mentioned in the patch below.

> Change-Id: I9f3e4c975784f1c1c5156887144d80fc5a26bffa
> Signed-off-by: Dmitry Shmidt <dimitrysh@google.com>
> ---
>  include/net/cfg80211.h | 37 +++++++++++++++++++++++++++++++------
>  1 file changed, 31 insertions(+), 6 deletions(-)
> 
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 14b51d7..1ae2570 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -1602,8 +1602,10 @@ struct cfg80211_sched_scan_plan {
>   *    cycle.  The driver may ignore this parameter and start
>   *    immediately (or at any other time), if this feature is not
>   *    supported.

At the the top of this kernel doc section it probably still refers to
struct cfg80211_sched_scan_request.

> + * @uscan_type: uscan type (scan, sched_scan, hotlist, scan_history,
> roaming)
> + * @uscan_results: uscan results report (none/batch/immediate)

If you change the type to struct cfg80211_uscan_request it seems a bit
redundant to prefix the field names with 'uscan_'.

>   */
> -struct cfg80211_sched_scan_request {
> +struct cfg80211_uscan_request {
>      struct cfg80211_ssid *ssids;
>      int n_ssids;
>      u32 n_channels;
> @@ -1621,6 +1623,10 @@ struct cfg80211_sched_scan_request {
>      u8 mac_addr[ETH_ALEN] __aligned(2);
>      u8 mac_addr_mask[ETH_ALEN] __aligned(2);
> 
> +    /* universal scan fields */

As the struct name changed it seems to me all fields in the struct are
universal scan fields.

> +    u32 uscan_type;
> +    u32 uscan_results;
> +
>      /* internal */
>      struct wiphy *wiphy;
>      struct net_device *dev;
> @@ -1633,6 +1639,21 @@ struct cfg80211_sched_scan_request {
>  };
> 
>  /**
> + * struct cfg80211_uscan_capa - universal scan capabilities
> + *
> + * @uscan_type: uscan type (scan, sched_scan, hotlist, scan_history,
> roaming)
> + * @max_ssids: max amount of ssids in sched scan
> + * @max_hotlist: max amount of bssids in hotlist
> + * @max_history: max amount of records in history
> + */
> +struct cfg80211_uscan_capa {
> +    u32 uscan_type;
> +    u32 max_ssids;
> +    u32 max_hotlist;
> +    u32 max_history;
> +};
> +
> +/**
>   * enum cfg80211_signal_type - signal type
>   *
>   * @CFG80211_SIGNAL_TYPE_NONE: no signal strength information available
> @@ -2898,10 +2919,13 @@ struct cfg80211_ops {
>      int    (*set_antenna)(struct wiphy *wiphy, u32 tx_ant, u32 rx_ant);
>      int    (*get_antenna)(struct wiphy *wiphy, u32 *tx_ant, u32 *rx_ant);
> 
> -    int    (*sched_scan_start)(struct wiphy *wiphy,
> +    int    (*uscan_get_capa)(struct wiphy *wiphy, struct net_device *dev,
> +                struct cfg80211_uscan_capa *uscan_capa);

Not sure if people start worrying about the size of struct wiphy
already, but for static information like capabilities I think a callback
is overkill.

> +    int    (*uscan_start)(struct wiphy *wiphy,
>                  struct net_device *dev,
> -                struct cfg80211_sched_scan_request *request);
> -    int    (*sched_scan_stop)(struct wiphy *wiphy, struct net_device
> *dev);
> +                struct cfg80211_uscan_request *request);

So given the two extra fields, what different driver/device behaviour is
required, eg. if uscan_type == roaming what will be different compared
to a normal scan.

> +    int    (*uscan_stop)(struct wiphy *wiphy, struct net_device *dev,
> +                int uscan_id);

The uscan_id is probably referring to a specific scan request started by
uscan_start. So who hands out that id (wiphy->cookie_counter?) and how
does the driver know about it. If cfg80211 determines the id it probably
need to be passed in the uscan request.

>      int    (*set_rekey_data)(struct wiphy *wiphy, struct net_device *dev,
>                    struct cfg80211_gtk_rekey_data *data);
> @@ -4305,11 +4329,12 @@ void cfg80211_scan_done(struct
> cfg80211_scan_request *request,
>              struct cfg80211_scan_info *info);
> 
>  /**
> - * cfg80211_sched_scan_results - notify that new scan results are
> available
> + * cfg80211_uscan_results - notify that new uscan results are available
>   *
>   * @wiphy: the wiphy which got scheduled scan results
> + * @uscan_id: type of scan results

Confused now. What is uscan_id here? Same as in .uscan_stop() callback?

>   */
> -void cfg80211_sched_scan_results(struct wiphy *wiphy);
> +void cfg80211_sched_scan_results(struct wiphy *wiphy, int uscan_id);

should this be renamed to cfg80211_uscan_results().

>  /**
>   * cfg80211_sched_scan_stopped - notify that the scheduled scan has
> stopped

Also change to cfg80211_uscan_stopped()? Does it need an additional
argument, ie. uscan_id.

Regards,
Arend
