Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51921 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab1KRQIn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 11:08:43 -0500
Subject: Re: [PATCH] mac80211: Fix endian bug in radiotap header generation
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1321632136-9398-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20111118_170256_838580_AF67C4F8)
References: <1321626702.10266.59.camel@jlt3.sipsolutions.net>
	 <1321632136-9398-1-git-send-email-helmut.schaa@googlemail.com>
	 (sfid-20111118_170256_838580_AF67C4F8)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 17:08:40 +0100
Message-ID: <1321632520.10266.66.camel@jlt3.sipsolutions.net> (sfid-20111118_170846_581212_37E6385E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-11-18 at 17:02 +0100, Helmut Schaa wrote:
> I intoduced this bug in commit a2fe81667410723d941a688e1958a49d67ca3346
> "mac80211: Build TX radiotap header dynamically"

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> ---
>  net/mac80211/status.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/mac80211/status.c b/net/mac80211/status.c
> index a9da6ee..46222ce 100644
> --- a/net/mac80211/status.c
> +++ b/net/mac80211/status.c
> @@ -260,7 +260,7 @@ static void ieee80211_add_tx_radiotap_header(struct ieee80211_supported_band
>  	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
>  	struct ieee80211_radiotap_header *rthdr;
>  	unsigned char *pos;
> -	__le16 txflags;
> +	u16 txflags;
>  
>  	rthdr = (struct ieee80211_radiotap_header *) skb_push(skb, rtap_len);
>  
> @@ -290,13 +290,13 @@ static void ieee80211_add_tx_radiotap_header(struct ieee80211_supported_band
>  	txflags = 0;
>  	if (!(info->flags & IEEE80211_TX_STAT_ACK) &&
>  	    !is_multicast_ether_addr(hdr->addr1))
> -		txflags |= cpu_to_le16(IEEE80211_RADIOTAP_F_TX_FAIL);
> +		txflags |= IEEE80211_RADIOTAP_F_TX_FAIL;
>  
>  	if ((info->status.rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS) ||
>  	    (info->status.rates[0].flags & IEEE80211_TX_RC_USE_CTS_PROTECT))
> -		txflags |= cpu_to_le16(IEEE80211_RADIOTAP_F_TX_CTS);
> +		txflags |= IEEE80211_RADIOTAP_F_TX_CTS;
>  	else if (info->status.rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS)
> -		txflags |= cpu_to_le16(IEEE80211_RADIOTAP_F_TX_RTS);
> +		txflags |= IEEE80211_RADIOTAP_F_TX_RTS;
>  
>  	put_unaligned_le16(txflags, pos);
>  	pos += 2;

Heh I would've fixed it by just using put_unaligned(txflags, pos) here,
but either is fine with me :-)

johannes

