Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC68358D32;
	Tue, 24 Mar 2026 01:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774315068; cv=none; b=Ls3mOpBUHxHZ7EXCBicLKktdH7FEnoz1TEIu5s48jtO9VVJv1FY3iIVrtVqWzwiedbWee1QGO69ioIxlZot/D01nHD6Stz33rhg7jksCyELiep4AKSqd8midfgBa0T2F68tOwFeR3xJWtrMdZKy2gIi8auk47QiR3Hkm+22W64w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774315068; c=relaxed/simple;
	bh=xUnql6cRHxgqOqVWZlIRiwB9+m3bK+fivNYECPY83Do=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QvApTEbnnLZyLF54JqGuhxmMG40aWdj8NeZea2+8jy7ppAajNtbJ7ZDv8J7zjI0wtgr/4HfQlGity9DFt0CcYOUZwDVeCb0gRp+q7vh8VrrlvB6KEQXNUnbQz2XiqN/N5SZR7vCcl+Ue8Au3fJ2B184i2zOkZqbin9GBOCm1/Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=jR3vSV6k; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="jR3vSV6k"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 62O1HMBu8112662, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1774315043; bh=xUnql6cRHxgqOqVWZlIRiwB9+m3bK+fivNYECPY83Do=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=jR3vSV6k4jRvS9ELV5BBV76z40twdmUR11DJtGWKaIYFIxJPLXkB28HhrALOdq0R5
	 vQOTI4T4LLkFwCNynLFM/QKkQmxq7Hi1pB7Ei6fjfaH6KArxVVMBESwnD+mYHJMWjV
	 XcSd8BP440UtI842AYABf7VKZj3aJhoYHniTXw01RD/6/Jfkj7aqDsv8KcKLUtOGpV
	 aVsmUyYdQwpYEM1K7wXsH3lFcltydUU9o4wBa6Gb3mRnrRQVyTOgNU3Asyv4f4+kwl
	 YCeSK9WqQxqQ3+GpRzDKuDhij30oX2gVM1b6Ynom180xQCdM/9iKwN6nMApzfu07y2
	 uAvdsQMESXP5A==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.21/5.94) with ESMTPS id 62O1HMBu8112662
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Mar 2026 09:17:22 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Tue, 24 Mar 2026 09:17:22 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([fe80::4cbd:6c6c:b92b:3913]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::4cbd:6c6c:b92b:3913%10]) with mapi id
 15.02.1748.010; Tue, 24 Mar 2026 09:17:22 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Alexey Velichayshiy <a.velichayshiy@ispras.ru>
CC: Yuan-Han Zhang <yuanhan1020@realtek.com>, Kalle Valo <kvalo@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: RE: [PATCH rtw-next] wifi: rtw89: phy: fix uninitialized variable
 access in rtw89_phy_cfo_set_crystal_cap()
Thread-Topic: [PATCH rtw-next] wifi: rtw89: phy: fix uninitialized variable
 access in rtw89_phy_cfo_set_crystal_cap()
Thread-Index: AQHcutAxHZqLH9mRjkyI0/skoVvqkLW84jFw
Date: Tue, 24 Mar 2026 01:17:22 +0000
Message-ID: <56455e8ac1f84b708084bc7f90f5b3c1@realtek.com>
References: <20260323140613.1615574-1-a.velichayshiy@ispras.ru>
In-Reply-To: <20260323140613.1615574-1-a.velichayshiy@ispras.ru>
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

Alexey Velichayshiy <a.velichayshiy@ispras.ru> wrote:
> In the rtw89_phy_cfo_set_crystal_cap() function, for chips other than
> RTL8852A/RTL8851B, the values read by rtw89_mac_read_xtal_si() are
> stored into the local variables sc_xi_val and sc_xo_val. If either
> read fails, these variables remain uninitialized, they are later
> used to update cfo->crystal_cap and in debug print statements. This
> can lead to undefined behavior.
>=20
> Fix the issue by initializing sc_xi_val and sc_xo_val to zero,
> like is implemented in vendor driver.
>=20
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
>=20
> Fixes: 8379fa611536 ("rtw89: 8852c: add write/read crystal function in CF=
O
> tracking")
> Signed-off-by: Alexey Velichayshiy <a.velichayshiy@ispras.ru>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>


