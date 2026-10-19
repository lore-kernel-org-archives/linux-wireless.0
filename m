Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E5C31BCAE;
	Mon, 19 Oct 2026 08:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792399960; cv=none; b=KLjxYyx4QYcEzODqiBsLD8J6chuzf/CaFjLKeqrt9IXBXNXffC32Nxy3UtiZMhLjdblNl7AaffoYtyj0EWtSaRKS7wWLryM/p2pE0E3PjxeudECzlUzFzgy315WqUYhRRYnDYu+L+VmOsmWccGhfNssyvNTQFtK0mbhQiaI9M7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792399960; c=relaxed/simple;
	bh=YA98EXOpwW+aSDO+J6VH8pnX18nnPXHCvmkxuhVpeMI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OJ9+QqRn4zXz+RaHcO0CGEWP6MZ1unz5nv4/qtzkQEMG1Fn16B/bYxFFLcUtaYi9u1T11eI3Pu+04hXH4uF6pO2EdWJoVGNTH6RBoMG2dGeknpznRWnwXHn5abNpC6qhABiKAsXmAYubB5/+GFQtVHIbs16v3yj0Fx6t0hAPAbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=NZh/GjB2; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="NZh/GjB2"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69J8qUOf91741895, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1792399950; bh=YA98EXOpwW+aSDO+J6VH8pnX18nnPXHCvmkxuhVpeMI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=NZh/GjB2eeyjfHbB0LVbK4bm5Rotl8cNRek3tWTWOSsS6Ew713t3kbboPE+oZHHDn
	 LIXi9D742FUrVYaLaZ6xcoV/65VsSNhWrwSbkylsAjbtmernViucWz9nZmGL5xMrTg
	 TwADXKrlcmX2U1U4+XpWPQXzvgz3Od+34sIrPV3SF1YUTdCpWeTPhF8aeTGiwvYIvY
	 khjdEyZii2HC4Z2UUqxWVUo4I8147MHvIezA7mifHKOFZxUAAEIOeiBrKzQC7CSLHf
	 G6bXNZPYIYW+3jM0E+9AlLY0gHsUj0m+ZLZ3NsTjEyxkuKM25Sr12PnZgzS08kc0+W
	 Mi9kVytACssSQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69J8qUOf91741895
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 19 Oct 2026 16:52:30 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 19 Oct 2026 16:52:30 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Mon, 19 Oct 2026 16:52:30 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mehmet Fide <mehmet.fide@gmail.com>
CC: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mehmet.fide@screeningeagle.com" <mehmet.fide@screeningeagle.com>
Subject: RE: [PATCH rtw-next v6 2/2] wifi: rtw88: support channel switch in AP
 mode
Thread-Topic: [PATCH rtw-next v6 2/2] wifi: rtw88: support channel switch in
 AP mode
Thread-Index: AQHdWuS02ghpGGHw90yaRSTFSDbFibcEOBOw///UiICAAIlYUA==
Date: Mon, 19 Oct 2026 08:52:30 +0000
Message-ID: <f4aea8175e4f4082afd50fa94787137d@realtek.com>
References: <b9bdebf6dac043ce9b3e285e0d12209b@realtek.com>
 <20261019083135.3251458-1-mehmet.fide@gmail.com>
In-Reply-To: <20261019083135.3251458-1-mehmet.fide@gmail.com>
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
> Hi Ping-Ke,
>=20
> On 2026-10-19, Ping-Ke Shih wrote:
> > If you download beacon to firmware twice within a period of beacon_int,
> > a countdown in the air will not present, no? Like this
> [...]
> > The 4 is missing.
>=20
> Yes, when a download runs late past the next TBTT. The absolute due
> time keeps the pace, one download per beacon interval on average, so
> the AP switches when its stations expect it; v5 queued relative to
> the previous download and drifted 10 ms per beacon on USB. The price
> of a download that late is one stale beacon and one count never sent.
> A station takes its switch time from the counts it sees; at worst one
> whose first count is the stale one switches one interval late.
>=20
> Forced on an RTL8821CU with a 90 ms delay on every second download: a
> sniffer saw 9, 8, 8, 6, 4, 4, 2, 2 for count 10, the AP finished on
> time, and a Windows station followed ten such switches (counts 10 and
> 50) without a re-association. Without the delay it happened once in
> nine switches.
>=20
> If you would rather not have it: timing the downloads from the TSF,
> 10 ms after each TBTT, leaves nearly a whole interval before a beacon
> goes out without the download. I tried that briefly on the 8821CU;
> with a 60 ms delay every count stays on the air. Which do you prefer?

It'd be better to see every count stays on the air. Will you implement
to handle TBTT events? Can you share a draft first or a separate patch
(e.g. patch 3/3 to improve missing count)?=20

Ping-Ke


