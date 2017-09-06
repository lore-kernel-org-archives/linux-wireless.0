Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:33392 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753326AbdIFM0e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Sep 2017 08:26:34 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] mac80211: always update the PM state of a peer on MGMT
 / DATA frames
Date: Wed, 6 Sep 2017 12:26:29 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB3FF7DB582@HASMSX112.ger.corp.intel.com> (sfid-20170906_142643_622178_802F7F20)
References: <20170906122523.17333-1-emmanuel.grumbach@intel.com>
In-Reply-To: <20170906122523.17333-1-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> The 2016 version of the spec is more generic about when the AP should
> update the power management state of the peer:
> the AP shall update the state based on any management or data frames. This
> means that even non-bufferable management frames should be looked at to
> update to maintain the power management state of the peer.
> 
> This can avoid problematic cases for example if a station disappears while
> being asleep and then re-appears. The AP would remember it as in power
> save, but the Authentication frame couldn't be used to set the peer as
> awake again.
> Note that this issues wasn't really critical since at some point (after the
> association) we would have removed the station and created another one
> with all the states cleared.
> 
> type=feature
> ticket=none
> 
> Change-Id: Iae1fbbd502d64f0c31db3e0f2d81224b29acb5af

Looks like I forgot to remove a few things here :)
And to put this as an RFC..

> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---
>  net/mac80211/rx.c | 17 +++++------------
>  1 file changed, 5 insertions(+), 12 deletions(-)
> 
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c index
> fdf616811865..89db6b11af8a 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -1749,23 +1749,16 @@ ieee80211_rx_h_sta_process(struct
> ieee80211_rx_data *rx)
> 
>  	/*
>  	 * Change STA power saving mode only at the end of a frame
> -	 * exchange sequence.
> +	 * exchange sequence, and only for a data or management
> +	 * frame as specified in ieee80211-2016 11.2.3.2
>  	 */
>  	if (!ieee80211_hw_check(&sta->local->hw, AP_LINK_PS) &&
>  	    !ieee80211_has_morefrags(hdr->frame_control) &&
> -	    !ieee80211_is_back_req(hdr->frame_control) &&
> +	    (ieee80211_is_mgmt(hdr->frame_control) ||
> +	     ieee80211_is_data(hdr->frame_control)) &&
>  	    !(status->rx_flags & IEEE80211_RX_DEFERRED_RELEASE) &&
>  	    (rx->sdata->vif.type == NL80211_IFTYPE_AP ||
> -	     rx->sdata->vif.type == NL80211_IFTYPE_AP_VLAN) &&
> -	    /*
> -	     * PM bit is only checked in frames where it isn't reserved,
> -	     * in AP mode it's reserved in non-bufferable management frames
> -	     * (cf. IEEE 802.11-2012 8.2.4.1.7 Power Management field)
> -	     * BAR frames should be ignored as specified in
> -	     * IEEE 802.11-2012 10.2.1.2.
> -	     */
> -	    (!ieee80211_is_mgmt(hdr->frame_control) ||
> -	     ieee80211_is_bufferable_mmpdu(hdr->frame_control))) {
> +	     rx->sdata->vif.type == NL80211_IFTYPE_AP_VLAN)) {
>  		if (test_sta_flag(sta, WLAN_STA_PS_STA)) {
>  			if (!ieee80211_has_pm(hdr->frame_control))
>  				sta_ps_end(sta);
> --
> 2.9.3
