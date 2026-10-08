Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1233C3F41
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 06:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791440498; cv=none; b=hvxZMppY0yG617UUb1fDJ6Cm1LHn8X8ITLoOVnXqWLseIv+S/gRe/bNvqVplezqZVxFgRnKYqP3/FPbeDT79VhmxiQriZngN/GU1Ne7MyUWWvUpLLO0GiH3KLXbUgBFci2d4Hwsikk+UcB4xN2mkvixZpIbORD/9VsUJKKsiSjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791440498; c=relaxed/simple;
	bh=uw3oIHXvtazNUQ/cNZ8byNvKC47HzCq1j5tqOHr5ijw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uwK04ifbMIcTRkjPCEI2+qaZL1Ib9QXWvrWXZX5kIUiGvg6kIFw1hYvFkDb0dbxfF9LgUQpL931BPbZx9yjQEbOin6nm1kCOD6Bq81WtoFqnGdC/yCAMQNEDXAKkyKKsOmca9URjXMsXSnr9zLEOO5xJ5dPMKjrD+B9nTEuLvss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I+Rv/aM0; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I+Rv/aM0"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4995b0343c1so39513185e9.3
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2026 23:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791440491; x=1792045291; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Hnyng5zB95tr/7QI7f4XsrAoeW8ORCn75nCzSg35aEo=;
        b=I+Rv/aM0roBfkB2cSersJWpVBrGrB1p0Sy6W6FA1INxMRn+qVeWGrjDZZXObvy0r+k
         0/NAXId6lvVSUpw9bD4JOoS7aaDXS/cl7FQADXmzTo2nVvpN84XZdzGxIs6JVdT454V0
         00gDSae2l+UONkK88pnEwWhBa45TNEhuLn3TGA0ZVR7RRRMdQi61QG5q+nNgrtPyyx8R
         9yNp7vlU7KFQsuhgj5qpMGM31ceTO2qMC/ovRw0+4ptq5hWPBnUPfUgJ1MLbOnafVIAA
         l0lfjgycpGiftp8gA6k1nIPf5ZUvEEh5veCoMev6OxJZliXVal3CtsdYF75Kzd1t3WqV
         4PKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791440491; x=1792045291;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Hnyng5zB95tr/7QI7f4XsrAoeW8ORCn75nCzSg35aEo=;
        b=kA6JOn2OStiqayMJEuPUld3cQD1leyKFYZhM01c2V1QUjS86axI3f8DOlWuPzP4gc3
         69TjHQFRF5NXOjSIqA41VbMMT9ecA0cs3BG66EDlbXmXLvW3PE9D2PQNeHcZcjZ4ZEAu
         bz26aYXaY5TWKmzbcjkPShO2RLivbB4cVxebf7pZiaMZRBqHEtYR6TIB9uAgZCspPfHb
         MbFI0G6d/kLno5Ujs19PS82zM6wr4CpvZsyxx8oR6HXbJcXDQJcWog5NmeA2iF7LG2EY
         dWevKxI7bvIx704ImvCMfgR2mjPAPSKBHCxJ9MWcMaQmWfHRTmnV5sFWgoEgOJX63+uF
         PxZw==
X-Forwarded-Encrypted: i=1; AKwUvBwFxQmmxyAvLBLL+dUGPy+yQBYj+/WKFuk+fW4QB4NSxJDkBUdd0KJw3mGpgzFn89wU7QSvph/Z/tmRip/eZA==@vger.kernel.org
X-Gm-Message-State: AFuF++m4tsk7HNBvkaiSQ368TqndynnZgSCEyv/Sam+bZHq6FOxH1xhn
	rJlsyNImbnZoVV/oavmLRoQ/IG5LfxQnllMeLNSEHOOZ2292Vst/xyMb
X-Gm-Gg: AYBFou01X//8vdZQGp6XJZUbd6IveiKtkZrFvaY3rS7Osl89qyBhsUw6sAfv/s2dAgN
	uF4RrTas4fOLp8jxOSRbCf73VlHdz7J0ZByXX6YqRdUFWWfmn+MrY6mcrQrf694etlx0HK7EiG6
	S9N6FJ3i6qO00uKHItEWReXTPiUvfdnm45f7XKrT81IIYCGrhApDLtd6pE5xH1RGzGBan2iXShz
	2A2IrDmJ72Ws2vtv7iK1i4kuytIneDkAfL5wxZRmVd3QK7ERa2wK0kHAoY1lvBS1dKj2M87F79c
	XtXQxlQ3ikVo+WEz8XU68+2Bw1YGU0POXS7QsQNqfMP0JD1jpbhSKRpU60jO7tvargEal4jHpxa
	bv7M7hqEn7K71C8E393PXLt61is5Vk9e34OsXnxFe/5sLSiEJQoWR7uvzLZmnWxCCs7xPJxY4Wm
	BVYDcXxqpDk3hP185PaYiYDsJJssqftRkQmYuq8WrsKhxyBTlDPlwq4fjy7vmLIEpqVQ537dycz
	BqdlRZj8Fud4rc=
