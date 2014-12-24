Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:15396 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbaLXXSI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2014 18:18:08 -0500
Message-ID: <549B49AD.7070804@broadcom.com> (sfid-20141225_001821_258995_541280E0)
Date: Thu, 25 Dec 2014 00:18:05 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Avinash Patil <patila@marvell.com>
CC: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <janusz.dziedzic@tieto.com>,
	<johannes@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: check for carrier state only when offchanel
 CAC supported
References: <1419425236-17457-1-git-send-email-patila@marvell.com>
In-Reply-To: <1419425236-17457-1-git-send-email-patila@marvell.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/24/14 13:47, Avinash Patil wrote:
> Checking for carrier state during start_radar_detection is needed
> only for devices which support offchannel CAC.
> This patch provides this additional check of extended feature offchannel
> CAC support while checking for carrier state.
>
> Signed-off-by: Avinash Patil<patila@marvell.com>
> ---
>   include/uapi/linux/nl80211.h | 3 +++
>   net/wireless/nl80211.c       | 4 +++-
>   2 files changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index 735ab43..9ac9008 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -4205,11 +4205,14 @@ enum nl80211_feature_flags {
>   /**
>    * enum nl80211_ext_feature_index - bit index of extended features.
>    *
> + * @NL80211_EXT_FEATURE_OFFCHAN_CAC: This device/driver supports
> + * offchannel Channel Availibility Check(CAC).

continuation on next line should be indented with a tab.

Regards,
Arend

>    * @NUM_NL80211_EXT_FEATURES: number of extended features.
>    * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
>    */
>   enum nl80211_ext_feature_index {
>
> +	NL80211_EXT_FEATURE_OFFCHAN_CAC,
>   	/* add new features before the definition below */
>   	NUM_NL80211_EXT_FEATURES,
>   	MAX_NL80211_EXT_FEATURES = NUM_NL80211_EXT_FEATURES - 1
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 39753de..b2abb37 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -6138,7 +6138,9 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
>   	if (err)
>   		return err;
>
> -	if (netif_carrier_ok(dev))
> +	if (wiphy_ext_feature_isset(&rdev->wiphy,
> +				    NL80211_EXT_FEATURE_OFFCHAN_CAC)&&
> +	    netif_carrier_ok(dev))
>   		return -EBUSY;
>
>   	if (wdev->cac_started)

