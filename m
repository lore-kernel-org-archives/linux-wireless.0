Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D63F1CAA78
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 08:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786955224; cv=none; b=hrd8tyv3oOB059A2cvBLjUJuZDt63mjUWOhoUQiaUx4Guxwj6rX1kjOj117Ybwtx1eaRhpfKwPV+vX7jYrwHMX3QMw5Bt0zIPfPTO4KiOq0kbbVnXhGMrV/KvturaJ66zCtuyn2ZoF3aK4SyETlf+JHncIHM1BFvjLszggrGUqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786955224; c=relaxed/simple;
	bh=MYsvUAJvFImpVmef9frGgt1BmbcgF1g+k6dFUxWrsTM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=frS11C4OIWr/T6W6njk/zRCCuiURmY0O4J93XI9I1uLwDjAH5J7phK6e1Rm0ZyoD2a19WhwbZ+fGdqhS8K7sNuN5NeOnZc2SK0HEJeT3I7y43AexwdVFr44RNzk45wz6kmp24QBpPWht79Ts4JsYOZs7J+ruCLsjsCHaj6Zv+FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=hrgocaes; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="hrgocaes"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67H8QpotE3789150, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1786955212; bh=C5g0G5vKG7d6DVnMi4zm85FHCbopGpzwta8RljnRpjA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=hrgocaeskGpAJIkfJrksYng01NTwprQVZKDhCIGJRgesg3fMOVu6aH22Sg5fiLhwB
	 +zbjQUwKdLhEOCaAOrVVFIQ9GGqiquCpO18Y2c+jYCON2nBpJgFK4GqNE4glFNkMb6
	 QcKX4Tjlsucg78aOResNznsTd8xnIKW59PaeyOSV7CPTJd4VYj4S2r5FUNpJzAjBYU
	 aU/yW3luE3WQ4/gaAep1OYjQ1lvZmEI5Bh3KqlpSi1SyUMNV7lYATFvlKoYhUqlW71
	 OYIsufg5e84Udh+PZSEKAE6JUV8sUUD3OnUmKofdcZfT+Xk45wUGWIQSWPc7L2qfDh
	 1E7fMeSHhYuog==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67H8QpotE3789150
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 17 Aug 2026 16:26:52 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 17 Aug 2026 16:26:51 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Mon, 17 Aug 2026 16:26:51 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mehmet Fide <mehmet.fide@gmail.com>
CC: Mehmet Fide <mehmet.fide@screeningeagle.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH rtw-next v5] wifi: rtw88: usb: do not log transfers lost
 to a mode switch
Thread-Topic: [PATCH rtw-next v5] wifi: rtw88: usb: do not log transfers lost
 to a mode switch
Thread-Index: AQHdLhJYPuWDmYKjg0mdnjKdNCJ00rah6BCQ
Date: Mon, 17 Aug 2026 08:26:51 +0000
Message-ID: <65592e1112b24b09be4382ea90d52e20@realtek.com>
References: <20260817063319.389188-1-mehmet.fide@gmail.com>
In-Reply-To: <20260817063319.389188-1-mehmet.fide@gmail.com>
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

Acked-by: Ping-Ke Shih <pkshih@realtek.com>

