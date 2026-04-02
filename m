Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B651EFFA1;
	Thu,  2 Apr 2026 03:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775099011; cv=none; b=hVEH1pWL6gii0KJ6mA9pMbtOg8i0BZW6mUgHg5NfrXNWArYvR32SzGTXcMR+YR7lLRbwpr2sj9ivU+lxuPMMriMg1AAA+jwu5NbUltvZFq7ZBfSSs1wvP5DeJ+pq11dRIZ0KkfOjYJqVXMDu7MrVCJbWIXPAMbxnebAyxZgUxIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775099011; c=relaxed/simple;
	bh=zNpVdt6E9Dt91aWU9Ii3DPyO48meLfGjMnpfocctI4k=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=eda4iVhUG1xDR1jRjwQrl1y6xrip9+U/ystSpj90eQ99ArTxbzpADwGVG+yQ4fqYVlEV0vjmN2YvYDI1xU/4AQcr6/7R6lyfvY5Hh2dc8DR+Rbu1M77YgfUcRpaMBi6UgolWIXH/GCvjVA4Oyvp6/JpZbkHIhs2z3psiyI6QN0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=enTyh6DF; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="enTyh6DF"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 63233PeB42316617, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1775099005; bh=awK1MpfdiFKxldDFKAkBpmlp36KFGT3o/SaRFJNc+zA=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=enTyh6DFu+5yeKbTn4Vuqt+wvcejcmjatZJ+HXy5juEjRObtsE6welygbLqTx3U7W
	 4HD+AvWuXKaOZcsNP/vt1TultYacgDo/pkqZ/28qFxp0CghyBOKfut4UoIpBL+OQy3
	 KTrrfB1I2X/qvhBAV7mZigyjPDgh0QQIPI0f4tACn644e+2EoG0sixtZc5Wf1oh/ot
	 ++CfErBbnIDjkOZPiZaSY6JHwtITbUK6RuA/l5EmKbeiQURl9LRc/MR6EH8tbgB2av
	 TwLS7JyibxDisoXrrKjWLhvX5I4IHb+bHRxHxtPyzh5xkUsN7oFZlJHyjUCjuVLtUk
	 BQM2Jt7HosepA==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.26/5.94) with ESMTPS id 63233PeB42316617
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 2 Apr 2026 11:03:25 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Thu, 2 Apr 2026 11:03:22 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10 via Frontend
 Transport; Thu, 2 Apr 2026 11:03:17 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Christos Longros <chris.longros@gmail.com>,
        Ping-Ke Shih
	<pkshih@realtek.com>
CC: <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Christos
 Longros <chris.longros@gmail.com>
Subject: Re: [PATCH] wifi: rtw89: fix typo "frome" -> "from" in rx_freq_frome_ie
In-Reply-To: <20260329074550.114787-1-chris.longros@gmail.com>
References: <20260329074550.114787-1-chris.longros@gmail.com>
Message-ID: <92b20491-aeed-4258-8f55-c01e68c4ad7f@RTKEXHMBS05.realtek.com.tw>
Date: Thu, 2 Apr 2026 11:03:17 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Christos Longros <chris.longros@gmail.com> wrote:

> The chip_info field rx_freq_frome_ie (RX frequency from Information
> Element) has a typo.  The function that uses it is already spelled
> correctly: rtw89_core_update_rx_freq_from_ie.  Rename the field to
> match.
> 
> Signed-off-by: Christos Longros <chris.longros@gmail.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

127ea8d0b068 wifi: rtw89: fix typo "frome" -> "from" in rx_freq_frome_ie

---
https://github.com/pkshih/rtw.git

