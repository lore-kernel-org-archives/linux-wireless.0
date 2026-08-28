Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6384F2848BE;
	Fri, 28 Aug 2026 08:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787905457; cv=none; b=NAljlk4iux5sZCYXhGV7iJfd0/C4k0ZXrXhvAXprOtB5LuNm0zCx6vMxGMfTRIJPWKvnNQh/NBuCrY1HnUD7JTsCh7YFavu6HhO92NnVOetgUlMp7n1rb/EH/wlLwKOrVFMJ1p4MZyPh/91tkqXZGUvSHevwxfEHdVWdkF9r4tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787905457; c=relaxed/simple;
	bh=GcqP4NFz3keMp7wQHFyIIBSwt0CYZxF/YS9AxVFwwXk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nf0rVMFantApKgcYnhc93B6kHX8/wazO0SQg+NRQtldBbxxW//xLzOIiq2B4A/jqd5PKnXj36eCZcPP0eNRPZc13jI+cgUoo7WGZg9d2AwaWig1+/APZ8fTcU1qzt9G9DtlMJH5olLvd+WSL6z76a91co+WGkdsIQrqQT7lDFbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=QxemK6R5; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="QxemK6R5"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67S8OAkS42280260, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787905451; bh=GcqP4NFz3keMp7wQHFyIIBSwt0CYZxF/YS9AxVFwwXk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=QxemK6R5pbDSF/0r/4bgThOxy6lC3wDnfNXLbAV0RTS18FiFriAyITJbBv3DY+/IA
	 KyLv9FyS+s/YBq+HGHirgUy3AvnNFS1BLfegyuFSJfLQPiBrWhcYnxEQrkcF0CuwFm
	 OqnZs9HSQ2u8lihiZ1K1Cxek+VSBI+grkdrthYXyVveo4vNJdSyFKg2JrAwAGewbDT
	 4RmD5Zu2F1uSzBsQOkphbXKFWewPPclALq0V+5cKpMsfTuXTWMoKHZMyFLvwJBxI16
	 QmMj1pHODqqFLxSgLWVJvHDEzO2P7f8RXYJkKkrWsNFF59MpI1H4KGAhzQPIBm4TOW
	 v/4V7u5hSlBew==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67S8OAkS42280260
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 28 Aug 2026 16:24:11 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 28 Aug 2026 16:24:10 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 28 Aug 2026 16:24:10 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Fri, 28 Aug 2026 16:24:09 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Arsenii Pashchenko <ulijg308@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH rtw-next v7 3/3] wifi: rtw88: rtw8822c: Replace custom DAC
 IQ sorting with kernel sort
Thread-Topic: [PATCH rtw-next v7 3/3] wifi: rtw88: rtw8822c: Replace custom
 DAC IQ sorting with kernel sort
Thread-Index: AQHdNq/B7LWUWm58E0yJHuRvyBahZ7azH5GQ
Date: Fri, 28 Aug 2026 08:24:09 +0000
Message-ID: <befda2079a1f4201b8f0ae3eeacb76bc@realtek.com>
References: <cover.1787895379.git.ulijg308@gmail.com>
 <7d0ab2352317b81df10dca7ddb3e855a303b8be7.1787895379.git.ulijg308@gmail.com>
In-Reply-To: <7d0ab2352317b81df10dca7ddb3e855a303b8be7.1787895379.git.ulijg308@gmail.com>
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

Arsenii Pashchenko <ulijg308@gmail.com> wrote:
> Replace the custom, nested bubble-sort logic in the calibration loop
> with direct calls to the kernel's optimized heapsort implementation
> inside rtw8822c_dac_cal_iq_search().
>=20
> Implement a safe, overflow-proof s32 comparator using the subtraction
> of relationals pattern. Since the input values are already properly
> sign-extended into signed arrays, the custom circular index sorting
> rules and helper functions completely disappear, reducing lines of code.
>=20
> Signed-off-by: Arsenii Pashchenko <ulijg308@gmail.com>

I guess v7 has no change from v6. Please remember take my acked-by.

Acked-by: Ping-Ke Shih <pkshih@realtek.com>


