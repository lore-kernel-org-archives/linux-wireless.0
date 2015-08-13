Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46980 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892AbbHMJJT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 05:09:19 -0400
Message-ID: <1439456956.2114.8.camel@sipsolutions.net> (sfid-20150813_110943_152676_58A412B6)
Subject: Re: [PATCH] mac80211: Fix oops in OCB mode when receiving data when
 not joined
From: Johannes Berg <johannes@sipsolutions.net>
To: Bertold Van den Bergh <bertold.vandenbergh@esat.kuleuven.be>,
	linux-wireless@vger.kernel.org
Date: Thu, 13 Aug 2015 11:09:16 +0200
In-Reply-To: <1438781899-600-1-git-send-email-bertold.vandenbergh@esat.kuleuven.be>
References: <1438781899-600-1-git-send-email-bertold.vandenbergh@esat.kuleuven.be>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-08-05 at 15:38 +0200, Bertold Van den Bergh wrote:
> The current implementation in ocb.c can cause a kernel oops when the
> interface is up, but no ocb has been joined. When data is received
> with the broadcast BSSID rx_no_sta is called. This function uses
> uninitialized variables because the join function has not yet been 
> used.
> 
> Signed-off-by: Bertold Van den Bergh <
> bertold.vandenbergh@esat.kuleuven.be>
> ---
>  net/mac80211/ocb.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/mac80211/ocb.c b/net/mac80211/ocb.c
> index 573b81a..5da2bd3 100644
> --- a/net/mac80211/ocb.c
> +++ b/net/mac80211/ocb.c
> @@ -50,6 +50,9 @@ void ieee80211_ocb_rx_no_sta(struct 
> ieee80211_sub_if_data *sdata,
>  	struct sta_info *sta;
>  	int band;
>  
> +	if (!ifocb->joined)
> +		return;
> 
Wouldn't it make more sense to put this check into
ieee80211_accept_frame() and, in addition to not doing any station
processing, simply dropping the frame completely? Like such:

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3314,6 +3314,8 @@ static bool ieee80211_accept_frame(struct ieee80211_rx_data *rx)
 		}
 		return true;
 	case NL80211_IFTYPE_OCB:
+		if (!sdata->u.ocb.joined)
+			return false;
 		if (!bssid)
 			return false;
 		if (ieee80211_is_beacon(hdr->frame_control))

johannes
