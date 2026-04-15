Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C2B21CA13
	for <linux-wireless@vger.kernel.org>; Wed, 15 Apr 2026 05:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776232502; cv=none; b=OYE0zzyhUNYZWds09mPfdQRBW0eBl3FdHbUm+lGdlUlbtZNK1S2q2AOCrWThTYkneeh6A1n2m1JTUkK7Xo8dga7ymc2dy/7rQWoxikZa3eJchL0nQ+S0BmDP6Loa43lQdrI7RhbpZ5M7UBHkblKa863KNkZ5mUBK2Fd2U1wIa1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776232502; c=relaxed/simple;
	bh=85SoIJ780slGkzhHF/3pf8UWmlL+WKaG3yj+7nz7IWQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lDb64GrWxooawQfAgi3bNQbyUncmQ9I4zXU1ZqPWTluAB4Cd3PCFJLoJRScIcAOQaa2dp60CEQU+ykY7Qtp3yswLt1fbINBGvObxesxAliZIjPnE8JfI1iMfY2CyqZloHtCF+0VoqXdH87a5AyB6CMABdejlxW2Y4AdxGuQYHuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=PuQFk5oh; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="PuQFk5oh"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 63F5svwgF3498410, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1776232497; bh=85SoIJ780slGkzhHF/3pf8UWmlL+WKaG3yj+7nz7IWQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=PuQFk5ohs5W1i3uNF/e/6RyxkVnsSd5jPOJOFpiJILlcZsiuMtNL+Y4yGxxl1vKy9
	 UpgNk52CXAzgM9Ojg9G+vGn5Tu80wc97tZ8YdecUSBC1qYpXqIHIlZxax1zt4wzDU1
	 X2ZzUOtZOuZ3T9qg/9DzacFnJhkO0uqXL+S4Kbaljewx+S7b6fw7GHoktD2iI/s6pt
	 3g5YJ0pzdbFQ3hJ0AyuyUyFJLu9QdHpbjfVfoCZ7OFzyJh+lBbCUbw+4o6vAiuvSBz
	 4nZ/IHaxsDtfwZLI1AWe4rQbmsJiUNTf8gYovsxidZ4fkq/0w6R30dr1ZyTGFyCi53
	 /BOi7iGAxeuug==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.26/5.94) with ESMTPS id 63F5svwgF3498410
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Apr 2026 13:54:57 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Wed, 15 Apr 2026 13:54:57 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([fe80::ed72:3015:2840:4458]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::ed72:3015:2840:4458%10]) with mapi id
 15.02.1748.010; Wed, 15 Apr 2026 13:54:57 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Panagiotis Petrakopoulos <npetrakopoulos2003@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Oleksandr Havrylov <goainwo@gmail.com>
Subject: RE: [PATCH v3] wifi: rtw88: Add NULL check for chip->edcca_th in
 rtw_fw_adaptivity_result()
Thread-Topic: [PATCH v3] wifi: rtw88: Add NULL check for chip->edcca_th in
 rtw_fw_adaptivity_result()
Thread-Index: AQHczJjzYUT6yo6yxECrS0hnHY7kpbXfn3nQ
Date: Wed, 15 Apr 2026 05:54:57 +0000
Message-ID: <ad69b2f3dbc74ea6b9b1a17f2a77fbb4@realtek.com>
References: <20260414194757.163339-1-npetrakopoulos2003@gmail.com>
 <20260415052959.14844-1-npetrakopoulos2003@gmail.com>
In-Reply-To: <20260415052959.14844-1-npetrakopoulos2003@gmail.com>
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

Panagiotis Petrakopoulos <npetrakopoulos2003@gmail.com> wrote:
> It was recently reported that rtw_fw_adaptivity_result()
> in fw.c dereferences rtwdev->chip->edcca_th without
> a NULL check. The issue is that devices with the
> 8821CE chip don't define edcca_th in their chip
> info. As a result, when rtw_fw_adaptivity_result()
> tries to dereference it, the kernel triggers an oops.
>=20
> Add a NULL check for edcca_th before dereferencing
> it in rtw_fw_adaptivity_result() in fw.c. Placing
> the check at the function entry avoids logging any
> garbage values.
>=20
> This change does not address the root cause for
> this behavior, but it prevents the NULL dereference
> and the resulting oops while a more permanent solution
> is developed.
>=20
> Tested on a 8822CE chip which defines edcca_th, so
> this issue is not present on it, but it still uses
> this driver and I can verify there are no regressions.
>=20
> Suggested-by: Ping-Ke Shih <pkshih@realtek.com>
> Reported-by: Oleksandr Havrylov <goainwo@gmail.com>
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=3D221286
> Signed-off-by: Panagiotis Petrakopoulos <npetrakopoulos2003@gmail.com>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>

