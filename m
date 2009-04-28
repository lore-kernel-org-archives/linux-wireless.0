Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:35805 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756016AbZD1Ors (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2009 10:47:48 -0400
Subject: Re: [PATCH] libertas: fix format warning
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1240601958-7273-1-git-send-email-linville@tuxdriver.com>
References: <1240601958-7273-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 28 Apr 2009 10:48:52 -0400
Message-Id: <1240930132.25559.7.camel@localhost.localdomain> (sfid-20090428_164753_218126_6FB26E8F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-04-24 at 15:39 -0400, John W. Linville wrote:
> drivers/net/wireless/libertas/if_spi.c: In function =E2=80=98if_spi_c=
2h_data=E2=80=99:
> drivers/net/wireless/libertas/if_spi.c:733: warning: format =E2=80=98=
%u=E2=80=99 expects type =E2=80=98unsigned int=E2=80=99, but argument 4=
 has type =E2=80=98long unsigned int=E2=80=99
>=20
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Yup; since that define includes a sizeof() it'll be native pointer size=
,
not simply a uint.

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/if_spi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wir=
eless/libertas/if_spi.c
> index 97493e2..dccd01f 100644
> --- a/drivers/net/wireless/libertas/if_spi.c
> +++ b/drivers/net/wireless/libertas/if_spi.c
> @@ -731,7 +731,7 @@ static int if_spi_c2h_data(struct if_spi_card *ca=
rd)
>  		goto out;
>  	} else if (len > MRVDRV_ETH_RX_PACKET_BUFFER_SIZE) {
>  		lbs_pr_err("%s: error: card has %d bytes of data, but "
> -			   "our maximum skb size is %u\n",
> +			   "our maximum skb size is %lu\n",
>  			   __func__, len, MRVDRV_ETH_RX_PACKET_BUFFER_SIZE);
>  		err =3D -EINVAL;
>  		goto out;

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
