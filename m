Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD0B27CCF0
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 03:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784864830; cv=none; b=VGGh6NLjRScc6hMS6Q9dHg6n9iM/WcOP2yWaiN/6jSg1zMOIWkR+XbNlA0XlVKAq91QwNGDQl4ca48vAyKn1nzjIDmFQbSWlSrqvdqyoS0zMgQLLbj2HJtFRDzg8SUs5REmvTO/hJJGuxbA3vYdKhzv2WSsUg984wvhF4/FYDwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784864830; c=relaxed/simple;
	bh=yt1H2PJPHfgDnRS2aZw3qQAUQpKJ17t50SSd+WLAMmU=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=UEvKTMOH6618sQ8vd63c6JK4Ye9jxsEMSjeGREtMIvz1j90y30o39hrboMpLtQ5X44IuqNAbatrbBW5HOdBS3WYnRn5BqB8gWsmH0AP/mYmmJgKRCZyB1fohda4Oo/CzdfPYGxQXCeMWoOOcV2zeCrpd5tfnePxfapOuZXcXYJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=LFlCWhxs; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="LFlCWhxs"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66O3l45N1959387, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784864824; bh=y0UgyzG2DzKIaYaJ+6X+kc5GuU4BHmtKfaJlawa3TzU=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=LFlCWhxsXPiHppz6rwicq35ozfHxEFj1krvoCw/CBO1N+rXbsvusvtp3pkNQ3r5/6
	 JB15O1/HkSkdZqyaonIOoG5Ggpazwhdse3xK5/WBhfRYhZXzJEOQb1uyyCNGXibL02
	 8R6YLvSIlEGefwbgPRRR9JIzcYi46tbqnV3UO42v63nVo8p8oN9sS857w9dRe3ijP+
	 aw43WGMbfNU8A5OthvqiOIshoupNuFMVgVFXBLXazq6xX6K8f9x5R4NCGcF6FzM2rv
	 On8Pxw/uXn2WBAMWfYYl+uWr0YDt3T32i6QydZjLPCHs9BDfKlMW3s/QSiQsD9PrjL
	 r9+PqAw4onwOg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66O3l45N1959387
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 24 Jul 2026 11:47:04 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 24 Jul 2026 11:47:04 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 24 Jul 2026 11:47:04 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 24 Jul 2026 11:46:59 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mihail Dimoski <mihaildimoski@gmail.com>, Ping-Ke Shih
	<pkshih@realtek.com>
CC: <linux-wireless@vger.kernel.org>, Mihail Dimoski <mihaildimoski@gmail.com>
Subject: Re: [PATCH] wifi: rtw88: disable ASPM and deep PS on ASUS TUF Gaming A15 FA506II
In-Reply-To: <20260718124045.23493-1-mihaildimoski@gmail.com>
References: <20260718124045.23493-1-mihaildimoski@gmail.com>
Message-ID: <54ea0e34-3309-44ae-92fb-718e12b7f1f2@RTKEXHMBS03.realtek.com.tw>
Date: Fri, 24 Jul 2026 11:46:59 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Mihail Dimoski <mihaildimoski@gmail.com> wrote:

> The RTL8822CE on the ASUS TUF Gaming A15 FA506II wedges during normal
> use. The driver watchdog toggles PCIe ASPM while leaving power save;
> the DBI read of the ASPM link-config register fails with -EIO, the PCIe
> link becomes unstable, and the device drops off the bus, taking Wi-Fi
> down until a cold power cycle:
> 
>   rtw88_8822ce 0000:03:00.0: failed to read ASPM, ret=-5
>   rtw88_8822ce 0000:03:00.0: firmware failed to leave lps state
>   rtw88_8822ce 0000:03:00.0: mac power on failed
> 
> This is the same platform ASPM inter-operability problem already
> handled for other machines through rtw_pci_quirks[]. Disabling PCI
> ASPM and deep power save on this model stops the failure. Add a DMI
> quirk so the workaround is applied automatically.
> 
> Signed-off-by: Mihail Dimoski <mihaildimoski@gmail.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

b0034a2e4156 wifi: rtw88: disable ASPM and deep PS on ASUS TUF Gaming A15 FA506II

---
https://github.com/pkshih/rtw.git

