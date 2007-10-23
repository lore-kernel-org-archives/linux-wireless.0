Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:51497 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752873AbXJWXPl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Oct 2007 19:15:41 -0400
Received: from midway.site ([71.117.233.180]) by xenotime.net for <linux-wireless@vger.kernel.org>; Tue, 23 Oct 2007 16:15:35 -0700
Date: Tue, 23 Oct 2007 16:15:35 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 10/12] mac80211: fix warning created by BIT()
Message-Id: <20071023161535.a526d595.rdunlap@xenotime.net> (sfid-20071024_001545_507325_368E1C48)
In-Reply-To: <20071023223645.421AB1F81B6@havoc.gtf.org>
References: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org>
	<20071023223645.421AB1F81B6@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 23 Oct 2007 18:36:45 -0400 (EDT) Jeff Garzik wrote:

> Now that BIT() forces unsigned long, this warning appears:
>=20
> net/mac80211/ieee80211_sta.c: In function =E2=80=98ieee80211_rx_mgmt_=
assoc_resp=E2=80=99:
> net/mac80211/ieee80211_sta.c:1187: warning: format =E2=80=98%d=E2=80=99=
 expects type =E2=80=98int=E2=80=99, but argument 7 has type =E2=80=98l=
ong unsigned int=E2=80=99

LC_ALL=3DC make ...


> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> ---
>=20
> diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_st=
a.c
> index f7ffeec..bdfd901 100644
> --- a/net/mac80211/ieee80211_sta.c
> +++ b/net/mac80211/ieee80211_sta.c
> @@ -1182,7 +1182,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct=
 net_device *dev,
>  	aid =3D le16_to_cpu(mgmt->u.assoc_resp.aid);
> =20
>  	printk(KERN_DEBUG "%s: RX %sssocResp from %s (capab=3D0x%x "
> -	       "status=3D%d aid=3D%d)\n",
> +	       "status=3D%d aid=3D%ld)\n",
>  	       dev->name, reassoc ? "Rea" : "A", print_mac(mac, mgmt->sa),
>  	       capab_info, status_code, aid & ~(BIT(15) | BIT(14)));
> =20
> -

Patch was submitted yesterday by Johannes Berg, but does need to be
pushed by someone... (like this)


---
~Randy
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
