Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34332 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab0FJG2M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jun 2010 02:28:12 -0400
Subject: Re: [RFC v2 06/22] mac80211: pull mgmt frame rx into rx handler
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <19472.26203.835523.525595@gargle.gargle.HOWL>
References: <20100609150142.227469359@sipsolutions.net>
	 <20100609150454.085469240@sipsolutions.net>
	 <19472.26203.835523.525595@gargle.gargle.HOWL>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Jun 2010 08:28:08 +0200
Message-ID: <1276151288.3623.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-06-10 at 09:43 +0530, Sujith wrote:
> Johannes Berg wrote:
> > -ieee80211_rx_result
> > -ieee80211_mesh_rx_mgmt(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
> > -{
> > -	struct ieee80211_local *local = sdata->local;
> > -	struct ieee80211_mgmt *mgmt;
> > -	u16 fc;
> > -
> > -	if (skb->len < 24)
> > -		return RX_DROP_MONITOR;
> > -
> > -	mgmt = (struct ieee80211_mgmt *) skb->data;
> > -	fc = le16_to_cpu(mgmt->frame_control);
> > -
> > -	switch (fc & IEEE80211_FCTL_STYPE) {
> > -	case IEEE80211_STYPE_ACTION:
> > -	case IEEE80211_STYPE_PROBE_RESP:
> > -	case IEEE80211_STYPE_BEACON:
> > -		skb_queue_tail(&sdata->skb_queue, skb);
> > -		ieee80211_queue_work(&local->hw, &sdata->work);
> > -		return RX_QUEUED;
> > -	}
> > -
> > -	return RX_CONTINUE;
> 
> Am not familiar with mesh code, but this changes the semantics, no ?
> 
> > -	if (ieee80211_vif_is_mesh(&sdata->vif))
> > -		return ieee80211_mesh_rx_mgmt(sdata, rx->skb);
> > +	stype = mgmt->frame_control & cpu_to_le16(IEEE80211_FCTL_STYPE);
> > +
> > +	if (!ieee80211_vif_is_mesh(&sdata->vif) &&
> > +	    sdata->vif.type != NL80211_IFTYPE_ADHOC &&
> > +	    sdata->vif.type != NL80211_IFTYPE_STATION)
> > +		return RX_DROP_MONITOR;
> >  
> > -	if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
> > -		return ieee80211_ibss_rx_mgmt(sdata, rx->skb);
> > +	switch (stype) {
> > +	case cpu_to_le16(IEEE80211_STYPE_BEACON):
> > +	case cpu_to_le16(IEEE80211_STYPE_PROBE_RESP):
> > +		/* process for all: mesh, mlme, ibss */
> > +		break;
> > +	case cpu_to_le16(IEEE80211_STYPE_DEAUTH):
> > +	case cpu_to_le16(IEEE80211_STYPE_DISASSOC):
> > +		/* process only for station */
> > +		if (sdata->vif.type != NL80211_IFTYPE_STATION)
> > +			return RX_DROP_MONITOR;
> > +		break;
> > +	case cpu_to_le16(IEEE80211_STYPE_PROBE_REQ):
> > +	case cpu_to_le16(IEEE80211_STYPE_AUTH):
> > +		/* process only for ibss */
> > +		if (sdata->vif.type != NL80211_IFTYPE_ADHOC)
> > +			return RX_DROP_MONITOR;
> > +		break;
> > +	default:
> > +		return RX_DROP_MONITOR;
> > +	}
> >  
> > -	if (sdata->vif.type == NL80211_IFTYPE_STATION)
> > -		return ieee80211_sta_rx_mgmt(sdata, rx->skb);
> > +	/* queue up frame and kick off work to process it */
> > +	skb_queue_tail(&sdata->skb_queue, rx->skb);
> > +	ieee80211_queue_work(&rx->local->hw, &sdata->work);
> >  
> > -	return RX_DROP_MONITOR;
> > +	return RX_QUEUED;
> >  }
> 
> RX_QUEUED is the default return status for IBSS/Managed but mesh
> originally used RX_CONTINUE.

Mesh also used (and needed to!) RX_QUEUED for the case where it actually
wanted the packet. I just wrote the code the other way around -- before
it was returning RX_QUEUED if wanted, now it short-cuts to
"RX_DROP_MONITOR" if unwanted.

> Wouldn't this change mesh mode's existing behavior ?

No, I don't think it does, in ieee80211_rx_h_mgmt() RX_CONTINUE and
RX_DROP_MONITOR are equivalent since that's the last possible thing to
happen with a (management) frame. Unless I'm misunderstanding you?

johannes

