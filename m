Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B6C3F4126;
	Fri, 14 Aug 2026 07:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786691736; cv=none; b=ZzISRQ4kL1KDmWAY0PCX7ZNOFIbiF5tEkSix27AETeWRa0kCmv1xuEBnUy4s2Q74DdxEwHecwiNoDO5wo2TJKpZnOd75bl8+X4VGRrcnDQH4+GanFcb81W29sI1UXIu50OoHE8b8HbIQgik9pohdTp8szB6LbHWJTG/q8PSRCl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786691736; c=relaxed/simple;
	bh=wxTFad5lWUbjFdpjFYlQDA8ixvvNK8tujfSO/xf2IUk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Wul5WU8m0rimlztA1/aiXop3HDRpDN/uyvyS67lqLtKt8r2NhNqlbrb74BBIx4x9AyymmlcGXOiWeFb4r2n+Dwci6r4bfhlataZdEaj4fZrQFRXTqcJdwDQz9KR3/xg/ypvhPfdBmPXJkvmq/zCLVeUpUfAgpe1XqDN61WOWSjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=TcYjkCP/; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="TcYjkCP/"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67E7FIDs81058995, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1786691718; bh=wxTFad5lWUbjFdpjFYlQDA8ixvvNK8tujfSO/xf2IUk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=TcYjkCP/3/rste8zLn9sISBlKsz5u5gOzVM1mdBugwr7bIC0vXeZeU4fasQX2+04a
	 y8iq9VtuAeJUUw/Z3I3USrRz0jbJtxHsJHwjcYy5L3Ec04qkyoe1VLsBcyRxlp6iy7
	 8rGvagYt63y6UbveIpRQPs9ume55ScecAZWkFddX96988CVdSz9Cjmu1dMUJ3+YYnR
	 RH/yGJlzB4UrFMx1coYESjSnicqc4xm5rhT0pA+lbvIsAN7JVqvFp85vr08PpCJHus
	 4rTepD1atxYqUSLHV6BriDXGWchpOmAkRK3Lb89JGJtTmNY3YvurD5IzoCLrJrIkae
	 vWzMgj1taPJuw==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67E7FIDs81058995
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 14 Aug 2026 15:15:18 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 14 Aug 2026 15:15:19 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Fri, 14 Aug 2026 15:15:19 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "luka.gejak@linux.dev" <luka.gejak@linux.dev>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>, Peter Robinson <pbrobinson@gmail.com>, "Hans de
 Goede" <johannes.goede@oss.qualcomm.com>
Subject: RE: [PATCH v4 1/7] wifi: rtw88: add the RTL8723B chip type and SDIO
 helper
Thread-Topic: [PATCH v4 1/7] wifi: rtw88: add the RTL8723B chip type and SDIO
 helper
Thread-Index: AQHdKXGncbBylyP4pEmjQjs3+DgAC7adJlgw
Date: Fri, 14 Aug 2026 07:15:19 +0000
Message-ID: <11e8fbf079f242a4bc3ad486797a0572@realtek.com>
References: <20260811091203.26841-1-luka.gejak@linux.dev>
 <20260811091203.26841-2-luka.gejak@linux.dev>
In-Reply-To: <20260811091203.26841-2-luka.gejak@linux.dev>
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
> The RTL8723B is a 802.11n combo chip whose SDIO variant, RTL8723BS, runs
> a Realtek vendor firmware that differs from the firmware used by the
> other rtw88 8723 family devices. Supporting it needs a number of small
> adjustments spread across the shared core, all of which have to be
> restricted to this one chip and bus combination.
>=20
> Add the chip type and a helper that tests for it, so the changes that
> follow can be gated without repeating the chip and bus comparison.
>=20
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>


