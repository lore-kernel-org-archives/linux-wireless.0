Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF36024A06D
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 03:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784863843; cv=none; b=GQxzygtIFcnFPuvpeZhOF85TXHFBG3rU4xJiZ6vk5g6u24LffZlm9jgJ9kAXL5BxYKiW008VhnzQzaBXXt32kX6jvlrrtphsRxQ8tDZMQ9avmbIhpOUwOi1nSeECni2flfkLD2z2J9+tC+eR71uu/Rlr/EHwD0vtJDDImrj/+vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784863843; c=relaxed/simple;
	bh=MvpAPY+TxxCDfhreuHxYD3NBtwZLIPYF6I5ZGaTavhk=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=piErDGWRd8FlXpsn7oBdyMyOEL4aega6QRRlN6+hoXrzlsCMZ4ZF8DnyS94mD3IQFyCM1na0izoZJPPGzjl2sHsEhxbPS8XEOLH7aRSD9IPG2vS+mPWx5WiARLJ/Ap3lBvk0malJV2pO1fpMqvvA78Lv2FGpqDRBtWHUdKF0gs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=TTaKGrHY; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="TTaKGrHY"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66O3UdmY6949961, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784863839; bh=xB2pJ5FkEjrjkSfC/4oQPEVyXiLZBDeW3HoT0r0SwhQ=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=TTaKGrHYSlLtzVrbSsxxCI4/rj5O1+FRz/Ksg7BcGEFQdSiZmGIkWqZNg3enVTUVb
	 K08cLqu/K2kN9HvLYgX/7u/W+x5nq/BjzeDLLwC6tpF5EAE2B7TBSQ26kQ5vHSE4Xe
	 Di+bZ1uD/6JLhU0ylOo85uGENDiqV4m+28noOKpTHS5jqo390cxJOzpaDYJle7g1oH
	 aB57wYx415zLJBLf48ueMoQmjACeCNKTIAvIzKG3Yey2sUbC6Cia0KluZAZtaCpHhH
	 fIv30kilsQ3M6+QuoHnzcIHKtP0htJiHHwAUxWR7kP0chP2QtoGf/HLm/PSrmUp/Gt
	 1B5n+dBuBpjAg==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66O3UdmY6949961
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 11:30:39 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 24 Jul 2026 11:30:39 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 24 Jul 2026 11:30:39 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 24 Jul 2026 11:30:39 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: Re: [PATCH rtw-next 01/13] wifi: rtw89: coex: Add version 107 TX/RX info for firmware feature
In-Reply-To: <20260717065739.64124-2-pkshih@realtek.com>
References: <20260717065739.64124-1-pkshih@realtek.com> <20260717065739.64124-2-pkshih@realtek.com>
Message-ID: <7a9575bf-f6e3-4469-a288-c945f4aea89a@RTKEXHMBS05.realtek.com.tw>
Date: Fri, 24 Jul 2026 11:30:39 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Ching-Te Ku <ku920601@realtek.com>
> 
> The previous version 7 format is for Dual-Bluetooth using. This patch
> is for single Bluetooth solution using. Driver will summary Wi-Fi now
> status for firmware to train RF parameters & TDMA mechanism.
> 
> Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

13 patch(es) applied to rtw-next branch of rtw.git, thanks.

0427315a6ed1 wifi: rtw89: coex: Add version 107 TX/RX info for firmware feature
4bedf26e132c wifi: rtw89: coex: Add version 9 report control info
b5bfb43844e1 wifi: rtw89: coex: Fix unexpected grant-signal assignee
00961e2705b7 wifi: rtw89: coex: Branch out version 105 firmware report map index
49989a3fef37 wifi: rtw89: coex: Refine chip initial related structure
81d30a7be825 wifi: rtw89: coex: Add driver info H2C command index version 103
35b569b60aa0 wifi: rtw89: coex: Fix Wi-Fi role info H2C command header issue
58b1bde3712e wifi: rtw89: coex: Add firmware 0.29.133.X support for RTL8852B family
42a83b5f13e3 wifi: rtw89: coex: Add TDMA version 4
b87da03ee7e9 wifi: rtw89: coex: Add slots version 2
b8892add7e51 wifi: rtw89: coex: Add cycle status report version 105
236badaa50b3 wifi: rtw89: coex: Add wifi role info version 101
38c58d541cfe wifi: rtw89: coex: Add firmware 0.27.97.X support for RTL8852C

---
https://github.com/pkshih/rtw.git

