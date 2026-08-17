Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC747260565;
	Mon, 17 Aug 2026 02:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786935506; cv=none; b=RNju7u2A4fSilTqQ1SxoKUiwj5aLCF4s+2uGU57IXuyHqfeCYb9uQ2kOZj0CNbj5PwrXsPmDVeHswvuIWJQJvmdZkhmbY79TxM1v3Bz7YOvvm9LBIbi6+D5Yl9PcfBVjHcK56m39jDMoL712WaAKiZE4RjlS48dF3I5H5d0YqyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786935506; c=relaxed/simple;
	bh=go/LVtv4LQARUvIj8NO9S1Zn1RrrNgCL2x5+uAYcjcY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oigzsic3atMNk8gQZsC+nOhcwyq4mHKO7bY7zgR+ur1qb4o77EkTA7/w8/fJXxF20m90+q1cG/zK1O9yR9A3fB8S+HsKvqdSkEmnr6nAJD3B8vvXJ9I8qMrkZwgPx5eY0gehiexr10lqcIZW1JIZRPHDZ/ST8U2DUPWn+1vR07E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Ajb+o0ky; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Ajb+o0ky"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67H2wCmtD3468083, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1786935492; bh=go/LVtv4LQARUvIj8NO9S1Zn1RrrNgCL2x5+uAYcjcY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=Ajb+o0kysSWBrnFOyCdlrdUMulQQBc6EvE5cswTJm1S8Cn61nu1huPeEjw2cPWPzj
	 5RJk/jJrBbYuP1tg4bhWAdtNNEak6BwkJgztEqtXMshhXhbVKfOJXhx3HpSyOcf/0N
	 4veLpy2z27NCfYLZvYXVt1aS7AxsHuaAO3GyEBnZ846lv7vZb7ZxrXpf2NEPnfQ/Ds
	 yxUI+wx8iDctf9hz61g7O07IhAHjacVY2ySxGKyf8fdkN6n13Wp+qkcLCW6yHTK31G
	 EFH6QCrmamm1/mdMlLfwoFhGpqshaEsvSB/xwGU6fqBl3JFrCUYEdvqf2TxEBx0p0s
	 IhWRaaXOx6AIA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67H2wCmtD3468083
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 17 Aug 2026 10:58:12 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 17 Aug 2026 10:58:02 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 17 Aug 2026 10:57:58 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Mon, 17 Aug 2026 10:57:58 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mehmet Fide <mehmet.fide@gmail.com>
CC: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mehmet Fide
	<mehmet.fide@screeningeagle.com>
Subject: RE: [PATCH rtw-next v3] wifi: rtw88: usb: route bmc frames via the
 high queue only for DTIM delivery
Thread-Topic: [PATCH rtw-next v3] wifi: rtw88: usb: route bmc frames via the
 high queue only for DTIM delivery
Thread-Index: AQHdK66WOfaBclcfS0e15NhvFyIcILackTUAgAT+nvA=
Date: Mon, 17 Aug 2026 02:57:58 +0000
Message-ID: <f8e94f04e06a4179bac17c2f01529062@realtek.com>
References: <20260814053426.2473247-1-mehmet.fide@gmail.com>
 <20260814063714.2480456-1-mehmet.fide@gmail.com>
In-Reply-To: <20260814063714.2480456-1-mehmet.fide@gmail.com>
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
> Hello Ping-Ke,
>=20
> One more data point that may be useful for the firmware side,
> separate from this patch.
>=20
> While comparing against the vendor driver I noticed a difference in
> how MORE_DATA is terminated. rtw88 sets the bit on every high queue
> frame (rtw_tx_fill_tx_desc(): more_data =3D qsel =3D=3D TX_DESC_QSEL_HIGH=
),
> including the last one. The vendor driver releases the high queue as
> an explicit batch and sets mdata =3D 1 on all frames of the batch
> except the final one, which carries 0 (chk_bmc_sleepq_hdl() in
> core/rtw_mlme_ext.c of the 88x2bu source).
>=20
> On both RTL8822BU and RTL8821CU I measured the high queue draining at
> roughly 3 frames per DTIM with BIT_TCR_UPDATE_HGQMD set, instead of
> the whole buffered burst, so the burst fetch of 076f786a0ae1 does not
> seem to engage on these chips. A never-terminated MORE_DATA chain is
> my best guess for why, but that is a guess; whether the hardware
> needs the 0 to conclude a burst is something only the firmware
> documentation can answer.

By consulting internal people and experiments, the last MORE_DATA is
unset by hardware. So I think we don't need to align behavior of
vendor driver, unless peeking the next frames before sending.=20

Ping-Ke

