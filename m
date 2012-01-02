Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50047 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab2ABNx6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 08:53:58 -0500
Subject: Re: [RFC 2/2] mac80211: stop data transmission while probing AP
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1324134328-27503-2-git-send-email-rmanohar@qca.qualcomm.com>
References: <1324134328-27503-1-git-send-email-rmanohar@qca.qualcomm.com>
	 <1324134328-27503-2-git-send-email-rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Jan 2012 14:53:51 +0100
Message-ID: <1325512431.3643.11.camel@jlt3.sipsolutions.net> (sfid-20120102_145401_743518_95C4B122)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-12-17 at 20:35 +0530, Rajkumar Manoharan wrote:
> If the station is out of coverage of AP and it tries to probe the AP
> because of the beacon loss then there is not point in pushing the
> data from the higher layer. So lets suspend the data transmission
> till the probing succeeds.

We could argue about the idea,

> +	if (ifmgd->flags & IEEE80211_STA_BEACON_POLL)
> +		netif_tx_stop_all_queues(sdata->dev);
>  	/*
>  	 * When the hardware reports an accurate Tx ACK status, it's
>  	 * better to send a nullfunc frame instead of a probe request,
> @@ -1255,6 +1257,10 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
>  					 (u32) -1, true, false);
>  	}
>  
> +	if (ifmgd->flags & IEEE80211_STA_BEACON_POLL) {
> +		drv_flush(sdata->local, false);
> +		netif_tx_wake_all_queues(sdata->dev);
> +	}

but this implementation is completely bogus anyway. Think about what
this really does.

johannes

