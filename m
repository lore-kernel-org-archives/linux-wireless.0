Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE8B3BB127;
	Tue,  6 Oct 2026 07:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791272946; cv=none; b=L2TXn16Uwd9vD5ZqqxQxY6OCAhZs+MHGQz1aHbth1QzJnW5RfRx2sXqwTSmUx/6xPADyDmDcfhHrOhruSfhAFP0ObHvk0pkABODQ+Sc5hcoguQvNBDL59zAXRkuOBpJ/c61TFc9pA0vw5T1LH8UPuwOICDxQ8E2OcAhxa/Yp3XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791272946; c=relaxed/simple;
	bh=FHFQoeXdiic9xZmTfhZvmlAOznZhtz8pOXnmnU2RQYQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SyrjeQEaCKG9NugU4R+fp1PvbBHv6fBhZDI9J7ySF6p/owPjbC6xMnctAe58o02EnOEPitx/PDE8+sYtMhss8EOSgLq7HRqDZU29S4bST4Y1G1uZIH+i48xqFmxDSaWCAAD0hBE9Y+A9i5yvh9HU06MQnfzSwXGExcEalnv8t54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=tXvW+VPa; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="tXvW+VPa"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6967mhTbB2739958, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791272923; bh=FHFQoeXdiic9xZmTfhZvmlAOznZhtz8pOXnmnU2RQYQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=tXvW+VPaX5i4G4mE5DDzsOYnG26kt9A9rjhGvMOi3o9Ozvx+GVBDxyrgH27r8MJ+O
	 C9+KYfFhc5fePjRs+rhPyHcqYq0WBeZH+IFt0VuRe2+aT/uhQ2WQnyfaYjGV9B7N5G
	 SW0ev8kx4rvPuuTlu8ILdFcgE2XAAkvmtEEtaujdmiJaCdTttyJ8kHFikkHiSmKue/
	 L/UIeRMVvVcUKDEyYSWyQmlrOQjfcNKFo5Ek3bxRljexRvPQSC2YxgwFCkRjeWbDJG
	 EGfl+r/3O/7lsBvn4p/LrhbgoWivm68ACLNgK9FxSKOtBAHD8Bb+pCvW5sMXPcN2Mz
	 SgCPVP2b4l6lA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6967mhTbB2739958
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 6 Oct 2026 15:48:43 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 6 Oct 2026 15:48:43 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Tue, 6 Oct 2026 15:48:43 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mehmet Fide <mehmet.fide@gmail.com>
CC: Luka Gejak <luka.gejak@linux.dev>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mehmet.fide@screeningeagle.com"
	<mehmet.fide@screeningeagle.com>
Subject: RE: [PATCH rtw-next v3 0/2] wifi: rtw88: channel switch in AP mode
Thread-Topic: [PATCH rtw-next v3 0/2] wifi: rtw88: channel switch in AP mode
Thread-Index: AQHdVNZ4ts6N6Jh3bEeUdjVzehzxzLbvrnEA///vXYCAAIZpcA==
Date: Tue, 6 Oct 2026 07:48:42 +0000
Message-ID: <df3ec647010848f6a1efc9f23baf9ed0@realtek.com>
References: <b6c8d3f63f7e40fa8b515352cba19541@realtek.com>
 <20261006074629.372782-1-mehmet.fide@gmail.com>
In-Reply-To: <20261006074629.372782-1-mehmet.fide@gmail.com>
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
> On 2026-10-06 Ping-Ke Shih wrote:
> > If you have something changed, you should not carry my acked-by.
> > Or, point out the reason you can.
>=20
> You are right, sorry. v4 drops it; the only change since the version
> you acked is the initialisation of the beacon pointer in the caller.

Yes, I did aware this after reviewing patch 1/2. So feel free to carry
my acked-by to v4.=20

Ping-Ke


