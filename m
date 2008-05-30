Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4587 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013AbYE3Q6W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2008 12:58:22 -0400
Date: Fri, 30 May 2008 12:15:11 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Chr <chunkeey@web.de>
Subject: Re: [PATCH] p54: fix skb->cb tx info conversion
Message-ID: <20080530161511.GA24013@tuxdriver.com> (sfid-20080530_185826_273316_DB2B7484)
References: <1211813099.4843.12.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1211813099.4843.12.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 26, 2008 at 04:44:59PM +0200, Johannes Berg wrote:
> When I moved the TX info into skb->cb apparently I forgot to change a
> few places to put the p54-internal data into info->driver_data rather
> than skb->cb. This should fix it.
>=20
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  drivers/net/wireless/p54/p54common.c |   14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
>=20
> --- everything.orig/drivers/net/wireless/p54/p54common.c	2008-05-26 0=
9:42:49.000000000 +0200
> +++ everything/drivers/net/wireless/p54/p54common.c	2008-05-26 09:44:=
40.000000000 +0200
> @@ -392,16 +392,20 @@ static void p54_rx_frame_sent(struct iee
>  	u32 last_addr =3D priv->rx_start;
> =20
>  	while (entry !=3D (struct sk_buff *)&priv->tx_queue) {
> -		range =3D (struct memrecord *)&entry->cb;
> +		struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(entry);
> +		range =3D (void *)info->driver_data;
>  		if (range->start_addr =3D=3D addr) {
> -			struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(entry);
>  			struct p54_control_hdr *entry_hdr;
>  			struct p54_tx_control_allocdata *entry_data;
>  			int pad =3D 0;
> =20
> -			if (entry->next !=3D (struct sk_buff *)&priv->tx_queue)
> -				freed =3D ((struct memrecord *)&entry->next->cb)->start_addr - l=
ast_addr;
> -			else
> +			if (entry->next !=3D (struct sk_buff *)&priv->tx_queue) {
> +				struct ieee80211_tx_info *ni;
> +
> +				ni =3D IEEE80211_SKB_CB(entry->next);
> +				freed =3D ((void *)ni->driver_data)->start_addr
> +						- last_addr;
> +			} else
>  				freed =3D priv->rx_end - last_addr;
> =20
>  			last_addr =3D range->end_addr;

  CC [M]  drivers/net/wireless/p54/p54common.o
drivers/net/wireless/p54/p54common.c: In function =E2=80=98p54_rx_frame=
_sent=E2=80=99:
drivers/net/wireless/p54/p54common.c:406: warning: dereferencing =E2=80=
=98void *=E2=80=99 pointer
drivers/net/wireless/p54/p54common.c:406: error: request for member =E2=
=80=98start_addr=E2=80=99 in something not a structure or union

Looks like you are missing a (struct memrecord *) for the freed
assignment...?

John
--=20
John W. Linville
linville@tuxdriver.com
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
