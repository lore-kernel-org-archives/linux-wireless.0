Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F8C3451B2;
	Mon, 27 Jul 2026 02:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785118171; cv=none; b=Pw+iBpQKPoophg6xqmKvaZj4rOYlz3V7ax/RHPNicqC5vqYExPKar7Qn/v7cyXUVg3bopB0/bcjubysRzX17vUVWDz2gKAHv1F6qx7NCVrNl5JTvfsS8xGx0oSEghkYdqaoMv7YXFh9Bn8D2BbC8ny6yfBs4sDAwVjIB4v+0RIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785118171; c=relaxed/simple;
	bh=Kj0OIH8JwIHeQBVxErMpaIpfC0RuImMMvJyBUuI9ruU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aydXs0/SLnI9BUZoZPHzW2ZymH30IQzobcHQMde+moXMfmmL17NlWYQVnzNPE49bzC8n4g3y3DEZM2L3WtCVmzNNVFnaiI41XInePyc99QJrVe/74yp+kzpyRZN55v2eezDNzMdN7/im9kci6jb6PfUw5WxOi3FkXJ/LsyChOTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=X0qnaTzI; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="X0qnaTzI"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66R29QlqC2756421, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785118166; bh=Kj0OIH8JwIHeQBVxErMpaIpfC0RuImMMvJyBUuI9ruU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=X0qnaTzI/dStSJB9POPSnpIMfbqe7ToJDpHmbiSE8KB9d7No+mxekdl7NQkEcy8U4
	 1+OL92gxeuSoDsxLV/vHS8XNHSSPMg37jnwWmV09UG4kGgM8rV0NrPmP5aGHxx97HV
	 Qb7lzpg6Ek9b8xBHsBGY7XBj/rPsLdehlP+WCPn3etVLNBmSs0LoxnIMxo5a0PVy3g
	 xayYwMLwMCoEJda8hyMVuX2uaYG2z2YMkr0Tsds7XMj3WYW5Asp8lzdS8MkQhfUEPV
	 G77ibYBunn2E5qnhtCg1pGxBDUc76FYGrn4LmIo4L5Ni5W2ZmglAL8whVeBghNtDFM
	 cKIJ7/9W+sh/g==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66R29QlqC2756421
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 10:09:26 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 27 Jul 2026 10:09:25 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Mon, 27 Jul 2026 10:09:25 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>, Sang-Heon Jeon <ekffu200098@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH rtw-next v2 1/2] wifi: rtlwifi: rtl8821ae: remove
 conditional return with no effect
Thread-Topic: [PATCH rtw-next v2 1/2] wifi: rtlwifi: rtl8821ae: remove
 conditional return with no effect
Thread-Index: AQHdHQRccTWbR+yjzUO4+qCV+SikebaAnn5ggAABCcA=
Date: Mon, 27 Jul 2026 02:09:25 +0000
Message-ID: <278a0e98f19847368eb40c330f39b10a@realtek.com>
References: <20260726134034.1385834-1-ekffu200098@gmail.com>
 <20260726134034.1385834-2-ekffu200098@gmail.com>
 <a46d352db44243d0a18e2312d614cde1@realtek.com>
In-Reply-To: <a46d352db44243d0a18e2312d614cde1@realtek.com>
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


Ping-Ke Shih <pkshih@realtek.com> wrote:
> Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> > Both branches of the check return the same value, so the check has
> > no effect. Remove it and return the value directly.
> >
> > This is the result of running the Coccinelle script from
> > scripts/coccinelle/misc/cond_return_no_effect.cocci.
> >
> > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
>=20
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>
>=20

For the record, I'd make subject more specific:=20

wifi: rtlwifi: rtl8821ae: remove conditional return with no effect in _rtl8=
821ae_llt_write()

