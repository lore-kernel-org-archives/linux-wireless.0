Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:45947 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbYLIUos (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 15:44:48 -0500
Received: by ewy10 with SMTP id 10so202727ewy.13
        for <linux-wireless@vger.kernel.org>; Tue, 09 Dec 2008 12:44:46 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: remove fragmentation offload functionality
Date: Tue, 9 Dec 2008 21:36:56 +0100
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	Dan E <trg_info@mailhaven.com>
References: <1228822203.22164.204.camel@johannes.berg>
In-Reply-To: <1228822203.22164.204.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200812092136.56768.IvDoorn@gmail.com> (sfid-20081209_214453_063855_60CE19F7)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 09 December 2008, Johannes Berg wrote:
> There's no driver that actually does fragmentation on the
> device, and the callback is buggy (when it returns an error,
> mac80211's fragmentation status is changed so reading the
> frag threshold from userspace reads the new value despite
> the error). Let's just remove it, if we really find some
> hardware supporting it we can add it back later.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> Unless anybody knows a work-in-progress driver that needs this, in which
> case we should fix it? Speak up now if you do.

For rt2800{pci,usb} the set_frag_threshold is not implemented, so it won't
provide problems with those drivers.

Ivo

>  include/net/mac80211.h |    5 -----
>  net/mac80211/tx.c      |    1 -
>  net/mac80211/wext.c    |    8 --------
>  3 files changed, 14 deletions(-)
> 
> --- everything.orig/include/net/mac80211.h	2008-12-08 21:54:08.000000000 +0100
> +++ everything/include/net/mac80211.h	2008-12-08 21:54:21.000000000 +0100
> @@ -1253,10 +1253,6 @@ enum ieee80211_ampdu_mlme_action {
>   *
>   * @set_rts_threshold: Configuration of RTS threshold (if device needs it)
>   *
> - * @set_frag_threshold: Configuration of fragmentation threshold. Assign this if
> - *	the device does fragmentation by itself; if this method is assigned then
> - *	the stack will not do fragmentation.
> - *
>   * @sta_notify: Notifies low level driver about addition or removal of an
>   *	associated station, AP, IBSS/WDS/mesh peer etc. Must be atomic.
>   *
> @@ -1326,7 +1322,6 @@ struct ieee80211_ops {
>  	void (*get_tkip_seq)(struct ieee80211_hw *hw, u8 hw_key_idx,
>  			     u32 *iv32, u16 *iv16);
>  	int (*set_rts_threshold)(struct ieee80211_hw *hw, u32 value);
> -	int (*set_frag_threshold)(struct ieee80211_hw *hw, u32 value);
>  	void (*sta_notify)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
>  			enum sta_notify_cmd, struct ieee80211_sta *sta);
>  	void (*sta_notify_ps)(struct ieee80211_hw *hw,
> --- everything.orig/net/mac80211/tx.c	2008-12-08 21:52:57.000000000 +0100
> +++ everything/net/mac80211/tx.c	2008-12-08 21:54:21.000000000 +0100
> @@ -1003,7 +1003,6 @@ __ieee80211_tx_prepare(struct ieee80211_
>  	if (tx->flags & IEEE80211_TX_FRAGMENTED) {
>  		if ((tx->flags & IEEE80211_TX_UNICAST) &&
>  		    skb->len + FCS_LEN > local->fragmentation_threshold &&
> -		    !local->ops->set_frag_threshold &&
>  		    !(info->flags & IEEE80211_TX_CTL_AMPDU))
>  			tx->flags |= IEEE80211_TX_FRAGMENTED;
>  		else
> --- everything.orig/net/mac80211/wext.c	2008-12-08 21:52:57.000000000 +0100
> +++ everything/net/mac80211/wext.c	2008-12-08 21:54:21.000000000 +0100
> @@ -639,14 +639,6 @@ static int ieee80211_ioctl_siwfrag(struc
>  		local->fragmentation_threshold = frag->value & ~0x1;
>  	}
>  
> -	/* If the wlan card performs fragmentation in hardware/firmware,
> -	 * configure it here */
> -
> -	if (local->ops->set_frag_threshold)
> -		return local->ops->set_frag_threshold(
> -			local_to_hw(local),
> -			local->fragmentation_threshold);
> -
>  	return 0;
>  }
>  
> 
> 
> 


