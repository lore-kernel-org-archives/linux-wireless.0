Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FB738886C;
	Mon, 12 Oct 2026 03:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791777596; cv=none; b=X3mFLEa0xqfhIiWgblpK0Rt9tgMYOkwTcopVBRlxFHqnEQWz93JSHDspsMqfmxZB5qPspG9PWdfo6ggPMQl3s+P+KYnOpYsl1R99ubfi1gtp7H49OzWcUvRqn0OvLo/bYBomI4l8w5NWfxtUjc7rAsvAOuS4PrEpDbPUFAd4c1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791777596; c=relaxed/simple;
	bh=6tD5pWr/nI+zGO7Mr38CulMpfmjbMxCzW6qlRqCuq+g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qZ5SsR/raGmDOjJEimh+bMoX/KbO6bEpFsr9UdkEKG5rGmkLRcnPBKgo5SNEKN0kN4IqhO3232DhgHkU/KUAPlE/9IxQvlY3Z7Wl8cILy9TRF8PJKjmtYi8oMLB+08I0ERCMD0nBgmDtd5qY3T0lpmg7mm4dgQhYRTtPyJy/Kp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=ef8Z1zFY; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="ef8Z1zFY"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69C3xZBS13513802, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791777575; bh=kiw+yQoMw54B9PpEaiHyaIJtNSd5TZmkvUfNzYr1QWs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=ef8Z1zFY61jjLb/47+J5KEv9QMIwj0olI4QRoXKlZ7+sWEfzIrTevoAgU09hqiXhT
	 m31aBRgsz7j96+mUJJKzA8DElFK6Wss0Cy4d3WQs4KlBFPv5W5y8f4nDjgJqJgcv9D
	 WzeC1Y/0iBsLUT+XYW58cecSyS0YrWeGEVLP0Elkv079WaChOdZjN54ggeMh2WhwjZ
	 o4BPsfYFjAGnrlNtEnvEVxS0eW4e4o/fTLy6NIs0MG+6Krr89enCn05rnwC5PM7OaT
	 Hq9y+eXuwaL9dB9jvhg+phuE/AkRr+2Qdm1BCqyqjt/k6DZzapD+AP+Kc55jAX+O7S
	 Y4JX9yCbuws8Q==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69C3xZBS13513802
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 12 Oct 2026 11:59:35 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 12 Oct 2026 11:59:42 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 12 Oct 2026 11:59:41 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Mon, 12 Oct 2026 11:59:42 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mehmet Fide <mehmet.fide@gmail.com>
CC: Luka Gejak <luka.gejak@linux.dev>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mehmet.fide@screeningeagle.com"
	<mehmet.fide@screeningeagle.com>
Subject: RE: [PATCH rtw-next v5 3/3] wifi: rtw88: support channel switch in AP
 mode
Thread-Topic: [PATCH rtw-next v5 3/3] wifi: rtw88: support channel switch in
 AP mode
Thread-Index: AQHdVu2otJ4gzEp6PUKgbnI6arP2KLb5SMNQ
Date: Mon, 12 Oct 2026 03:59:42 +0000
Message-ID: <04b18579ec644839af3d5baa1790618f@realtek.com>
References: <cover.1791362281.git.mehmet.fide@screeningeagle.com>
 <ab6a510713267fee446e511c87d5b162827353fb.1791362281.git.mehmet.fide@screeningeagle.com>
In-Reply-To: <ab6a510713267fee446e511c87d5b162827353fb.1791362281.git.mehmet.fide@screeningeagle.com>
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
>  void rtw_fw_update_beacon_work(struct wiphy *wiphy, struct wiphy_work *w=
ork)
>  {
>         struct rtw_dev *rtwdev =3D container_of(work, struct rtw_dev,
> @@ -1811,7 +1840,8 @@ void rtw_fw_update_beacon_work(struct wiphy *wiphy,=
 struct wiphy_work *work)
>=20
>         mutex_lock(&rtwdev->mutex);
>=20
> -       if (!test_bit(RTW_FLAG_RUNNING, rtwdev->flags))
> +       if (!test_bit(RTW_FLAG_RUNNING, rtwdev->flags) ||
> +           rtw_fw_csa_active(rtwdev))

As my comment in patch 2/3, I think we should cancel the work at core_stop.

>                 goto out;
>=20
>         rtw_fw_download_rsvd_page(rtwdev);

[...]

> @@ -438,6 +443,8 @@ static void rtw_ops_bss_info_changed(struct ieee80211=
_hw *hw,
>                 rtw_set_dtim_period(rtwdev, conf->dtim_period);
>                 rtw_fw_download_rsvd_page(rtwdev);
>                 rtw_send_rsvd_page_h2c(rtwdev);
> +               if (conf->csa_active)
> +                       rtw_fw_csa_start(rtwdev, vif);

Is this a necessary case? Can't rtw_ops_channel_switch_beacon() handle it?

>         }
>=20
>         if (changed & BSS_CHANGED_BEACON_ENABLED) {

[...]


