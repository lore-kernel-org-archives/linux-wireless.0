Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C28184524;
	Wed, 16 Sep 2026 04:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789531359; cv=none; b=UhKKWBJoHFisBJ58s6YNpG7HNs6roucAii8vvwHXQFi90Ot8FOyfPcFvmMHv2SIHF0JS1zvyzHFdUNWYEqcqI7VPnq6VgH56inMgceY+4t1tHpUHUrFhhqD6p3RzuMuPcB/dTmHyCaLF6tcyjHl78Ak7FPUqjL0t49D6pk4HiC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789531359; c=relaxed/simple;
	bh=lJqtbALDwOWw6Xp6syX8TDZPnSbVMrYwmJGHEpFnbpg=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=AzHdNsbz5dHhj4ikBwVTBc53c24FLRO4fgLFur3plmeJj2MFetXbPmWDHtg3x8Y+zNC+RABpR+ac2FrGDG7xK3dXQr/NorhdnRwFMDznno+Q0MVPW3K5QAgRYfKugFBNqTYbP1CALI3S6xVtEj0nKy3+aKOCy3JJJ2coGGC3qeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=oazY6NJq; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="oazY6NJq"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68G42PM202075626, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789531345; bh=ujKM9PTLrAtwAt0e/O90NkuHCypzjgFyfFzRrvUGeWQ=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=oazY6NJqiCccr9yq3mwxxxkFzSXMJ1UDEL0eoEGrDA1maDWPDsQUV8ypIjH0+9GGt
	 WuCIekFjgDVx9lDNNUtCTyxOspmY1KiwwJSQdbKe+khCp/aEbg/2MiUT9JDuiFL1ig
	 4W3U4WOpYEug95FWg2BBJAwF5nPhdOzkdVI9SvXC5vRmy0VaV1Odu83VFbCWQDkBLE
	 Uv+XJU1ksyRxpVTSfsGvKBBF/t5b5Uw16hpi0u5tAopM79ZnaIas0FdELK2GJ1ef56
	 BqFlmhQPAcmdX8ZSnCvVg2vng1/52Rj9HCcmVHaTS9EdoSTu3W75VgW6/e3ga0p+HE
	 o3TUHLdXalpWQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68G42PM202075626
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 12:02:25 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 12:02:25 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 12:02:25 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 16 Sep 2026 12:02:20 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <luka.gejak@linux.dev>, Ping-Ke Shih <pkshih@realtek.com>
CC: <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>, Luka Gejak <luka.gejak@linux.dev>
Subject: Re: [PATCH v11 1/7] wifi: rtw88: add the RTL8723B chip type and SDIO helper
In-Reply-To: <20260909074556.55709-2-luka.gejak@linux.dev>
References: <20260909074556.55709-1-luka.gejak@linux.dev> <20260909074556.55709-2-luka.gejak@linux.dev>
Message-ID: <15af360d-5098-440d-a0a9-3d20ec43dc7f@RTKEXHMBS04.realtek.com.tw>
Date: Wed, 16 Sep 2026 12:02:20 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

luka.gejak@linux.dev wrote:

> From: Luka Gejak <luka.gejak@linux.dev>
> 
> The RTL8723B is a 802.11n combo chip whose SDIO variant, RTL8723BS, runs
> a Realtek vendor firmware that differs from the firmware used by the
> other rtw88 8723 family devices. Supporting it needs a number of small
> adjustments spread across the shared core, all of which have to be
> restricted to this one chip and bus combination.
> 
> Add the chip type and a helper that tests for it, so the changes that
> follow can be gated without repeating the chip and bus comparison.
> 
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

7 patch(es) applied to rtw-next branch of rtw.git, thanks.

673662a0411e wifi: rtw88: add the RTL8723B chip type and SDIO helper
5f92fb993456 wifi: rtw88: rx: mark zero length packets on RTL8723BS
4d688f22ebbf wifi: rtw88: tx: extend the TX report purge timeout to RTL8723BS
b81ead28aeb1 wifi: rtw88: sdio: zero the padding added to a TX transfer
5a95bd460175 wifi: rtw88: sdio: track free TX pages and OQT credits for RTL8723BS
8c17eb82a0fb wifi: rtw88: sdio: set up RX aggregation and interrupts for RTL8723BS
28eaf7971a20 wifi: rtw88: sdio: add TX back-pressure and retry on page starvation

---
https://github.com/pkshih/rtw.git

