Return-Path: <SRS0=bGvd=SS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE50AC10F14
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 09:29:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8671020857
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 09:29:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729171AbfDPJ3m (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 05:29:42 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37132 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728518AbfDPJ3l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 05:29:41 -0400
Received: by mail-wr1-f65.google.com with SMTP id w10so26041628wrm.4
        for <linux-wireless@vger.kernel.org>; Tue, 16 Apr 2019 02:29:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=95BMgZMuUpzgiZp8pdYiku61NNhFSs49Ai7lWtJm1A0=;
        b=OnFIaCkWYeJ2Ny+ltiScr6x7LSs+ua+18UIsq+y7nAnk2PN+J/tnJ/0h5C/cPxfZ8D
         yyhi/VQO1brVf3qSwdiMIetVXlkbXdYwCKYpLdBqxYiybpVXkCb2ELN6YprT1FvqXrPJ
         ZliKcvVZeLhoOn7GyJqj2VXQ77CN00XOPm/mTpcwSgnaHNwO9jL3GJwYPzYa/WKljA9j
         dRXVKZq0LUIwGJ8EoGQHrPgn6LlIFTAfA4KhWTZPT5OOIyzyljtArQB5Um4puR00ny1W
         wAUySG/z47Gh4D3bGMuTnSDZ1Nc/EDVy9lE/ystZkFWDNTHac+I8n1jZztumyAWbUVRt
         GovA==
X-Gm-Message-State: APjAAAXqt2uYu6U2IAixH5nQWMGq2zeXGZ0uksY3ku3Rl7F7Sk/4mJDT
        HQtXJfYiAqtwt2wF+sDvr36g4SAo/Jk=
X-Google-Smtp-Source: APXvYqzK24uz18v6PNhrQpD03O/qQ0itw8y7N1ZIEcHhjOVCr+dCaZjnBY9qtHYa7kc7XoZyu0WmaQ==
X-Received: by 2002:a5d:6101:: with SMTP id v1mr30085142wrt.222.1555406978857;
        Tue, 16 Apr 2019 02:29:38 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id t24sm22252258wmi.10.2019.04.16.02.29.37
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 16 Apr 2019 02:29:38 -0700 (PDT)
Date:   Tue, 16 Apr 2019 11:29:36 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
Subject: Re: [RFC 3/3] mt76x02: remove bogus mutex usage
Message-ID: <20190416092935.GC11046@localhost.localdomain>
References: <20190416091305.4218-1-sgruszka@redhat.com>
 <20190416091305.4218-4-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="TiqCXmo5T1hvSQQg"
Content-Disposition: inline
In-Reply-To: <20190416091305.4218-4-sgruszka@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--TiqCXmo5T1hvSQQg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> mac .start(), .stop() callbacks are never called concurrently with other
> mac callbacks. The only concurencly is with mt76 works which we cancel
> on stop() and schedule on start().
>=20
> This fixes possible deadlock on cancel_delayed_work_sync(&dev->mac_work)
> as mac_work also take mutex.
>=20
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  .../net/wireless/mediatek/mt76/mt76x0/pci.c   |  6 -----
>  .../net/wireless/mediatek/mt76/mt76x0/usb.c   | 22 +++++--------------
>  .../wireless/mediatek/mt76/mt76x2/pci_main.c  |  5 -----
>  .../wireless/mediatek/mt76/mt76x2/usb_main.c  | 10 ++-------
>  4 files changed, 7 insertions(+), 36 deletions(-)
>=20
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/ne=
t/wireless/mediatek/mt76/mt76x0/pci.c
> index 156d3d064ba0..ac979128386a 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
> @@ -25,8 +25,6 @@ static int mt76x0e_start(struct ieee80211_hw *hw)
>  {
>  	struct mt76x02_dev *dev =3D hw->priv;
> =20
> -	mutex_lock(&dev->mt76.mutex);
> -
>  	mt76x02_mac_start(dev);
>  	mt76x0_phy_calibrate(dev, true);
>  	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->mac_work,
> @@ -35,8 +33,6 @@ static int mt76x0e_start(struct ieee80211_hw *hw)
>  				     MT_CALIBRATE_INTERVAL);
>  	set_bit(MT76_STATE_RUNNING, &dev->mt76.state);
> =20
> -	mutex_unlock(&dev->mt76.mutex);
> -
>  	return 0;
>  }
> =20
> @@ -62,10 +58,8 @@ static void mt76x0e_stop(struct ieee80211_hw *hw)
>  {
>  	struct mt76x02_dev *dev =3D hw->priv;
> =20
> -	mutex_lock(&dev->mt76.mutex);
>  	clear_bit(MT76_STATE_RUNNING, &dev->mt76.state);
>  	mt76x0e_stop_hw(dev);
> -	mutex_unlock(&dev->mt76.mutex);
>  }
> =20
>  static void

