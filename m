Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4F3364EA4
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 02:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790735030; cv=none; b=itNfK3nghSuxe2eMiPdzxpfXwR6ulirupVmkTs15MFrnKP5jmj6xzxrCaMatoes1Rihbw7JiAz2OrUEQ6ebX8QKCMxU+kPfrycIvfCwH0DPEtf1MWNHf6U9wdTWhsfFYpaRPo3l945UPgR4YkdOqfYHBR9M5L6L5iVYi37uv2nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790735030; c=relaxed/simple;
	bh=Xcj2+SS7Txd4YkVUw7qJfe+64Gige0je29lWzVNeoOc=;
	h=From:To:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=LOaouAEnN0R8VfqD2H+xWzxHR2lXVDzrTzooUlnhW0NzgadGV19vn/YmomR1hqm80WU4DXR4MHVlml2l3XXEB8+vlUcEgu6mLpcJvRXoLfDN4vOJ/7dOnHnpXbNz6cyxhHI94KqPMT1WLkSA4Ps5DcEcVO6XadoHnS3h4X6MHK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=IWX2KJBR; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="IWX2KJBR"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68U2Njf661782051, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790735026; bh=Xis1eV9fHv2A4qnkFOxFasYsD/LrDI74V8vxH+foHhg=;
	h=From:To:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=IWX2KJBRIng23L2FSEZTEVYq8GUrKlbvTqLioW6N1O9v/mJKL/NSzkOHJw7DbEtHa
	 /8+ScmzrhGt5ZIbAoABr792z78t02BTaTWW3ZptlUq3+gVPsH3gxerPJF05RPRs04h
	 GRo4IjTqirAhbzCnCnympS/QeBHzojkI5+NulaFArMsnI534TpePWil1qsUDxKv0a+
	 zGR7iSe70GsBP0Dg52yXkXpZ5zHBjUZ7ys9W3uRfrfrUiNQXZCs+j6Ixxknx0+TAgr
	 LPiwllbTrZFXzvksEyfJFpGq6VycxwyMM5d5xuS6FLImfk9i0diY1wrrPP1lK2c7bp
	 T5hPRlMMXkJyA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68U2Njf661782051
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 10:23:46 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 30 Sep 2026 10:23:44 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 30 Sep 2026 10:23:44 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH rtw-next] wifi: rtw88: TX report with long timeout for non-PCIE devices
In-Reply-To: <20260924004637.9958-1-pkshih@realtek.com>
References: <20260924004637.9958-1-pkshih@realtek.com>
Message-ID: <945a64e3-fb20-4ba8-8ccc-1bc87687e6e4@RTKEXHMBS06.realtek.com.tw>
Date: Wed, 30 Sep 2026 10:23:44 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ping-Ke Shih <pkshih@realtek.com> wrote:

> Many USB and SDIO devices can't report TX status within 500 ms, and
> extending to 2500 ms as tested USB/SDIO devices can fix the problem [1].
> To avoid adding chip ID one by one, and this change looks harmless.
> Keep PCIE using short timeout, and others use long timeout.
> 
> [1] https://lore.kernel.org/linux-wireless/20260921165343.8131-1-pepe.schlehofer@gmail.com/
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Reviewed-by: Luka Gejak <luka.gejak@linux.dev>
> Tested-by: Josef Schlehofer <pepe.schlehofer@gmail.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

7cde94dab0e7 wifi: rtw88: TX report with long timeout for non-PCIE devices

---
https://github.com/pkshih/rtw.git

