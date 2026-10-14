Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A867545D96
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 14:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791988353; cv=none; b=gGk7fZUP14YLioMhusUX2b9G/RBzioVsE32q+TAiz0i9y43XF+YpafbAiFrN9ESJ1xASbSGfH8yZz/fM4q1MopiTkvvjg/wWm1EBMdQP4H1HE/zSuuLM4yudeSBoQkH4YkowPj5N2tbSFrn9g2i8ssK2xgzboNgpfmQqC0+elLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791988353; c=relaxed/simple;
	bh=CkNFkih/PHsQwbdBVQI6aDqUXadsyoT0wO68CIPND7c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hDGH4nbx0zXy3pSAaTwqkK5AWhgNOzObFE7gttHnsimIoKyJTENPceGx/cNcG4coyVcQI+z0zzjH8MwWNT753+/Wt4HfLwp5FptQIzbRtc8ddDYZdq7LMUQUlK8h+wNI7BACKtP7IwS6tZIJ0ut+n4Xe8lPCjaOStYnQERVC6q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cIXxfPp+; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cIXxfPp+"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a0286c981dso9836965e9.2
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 07:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791988351; x=1792593151; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3Vp4nT657Y1gmkh1GAO3l2MeIxGaDsbtKCzwsk3mzmE=;
        b=cIXxfPp+frOgZ6pDRisB28qTaQTTSuPpxmVO/+W6ZSdGfmbcG4pJzx8nnPCJuVNfsi
         tSiWfcv5tYBbR2TkHuB81E2qnz77ktP6FV5OfNW0YO3GBTmQh6QtXMvNfLYEajv2gZid
         MKLlCYYt6imYjIVINqmgBW/tFGA02Yp4hNSBbg3yPEnwbedzYCOvBndXSTa0Sd/s6ANN
         VX42cY/MUn+gmrRQjOnetSQWD9JkhZF9amiJTvz7ekRl1ys41xru+ynTTnMHRnSVJAzG
         kniRtNlo/38Tik+I8BOGXHy2Kt2yMnqVnp4v4Bcthyuwz08ejIAODlXE0jPr1tT0qWH8
         nxfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791988351; x=1792593151;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3Vp4nT657Y1gmkh1GAO3l2MeIxGaDsbtKCzwsk3mzmE=;
        b=ZjMSDrn4GiXNs4R+nbqEcPyX+Ujl5puKvD+rXtVUAG5c84Ol91VV2wFBCyO46y2Cea
         LCxMA9O102+a3KwzrRmIDa5EaPyczznMkcFIlVBLGIsscHgMqUfGcPSscCfUCrV5fOOt
         TyOpXoPq17Abykg5dnnAjkMnosDW9vfMZmgUXG2x8jx4rTNqVzICv7Tfvo40EddKrE8r
         AN3Rd5kPEOpJi594BGwxOhJGFY7pIdqJrATMq6dbbfAvJ9xle3iJYFhj7P251HfVMFyG
         pWyFU6MNhJGcj8HXQzOQbFSeqZN5BmqOHBpsVroN228USFBtrVmQqxnPlDXBLLtSBEsp
         dTKQ==
X-Gm-Message-State: AFq9FYJtguLsmDlzy5+PT/KhoBUIhabnPa2785gqupXyiBW1TXiD4u7m
	HUxZ9Nk4O7l8jkSsFLwZ/6Vcmm3NZq7UX455UiFFzDEnt0CVr6c0axgM4QJQ5pTp
X-Gm-Gg: AYBFou3VpBK0MDpEDCXbYnjk/BMOGUW6nsABCF4AhP5uriNeQRonG7pS7yfgkBc6R7I
	NZzNEd7Vf3D9zmM76FN3WtJ0m5Di5N0vIWTn4sg+ULt5dw2A3i1fNtswOwByuvf+zpJ3u3qdgFP
	S0hUnmlo2++LwDfbCCATP4Rk3AWVo6FTVP3t67ZMT2FX220WsgkzWzbWIhkB5S2fMSOEnyhg1rl
	OP+xHSf9DWMVuA9u+rhJvFcCvfSRFy+KtH7pnrPWiTllgzK0ocWDYRsqFdknXIy5pDPIAoUqfgc
	Sl9Ikl2J/e16Dmz4KDwqJjkEIZIkhr70YGQ1qkT3CWzwXFWmhOGI/ODcEtIIH7ham20QZptVXEz
	oJMRTmaiYlk8EKEo/RwoIULlrS6TGpfbUSYXa02l77sU87kJZ8xiOGT01qu6Rq8oEn/dLJpmMM/
	L3hTeTiDKEQ97hoD2G84LKYDUZjN2pA2y/l5KcE+B0T8WOzZ8fAtvUY2P86blH0f/KqiMeIa8Fl
	GL8v2eQF/Y8xVdp3/GZz8oSP7kuy9T4LXG3XD/ZUmk4MvW0nBWwuxz/l0CVuKpcFtFG8d6MoL06
	SoC6Skmp2qStEgiFgK+lPHszHof9gt5fl/ILjQ+K+2tN4Qn+iQUq0Escq+JVW0sp
X-Received: by 2002:a05:600c:8105:b0:4a1:83f0:7c8a with SMTP id 5b1f17b1804b1-4a18e4433d6mr318840825e9.1.1791988350580;
        Wed, 14 Oct 2026 07:32:30 -0700 (PDT)
Received: from zitrone ([2a02:810d:a1:6000:62d3:e68c:3175:a538])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1bd068126sm3411345e9.11.2026.10.14.07.32.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 07:32:28 -0700 (PDT)
From: Andreas Wendleder <gonsolo@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	b43-dev@lists.infradead.org,
	Michael Buesch <m@bues.ch>,
	Alessio Ferri <alessio.ferri@mythread.it>,
	kvalo@kernel.org,
	julian.calaby@gmail.com,
	jpeisach@ubuntu.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless-next 0/2] wifi: b43: MAC filter and 64-bit DMA fixes for the BCM4360
Date: Wed, 14 Oct 2026 16:32:23 +0200
Message-ID: <20261014143225.82149-1-gonsolo@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Two fixes found while bringing up a BCM4360 (MacBookAir6,1). Neither
depends on the AC PHY.

 1. After an interface restart nothing was received until some other
    change touched the filter: b43_op_start() zeroes wl->filter_flags,
    but mac80211 computes the change against its own cached flags.
 2. The 64-bit DMA engines of the BCM4352/BCM4360 cores use bus addresses
    in the index and status registers. They are detected by probe, as
    brcmsmac does; engines that keep offsets are untouched.

The rest of the BCM4360 support will follow once these land.

Tested on a MacBookAir6,1 (BCM4360, core revision 42) with the whole
BCM4360 support applied.

Andreas Wendleder (2):
  wifi: b43: reprogram the MAC filter after an interface restart
  wifi: b43: handle 64-bit DMA engines whose index registers hold bus
    addresses

 drivers/net/wireless/broadcom/b43/b43.h  |  1 +
 drivers/net/wireless/broadcom/b43/dma.c  | 52 +++++++++++++++++++-----
 drivers/net/wireless/broadcom/b43/dma.h  |  3 ++
 drivers/net/wireless/broadcom/b43/main.c |  8 ++++++++
 4 files changed, 53 insertions(+), 11 deletions(-)

