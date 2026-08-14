Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182063E0754;
	Fri, 14 Aug 2026 07:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786694250; cv=none; b=AOh+m2kmcXPuKU0suVgBdXTnT1WP8BHGi7xRDZnViA5R01sC6dcdJc9XFCxgy0KkMM0j43IoXvyjLHBnk2vkYe39JIf7waJzh7IX5Heh1s0ICsJfP1yg1yyYHWbML4OB9BG8x0vA0QwN9+NLdKSKeB8pS21ebGUHuR38nNSEB+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786694250; c=relaxed/simple;
	bh=+XXZW8eZ3nLlvoHzeWn4pRJUygO24two+7t7I3FX2jc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jZjH6F8ovpl7vj4oJ22cLtNLBDx4x0tbteYNlHdQ7jAtS+beO+OcWpIDJpR0XtjK8VddHOhnP5OOKyixyMFxQn4P9AuSuRZrvbnIlxoXAKOouAuC1shEZBZI5zE1t3GN+ZhAnz2RJlo5i1sbycd3OoZJIFpq7Hs/7f5p30D64g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=t1KwZQ5h; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="t1KwZQ5h"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67E7vO3L11075557, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1786694245; bh=+XXZW8eZ3nLlvoHzeWn4pRJUygO24two+7t7I3FX2jc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=t1KwZQ5hx/lw4mJEJxzsYSqCLGzYgqY+/AV24Br6otJ92zrKyQe4ycI12tBCpD8ex
	 oX01RFe0YOC6C9pXmf5V5faLpwvNUcbkSsTKFroA8DkEP7XPjoES5A4G5yq1Ct+x4Y
	 N+iJUwfMrfTjaYQ10dRxRItkMnMt/ujduKaPVhIIttHycji2NGJd+RoDpp8d+LF/Rf
	 etq/TrU8sjuWg9GCMug6UWcdfnyHDMsFe2PULajHYKEfvMjLLi+PoP/M/WclTOPNRR
	 raCdlov2AerHPEDlv2ys4h/LZulg/r7MByMB+oEMvLs0osHJSCtgEGCsWWMrRpSZfh
	 slvP1mcs+RhGQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67E7vO3L11075557
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 14 Aug 2026 15:57:25 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 14 Aug 2026 15:57:23 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 14 Aug 2026 15:57:23 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Fri, 14 Aug 2026 15:57:23 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Arsenii Pashchenko <ulijg308@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/4] wifi: rtw88: rtw8822c: switch to the kernel's sort()
 library
Thread-Topic: [PATCH 3/4] wifi: rtw88: rtw8822c: switch to the kernel's sort()
 library
Thread-Index: AQHdKmlUB+vHsaniiE+cPnTsUIF637adLiUg
Date: Fri, 14 Aug 2026 07:57:23 +0000
Message-ID: <b2bde0f232e34dcda315e52ba225a229@realtek.com>
References: <cover.1786545572.git.ulijg308@gmail.com>
 <4a0b85003aac26b23fcfc6e414e00b39e0d2aa45.1786545572.git.ulijg308@gmail.com>
In-Reply-To: <4a0b85003aac26b23fcfc6e414e00b39e0d2aa45.1786545572.git.ulijg308@gmail.com>
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
> Replace the custom, nested bubble-sort logic in rtw8822c_dac_iq_sort()
> and __rtw8822c_dac_iq_sort() with a call to the kernel's optimized
> heapsort implementation.
>=20
> Implement a concise, localized s32 comparator. Since the previous
> patch already guarantees that input values are properly sign-extended
> into signed arrays, the custom circular index sorting rules completely
> disappear, trimming down lines of code.
>=20
> Signed-off-by: Arsenii Pashchenko <ulijg308@gmail.com>

I think this patch is correct, but please use real hardware to verify pleas=
e.
The calibration is very important to WiFi performance, and hard to find
a slight degrade (e.g. throughput degrade from 500Mbps to 480Mbps).=20

Acked-by: Ping-Ke Shih <pkshih@realtek.com>


