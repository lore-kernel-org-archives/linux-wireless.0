Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49ECB47DF84
	for <linux-wireless@vger.kernel.org>; Tue,  1 Sep 2026 16:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788279034; cv=none; b=Pl36SHEm318a/SEYwWhhgRnIaWSGdx46h9NTCjVaD3ToR9KjOu1K2z+0jYW4O1hhjPghclGU22ef9SiLKkfHyEtyW16DE5skkhCPCPyx2k6Tyg5OO/evzACKon1hWUHVdNbdWN0+GENvf2qC5/bDfR6ttqPciwjYY+Qu6kAyMjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788279034; c=relaxed/simple;
	bh=kB+wRcwLg9jpN6jhg7tmxn+hiV+nveguI8b9GP8r5oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Do9mq6LODfCXlvJuOg51e8Mw14OAInCZhaorAOvn+V1RovPGbtMIA9c/NBT8nvnEsTaJFp9QOAhm2cC218rzDCBn/38v0GGCT1853AqOd+vkeZ+yDZ3ygyaG+Q43yKiu5cdObFU2LLN2dfue+ciEiV8jod0XuJ5Qb41hNSnPzVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l2upDrJC; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l2upDrJC"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-90e970f710cso162296d6.3
        for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2026 09:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788279032; x=1788883832; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qd8FjjdakEvlndPpogmSOky/bdaCcagMgEJZOrnyBdY=;
        b=l2upDrJC/GwSxGdiavmH/jNLDexiu0A7sUvAv1R5e217OjectCukxLJCjaltAkpJO0
         4EI2kmBDoaN7IsrBuwnezJYNkV82eiYtoHFE36aH7xrPUaApYKxpwGxwtyymUfvBRLWs
         5pnNsPB+iHJk0VNvAWl9IVfPA0UVJLuslvzsLbp0tPxOiOFxtiuIBiQpQy8Jrs6LhWCB
         K9bYNeg7I6Ag96UHOxn2NhT1AMpuXVZzWR3DyI1zZgrnU6qxaJaFza6w3t+QxxQIwm9J
         BF6KJhEb6DLhfGqLEGm7fJF0KfmXM0V+4I78ECqJBAMV83L9eAMWQBKUBvs2XVpNCdLN
         49hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788279032; x=1788883832;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qd8FjjdakEvlndPpogmSOky/bdaCcagMgEJZOrnyBdY=;
        b=jj+9iffyxSaentxacQsKi914WWXY4lSoFYofeI7a47mOdYnDxwY+oFhq2CkFE7P9dY
         EDszK5tvzgitPLFYQEvjaFlsZfRxK9JzLjBB5Ja9DbCEbH5+CAZ2jO5dRA+jzhFeX5K4
         0skjb7iAs7CtOeKDo3iGLx4KY3xA7v3UsK67Y4xkR33la79L2Wult2QXJomfPvzi3kDK
         8U7w0Hq/SKUOyL9MsXDpBSKRrTwOKeDzMR6p+hfuJWfHeDonbfEWe4xapp2Z/F2pXa2E
         EC1fbxDgT47wk+w8mlmWFQXg1H6SmEz/UlflxapneqBXsZa4XZOJtPmHPMpaMz4oP4YM
         jlQg==
X-Forwarded-Encrypted: i=1; AHgh+Ro5slilbOT40g/zZSTdnavYOIkVCgc6DwcB1XOUuCtnnT4hxIQAldDDCN8UBnKwJx8GhWdGDXGXU1stAjK05Q==@vger.kernel.org
X-Gm-Message-State: AFuF++lEvheKUSZxw0GBPWfwJG0tU4ZZmapAcgprGWaPHsfcjc3pTz01
	5nN63DaVmQOZ8zJIBKvDM67ADQp1+E8Qi7oQooomXPysSmHtjjksgYEMiKBV4W4Lf8k=
