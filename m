Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C07634EC
	for <linux-wireless@vger.kernel.org>; Sat, 10 May 2025 00:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746838004; cv=none; b=LQAcijjic2Wk7JLTKbh1VOCRlIV0PqasOFTqTplli+fuh69+OU7viwbJiSWygWzqpgl3W1xFcMy0kHX8qyf4DKwMf/m8F6t7tX60ltR/y2O/lncFlXpekDMPhdok6XQevyRRqUOwAZ+J33jbgD6OGxVSKrvXCBmb8/j5jOH/YtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746838004; c=relaxed/simple;
	bh=Zu0qznHiBkgoKfddWo5xibOZjMJgBcQzjXWy+D+sr5E=;
	h=From:To:CC:Subject:In-Reply-To:References:MIME-Version:
	 Content-Type:Message-ID:Date; b=gpe7EHH5glMmFXBosYMhiVd9G/m1uHr9y5Le7yl9hUwMlqCpImbDudUn0NiBhmd/3Ex0H4q6Dir0z8g0k9bcTAEClsF4YjyissgvkBRBuMHK3FoB6OaaUzc5RmBENUxtRPxKJ+tGkb87FUUTCTqbPepZwXfFxZoiytMeMogpZkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=temperror (0-bit key) header.d=realtek.com header.i=@realtek.com header.b=SZ1yBDji; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=temperror (0-bit key) header.d=realtek.com header.i=@realtek.com header.b="SZ1yBDji"
X-SpamFilter-By: ArmorX SpamTrap 5.78 with qID 54A0kZ1Y11097432, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=realtek.com; s=dkim;
	t=1746837995; bh=Zu0qznHiBkgoKfddWo5xibOZjMJgBcQzjXWy+D+sr5E=;
	h=From:To:CC:Subject:In-Reply-To:References:MIME-Version:
	 Content-Type:Message-ID:Date;
	b=SZ1yBDji2xReRSCbVypxHAoammxHXwQf2nunPlU00bjhqoKPlryge4BE5053UVn/D
	 6LuBF1yVy5RGWCu6hGAs/YhmmTnoqcn9a0nGzJFolLGzyDmxiMGIiwuCu+sEnedOfG
	 eEas4X5vvApM7yp2Ag2E1YMo0CLU47K/x9dogQXRh0gsG4SSgjz+vpjzr7Mv0MCIOw
	 ZvCh4/t9Ar2ySNw0B+VGSDerKS7S5fEWgvkeQZeDQJdBD3XmcRoUkioDFznGRyLYMO
	 EZmkhs9IYpeEm6RWrXflNkWvwZq15Vde2Lv6csYy4XQWzoNQnADX+38rA2vBCsQ2XN
	 e8rRwnhPtwocg==
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
	by rtits2.realtek.com.tw (8.15.2/3.06/5.92) with ESMTPS id 54A0kZ1Y11097432
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 10 May 2025 08:46:35 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sat, 10 May 2025 08:46:36 +0800
Received: from [127.0.1.1] (10.22.225.79) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Sat, 10 May
 2025 08:46:35 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Ping-Ke Shih <pkshih@realtek.com>
Subject: Re: [PATCH rtw-next v2 1/2] wifi: rtw88: Fix RX aggregation settings for RTL8723DS
In-Reply-To: <4c79fdc1-54bc-4986-9931-bb3ceb418b97@gmail.com>
References: <4c79fdc1-54bc-4986-9931-bb3ceb418b97@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <f3ec1db0-1b2f-49f9-96d2-c2012af6cd93@RTEXMBS04.realtek.com.tw>
Date: Sat, 10 May 2025 08:46:35 +0800
X-ClientProxiedBy: RTEXMBS02.realtek.com.tw (172.21.6.95) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)

Bitterblue Smith <rtl8821cerfe2@gmail.com> wrote:

> Use the same RX aggregation size and timeout used by the out-of-tree
> RTL8723DS driver. Also set mystery bit 31 of REG_RXDMA_AGG_PG_TH. This
> improves the RX speed from ~44 Mbps to ~67 Mbps.
> 
> Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

2 patch(es) applied to rtw-next branch of rtw.git, thanks.

0ffa1ba81b35 wifi: rtw88: Fix RX aggregation settings for RTL8723DS
2c17afde9ff6 wifi: rtw88: Handle RTL8723D(S) with blank efuse

---
https://github.com/pkshih/rtw.git

