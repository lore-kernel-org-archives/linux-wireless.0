Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36530 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab2JALTp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Oct 2012 07:19:45 -0400
Message-ID: <1349090417.10330.27.camel@jlt4.sipsolutions.net> (sfid-20121001_131949_370288_997F4958)
Subject: Re: [PATCH v3] mac80211: VHT peer STA caps
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 01 Oct 2012 13:20:17 +0200
In-Reply-To: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCF6D5B@mbx022-e1-nj-10.exch022.domain.local>
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCF6D5B@mbx022-e1-nj-10.exch022.domain.local>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hm, seems I missed this before:

> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -498,6 +498,7 @@ enum station_parameters_apply_mask {
>   * @plink_action: plink action to take
>   * @plink_state: set the peer link state for a station
>   * @ht_capa: HT capabilities of station
> + * @vht_capa: VHT capabilities of station
>   * @uapsd_queues: bitmap of queues configured for uapsd. same format
>   *	as the AC bitmap in the QoS info field
>   * @max_sp: max Service Period. same format as the MAX_SP in the
> @@ -517,6 +518,7 @@ struct station_parameters {
>  	u8 plink_action;
>  	u8 plink_state;
>  	struct ieee80211_ht_cap *ht_capa;
> +	struct ieee80211_vht_cap *vht_capa;


I don't think this should be part of this particular patch? Shouldn't
there be a cfg80211/nl80211 patch to allow hostapd to set this
information when adding a station, like for HT, and then that patch
introduces this struct member?

> + * @vht_cap: VHT capabilities of this STA; Not restricting any capabilities
> + * 	of remote STA. Taking as is.

Thanks :)


> -			2 + sizeof(struct ieee80211_vht_capabilities) + /* VHT */
> +			2 + sizeof(struct ieee80211_vht_cap) + /* VHT */

Maybe all this renaming (and the ieee80211.h change) could be a separate
patch? Then this would be easier to read overall I think.


> +#include <linux/ieee80211.h>
> +#include <linux/export.h>

export.h isn't needed here (yet)

johannes

