Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062D157C9F
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 01:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784511141; cv=none; b=TZBY4tmTRfeRTmMkSkLUbNtLS1IYoYcy1djezRzPg++0CtM37+I/QKoQcGn1fhfzsMtzyV7/C1as/eSowofjrfOiRNSNfsKTvsR8BuAfftXienGlai7+6fUl3U/sF4UMWBx8KIDjXgtoqhDfQSO2Z8CUWqcFW5M7i8WkfJFwbRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784511141; c=relaxed/simple;
	bh=SJhVikg0W48uyvU20BGtMfjTBTlr6TTujFwctoROICE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nptTBoTAtPSdnv32UjIVJoJ2lLBgCtZxkxZ7nOjk/t4HyLgrOvCHxlkp0ao202jID8rhVlhCQHoKlJs18QFBx6mhS2ZJG6qcrmoR1rk2DOWUAlxUDqXws4o44fcn5ZreRTH/XtS8tpT+J6hgpv8PjbTL5PJilwEKOiZVWQkHfeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Aqt0jXas; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Aqt0jXas"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66K1Vtt662082723, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784511115; bh=Eq1MdNSPYuGelvumB9KCOSTq9slampyHeK18z/v5fUo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=Aqt0jXasUA5PfyAonIC5oA3mbwOQlOnZDqdjacNl/LdtQ8lAnkjwPB56UaIyojQmj
	 2+jYVx7Ccm1RL8C/v7twdBpxZ8CjCbfWkw3N4Co1vMcsHqwRg4BDoDmFaXIqbFDyo8
	 ampCDFo8lkriiLrxC2OBn1JtPDLFL4h93n4f2wzd/NhG1RryyUide6F67a04LY+VVW
	 osIAMAIFCVY+h9QRGerU1aEHWxIutsSqcicZ0zSQ7SaupMbyhwjaHt59j6T3OwLXtR
	 V7tW1kfmkuc9wqwGZjtRpNlqCMvPQ5Hp6RzMmdBQ5sX7yJ/Pg/HzK1NREWVvE0Ncv5
	 Oc3t58FOfPIqA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66K1Vtt662082723
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 20 Jul 2026 09:31:55 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 20 Jul 2026 09:31:54 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Mon, 20 Jul 2026 09:31:54 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "luka.gejak@linux.dev" <luka.gejak@linux.dev>, "linux-firmware@kernel.org"
	<linux-firmware@kernel.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] rtw88: add firmware v41.0.0 for RTL8723B
Thread-Topic: [PATCH] rtw88: add firmware v41.0.0 for RTL8723B
Thread-Index: AQHdF6iIRMUpMZ62skKcRyubJgLa1bZ1nxpw
Date: Mon, 20 Jul 2026 01:31:54 +0000
Message-ID: <9e5ea4e2cf52446fb05ce66c0413d6fb@realtek.com>
References: <20260719180033.66867-1-luka.gejak@linux.dev>
In-Reply-To: <20260719180033.66867-1-luka.gejak@linux.dev>
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

luka.gejak@linux.dev <luka.gejak@linux.dev> wrote:
> From: Luka Gejak <luka.gejak@linux.dev>
>=20
> Add the RTL8723B NIC firmware image used by the rtw88 driver. Support for
> the RTL8723BS (SDIO) device that uses it is being added to the mainline
> rtw88 driver.
>=20
> The image was extracted from the Realtek "rtl8723bs" vendor driver,
> version v5.2.17.1_26955.20180307_COEX20180201-6f52, from the C array
> array_mp_8723b_fw_nic[] in hal/rtl8723b/hal8723b_fw.c, using the
> convert_firmware.c tool. A public copy of that vendor driver is at
> https://github.com/MocLG/rtl8723bs-5.2.17
>=20
> The image reports version 41.0.0 and is covered by the existing Realtek
> redistribution licence (LICENCE.rtlwifi_firmware.txt).
>=20
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>

I checked firmware binary with official release. They are identical.=20

Except to a nit below,

Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>

> ---
>  WHENCE                |   1 +
>  rtw88/rtw8723b_fw.bin | Bin 0 -> 32272 bytes
>  2 files changed, 1 insertion(+)
>  create mode 100644 rtw88/rtw8723b_fw.bin
>=20
> diff --git a/WHENCE b/WHENCE
> index 6cfe142d4e91..b4b7e6acda1c 100644
> --- a/WHENCE
> +++ b/WHENCE
> @@ -3352,6 +3352,7 @@ File: rtw88/rtw8822c_fw.bin
>  File: rtw88/rtw8822c_wow_fw.bin
>  File: rtw88/README

Why not putting rtw8723b_fw.bin here in alphabetic order?

>  File: rtw88/rtw8723d_fw.bin
> +File: rtw88/rtw8723b_fw.bin
>  File: rtw88/rtw8821c_fw.bin
>  File: rtw88/rtw8703b_fw.bin
>  File: rtw88/rtw8703b_wow_fw.bin


