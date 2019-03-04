Return-Path: <SRS0=K+dv=RH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4BBEC43381
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 10:55:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8927E20823
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 10:55:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbfCDKzd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Mar 2019 05:55:33 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42245 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbfCDKzd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Mar 2019 05:55:33 -0500
Received: by mail-wr1-f65.google.com with SMTP id r5so4998557wrg.9
        for <linux-wireless@vger.kernel.org>; Mon, 04 Mar 2019 02:55:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7h6lPr0ehQEwogrDlc9Yk5GhAFp5H3Ag4vFZEkGPK7k=;
        b=hojpRBu+FpnWzwxae8mr7My0YowpAiVNZO86mpF5xi7qvX8qH49dCR6P2im6FJpCEx
         F1P9hKPnn5yoyeJLPEhP9VTlc4wK67FqKz3G7f9KEitDemsYPag9VKfrp2u7Mt1zQFn1
         jIbWXlv7pjCFjd2E4phrk3Jqwy+cg/VAITl2WsX1wZ7kuE2mTwgXmv/wYDLKu9bo1zF1
         y7KdJhEPdI81FpSBvshKRqXJ5XoPAAzqPmc+B8FM18YxcA0yoYlLziXoKIOkscZj6wKA
         xi8LnmC2jP250bdN5aKo5Rde8IoXDgRq/1VYE5jo6h0xDMIdY3GiQUx7dFmjvVVCdAcp
         EU6g==
X-Gm-Message-State: APjAAAVMvr0DeOuIdpkWwG8Ur0G6ojmYQQfKmZbLQ7Y7A8uJs6rgMsur
        aP0F18NkuuECiCaZKOz+TsQH4g==
X-Google-Smtp-Source: APXvYqyV/WTa9lPYf9V+KhNlY7P/p2NIJ+ZROwsNooK6skQNgvh1UXifRNNvT8i7ld4rChNuoIGUdQ==
X-Received: by 2002:adf:edca:: with SMTP id v10mr11696593wro.313.1551696931599;
        Mon, 04 Mar 2019 02:55:31 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id y8sm4472952wrm.8.2019.03.04.02.55.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 04 Mar 2019 02:55:30 -0800 (PST)
Date:   Mon, 4 Mar 2019 11:55:07 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 11/11] mt76x02: enable AP mode for USB
Message-ID: <20190304105506.GB3073@localhost.localdomain>
References: <1551692896-7062-1-git-send-email-sgruszka@redhat.com>
 <1551692896-7062-12-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="JYK4vJDZwFMowpUq"
Content-Disposition: inline
In-Reply-To: <1551692896-7062-12-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--JYK4vJDZwFMowpUq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Enable AP mode. For now without multi-vif support, this will require
> more testing and investigation.
>=20
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/=
net/wireless/mediatek/mt76/mt76x02_util.c
> index 38997076cb03..99c729f6701d 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> @@ -142,6 +142,7 @@ void mt76x02_init_device(struct mt76x02_dev *dev)
> =20
>  	wiphy->interface_modes =3D
>  		BIT(NL80211_IFTYPE_STATION) |
> +		BIT(NL80211_IFTYPE_AP) |
>  #ifdef CONFIG_MAC80211_MESH
>  		BIT(NL80211_IFTYPE_MESH_POINT) |

I think we need to disable DFS channels for the moment (for mt76x{0,2}u) si=
nce
dfs is not supported yet

Regards,
Lorenzo

>  #endif
> @@ -158,7 +159,6 @@ void mt76x02_init_device(struct mt76x02_dev *dev)
>  		wiphy->reg_notifier =3D mt76x02_regd_notifier;
>  		wiphy->iface_combinations =3D mt76x02_if_comb;
>  		wiphy->n_iface_combinations =3D ARRAY_SIZE(mt76x02_if_comb);
> -		wiphy->interface_modes |=3D BIT(NL80211_IFTYPE_AP);
>  		wiphy->flags |=3D WIPHY_FLAG_HAS_CHANNEL_SWITCH;
> =20
>  		/* init led callbacks */
> --=20
> 2.20.1
>=20

--JYK4vJDZwFMowpUq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXH0EBgAKCRA6cBh0uS2t
rN44AP4+EMGgfGdR5bdv0krFPjZYyr0CQYLMrl9BhBx+0hNugQD/XebShZxo3pLc
EM9NRCDtzULebRJXcOlCtY8/EFn0Ogo=
=QLp5
-----END PGP SIGNATURE-----

--JYK4vJDZwFMowpUq--
