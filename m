Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793239050;
	b=fghR+1z1VgyQGsbz4a1OCVa68zZdt37/g02qNJsOze5A2icAN+95qpcXm6W6a5gCn47C
	 Pav6tLhCRH5XlzbNFbVIfWCLaN40h7gDs986PTc52aVnGpDWrEj0kmoIFJXaZgtJ45iKp
	 BWapVcUerpsJUanZKx8+JIp0eOSEhn8AIhAbggfmw3WjNYVUMognFGUM28T0pCvIpYU5U
	 QA31pbcus/wup84vU1CmOoWkZAzXUsH7yROfkIXsW8BaHzBfHQSGLx927D5RmaTrA4zJ4
	 c2RYqJwf0dvxWEM7Ue8Z4Rb9m84nIRv3YZp7+qNTDxZlL8qLkPdsjXdthXIQ7mEVr7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793239050;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:
	 References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=DVTcnbPuad1yF6DRhNOYmBJVZtpCUGa00cr3jC/F7go=;
	b=nME/7XhtNisUw3/2KGqHMfMlp12PllvJceuorY40kDsQR8KdVcsVbAMMwbB3WWctRZVm
	 108PD1+8uL3iw9i/b0XxKH7Sz1UFVskpbooWblPRVV23Zibn+0rVCQIGJo3lmGZTV6adp
	 EUk/3rWkqBlEuUa9FRa+TQ2KnfeAQOta+E/jmDfNdaFaq6cwR3EiQhlDlKwqB4MYTOund
	 omaq2C5kJAhtCr2VYLLww16A75mYe6f6PBoAB+3W3JhTur5zRg+jE4oKgNsUfx+laEZkM
	 juEgNs4ocI4nbA7vyJ/DAuRSzGf9pDl4ANg6Ed+KU+de6ManUvpLZPc9JiNfboJdxzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b="nM2Ptpk/";
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7052D606A31A
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 01:57:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7052D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=nM2Ptpk/
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69T1vMfyD2419257, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793239042; bh=DVTcnbPuad1yF6DRhNOYmBJVZtpCUGa00cr3jC/F7go=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=nM2Ptpk/cH8gnucMQPNAr+WsjPtcncyOUqA2WWCnkpecueTFIVjf7UBqM/X9b+YoN
	 y8ok2+7eZcj+1fFLzoyTnvDilyJ/nfTX4A0AE3CSC454aJ7wcpNRtmcGeM7yt7L1J3
	 a/dGI+fPhsPQgXYuUcL/Lg995TlRhI2usshf44z9DcFFJc+A/sh1PK6YRzxdl/1eqq
	 zRL6DErVuPFkiembdYHAxEB6SWA/di+46ftAX6EaCPcujfs+8Hmo2wj7vwGNpy2zdX
	 pq6urHS2mWPW6cyRriSNNgUQ9OV19J+6rm51SvXK6WK/Dirv0hKnac7/Hgb9Gqe8p8
	 w0OhWNFQgkiMg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69T1vMfyD2419257
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 29 Oct 2026 09:57:22 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 29 Oct 2026 09:57:13 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef%10]) with mapi id
 15.02.2562.056; Thu, 29 Oct 2026 09:57:13 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: V schurink <spam@acio.nl>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH rtw-next] wifi: rtw89: do BIP in software when not in
 station mode
Thread-Topic: [PATCH rtw-next] wifi: rtw89: do BIP in software when not in
 station mode
Thread-Index: AQHdYJs1nqEC/6moOkOYSlDC5jn4+LcTzu+w
Date: Thu, 29 Oct 2026 01:57:13 +0000
Message-ID: <1ca81a8669be41a6924ad0c5e042fcdc@realtek.com>
References: <20261020130019.137170-1-spam@acio.nl>
In-Reply-To: <20261020130019.137170-1-spam@acio.nl>
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

V schurink <spam@acio.nl> wrote:
> rtw89_cam_sec_key_add() installs the AES-CMAC key (BIP, 802.11w PMF)
> in hardware. rtw89_core_tx_update_sec_key() has no case for
> WLAN_CIPHER_SUITE_AES_CMAC, and the driver does not set
> IEEE80211_KEY_FLAG_GENERATE_MMIE. Thus, an AP with PMF sends each
> protected group-addressed management frame without an MMIE, for
> example a broadcast deauthentication. For each frame, the driver logs
> "key cipher not supported 1027078". PMF clients discard these frames.
>=20
> An AP sends these frames. Thus, return -EOPNOTSUPP for AES-CMAC when
> the interface is not a station, so that mac80211 does BIP in software.
> A station only receives these frames, so it keeps the IGTK in
> hardware. This does not change WoWLAN, which uses the IGTK of a
> station.
>=20
> BIP in hardware does not work for an AP on RTL8922A. The test used
> IEEE80211_KEY_FLAG_GENERATE_MMIE and RTW89_SEC_KEY_TYPE_BIP_CCMP128 in
> the TX descriptor. The client did not accept the protected broadcast
> deauthentication.
>=20
> Tested on RTL8912AU (RTL8922A, USB) in AP mode with hostapd 2.10,
> WPA2-PSK and SAE, ieee80211w=3D1. The client accepts the protected
> broadcast deauthentication, and the driver does not log the warning.

We made a RFT patch [1]. Please try if it can work to you.

I think the reason why your try in github doesn't work is missing to
trim MIC space of MMIC.

[1] https://lore.kernel.org/linux-wireless/20261029014857.9753-1-pkshih@rea=
ltek.com/T/#u

>=20
> Fixes: 940cd99625de ("wifi: rtw89: wow: support 802.11w PMF IGTK rekey")
> Signed-off-by: V schurink <spam@acio.nl>
> ---
>  drivers/net/wireless/realtek/rtw89/cam.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> diff --git a/drivers/net/wireless/realtek/rtw89/cam.c b/drivers/net/wirel=
ess/realtek/rtw89/cam.c
> index 22f21a0..58a7e8f 100644
> --- a/drivers/net/wireless/realtek/rtw89/cam.c
> +++ b/drivers/net/wireless/realtek/rtw89/cam.c
> @@ -514,6 +514,12 @@ int rtw89_cam_sec_key_add(struct rtw89_dev *rtwdev,
>                 ext_key =3D true;
>                 break;
>         case WLAN_CIPHER_SUITE_AES_CMAC:
> +               /* TX does not support BIP. An AP sends group-addressed r=
obust
> +                * management frames, so let mac80211 do BIP in software =
there.
> +                * A station only receives them; keep its IGTK in hardwar=
e.
> +                */

The first line of block comment should be empty. Even, I think this comment
is not necessary. The change blow says that, or it should be 'vif =3D=3D IF=
TYPE_AP'
to match the comment.=20

> +               if (vif->type !=3D NL80211_IFTYPE_STATION)
> +                       return -EOPNOTSUPP;
>                 hw_key_type =3D RTW89_SEC_KEY_TYPE_BIP_CCMP128;
>                 break;
>         default:
> --
> 2.53.0
> ---
> Also discussed in the out-of-tree repository:
> https://github.com/morrownr/rtw89/pull/135

