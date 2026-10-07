Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92FD8369D47
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 03:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791345194; cv=none; b=Xb8wGPim0VznpGCogt4Ksnc5WHDOxJXChShwL3VG/WAjnjFTikIvhGZJ3fktemHtUpZK942eOeKk5fWeNz1t9UgRTQvcGwOi9mCJeXPZWcg3s9UDcQ52s46u+GaJ475ceqvFsnmAADx5jdRNlac7YKfeWcxGYagAcp4meBBZXew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791345194; c=relaxed/simple;
	bh=bM+aKvkBlgHNC1MasJI71mzsLCrIhHdBfxVBdFxDKqo=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=Wj3GeWEHCGX9tE14UQdexNwUwhrR+xdvt3XHZ+9FHfWxHl82Ki82Nwc30ZTZYJtoU4l5/IvJxOzORwoFfrJeAu4R5Z0kVQ2o1GDZtL6GQ25JptVzSj2QS04ZCsNtOsBxS/Sc3eOlpHKH6jy8Fxj5VVTHf/R8W5ruzpDgfQCsLzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=wgeyIXkP; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="wgeyIXkP"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6973r0Ru93501126, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791345180; bh=6/DSYe65EgWBjd0rtnaD6+VaNb+rHN1mCRG5nM5sqcE=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=wgeyIXkP95ZKObC8O/Mtzq4mllTyk/OY9B8ELgHrwkudS+nllZl10YdC4ouG1BWwx
	 XwtaEnsi0S7D/r+FPLGJVxEsPa+3WRvJCO8cFtkmVSdTXtTaWeSgIzlDnFCcvtHu3j
	 7wPr0ORZO/e4paswEo2lCd6eJbchi3CnsVfGBgXiF+9EwYWNNFcFYMZcHxkfPUiZUH
	 rxYzE0YmS78wbmnA1tJoBDIV6d+l9TUlNBo4MaNWs+FoCpvRPY7ugMZLcvuSjxOZby
	 S4KNq/TwiVb1bIJHE4+e5flfIgGHaeSJ7ZT8Xo5bi/pCeKcHC4Dl6EJv+GQnaJKIcD
	 F4vFRRiy+OWCg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6973r0Ru93501126
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 7 Oct 2026 11:53:00 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 7 Oct 2026 11:52:57 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 7 Oct 2026 11:52:57 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>
CC: <arnd@arndb.de>
Subject: Re: [PATCH rtw-next] wifi: rtw89: remove discouraged imply from Kconfig LED
In-Reply-To: <20261002065058.13535-1-pkshih@realtek.com>
References: <20261002065058.13535-1-pkshih@realtek.com>
Message-ID: <1ad45349-4977-43bf-a43e-e7c63959733e@RTKEXHMBS06.realtek.com.tw>
Date: Wed, 7 Oct 2026 11:52:57 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ping-Ke Shih <pkshih@realtek.com> wrote:

> The 'imply' in Kconfig to weakly and implicitly select dependencies is
> discouraged. Remove them to simply logic.
> 
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Closes: https://lore.kernel.org/linux-wireless/7cdc36a9-aadd-4636-8a29-847d89638c8d@app.fastmail.com/T/#t
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

5a4847b554e8 wifi: rtw89: remove discouraged imply from Kconfig LED

---
https://github.com/pkshih/rtw.git

