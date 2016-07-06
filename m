Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40277 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbcGFMmn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 08:42:43 -0400
Message-ID: <1467808954.5460.6.camel@sipsolutions.net> (sfid-20160706_144245_868578_E2DD071B)
Subject: Re: [PATCH v2] cfg80211: Add mesh peer AID setting API
From: Johannes Berg <johannes@sipsolutions.net>
To: Masashi Honma <masashi.honma@gmail.com>
Cc: linux-wireless@vger.kernel.org, j@w1.fi, me@bobcopeland.com
Date: Wed, 06 Jul 2016 14:42:34 +0200
In-Reply-To: <1467335974-2802-1-git-send-email-masashi.honma@gmail.com> (sfid-20160701_031947_889703_68F66C0A)
References: <1467277258-2331-1-git-send-email-masashi.honma@gmail.com>
	 <1467335974-2802-1-git-send-email-masashi.honma@gmail.com>
	 (sfid-20160701_031947_889703_68F66C0A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-07-01 at 10:19 +0900, Masashi Honma wrote:
> Previously, mesh power management functionality works only with
> kernel
> MPM. Because user space MPM did not report mesh peer AID to kernel,
> the kernel could not identify the bit in TIM element. So this patch
> adds mesh peer AID setting API.
> 
> Signed-off-by: Masashi Honma <masashi.honma@gmail.com>
> ---
>  include/net/cfg80211.h       | 2 ++
>  include/uapi/linux/nl80211.h | 5 +++++
>  net/mac80211/cfg.c           | 1 +
>  net/wireless/nl80211.c       | 7 +++++++
>  4 files changed, 15 insertions(+)
> 
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 7bbb00d..23e34ca 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -774,6 +774,7 @@ enum station_parameters_apply_mask {
>   *	(bitmask of BIT(NL80211_STA_FLAG_...))
>   * @listen_interval: listen interval or -1 for no change
>   * @aid: AID or zero for no change
> + * @peer_aid: mesh peer AID or zero for no change
>   * @plink_action: plink action to take
>   * @plink_state: set the peer link state for a station
>   * @ht_capa: HT capabilities of station
> @@ -805,6 +806,7 @@ struct station_parameters {
>  	u32 sta_modify_mask;
>  	int listen_interval;
>  	u16 aid;
> +	u16 peer_aid;
>  	u8 supported_rates_len;
>  	u8 plink_action;
>  	u8 plink_state;
> diff --git a/include/uapi/linux/nl80211.h
> b/include/uapi/linux/nl80211.h
> index 53c8278..f8c454e 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -1829,6 +1829,9 @@ enum nl80211_commands {
>   *	%NL80211_ATTR_EXT_CAPA_MASK, to specify the extended
> capabilities per
>   *	interface type.
>   *
> + * @NL80211_ATTR_MESH_PEER_AID: Association ID for the mesh peer
> (u16). This is
> + *	used to pull the stored data for mesh peer in power save
> state.
> 
Why does this need new API all over?

It seems to me that it could just use the regular NL80211_ATTR_STA_AID
attribute, and the cfg80211 code would already be in place, and you'd
just need to add a single line to mac80211 and
to cfg80211_check_station_change() to accept that.

johannes
