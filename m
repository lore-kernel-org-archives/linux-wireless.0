Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9663F3033DE
	for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2026 00:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787877744; cv=none; b=ll8wnFCUr2vfJn2CelANkFyJ4NfGGyjFHp6QdBHkOiy5w+TRiWojzHCCU9Qn2H+GLBtFjJlm36SsVUVOMPf/HNWm+jiXE+BwWUpaLhxthdCBURw3H6W/JY5eFtTr21akt1/eQWrJq4uHKwTJMWAYWYaPbwgEAJJ1eE+nUxhqY08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787877744; c=relaxed/simple;
	bh=X4JAAI9nzyl96hq6dC1vq4fo3jafSSI6R9EKqTCxPbQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tcxcCXdrBI7QZEYHTjbb3TbsinpSyN0ExBgAtWINY7YvTFjGuU6cPH4bKzKC1s38fPdHbT70hYF2aW13bSIMF8c+NXsQViREKGNS2MMrqgSpX76Aao9yz55JT0eE9IFoNL+FOuZ9GWFnEiXYWsJw/XRlEKlKmCpzpDoie7CsspE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=YJTFu14n; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="YJTFu14n"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67S0g28k92025889, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787877722; bh=95n6xohoBtCyCj7PGIYNd63jCXR4zV42/4QiaYW6auY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=YJTFu14nEV2GfopKcbfEP9YBPqWH0yoV5SVhRc07F0tkeizWdXqPDx+JDt7i1MmB9
	 TizNADOxISto5bfoNSyzckQaQYhRT/JICvmVnLZxx5VYDHTJ5uGIBrJoMfgpUfTJP/
	 7ZSPdvLfmzxaSfsBKdYiQKJmAR5n8OdBbKsjKRgfvPEM6Ixw8K2RNMwPJaauHBDWA8
	 wpiqWrC+Z8VLzRod+rV/1uvJ49olJYpKPBEPeYC+PH7Y8cCnwV5J4XgiHSCDHRdvzZ
	 UgBjLCFDZRuZ5ostJLgfGBHbMcNmzfKdM7oHKdodfmHboJ65ff0VuPXVRXkZ4BhjWR
	 /eVUhHeas1jOw==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67S0g28k92025889
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 28 Aug 2026 08:42:02 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 28 Aug 2026 08:42:02 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Fri, 28 Aug 2026 08:42:02 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"kvalo@kernel.org" <kvalo@kernel.org>, "briannorris@chromium.org"
	<briannorris@chromium.org>
Subject: RE: [PATCH v2 wireless] wifi: rtw88: debugfs: don't vzalloc(0) when
 rsvd_page is read unconfigured
Thread-Topic: [PATCH v2 wireless] wifi: rtw88: debugfs: don't vzalloc(0) when
 rsvd_page is read unconfigured
Thread-Index: AQHdNiXQ2DSQRW3iuUeeies1MedeQrayn1VA
Date: Fri, 28 Aug 2026 00:42:02 +0000
Message-ID: <bd7176af6556460882d032f7da593d6f@realtek.com>
References: <20260827124837.14370-1-abdurrahmankaradag19@gmail.com>
 <20260827131244.35623-1-abdurrahmankaradag19@gmail.com>
In-Reply-To: <20260827131244.35623-1-abdurrahmankaradag19@gmail.com>
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

Abdurrahman Karadag <abdurrahmankaradag19@gmail.com> wrote:
> Reading the rsvd_page debugfs entry before writing a page offset and
> count to it calls vzalloc() with a size of zero, because
> rsvd_page.page_num defaults to 0.  vmalloc warns about this:
>=20
>   WARNING: mm/vmalloc.c:4019 at __vmalloc_node_range_noprof+0x9ac/0xa30
>   ...
>   Call Trace:
>    __vmalloc_node_noprof+0x4c/0x70
>    rtw_debugfs_get_rsvd_page+0x4c/0x110 [rtw88_core]
>    seq_read_iter+0x132/0x4b0
>    seq_read+0x12e/0x1c0
>    full_proxy_read+0x6f/0xc0
>    vfs_read+0xdd/0x490
>=20
> rtw_fw_dump_fifo() would reject the zero size anyway, but only after
> the allocation.  Check for a zero buffer size first and print a short
> usage hint instead of allocating.
>=20
> Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
> Signed-off-by: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>

> ---
> v2: no code change. Add the wireless target tree to the subject and Cc
>     the maintainers/blamed authors that v1 missed.

Actually, target tree of Realtek Wifi driver should be rtw-next or rtw.=20

[1] https://github.com/pkshih/rtw.git rtw-next