X-Gm-Gg: AYBFou0m6rvzUMH5PRvU8uwJ6Cde20vBYy2Soq9Q4E728GX9cH66T38rC6YGbGftXCw
	EbCl2/ibvZ4TyRSFIawoz992Fca1h991sKPz0wVMV2wmo701CwWYABveGK1lXdSE7v6nG6EiE4c
	mZm3SW+3HgHrk556WaVFB3p4SAsDIC3HPNGr49xzeXblPLlmhMlrRRQGVfP5fFK3wsNdA7nOEjz
	wIR9kNc3DeMkV2Eeosp9wEWm1nzZmT4Sai/57Yc0N5Tm7jJ5Yv6Le6lRs9rBfGq867ua3V5aERg
	O5xGX/L/GaSaT3BGMbo1BJdoQ8lkExYGlszWQt5p121MGkTri41h4E9AnYNRlR21I95RxDkV1rv
	5UQIyhpgDRzape+piBZXaqhjVLfbzDSB1MsQmkhwsvrYGXL2H1qmlzDTEV7fAGfPIZilGTZO7gU
	xUIXTrueRlNFR5BgKLVbMnk7KxiXoXRxDJi2jhzE6e0yUy53XVdgFdt93yQM5YP92oejs4Pd2i0
	wcvMkY+D3HCwDGoeD4QI9vzX5pMD9vqDjU=
X-Received: by 2002:a05:6214:2425:b0:90e:95c1:47d3 with SMTP id 6a1803df08f44-90e95c14964mr82027126d6.8.1788279031820;
        Tue, 01 Sep 2026 09:10:31 -0700 (PDT)
Received: from Valhalla.lan (50-36-57-116.bng01.ssvl.sc.frontiernet.net. [50.36.57.116])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90d98d54cfasm92683046d6.40.2026.09.01.09.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 09:10:31 -0700 (PDT)
From: Hans Buchheim <hbuchheim@gmail.com>
To: Eason Lai <eason.lai@mediatek.com>,
	linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	linux-mediatek@lists.infradead.org,
	kun.wu@mediatek.com,
	deren.wu@mediatek.com,
	Sean Wang <sean.wang@mediatek.com>,
	quan.zhou@mediatek.com,
	Ryder Lee <ryder.lee@mediatek.com>,
	leon.yen@mediatek.com,
	litien.chang@mediatek.com,
	jb.tsai@mediatek.com,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	stable@vger.kernel.org
Subject: Re: [PATCH v4 2/2] wifi: mt76: fix memory leak in USB TX path
Date: Tue,  1 Sep 2026 12:10:15 -0400
Message-ID: <20260901161015.607195-1-hbuchheim@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260827083526.1621600-3-eason.lai@mediatek.com>
References: <20260827083526.1621600-3-eason.lai@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I tested this series on another mt7921u USB device and confirmed that it fixes the zero-length WNM-frame skb/socket-charge leak.

Hardware and software:

  x86_64
  Netgear USB 0846:9065, mt7921u
  Linux 7.1.9-arch1-2
  wpa_supplicant 2.12
  NetworkManager 1.58.1
  firmware HW/SW 0x8a108a10, WM build 20260224110949

I applied both v4 changes without semantic modification to the exact Linux 7.1.9 source and built the mt76 module set against matching Arch headers.

The reproducer used a nonblocking AF_PACKET/SOCK_DGRAM ETH_P_IP socket to send zero-byte payloads to the associated AP and sampled SIOCOUTQ after each send. This produces the same packet shape as wpa_supplicant's synthetic WNM keep-alive without using the supplicant's socket.

With the stock modules, eight sends returned success and SIOCOUTQ increased monotonically by 960 bytes per frame:

  960, 1920, 2880, 3840, 4800, 5760, 6720, 7680

With v4 applied, 500 identical frames paced 10 ms apart completed with SIOCOUTQ=0 on all 500 samples. Both the immediate and settled final values were zero. An additional unpaced burst created a temporary backlog that drained completely to zero in 1.35 seconds.

The link remained healthy after the test: 0% gateway and Internet packet loss, and no mt76 pending-TX timeout, firmware reset, warning, or error in the kernel log.

The reproducer and this report were prepared with assistance from OpenAI Codex using GPT-5.6 Sol at x-high reasoning effort. I reviewed the procedure and results and ran the tests on the hardware described above.

Tested-by: Hans Buchheim <hbuchheim@gmail.com>
