Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7233B42FE;
	Sun,  6 Sep 2026 03:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788666106; cv=none; b=myViN6HH6SbvhwOKqvHnuNiD1IacNQihEh3vAaFxNSATRQ4mHHks0aKj+1CDtJ5bKJtXvLzaiBGQW2RVBE5sZFrZcQTMo+PRHVS45o2MNdYlSSrfIeeCCWnpI2F8i7MG5F74zrA0ep+3khiQQZ8bupbpdC+pwv8Tde6eIbkmoEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788666106; c=relaxed/simple;
	bh=hG/Upj9RqcrRpgLKGcTFUe5pSKWdIJ0ODzHTTlfV9Sw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lEndyOYqS4ZKvgKWBiGkMUXSe3bMVWSNDqMjgR1EfU+sZ0Bt/KCeoaroN8ysYOyo4dCdQuil7/LnLHpZ2CJjmhafH8BYtlkiW67YdW60exCNKrYdFythtpJxFn2vl5qRL1Ggv80W5SkuXta98L5JECSU3iOefYddKJMVQGyDqE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=WUpH2Ju1; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="WUpH2Ju1"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6863fZdqD1626384, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788666095; bh=HiPn6/HXhEk2HSUce/QZrMS1zkPRKNbpkmok3iQp/Wk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=WUpH2Ju15wt7+8ClTNZRrdvKEOnaYkwyfaEoprhAB6vGp8m8vgLy2ETEvDdf6J73h
	 SycosfzKvmXaDEN1KasQDlw9fkl7OX+fZ9QLlNcJgEtC8pHdEXvl+VEWaLITX0b8TJ
	 AgLftORJQ7dTP2VuSbror9QEPzIDlQ7hXdesiU2snYoWU1/PF5U9BzxcjO1ZRZA0BE
	 yeFvUPZhXvCi1d+xz/7fM1Z+GdyhxPA1saW5b3p48ajaCD5KgEHrTgT5DL7Cr6JLlt
	 IPJzB/x3Fou6DgR6fgU0CUl+CywYSVlayY/8Y6s02353JKIAxu4YbYd/mXVsZPeH+I
	 TP5JPcOoMsv0Q==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6863fZdqD1626384
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 6 Sep 2026 11:41:35 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Sun, 6 Sep 2026 11:41:35 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Sun, 6 Sep 2026 11:41:35 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mehmet Fide <mehmet.fide@gmail.com>
CC: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mehmet Fide
	<mehmet.fide@screeningeagle.com>
Subject: RE: [PATCH rtw-next 1/2] wifi: rtw88: usb: bound what the driver
 feeds the after-DTIM queue
Thread-Topic: [PATCH rtw-next 1/2] wifi: rtw88: usb: bound what the driver
 feeds the after-DTIM queue
Thread-Index: AQHdOserEIbQKCPZBUapj5uLd8USWrbA5gLA
Date: Sun, 6 Sep 2026 03:41:35 +0000
Message-ID: <05f0cbfc6a744053863e3d7233e3ea15@realtek.com>
References: <20260902104146.3853102-1-mehmet.fide@gmail.com>
 <20260902104146.3853102-2-mehmet.fide@gmail.com>
In-Reply-To: <20260902104146.3853102-2-mehmet.fide@gmail.com>
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

Mehmet Fide <mehmet.fide@gmail.com> wrote:

[...]

> --- a/drivers/net/wireless/realtek/rtw88/usb.c
> +++ b/drivers/net/wireless/realtek/rtw88/usb.c
> @@ -562,7 +562,38 @@ static int rtw_usb_write_data_h2c(struct rtw_dev *rt=
wdev, u8 *buf, u32 size)
>         return rtw_usb_write_data(rtwdev, &pkt_info, buf);
>  }
>=20
> -static u8 rtw_usb_tx_queue_mapping_to_qsel(struct sk_buff *skb)
> +#define RTW_USB_HIQ_RATE       10
> +#define RTW_USB_HIQ_BURST      16
> +
> +static bool rtw_usb_hiq_take(struct rtw_usb *rtwusb)
> +{
> +       unsigned long flags, delta;
> +       bool ok;
> +       u32 add;
> +
> +       spin_lock_irqsave(&rtwusb->hiq_lock, flags);

nit: a blank line

> +       delta =3D jiffies - rtwusb->hiq_refill;
> +       if (delta >=3D HZ / RTW_USB_HIQ_RATE) {
> +               add =3D delta / (HZ / RTW_USB_HIQ_RATE);

The pattern ' HZ / RTW_USB_HIQ_RATE' repeat many times. Can you just define
the it as a part of macro? (The macro name should change as well.)

> +               if (add >=3D RTW_USB_HIQ_BURST) {
> +                       rtwusb->hiq_tokens =3D RTW_USB_HIQ_BURST;
> +                       rtwusb->hiq_refill =3D jiffies;
> +               } else {
> +                       rtwusb->hiq_tokens =3D min_t(u32, rtwusb->hiq_tok=
ens + add,
> +                                                  RTW_USB_HIQ_BURST);

Will 'quota' or 'budget' be clearer than 'token'?

> +                       rtwusb->hiq_refill +=3D add * (HZ / RTW_USB_HIQ_R=
ATE);

It looks like you shift refill jiffies according to the tokens you are addi=
ng.
How can I understand '+=3D add * (HZ / RTW_USB_HIQ_RATE)'?

> +               }
> +       }
> +       ok =3D rtwusb->hiq_tokens > 0;
> +       if (ok)
> +               rtwusb->hiq_tokens--;

nit: a blank line

> +       spin_unlock_irqrestore(&rtwusb->hiq_lock, flags);
> +
> +       return ok;
> +}
> +
> +static u8 rtw_usb_tx_queue_mapping_to_qsel(struct rtw_usb *rtwusb,
> +                                          struct sk_buff *skb)
>  {
>         struct ieee80211_hdr *hdr =3D (struct ieee80211_hdr *)skb->data;
>         struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);


