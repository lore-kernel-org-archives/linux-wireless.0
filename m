Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:63755 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353AbYLLKYM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 05:24:12 -0500
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 12 Dec 2008 02:24:12 -0800
Date: Fri, 12 Dec 2008 15:54:05 +0530
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: Jouni Malinen <jouni.malinen@atheros.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>
Subject: Re: [PATCH] ath9k: Do not remove header padding on RX from short
	frames
Message-ID: <20081212102405.GA10231@senthil-lnx.users.atheros.com> (sfid-20081212_112416_351937_202745FC)
References: <20081211162213.GA28193@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20081211162213.GA28193@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 11, 2008 at 09:52:13PM +0530, Jouni Malinen wrote:
> The 802.11 header is only padded to 32-bit boundary when the frame has
> a non-zero length payload. In other words, control frames (e.g., ACK)
> do not have a padding and we should not try to remove it. This fixes
> monitor mode for short control frames. In addition, the hdrlen&3 use
> is described in more detail to make it easier to understand how the
> padding length is calculated.
> 
> Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
> 
> ---
>  drivers/net/wireless/ath9k/recv.c |   12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> --- wireless-testing.orig/drivers/net/wireless/ath9k/recv.c     2008-12-11 11:35:56.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/ath9k/recv.c  2008-12-11 12:18:02.000000000 +0200
> @@ -571,8 +571,16 @@ int ath_rx_tasklet(struct ath_softc *sc,
>                 hdr = (struct ieee80211_hdr *)skb->data;
>                 hdrlen = ieee80211_get_hdrlen_from_skb(skb);
> 
> -               if (hdrlen & 3) {
> -                       padsize = hdrlen % 4;
> +               /* The MAC header is padded to have 32-bit boundary if the
> +                * packet payload is non-zero. The general calculation for
> +                * padsize would take into account odd header lengths:
> +                * padsize = (4 - hdrlen % 4) % 4; However, since only
> +                * even-length headers are used, padding can only be 0 or 2
> +                * bytes and we can optimize this a bit. In addition, we must
> +                * not try to remove padding from short control frames that do
> +                * not have payload. */
> +               padsize = hdrlen & 3;
> +               if (padsize && hdrlen >= 24) {
I think "if(padsize && hdrlen > 24)" should be sufficient here as padsize is
anyway zero for hdlen==24.
>                         memmove(skb->data + padsize, skb->data, hdrlen);
>                         skb_pull(skb, padsize);
>                 }
> 
> --
> Jouni Malinen                                            PGP id EFC895FA
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
