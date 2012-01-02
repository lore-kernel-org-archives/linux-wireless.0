Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50071 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab2ABN4H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 08:56:07 -0500
Subject: Re: [RFC 1/2] mac80211: reset beacon monitor at tx ack notify
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1324134328-27503-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1324134328-27503-1-git-send-email-rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Jan 2012 14:55:15 +0100
Message-ID: <1325512515.3643.12.camel@jlt3.sipsolutions.net> (sfid-20120102_145609_963862_3A631FF3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-12-17 at 20:35 +0530, Rajkumar Manoharan wrote:
> This patch moves the beacon loss timer to future on receiving tx
> ack status from the associated AP. So that we can avoid unnecessary
> AP probing.
> 
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> ---
>  net/mac80211/mlme.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index a984f1f..65f1262 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -1209,8 +1209,10 @@ void ieee80211_sta_tx_notify(struct ieee80211_sub_if_data *sdata,
>  	if (!ieee80211_is_data(hdr->frame_control))
>  	    return;
>  
> -	if (ack)
> +	if (ack) {
>  		ieee80211_sta_reset_conn_monitor(sdata);
> +		ieee80211_sta_reset_beacon_monitor(sdata);
> +	}

This doesn't make a lot of sense. You can argue that beacon monitoring
isn't worthwhile, but side-stepping it completely when there's traffic
seems not what's intended as it is?

johannes

