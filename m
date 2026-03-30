Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA1F19CD1D
	for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2026 01:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774835242; cv=none; b=bYr81ciiJjj8viJuaK+0NNqYPGBPNRIzQBKvHPtuvtLuvN8pW9mzpCWolDPP/HAETUX+650E8N6ifaNvIAUwo1yq0Jq3zUW0hy2g8l/Wnve1pvL7XNj/nsW46jVLW6j2El79lcrdn/4x1CBPSU8BOk+90ohMi/xrnJz2OxMAvFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774835242; c=relaxed/simple;
	bh=/WNkimE9kIhJfNph/d12hz3cqN/OHsntJzY9YHvA12w=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=HoIb6aoWbQPy2yuo6z8URVFu88SFcU3+ig5X5QfPY9Gpn9YsN3IjmdeDZQU+IimX6nf4lRr2KYmYeofVJnRVBZBdNH2XcO/5APMB6QK4m9JfhHhUiGTXCrBoSDvrV1X3V4YximFIB2M03xm6CvqlJh6r1GNDHPqNaOHLXPtdawg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=ti70TtIc; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="ti70TtIc"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 62U1lGyD5070212, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1774835236; bh=LkHI+g/p0ZTB7xsA8DGgxOgTcttj0JBeEKLlbs8BhCE=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=ti70TtIc5/vfHv+OwBJQKBdaZLaxVZmwnvCA4yoXW0psk6WuTs6YKfM7Bf4cOx04W
	 svD5tDt+YOwoALwSIRJGjom26tLku/JNULvgvxe8vOksSQ1B+zoRtu+ik22fqD0ZRz
	 I41r2GO/tUQ9q72H+KDZiu+8Pmtg1tmqNt4CLEyAQNRstr3D3ZvcYPUihvtBq/4rDY
	 RGucRMkmyX9SzBsAhMLi8t6x5nw0nRYhKlXZxavZZpMrq0bwMA5GSLhn99iFpfXMFA
	 9xgypV5fP99LPwcrBEXwujRhBd+wwR7inuJIHRxTgF8ZElc+/i2hKH6mptfnyL4qgE
	 65EkhKpM/rOaA==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.26/5.94) with ESMTPS id 62U1lGyD5070212
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 30 Mar 2026 09:47:16 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Mon, 30 Mar 2026 09:47:17 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Mon, 30 Mar 2026 09:47:14 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10 via Frontend
 Transport; Mon, 30 Mar 2026 09:47:09 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Zenm Chen <zenmchen@gmail.com>, <linux-wireless@vger.kernel.org>,
        <pkshih@realtek.com>, <rtl8821cerfe2@gmail.com>
CC: <usbwifi2024@gmail.com>, Zenm Chen <zenmchen@gmail.com>
Subject: Re: [PATCH rtw-next] wifi: rtw89: Add support for Buffalo WI-U3-2400XE2
In-Reply-To: <20260320154136.5750-1-zenmchen@gmail.com>
References: <20260320154136.5750-1-zenmchen@gmail.com>
Message-ID: <25a53478-f60b-4aa8-83ce-46ca44f36876@RTKEXHMBS04.realtek.com.tw>
Date: Mon, 30 Mar 2026 09:47:09 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Zenm Chen <zenmchen@gmail.com> wrote:

> Add the ID 0411:03a6 to the table to support an additional RTL8832CU
> adapter: Buffalo WI-U3-2400XE2.
> 
> Link: https://github.com/morrownr/rtw89/commit/506d193b8cb7d6394509aebcf8de1531629f6100
> Signed-off-by: Zenm Chen <zenmchen@gmail.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

aefb20749074 wifi: rtw89: Add support for Buffalo WI-U3-2400XE2

---
https://github.com/pkshih/rtw.git

