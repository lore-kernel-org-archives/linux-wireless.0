Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869BD2DBF75;
	Mon,  5 Oct 2026 03:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791172366; cv=none; b=qXr7Q0Y4Fi5PYbycOF7v5FuFXxu2CIvTrGLGJ35BOUZ2GtD4nlcJ4oIJOUhsJ5yoTLPpFdlP4BFHtqMMpIYb1qql5veeAW+IHI6ym9fCQqOMduIrgro+72bA15tyS1Bx4rVvKO+T6eQxaECRo59QHT40uS4FA9fIMOuUejv/NXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791172366; c=relaxed/simple;
	bh=gj2Q63oPtFso+XeBpiIFiPM5yt4cZbQGRxdWWVz6NDU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tpYpy/LbiNvo7C8H9QHlbI5x0RXNL1A7l2HVCwne7JZA14bM2OELU9DuqZEX99Zun6HzR7ULKU4lfIycDgF4bEH8tVY1qPy7QoV6MquOcmj46Xm7ho5rJrhjqniDpCQIhcBocfxZel9ExwZDQNFzXjT4tygBO909kwbN0j/hvUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=dBVrtRSi; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="dBVrtRSi"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6953qVz451637530, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791172351; bh=gj2Q63oPtFso+XeBpiIFiPM5yt4cZbQGRxdWWVz6NDU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=dBVrtRSik2PFqQpVwNaS8dHM1Ra+rBZ2I+RYkuQM0aW8Ochzt50op4Mjvxr/TY/9r
	 6YarELFruiXOWpHB83aKdxhT6D3FvJR3UIyzwf/dDnidSld7OeTANb8lnLuzMvpn86
	 8FSbRSvEkj68oN72DjNrCjCUNTgkJGYQLNNED9rMXZvnYO6faK4gEtyYSFHGZeNWx6
	 kRS9QKIIHcjqCTLdLj3im/4uJ8+bLCLwYrB3qLkLJDvdaCA9YAdN0hkj0pe8awD3CB
	 V9UR2Ufrvjs5Q9xx4iCqp21mFZIQt+M7bWf74qNh/v/Jov5JvfHggGtNjI2Hdma4ub
	 6iG+eV4rjN62A==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6953qVz451637530
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 5 Oct 2026 11:52:31 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 5 Oct 2026 11:52:31 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Mon, 5 Oct 2026 11:52:31 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH rtw-next v7 1/6] wifi: rtw88: move the 88xxa CCK power
 detect setter to phy.c
Thread-Topic: [PATCH rtw-next v7 1/6] wifi: rtw88: move the 88xxa CCK power
 detect setter to phy.c
Thread-Index: AQHdUkEbSpKjEj961E6omv5P2xqefbbuVPDg
Date: Mon, 5 Oct 2026 03:52:31 +0000
Message-ID: <a1348f5983584cd1a80a27d408825fe5@realtek.com>
References: <20261002073845.31486-1-luka.gejak@linux.dev>
 <20261002073845.31486-2-luka.gejak@linux.dev>
In-Reply-To: <20261002073845.31486-2-luka.gejak@linux.dev>
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
> The CCK power detect setter in rtw88xxa.c programs values that are not
> specific to that chip family. The RTL8723B wants the same setter, but
> pulling in the whole rtw88_88xxa module for one helper is not worth it.
>=20
> Move it to phy.c as rtw_phy_cck_pd_set(), where the rest of the CCK power
> detect code and the level enum already live. rtw8812a and rtw8821a call
> the core version, so rtw88xxa.c no longer provides it.

Like this patch, you just move the function, no change logic.

Please add "no logic change at all" to commit message.

>=20
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>


