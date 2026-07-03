Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8442BD02;
	Fri,  3 Jul 2026 02:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783046409; cv=none; b=qXL/8gxG0oqkLRYBbCsEWn7wuKazApii1bnhvtnxXXOVmSwn+MGfEv5ceUlFpN/rVLZAx5oU0ATF2usEzlNMzajQyuvo8NYGOPRqcxNboESvJsx+2+Q364Vbctnn32fhblYDSF7dKdZKoTt61ty56992bXrZhpaRGL1HEsUyLWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783046409; c=relaxed/simple;
	bh=eMsGWSF3XCa+RUJ1w+dTn0x3hAgJ8gnzCJrnsJWCsxY=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=CXC0H7nV2FVRIVwr3GJY7T/hsM70MY2LmiiRmMAssfqjpS3A0EARAmOdru+p60UXVhjOQlpL7Fk+zpHeoyBItgvy2F1JuJjcpBvkEX+BTeFFk/XY5ZEZhRPBh1mjgIv1bMxICBm6G8bs+yM941X9c11SZB61zoRVkQOnhFHVgP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=SVHYPyl5; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="SVHYPyl5"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6632dbZ432393891, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1783046377; bh=Q2bucrghnOwHSw0URP5maZud9s9VgA1yh9CednmuIXk=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=SVHYPyl5JUWX2SWXY7FyngENWKjX8CpyGzVmphmIUIUYAyC+8xebm1NnvK/6Ou6Dr
	 q5Sour//+PxlOhaSw9l7zCfwTKgT0K1UPA9H6WM/E77zoqNYoetIPq2uNTKMG1SCZF
	 sj/wpzHeTthnhRwHyTxNLdMfBHjrt6loWXNFAhOhk4yrWrUL2AJVQUbuMLPjl8PDPq
	 bq+Q9tAAEP0x7RUI6GX7RRkMRmJAMcbCyeu3lTYHKdwmWYAgGQlnbf6rGNqv6RZ2z6
	 a+mwRf7xQnA5vU7UHiwqyaKD6/5vplLBFcrwtVXUewXNcaCyU7kU2rZbhtj4PgcQC4
	 TOqgh/h5UgElg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6632dbZ432393891
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 3 Jul 2026 10:39:37 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 3 Jul 2026 10:39:34 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 3 Jul 2026 10:39:29 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Chen Jung Ku <ku.loong@gapp.nthu.edu.tw>, Ping-Ke Shih
	<pkshih@realtek.com>
CC: <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Chen
 Jung Ku <cjku@proton.me>, Chen Jung Ku <ku.loong@gapp.nthu.edu.tw>
Subject: Re: [PATCH] wifi: realtek: rtw8822c: replace msleep() with fsleep() for DPK delays
In-Reply-To: <20260613170434.23645-1-ku.loong@gapp.nthu.edu.tw>
References: <20260613170434.23645-1-ku.loong@gapp.nthu.edu.tw>
Message-ID: <7aba7d56-f5e5-4bf5-ae1c-0af655907255@RTKEXHMBS03.realtek.com.tw>
Date: Fri, 3 Jul 2026 10:39:29 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Chen Jung Ku <ku.loong@gapp.nthu.edu.tw> wrote:

> Replace msleep() with fsleep(), because msleep() may oversleep
> to as much as 20 ms when used for a 10 ms delay.
> According to the kernel documentation, fsleep() is more suitable
> and aligns better with modern kernel style.
> 
> Documentation link: https://docs.kernel.org/timers/delay_sleep_functions.html
> 
> Signed-off-by: Chen Jung Ku <ku.loong@gapp.nthu.edu.tw>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

000e63e67a78 wifi: rtw88: 8822c: replace msleep() with fsleep() for DPK delays

---
https://github.com/pkshih/rtw.git

