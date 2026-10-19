Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA913FCB11
	for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 03:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792381788; cv=none; b=dXPTGU5uQWU9slfSbLOg/irazkEbtLYlJwLGYifYBOegjczVhaAAWfj4dpsjLsh+yLeUbIbaxvQ53WAPiNh3HJSP//bJpGT0wZyfVhUXhwNu2pC3DhaDRBkEzQQpDunjl3V3pCuzSUuIWlqx6bNEQgc+OnOCm6+yNHvsfzvmSaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792381788; c=relaxed/simple;
	bh=oBSPRjQzK7K/RxQ4MbHI0L7hMP/2ngmmaUv7oD9zDpg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Jmw7X0aJEIRtG+buejwlSsiWxy44OzDbJ/x2rB/tUmQBeldyc0kTAe6GVsxL4z+0mL8fywaYNYwOQIGGyNyBOWDZg9JIVrJ2FWtP6yzEAjVlAOJUsO/DSGa4gItSk10PUBnrFKCmcIVnhalHEuHDhq5u+kTJep5FZ3W02ld28cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=awDi4GkJ; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="awDi4GkJ"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69J3ng8mB1541442, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1792381782; bh=oBSPRjQzK7K/RxQ4MbHI0L7hMP/2ngmmaUv7oD9zDpg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=awDi4GkJOd8+80p7yCEe8UeyN3UPKRG68Xm2HzZlrgq3aC4I+jOg2S93HmZmcfd6m
	 7KCk0K5y6eQndzUjNxTJpWKWCNa3s6IU4e71kQn9Eu41M/BHXKQ0PYkRJ0FlNzBCpb
	 h0WtkxR8Z/DJmHWuSPXdGJV+vBlgbi4zz2VnFZFJkyJxHiMbXDVWNQraguM+L6y+ab
	 1kxt9EG4OU93R4YSbt1Lc4UKP6krvPc4r8H95ZRy3lfbyNLihrjTnJDD7WNUsY//e8
	 krUvqZf8Apmf5ueEHlZQDcnU02nbBlfw3/l4JUyw1PCSsy38xSOKnp3HFrXpEmLE1m
	 cjwgBlcGTf21A==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69J3ng8mB1541442
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 19 Oct 2026 11:49:42 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 19 Oct 2026 11:49:42 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Mon, 19 Oct 2026 11:49:42 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Josef Schlehofer <pepe.schlehofer@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH rtw-next] wifi: rtw88: 8822b: Relax ETSI EDCCA threshold
 on 2.4 GHz
Thread-Topic: [PATCH rtw-next] wifi: rtw88: 8822b: Relax ETSI EDCCA threshold
 on 2.4 GHz
Thread-Index: AQHdWcFxat/dhNE39UKu1e/6QfZW+rcERYmw
Date: Mon, 19 Oct 2026 03:49:42 +0000
Message-ID: <a73283377ebe42d4b383553bb8f714c1@realtek.com>
References: <20261011204509.46062-1-pepe.schlehofer@gmail.com>
In-Reply-To: <20261011204509.46062-1-pepe.schlehofer@gmail.com>
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

Josef Schlehofer <pepe.schlehofer@gmail.com> wrote:
> The RTL8822B has no firmware-managed adaptivity, so rtw88 sets
> the EDCCA thresholds in the driver. Under ETSI, the current rule
> uses L2H =3D min(IGI, 36), at most about -74 dBm.
>=20
> On a TP-Link Archer T4U v3 (RTL8812BU) operating as a 2.4 GHz AP,
> in-band energy, mostly from the adapter's own USB 3 link, kept IGI
> at 0x2a and L2H at 36. The AP was not seen in any of 5 scans, and
> the driver reported "failed to get tx report from firmware".
>=20
> With min(max(IGI + 8, 48), 50), the AP was seen in 4/5 scans on the
> same port and boot (16/19 across repeated runs), with no TX report
> failures and no change in the false alarm rate.
>=20
> EN 300 328 V2.2.2 tests detection at -70 dBm/MHz for a 20 dBm EIRP
> transmitter, about -57 dBm over 20 MHz.
>=20
> Use the normal threshold, max(IGI + 8, 48), on 2.4 GHz under ETSI,
> capped at 50 (nominally -60 dBm). Keep the existing rule on 5 GHz
> and in JP.
>=20
> Signed-off-by: Josef Schlehofer <pepe.schlehofer@gmail.com>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>

[...]

> +/* nominally -60 dBm: 3 dB below the EN 300 328 level at 20 dBm e.i.r.p.=
 */
> +#define RTW8822B_EDCCA_ETSI_2G 50

For the record, I consulted internally that the hardware isn't very accurat=
e,
but with 3 dB reduction, it should be fine.=20

