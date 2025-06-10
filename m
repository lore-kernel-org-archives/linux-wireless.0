Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB4C10957
	for <linux-wireless@vger.kernel.org>; Tue, 10 Jun 2025 02:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749522516; cv=none; b=pyigtFaCMLLf6VOj+P8873BXOUjxhH6ZJoPxVgrOrSrzxqq2NPfuN/qurzCZmVrKuWqfq+Np4wPIGILPwqyiET+YYN5t5uax9K17aeVlGNKi8r8t6JmK2O4LRaCS3f5p01WSSaZ+L6knQodtWvCGgwsS1cr/wd0SWXSZZmJ5gys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749522516; c=relaxed/simple;
	bh=v3p0yU4WtCR4x10G4gWkSZ66TXSMIbwiBZ4Sf0U5X+Q=;
	h=From:To:CC:Subject:In-Reply-To:References:MIME-Version:
	 Content-Type:Message-ID:Date; b=PwC+A4xFMEi0RFAlqMVkF/yhd2h7zoeheZ8qMYsuZ2hAKsKtKyXAXnbBf521+UM5ZnZbHWelaUZrFc/0XAmds9mQ+ttBOBg4x2eNHcH9GPVyTlqey58H6rKz74nRE0b7GIMq6tDJ45qbXXKlVo0by86mRW1+8IjtcoxKOZ5ZCn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=C9MTd7db; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="C9MTd7db"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 55A2STbY42124237, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1749522509; bh=SsMlAyomCA2WV+vYu3FR7X04mudKNMzmMZb68OnoCJY=;
	h=From:To:CC:Subject:In-Reply-To:References:MIME-Version:
	 Content-Type:Message-ID:Date;
	b=C9MTd7dbhmU/GADzObN7BMqO+qEtnrbj+N3jOzY8dAJrsVVTcNhsdf4Cc2HWwcX/h
	 iMUEOPugVIOAxsMrRxq/W288jlCYHBIHHbvPPwqO2FpGIk4JZnPGqv3Xc7lJvIQk7D
	 IwC4a0w+b1uZ2oZutyRyFWfIuSsLqy5AqSOMbKKL7kSwL7wS63Qkq56BX2ugTnNvMW
	 TWxHtqN2rsMbKAAnLASdTKtu0OfGurA1oaLt/2zFU6dQLMOV/ttqR2MK8NO5poLXGQ
	 UZdt0QaLuqrbdEpC38BEN9WDY0bV5wEaCqMMabp/UF3lBToCTT1tnDF0CLtoRxJUY0
	 KJjD0rJBRZdoA==
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
	by rtits2.realtek.com.tw (8.15.2/3.13/5.93) with ESMTPS id 55A2STbY42124237
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Jun 2025 10:28:29 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 10 Jun 2025 10:28:30 +0800
Received: from [127.0.1.1] (172.21.69.94) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Tue, 10 Jun
 2025 10:28:29 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Ping-Ke Shih <pkshih@realtek.com>
Subject: Re: [PATCH rtw-next 1/2] wifi: rtw88: Rename the RTW_WCPU_11{AC,N} enums
In-Reply-To: <bfb1099c-db52-4b25-b111-17ab712e9404@gmail.com>
References: <bfb1099c-db52-4b25-b111-17ab712e9404@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <904072f8-39b9-4ec1-a8b0-74e53cffba7d@RTEXMBS04.realtek.com.tw>
Date: Tue, 10 Jun 2025 10:28:29 +0800
X-ClientProxiedBy: RTEXMBS02.realtek.com.tw (172.21.6.95) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)

Bitterblue Smith <rtl8821cerfe2@gmail.com> wrote:

> The RTW_WCPU_11AC and RTW_WCPU_11N enums are used to identify two
> types of microcontrollers used in Realtek chips, but these names are
> misleading. The "11AC" type was also used in 11n devices (e.g.
> RTL8733BU, not supported by rtw88), and the "11N" type was also used
> in 11ac devices (RTL8821AU, RTL8812AU).
> 
> Rename RTW_WCPU_11AC to RTW_WCPU_3081 and RTW_WCPU_11N to RTW_WCPU_8051.
> (8051 is well known. It's less clear what 3081 is, but the out of tree
> drivers use this name.)
> 
> Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>

2 patch(es) applied to rtw-next branch of rtw.git, thanks.

57d6be36cf42 wifi: rtw88: Rename the RTW_WCPU_11{AC,N} enums
793905c70a56 wifi: rtw88: Enable AP and adhoc modes for SDIO again

---
https://github.com/pkshih/rtw.git

