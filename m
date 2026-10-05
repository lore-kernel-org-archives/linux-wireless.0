Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2A51C862F;
	Mon,  5 Oct 2026 01:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791165130; cv=none; b=bt0Ikdzw3oslLVWXhpm+K+pJ6oLaBi3rJbT9cA7eBnlwFrroVk1L+qvyfjbiqo8zRxyBcACDkyBkg408um0k1bw/PYovj8bAAfDdMoZ9ObhbZlHnoecSFMXZwE95rHT2lrZSUHumyl3xoOdXK3OJ2oCWE6z4PRWMVfg2GypIR78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791165130; c=relaxed/simple;
	bh=YgsrRmrNBTau/ES8l0RE5kXvOByyT65/kGKuFa4VmiU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FMzNNtwA/nCg8pVYmdW7XGf5zJkem54RaB9mpmKBRyftcFETtrw8lvJaXbh+7kWPFeH1tvki705FqAroWBa5auHH8dNRnyO0FjB4kWXpLFBdrzlrr7Ext+NUtf/NSTtzDTJZwxdpI7HxxwkLKi5bRRFxedGxk1agb287o9E+Zbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=efMoIVTX; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="efMoIVTX"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6951q5tF51530858, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791165125; bh=YgsrRmrNBTau/ES8l0RE5kXvOByyT65/kGKuFa4VmiU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=efMoIVTXxqCDw6GZV7Ty27gKaTbWGAjhXAC7ZWHqzjYH5B2EQJaAJix0vo7xnd5sY
	 hqsjbx2vALlYnSyblSbLgNQ67JEoNR3zFWyFGVh6QsMLYBl95xh6HoKC+XHj1wIB0f
	 dm3/3LJyNQPfQ+cnna/FvaHjF6IokkSNbPPZFlUMwbunkm9w2M5S2yoWPeyse5nNk9
	 fZSk6vXVqHehD9fhU335E8/nR1o2+0NvcZgqVu8a57VvqizSQlWsBU+a7fnGn4ffqm
	 b4okdkYcaWQvN+3LHA9vwbukW7TJC8hIYCQKI+LfA+9swXsILpbsyvw0+JTZQIiQFD
	 7EsiA2pRoXMzg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6951q5tF51530858
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 5 Oct 2026 09:52:05 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 5 Oct 2026 09:52:05 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 5 Oct 2026 09:52:04 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Mon, 5 Oct 2026 09:52:04 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"rtl8821cerfe2@gmail.com" <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH rtw-next 2/2] wifi: rtw88: pci: warn when a TX ring stops
 advancing
Thread-Topic: [PATCH rtw-next 2/2] wifi: rtw88: pci: warn when a TX ring stops
 advancing
Thread-Index: AQHdUsNFIL/l8RggjUyOfPNj4VrGRLbuMh1w
Date: Mon, 5 Oct 2026 01:52:04 +0000
Message-ID: <afa2a308990349fb9ad41f6a5031508f@realtek.com>
References: <20261002231013.11792-1-abdurrahmankaradag19@gmail.com>
 <20261002231013.11792-3-abdurrahmankaradag19@gmail.com>
In-Reply-To: <20261002231013.11792-3-abdurrahmankaradag19@gmail.com>
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
> On RTL8821CE the hardware read index of a TX ring can stop moving while
> the driver keeps submitting descriptors. The link stays associated and
> RX keeps working, so from userspace this is a dead network with no
> explanation: ping and curl report 100% loss and nothing appears in the
> log.
>=20
> A watchdog dumping the TXBD registers caught five of these across three
> boots, all with station power save off and REG_TXPAUSE at 0x00.=20

As you mentioned, REG_TXPAUSE at 0xff sometimes. I think it will be=20
a right direction to dig why it becomes 0xff. Then, we don't need
a watchdog to detect the status periodically.=20


