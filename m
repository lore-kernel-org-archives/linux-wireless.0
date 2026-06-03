Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46C61C84DC
	for <linux-wireless@vger.kernel.org>; Wed,  3 Jun 2026 06:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780469161; cv=none; b=PLABgzGehisL3Y2BoZOhFwDf7u+czfOHt/qR5DcgrwXunAaQ1Cs6wpbx1o3ivKTJPG235XAwyhxE4O56fCmxEN8LaehuzG+Q9UXlEVQZhsSISNpG6rGFkvLCo5u6eUCaBtbunebchnb6PPT0XNB6ZYxglJz8jt2jLZbB2tAE15E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780469161; c=relaxed/simple;
	bh=pIyJgIJEfA203itGEFkewEQKHCmQCjLS5fx3j1lxHl0=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=VYCoVUdapxUhyu9ZY+Y8JWXDS8pFRGRy/zqycCvAn4D5+iMmxjydcsG0gcg7n6v6gC9WZKU7144MNW8Cz/RieFH8TroGh0dPRT20bshZSegiETqK91pGRw59JivHSZUOAof3w92CMZAUiRoAn2vA1jO5VUwxjaf3ElIOYkTymtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=kFeYSnm7; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="kFeYSnm7"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6536jvw973638664, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1780469157; bh=TE0J12lqcjQBO0eTehDQjJQo9FIeLHJ9bmiPlzGYq6g=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=kFeYSnm7ALpUUfc+CSQ/aaT2iJgz83iy5nHZGVgU1Kmx6pEfmG4+raFTL7PwdhRYV
	 RVv7pQ7DyNTLz1g+W7nfDT6T/loZYF2PtOaM3U+Kjv/yvAAQXl6ceVlnkxJ1KdCs/+
	 Ghq0wfnSamqe3vHA43kYhzFXk1/J1dalGDyW2JnAQnNq3FHBsYpx+vvdZnmoj3b2wH
	 Gp4VvRAdlVHh3hLlJEAkCb92ckqbfpoEC+mBtj8hGMKlCoy9M3F9kIQue3A/XK2VG/
	 nROrMzY5EHac6CyGPKFO8u8H0cegiu7xeE6Fhi+3S3WDkQdJDiLOzKAMZt76j9dCde
	 PzGGX1PBz6hHg==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.28/5.94) with ESMTPS id 6536jvw973638664
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 3 Jun 2026 14:45:57 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 3 Jun 2026 14:45:57 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Wed, 3 Jun 2026 14:45:57 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>
CC: <sc.lee@realtek.com>
Subject: Re: [PATCH rtw-next] wifi: rtw89: usb: skip ACPI capability check for USB devices
In-Reply-To: <20260525082636.31105-1-pkshih@realtek.com>
References: <20260525082636.31105-1-pkshih@realtek.com>
Message-ID: <ad2c444f-cb58-40f2-819e-c7026a02d095@RTKEXHMBS05.realtek.com.tw>
Date: Wed, 3 Jun 2026 14:45:57 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: David Lee <sc.lee@realtek.com>
> 
> Skip the ACPI capability check for all USB devices by default,
> allowing them to use their default configurations.
> 
> For USB dongles, customers will manage their own compliance and
> certification. This initial patch focuses on the generic USB skip
> infrastructure; specific customer certifications and localized
> configurations will be handled by quirks afterward.
> 
> Signed-off-by: David Lee <sc.lee@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

bf4a37f516f0 wifi: rtw89: usb: skip ACPI capability check for USB devices

---
https://github.com/pkshih/rtw.git

