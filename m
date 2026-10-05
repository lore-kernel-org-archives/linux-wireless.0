Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B010137923;
	Mon,  5 Oct 2026 02:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791168575; cv=none; b=mFAW/6jyIHd0ko4kHyQOF3jzNhC1Wg3mT+INyV4PkkMZrfOOUFDjjbV4jBKxbQY4+1+IuX91Oz2E1KWweyyAxcKOriCtVOtTUwv7i7U0e2Jmx6M40QSkB1l8yuFMEdIWnsZtsAJszzNeDqUp0Zzgz0OMh/K0bGQnT5Lu3gKSuxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791168575; c=relaxed/simple;
	bh=TeNOui+d+8wVzQ53YLWRSoVcQwhb7zeXCCMpW/ipLZY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CzOqa9LwShq/21EWFNI4+6tVA20MGET9l/VyJHa8HA0D+Bq8HwuQJ2HY0H2fi37GStUVdJwRCf37tvAK9q1l/pqupV1rozQJ9LGdgtnXIq4wUCQJgXb20wKvXyT6yJ3TcwI2VZeXKdJxZJErujimCx48EyrZWaQ36SQgRIaV0fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=VEvt6dwt; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="VEvt6dwt"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6952nEUe91595954, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791168555; bh=TeNOui+d+8wVzQ53YLWRSoVcQwhb7zeXCCMpW/ipLZY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=VEvt6dwt7sDuckOPqGHWuTNCwZhSM52MQLNKBcZFi/Syku/dqcwCzDVqdKYYc2D/D
	 42+ZMosxgVHiB+y55IjU/jdkVslZaM/SrbZWd3gtmVQirdruHmzuiKsOznvKk5Ij7j
	 PW5VMub4OD2gi+z3yWRGjGGrtY0YqXjLHxG443f8wfhTChNO8TsEFR7eS84Mm4WZo+
	 vrkVmaYClRRs72sKMKB5l4FXhMYSpZ9aPsVogwIRvU1hMOjViJC1ox13OmqG/Z/T+9
	 P9Mt2rrIYRmsqe+riWh+G4ZWfXuJ1mz/LVyuUfhOv7G9hQMIDpNKjlhjaeGu5dQKHX
	 D95NiWmmhtktw==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6952nEUe91595954
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 5 Oct 2026 10:49:15 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 5 Oct 2026 10:49:15 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 5 Oct 2026 10:49:15 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Mon, 5 Oct 2026 10:49:15 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mehmet Fide <mehmet.fide@gmail.com>
CC: Luka Gejak <luka.gejak@linux.dev>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mehmet.fide@screeningeagle.com"
	<mehmet.fide@screeningeagle.com>
Subject: RE: [PATCH rtw-next v2 1/2] wifi: rtw88: download the beacon the
 reserved page was built with
Thread-Topic: [PATCH rtw-next v2 1/2] wifi: rtw88: download the beacon the
 reserved page was built with
Thread-Index: AQHdUK+UZva0FMvhREW6x54LpFWhtLbuRr+w
Date: Mon, 5 Oct 2026 02:49:14 +0000
Message-ID: <d19dd7073b9d4cdab5e4e1b2d841bca9@realtek.com>
References: <20260930074444.1991223-1-mehmet.fide@gmail.com>
 <20260930074444.1991223-2-mehmet.fide@gmail.com>
In-Reply-To: <20260930074444.1991223-2-mehmet.fide@gmail.com>
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
> rtw_fw_download_rsvd_page() downloads the beacon twice: once as part of
> the reserved page and once more on its own, so that the firmware ends up
> with a TX descriptor that describes the beacon rather than the whole
> page. The second download fetched a new beacon from mac80211 instead of
> downloading the one the page already holds.
>=20
> Besides the extra work, every beacon fetch advances the DTIM count and,
> while a channel switch is announced, the CSA countdown; doing it twice
> per update lets a countdown that starts at 2 reach 0, which mac80211
> warns about. Hand the beacon skb out of the page build and download
> that. The hw scan, which downloads the beacon without a page build,
> keeps fetching its own.
>=20
> Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>


