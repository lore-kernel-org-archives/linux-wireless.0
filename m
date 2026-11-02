Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793590114;
	b=L/qVP68Cptf6zX9LHNpAjU6LWhY+sD24WodcJ9lFpZJ017ociCj1giPUtz+HjKf7MxFW
	 CFAGMLEXacH/STLk1s9x+WwF0b/P6y67ENRX7rZ0D+s5rv3JiEw5U8YHL1tgGOXuD3HMm
	 npKEhEZMJVjFjp9r5RNHNdx4RF88bx/eUJO+7KZYzyMDbYYfqXZxa6gPuS51R2n7WWxV0
	 sP+N+pchAGjnhJnrMqp0tyyY1juTk33fDPaxSMMXA0IKFJu4FCrtiH8OywwK5a7miNKlP
	 ZFGKyVFrCd5QBtj2FZeYbrYBZLojq5tZOsPCfucObwFCMgqBRXoZwrgULSsAPV5S7BQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793590114;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:
	 References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=AsyZ2rRSDNzE0zB4SNUDz4Q+VubPg3NirSbzcFzF+zQ=;
	b=cw9ub6V2+om4b3NSmfSZWxGQBNqRAqEFpUHMrqkOf5l1h6FtUcbqAm0pN3y6GBDUwI2W
	 kFBeHV2E/68PyGWzETywmAu3wHPK8JSw/HpFy0T7lDqwNLteq1wPBQggp4KptJ2+piCJD
	 93iFhRC0OtwR6vjjb+AW4jQcnM0UEHr+UuC0dcjd19/T2nA8IgPuDaSwjLY81x+WEc/jE
	 DUcg9rpPe6j9jDy1KEjcl2ABFoerXjR0MCotNLZ26iXMJuiHGyQAzt3bMMvMIQVtFNoBG
	 a6kzJbITpH77p9R+fsiR99eJZaXn6dxbpuWymXeW91Uvjpmfcc0blVyOf1NN3hn4YPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=FvBy+aII;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4E4606A324;
	Mon,  2 Nov 2026 03:28:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2C4E4606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=FvBy+aII
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A23SQVg81819896, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793590106; bh=AsyZ2rRSDNzE0zB4SNUDz4Q+VubPg3NirSbzcFzF+zQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=FvBy+aIITEiu5MYgGLDhJ+G/7NJhogsuVBBahzwso578UE0Ce1zj3sAXuO8PJ97A0
	 NSrA4MBU99wxLATDc0Xb33nF98jKSlMUvl8f2NiB8+yGHP0pOmuXWHgUzP0CjO5Vda
	 0AOpDUMxLOmTPDgsOwsO+A+WRkT0mOd+6aM9oo8U4ftRn/MficKZixBKAUklHodUc4
	 ZUHiPIRjkRGx2GFgBdj5Km8uY1sIQ17uaGBE7jEo6rjFJxwcG4Cg0BU6F/HCvc7R0p
	 ad4dZ7hRl6EvLDDjXJr5Zal9TX94vO9VKypd2/2jE6a0jRuVhlWjyz3572WZH/gPpH
	 y+JS2udgzcHQg==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A23SQVg81819896
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 2 Nov 2026 11:28:26 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 2 Nov 2026 11:28:26 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef%10]) with mapi id
 15.02.2562.056; Mon, 2 Nov 2026 11:28:26 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Rosen Penev <rosenp@gmail.com>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
CC: Zong-Zhe Yang <kevin_yang@realtek.com>, Kalle Valo <kvalo@kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH rtw-next] wifi: rtw89: acpi: check for _DSM function
 support before evaluating it
Thread-Topic: [PATCH rtw-next] wifi: rtw89: acpi: check for _DSM function
 support before evaluating it
Thread-Index: AQHdak/ux0lhlq5WtE+cZkh8fkWQOLcaHI1w
Date: Mon, 2 Nov 2026 03:28:26 +0000
Message-ID: <ebd3c83183464c3e9c218337a568b59a@realtek.com>
References: <20261101222535.34573-1-rosenp@gmail.com>
In-Reply-To: <20261101222535.34573-1-rosenp@gmail.com>
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

Rosen Penev <rosenp@gmail.com> wrote:
> When the WiFi device has no ACPI companion, or the firmware does not
> implement a given rtw89 _DSM function, rtw89_acpi_evaluate_dsm() calls
> acpi_evaluate_dsm() anyway. ACPI core then warns on every probe:
>=20
>   ACPI: \: failed to evaluate _DSM e8c3a8d2-694b-004f-82bd-fe8607803aa7 r=
ev:0 func:10 (0x1001)
>   ACPI: \: failed to evaluate _DSM e8c3a8d2-694b-004f-82bd-fe8607803aa7 r=
ev:0 func:6 (0x1001)
>=20
> Here the handle is NULL, and acpi_evaluate_object() returns
> AE_BAD_PARAMETER. All callers already treat failure as "no policy
> provided by the platform", so this is only noise.
>=20
> Use acpi_check_dsm() first. It returns false for a NULL handle and for
> functions that are not advertised, so absent functions fail quietly at
> debug level, as rtw89_acpi_evaluate_method() already does.

The acpi_check_dsm() is to evaluate func 0 before actually accessing func.=
=20
I'm not sure if all platforms will implement func 0. Do you know that?

>=20
> Seen on an RTL8852BE in a desktop PCIe slot.
>=20
> Fixes: e897b0bef38a ("wifi: rtw89: introduce realtek ACPI DSM method")

Does it need a Fixes? As I see, this is not a bug.=20

> Signed-off-by: Rosen Penev <rosenp@gmail.com>


