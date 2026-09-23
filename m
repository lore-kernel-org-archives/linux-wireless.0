Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A137933ADBA
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 02:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790129565; cv=none; b=qiGNQ8h4CpNgDLctAR8sQTNxe71oKhYpmUBQXh4jNZ1xlALafl7aUVy1e9i07Oj6hVU0JNI2A4dwyNKLdZau4l8eOmpfE9COLaFgYpUQ8OJGG6UgKSUzWfFZASFez63poD7lq3o0vZdgI68s7sMkDobFfAADA7cNjdB8sa0whgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790129565; c=relaxed/simple;
	bh=LAA5dkW8AjmAoiS8kk/2U9v56m/FQAb6wbtdRDazqmk=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=eR+GpZ+fCZM3vZ+y3+8huTugOtPKnqKj2QoP3uUZbkNBFCAyhe8OTaFyfP6JQ9sA4JNe2yaRk8bG+mTfq+ibRqW5Vmh8QymAom+T9fk5bZsdChwkoplf9zeeBdzAt/zokgAhVFQp7//GqAWkRcj3xt4f+c9IKmRvocMN5CZPl/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=nVdiikDs; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="nVdiikDs"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68N2CdgsE4164059, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790129559; bh=T1gKSVjRJW/5Hxt3Nm3+Kl8gOdh7BGpkuzf5+m47ADU=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=nVdiikDsize8ewhQdyKnHdNGEGAIbs9Y0vXyUY0ZSOHFVMjap6wToRVstH08RmJyt
	 sVIDJXoBJqHQoBuGjFMnAgdHPF+Bk6VgKkPT5Ll4les+guA3TcgXAgGjPLORpkwnok
	 D8U2y0QBUCry6A6VT1M1WoEYGh88plF152/OX4zb51r6v3C046KooFxK5JiYBAU0NS
	 vV8xjw7GBCnNFiW6PME2F3FLDZMpFtmY3vNOPStnAL/ARJH4qGiGdBp/xxwzZF2tO3
	 GSe3S6uK/AxR9DQnBFavYzRJ8dhjm1G2uCrOkXjHPUE4EaZFMWKiJy4daJ3OU3RpWq
	 zFMN/uqUfD+Sg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68N2CdgsE4164059
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 23 Sep 2026 10:12:39 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 10:12:34 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 10:12:10 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 23 Sep 2026 10:12:10 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>
CC: <gary.chang@realtek.com>, <skokovmaksimevg@gmail.com>
Subject: Re: [PATCH rtw-next] wifi: rtw89: 8851b: avoid using CPUIO feature with old firmware
In-Reply-To: <20260916074000.65960-1-pkshih@realtek.com>
References: <20260916074000.65960-1-pkshih@realtek.com>
Message-ID: <d89544a1-3507-4994-b3bc-7c1b27d6bbc6@RTKEXHMBS05.realtek.com.tw>
Date: Wed, 23 Sep 2026 10:12:10 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Chih-Kang Chang <gary.chang@realtek.com>
> 
> The old firmware for RTL8851B doesn't support CPUIO feature. Add firmware
> feature check to avoid C2H register polling timeout.
> 
> Reported-by: Maxim Skokov <skokovmaksimevg@gmail.com>
> Closes: https://lore.kernel.org/linux-wireless/20260912193939.5565-1-skokovmaksimevg@gmail.com/
> Signed-off-by: Chih-Kang Chang <gary.chang@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Tested-by: Maxim Skokov <skokovmaksimevg@gmail.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

cb43c5421fb3 wifi: rtw89: 8851b: avoid using CPUIO feature with old firmware

---
https://github.com/pkshih/rtw.git

