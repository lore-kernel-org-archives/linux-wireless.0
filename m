Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112FB3546ED
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 06:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790232336; cv=none; b=ocgpFEcEZ9M4/eiDklHD0GpOvN6YuGmPiozytaxVn6MpCA1BBSyoz6vJY4nj926tNXz88Fw/8FmKOQvZSm6KrUYs7loTu6QxMSFndpHXYb6aq/JtRI69nIcLwFtgv9k3H+C76txiBxyGuYmoExD5D0oTpTWmlKINNN2P45pJJEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790232336; c=relaxed/simple;
	bh=qwaUj7tXmyEj00IOiSMltFEfTtSWmozQq3q5MaxQSVc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=pLMDFfq/9Uy4MH+va9eKv6qtSvpJwyTt5d/3jncrFW7iguyPkuKntGnQNSPd3+sREMkotJyL+wWf9QFLVGJTg6bmTzEEqKWKcTu1psMu7lBbcLsLnzrY1jU9j4vd26BR1hKU8cKh0QsbjLQxWFxUtmShnAn6xD4uB0tHuS+/djQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=IH1m3OGl; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="IH1m3OGl"
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc1ceb47d53so382509a12.0
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 23:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1790232334; x=1790837134; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=M53f5hT8k+fyFbTw7K8y0jbkmvC5C8b2JhM3dUXXYew=;
        b=IH1m3OGlXcPywVXh3cDVyAj4FSsI5416pOIAxBPLUJnNMAPS4xTdCoDqIQtsx3mBak
         Y1Ba/hk0gXgNhfWGknjplK3DvLb+NtyUX4DqXnPeueOrFvdYxNaFeXSzqnAefe/Y9rfW
         /WM85QY5ihDgKe6ANUpj6IYV6lX1ne8P3FZMlz3xkRMK0L/UayPkVTuauW+C8mgSqM/O
         u1IN1sIFlr0aO7iZO6FoJsFqROQ0Nsz2hKRoHIiW1mX1zg2mNf5vUeQCkckSpTNIzxEc
         DFAKqxM/5vom+2B1IxZXBrp3r7H/drlb6a9RIie7wx0J8huVYdTn6nlIvtPYId6p9EV4
         JIiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790232334; x=1790837134;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M53f5hT8k+fyFbTw7K8y0jbkmvC5C8b2JhM3dUXXYew=;
        b=TEMvad3qGmVvAiyoQi4rZBNtoctqcOPcf0riQ1Davs2IRmJdSq6jE3lCVO5K8Xb4TU
         d9NiyjMEgXtSZMkLJmBwxNqwL9WlwRNr9ooxOtjjUAfpX7QIvpLPkZrdt3qbVyGj3gri
         UR2nQtyztB/59Izl4Nwh7084oeMRnXkquBUCcSpWfyo9m3Qfkr/mkcICtaM7pewOXns3
         1ceQBHhooatE/2hRIPevBVpZGg090CTXNeKf9c8zUmHXhXRj3a0uKcfkpZay4aP5gFQJ
         /6ItGYL9dNV/MsEIoP8V4EnWAUqEdwW6VJJpEGWeEBH/nsQGbfTG205mrbjusNNRCJOw
         FVag==
X-Gm-Message-State: AFuF++n67sEdKPnad2EgD4myyMa8cMeRV/BuZrs1jNy7ZIV6p9fPVdLi
	7gJO1eei8N1M34g053xe8AZjO75mHFi66D/Hp0TzulzwSiqeHaGx5cD/cEEwkL79ljjJgtl5agz
	C8pEW
