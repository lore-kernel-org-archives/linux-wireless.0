Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185E8175A68;
	Thu, 30 Jul 2026 05:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785389820; cv=none; b=MsLCKKVyG7JpLClek7B1CHhCrZSLw60F4enFNLFDE+GFv+tlrlYAiNlxaZwNmQa+CLTswrj+/iphoTDU7O5JgF6aPG2Ww8sYVf1ZjzzR6aKchv+S/TAgIj3arqfEOSkLPrzBda2GvuffB/Mw6tE9oYMXL/0ug7wRdgGXV5lnQkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785389820; c=relaxed/simple;
	bh=I+anm55usCG9xMDRflx6zGzZ8Hgl7uUNw60T8phG7Dw=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=A5gauozPfLRpWFVAVqG+itWUQ3nP5eRchXWVPmoi0xqKutf+Kf3cqRqWjy/e0bxPpYiwObAPeah7Qd+PMlpbGciUxRkAZ7xzSwMNVTQD6VOIyY0do2W68O8PSwHIqjUcnXNYp9kqL602fyYn9UBvj55+wg7NF/utth+hW84GnM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=uslUYBy6; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="uslUYBy6"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66U5arB33970182, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785389813; bh=o92yWpXsIypao+0C5N4Ex4SLNaVIFWxrMgsCHljBl/k=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=uslUYBy6nPmFsJsZI5ET6lkAuk1tf5RrgPuOuB3nzA7dK+8h5IrXbmKO8At/Rpb6Z
	 VuKo5sNdIfQBNXCeDAvYMyNgJQMeiUSDnjrAs2ev/QBjp/JztYT94YZ4GGNxW2YH2e
	 zDfTOfjQQfPEfb2kk5DzxtpNmQg0dnoWi+V+Y2R2P3vjiV3nMD8HutjPUvrWU24OsM
	 /w6V/lVTvStEN0DbpPibeLGCJGgfOc/XT1ufYJ4STtECtflQW0JnhYfB1raY0MHXyZ
	 KsLjt5ID042QzuoltkR1alRujxv47/JKtaLSkxsFB3+9K9EKr+Z9fjCbj2bnuTHedX
	 6B5T93X2Bemig==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66U5arB33970182
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 30 Jul 2026 13:36:53 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 30 Jul 2026 13:36:54 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 30 Jul 2026 13:36:53 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Thu, 30 Jul 2026 13:36:53 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Sang-Heon Jeon <ekffu200098@gmail.com>, Ping-Ke Shih <pkshih@realtek.com>
CC: <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH rtw-next v2 1/2] wifi: rtlwifi: rtl8821ae: remove conditional return with no effect
In-Reply-To: <20260726134034.1385834-2-ekffu200098@gmail.com>
References: <20260726134034.1385834-1-ekffu200098@gmail.com> <20260726134034.1385834-2-ekffu200098@gmail.com>
Message-ID: <4ede816b-2e5c-408e-ae3a-c46dc90b282f@RTKEXHMBS05.realtek.com.tw>
Date: Thu, 30 Jul 2026 13:36:53 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> Both branches of the check return the same value, so the check has
> no effect. Remove it and return the value directly.
> 
> This is the result of running the Coccinelle script from
> scripts/coccinelle/misc/cond_return_no_effect.cocci.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

2 patch(es) applied to rtw-next branch of rtw.git, thanks.

c13ab5bed716 wifi: rtlwifi: rtl8821ae: remove conditional return with no effect in _rtl8821ae_llt_write()
bbc18041ad5f wifi: rtw89: remove conditional return with no effect in sys_init_*()

---
https://github.com/pkshih/rtw.git

