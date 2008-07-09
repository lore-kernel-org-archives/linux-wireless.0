Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:42890 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419AbYGIMrn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 08:47:43 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH 3/6] b43legacy: use le16 frame control directly, avoid byteswapping
Date: Wed, 9 Jul 2008 14:47:15 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1215550043.476.41.camel@brick>
In-Reply-To: <1215550043.476.41.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807091447.15828.mb@bu3sch.de> (sfid-20080709_144753_629005_558F5106)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 08 July 2008 22:47:23 Harvey Harrison wrote:
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

ACK

> ---
>  drivers/net/wireless/b43legacy/xmit.c |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43legacy/xmit.c b/drivers/net/wireless/b43legacy/xmit.c
> index a354078..5e8a575 100644
> --- a/drivers/net/wireless/b43legacy/xmit.c
> +++ b/drivers/net/wireless/b43legacy/xmit.c
> @@ -193,7 +193,6 @@ static int generate_txhdr_fw3(struct b43legacy_wldev *dev,
>  {
>  	const struct ieee80211_hdr *wlhdr;
>  	int use_encryption = (!(info->flags & IEEE80211_TX_CTL_DO_NOT_ENCRYPT));
> -	u16 fctl;
>  	u8 rate;
>  	struct ieee80211_rate *rate_fb;
>  	int rate_ofdm;
> @@ -204,7 +203,6 @@ static int generate_txhdr_fw3(struct b43legacy_wldev *dev,
>  	struct ieee80211_rate *tx_rate;
>  
>  	wlhdr = (const struct ieee80211_hdr *)fragment_data;
> -	fctl = le16_to_cpu(wlhdr->frame_control);
>  
>  	memset(txhdr, 0, sizeof(*txhdr));
>  
> @@ -253,7 +251,7 @@ static int generate_txhdr_fw3(struct b43legacy_wldev *dev,
>  			mac_ctl |= (key->algorithm <<
>  				   B43legacy_TX4_MAC_KEYALG_SHIFT) &
>  				   B43legacy_TX4_MAC_KEYALG;
> -			wlhdr_len = ieee80211_get_hdrlen(fctl);
> +			wlhdr_len = ieee80211_hdrlen(wlhdr->frame_control);
>  			iv_len = min((size_t)info->control.iv_len,
>  				     ARRAY_SIZE(txhdr->iv));
>  			memcpy(txhdr->iv, ((u8 *)wlhdr) + wlhdr_len, iv_len);
> @@ -295,8 +293,7 @@ static int generate_txhdr_fw3(struct b43legacy_wldev *dev,
>  	/* MAC control */
>  	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
>  		mac_ctl |= B43legacy_TX4_MAC_ACK;
> -	if (!(((fctl & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL) &&
> -	      ((fctl & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PSPOLL)))
> +	if (!ieee80211_is_pspoll(wlhdr->frame_control))
>  		mac_ctl |= B43legacy_TX4_MAC_HWSEQ;
>  	if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
>  		mac_ctl |= B43legacy_TX4_MAC_STMSDU;



-- 
Greetings Michael.
