Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47378 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178Ab1J2JkS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Oct 2011 05:40:18 -0400
Received: by faan17 with SMTP id n17so4263910faa.19
        for <linux-wireless@vger.kernel.org>; Sat, 29 Oct 2011 02:40:17 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Thomas Pedersen <thomas@cozybit.com>
Subject: Re: [PATCH 2/4] mac80211: QoS multicast frames have No Ack policy
Date: Sat, 29 Oct 2011 11:40:11 +0200
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	johannes@sipsolutions.net, linville@tuxdriver.com
References: <1319864732-11286-1-git-send-email-thomas@cozybit.com> <1319864732-11286-2-git-send-email-thomas@cozybit.com>
In-Reply-To: <1319864732-11286-2-git-send-email-thomas@cozybit.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201110291140.12311.chunkeey@googlemail.com> (sfid-20111029_114022_477911_33A48182)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 29 October 2011 07:05:30 Thomas Pedersen wrote:
> Previously QoS multicast frames had the Normal Acknowledgment QoS
> control bits set. This would cause broadcast frames to be discarded by
> peers with which we have a BA session, since their sequence number would
> fall outside the allowed range. Set No Ack QoS control bits on multicast
> QoS frames and filter these in de-aggregation code.
> 
> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
> ---
>  net/mac80211/rx.c  |    8 +++++++-
>  net/mac80211/wme.c |    3 ++-
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index b867bd5..ee9e71b 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -747,7 +747,7 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx)
>  	struct sta_info *sta = rx->sta;
>  	struct tid_ampdu_rx *tid_agg_rx;
>  	u16 sc;
> -	int tid;
> +	u8 tid, ack_policy;
>  
>  	if (!ieee80211_is_data_qos(hdr->frame_control))
>  		goto dont_reorder;
> @@ -760,6 +760,7 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx)
>  	if (!sta)
>  		goto dont_reorder;
>  
> +	ack_policy = *ieee80211_get_qos_ctl(hdr) & ~IEEE80211_QOS_CTL_TID_MASK;
uh, while it might be a bit far fetched, but ack_policy might now clash with
frames that have set:

IEEE80211_QOS_CTL_EOSP (0x10)
IEEE80211_QOS_CTL_A_MSDU_PRESENT (0x80)
IEEE80211_QOS_CTL_MESH_CONTROL_PRESENT (0x100)

so I think we would be better of with something like:

(in include/linux/ieee80211.h)
#define IEEE80211_QOS_CTL_ACK_POLICY_MASK 0x0060

ack_policy = *ieee80211_get_qos_ctl(hdr) & ~IEEE80211_QOS_CTL_ACK_POLICY_MASK;

> @@ -770,6 +771,11 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx)
>  	if (unlikely(hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_NULLFUNC)))
>  		goto dont_reorder;
>  
> +	/* not part of a BA session */
> +	if (!((ack_policy == IEEE80211_QOS_CTL_ACK_POLICY_BLOCKACK) ||
> +	      (ack_policy == IEEE80211_QOS_CTL_ACK_POLICY_NORMAL)))
> +		goto dont_reorder;
> +

Regards,
	Chr
