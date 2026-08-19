Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30EEC38BF69;
	Wed, 19 Aug 2026 00:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787098976; cv=none; b=JQ4giQRkHJIKPUa/SRynAgzwqj/TGU0cyjU0ZMPCCpa2NLiJey1txmNc21AhIOvOvk4OsB5Q4nzQLYMpBpXcwO1mFGoYCFzlM34HEQhjb+NDXxcuFm5y+1QmMnzEoed8AeHHebcGL0Rm3fkdmHA4I/gXmtp52rO/PBA0eyrA9ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787098976; c=relaxed/simple;
	bh=LgbsACI0TefRjRijF9DAEEqTrRDTP6iYnOk0v+sjZqE=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KXmVKep5myuGEyh1CRGTMtHkH+tYeNsbULMxRLCf/T92udF7K/x5JKvfIEP0p6hcGfxUAVPPbuTlldGmM0CPcMnJRgK9dCg5YjMXOdm6JJVB/J+DzUByn+6AECF9D6SQf2ax1OdoiUQ/uwxr2Jj1bNgexSS7KNBNFMV58wfG73I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=n3zBf+Mk; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="n3zBf+Mk"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67J0MfPdA1911497, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787098961; bh=QeJU0+umnOedZzWnDufzijNUN4i+e57o63OO/e4dNcc=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=n3zBf+MkusoAVDq4H/nPg0Sk/1XJruPlr9b5V5u3QAJ2AAao+PNFHK2rC1j7wJ5i6
	 YouXkCxV49PeiUqcfRTWc2KOn3uDgCUUDOeNlV0B7jbqKnNHDAfj30cM2poUk2dCQK
	 dwP6+uxhGj0nBLeJmkc3WDiemjRVVHDcRTw2rNt7RzH4ghBRfv47VynWFZtfI6btTi
	 7sBpOCjNyrNSVH7GDqXT+r+DJfaMQmANrMYysYa+gZDy7hF57/f3etXKGbiG9KBEPW
	 wHOLg9Gj96izt1bXZ5XYTVWms60y0hgP5WGHbpsala5fJjQONQrYL8GGfV6t6hsEyJ
	 7dH13emM68Cpw==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67J0MfPdA1911497
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 19 Aug 2026 08:22:41 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 19 Aug 2026 08:22:41 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Wed, 19 Aug 2026 08:22:41 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: rafad900 <rafad900@gmail.com>, "Jes.Sorensen@gmail.com"
	<Jes.Sorensen@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
Subject: RE: [PATCH rtw-next v5] wifi: rtl8xxxu: Use local 'dev' variable for
 dev_warn()
Thread-Topic: [PATCH rtw-next v5] wifi: rtl8xxxu: Use local 'dev' variable for
 dev_warn()
Thread-Index: AQHdL0mfYevXINN71kKpfmR/NZF2pbakgbQg
Date: Wed, 19 Aug 2026 00:22:41 +0000
Message-ID: <51b1f52648c948a5b960d3e3196fa845@realtek.com>
References: <20260818193402.2109269-1-rafad900@gmail.com>
In-Reply-To: <20260818193402.2109269-1-rafad900@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

rafad900 <rafad900@gmail.com> wrote:
> @@ -3173,7 +3175,7 @@ static int rtl8xxxu_iqk_path_b(struct rtl8xxxu_priv=
 *priv)
>             (((reg_ecc & 0x03ff0000) >> 16) !=3D 0x36))
>                 result |=3D 0x02;
>         else
> -               dev_warn(&priv->udev->dev, "%s: Path B RX IQK failed!\n",
> +               dev_warn(dev, "%s: Path B RX IQK failed!\n",
>                          __func__);

Straighten ?

Please check this kind of pattern across whole patch before sending out.

>  out:
>         return result;


> @@ -5862,6 +5864,7 @@ static void rtl8xxxu_queue_rx_urb(struct rtl8xxxu_p=
riv *priv,
>  static void rtl8xxxu_rx_urb_work(struct work_struct *work)
>  {
>         struct rtl8xxxu_priv *priv;
> +       struct device *dev;

In reverse X'mas tree order.=20

>         struct rtl8xxxu_rx_urb *rx_urb, *tmp;
>         struct list_head local;
>         struct sk_buff *skb;
> @@ -5869,6 +5872,7 @@ static void rtl8xxxu_rx_urb_work(struct work_struct=
 *work)
>         int ret;
>=20
>         priv =3D container_of(work, struct rtl8xxxu_priv, rx_urb_wq);
> +       dev =3D &priv->udev->dev;
>         INIT_LIST_HEAD(&local);
>=20
>         spin_lock_irqsave(&priv->rx_urb_lock, flags);
> @@ -5894,8 +5898,7 @@ static void rtl8xxxu_rx_urb_work(struct work_struct=
 *work)
>                         rtl8xxxu_queue_rx_urb(priv, rx_urb);
>                         break;
>                 default:

Only here use local 'dev'. Why not assign the value here?
But for this case, it seems no gain. Just keep it as was?

> -                       dev_warn(&priv->udev->dev,
> -                                "failed to requeue urb with error %i\n",=
 ret);
> +                       dev_warn(dev, "failed to requeue urb with error %=
i\n", ret);
>                         skb =3D (struct sk_buff *)rx_urb->urb.context;
>                         dev_kfree_skb(skb);
>                         usb_free_urb(&rx_urb->urb);
> --
> 2.43.0
>=20

