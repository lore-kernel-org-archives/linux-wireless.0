Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35282 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab1KDO5d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 10:57:33 -0400
Subject: Re: mac80211: UAPSD - seems MORE_DATA bit is not set in all cases
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAFED-jmnK5qKG6pMUHC__8CnoJwaBoihV_U5p-JoyAH6VW1rNw@mail.gmail.com> (sfid-20111104_155008_011111_90F925A7)
References: <CAFED-jmnK5qKG6pMUHC__8CnoJwaBoihV_U5p-JoyAH6VW1rNw@mail.gmail.com>
	 (sfid-20111104_155008_011111_90F925A7)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Nov 2011 15:57:29 +0100
Message-ID: <1320418649.3969.93.camel@jlt3.sipsolutions.net> (sfid-20111104_155736_748764_822A18A3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-11-04 at 15:49 +0100, Janusz Dziedzic wrote:
> Hello,
> 
> Seems we don't set MORE_DATA bit correctly in
> ieee80211_sta_ps_deliver_response() fuction.
> In case we have more than one frame in struct sk_buff_head frames we
> don't set MORE_DATA bit.
> 
> Proposed fix:
> diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
> index ce962d2..8eaa746 100644
> --- a/net/mac80211/sta_info.c
> +++ b/net/mac80211/sta_info.c
> @@ -1354,12 +1354,12 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
>                          * Use MoreData flag to indicate whether there are
>                          * more buffered frames for this STA
>                          */
> -                       if (!more_data)
> -                               hdr->frame_control &=
> -                                       cpu_to_le16(~IEEE80211_FCTL_MOREDATA);
> -                       else
> +                       if (more_data || !skb_queue_empty(&frames))
>                                 hdr->frame_control |=
>                                         cpu_to_le16(IEEE80211_FCTL_MOREDATA);
> +                       else
> +                               hdr->frame_control &=
> +                                       cpu_to_le16(~IEEE80211_FCTL_MOREDATA);
> 
>                         if (ieee80211_is_data_qos(hdr->frame_control) ||
>                             ieee80211_is_qos_nullfunc(hdr->frame_control))
> 

Yeah that seems reasonable. Please submit a proper patch :-)

johannes

