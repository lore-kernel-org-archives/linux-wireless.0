Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45928 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab1IWKWH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Sep 2011 06:22:07 -0400
Subject: Re: [RFC 2/2] mac80211: Send the management frame at requested rate
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni@qca.qualcomm.com>
In-Reply-To: <1316703516-24216-2-git-send-email-rmanohar@qca.qualcomm.com>
References: <1316703516-24216-1-git-send-email-rmanohar@qca.qualcomm.com>
	 <1316703516-24216-2-git-send-email-rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Sep 2011 12:22:04 +0200
Message-ID: <1316773324.4058.2.camel@jlt3.sipsolutions.net> (sfid-20110923_122212_939998_57596E54)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-22 at 20:28 +0530, Rajkumar Manoharan wrote:

> +++ b/net/mac80211/tx.c
> @@ -639,6 +639,11 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
>  		txrc.rts = rts = true;
>  	}
>  
> +	if (ieee80211_is_probe_req(hdr->frame_control) &&
> +	    tx->sdata->local->scan_req &&
> +	    tx->sdata->local->scan_req->no_cck)
> +		info->flags |= IEEE80211_TX_CTL_NO_CCK_RATE;
> +

I think this would make more sense in ieee80211_send_probe_req() rather
than here where it'll be executed for every frame.

johannes

