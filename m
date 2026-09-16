Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31343C0A1E
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 05:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789536207; cv=none; b=fiuWfmBUV6Ak9nSu2ocAJXjrVH7Jm6ECOqhBk+ObP7LKfmQ8TTlChbrwASTk86fEtLs6dY0sGRKGBbUymJVDWqijsAvkG0LXr4xSlE4GD0j/0m/ib7/xgC7MCcRrPw+ezUZTpkUarVdhWaYP9GfNNS/caLnQHGCLGmHpjUa1cwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789536207; c=relaxed/simple;
	bh=E1uj2dtFj8xzfaL0zjOuw0S0PidT2pKth8UGBHAvM9Y=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=WobKTCr4MRT2T/h99b4k0TmR11lvQsnrgvuNgryXiCiPR/94eAb+OuLmmO4C4tAe1o40OVDXHens4ou+c38AQnpyZKFqI9oicjcBURxjVrT8uuXfVEt+tPBiHDk3Qyrkc2ETC+jC2W9wjvvLzt6t/z0kz/1yYKp3CqYPEermxCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=SlmeBhGY; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="SlmeBhGY"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68G5NLBL02123184, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789536201; bh=DIneCnGVmkM2AS7HVUg04kmi3+0zjKyNyD+iuCAQEog=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=SlmeBhGY381H/6WEmKoz1zEYhmvlz8csnOOBbHuKtFEcw7VPb2LStmbwv8K2CxBFI
	 +FmrBO60Y9YSFvaeCdSi2fYwytXnAedSE1BBRMZoSPPaqwjfMMW2k+uCrkdF3f3LFQ
	 91wCNBr2Gd7jhG36uJz4R52pI956s9i+kw006ksNrm5dk15JXnWvbIOgcbfZDB2LN/
	 Zkt4Kpl+j4kIuTLapoYpspg6nFu53/e5zIrZo26uOlyJUFBZhUxjzuKOU6uHH6CiX0
	 wTw5S22TTSG3JFsAhjSckcMlD86af+SoD69Q0Ebl+VFa8BrNOOxE4Q7+/rLLepvD7v
	 0RNhiou71GVsg==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68G5NLBL02123184
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 13:23:21 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 13:23:21 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 16 Sep 2026 13:23:21 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>
CC: <error27@gmail.com>, <ku920601@realtek.com>
Subject: Re: [PATCH rtw-next] wifi: rtw89: coex: cancel RF band return condition at _set_bt_tx_power()
In-Reply-To: <20260911070407.35803-1-pkshih@realtek.com>
References: <20260911070407.35803-1-pkshih@realtek.com>
Message-ID: <a211c4ae-a881-4a98-985c-9c04077cc88c@RTKEXHMBS06.realtek.com.tw>
Date: Wed, 16 Sep 2026 13:23:21 +0800
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
> Because RF band value 0 means 2 GHz and, if the condition set !rf_band
> return, the 2 GHz BT TX power will never been set. Correct the logic.
> 
> Reported-by: Dan Carpenter <error27@gmail.com>
> Closes: https://lore.kernel.org/linux-wireless/aoXrgwyFu851qVNV@stanley.mountain/
> Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

2db269480b86 wifi: rtw89: coex: cancel RF band return condition at _set_bt_tx_power()

---
https://github.com/pkshih/rtw.git

