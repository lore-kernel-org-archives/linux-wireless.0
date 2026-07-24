Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F351A267;
	Fri, 24 Jul 2026 00:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784853468; cv=none; b=RwhhsYdL8fZl3/ca+s3JyIWxPs+Mw+I05OHhZMPg1mipLBMm6yTJZmD8ylEXEqegf1f9or9hNDXZFxGJr00k1Or4dD1FVGUPGPPmmoA/0swX9SRUx86+9pk9IBCbPF38H6sVWa+OSSZBw76PEcHzC3tocK/bdo/cEFf8orBfky8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784853468; c=relaxed/simple;
	bh=yAkBQkGP917ea0m/xgChipsLcVWIVsuA/VDBpFxhr80=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NcWDnbskWXnGBIRsjblO1H5xZiu04C5lgy3Mdrxz1zly+rzQSNm8jaSfKumpDlTSFn1XMq0qSvLBw4GIV/G7fIsXnsMIHBpJbNsWFk6TeK2CjBD8NgcYK8AmkVD+8xDx2aE/6vJ173AXHrPIpkNxF4I0y9CwGp4mq81sXGPgzA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=fGUEI+X2; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="fGUEI+X2"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66O0bT9S1826679, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784853449; bh=/cbDgo598TG5qpJ+4KpyIoA1nOSul4eORvYLw5ziO6o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=fGUEI+X2awwxTvIvI9o1faUIHtXkiFeS1W0ENcZ/eIOUAGn62S/Af/IptcDqtBNqf
	 IdDDnnAJkZ+sQiXUX81iBuempnsKbEQv3OLcYMpRlnQML05bg/HDqLRNjVcWkBLHzF
	 O9yhku6/luy9Z9AtH94HONouCswAmYB7Ko+CZ3yZyFgxLuI2BsZtBwav677PFMbSt1
	 Wudy70OJkV9Ale5QvvxDZ9MJabEe+0vyc/cMvBd+Xxcz1eafZ2fglFG+ThepDUwOko
	 ZNkqtRXb3MRy2lbO8XiR8CLs9RZNy6/FM6B3hdqQNYF7HcmI/8VEhgS0aUJVZw+wSk
	 U72qaiujDcGiw==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66O0bT9S1826679
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 24 Jul 2026 08:37:29 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 24 Jul 2026 08:37:29 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Fri, 24 Jul 2026 08:37:29 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Sang-Heon Jeon <ekffu200098@gmail.com>, "Julia.Lawall@inria.fr"
	<Julia.Lawall@inria.fr>, Miri Korenblit <miriam.rachel.korenblit@intel.com>
CC: "cocci@inria.fr" <cocci@inria.fr>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
Subject: RE: [PATCH 10/36] wifi: remove conditional return with no effect
Thread-Topic: [PATCH 10/36] wifi: remove conditional return with no effect
Thread-Index: AQHdGtORMhfc1QA3FUeQ8RJ/kmVgbrZ70qMQ
Date: Fri, 24 Jul 2026 00:37:29 +0000
Message-ID: <3c36ea4acf0545a28f8c64dd49539cc6@realtek.com>
References: <20260723184538.3888637-1-ekffu200098@gmail.com>
 <20260723184538.3888637-11-ekffu200098@gmail.com>
In-Reply-To: <20260723184538.3888637-11-ekffu200098@gmail.com>
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

Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> Both branches of the check return the same value, so the check has
> no effect. Remove it and return the value directly.
>=20
> This is the result of running the Coccinelle script from
> scripts/coccinelle/misc/cond_return_no_effect.cocci.
>=20
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---
>  drivers/net/wireless/ath/ath6kl/init.c              | 6 +-----
>  drivers/net/wireless/intel/iwlwifi/mvm/link.c       | 6 +-----
>  drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c | 7 +------
>  drivers/net/wireless/realtek/rtw89/mac.c            | 6 +-----
>  drivers/net/wireless/realtek/rtw89/mac_be.c         | 6 +-----

Can you split into four patches for ath6k, iwlwifi, rtlwifi and rtw89?
Then we can apply the patch to individual tree.=20

Ping-Ke

