Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA31C394490;
	Wed, 23 Sep 2026 07:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790149466; cv=none; b=mi52CWpQxoow7fGX1+rkiewErYYfgGiEIZ8fTYRvCjS4Klz0qQqo5+2qkIsLEmXq5yhdIm0p6HMIzgVahgju1Qf9fypBhCJtV8AzhrIjOA8Pfa+YkGH+tIJOYQaETLPMrXBnk1jx685RLQcRkRDyKhkleqfysgEjblIqs8lRxyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790149466; c=relaxed/simple;
	bh=qzhs0Pb5m81hvixzsOg4zduo32BSVgYiO96PJiwHqss=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DYJxghjl5gbdsMCuXZJSojeiiGt/dlbTgsCHR+Do2BjWowTNui8ddvQ9dex/EemaLHdHEXU/co0zJ1j56UApx/7wMpAfcOK8wQe/XCBDCDnjiJIsekMY3gedvKQmlrQo0+g7lAQsiXNn0fr3NJrcTGa1Y6UjxecNlUoMElO+I1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=IRmAWcVB; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="IRmAWcVB"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68N7iAyjD142878, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790149450; bh=flyXIh/kNOVxgLn36qpxOplJyAGQHLViQ5ltaf6ezCs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=IRmAWcVBzlcT1Bett0yjEkMJW/vfNo055tyZZjbexQEaCFzp1gho72CA+MNKiWOUh
	 0zdvWtLQoklUFTidtZOYNOwFKqkY4WII2EgajHFxSxCvMNdNcwRn3IlWsp8QI7y2RE
	 GTwQlfOZarlQEvVnWP3LMLcCGyXh8O3tKyGgnZWuJB/iyeRZm/rgEDYvZ6dajeDNeM
	 1peEtUZ3/Fek+pyixr25kYZzx89cU/fGJR3ztHEdvzcSepULzhuFgR/VjcJDDi3uPu
	 O9g+SsOokdd6ZjD4c5S/eIvRf8bu7IBuTQLzAJ9ni/8S2r2s2NPzpsVxuxSykDhQmG
	 orop70uBbyFsQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68N7iAyjD142878
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 23 Sep 2026 15:44:10 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 15:44:09 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Wed, 23 Sep 2026 15:44:09 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH v3 1/6] wifi: rtw88: 8723b: add the RTL8723B register
 definitions
Thread-Topic: [PATCH v3 1/6] wifi: rtw88: 8723b: add the RTL8723B register
 definitions
Thread-Index: AQHdSeATlhJ4Vg2ZrEeh4i3UA0Ho0rbbyTmA
Date: Wed, 23 Sep 2026 07:44:08 +0000
Message-ID: <cfe927df6a3d4999bf591e491a678f4d@realtek.com>
References: <20260921154347.82317-1-luka.gejak@linux.dev>
 <20260921154347.82317-2-luka.gejak@linux.dev>
In-Reply-To: <20260921154347.82317-2-luka.gejak@linux.dev>
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

Luka Gejak <luka.gejak@linux.dev> wrote:
> Add the register offsets and bit definitions the RTL8723B driver uses:
> the power and system function bits, the BT antenna and control
> registers, the packet lifetime and MAC ID drop registers, the FPGA0
> HSSI and RF switch control registers, and the RFE antenna path
> registers.
>=20
> These are split out from the chip driver so the driver patch that
> follows is easier to read. Nothing references them yet.
>=20
> This depends on the shared core handling sent as a separate series,
> "wifi: rtw88: preparations for RTL8723B/RTL8723BS".

No need to point out dependency in commit message. If it is needed,
add it after --- as note.=20

But as you have based on rtw/rtw-next, the patchset is merged already.

>=20
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>

[...]

> @@ -301,6 +308,8 @@
>  #define REG_HMEBOX3            0x01DC
>  #define REG_LLT_INIT           0x01E0
>  #define BIT_LLT_WRITE_ACCESS   BIT(30)
> +#define REG_RFK_FW_ACK_8723B   0x01e7

upper case 0x01E7 as existing ones.

> +#define BIT_RFK_FW_ACK_8723B   BIT(0)
>  #define REG_HMEBOX0_EX         0x01F0
>  #define REG_HMEBOX1_EX         0x01F4
>  #define REG_HMEBOX2_EX         0x01F8

[...]

> @@ -606,12 +624,20 @@
>  #define BIT_RX_PSEL_RST                (BIT(28) | BIT(29))
>  #define REG_TXPSEL             0x080C
>  #define REG_RX_GAIN_EN         0x081c
> +#define REG_FPGA0_XA_HSSI_PARM2        0x0824
> +#define HSSI_3WIRE_ADDR_LEN    0x400
> +#define HSSI_3WIRE_DATA_LEN    0x800
>  #define REG_CCASEL             0x082C
> +#define REG_FPGA0_XB_HSSI_PARM2        0x082c

upper case 0x082C

[...]

> @@ -683,6 +713,7 @@
>  #define REG_RX_IQC_AB_A                0x0c10
>  #define REG_RX_IQC_CD_A                0x0c14
>  #define REG_TXSCALE_A          0x0c1c
> +#define REG_B_RXIQI            0x0c1c

I'd say upper case too, but existing ones are there. Just ignore this.=20

>  #define BB_SWING_MASK          GENMASK(31, 21)
>  #define REG_TX_AGC_A_CCK_11_CCK_1              0xc20
>  #define REG_TX_AGC_A_OFDM18_OFDM6              0xc24
> --
> 2.55.0

