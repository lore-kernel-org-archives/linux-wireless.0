Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43536 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab0DMIOV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Apr 2010 04:14:21 -0400
Subject: Re: [PATCH] cfg80211: Avoid sending IWEVASSOCREQIE and
 IWEVASSOCRESPIE events with NULL event body
From: Johannes Berg <johannes@sipsolutions.net>
To: Nishant Sarmukadam <nishants@marvell.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1271145896-13377-1-git-send-email-nishants@marvell.com>
References: <1271145896-13377-1-git-send-email-nishants@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Apr 2010 10:14:12 +0200
Message-ID: <1271146452.4885.35.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-04-13 at 01:04 -0700, Nishant Sarmukadam wrote:
> In a scenario, where a cfg80211 driver (station mode) does not send
> assoc request and assoc response IEs in cfg80211_connect_result after
> a successful association to an AP, cfg80211 sends IWEVASSOCREQIE and
> IWEVASSOCRESPIE to the user space application with NULL data. This can
> cause an issue for the event recipient. An example of this is when cfg80211
> sends IWEVASSOCREQIE and IWEVASSOCRESPIE events with NULL event body to
> wpa_supplicant. The wpa_supplicant overwrites the assoc request and assoc response
> IEs for this station with NULL data. If the association is WPA/WPA2,
> then wpa_supplicant is not able to generate EAPOL handshake messages, since the IEs are NULL.
> This patch fixes the issue by not sending these events in case the event body is NULL.

I can agree with the patch, but I think the commit log needs to be more
explicit about why this is sufficient, since you never touch the event
sending code! Also, you should format in a way that's easier to read, I
think ...

johannes

> Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
> ---
>  net/wireless/sme.c |   16 ++++++++++------
>  1 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/net/wireless/sme.c b/net/wireless/sme.c
> index 17fde0d..396b8d3 100644
> --- a/net/wireless/sme.c
> +++ b/net/wireless/sme.c
> @@ -516,12 +516,16 @@ void cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
>  	ev->type = EVENT_CONNECT_RESULT;
>  	if (bssid)
>  		memcpy(ev->cr.bssid, bssid, ETH_ALEN);
> -	ev->cr.req_ie = ((u8 *)ev) + sizeof(*ev);
> -	ev->cr.req_ie_len = req_ie_len;
> -	memcpy((void *)ev->cr.req_ie, req_ie, req_ie_len);
> -	ev->cr.resp_ie = ((u8 *)ev) + sizeof(*ev) + req_ie_len;
> -	ev->cr.resp_ie_len = resp_ie_len;
> -	memcpy((void *)ev->cr.resp_ie, resp_ie, resp_ie_len);
> +	if (req_ie_len) {
> +		ev->cr.req_ie = ((u8 *)ev) + sizeof(*ev);
> +		ev->cr.req_ie_len = req_ie_len;
> +		memcpy((void *)ev->cr.req_ie, req_ie, req_ie_len);
> +	}
> +	if (resp_ie_len) {
> +		ev->cr.resp_ie = ((u8 *)ev) + sizeof(*ev) + req_ie_len;
> +		ev->cr.resp_ie_len = resp_ie_len;
> +		memcpy((void *)ev->cr.resp_ie, resp_ie, resp_ie_len);
> +	}
>  	ev->cr.status = status;
>  
>  	spin_lock_irqsave(&wdev->event_lock, flags);


