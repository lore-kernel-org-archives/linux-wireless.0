Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2AC73ED13F;
	Thu, 30 Jul 2026 09:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785402181; cv=none; b=mBoL7yAFmjW1a9luFAl3srPkGbC7s64fp620RtA8aYqmc8VMQqbF6fcRIVv1ivgp+o2uuMzzvBtTisHx/W79Q/UQdwAifVXmYp75vVK0iYKxueCFHM8cqE/Zl98VnMq/r7at8ggjDNvwEgil9JwJKjPTrXI32UcAMIpx72q4ZBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785402181; c=relaxed/simple;
	bh=FCeQYZgboLmutTQDBSlK/wujqxTSUBV9zy6FKgBoM/o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sfQQtbtHSaJ9LAUIYSi5y1e0EfnLjNr4aPlnGOQhzOzIqfPfg1JUFWa/cCFKioPsLFZPfJaIs3AJEX5Bf+FhIQtJMMcxOrW5Zp8BPgImKifWPkD7mcr+fIZr0mmQt6IBgcrOOtJyKQPM1z78WzN0KAajUWxyYcOAuvfZYU/us7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=PE1Iz8B1; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="PE1Iz8B1"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66U92gjuE1068654, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785402162; bh=Q9CUwJVMbbqwnLxYXhKdCUWEa4BGFb85LxPT2Sd41co=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=PE1Iz8B13SS51VMiRQ513syjPUuLo3honuaNPF7UYVTUEH+7AYpzYaLUj5kWJTWMr
	 MTH/YugT8k63UjDN/XbpE5XF880Rhp2wgyC3TZMPYBJZ6EHS0ApqdBvNuggSPlOxge
	 YKVQ0OQdM0TJHM1XqKECwjbU7CR1UKcuXE3nrjjuiZjfAiZ1eb9QW9ulaY03FejjxS
	 H6XM+EdCPioXa0q/ynOzt4BzIaXpX5/pkixgVkWosmRJg5XvBllwMWm8/qY2GImf/r
	 Eu1XvhL3FrwRE5hwrwQO4+s6dXuRe9vPSiUiUAPTW1wTZmD5BBQdjQ5P4w/dzAXRdt
	 b/H4+c89S8aPQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66U92gjuE1068654
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 30 Jul 2026 17:02:42 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 30 Jul 2026 17:02:42 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Thu, 30 Jul 2026 17:02:42 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "luka.gejak@linux.dev" <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH v2 09/11] wifi: rtw88: sdio: add TX back-pressure and
 retry on page starvation
Thread-Topic: [PATCH v2 09/11] wifi: rtw88: sdio: add TX back-pressure and
 retry on page starvation
Thread-Index: AQHdHEb9QehgipUqV0WrHvKAAfZkDLaBFFxQgAQbogCAAJtSIA==
Date: Thu, 30 Jul 2026 09:02:42 +0000
Message-ID: <1e496b19adbe4986a1b8d53dde7fe45e@realtek.com>
References: <af51f851a5254faa9caba6b1e04fefe8@realtek.com>
 <20260730074504.19725-8-luka.gejak@linux.dev>
In-Reply-To: <20260730074504.19725-8-luka.gejak@linux.dev>
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
> On 27/07/2026 09:21, Ping-Ke Shih wrote:
> >> -       queue_work(rtwsdio->txwq, &rtwsdio->tx_handler_data->work);
> >> +       mod_delayed_work(rtwsdio->txwq,
> >> +                        &rtwsdio->tx_handler_data->work, 0);
> >
> > queue_delayed_work()?
>=20
> Changed inside the TX handler, where the work is not pending and
> queue_delayed_work() is the right call.
>=20
> I kept mod_delayed_work() in rtw_sdio_tx_kick_off() on purpose, because
> there it can race with a pending retry. If a page shortage has already
> armed the work with RTW_SDIO_TX_RETRY_DELAY, queue_delayed_work() would
> see it pending and do nothing, so a newly queued frame would sit for up
> to a millisecond for no reason. mod_delayed_work() re-arms it to fire
> immediately. I have added a comment saying so.

Make sense. Please add a short comment for the reason.=20

Ping-Ke

