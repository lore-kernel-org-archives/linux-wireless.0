Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C52A3A1B5
	for <linux-wireless@vger.kernel.org>; Fri,  3 Jul 2026 02:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783046909; cv=none; b=biMz+VBCbX2HkHQlqFvuNLglHeIS6xgoGFLP6M2EFskxNja3tw5ikNBjvFvMDR+Ed5vxJpgxurYGG7clghxuL+GxM3hoJ5zHlpotQ3h9wHqNmmAJiEeWKwmMGbffoAlnSy8I0EjtwfZFUe4LrCSZ6eM832vVtPTgZN073vj/AkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783046909; c=relaxed/simple;
	bh=IP8kWRmsCE/zcsUbcwxfE1Mz+AnuzhPu1ErlL8NzCAI=;
	h=From:To:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=CoTobF66N0PoTkdzc1Lx8EKdMnVhYhTcPG8fYQopS79Dmr0oieLRIpXhd5WAQCs1Q4Z6hrKQT/6b+uP6rSCFVf817AqZDPAMb6UZGOYL3nJBv8oddn2uLGUWTI3Na5XrfBNjTgLLo839sT9+LDgDS4WU+IQZLUSLXaCl3gR7ols=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=GfIM4/M5; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="GfIM4/M5"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6632mNZ212398933, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1783046904; bh=5bT5QwuL4NksKVVIDx4TMaiWuqyc+GrraxRsi/LY2D0=;
	h=From:To:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=GfIM4/M5VMR7AmHjBDU5smUHbasTPoMBUWhwhGnnQjSRsbIy6C+FkpQc8Sk29wc+f
	 x7qa6LZjraTIENFZ3Q7FN4Jct2CVeTSW3XYcBDGAWt/IFe7VAlaWb5U4BxEO2yklH4
	 2VZW1i9TbrnCSOzISGygCXsgM28hfi37Ef2eBQGYktmF73Q10WM0tImKDgibyJ9LCb
	 KSoBaOs8eZIP1xsA+Xp9PxrFMU9ask1Jt2OFRzD+1gY9ynQbRSYhEeh+oZiag7F7JY
	 FiNgPLFQfpXnktGVRe3ODIWP80mz2aO8YgwB/mwgsxMNzcZL12oXeOxcrvUWLHiICE
	 ylClBYnFbn37Q==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6632mNZ212398933
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 3 Jul 2026 10:48:24 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 3 Jul 2026 10:48:23 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 3 Jul 2026 10:48:22 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>,
	<Jes.Sorensen@gmail.com>
Subject: Re: [PATCH rtw-next] wifi: rtl8xxxu: 8723bu: remove reference of non-existing firmware rtl8723bu_bt.bin
In-Reply-To: <20260622015439.9621-1-pkshih@realtek.com>
References: <20260622015439.9621-1-pkshih@realtek.com>
Message-ID: <0be1cd4d-758d-4b5c-8e0e-268799538393@RTKEXHMBS03.realtek.com.tw>
Date: Fri, 3 Jul 2026 10:48:22 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ping-Ke Shih <pkshih@realtek.com> wrote:

> A report from [1] that firmware is missing in linux-firmware repository.
> However, there is no specific firmware for RTL8723BU for Bluetooth enabled.
> Remove the unnecessary reference of firmware file.
> 
> [1] https://github.com/rtlwifi-linux/rtlwifi-next/issues/20
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

1349ed8f104a wifi: rtl8xxxu: 8723bu: remove reference of non-existing firmware rtl8723bu_bt.bin

---
https://github.com/pkshih/rtw.git

