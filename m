Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:50057 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215AbXJ1Kpq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2007 06:45:46 -0400
Message-ID: <4724684F.3000106@garzik.org> (sfid-20071028_104549_992101_30C244F4)
Date: Sun, 28 Oct 2007 06:45:35 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Joe Jezak <josejx@gentoo.org>, Daniel Drake <dsd@gentoo.org>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mac80211: fix printk() format string
References: <472473D2.8040102@freemail.hu>
In-Reply-To: <472473D2.8040102@freemail.hu>
Content-Type: text/plain; charset=ISO-8859-2;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

N=E9meth M=E1rton wrote:
> From: M=E1rton N=E9meth <nm127@freemail.hu>
>=20
> Get rid of the following compiler warning message:
>=20
> net/mac80211/ieee80211_sta.c: In function 'ieee80211_rx_mgmt_assoc_re=
sp':
> net/mac80211/ieee80211_sta.c:1187: warning: format '%d' expects type =
'int', but argument 7 has type 'long unsigned int'
>=20
> Signed-off-by: M=E1rton N=E9meth <nm127@freemail.hu>
> ---
> --- linux-2.6.24-rc1/net/mac80211/ieee80211_sta.c.orig	2007-10-24 05:=
50:57.000000000 +0200
> +++ linux-2.6.24-rc1/net/mac80211/ieee80211_sta.c	2007-10-28 11:20:23=
=2E000000000 +0100
> @@ -1182,7 +1182,7 @@ static void ieee80211_rx_mgmt_assoc_resp
>  	aid =3D le16_to_cpu(mgmt->u.assoc_resp.aid);
>=20
>  	printk(KERN_DEBUG "%s: RX %sssocResp from %s (capab=3D0x%x "
> -	       "status=3D%d aid=3D%d)\n",
> +	       "status=3D%d aid=3D%lu)\n",
>  	       dev->name, reassoc ? "Rea" : "A", print_mac(mac, mgmt->sa),
>  	       capab_info, status_code, aid & ~(BIT(15) | BIT(14)));

=46ix already went upstream...


-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
