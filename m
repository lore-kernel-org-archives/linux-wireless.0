Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172424E1415
	for <linux-wireless@vger.kernel.org>; Thu,  3 Sep 2026 15:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788449796; cv=none; b=jhhrSoi6ZJfwYRwZA2F4HcMFbUbZ2WZgJXjfEsXpZqLAvBe9wU6b2V3imEe40DduwZFeBa9Hb/8T77/nSrOSN98nKDwDIv9e8kaYV/B6Alzlg0UDZw78oX6ax35EWfI+ibQL2+92F/sqMvXQiBGt34u/YUKqKEKM8bTtJESIUps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788449796; c=relaxed/simple;
	bh=Y4N5n3dWF43z5fnhzSjvS2JctFJVZQSgkRXuPz00tj8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hI5r0MeEy2eTTocNPcBMXRE5iqndh5ihrlhYXJEP6GxkJiBVh6Jsd1dUtUMlVmBSFurDPgU8rmgBqfwceZ2AKplcknjCLZ2aVI6VrQCbm9g3a2JH+b6BhWnxxIJxEyWNP4ExqcZnPe6LL751IO73Gwvl4PI3Ypt//EIJQdUYraA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XcKC2slh; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XcKC2slh"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-499b2981a7bso26783745e9.3
        for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2026 08:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788449793; x=1789054593; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:sender:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=HxVPdMsVHdS0kk+CtMD8XqvKLESkGAfNVL5qV8f2BIs=;
        b=XcKC2slhhxO/9v0o3/hAySnngt2tHiRC8VLBEiR5/b5ZFYERL796+2Gt/mIEvyJadv
         zdNozbMPLfn0jtGrUxR1/C01FgoR+ULTKHuZEfXX1TK/sFsEh2IO7OI9HBE2rXzyXK9S
         Xf5YIS9fWvwbeRb0G92SMZ2h19jkW56Bsfh7vr9qxzd2Z19amz9I3OjdLSCi3CbA2kl1
         WOB3YY2eFFMIvFBX8tvuwljRjfpPOhNX/s/WpR+ssj5SMAynIEm1+XPKedaxiMIj1XGc
         NF9jyOrL4ymTC5u0nzgwBMCv2qsFyaJTzysL9F6lH4QxN/E0ytnPUh4xY/3Fo6GIMCGD
         hf6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788449793; x=1789054593;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=HxVPdMsVHdS0kk+CtMD8XqvKLESkGAfNVL5qV8f2BIs=;
        b=pjkERCqyYBZiY/OolMG8mE+rxscn4PX826HEscwC+bK2qvx0TFhiyOHwnM86d2rTqW
         5TObEHis/kKO/YJUPZwrFlPVNREZwTuH9ItnLKcZTzSpy0OvVkJUdMMyS7dtmW0Qxi0V
         txLzFA6CY2/zp3+17pzqjyDPZn5WW996RaezIJ7f4AxvDPhrrhruk25slEJXjZq7dH1O
         iqpZKK5LtbVxQJIoto3avTIk4i11EEuSumrcbypWWOGxssmgQ6zF4kA9Oa4nv696elsT
         tC0TLSNiQiZnd+NZOSX5ltZiCPOnlVU1R7OYKBaBUOtENrRpFsJh3Lv/k0EaoEHaSr7i
         gDQw==
X-Forwarded-Encrypted: i=1; AKwUvBxyK7tHnYABiF7DJIhKPTEloluL+6zfjcUu+t1/6meOl2RNFe0C/wiqYrmc+T0YNVzpmrnkYglyzBCrknz7fw==@vger.kernel.org
X-Gm-Message-State: AFuF++mNbOI6nI/TxnhWv/sMEYmxdRGqGX7R57UmdfkoEYZOEm1kGf8E
	xt63MlA3JhnYlICqnlYTIw4WPn3ZK0E6rxsXngUOyzbjWNDeSFbMdxnsbixH
X-Gm-Gg: AYBFou2OESRGI0Y/d9eVfg8+0QqvNSHQQuwQStoiBf01yZbBRRBegFm6k+MCw9G/FRA
	lS2+QGogu6OqN8TtIZUnlHdTR8jwKQk64OVuMBfUeymJkG71CCBo2dtEF/zE9w/L+/6V1Soyqr+
	PlGIlVc3roX3yIg6Drs0oirS5WUXpOnlEmYM8e42JFADZIvaHEMSUjprlINRmrvjdZYUFooEPmE
	+ZMLO1AZze1qx3m8Rnfdky5J2Xq3U6XHaGQjilJmBiU8SGnnItp+DsBAmeT6XKUo2QfKuB7w3Pb
	bVIU2Z/XsyI8UVQ7NBf2GvrUJkIEEjYUHkqUiE2irHLMCHKw+XG5URHiaBwo7QD+l4kQckfDxUD
	v8ysxZWBTyHIzzrq8++N7bvuM4KqGkUttlf5DaXAbsRivMGdWIaVssRQzhrZDYTeNX6FAFDmqtO
	63dkj39kWlmXChXkgwydJ3DjG3D33xOGMoqNVgzAdJcaCXYcHaQxOiY6/WkrjJuTbcXaJTbi9f6
	nbe7IQStAJn2wuUy/bb9cmrgMgmqssazxVq3zpqtYoK9NqTvFzkH+mYN6P9QILTSirE4k8qUEtV
	eyImiVC1kQH4eHY=
