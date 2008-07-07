Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:50332 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbYGGQXj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2008 12:23:39 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2173354wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jul 2008 09:23:39 -0700 (PDT)
Subject: Re: [PATCH 1/1 V2] mac80211: Fix ieee80211_rx_reorder_ampdu:
	ignore QoS null packets
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <1215434881-5410-1-git-send-email-tomas.winkler@intel.com>
References: <1215434881-5410-1-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain
Date: Mon, 07 Jul 2008 09:23:44 -0700
Message-Id: <1215447824.14247.2.camel@brick> (sfid-20080707_182343_781313_1B88BA63)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-07-07 at 15:48 +0300, Tomas Winkler wrote:
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> 
> This patch fixes the check at the entrance to ieee80211_rx_reorder_ampdu.
> This check has been broken by 511fe3f3c4ba0b5b77421336f64a19b6cd00e65f
> 'mac80211: rx.c use new helpers'
> 
Actually, do we want something like this instead:

> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index 6a88e8f..a6e8214 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -2052,7 +2052,7 @@ static u8 ieee80211_rx_reorder_ampdu(struct ieee80211_local *local,
>  	tid_agg_rx = sta->ampdu_mlme.tid_rx[tid];
>  
>  	/* null data frames are excluded */
> -	if (unlikely(ieee80211_is_nullfunc(hdr->frame_control)))
> +	if (unlikely(ieee80211_is_qos_nullfunc(hdr->frame_control)))
>  		goto end_reorder;
>  
>  	/* new un-ordered ampdu frame - process it */

	if (unlikely(ieee80211_is_data(hdr->frame_control) && (hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_NULLFUNC))))

Or wrap the above in a ieee80211_is_data_has_nullfunc() helper?

Cheers,

Harvey


