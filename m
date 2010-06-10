Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:40814 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154Ab0FJELp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jun 2010 00:11:45 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 09 Jun 2010 21:11:45 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19472.26203.835523.525595@gargle.gargle.HOWL>
Date: Thu, 10 Jun 2010 09:43:15 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [RFC v2 06/22] mac80211: pull mgmt frame rx into rx handler
In-Reply-To: <20100609150454.085469240@sipsolutions.net>
References: <20100609150142.227469359@sipsolutions.net>
	<20100609150454.085469240@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> -ieee80211_rx_result
> -ieee80211_mesh_rx_mgmt(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
> -{
> -	struct ieee80211_local *local = sdata->local;
> -	struct ieee80211_mgmt *mgmt;
> -	u16 fc;
> -
> -	if (skb->len < 24)
> -		return RX_DROP_MONITOR;
> -
> -	mgmt = (struct ieee80211_mgmt *) skb->data;
> -	fc = le16_to_cpu(mgmt->frame_control);
> -
> -	switch (fc & IEEE80211_FCTL_STYPE) {
> -	case IEEE80211_STYPE_ACTION:
> -	case IEEE80211_STYPE_PROBE_RESP:
> -	case IEEE80211_STYPE_BEACON:
> -		skb_queue_tail(&sdata->skb_queue, skb);
> -		ieee80211_queue_work(&local->hw, &sdata->work);
> -		return RX_QUEUED;
> -	}
> -
> -	return RX_CONTINUE;

Am not familiar with mesh code, but this changes the semantics, no ?

> -	if (ieee80211_vif_is_mesh(&sdata->vif))
> -		return ieee80211_mesh_rx_mgmt(sdata, rx->skb);
> +	stype = mgmt->frame_control & cpu_to_le16(IEEE80211_FCTL_STYPE);
> +
> +	if (!ieee80211_vif_is_mesh(&sdata->vif) &&
> +	    sdata->vif.type != NL80211_IFTYPE_ADHOC &&
> +	    sdata->vif.type != NL80211_IFTYPE_STATION)
> +		return RX_DROP_MONITOR;
>  
> -	if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
> -		return ieee80211_ibss_rx_mgmt(sdata, rx->skb);
> +	switch (stype) {
> +	case cpu_to_le16(IEEE80211_STYPE_BEACON):
> +	case cpu_to_le16(IEEE80211_STYPE_PROBE_RESP):
> +		/* process for all: mesh, mlme, ibss */
> +		break;
> +	case cpu_to_le16(IEEE80211_STYPE_DEAUTH):
> +	case cpu_to_le16(IEEE80211_STYPE_DISASSOC):
> +		/* process only for station */
> +		if (sdata->vif.type != NL80211_IFTYPE_STATION)
> +			return RX_DROP_MONITOR;
> +		break;
> +	case cpu_to_le16(IEEE80211_STYPE_PROBE_REQ):
> +	case cpu_to_le16(IEEE80211_STYPE_AUTH):
> +		/* process only for ibss */
> +		if (sdata->vif.type != NL80211_IFTYPE_ADHOC)
> +			return RX_DROP_MONITOR;
> +		break;
> +	default:
> +		return RX_DROP_MONITOR;
> +	}
>  
> -	if (sdata->vif.type == NL80211_IFTYPE_STATION)
> -		return ieee80211_sta_rx_mgmt(sdata, rx->skb);
> +	/* queue up frame and kick off work to process it */
> +	skb_queue_tail(&sdata->skb_queue, rx->skb);
> +	ieee80211_queue_work(&rx->local->hw, &sdata->work);
>  
> -	return RX_DROP_MONITOR;
> +	return RX_QUEUED;
>  }

RX_QUEUED is the default return status for IBSS/Managed but mesh originally used RX_CONTINUE.
Wouldn't this change mesh mode's existing behavior ?

Sujith