[..]

>  static const struct ieee80211_ops mt76x0u_ops =3D {
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c b/drive=
rs/net/wireless/mediatek/mt76/mt76x2/pci_main.c
> index 16dc8e2451b5..1b5caabebff5 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
> @@ -22,8 +22,6 @@ mt76x2_start(struct ieee80211_hw *hw)
>  	struct mt76x02_dev *dev =3D hw->priv;
>  	int ret;
> =20
> -	mutex_lock(&dev->mt76.mutex);
> -
>  	ret =3D mt76x2_mac_start(dev);
>  	if (ret)
>  		goto out;

You can remove goto here and just return ret (same below)

> @@ -40,7 +38,6 @@ mt76x2_start(struct ieee80211_hw *hw)
>  	set_bit(MT76_STATE_RUNNING, &dev->mt76.state);
> =20
>  out:
> -	mutex_unlock(&dev->mt76.mutex);
>  	return ret;
>  }
> =20
> @@ -49,10 +46,8 @@ mt76x2_stop(struct ieee80211_hw *hw)
>  {
>  	struct mt76x02_dev *dev =3D hw->priv;
> =20
> -	mutex_lock(&dev->mt76.mutex);
>  	clear_bit(MT76_STATE_RUNNING, &dev->mt76.state);
>  	mt76x2_stop_hardware(dev);
> -	mutex_unlock(&dev->mt76.mutex);
>  }
> =20
>  static int
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c b/drive=
rs/net/wireless/mediatek/mt76/mt76x2/usb_main.c
> index 0771de210c6a..32726b4906ea 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
> @@ -21,30 +21,24 @@ static int mt76x2u_start(struct ieee80211_hw *hw)
>  	struct mt76x02_dev *dev =3D hw->priv;
>  	int ret;
> =20
> -	mutex_lock(&dev->mt76.mutex);
> -
>  	ret =3D mt76x2u_mac_start(dev);
>  	if (ret)
> -		goto out;
> +		return ret;
> =20
>  	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mac_work,
>  				     MT_MAC_WORK_INTERVAL);
>  	set_bit(MT76_STATE_RUNNING, &dev->mt76.state);
> =20
> -out:
> -	mutex_unlock(&dev->mt76.mutex);
> -	return ret;
> +	return 0;
>  }
> =20
>  static void mt76x2u_stop(struct ieee80211_hw *hw)
>  {
>  	struct mt76x02_dev *dev =3D hw->priv;
> =20
> -	mutex_lock(&dev->mt76.mutex);
>  	clear_bit(MT76_STATE_RUNNING, &dev->mt76.state);
>  	mt76u_stop_tx(&dev->mt76);
>  	mt76x2u_stop_hw(dev);
> -	mutex_unlock(&dev->mt76.mutex);
>  }
> =20
>  static int
> --=20
> 2.20.1
>=20

--TiqCXmo5T1hvSQQg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXLWgewAKCRA6cBh0uS2t
rBC1AP0eX5OeNpRB23dUDdViu9creTctrLXs5cwBLFRvN5UwbwEAq4ZHUnpx8xww
x8WjhCWT5rCve4rrx57+ITiYjlS8Zwg=
=f75v
-----END PGP SIGNATURE-----

--TiqCXmo5T1hvSQQg--