X-Gm-Gg: AYBFou0AryDvGtcEBMOFTAZkaZdbJRbco7X8/EcKn8guwZJV4KHQf/kl7Et5iDNN9je
	X9+RGCjq4WE8azS5cRXOEC8KDhs+kleN1543/Er1NF+4IB6z08OmX+b5wPjHgJXTguuuZDX+wRZ
	smI0JQ/7w4wd5vglCJpyMkTlputZxwl+i6FahMxtIrne0CtepI0wHHqM0OfaFIEsBDIXRyCOef/
	LXlESTRjxEucoSpsf/cVBy8TVc/B6a2DqmYw2UcQUAaz8AgixqyCkm/YMlQjWHEt9YAu+/AGg2g
	w3QxlrJBfsm5E2dIqIM1LMX527DPeg2sEn0G/7c75IZVDDeQpQjHYfjN7p5vuxYPukZnVqe+tWi
	1xy1qSdbpfj2o2zsEvSPU87+n0ET2ZBmfZmAiDbC7me9OiU4n1dDx59nio1Uwbjqc7vA1eruiOY
	uc8PGjgHcS5evTSzV9QkMfsU2bTukROVpvAmUqjZ1K6HU7C2hUfw+5UsYy59u2Oi9gRW7Ro2qAB
	UnvYY8W/HPZLKpmv6dDyXdc+8ADwFkVLV3gOx94acgg1xsE
X-Received: by 2002:a17:90b:224b:b0:3a0:78b6:588e with SMTP id 98e67ed59e1d1-3a098ac6431mr842230a91.23.1790232334197;
        Wed, 23 Sep 2026 23:45:34 -0700 (PDT)
Received: from localhost ([60.227.235.15])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0976c8f8dsm3084004a91.12.2026.09.23.23.45.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 23:45:33 -0700 (PDT)
Date: Thu, 24 Sep 2026 16:45:31 +1000
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, arien.judge@morsemicro.com, 
	dan.callaghan@morsemicro.com
Subject: pull-request: mm81x-next-2026-09-24
Message-ID: <gda24qlmc6col7tf3u4c2sqmh5j3w63sovh5n3zavkhfboqjid@vk2n2vildz5o>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

first PR for 7.4 signed and this time tagged with a message :).
Please pull and let me know if any issues.

lachlan

The following changes since commit 1b78070aaef63512688aebfbc82365ef9d6660f1:

  Merge tag 'net-7.3-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2026-08-27 13:53:43 -0700)

are available in the Git repository at:

  https://github.com/MorseMicroLabs/linux-wireless.git tags/mm81x-next-2026-09-24

for you to fetch changes up to dc1936211335eca00acca53d058dc94fbab02028:

  wifi: mm81x: do not discard a failed firmware segment write (2026-09-02 21:44:53 +1000)

----------------------------------------------------------------
mm81x 7.4 PR #1:
- buffered multicast improvements
- tx bandwidth selection improvements
- misc minor bug fixes (mostly LLM)

----------------------------------------------------------------
Dan Carpenter (1):
      wifi: mm81x: fix type bugs handling sdio_readl/writel()

Lachlan Hodges (8):
      wifi: mm81x: move beacon work and init below the tx op
      wifi: mm81x: release buffered broadcast frames after DTIM
      wifi: mm81x: do not drop PS filtered frames in AP mode
      wifi: mm81x: implement .tx_frames_pending() mac op
      wifi: mm81x: factor out tx width selection
      wifi: mm81x: tx EAPOLs at primary width
      wifi: mm81x: clamp tx width to stas max supported width
      wifi: mm81x: tx multicast frames from AP at primary width

Linmao Li (2):
      wifi: mm81x: free the firmware scratch buffer on parse failures
      wifi: mm81x: do not discard a failed firmware segment write

 drivers/net/wireless/morsemicro/mm81x/core.h |   7 ++++++-
 drivers/net/wireless/morsemicro/mm81x/fw.c   |   9 ++++++---
 drivers/net/wireless/morsemicro/mm81x/mac.c  | 181 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------------------------------------------------
 drivers/net/wireless/morsemicro/mm81x/sdio.c |   9 ++++-----
 drivers/net/wireless/morsemicro/mm81x/skbq.c |   7 +++----
 5 files changed, 133 insertions(+), 80 deletions(-)
