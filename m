Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:49862 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755598AbeFOLlP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Jun 2018 07:41:15 -0400
Message-ID: <1529062873.10037.9.camel@sipsolutions.net> (sfid-20180615_134118_686678_45310791)
Subject: Re: [PATCH v2 1/2] cfg80211: last ack signal support in station dump
From: Johannes Berg <johannes@sipsolutions.net>
To: Balaji Pothunoori <bpothuno@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 15 Jun 2018 13:41:13 +0200
In-Reply-To: <1528121469-16450-2-git-send-email-bpothuno@codeaurora.org>
References: <1528121469-16450-1-git-send-email-bpothuno@codeaurora.org>
         <1528121469-16450-2-git-send-email-bpothuno@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-06-04 at 19:41 +0530, Balaji Pothunoori wrote:
> 
> +++ b/include/uapi/linux/nl80211.h
> @@ -3000,8 +3000,8 @@ enum nl80211_sta_bss_param {
>   *	received from the station (u64, usec)
>   * @NL80211_STA_INFO_PAD: attribute used for padding for 64-bit alignment
>   * @NL80211_STA_INFO_ACK_SIGNAL: signal strength of the last ACK frame(u8, dBm)
> - * @NL80211_STA_INFO_DATA_ACK_SIGNAL_AVG: avg signal strength of (data)
> - *	ACK frame (s8, dBm)
> + * @NL80211_STA_INFO_ACK_SIGNAL_AVG: avg signal strength of data or management
> + *	ACK frames(s8, dBm)
>   * @__NL80211_STA_INFO_AFTER_LAST: internal
>   * @NL80211_STA_INFO_MAX: highest possible station info attribute
>   */
> @@ -3041,7 +3041,7 @@ enum nl80211_sta_info {
>  	NL80211_STA_INFO_RX_DURATION,
>  	NL80211_STA_INFO_PAD,
>  	NL80211_STA_INFO_ACK_SIGNAL,
> -	NL80211_STA_INFO_DATA_ACK_SIGNAL_AVG,
> +	NL80211_STA_INFO_ACK_SIGNAL_AVG,

Wait, what happened here? You can't remove old API.

> @@ -5128,9 +5128,9 @@ enum nl80211_feature_flags {
>   *	"radar detected" event.
>   * @NL80211_EXT_FEATURE_CONTROL_PORT_OVER_NL80211: Driver supports sending and
>   *	receiving control port frames over nl80211 instead of the netdevice.
> - * @NL80211_EXT_FEATURE_DATA_ACK_SIGNAL_SUPPORT: This Driver support data ack
> - *	rssi if firmware support, this flag is to intimate about ack rssi
> - *	support to nl80211.
> + * @NL80211_EXT_FEATURE_ACK_SIGNAL_SUPPORT: This Driver support ack rssi if
> + *	firmware support, this flag is to intimate about ack rssi support
> + *	to nl80211.

Same here, why are you removing the data-ack-signal API?

Is that just a rebase error or something?

Or is it intentional, but then please explain what you're trying to do
and I can help find a correct solutions.

johannes
