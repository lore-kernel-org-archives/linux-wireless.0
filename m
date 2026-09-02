Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780AE343D9D;
	Wed,  2 Sep 2026 01:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788312147; cv=none; b=oXwd8ghtZ2rIZqkRLl89UMgu0Sj4e6fNgEXcQKmljtCtVzeEVRmSNdFnXKEs06I1XrwQ+BbROHNYk5zSd+wBcEpsIh9W3TmbBnAA0Wsazyo8OIAQCD/ELXd/jkS0fPDNo/bEs4MtD1MSgXvBHMKqaaf6PaCaBOZbOVa14dQGTf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788312147; c=relaxed/simple;
	bh=5PnUx2nE3UNmaLS+bLdkhV1ANeaCBATNyLWNFwTT4KQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RWPna/7jvwnWKlTFWVIOikblzT3jwYbGAsbothl7qG5DJ2jUvQh0VkL9x+S/PKoySjkLfJv9q26Dup1WIY0SCL5bD9XbB5R+TibK7oyAfv9EEx1zGJrkK/ouvG7KS8zFD0ee69rLSt6u74J//dDh34lEwXf8xLH6xcwQNJ859HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=akhgtygh; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="akhgtygh"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6821MFwtC2212040, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788312135; bh=yh0oxiqUtWIyAs+sQaX50i8WERvCzlu5W42z4mfDHEY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=akhgtyghRz8lZEqKjFgjjvIkF/+p0nrXZtk7XkjnZ3yBXOH4HcVlxNWEWsVzUQ81B
	 cr1jPGotznhrZaoUHMM350Y1OPbBzXRv8bhwu6PgxHZ4aewWxBcQ96CQ4oFcnfzt1k
	 gxy0au0bVx/eJ8G7904fn0pXgN7rS6wtHkEhAI1/mxGYH/BAqNXZKhpYqT5RnY4woe
	 56e6jYCP48JjAYzMliK7GBOaZbIAYDaV37DxgE0inUvz0e9qVPCVqkFtmVc5UZUpnl
	 0N5QAAFE8BJjkLjthXvwbn5XmKMKLgQSMN4S00XYomD6A8k46oWziIv9uMyzf/Upvf
	 EVf53R/969TSQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6821MFwtC2212040
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 2 Sep 2026 09:22:15 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 2 Sep 2026 09:22:15 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Wed, 2 Sep 2026 09:22:15 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: YuChia-Kan <raspberrykan@stu.hqu.edu.cn>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] wifi: rtw88: use firmware MAC address as fallback
Thread-Topic: [PATCH] wifi: rtw88: use firmware MAC address as fallback
Thread-Index: AQHdOg/rKigchPTsY0+A+iPeLR6Lhba6fQxQ
Date: Wed, 2 Sep 2026 01:22:15 +0000
Message-ID: <4d1e5555bad84badba213f11b431c762@realtek.com>
References: <20260901124551.3921506-1-raspberrykan@stu.hqu.edu.cn>
In-Reply-To: <20260901124551.3921506-1-raspberrykan@stu.hqu.edu.cn>
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

YuChia-Kan <raspberrykan@stu.hqu.edu.cn> wrote:
> Some devices provide the Wi-Fi MAC address through firmware instead of
> storing a valid address in the chip efuse.
>=20
> Try to read the MAC address from firmware before falling back to a
> randomly generated address.

Please share the board and WiFi chip you are using.

>=20
> Signed-off-by: YuChia-Kan <raspberrykan@stu.hqu.edu.cn>
> ---
>  drivers/net/wireless/realtek/rtw88/main.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wire=
less/realtek/rtw88/main.c
> index cd9254370fcc..b9d8e0f5d15e 100644
> --- a/drivers/net/wireless/realtek/rtw88/main.c
> +++ b/drivers/net/wireless/realtek/rtw88/main.c
> @@ -2060,8 +2060,12 @@ static int rtw_chip_efuse_info_setup(struct rtw_de=
v *rtwdev)
>         efuse->ext_lna_5g =3D efuse->lna_type_5g & BIT(3) ? 1 : 0;
>=20
>         if (!is_valid_ether_addr(efuse->addr)) {
> -               eth_random_addr(efuse->addr);
> -               dev_warn(rtwdev->dev, "efuse MAC invalid, using random\n"=
);
> +               mac_ret =3D device_get_mac_address(rtwdev->dev, efuse->ad=
dr);

mac_ret isn't declared.=20

> +               if (mac_ret) {
> +                       eth_random_addr(efuse->addr);
> +                       dev_warn(rtwdev->dev,
> +                                "failed to get valid MAC address, using =
random\n");
> +               }
>         }
>=20
>  out_disable:
> --
> 2.53.0

