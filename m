Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38363 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934714Ab3FSTaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 15:30:12 -0400
Date: Wed, 19 Jun 2013 15:27:14 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Antonio Quartulli <ordex@autistici.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: Re: [PATCH mac80211-next] brcm80211: fix null pointer access
Message-ID: <20130619192714.GF12079@tuxdriver.com> (sfid-20130619_213016_984074_3B8D462C)
References: <1371641731-1297-1-git-send-email-ordex@autistici.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1371641731-1297-1-git-send-email-ordex@autistici.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

FWIW, driver fixes like this come to me rather than Johannes...

On Wed, Jun 19, 2013 at 01:35:31PM +0200, Antonio Quartulli wrote:
> From: Antonio Quartulli <antonio@open-mesh.com>
> 
> Do not unconditionally access the chan variable in
> brcmf_cfg80211_mgmt_tx() as it may be NULL.
> Use freq instead.
> 
> Introduced by c2ff8cad64233b539c71a27e2a6e324001143ef0
> ("brcm80211: make mgmt_tx in brcmfmac accept a NULL channel")
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
> ---
>  drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
> index 8bd256b..d316d62 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
> @@ -3985,8 +3985,7 @@ brcmf_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
>  		       le16_to_cpu(action_frame->len));
>  
>  		brcmf_dbg(TRACE, "Action frame, cookie=%lld, len=%d, freq=%d\n",
> -			  *cookie, le16_to_cpu(action_frame->len),
> -			  chan->center_freq);
> +			  *cookie, le16_to_cpu(action_frame->len), freq);
>  
>  		ack = brcmf_p2p_send_action_frame(cfg, cfg_to_ndev(cfg),
>  						  af_params);
> -- 
> 1.8.1.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
