Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60642 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbaEMRpN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2014 13:45:13 -0400
Date: Tue, 13 May 2014 13:39:59 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 3.15] nl80211: fix
 NL80211_FEATURE_P2P_DEVICE_NEEDS_CHANNEL API
Message-ID: <20140513173959.GF21204@tuxdriver.com> (sfid-20140513_194516_843513_4C81040F)
References: <1399988848-13185-1-git-send-email-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1399988848-13185-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do we need to preserve the API compatibility?

On Tue, May 13, 2014 at 03:47:28PM +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> My commit removing that also removed it from the header file
> which can break compilation of userspace that needed it, add
> it back for API/ABI compatibility purposes (but no code to
> implement anything for it.)
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  include/uapi/linux/nl80211.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index 1ba9d626aa83..194c1eab04d8 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -3856,6 +3856,8 @@ enum nl80211_ap_sme_features {
>   * @NL80211_FEATURE_CELL_BASE_REG_HINTS: This driver has been tested
>   *	to work properly to suppport receiving regulatory hints from
>   *	cellular base stations.
> + * @NL80211_FEATURE_P2P_DEVICE_NEEDS_CHANNEL: (no longer available, only
> + *	here to reserve the value for API/ABI compatibility)
>   * @NL80211_FEATURE_SAE: This driver supports simultaneous authentication of
>   *	equals (SAE) with user space SME (NL80211_CMD_AUTHENTICATE) in station
>   *	mode
> @@ -3897,7 +3899,7 @@ enum nl80211_feature_flags {
>  	NL80211_FEATURE_HT_IBSS				= 1 << 1,
>  	NL80211_FEATURE_INACTIVITY_TIMER		= 1 << 2,
>  	NL80211_FEATURE_CELL_BASE_REG_HINTS		= 1 << 3,
> -	/* bit 4 is reserved - don't use */
> +	NL80211_FEATURE_P2P_DEVICE_NEEDS_CHANNEL	= 1 << 4,
>  	NL80211_FEATURE_SAE				= 1 << 5,
>  	NL80211_FEATURE_LOW_PRIORITY_SCAN		= 1 << 6,
>  	NL80211_FEATURE_SCAN_FLUSH			= 1 << 7,
> -- 
> 2.0.0.rc0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
