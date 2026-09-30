Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A99386C37;
	Wed, 30 Sep 2026 03:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790739921; cv=none; b=PJT861Ms2K7M6HbA6EXImMqPxuByjr0myshTh6RhfDPP3Nd292oHC9BUI8kTk56q2/CKwZIAdOxtzd60DDuPVbexXbObObPeVAk96e+Iu7kYF92jd5T8gxKNggaO51+ik3kzMSaycZ0/STcUtFYEXC6EMqM/21xyk0WKsNnzOJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790739921; c=relaxed/simple;
	bh=jmx/Jl6VciQ21pEgirl+C5UPRJMRlhQE3P6BfMcdsTk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=s/OrAsdJDfJrfE++1w6lJvPVNPMLdVQzgjQ7+5AzCKLg7ZzDpczbjpeLnXUzwZHpKNTCPIfMkEAH7AqyshaWTWoTC3TIVK/LjDu6iYb7NU3qgoWqkVnoA4l7pL3Re41mRtOI8CAlqG3sni5+o2sYkgVBsoMtfC8b5zN74L5CCbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Gf8czlz7; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Gf8czlz7"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68U3jBTx91814670, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790739911; bh=nM680bHQwzxvq4VhgLZv6XsNS3599HmXcpfoKFqgW34=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=Gf8czlz7O+KRLdQrOx6zvTkjq6KiAdnJqUWfFxpnUmtbuhlpC5tkMvEBF5LwkQvan
	 hYiyZWs/3ip5YaEEohCwcNN9VpxJr+pgQyX6BCl4mFGpxkmGY/bt527pZTmPrIHyDz
	 Kn9H5Ri7mHvI4Oz7ZDIHNTEGeaHTzYiHPM7ooaTt7OmdXN3AQgzcI80tvJLGXwYmdn
	 eSQkLL+lgnApLeyrV3vSnOD69eozFAXmxgmLIyjTQbMRK0uKQ5DfKFJTUmI33hf812
	 hKdWHe5hag4OfxBhA61iD0tbS0pQ/buIGDcsQAXeZBW6L+nG++9FJTf1GK3w0FCQ8h
	 4z+O/LoeZ2JsQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68U3jBTx91814670
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 30 Sep 2026 11:45:11 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 30 Sep 2026 11:45:11 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 30 Sep 2026 11:45:11 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Wed, 30 Sep 2026 11:45:11 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mehmet Fide <mehmet.fide@gmail.com>
CC: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mehmet.fide@screeningeagle.com" <mehmet.fide@screeningeagle.com>
Subject: RE: [PATCH rtw-next 2/2] wifi: rtw88: support channel switch in AP
 mode
Thread-Topic: [PATCH rtw-next 2/2] wifi: rtw88: support channel switch in AP
 mode
Thread-Index: AQHdUBA6dRlhTcKkNEeEr43th8LjJrbmeydQ
Date: Wed, 30 Sep 2026 03:45:11 +0000
Message-ID: <bef3467b008b4bc790ae2baedc1f4625@realtek.com>
References: <20260929124400.3856049-1-mehmet.fide@gmail.com>
 <20260929124400.3856049-3-mehmet.fide@gmail.com>
In-Reply-To: <20260929124400.3856049-3-mehmet.fide@gmail.com>
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
> From: Mehmet Fide <mehmet.fide@screeningeagle.com>
>=20
> hostapd's CHAN_SWITCH is refused because the driver does not announce
> channel switch support, so an AP on rtw88 can only change its channel
> by being torn down and started again.
>=20
> Declare WIPHY_FLAG_HAS_CHANNEL_SWITCH and implement
> ieee80211_ops::channel_switch_beacon the way rtw89 does:

No need to mention rtw89, which you have mentioned in cover letter.

> the firmware
> repeats the beacon held in the reserved page, so while a switch is
> announced the beacon is downloaded again every beacon interval to renew
> the countdown, and ieee80211_csa_finish() is called once it completes.
>=20
> Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>

[...]

> diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c
> b/drivers/net/wireless/realtek/rtw88/mac80211.c
> index 2a9b09fa76e7..915e810470aa 100644
> --- a/drivers/net/wireless/realtek/rtw88/mac80211.c
> +++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
> @@ -164,6 +164,8 @@ static int rtw_ops_add_interface(struct ieee80211_hw =
*hw,
>         memset(&rtwvif->bfee, 0, sizeof(struct rtw_bfee));
>         rtw_txq_init(rtwdev, vif->txq);
>         INIT_LIST_HEAD(&rtwvif->rsvd_page_list);
> +       rtwvif->rtwdev =3D rtwdev;

Move to be first statement of this function followed by a blank line.=20

> +       INIT_DELAYED_WORK(&rtwvif->csa_beacon_work, rtw_fw_csa_beacon_wor=
k);
>=20
>         mutex_lock(&rtwdev->mutex);
>=20


