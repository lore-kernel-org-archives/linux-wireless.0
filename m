Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C8F3CB56F
	for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2026 05:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785909265; cv=none; b=WpSAaE71zU3iRWO6okZJ05BpMu9lEKr6jDr6PeH9U8Cehd+2MIpRVOqmopPx6QFpx0Blbk0sHtuwX9Zn6M3BbTgGVQE+0DoderfCDiODbcKsmA/W1AlAzvamj07s8XF7xmKZ8+7WpsQQgshySCoATjxWIzgaIVmQnLohTGzfGQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785909265; c=relaxed/simple;
	bh=EGUH/sSx/SgSx9+hBEartwdQNBAFVfQXtBE/atloicU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Z5xxubq2+VJNW5TTvUO/c2gxDbJ51uDZmU8oiX3K7MJWna7pAbZUb70OHPP1ICjCduOSIJ9EgAlLjVcq+znH6ZB1avbddMmmZpN4Pbd9hiryY5WzAGuBANPjuRQNsa7w/f9i9T//75OGfX9mAGUBviHZetJ/aiISe/HZ+fChjUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=VPNBqnst; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="VPNBqnst"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6755sG0S11644278, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785909256; bh=EGUH/sSx/SgSx9+hBEartwdQNBAFVfQXtBE/atloicU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=VPNBqnsthUzBL+frvg+/drOX9GoC6ZI2tc25D7Nx/qREYr3WR/42sVuGIAYxVXOu1
	 fpjdyx06CjkiWgWodZYEDgmpeyLlZsfVV3q9kO+kFchl2LghzDhLa/A5bI+sK5Q6e8
	 iLU7pUXSZCwDzAKjko6kG2RK4TEeo1+fHZBTOCJD6HKZbGxu+J2i8L54Pn3qjmj1W7
	 pqntskvOg7GzC/qHrEVCYrj13aM1l3ERtpRacw1hKdI0+iXrK2msHadrfcg0rlYb8b
	 aexal9h8Y9AMxjL0W/FeM6NzC19V+JZn0a61nPrtGi5pUd4qkqNr3qOeRSReO3Lq1Y
	 J7fLA+pX0soZw==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6755sG0S11644278
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 5 Aug 2026 13:54:16 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 5 Aug 2026 13:54:16 +0800
Received: from RTKEXHMBS05.realtek.com.tw ([::1]) by
 RTKEXHMBS05.realtek.com.tw ([fe80::61a9:c619:5327:6ce4%4]) with mapi id
 15.02.2562.017; Wed, 5 Aug 2026 13:54:16 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] wifi: rtlwifi: rtl8192cu: Remove logically dead code in
 rtl92cu_update_hal_rate_table
Thread-Topic: [PATCH] wifi: rtlwifi: rtl8192cu: Remove logically dead code in
 rtl92cu_update_hal_rate_table
Thread-Index: AQHdI0m7VwA0elGZokiSvZGRkJu/draO9pnw
Date: Wed, 5 Aug 2026 05:54:16 +0000
Message-ID: <eb196f133d8547c783fd303e90f9071a@realtek.com>
References: <20260803131203.998989-1-chelsyratnawat2001@gmail.com>
In-Reply-To: <20260803131203.998989-1-chelsyratnawat2001@gmail.com>
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

Chelsy Ratnawat <chelsyratnawat2001@gmail.com> wrote:
> The variable 'mimo_ps' is initialized to IEEE80211_SMPS_OFF and never
> modified throughout the function. This makes the condition checking for
> IEEE80211_SMPS_STATIC always evaluate to false, rendering the entire
> if-branch unreachable dead code.
>=20
> This error was reported by Coverity Scan.

Similarly, I'd change 'error' to 'warning', and use rtl92cu_update_hal_rate=
_table()
instead in subject.

By the way, I see other places using IEEE80211_SMPS_OFF have similar dead c=
ode.
Patches are welcome to remove them.

>=20
> Signed-off-by: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>




