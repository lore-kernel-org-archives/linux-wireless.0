Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742CA36197F;
	Wed,  7 Oct 2026 02:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791341844; cv=none; b=LnKRD5Nbw+P91xrYGhz+9Z0tz6Z9M54SHwlZ0clh7tLQQls2Gop/57jqT3Z9nQJ7Gfm7pTFXNNpQcEBBsIgFvZM1B3ksGTx6Tz3BM4rqA+JaRaqF1iCp9mPYIu/zMBgkoIcTgzNwKTljTpGEU9rG01Mf6Fylx6cRCNPq/N8CBt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791341844; c=relaxed/simple;
	bh=jjtWjwD9Wv6yms9R/f3JJhd9ji380NLRK6EK6XjSzzg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=s58t4eOlQNrjT0UYkGMoQqDmqOYZJIYqkM/yKMfOe8gJz3rcRpwFZTKh4Sof4xftZaBQVK5RVHk+YzfH0zMSg+QWpK+Ml8YyIXol8RkHyxWQAFvn9F1qtCidkP+/eeGfsvBhKeZvLqoxDm1BIIUI0wN8Rh200UTN8FAXO1Uhaic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=ZYssBkPU; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="ZYssBkPU"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6972vC7Z13478707, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791341832; bh=jjtWjwD9Wv6yms9R/f3JJhd9ji380NLRK6EK6XjSzzg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=ZYssBkPUMejBLkRU1XQ4+7Kea+/8cUHXSQWuv7ooGjbAh4k/MWTZyvHk4XKni4pC3
	 AIDb3J+r5SDQrV7NDUS7oCx6KqpVdlf6nRHihCX94uLaWT+FbCEXzBcIIiHyECTjNE
	 F7nGbCSF8Ys1j/bj5cG3NnFp1BhiwfghLM93l+5gwa8OuL6rpo4R2LtARrbpIFkaha
	 0sTeft3aoB5/g8U1OTdKru+B4IbRAnm+fgu/4z7cSR8C3k0SqaKZRnJGSTzPo/GFY+
	 D1RZhYC0QDBlTo7eo1tNCx7PokOSiUX9RNs/UTPVpx8ysPZQay9grwgi+Ul2Vq8slG
	 uNLfHXrAl1klg==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6972vC7Z13478707
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 7 Oct 2026 10:57:12 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 7 Oct 2026 10:57:12 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Wed, 7 Oct 2026 10:57:12 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH rtw-next v8 5/7] wifi: rtw88: 8723b: add the RTL8723B chip
 driver
Thread-Topic: [PATCH rtw-next v8 5/7] wifi: rtw88: 8723b: add the RTL8723B
 chip driver
Thread-Index: AQHdVZOkAJbLY4OQZU62Znwke6F4RrbxY8UA
Date: Wed, 7 Oct 2026 02:57:11 +0000
Message-ID: <3db085e6c3c14545ac9fd4221e0715ed@realtek.com>
References: <20261006130701.120460-1-luka.gejak@linux.dev>
 <20261006130701.120460-6-luka.gejak@linux.dev>
In-Reply-To: <20261006130701.120460-6-luka.gejak@linux.dev>
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
> Add the Realtek RTL8723B 802.11n chip driver: the chip operations, the
> power sequences, the efuse layout, the RF and IQ calibration, and the
> chip specific coexistence handling.
>=20
> The RTL8723B chip support is based on the initial work by
> Michael Straube <straube.linux@gmail.com>.
> Link: https://github.com/mistraube/rtw88/tree/rtl8723bs
>=20
> Co-developed-by: Michael Straube <straube.linux@gmail.com>
> Signed-off-by: Michael Straube <straube.linux@gmail.com>
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> Reviewed-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>


