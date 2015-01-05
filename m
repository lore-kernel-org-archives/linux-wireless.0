Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54115 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753272AbbAEM57 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2015 07:57:59 -0500
Message-ID: <1420462674.9459.9.camel@sipsolutions.net> (sfid-20150105_135808_759296_2C2478B1)
Subject: Re: [PATCH v3] cfg80211: check for carrier state only when
 offchanel CAC supported
From: Johannes Berg <johannes@sipsolutions.net>
To: Avinash Patil <patila@marvell.com>
Cc: linux-wireless@vger.kernel.org, akarwar@marvell.com,
	cluo@marvell.com
Date: Mon, 05 Jan 2015 13:57:54 +0100
In-Reply-To: <1420475584-5533-1-git-send-email-patila@marvell.com> (sfid-20150105_120344_381788_A7E15DA0)
References: <1420475584-5533-1-git-send-email-patila@marvell.com>
	 (sfid-20150105_120344_381788_A7E15DA0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-01-05 at 22:03 +0530, Avinash Patil wrote:
> Checking for carrier state during start_radar_detection is needed
> only for devices which support offchannel CAC.
> This patch provides this additional check of extended feature offchannel
> CAC support while checking for carrier state.
> 
> Signed-off-by: Avinash Patil <patila@marvell.com>
> ---
>  include/uapi/linux/nl80211.h | 3 +++
>  net/wireless/nl80211.c       | 4 +++-
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index 735ab43..c318802 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -4205,10 +4205,13 @@ enum nl80211_feature_flags {
>  /**
>   * enum nl80211_ext_feature_index - bit index of extended features.
>   *
> + * @NL80211_EXT_FEATURE_OFFCHAN_CAC: This device/driver supports
> + *	offchannel Channel Availability Check(CAC).
>   * @NUM_NL80211_EXT_FEATURES: number of extended features.
>   * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
>   */
>  enum nl80211_ext_feature_index {
> +	NL80211_EXT_FEATURE_OFFCHAN_CAC,
>  
>  	/* add new features before the definition below */
>  	NUM_NL80211_EXT_FEATURES,
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 39753de..b2abb37 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -6138,7 +6138,9 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
>  	if (err)
>  		return err;
>  
> -	if (netif_carrier_ok(dev))
> +	if (wiphy_ext_feature_isset(&rdev->wiphy,
> +				    NL80211_EXT_FEATURE_OFFCHAN_CAC) &&
> +	    netif_carrier_ok(dev))
>  		return -EBUSY;

Wait - doesn't that have to be !feature_isset()?

johannes

