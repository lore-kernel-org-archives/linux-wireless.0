Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9128299943;
	Thu, 13 Aug 2026 00:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786581683; cv=none; b=CVkNAvjpU2ZH8sM8mhb1TqTkD3qwSzs6lN8i/OMvDpTjr0Ld3w/IEQeNPWAIs5fVfgK2A5nlUDAo5L8b0kSQdjivmEiFMVdVwz8gJ2zvE778MYF3SM3fMgmYHmAf7R1KKaKz97wHxyusffNoEv1jwt3IG4BazzoGjW9BJ5KzvhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786581683; c=relaxed/simple;
	bh=bWWM/EWDy2rdcaaTh+2pmtIvJK9xay0B+nDH13scp/M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RULL3HezbWFVGh0/l71Sly9aj5ar2UxAV3ERvLUaRtwxngrezK3c2IxK8pv4ofhw3YwTmdgnPqGfKSbe3LiDDMR0JT7UZMJTRpQf+p5/JOWx8MZ3yXu0nfk4dX0WRxkNpKEH1+XaokFk6WNxYMYigTHlm85A2xvqQLNRlRBE3PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=eWXrzSHq; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="eWXrzSHq"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67D0fGGn94034208, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1786581676; bh=/Gv9Ap14ndZkF6dQPGfexOhFDzGpmA8bIa75e7Pxv7M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=eWXrzSHqq8KnXsAznuG5Mr34MK89Vg2ABTwlPHY0F1/M4H27NT/Qqn8sWtDXJcfCW
	 ECe+EoNgMxBePUxAWGgrAVN0lRCjAsIRgdhAK7AWGpCxyo2fwpIn60sj8cAGQ3gobh
	 Z1WfGDZhHzjOutm+BApGUhcYbQFyQG5vhCOiUyhpv9DadAjSIrRg3r9v+REwfCYnXC
	 SiyL01mBY4mYuuAn5jr3vE1L4rMAGLIRjIke77TuJZElRPYTgYfI/WMaMQTYzUfzio
	 1qZzbFV1Fn/ZLyvm1c+1xR/KdwHK9oI1Uwo/R6F25TvAF491rUPNClgIfH/q1MGKFR
	 RqNdYa2EzKr4w==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67D0fGGn94034208
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 13 Aug 2026 08:41:16 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 13 Aug 2026 08:41:17 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 13 Aug 2026 08:41:16 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Thu, 13 Aug 2026 08:41:16 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mehmet Fide <mehmet.fide@gmail.com>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH rtw-next v2] wifi: rtw88: usb: do not log transfers lost
 to a mode switch
Thread-Topic: [PATCH rtw-next v2] wifi: rtw88: usb: do not log transfers lost
 to a mode switch
Thread-Index: AQHdKoCI2hW/7AeWXk2Wz2ZCDDBU/babIvIw
Date: Thu, 13 Aug 2026 00:41:16 +0000
Message-ID: <72ff0d793d61415eb9fd1c513abdcc5a@realtek.com>
References: <20260812122858.3317577-1-mehmet.fide@gmail.com>
 <20260812173215.4090278-1-mehmet.fide@gmail.com>
In-Reply-To: <20260812173215.4090278-1-mehmet.fide@gmail.com>
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
> An RTL8822BU or RTL8822CU is asked to come back as a USB 3 device by
> rtw_usb_switch_mode_new(). The chip powers off its MAC and leaves the bus
> while the last control transfers of that sequence are still in flight, so
> they complete with -EPROTO and the driver reports them as errors:
>=20
>   rtw_8822bu 1-1:1.0: Firmware version 27.2.0, H2C version 13
>   rtw_8822bu 1-1:1.0: write register 0xc4 failed with -71
>   usb 1-1: USB disconnect, device number 2
>   usbcore: registered new interface driver rtw_8822bu
>   rtw_8822bu 1-1:1.0: Firmware version 27.2.0, H2C version 13
>=20
> Register 0xc4 is REG_PAD_CTRL2 and the access losing the race is the
> rtw_write32_set() that ends the switch sequence, a few milliseconds befor=
e
> the disconnect. Which transfer gets caught varies from boot to boot: 0xc4
> is in the "always on" section, so every write to it is followed by a seco=
nd
> one from rtw_usb_reg_sec(), and sometimes that is the one that fails:
>=20
>   rtw_8822bu 1-1:1.0: rtw_usb_reg_sec: reg 0x4e0, usb write 1 fail, statu=
s: -71

How about changing to use WARN_ONCE()?

[...]

> @@ -1098,6 +1098,7 @@ static int rtw_usb_switch_mode_old(struct rtw_dev *=
rtwdev)
>                         rtw_write8(rtwdev, REG_ACLK_MON, 0x1);
>                         rtw_write8(rtwdev, 0x3d, 0x3);
>                         /* usb disconnect */
> +                       rtwusb->switching_mode =3D true;
>                         rtw_write8(rtwdev, REG_SYS_PW_CTRL + 1, 0x80);
>                         return 1;
>                 }

[...]

> @@ -1151,6 +1153,11 @@ static int rtw_usb_switch_mode_new(struct rtw_dev =
*rtwdev)
>         rtw_write32(rtwdev, REG_PAD_CTRL2, pad_ctrl2);
>         rtw_write8(rtwdev, REG_PAD_CTRL2 + 1, 4);
>=20
> +       /* From here the chip powers off its MAC and re-enumerates, so it=
 can
> +        * leave the bus while a control transfer is still in flight.
> +        */
> +       rtwusb->switching_mode =3D true;
> +
>         rtw_write16_set(rtwdev, REG_SYS_PW_CTRL, BIT_APFM_OFFMAC);
>         usleep_range(1000, 1001);
>         rtw_write32_set(rtwdev, REG_PAD_CTRL2, BIT_NO_PDN_CHIPOFF_V1);

If WARN_ONCE isn't suitable, move these two assignments to caller.
I think only set `rtwusb->switching_mode =3D true` only if the return
value is 1.=20


