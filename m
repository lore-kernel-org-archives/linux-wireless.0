Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91D93EBF0F;
	Tue, 24 Feb 2026 00:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771893976; cv=none; b=fa31fW9nGmarT/wzkVfJIiTYNdlnqDbD2VgHbJX+HLVNzp6PN5TRRaox4zOVrMcvtz6+2vMX8KirRiaFMiDvV7EKnHFzlsFTCI7HNhdOzdVaU+7s+O4YH8pkPQkv0Hfq7aJFLI0WnT1h2MbfJyaz/oXm3Gwlz3wvbxeEQfGaZOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771893976; c=relaxed/simple;
	bh=OetNlqsQvTt9TPOL55A1NMZFeCtcA4T/mzqX72ybvHQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZzqjmkqroS1h0A0rxW+/NbntAkGL5S4a7yU2nwxhG66KUvcQjCtrNjjUMkR2113oaAWZrI0Lux1BVZ1hffq7CQfyTIEviHyETwDiDMz3G0toIdWbReiaWXcwVToJrmIuh62SrkyjuN6LCLMGFCvN36dHj8dCZozf0bdy8ohMP2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=DXshVwtz; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="DXshVwtz"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 61O0k2zkD1987035, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1771893962; bh=HAtt0Riiqplw8xcR2nwEBD6sbH3W7GCQKEVsRSUNc9E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=DXshVwtzB1C1uvY5EpLunP8VTW5vJj8MKLEsee54QW+bEal+oIDwtZRcUH/vDTyna
	 021ZpRVFTWD2BVUt1P98LuLpWxnVmfHmwBOzKoipbjA2SWpmUNwfEsOvDmJ4VNTqAo
	 HPw2PoYuY31I6+l2mBVTMNOp3E3KbZislwGK2HsNv3VMCr+CXb5sOfsvJg8atDI6rI
	 If8mGd16Qst46mJ0r4iS0RG5odLWcrwwWW8Gg2QXXy4Fg5OEe1Y576hMr58Y1KyJ1W
	 RWsx0fm93GcJ+/ykHtFd3V5YIl9BQpPLhXw4HFlpqAgzbFywYnCCUfi6ChN32pDNXY
	 HzflaXNibe7yQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.21/5.94) with ESMTPS id 61O0k2zkD1987035
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 08:46:02 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Tue, 24 Feb 2026 08:46:03 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Tue, 24 Feb 2026 08:46:03 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([fe80::4cbd:6c6c:b92b:3913]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::4cbd:6c6c:b92b:3913%10]) with mapi id
 15.02.1748.010; Tue, 24 Feb 2026 08:46:03 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable
	<stable@kernel.org>
Subject: RE: [PATCH net] wifi: rtw88: properly drop usb interface reference on
 error
Thread-Topic: [PATCH net] wifi: rtw88: properly drop usb interface reference
 on error
Thread-Index: AQHcpLjbvOo/97laWkyK/7R7FXgm/rWRAqJQ
Date: Tue, 24 Feb 2026 00:46:02 +0000
Message-ID: <0a1b75853588468d87725e4d6aad8f22@realtek.com>
References: <2026022333-periscope-unusual-f0a0@gregkh>
In-Reply-To: <2026022333-periscope-unusual-f0a0@gregkh>
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

Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> If an error happens in the usb probe path, in rtw_usb_intf_init(), the
> usb interface reference needs to be properly dropped, otherwise is is
> incorrectly increased when returning to the USB core.
>=20
> Cc: Ping-Ke Shih <pkshih@realtek.com>
> Cc: stable <stable@kernel.org>
> Assisted-by: gkh_clanker_2000
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/net/wireless/realtek/rtw88/usb.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wirel=
ess/realtek/rtw88/usb.c
> index 433b06c8d8a6..36ac20039ce2 100644
> --- a/drivers/net/wireless/realtek/rtw88/usb.c
> +++ b/drivers/net/wireless/realtek/rtw88/usb.c
> @@ -1046,13 +1046,17 @@ static int rtw_usb_intf_init(struct rtw_dev *rtwd=
ev,
>=20
>         rtwusb->udev =3D udev;
>         ret =3D rtw_usb_parse(rtwdev, intf);
> -       if (ret)
> +       if (ret) {
> +               usb_put_dev(udev);
>                 return ret;
> +       }
>=20
>         rtwusb->usb_data =3D kcalloc(RTW_USB_MAX_RXTX_COUNT, sizeof(u32),
>                                    GFP_KERNEL);
> -       if (!rtwusb->usb_data)
> +       if (!rtwusb->usb_data) {
> +               usb_put_dev(udev);
>                 return -ENOMEM;
> +       }
>=20
>         usb_set_intfdata(intf, rtwdev->hw);
>=20

Since rtwusb->udev isn't used right after assignment in this function.
Would it be simpler that moving usb_get_dev() downward like below?

diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireles=
s/realtek/rtw88/usb.c
index db60e142268d..6e5c9c6f3e00 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -1041,10 +1041,8 @@ static int rtw_usb_intf_init(struct rtw_dev *rtwdev,
                             struct usb_interface *intf)
 {
        struct rtw_usb *rtwusb =3D rtw_get_usb_priv(rtwdev);
-       struct usb_device *udev =3D usb_get_dev(interface_to_usbdev(intf));
        int ret;

-       rtwusb->udev =3D udev;
        ret =3D rtw_usb_parse(rtwdev, intf);
        if (ret)
                return ret;
@@ -1054,6 +1052,8 @@ static int rtw_usb_intf_init(struct rtw_dev *rtwdev,
        if (!rtwusb->usb_data)
                return -ENOMEM;

+       rtwusb->udev =3D usb_get_dev(interface_to_usbdev(intf));
+
        usb_set_intfdata(intf, rtwdev->hw);

        SET_IEEE80211_DEV(rtwdev->hw, &intf->dev);



