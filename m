Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE7A313E3F
	for <linux-wireless@vger.kernel.org>; Sun, 12 Jul 2026 01:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783821341; cv=none; b=fNPBETRdRScYzmdgJMRGm4/Gp2SEBMTPiTq/wXaTZTttsGdZmrxYirx7k4OMdsglPjXNVLZlhiqpwqYnqEXcHZWQYaeyW4LvX2bFDBqHB5dyjMAoViSuhb9yRKgEvGWWf9INQnpJRBK44iuVOCFEGlYx58fyTT5BpTQHn6v/4NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783821341; c=relaxed/simple;
	bh=KMjpI4fTVUwFifOT2GZ72eOgdNXsT+J+DOKtOGCvfhA=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=LAI+2CF4RxDkPyekFDa7+JgTqa2rBgGx/Rud3VNGi7vJRf1DwIoAbJsVYl+BeBykrcftVpPuW1B2nq4VqpQC2f5Y+CFEqtbC6xgmfcHogfv1c5sA4mCm6B+I7qH/Q1p3Ac7zWgaPhiPxCO3G5y8htrTm6fCDaNg0QttiW6LEGGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=nemHlu5J; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="nemHlu5J"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66C1tblH7508760, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1783821338; bh=RC/fI6Uxthb7ZaQjSQ6eadGr+aCEcp8+DvEkpKHC9qc=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=nemHlu5JlvGh2Res+fwtE5vohZKgw91tS+K83hwW6szSoOP8H3MLDPzSB6KMNu2hy
	 gi0aOsGiWme1vhZnIr6rbt4k0qOymhDKqXPFmPEo4GnkLvM+NP5zFoSTsarX0fR2JL
	 XejfH9U+xO/xMXhKg+KbOiv9HI/gcx/0/0nRS91ERdu53pgFu/mFVuQlKvlMbNIGOY
	 yce41i26QM3cBDTxcB0S4RsdqEKGCBe0aXn6BSkFq+Cy80WG0qIHvMOGuOBnOZHCdu
	 rvrbOaL5oolMrjbG5eA3GXFb8AfQhDOX/R9AgXKyF4l5zoxizc9s2/iJbUvpibTydt
	 /ikM8yvvHMoyA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66C1tblH7508760
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Sun, 12 Jul 2026 09:55:37 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 12 Jul 2026 09:55:37 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Sun, 12 Jul 2026 09:55:37 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>
CC: <gary.chang@realtek.com>, <echuang@realtek.com>
Subject: Re: [PATCH rtw-next 01/15] wifi: rtw89: 8922d: remove CCK bandwidth compensation
In-Reply-To: <20260707091056.42771-2-pkshih@realtek.com>
References: <20260707091056.42771-1-pkshih@realtek.com> <20260707091056.42771-2-pkshih@realtek.com>
Message-ID: <9a910ef7-95b2-455a-be92-165169d5dcb3@RTKEXHMBS05.realtek.com.tw>
Date: Sun, 12 Jul 2026 09:55:37 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Eric Huang <echuang@realtek.com>
> 
> Remove the 40MHz bandwidth compensation from CCK efuse gain calculation.
> The design no longer requires the +3dB compensation for 40MHz channels.
> 
> Signed-off-by: Eric Huang <echuang@realtek.com>

15 patch(es) applied to rtw-next branch of rtw.git, thanks.

be8aedb68c96 wifi: rtw89: 8922d: remove CCK bandwidth compensation
daa3fda5aeb9 wifi: rtw89: 8922d: dynamic adjust channel smoothing
8da4883c81ae wifi: rtw89: 8922d: fix EMLSR BB switch sequence for MLO mode transition
852927114f6e wifi: rtw89: phy: fix bandedge primary channel for 2.4GHz 40MHz and 6GHz
390f58e29de3 wifi: rtw89: 8922d: set TX compensation by format v2
d193bdc73396 wifi: rtw89: efuse: no need to export rtw89_efuse_read_ecv_be()
4260edb3b1a6 wifi: rtw89: efuse: read thermal calibration value for RTL8922D
4e199cd66614 wifi: rtw89: 8922d: read default digital voltage calibration values
47ad03f1eca5 wifi: rtw89: add thermal protect by digital voltage reduction
b7911466b6db wifi: rtw89: 8922d: set ANA CLK enter to 500KHz
79afed9426ce wifi: rtw89: 8922d: update scaling factor for RX path
9bf6bd6ed5ac wifi: rtw89: 8852a: fix RSSI report when average beacon RSSI is not ready
235fa79d7561 wifi: rtw89: phy: add NCTL check for WiFi 7 chips
5c925d7722c6 wifi: rtw89: unify access struct of TX power track tables
56d32cdc6040 wifi: rtw89: set needed firmware elements for early chips transition

---
https://github.com/pkshih/rtw.git

