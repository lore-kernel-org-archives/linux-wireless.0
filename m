Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33506 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab0FJGZR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jun 2010 02:25:17 -0400
Subject: Re: [RFC v2 07/22] mac80211: always process blockack action from
 workqueue
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <19472.26264.654635.201393@gargle.gargle.HOWL>
References: <20100609150142.227469359@sipsolutions.net>
	 <20100609150454.273811480@sipsolutions.net>
	 <19472.26264.654635.201393@gargle.gargle.HOWL>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Jun 2010 08:25:14 +0200
Message-ID: <1276151114.3623.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-06-10 at 09:44 +0530, Sujith wrote:
> Johannes Berg wrote:
> >  		switch (mgmt->u.action.u.addba_req.action_code) {
> >  		case WLAN_ACTION_ADDBA_REQ:
> >  			if (len < (IEEE80211_MIN_ACTION_SIZE +
> >  				   sizeof(mgmt->u.action.u.addba_req)))
> > -				return RX_DROP_MONITOR;
> > -			ieee80211_process_addba_request(local, rx->sta, mgmt, len);
> > -			goto handled;
> > +				goto invalid;
> > +			break;
> >  		case WLAN_ACTION_ADDBA_RESP:
> >  			if (len < (IEEE80211_MIN_ACTION_SIZE +
> >  				   sizeof(mgmt->u.action.u.addba_resp)))
> > -				break;
> > -			ieee80211_process_addba_resp(local, rx->sta, mgmt, len);
> > -			goto handled;
> > +				goto invalid;
> > +			break;
> >  		case WLAN_ACTION_DELBA:
> >  			if (len < (IEEE80211_MIN_ACTION_SIZE +
> >  				   sizeof(mgmt->u.action.u.delba)))
> > -				break;
> > -			ieee80211_process_delba(sdata, rx->sta, mgmt, len);
> > -			goto handled;
> > +				goto invalid;
> > +			break;
> > +		default:
> > +			goto invalid;
> >  		}
> 
> rx->sta->rx_packets is no longer incremented for valid action frames,
> since we return immediately after queuing to sdata.

Good catch, I guess I broke that earlier and also with other frames that
are put onto the skb queue. I don't think I want to go back and fix it
so I'll go add a patch to the series that takes care of this for all the
possible cases.

johannes

