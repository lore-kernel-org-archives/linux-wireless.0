Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE001157A5A;
	Mon, 12 Oct 2026 03:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791774996; cv=none; b=NOWOST0FItRiadFRWS38mt8YacNLn2mkicjaC7FlscXvFsmjnNqp25GNgwWnXtTsMRcYOniD7qTia4hhxWZ94vqbbYBCZ76IEQL5HmASDtGQ+wm9zTxr1Bw8rW4HD5Vs+L314xLdv6S+HUjZzQs/tNcJ7HAyVgSsxD1Z7cxcorI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791774996; c=relaxed/simple;
	bh=47RXKjq80a6i3HHoD/Z/Py2CJwf5l0BmLnR/N5qt3CI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=U7c/b8A1EW1xhFFCvsCk2RtOhsrvRBlmv8TcgJhjKPTByXmD+fITtAn13fTE6MIWI2LnpiDoXJK9E4UlGflt+Rgcf024RMeSzbTN+QVxXmbIeQxvuaEszsOSNothHxCAH0yzbsgx5ojNxZ9GFPfSxPJ9hkQW4gvKouPlTHpBHuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=NVz9DwEq; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="NVz9DwEq"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69C3GC0d83477966, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791774973; bh=47RXKjq80a6i3HHoD/Z/Py2CJwf5l0BmLnR/N5qt3CI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=NVz9DwEqjh+pwaXpCaIYBjmLMX3C7NJCcwnoB4iq8On/+T/5XCqRFJmPu4OsKcF8h
	 yMnkP9vBKqOShrYQlXb9V4DSG3q50iOjmEdEWyXzBNttc5hrygufscUxHi3QcbZ+UD
	 w/IlhuV65PDz8VuApwvPXFot5ad7zNlVRyXpxlkjDEXc1WnNSUABAmqEdqhW/zQkbe
	 bTwLn3j1qU++5gP4VmzcxaB/W0tQ+/9buDAmstBzoY7fDq/r/or7SmKLCVRMCDk5j2
	 gEaSkNUIgZ+bcqiOlY5/VZMx+PkzMQ0HFIFQFz3jpr42jvz9cOnIrmF+4OPOdVFmts
	 QPZ6ueIUKtmAA==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69C3GC0d83477966
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 12 Oct 2026 11:16:13 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 12 Oct 2026 11:16:19 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 12 Oct 2026 11:16:19 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Mon, 12 Oct 2026 11:16:19 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mehmet Fide <mehmet.fide@gmail.com>
CC: Luka Gejak <luka.gejak@linux.dev>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mehmet.fide@screeningeagle.com"
	<mehmet.fide@screeningeagle.com>
Subject: RE: [PATCH rtw-next v5 2/3] wifi: rtw88: update the beacon from a
 wiphy work
Thread-Topic: [PATCH rtw-next v5 2/3] wifi: rtw88: update the beacon from a
 wiphy work
Thread-Index: AQHdVu3mwmHy3D3OSEW9+SwESNh3d7b5QEgw
Date: Mon, 12 Oct 2026 03:16:06 +0000
Message-ID: <0d01a6f2cd9842ae991091918700d638@realtek.com>
References: <cover.1791362281.git.mehmet.fide@screeningeagle.com>
 <1d68c868609a8d63dc884c155023c2e100dca886.1791362281.git.mehmet.fide@screeningeagle.com>
In-Reply-To: <1d68c868609a8d63dc884c155023c2e100dca886.1791362281.git.mehmet.fide@screeningeagle.com>
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
> set_tim() queues update_beacon_work to rebuild the reserved page with
> the new TIM. Make it a wiphy work so that it runs under the wiphy lock
> like the other beacon downloads and can look at mac80211 state;

What "mac80211 state" did you mean? Without wiphy_work, it can't state
it?

> the
> next patch needs that to tell whether a channel switch is being
> announced.
>=20
> rtw_core_stop() runs without the wiphy lock on the IPS path and can no
> longer cancel the work, so the work checks RTW_FLAG_RUNNING under the
> driver mutex instead, as the watchdog and the C2H work do.

rtw88 doesn't use wiphy work/lock yet. and you are the first one to use
wiphy_work. Mixing to use wiphy work/lock and ieee80211_work with driver
lock looks not good. Should we just use ieee80211_work to avoid confusing?

Or we should migrate to wiphy work/lock?

For me, I prefer you use ieee80211_work with driver lock for now, because
I guess I don't have time to verify the migration...=20

Ping-Ke

