Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11157302CD5
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 05:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791437432; cv=none; b=LdNtVPdTDZglCKFlITB0gCblyvoDPlaiO+l7ATzzUS/U2rFd5d+JO1+L3iAR/8K1OlrZtlJFmhF7IS4J0/VRPIn8wKE41Tv3o10Q7UIoMGgRRp+TqZamgTGq9yJpMSSlytt3NRhAbi9uibvy4hSsd+jYHuYcG/anuYlGYM1Fkdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791437432; c=relaxed/simple;
	bh=lpcATz/3jWS3fZJ3WHwYT6AUozExsYL51IkIoQn7KM8=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=k7FIbjbUd3cE2beWvFQj/fTNxnYFq2sUmYHzxsb0qDCMfm+yLP6MlLNLDBoWa8qm2XSw8a3Fs7b5O//HJoMug+j7bAyPsWg7RpIKNTvmNLrlXqHDalm4/GMl9qwZt5NIRdOVUNyJYoLVlNpASCcfnvRM4WJvtqORiGCzSfQ32mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=LRHZMLG/; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="LRHZMLG/"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6985UCm74223550, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791437412; bh=CUa+/saL9ChAPgCuhwIm747KTrgZ4kLD+pCOZ7LYG0U=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=LRHZMLG/eGJT4Fb/YJuFS+ORVPkZSD9dOV0QWpPqPPT+AoqaKCPLqwje7tcbj3Qu4
	 Qxt45aDMfK8gbv8kf/o5nUZidP6woCQvUozUpgyywNPqB1IzOK6hUxCBRFwZ1sOHjg
	 JcKIy24TmTzUj6oX4pmzJjo9GWkYO5sWVXdLxLJOayXB5TkRd5tcc1X5HY62FANE+5
	 zYHVNOtjKCt1AyqHILazel2hU2YD/iAvrdWGcHh2FovlButS4xRezz92ub7fmpDnZR
	 kwTWV0W8U5tK4mmjC0r6gqrDmCstNy5y7rtsmftophBeCLJM/p/3sPyZkc7j6WXgB8
	 MsqbW//bp/DpA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6985UCm74223550
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 8 Oct 2026 13:30:12 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 8 Oct 2026 13:30:12 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Thu, 8 Oct 2026 13:30:12 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Ping-Ke Shih <pkshih@realtek.com>, PierluigiFrullani
	<pierluigi.frullani@frumar.it>
Subject: Re: [PATCH rtw-next v2] wifi: rtw89: Override antenna number for RTL8852BE-VS
In-Reply-To: <c6f85442-dd1e-4971-943a-31bfb54eb0ed@gmail.com>
References: <c6f85442-dd1e-4971-943a-31bfb54eb0ed@gmail.com>
Message-ID: <df2dfc2a-483e-473f-aae7-9eea78d689d8@RTKEXHMBS06.realtek.com.tw>
Date: Thu, 8 Oct 2026 13:30:12 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Bitterblue Smith <rtl8821cerfe2@gmail.com> wrote:

> RTL8852BE-VS (PCI ID 10ec:b85b, RFE type 41) has only one spatial stream
> and likely one physical antenna, but the firmware reports two antennas.
> This results in the driver configuring the wrong RF path, which leads to
> very poor reception. Users complain that 5 GHz networks are not visible.
> 
> Hardcode the number of antennas for this RFE type to one, and the
> correct RF path for the Bluetooth coexistence code. This is what the
> vendor driver does.
> 
> Closes: https://lore.kernel.org/linux-wireless/10543730.tdPhlSkOF2@topolinux/
> Closes: https://github.com/morrownr/rtw89/issues/128
> Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

411e89374aa2 wifi: rtw89: Override antenna number for RTL8852BE-VS

---
https://github.com/pkshih/rtw.git

