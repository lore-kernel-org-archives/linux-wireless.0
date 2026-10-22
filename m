Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792632993;
	b=y1WtzvTL6wJvLerO4PDeeIas3h162vylheezOFeaLFYpqexH+Vs6rakua1fiz9bQb+4k
	 Yb63GMQa5/YDJzCPf9dhlNwyIqbAwwyMoOAghePMK1vY2q3UNuFhl+5IdMKQQDbF8EzXZ
	 Oww3OKmSPketz2Qey0v9V1AIuiZTjtbWvnv07IhcPN7j9p5YPHKttEiXiy7VkXqMZ3AwP
	 mszFVVRWXmv5wCM3GIXomck8AbQxzkgvYkT8qudDzoQNdxunB+ONMMcAWOl68ow8R+yL8
	 7kEP8SnmJzClanMhfLbJjs6lf2q3G1Ed6Psyahe1lBSPS4Y+2LpHQI5rMHtLsj66mlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792632993;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:
	 Message-ID:References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=BGZjxVG3+ZQKW4GT5a9vzXXQ4iSYpkTQGbrMvaFDw/M=;
	b=3ECmD4KsqAOSXsy3GRroidHIe7Q26WhdcdBG63tULYGdulV3PixW6Ct900gs3IRFffwU
	 xy1nCblQFcvSntMarI3VwCQSE8VohomMWrvdIOxYIu5thBFJzn2eItStzFgThBwb5GLLl
	 6tMU+IaMcPNOnHacbvLmrhNMFBThN696EHeAeZ2epfuhVM4hJMRCCJx0TMfzcoQuSzrsb
	 PPg7GMizxhvn7hASyXAQEqbj7yT/i9ZyaleHBUjYDI8bS6K5AlwLekitKrzTTbH4FYHG/
	 eWoCa/qKgBNTK9i55Ahi4HaIxI1MTPBUqf+FQSnczvfe94ygHyUyU80jtBO1Z2LAmcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=Uy43FliI;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF08606A319;
	Thu, 22 Oct 2026 01:36:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AEF08606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=Uy43FliI
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69M1aRkA5423792, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1792632987; bh=BGZjxVG3+ZQKW4GT5a9vzXXQ4iSYpkTQGbrMvaFDw/M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=Uy43FliIJo8XF8c1lv7RQIJ3dcmZ7PP/ccCRSUImRwDgJ0tzMZ/JQsX3jMZXYmaax
	 P9zXYUZqBoswbnsLBI1c5zKWHZiL+w4nGpr271S4++cHZ8hGA60Llf8ynDuR7EDiF/
	 NgaaZtA7aCRruX5rHHsuTzSSmVY35wpe2a49BABrTcDuf3frKBt37nFlEcgOZGTOzu
	 L3AGaAgHI+7vQk82XbxwleoQYsuzNThiQt3Do/eEH49YmclwY1Y+/Vk6jnj513ul+q
	 FpvtmX/BkA01zR5iwSrX8P5TWw6s1ZQ/gznz+LHFiuFWWkiEFJKZ5A0sVZe1CwWDcY
	 ZeZw3rl313ksA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69M1aRkA5423792
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 22 Oct 2026 09:36:27 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 22 Oct 2026 09:36:27 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 22 Oct 2026 09:36:27 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Thu, 22 Oct 2026 09:36:27 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"rtl8821cerfe2@gmail.com" <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH rtw-next v4] wifi: rtw88: pci: wake the TX queues after
 restart_hw and interface up
Thread-Topic: [PATCH rtw-next v4] wifi: rtw88: pci: wake the TX queues after
 restart_hw and interface up
Thread-Index: AQHdYUTZHqBHBr/kKE6mkTCqhcbTnLcIxw1A
Date: Thu, 22 Oct 2026 01:36:27 +0000
Message-ID: <e9cab7ed7daf45b9b4c2294174f8c1a0@realtek.com>
References: <20261021101315.1974894-1-abdurrahmankaradag19@gmail.com>
In-Reply-To: <20261021101315.1974894-1-abdurrahmankaradag19@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Abdurrahman Karadag <abdurrahmankaradag19@gmail.com> wrote:
> diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wirel=
ess/realtek/rtw88/pci.c
> index 66d2e5f..fd84ace 100644
> --- a/drivers/net/wireless/realtek/rtw88/pci.c
> +++ b/drivers/net/wireless/realtek/rtw88/pci.c
> @@ -571,12 +571,20 @@ static void rtw_pci_napi_stop(struct rtw_dev *rtwde=
v)
>  static int rtw_pci_start(struct rtw_dev *rtwdev)
>  {
>         struct rtw_pci *rtwpci =3D (struct rtw_pci *)rtwdev->priv;
> +       enum rtw_tx_queue_type queue;
> +       bool wake =3D false;
>=20
>         rtw_pci_napi_start(rtwdev);
>=20
>         spin_lock_bh(&rtwpci->irq_lock);

It would look natural to clear queue_stopped before enabling interrupt,=20
since it is intended to reset. More, add a function to be clear that we=20
are resetting queue_stopped, like rtw_pci_reset_tx_{ring or queue}_state().

For scanning from idle case, we have an assistant=20
'test_bit(RTW_FLAG_SCANNING, rtwdev->flags)' if you want.

Add an empty line before 'running =3D true'.

>         rtwpci->running =3D true;
>         rtw_pci_enable_interrupt(rtwdev, rtwpci, false);
> +       for (queue =3D 0; queue < RTK_MAX_TX_QUEUE_NUM; queue++) {
> +               wake |=3D rtwpci->tx_rings[queue].queue_stopped;
> +               rtwpci->tx_rings[queue].queue_stopped =3D false;
> +       }
> +       if (wake)
> +               ieee80211_wake_queues(rtwdev->hw);
>         spin_unlock_bh(&rtwpci->irq_lock);
>=20
>         return 0;
> base-commit: 9b0be45d4d52fd223994e151f169743a97abd290
> --
> 2.56.0

