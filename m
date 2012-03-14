Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35566 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388Ab2CNVQp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 17:16:45 -0400
Subject: Re: [PATCH v3 2/3] cfg80211: Fill Toffset for each station
From: Johannes Berg <johannes@sipsolutions.net>
To: Ashok Nagarajan <ashok@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	javier@cozybit.com
In-Reply-To: <1331756567-5001-2-git-send-email-ashok@cozybit.com> (sfid-20120314_212331_878038_F64200B1)
References: <1331756567-5001-1-git-send-email-ashok@cozybit.com>
	 <1331756567-5001-2-git-send-email-ashok@cozybit.com>
	 (sfid-20120314_212331_878038_F64200B1)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Mar 2012 22:16:39 +0100
Message-ID: <1331759799.25475.1.camel@jlt3.sipsolutions.net> (sfid-20120314_221654_751706_00B963C2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As far as patch ordering/splitting goes, I think you should resubmit the
mac80211 changes in the mac80211 patch, and the cfg80211 changes here in
the nl80211 patch (and that obviously requires reordering the patches).

The way it is now is confusing because the cfg80211 patch changes
mac80211 without having to (since this is an optional feature)

johannes

On Wed, 2012-03-14 at 13:22 -0700, Ashok Nagarajan wrote:
> Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
> Signed-off-by: Javier Cardona <javier@cozybit.com>
> ---
> v2:
> Report toffset to userspace only when RX_FLAG_MACTIME_MPDU is set (Johannes)
> 
> v3:
> Introduced a new sta flag to check if toffset calculated is valid
> 
>  include/net/cfg80211.h |    6 +++++-
>  net/mac80211/cfg.c     |    4 ++++
>  2 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 66f4603..22c42bb 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -520,6 +520,7 @@ struct station_parameters {
>   * @STATION_INFO_ASSOC_REQ_IES: @assoc_req_ies filled
>   * @STATION_INFO_STA_FLAGS: @sta_flags filled
>   * @STATION_INFO_BEACON_LOSS_COUNT: @beacon_loss_count filled
> + * @STATION_INFO_T_OFFSET: @t_offset filled
>   */
>  enum station_info_flags {
>  	STATION_INFO_INACTIVE_TIME	= 1<<0,
> @@ -541,7 +542,8 @@ enum station_info_flags {
>  	STATION_INFO_CONNECTED_TIME	= 1<<16,
>  	STATION_INFO_ASSOC_REQ_IES	= 1<<17,
>  	STATION_INFO_STA_FLAGS		= 1<<18,
> -	STATION_INFO_BEACON_LOSS_COUNT	= 1<<19
> +	STATION_INFO_BEACON_LOSS_COUNT	= 1<<19,
> +	STATION_INFO_T_OFFSET		= 1<<20,
>  };
>  
>  /**
> @@ -640,6 +642,7 @@ struct sta_bss_parameters {
>   * @assoc_req_ies_len: Length of assoc_req_ies buffer in octets.
>   * @sta_flags: station flags mask & values
>   * @beacon_loss_count: Number of times beacon loss event has triggered.
> + * @t_offset: Time offset of the station relative to this host.
>   */
>  struct station_info {
>  	u32 filled;
> @@ -668,6 +671,7 @@ struct station_info {
>  	size_t assoc_req_ies_len;
>  
>  	u32 beacon_loss_count;
> +	s64 t_offset;
>  
>  	/*
>  	 * Note: Add a new enum station_info_flags value for each new field and
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 677d659..75a5bcd 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -412,6 +412,10 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
>  		sinfo->llid = le16_to_cpu(sta->llid);
>  		sinfo->plid = le16_to_cpu(sta->plid);
>  		sinfo->plink_state = sta->plink_state;
> +		if (test_sta_flag(sta, WLAN_STA_TOFFSET_KNOWN)) {
> +			sinfo->filled |= STATION_INFO_T_OFFSET;
> +			sinfo->t_offset = sta->t_offset;
> +		}
>  #endif
>  	}
>  


