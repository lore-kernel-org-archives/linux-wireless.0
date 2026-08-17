Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B347E379C4E
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 05:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786945144; cv=none; b=JCbHlsEmRwnHIblUntuLMl+lYyEpuUmSbSrMqJEVu3NLh8yfqAjGeiU0An7mDJe9Xw0wCNrLnix1FkJfTpk65I511wMeRlbBY4629lwREm9rt2+y2xrhVdp2/krifLgTyauJyNrcpwn7FJZT5IXdBgYidsQ4hIPcjaiRrKFp7UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786945144; c=relaxed/simple;
	bh=N1MUVCZRk+JnihPhSQrWFGKRrA06WF7Pa450bPU36Zk=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kcb8PgwxjQs+O439TR+l612N2iyq2af1BeUlgshl2tFuYVMuOM337U2/fa8FlmGyG7BiWJrbqMnT1NMfioAvAUkIpK2xRrLyPUxX4FA6v8tO4oFud0/0j1Hr9kaitnW0h8yUv1sPuG/PlZFaT+KPwNofqL9J8NxqLCFx+o6e9iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Nx7aODtr; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Nx7aODtr"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67H5cwlaF3674103, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1786945138; bh=nyH4LTYKekB0phlEltwsEtmCkVuE/1yMiswuvtjR3Po=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=Nx7aODtrRAciDu0LqA41kreZkTdyZ1ko5xHkvjNF2aLsOJDQ8+QZDXoHom027xS4D
	 354ht2o4ewJgJW/O+eWpPiGrklWz7KXFDH4ZTYq8zGMNBsu/W0s+N7nZIX8F33MiFZ
	 +3Br2mAc6e4KhJ/11wg0ckmdi5a9G+EjaVyVZzqnXlsVX+0HcL61FFkq9vJXGr+oqb
	 Fw/g5Qm00nHkY3ljscRIea5m4uiNN6YOGVvZT6YSwZB987oRRU0j05qSqQCNoSaWd+
	 93ELeI9VUmFmZ0xH9zAXUfapqJ0BZ39So9jIhHz1fiNCu4gr8qMxipuewU/+rlcCyt
	 9FhqSQlb0Z32Q==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67H5cwlaF3674103
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 17 Aug 2026 13:38:58 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 17 Aug 2026 13:38:58 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 17 Aug 2026 13:38:58 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Mon, 17 Aug 2026 13:38:58 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mehmet Fide <mehmet.fide@gmail.com>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
Subject: RE: [PATCH rtw-next v4] wifi: rtw88: usb: do not log transfers lost
 to a mode switch
Thread-Topic: [PATCH rtw-next v4] wifi: rtw88: usb: do not log transfers lost
 to a mode switch
Thread-Index: AQHdLgWc8m0HmR+85EyqGCmj8+WIs7ahuMgw
Date: Mon, 17 Aug 2026 05:38:58 +0000
Message-ID: <025be0cbb3e14d6e9a32be33d107c234@realtek.com>
References: <20260817050227.363362-1-mehmet.fide@gmail.com>
In-Reply-To: <20260817050227.363362-1-mehmet.fide@gmail.com>
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
>   rtw_8822bu 1-1:1.0: rtw_usb_reg_sec: reg 0x4e0, usb write 1 fail,
>   status: -71
>=20
> Nothing is wrong here. The device re-enumerates, probes again and registe=
rs
> normally, which is why rtw_usb_probe() already treats a non-zero return
> from rtw_usb_switch_mode() as "Not a fail". On a USB 2 only port the
> switch can never succeed, so the message returns on every boot and
> everyone using such a port has to work out that it is harmless.
>=20
> Mark the window in which the chip is expected to leave the bus and skip t=
he
> error reports for transfers that fall into it. The mark is a rtw_flags bi=
t
> set in rtw_usb_switch_mode(), so it covers both the new and the old switc=
h
> sequence, and it is cleared again right after them: the transfers that lo=
se
> the race are issued from inside the sequences, and anything that fails
> later must be reported again.
>=20
> Tested with an RTL8822BU (0x7392:0xb822) on a USB 2 root port of a TI AM6=
2,
> where the message appears exactly once per boot. With the patch both line=
s
> are gone while the disconnect, the re-enumeration and the second firmware
> load are unchanged.
>=20
> Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
> ---
> v4:
>  - track the window with a RTW_FLAG_SWITCHING_USB_MODE bit in rtw_flags
>    instead of a bool in struct rtw_usb, clear it unconditionally right
>    after the switch sequences so later failures are reported again, and
>    drop the comment block in usb.c (Ping-Ke Shih)
>  - Signed-off-by switched to my work address to match my other patches
> v3:
>  - set the mark in rtw_usb_switch_mode() instead of in the two switch
>    helpers (Ping-Ke Shih)
>=20
>  drivers/net/wireless/realtek/rtw88/main.h |  2 ++
>  drivers/net/wireless/realtek/rtw88/usb.c  | 22 +++++++++++++++++-----
>  2 files changed, 19 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wire=
less/realtek/rtw88/main.h
> index c6e981ba7..fc3fb617c 100644
> --- a/drivers/net/wireless/realtek/rtw88/main.h
> +++ b/drivers/net/wireless/realtek/rtw88/main.h
> @@ -377,6 +377,8 @@ enum rtw_flags {
>         RTW_FLAG_RESTARTING,
>         RTW_FLAG_RESTART_TRIGGERING,
>         RTW_FLAG_FORCE_LOWEST_RATE,
> +       /* USB mode switch: the chip re-enumerates, transfers may be cut =
off */

As we didn't add comments for existing enumerators, add the comment in USB =
code
if you actually need this. (I think no need though)

> +       RTW_FLAG_SWITCHING_USB_MODE,
>=20
>         NUM_OF_RTW_FLAGS,
>  };


