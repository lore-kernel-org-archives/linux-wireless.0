Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5518F3CF97A;
	Tue, 25 Aug 2026 07:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787643803; cv=none; b=mz016yRpVE2ObCiimlOeaoa1xKkO6Or1Ru8EYzq1/DgrxmCRrZBaL4yG5/5JQAD/WDY1c61lsDm0Rh0wz5JlpSDKbvuVY+7TR1WPweFej0dkPUI0hOuN3RPRaVan4SmRZu0zMBgLkCBr92ZgxWPp+9GD/A7LZcqeo+8sjMB2wdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787643803; c=relaxed/simple;
	bh=yJ/YJo7HPLOkFAKPwjKWTqaYxYmlrhM6mS5BIsjXfuY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SdrwS5UtvA1I0bBK4e1VOiF1iTCCQTPyIPGTEIvpuW0WvU1Q1GooN8r4YGFUYfCEJIvM8vQR8MeBVL1h0+cNHYnycuAuJJdwoEbYrCaGar4fb5/L4erBoU9ry7yWUVW0Tmd82b8WTeeyZWiN3NB++WGlE6dGSJykWX8HTa6Plvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=CwGhB8JX; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="CwGhB8JX"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67P7hImvD3611973, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787643798; bh=yJ/YJo7HPLOkFAKPwjKWTqaYxYmlrhM6mS5BIsjXfuY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=CwGhB8JXd/5OAvGIY2Ol4Rn1SjNAZrreLnLWaYKzUvV0JrdXsYRKrdUcpgWyt6bci
	 OYv96Rziou2xKcDuiv1UkxwnKUC44GEi+gMYtinFHUpYkHAU81BQGZc6wTlOwZ03nY
	 cYzPEqw5IGJqMLcRLGih+S0Xz9tlqhFBquE3CfvL0khARrofbkkSexOz49NTIFeTtU
	 Pyl4CRLstkIN6BhEXw0xBdStipqs0W1z6PJVcgjdzHHl2yBEGQYLJGJAc75Pqf9/sh
	 E+IjQs1y4bdR5rynh4aqN1PEM6ggLqE4Xq5WdIGpyhhDJxvx3OjHjKE10fF8eUn6Z1
	 sCiKDMoSXEdfQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67P7hImvD3611973
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 25 Aug 2026 15:43:18 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 25 Aug 2026 15:43:18 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Tue, 25 Aug 2026 15:43:18 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Arsenii Pashchenko <ulijg308@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH rtw-next v6 3/3] wifi: rtw88: rtw8822c: Replace custom DAC
 IQ sorting with kernel sort
Thread-Topic: [PATCH rtw-next v6 3/3] wifi: rtw88: rtw8822c: Replace custom
 DAC IQ sorting with kernel sort
Thread-Index: AQHdLJn9jUyhbKF0+0iD3BLeOiTAdLaucX4A
Date: Tue, 25 Aug 2026 07:43:18 +0000
Message-ID: <2cd8a88de1414b04a2e89e94bd0e09b5@realtek.com>
References: <cover.1786784750.git.ulijg308@gmail.com>
 <f1a1434ff177a37029fbfb198b6f74160736ca89.1786784750.git.ulijg308@gmail.com>
In-Reply-To: <f1a1434ff177a37029fbfb198b6f74160736ca89.1786784750.git.ulijg308@gmail.com>
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

Acked-by: Ping-Ke Shih <pkshih@realtek.com>


