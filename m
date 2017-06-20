Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-co1nam03on0054.outbound.protection.outlook.com ([104.47.40.54]:45408
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752479AbdFTV6I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Jun 2017 17:58:08 -0400
From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: Re: [PATCH] mac80211: don't look at the PM bit of BAR frames
To: emmanuel.grumbach@intel.com,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <20170608110049.8747-1-emmanuel.grumbach@intel.com>
Message-ID: <5d0d7ce8-ff71-7b37-012d-2db75da49d9d@quantenna.com> (sfid-20170620_235817_452113_F991B52D)
Date: Tue, 20 Jun 2017 14:57:57 -0700
MIME-Version: 1.0
In-Reply-To: <20170608110049.8747-1-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/08/2017 04:00 AM, Emmanuel Grumbach wrote:
> When a peer sends a BAR frame with PM bit clear, we should
> not modify its PM state as madated by the spec in
> 802.11-20012 10.2.1.2.
> 
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>   net/mac80211/rx.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index e48724a6725e..bb1e4bbf55e2 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -1558,12 +1558,16 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
>   	 */
>   	if (!ieee80211_hw_check(&sta->local->hw, AP_LINK_PS) &&
>   	    !ieee80211_has_morefrags(hdr->frame_control) &&
> +	    !ieee80211_is_back_req(hdr->frame_control) &&

BTW latest spec also notes that PSPOLL frame has PM bit reserved too, 
because it may not result in ACK frame from AP.

>   	    !(status->rx_flags & IEEE80211_RX_DEFERRED_RELEASE) &&
>   	    (rx->sdata->vif.type == NL80211_IFTYPE_AP ||
>   	     rx->sdata->vif.type == NL80211_IFTYPE_AP_VLAN) &&
> -	    /* PM bit is only checked in frames where it isn't reserved,
> +	    /*
> +	     * PM bit is only checked in frames where it isn't reserved,
>   	     * in AP mode it's reserved in non-bufferable management frames
>   	     * (cf. IEEE 802.11-2012 8.2.4.1.7 Power Management field)
> +	     * BAR frames should be ignored as specified in
> +	     * IEEE 802.11-2012 10.2.1.2.

Comment placement is a little confusing IMO. Maybe move 
ieee80211_is_back_req() check to this position?

>   	     */
>   	    (!ieee80211_is_mgmt(hdr->frame_control) ||
>   	     ieee80211_is_bufferable_mmpdu(hdr->frame_control))) {
> 
