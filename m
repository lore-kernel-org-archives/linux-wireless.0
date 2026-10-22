Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.151
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792645895;
	b=xQLQMwuO7XaHin06qkb73Uefx43/OWqzqHPXpEcxcJPZRDNxUGBBq8ISi/wH6D2fUdhs
	 sDg1rnVHfsbSrEnJY6MjIbSYIlE2F96aylRUutIHCWtt1pEjfuRBL7W9XQkC+rDlL22F3
	 PQ+jPo0A6bwOwJTMZvLHGXzGwUM6i66QHKi+/0fDWXuVdSE3DO7ry1yh5p/pVz5FXS9Jz
	 plaLEcZuKzJkjAJomtw9BeY1tt62Z7wEhNuAvm/L/eNdWqFHdQDIT8qRZsP984yqvcUXg
	 AbaWlqEWw0zTRCpmgj5ughwrVsOlyvOPt2akjTD+RsdCec1Akqg4HsNLnYEZxwJuWfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792645895;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:MIME-Version:Date:Content-Type:
	 Content-Transfer-Encoding:From:Message-ID:TLS-Required:Subject:To:Cc:
	 In-Reply-To:References;
	bh=5OZ+Kj7XZIEzQyiU4CaO1Gddo3vfB4kFN1ReAFchqBQ=;
	b=BHvO3RmJb+G81wL56fmFmDdm0vQgx82gL1Rz5ToAkY/al7/yZXf80w/cqOBXe5lTjjqi
	 WCmu8qGsKYcNtDDSA0iUU5YlnhOXYTMId8Y8wYeTHL41Wh9wD1x/1pmu8GVb3chvyZydw
	 SqvzNGlrXPeyUSEXJf3bq1pBoynajiCx/AJoVlUcPS2wrt9FQIiVOT1+ZaCvJN9uFIouv
	 7nzfLRsdz75QQT9lg9+FUSmN0hhryf2odztzKqtIGyK30Pv2CSGAHNnn48EddfieBBONB
	 j5ykFZ//jAD1zaJ7YcICDCkOypVG4syMWGJMbs78lxw1NRRmnmKvbyXgmTtgL/4SoIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=e872zD8u;
	arc=none smtp.remote-ip=91.218.175.151
Received: from mta0.migadu.com (out-151.mta0.migadu.com [91.218.175.151])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80879606A325
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 05:11:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 80879606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=e872zD8u
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=InhJfSz01rUKTol/lM0gWPgFnxmwPY+9AlzLND0Wegk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792645891; v=1; x=1793250691;
 b=e872zD8ujaBv4dBpjErQtfc8MUM3K7Wo+wqUHsVlinKpiNepMgiJgO9Beg2Wis6mkNqTjLNf
 v3313iLrRzMd3V2QKay+AnvoFU45KjB6QuMy+xzcHTTmZk/ejLiWir9L042EDOiiwQC2oLV5AOW
 m/rFXg9HaVorjbqVb70YXgI0=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 7c1dde27cdf14590;
	Thu, 22 Oct 2026 05:11:31 +0000
X-Mizu-Trace-ID: 7c1dde27cdf14590
X-Migadu-Flow: FLOW_OUT
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Thu, 22 Oct 2026 05:11:27 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <5235fd68b703f756cc2ee1e7471339a512db59b8@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next v2 1/2] wifi: rtw88: move the bmc high queue
 decision to tx.c
To: "Ping-Ke Shih" <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <ac6d8824bdeb45148ffd6b5dee7da313@realtek.com>
References: <20261021124318.15993-1-luka.gejak@linux.dev>
 <ac6d8824bdeb45148ffd6b5dee7da313@realtek.com>

October 22, 2026 at 4:20 AM, "Ping-Ke Shih" <pkshih@realtek.com> wrote:


>=20
>=20Luka Gejak <luka.gejak@linux.dev> wrote:
>=20
>=20>=20
>=20> USB decides in usb.c which broadcast and multicast (bmc) frames may=
 use
> >  the high queue. SDIO needs the same decision, so move the helpers to
> >  tx.c behind a single exported rtw_tx_bmc_use_hiq() and keep the budg=
et
> >  state in struct rtw_dev.
> >=20=20
>=20>  No functional change.
> >=20
>=20By my review, I think it doesn't change logic at all, but I hope if
> someone can help to test USB devices to confirm it still works well.
>=20

I=20ran the same test with rtl8723du and there is no regression.

Best regards,
Luka Gejak
