Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:40820 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556Ab0FJEMq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jun 2010 00:12:46 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 09 Jun 2010 21:12:46 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19472.26264.654635.201393@gargle.gargle.HOWL>
Date: Thu, 10 Jun 2010 09:44:16 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [RFC v2 07/22] mac80211: always process blockack action from
 workqueue
In-Reply-To: <20100609150454.273811480@sipsolutions.net>
References: <20100609150142.227469359@sipsolutions.net>
	<20100609150454.273811480@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
>  		switch (mgmt->u.action.u.addba_req.action_code) {
>  		case WLAN_ACTION_ADDBA_REQ:
>  			if (len < (IEEE80211_MIN_ACTION_SIZE +
>  				   sizeof(mgmt->u.action.u.addba_req)))
> -				return RX_DROP_MONITOR;
> -			ieee80211_process_addba_request(local, rx->sta, mgmt, len);
> -			goto handled;
> +				goto invalid;
> +			break;
>  		case WLAN_ACTION_ADDBA_RESP:
>  			if (len < (IEEE80211_MIN_ACTION_SIZE +
>  				   sizeof(mgmt->u.action.u.addba_resp)))
> -				break;
> -			ieee80211_process_addba_resp(local, rx->sta, mgmt, len);
> -			goto handled;
> +				goto invalid;
> +			break;
>  		case WLAN_ACTION_DELBA:
>  			if (len < (IEEE80211_MIN_ACTION_SIZE +
>  				   sizeof(mgmt->u.action.u.delba)))
> -				break;
> -			ieee80211_process_delba(sdata, rx->sta, mgmt, len);
> -			goto handled;
> +				goto invalid;
> +			break;
> +		default:
> +			goto invalid;
>  		}

rx->sta->rx_packets is no longer incremented for valid action frames,
since we return immediately after queuing to sdata.

Sujith
