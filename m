Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38146 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581AbcAEPfl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 10:35:41 -0500
Message-ID: <1452008139.12357.32.camel@sipsolutions.net> (sfid-20160105_163544_756258_CB978486)
Subject: Re: [PATCH] mac80211: Don't buffer non-bufferable MMPDUs
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 05 Jan 2016 16:35:39 +0100
In-Reply-To: <1452004632-20263-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20160105_153736_255867_4249A787)
References: <1452004632-20263-1-git-send-email-helmut.schaa@googlemail.com>
	 (sfid-20160105_153736_255867_4249A787)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-01-05 at 15:37 +0100, Helmut Schaa wrote:
> Non-bufferable MMPDUs are sent out to STAs even while in PS mode
> (for example probe responses). Applying filtered frame handling for
> these doesn't seem to make much sense and will only create more
> air utilization when the STA wakes up. Hence, apply filtered frame
> handling only for bufferable MMPDUs.
> 
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> ---
>  net/mac80211/status.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/net/mac80211/status.c b/net/mac80211/status.c
> index 5bad05e..14bd53b 100644
> --- a/net/mac80211/status.c
> +++ b/net/mac80211/status.c
> @@ -51,6 +51,12 @@ static void ieee80211_handle_filtered_frame(struct
> ieee80211_local *local,
>  	struct ieee80211_hdr *hdr = (void *)skb->data;
>  	int ac;
>  
> +	if (ieee80211_is_mgmt(hdr->frame_control) &&
> +	    !ieee80211_is_bufferable_mmpdu(hdr->frame_control)) {
> +		ieee80211_free_txskb(&local->hw, skb);
> +		return;
> +	}
> 
I don't really see a problem per se with this patch, but it seems that
we could just check the flags instead? Perhaps we simply shouldn't
apply buffering filtered frames here to frames that were already marked
with IEEE80211_TX_CTL_NO_PS_BUFFER, since those frames shouldn't be
filtered by the driver to start with.

That said, it obviously also points to a driver bug not treating these
frames correctly, so you might want to investigate why you got here to
start with!

johannes