X-Received: by 2002:a05:600c:3f12:b0:4a1:7ec7:a479 with SMTP id 5b1f17b1804b1-4a18065eb7dmr74540665e9.33.1791440491366;
        Wed, 07 Oct 2026 23:21:31 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1843e3356sm40309455e9.14.2026.10.07.23.21.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 23:21:30 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: [PATCH rtw-next v5 0/3] wifi: rtw88: channel switch in AP mode
Date: Thu,  8 Oct 2026 08:21:26 +0200
Message-ID: <cover.1791362281.git.mehmet.fide@screeningeagle.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mehmet Fide <mehmet.fide@screeningeagle.com>

An rtw88 AP cannot change its channel: the driver does not announce
channel switch support, so hostapd's CHAN_SWITCH is refused and the
only way is to tear the AP down. The series fixes the beacon download
the reserved page build makes twice, makes the TIM beacon update a
wiphy work, then implements channel_switch_beacon on top of the
firmware's beacon page.

v5:
- 2/3 is new: update_beacon_work becomes a wiphy work, so that it can
  look at the channel switch state under the wiphy lock; it checks
  RTW_FLAG_RUNNING instead of being cancelled in rtw_core_stop(), which
  runs without the wiphy lock on the IPS path (Ping-Ke)
- 3/3: rtw_fw_csa_active/start/stop() assert the wiphy lock (Ping-Ke)
- 3/3: hw_scan() takes the mutex with guard() (Ping-Ke)
- 3/3: a comment on the association download names the STA+AP
  combination it skips the download for (Ping-Ke)
- the whole set ran on a PROVE_LOCKING kernel without a lockdep report:
  switches with counts 1 to 100, hostapd stopped and restarted during
  a countdown, scans during a countdown, a firmware crash during a
  countdown, three stop/idle/start cycles, IBSS, 50 switches with a
  station attached, and on the RTL8822CU a station interface
  associating while the AP interface counted down

v4:
- 1/2: Reviewed-by from Luka
- 2/2: the countdown work is back in the device, initialised once,
  with csa_vif naming the interface; no interface iteration and no
  lookup through the reserved page any more (Ping-Ke)
- 2/2: the countdown is cancelled before a firmware recovery restarts
  the hardware, instead of guarding the work with flags (Ping-Ke)
- 2/2: the page download on association skips a running countdown,
  like the TIM update and the PG backup (Luka)
- 2/2: the scan refusal comes before the scan offload test, so that
  firmware without scan offload does not fall back to a software scan
  during a countdown (Luka)

v3:
- 1/2: the beacon out-pointer is initialised in the caller (Luka)
- 2/2: the countdown work lives in the interface, remove_interface
  cancels it unconditionally, the queue wrapper and the comments are
  gone (Ping-Ke)
- 2/2: the TIM update and the PG backup on set_key skip the page
  download while a switch is announced; every beacon fetch advances
  the countdown (Luka)
- 2/2: the commit message names the refused hardware scan (Ping-Ke)

v2:
- 2/2: a hardware scan is refused while a switch is announced
- the rtw89 mention is gone from the cover

Mehmet Fide (3):
  wifi: rtw88: download the beacon the reserved page was built with
  wifi: rtw88: update the beacon from a wiphy work
  wifi: rtw88: support channel switch in AP mode

 drivers/net/wireless/realtek/rtw88/fw.c       | 107 +++++++++++++++---
 drivers/net/wireless/realtek/rtw88/fw.h       |   6 +-
 drivers/net/wireless/realtek/rtw88/mac80211.c |  36 +++++-
 drivers/net/wireless/realtek/rtw88/main.c     |  13 ++-
 drivers/net/wireless/realtek/rtw88/main.h     |   4 +-
 5 files changed, 141 insertions(+), 25 deletions(-)

-- 
2.55.0

