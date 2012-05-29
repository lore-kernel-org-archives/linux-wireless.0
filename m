Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50258 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662Ab2E2HEz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 03:04:55 -0400
Message-ID: <1338275092.4342.14.camel@jlt3.sipsolutions.net> (sfid-20120529_090459_178216_19E366B4)
Subject: Re: [PATCH] mac80211: fix flag check for QoS NOACK frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Claudio Pisa <claudio.pisa@uniroma2.it>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Tue, 29 May 2012 09:04:52 +0200
In-Reply-To: <1338206785-3222-1-git-send-email-claudio.pisa@uniroma2.it>
References: <1338206785-3222-1-git-send-email-claudio.pisa@uniroma2.it>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-05-28 at 13:06 +0100, Claudio Pisa wrote:
> Signed-off-by: Claudio Pisa <claudio.pisa@uniroma2.it>
> ---
>  net/mac80211/tx.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index d67d36f..cb17497 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -153,7 +153,7 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
>  
>  	/* Don't calculate ACKs for QoS Frames with NoAck Policy set */
>  	if (ieee80211_is_data_qos(hdr->frame_control) &&
> -	    *(ieee80211_get_qos_ctl(hdr)) | IEEE80211_QOS_CTL_ACK_POLICY_NOACK)
> +	    *(ieee80211_get_qos_ctl(hdr)) & IEEE80211_QOS_CTL_ACK_POLICY_NOACK)

Looks right to me, I guess nobody cares about duration calculations
after all. How did you find this?!

johannes

