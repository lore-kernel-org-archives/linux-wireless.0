Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46888 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932798Ab2CZQJl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 12:09:41 -0400
Message-ID: <1332778177.5435.45.camel@jlt3.sipsolutions.net> (sfid-20120326_180943_523083_5648A7F1)
Subject: Re: [PATCH 2/2] mac80211: fix oper channel timestamp updation
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <Helmut.Schaa@gmx.de>
Date: Mon, 26 Mar 2012 18:09:37 +0200
In-Reply-To: <1332775418-16865-2-git-send-email-rmanohar@qca.qualcomm.com>
References: <1332775418-16865-1-git-send-email-rmanohar@qca.qualcomm.com>
	 <1332775418-16865-2-git-send-email-rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-03-26 at 20:53 +0530, Rajkumar Manoharan wrote:
> At the start of scan, mac80211 stop all vif transmission and inform the
> AP that the station is leaving the operating channel. But it is not
> updating the leave_oper_channel timestamp. As the result, the scan
> decision always set operating channel at the scan start when the listen
> interval is reduced.

Could use a better description, but seems OK, Helmut?

johannes

> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> ---
>  net/mac80211/scan.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
> index 33cd169..c70e176 100644
> --- a/net/mac80211/scan.c
> +++ b/net/mac80211/scan.c
> @@ -370,7 +370,7 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
>  	 */
>  	drv_sw_scan_start(local);
>  
> -	local->leave_oper_channel_time = 0;
> +	local->leave_oper_channel_time = jiffies;
>  	local->next_scan_state = SCAN_DECISION;
>  	local->scan_channel_idx = 0;
>  


