Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04672D2486;
	Mon,  5 Oct 2026 03:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791172451; cv=none; b=eOtmWdeDIE0Nb42C1itadptCKdgGG2pF4igKnv9Tp1GaT7UjiuFcpSMvHa0VSuGQ32ifNopPi6h0bZokG3TYVNZiN1jzbHH4jLYGP89uPVOPblFpWxWfeALltu6Q4SiKx9+qgjekx8+BYsCcrjdlbCa0PBTwePv+aFOvN3ZWa0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791172451; c=relaxed/simple;
	bh=2yTBh4d/7D0Ufp3zCoBBJSuFLWQE26DmbYwy66w+zz8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HjUy7jxgZDrI+wO+vnL10CsKgCqp7mPBDeWsiOQiGHD/9bcxPML5zG0PF6r+VXp+Z7gAtXUXkh/brRKKGioEEsiYS4Q7XcfvHg7o8Hn/kvgK+FHiSLv+nJcQex9eVaRwtUMyTTrNM7msURiTjXAm5eu9BLHkp6f39y9gMqSjPrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=JVHUdrbU; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="JVHUdrbU"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6953s1g151637855, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791172441; bh=2yTBh4d/7D0Ufp3zCoBBJSuFLWQE26DmbYwy66w+zz8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=JVHUdrbUSsoMngZJ2bcLvK535g0jhv1RtAhUotV2IPYGWrhrgId/cd9bmN0WdkUGV
	 NcPSapwu4K6t1Ep1Qn5n682nOO1TVF5BJ1h7QJbwdwQHwSzHBTQJTse+v16t3KvUCj
	 1fNOWbgLSY7gq2t42wHNhk56ZC7Un86TnqkUVfJQd/3dVi+Lt7mVI1v9mdm6P3wm7h
	 YIjlgI3r3btPIAZOtARv8+g69XL8SCW18FeipISZ4Ga164cUkjoJ4T1y78LqPT0H+n
	 XFYxniIZDYdvhYPt9PA2WkiFrrhGef/w2s7bvA7Vt1CmjvclqSGeo4ViNNagf3lCUx
	 HiaV2i3BvNp4g==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6953s1g151637855
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 5 Oct 2026 11:54:01 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 5 Oct 2026 11:54:02 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Mon, 5 Oct 2026 11:54:02 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH rtw-next v7 2/6] wifi: rtw88: 8723b: add the RTL8723B
 register definitions
Thread-Topic: [PATCH rtw-next v7 2/6] wifi: rtw88: 8723b: add the RTL8723B
 register definitions
Thread-Index: AQHdUkEbYxjvVd4z4UiiuvxY5rTTmLbuVbQg
Date: Mon, 5 Oct 2026 03:54:01 +0000
Message-ID: <8b3e2b9887ed420d8ef020f650d011f2@realtek.com>
References: <20261002073845.31486-1-luka.gejak@linux.dev>
 <20261002073845.31486-3-luka.gejak@linux.dev>
In-Reply-To: <20261002073845.31486-3-luka.gejak@linux.dev>
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
> Add the register offsets and bit definitions the RTL8723B driver uses,
> including the power and system function bits, the BT antenna and efuse
> control registers, the packet lifetime and MAC ID drop registers, the
> FPGA0 HSSI and RF switch control registers, and the RFE antenna path
> registers.
>=20
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>


