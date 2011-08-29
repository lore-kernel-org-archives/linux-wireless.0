Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47488 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429Ab1H2NcJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 09:32:09 -0400
Subject: Re: [PATCH v3 2/2] mac80211: fix race condition between assoc_done
 and first EAP packet
From: Johannes Berg <johannes@sipsolutions.net>
To: Guy Eilam <guy@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1313583495-9695-2-git-send-email-guy@wizery.com> (sfid-20110817_142226_610504_EC40B744)
References: <1313583495-9695-1-git-send-email-guy@wizery.com>
	 <1313583495-9695-2-git-send-email-guy@wizery.com>
	 (sfid-20110817_142226_610504_EC40B744)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Aug 2011 15:32:06 +0200
Message-ID: <1314624726.8959.8.camel@jlt3.sipsolutions.net> (sfid-20110829_153213_804071_6C363C4F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-08-17 at 15:18 +0300, Guy Eilam wrote:

> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -850,8 +850,21 @@ ieee80211_rx_h_check(struct ieee80211_rx_data *rx)
>  		      ieee80211_is_pspoll(hdr->frame_control)) &&
>  		     rx->sdata->vif.type != NL80211_IFTYPE_ADHOC &&
>  		     rx->sdata->vif.type != NL80211_IFTYPE_WDS &&
> -		     (!rx->sta || !test_sta_flags(rx->sta, WLAN_STA_ASSOC))))
> +		     (!rx->sta || !test_sta_flags(rx->sta, WLAN_STA_ASSOC)))) {
> +		if (rx->sta && rx->sta->dummy &&
> +		    ieee80211_is_data_present(hdr->frame_control)) {
> +			u16 ethertype;
> +			u8 *payload;
> +
> +			payload = rx->skb->data +
> +				ieee80211_hdrlen(hdr->frame_control);
> +			ethertype = (payload[6] << 8) | payload[7];
> +			if (cpu_to_be16(ethertype) ==
> +			    rx->sdata->control_port_protocol)
> +				return RX_CONTINUE;
> +		}
>  		return RX_DROP_MONITOR;
> +	}

It might be easier to read to split the outer condition now into
data/ps-poll?

Anyway, didn't pay attention if this got applied -- seems fine.
 
johannes

