Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65DC3AF66E;
	Wed, 29 Jul 2026 06:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785308032; cv=none; b=eqYXA9IayMXpRCY8N6xXHlJfEMALcYspIyWwzszhCU/FSLqzu4IF+BhzCycaz1aQRrxfJPsyj7NFm9IZ5+56kpxGkCjcomiS0NWDFAjt1Izid1bu4eUqdJx+kKTU3IEb8e2ZfswrYPtyoYjDyy2cTo6iOdpvF0GRX5J086niPlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785308032; c=relaxed/simple;
	bh=PL++Ebf0E7fR+CT+GNphtiWolKbccSMxHMQdfIrubx8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HOjXofFdpEEriSx60A6i6Etevz4V2LPfM9JRjNC4LNkwUZeuHTNZkNR3MrCCDgzAYwUDVVZxk0+pgaF3tSIhKga/uegEuLQ5zH/e4P0RwI46HhjUlml7b1/RG3I4aG6c+Kvxmxyi1j1RuIVhaziIE2nZ4LAiSRi0KlkymzIEH+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Hgcg+Ya1; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Hgcg+Ya1"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66T6ri2nB254976, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785308024; bh=TcQEFEv6x3qTJhROOoKi9Du9wrgWYfvs6V30MECbMP8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=Hgcg+Ya1kKNN98XnIj9gY5WmGbT4kinkHtDBPCiiYQVw2XWoBI/RGkPfdf6Ckq/f8
	 JXBuytTw27WFtOhIDHhq2SuzW1zlXcRUxRf6AovG2kti2SDpW4/4FOpiysGaKBHKZ3
	 xZreMeC0WutmKQFptIICue45r2IWrNliPCnBTQPaVsODenliGQ+RDbCNuHtapL6JrJ
	 LfXwv8ydA1kAJKUX8P89sjtBpXPzkf3kknzUitJFA04T5BMx+kHdFWbf8sd538A7b7
	 lkl4QT5szHLNY4xzcb7+e64AhQ6wa9kLntwYyDn0uH1QeMXnETN+mo4TDNTLGIiGdc
	 YrlLYNQ8Cu/Mg==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66T6ri2nB254976
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 14:53:44 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 29 Jul 2026 14:53:45 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 29 Jul 2026 14:53:45 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Wed, 29 Jul 2026 14:53:45 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "yhchen312@gmail.com" <yhchen312@gmail.com>
CC: Damon Chen <damon.chen@realtek.com>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] wifi: rtw89: 8852be: add .shutdown callback to quiesce
 device on reboot
Thread-Topic: [PATCH] wifi: rtw89: 8852be: add .shutdown callback to quiesce
 device on reboot
Thread-Index: AQHdHjQ15yuLO5GH90GecNOHrVXHNraCM1qggAD/PoCAAN7dMA==
Date: Wed, 29 Jul 2026 06:53:45 +0000
Message-ID: <7311cac831b2439db0b35af5012cef9b@realtek.com>
References: <142c91dfc7334136a5dabc4f91504ec6@realtek.com>
 <20260729013537.2743729-1-yhchen312@gmail.com>
In-Reply-To: <20260729013537.2743729-1-yhchen312@gmail.com>
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

yhchen312@gmail.com <yhchen312@gmail.com> wrote:
> Hi Ping-Ke,
>=20
> Thanks for the review.
>=20
> > Does it mean the work is running after .shutdown but before .remove?
>=20
> On the reboot/poweroff path the kernel only runs device_shutdown(),
> which invokes each driver's .shutdown callback; .remove is *not* called
> on this path -- it only runs on driver unbind, module unload or
> hot-unplug.  The rfkill polling workqueue, however, keeps being scheduled
> by the rfkill core throughout the whole shutdown sequence until the
> system finally halts.  During that window the platform starts tearing
> the PCIe link down, and the next MMIO read issued by
> rtw89_ops_rfkill_poll() then targets a non-responding device, which on
> arm64 is reported as a fatal asynchronous SError.  So it is not ".remove
> after .shutdown"; .remove never runs on reboot -- the poll work simply
> outlives the link, and that is exactly what the new flag stops.

Thanks for the detail.=20

Ping-Ke