X-Received: by 2002:a05:600c:4684:b0:49c:f617:7cf with SMTP id 5b1f17b1804b1-49cf61707efmr7854075e9.0.1788449793027;
        Thu, 03 Sep 2026 08:36:33 -0700 (PDT)
Received: from nn ([2001:1ab8:1003:0:5454:f357:ba89:4e22])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ce831af89sm75568425e9.1.2026.09.03.08.36.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 08:36:31 -0700 (PDT)
Sender: N B <gen.benner@gmail.com>
From: =?UTF-8?q?Nerijus=20Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/5] wifi: ath9k: cut USB round trips on channel changes
Date: Thu,  3 Sep 2026 18:36:12 +0300
Message-ID: <20260903153617.990995-1-nerijus.bendziunas@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Every register access on the ath9k_htc devices is a synchronous WMI round
trip, so a channel change that is nearly free on PCI costs tens of
milliseconds over USB. These patches take round trips out of that
path without changing what the hardware is asked to do.

Patch 1 writes down the eight-register limit on REG_READ_MULTI() that
ath9k_multi_regread() has always had and never stated. Patch 2 makes a
multi-read that times out over USB return all ones, the way a single
read already does, instead of the stack contents it copies out today.
Patch 3 replaces the ten-queue ath9k_hw_numtxpending() poll in
ath9k_hw_channel_change() with two multi-reads, and needs patch 2 so
that a timed-out read still counts as frames pending. Patch 4 wraps the
read-modify-write runs in ar5008_hw_set_delta_slope() and
ath9k_hw_start_nfcal() in the RMW buffer. Patch 5 drops the departing
channel's noise-floor readout on a fast channel change over USB.

Patches 3 and 4 sit in code that PCI runs too, but there the multi-read
is a loop of ordinary reads and the RMW buffer callbacks are not
installed, so the register traffic is unchanged. Patch 5 is gated on
ATH_USB.

Measured on an AR9271 (0cf3:9271), counting WMI commands with a debug
counter added locally around the driver's channel change:

  full reset, unpatched            182 commands   ~92 ms
  channel change with 1-5           44 commands   ~31 ms

The queue poll alone was around twenty reads per change, and the two
read-modify-write runs another ten commands.

The second row also needs two changes that are not in this series:
taking the fast channel-change path on same-band retunes, which mainline
does only for off-channel scan hops, and a mac80211 fix so a monitor
retune performs one driver channel change instead of two. Both are
separate, and I am not asking for them here. What this series
contributes on its own is the round-trip reduction that those then
benefit from; mainline as it stands sees it on scan hops.

One note on how this was checked, because it changed the series. Two
further patches that also cut round trips, skipping the PCU
re-initialisation and the WMI_SET_MODE on a fast change, measured about
twice as fast again on a channel-switch latency benchmark. They also left
the receiver dead: ath9k_host_rx_init() is what clears AR_DIAG_RX_DIS and
AR_DIAG_RX_ABORT, and without it the radio retunes correctly and hears
nothing. The latency benchmark could not see that, since it only timed
the tuning. What caught it was two AR9271s coupled over coax, one
injecting raw frames and the other capturing. Those two patches are
therefore not here. With patches 1-5 in place, the fast path delivered
90-97% of injected frames on the standard 2.4 GHz channels across
repeated runs, against 95-97% for a full reset on the same build. The
spread is the rig, not the patches: the same binary can read differently
minutes apart, and the fast path shows that drift first because it does
not recalibrate, which is the reason mainline limits it to scan hops.
Those numbers are from cards on root ports. With the receiving card two
USB hub tiers deep, fast-path reception was unreliable with and without
these patches while full resets were unaffected, so that is a property
of the fast path on this hardware rather than of the series.

Changes in v2:
- New patch 2. While tracing a different WMI timeout I found that
  ath9k_multi_regread() copies an uninitialised buffer out when the
  command fails. In v1 that turned the fail-safe queue check (every
  single read returns -1 on timeout, which reads as pending) into a
  coin toss, and it also affects the existing ANI, EEPROM and register
  array callers, so it is fixed on its own with a Fixes tag.
- Patch 3 gained a comment sentence saying why a failed read is safe.
- Patches 1, 4 and 5 are unchanged.

Nerijus Bendžiūnas (5):
  wifi: ath9k: name the register multi-read limit
  wifi: ath9k_htc: report a failed multi-read as all ones
  wifi: ath9k: check all tx queues with one multi-read
  wifi: ath9k: batch the read-modify-writes of a channel change
  wifi: ath9k: skip the departing channel's noise floor on USB fast
    changes

 drivers/net/wireless/ath/ath9k/ar5008_phy.c   |  2 +
 drivers/net/wireless/ath/ath9k/calib.c        |  2 +
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 10 ++++-
 drivers/net/wireless/ath/ath9k/hw.c           | 21 ++++++----
 drivers/net/wireless/ath/ath9k/hw.h           |  7 ++++
 drivers/net/wireless/ath/ath9k/mac.c          | 38 +++++++++++++++++++
 drivers/net/wireless/ath/ath9k/mac.h          |  1 +
 7 files changed, 71 insertions(+), 10 deletions(-)


base-commit: ca800a9302764c445de0da0e84d2252400a770ee
-- 
2.55.0

