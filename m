Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CBA41F5ED
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 01:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791856322; cv=none; b=HXZu1xGgySSgLlZ492UwoIA7n36GTceOl9VAzko9BXkzbNalzmH7bKNcfFr+uDea8J9xdr7npnS2E2MSCzFr2MEZSH7MMXKVNKZjFVtPSF79h480/AUs6i55zbCJkHn2lKTeMxlbgbo/HU4QNkh8PgGtu/7OsT5unvUi8KR3V5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791856322; c=relaxed/simple;
	bh=XdIj5q/gh9ujV3fqTejJK5mTL6bH9NFbzZakUWuGO5I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=T602XRfA37GCzt5XTBVNB+WBxqizlU7cf4BkrfvVm/galnWqJFYgPE3S97rci4Gp9YvVfEwrqsUUFfPVVPrL9QxORv1NG7LIUWWzIQ9InNJQ4Xrv/X0C1beRAuVMH53L7aum0aTLx1tTyBCpUwcftcDRbiPLjdFb6MebVpXtVog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=tay4EAQG; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="tay4EAQG"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69D1pt783114798, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791856315; bh=HXys3ckxzpbA8u1r7NR3Vyrhet5wQF+0ZxNTieclHVU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=tay4EAQGoUBm4zMgCtdKCEMJB1S7qeeNMgIagaASkwdnldeOi7U409HroRKKklTbj
	 /7/ekoHx5vqMALL+vKl5CdbPuu68s/IeYqgVNAw03akO9M8MddSeLJx0TX27tZxYMs
	 mebifMZEh9IrzlZidVKZPY4/6hp5JSh1GsiweGn+RAjjqht7yaruwyAdlwO0L/ZpNm
	 Pl+RhfFSxbf8AA+3x30J072IUggGkr780PWtin9BqUw58H36ywq5UdlpL0P2wfdOCd
	 gsf18c8sK/aRqneTagcw8j+y+I8y+8Hn08fn/zKY7AfkozufTfTNbjRyeyVNiI/bwo
	 /Oj7ck7OPoeHg==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69D1pt783114798
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:51:55 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 13 Oct 2026 09:51:54 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Tue, 13 Oct 2026 09:51:54 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Josef Schlehofer <pepe.schlehofer@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Mohammed Afifi <i.mafifi17@gmail.com>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH rtw-next v4] wifi: rtw88: usb: Download the reserved page
 synchronously
Thread-Topic: [PATCH rtw-next v4] wifi: rtw88: usb: Download the reserved page
 synchronously
Thread-Index: AQHdWlcHgY6d5QOmfUa83yDsmKNJabb6syKw
Date: Tue, 13 Oct 2026 01:51:54 +0000
Message-ID: <96a7bcd903484fe29c310166fa311813@realtek.com>
References: <20261012143557.82117-1-pepe.schlehofer@gmail.com>
In-Reply-To: <20261012143557.82117-1-pepe.schlehofer@gmail.com>
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

Josef Schlehofer <pepe.schlehofer@gmail.com> wrote:

[...]

Some minor comments below.

> diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wirel=
ess/realtek/rtw88/usb.c
> index 715a2ce342d9..f747400fca12 100644
> --- a/drivers/net/wireless/realtek/rtw88/usb.c
> +++ b/drivers/net/wireless/realtek/rtw88/usb.c
> @@ -396,6 +396,51 @@ static int rtw_usb_write_port(struct rtw_dev *rtwdev=
, u8 qsel, struct sk_buff *s
>         return ret;
>  }
>=20
> +static void rtw_usb_write_port_sync_complete(struct urb *urb)
> +{
> +       complete(urb->context);
> +}
> +
> +static int rtw_usb_write_port_sync(struct rtw_dev *rtwdev, u8 qsel,
> +                                  struct sk_buff *skb)
> +{
> +       struct rtw_usb *rtwusb =3D rtw_get_usb_priv(rtwdev);
> +       struct usb_device *usbd =3D rtwusb->udev;
> +       DECLARE_COMPLETION_ONSTACK(done);
> +       struct urb *urb;
> +       unsigned int pipe;
> +       int ret;
> +       int ep =3D qsel_to_ep(rtwusb, qsel);

In reverse X'mas tree order for three non-struct declarations.=20

> +
> +       if (ep < 0)
> +               return ep;
> +
> +       pipe =3D usb_sndbulkpipe(usbd, rtwusb->out_ep[ep]);
> +       urb =3D usb_alloc_urb(0, GFP_KERNEL);
> +       if (!urb)
> +               return -ENOMEM;
> +
> +       usb_fill_bulk_urb(urb, usbd, pipe, skb->data, skb->len,
> +                         rtw_usb_write_port_sync_complete, &done);
> +       urb->transfer_flags |=3D URB_ZERO_PACKET;
> +       ret =3D usb_submit_urb(urb, GFP_KERNEL);
> +       if (ret)
> +               goto out;
> +
> +       if (wait_for_completion_timeout(&done, secs_to_jiffies(5))) {
> +               ret =3D urb->status;
> +       } else {
> +               /* returns after the completion handler has finished with=
 &done */

This branch is timeout case, no? This comment is confusing me.

> +               usb_kill_urb(urb);
> +               ret =3D urb->status =3D=3D -ENOENT ? -ETIMEDOUT : urb->st=
atus;
> +       }
> +
> +out:
> +       usb_free_urb(urb);
> +
> +       return ret;
> +}
> +
>  static bool rtw_usb_tx_agg_skb(struct rtw_usb *rtwusb, struct sk_buff_he=
ad *list)
>  {
>         struct rtw_dev *rtwdev =3D rtwusb->rtwdev;
> @@ -508,7 +553,7 @@ static void rtw_usb_write_port_complete(struct urb *u=
rb)
>=20
>  static int rtw_usb_write_data(struct rtw_dev *rtwdev,
>                               struct rtw_tx_pkt_info *pkt_info,
> -                             u8 *buf)
> +                             u8 *buf, bool sync)
>  {
>         const struct rtw_chip_info *chip =3D rtwdev->chip;
>         struct sk_buff *skb;

I found the initializer of 'int ret =3D 0;' can be removed.
Please keep reverse X'mas order as well.

> @@ -530,12 +575,16 @@ static int rtw_usb_write_data(struct rtw_dev *rtwde=
v,
>         rtw_tx_fill_tx_desc(rtwdev, pkt_info, skb);
>         rtw_tx_fill_txdesc_checksum(rtwdev, pkt_info, skb->data);
>=20
> -       ret =3D rtw_usb_write_port(rtwdev, qsel, skb,
> -                                rtw_usb_write_port_complete, skb);
> -       if (unlikely(ret)) {
> +       if (sync)
> +               ret =3D rtw_usb_write_port_sync(rtwdev, qsel, skb);
> +       else
> +               ret =3D rtw_usb_write_port(rtwdev, qsel, skb,
> +                                        rtw_usb_write_port_complete, skb=
);
> +       if (unlikely(ret))
>                 rtw_err(rtwdev, "failed to do USB write, ret=3D%d\n", ret=
);
> +
> +       if (ret || sync)
>                 dev_kfree_skb_any(skb);
> -       }
>=20
>         return ret;
>  }


