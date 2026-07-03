Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5E7CA6F
	for <linux-wireless@vger.kernel.org>; Fri,  3 Jul 2026 02:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783045005; cv=none; b=gcWFXDflDP2WLrj0KsHkKbtzq2UxyRgaCKCzu6HWrsJ87u0wtd9IGhltYX+tDQXmkLxHLovsoEEdNvE53aXwV5RlgLZp660cDgmfLVHtNjzdEojZc1HPD84N82leM4qeBtPDga7umIiJs2C9PG+Jc/HNN7YGdOB2Bjcnf/u5VaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783045005; c=relaxed/simple;
	bh=5BErwfsC9OC7NZ3/YenTYigFTv2N/CpBtMhKlRU24pE=;
	h=From:To:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=YOL1FhH9XOYvPNnoaR8faSlxbdB/+gBVA0lJVJ8g949h9fxNkZD2tlU3Ucv2NZ6qroyKfch28rAp3hYs3Uyro3wqCER3AE0gY2WvItjafW2Mna3fpb3Mj6FEFhB/zO3/53fnrRCftivF1HNPDcL98svV7HyfwbpphjxII9iquXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Gh27aenG; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Gh27aenG"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6632GeN122382073, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1783045001; bh=VdLGzeESwFp28OuDSqaJh4eeFHidQdPf0UZNfBGAKxc=;
	h=From:To:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=Gh27aenGlt5VTValiDUvvGucKm+gnNmngtj2JuX55kDWKUl77m1C4O5TLsDWdldmW
	 MIjOJCvnwAJQX0B9Zob2NHQG3A/zH6cbXjRsN2rZm/Q5Ps1LNaanSN2g/AIrAAMYTs
	 MKY9sC4V5zgXsVf+FZkha1wmAXxqc1QDyvVBqeYSsYK14TmDup9TxDphRm0vBRGCBK
	 yzsZIKyHtJJNNPyVPE/ozw6v4CHX8K8s2morE38PqK15PmqMFrqx3dh6dEwRqcAbHp
	 aoSpibajLfNjiiGHPRgaG9zmyNbZbfrppHy+s5PMVDNXTyiz10Tl+dIYEOhmBicEmk
	 mQ0b0F7vPVdNg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6632GeN122382073
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 3 Jul 2026 10:16:41 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 3 Jul 2026 10:16:36 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 3 Jul 2026 10:16:36 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 3 Jul 2026 10:16:36 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH rtw-next 1/2] wifi: rtw89: fw: add first set of firmware features by version for RTL8922D
In-Reply-To: <20260525070735.27659-2-pkshih@realtek.com>
References: <20260525070735.27659-1-pkshih@realtek.com> <20260525070735.27659-2-pkshih@realtek.com>
Message-ID: <d2469a2d-b74d-4064-ab15-75789c121bd9@RTKEXHMBS06.realtek.com.tw>
Date: Fri, 3 Jul 2026 10:16:36 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ping-Ke Shih <pkshih@realtek.com> wrote:

> The firmware features including version of command/event format are
> maintained by this table, which enables features by firmware version.
> Define the first feature set accordingly.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

2 patch(es) applied to rtw-next branch of rtw.git, thanks.

7123cb442e13 wifi: rtw89: fw: add first set of firmware features by version for RTL8922D
92827aaf07ce wifi: rtw89: fw: support scan offload v2 for WiFi 7 chips

---
https://github.com/pkshih/rtw.git

