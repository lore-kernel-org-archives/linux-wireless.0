Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0165B39A070
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 07:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791876618; cv=none; b=J0yWiwf+LGitGZ4F5gkJJb2GNtJsBiZfKReO1uXGU/0BMp/h/sqBQdQ/GpKuq/BfXRqGkaMQ7EN5i8uSwzk4jv4dwSTUbK4GacApWENzVaEnvj58I47kTR+80GL5lMz6iGrSeUj2oF/GDF83NDYsTGwYDwgovchj5TaPcM4Z+QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791876618; c=relaxed/simple;
	bh=8Zcnc8WofbtCm3DYN8jyqiFBVQ6+ylqXd3wr/rTkc3o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y4RQ6q60M/w/ZvlhxSr7v9HaS9Q7Qr1CjuiCj78YIJq9xs7CsAU0BBZKKUXydqQPDYCvOmsTGCk9om7eklOr2AHYmb1WaPemT/29yx+swY2SqfsF3qbvNh8iB6NzsDHvEZ4CKBRq7Zgq5hHjXedgQfTnSPLuPa5boT9E5F4qIlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q3Lwue9C; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q3Lwue9C"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a0213948d3so15899285e9.2
        for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 00:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791876615; x=1792481415; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=eWcmy1Ej3WG6kz7u3KgX8RQlcedhdjpfbUCLK+AYaEw=;
        b=Q3Lwue9C9eiy7Ho3SfzNca6DBMuEvvSymJkOEIqbFT6ZMdVE18vgexAoyEfLXPXkIA
         ah1cKCFN+zXvwyjswRRK8rJVQsBAUiiVcctGnjQ9f4Sby1P7tkTHT5eKA9xdQRMXUVeg
         Rv1JmcoE6mDTwxgrLYeWZb+Dv7GHX1Hpv2iEdSodZq8ZvX6VcUh54m+s2K5wqRiwxAE6
         mrosJTlMGOsbwWDE1piTfcKkFJgFcJVIPDxzbKjJolzjOGGHVRx41hzHFqg0QxHSNTSg
         IUY4hJCCwon28izkxP9+w11sDp9fwo0acH8ZI+ufBp3XKq7m0S4pr2vNi/J/nYOdhkg4
         0e9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791876615; x=1792481415;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eWcmy1Ej3WG6kz7u3KgX8RQlcedhdjpfbUCLK+AYaEw=;
        b=r3bGZS96L6gk4t0A+qRR0ddA7IXbdQzAAe+5NBIEC44PEy+gdVbsPnD3J4yzCZaB5T
         ys3ZM/hA5kMsrNLmebtsmJ+vvPLwcEUVt45jmd4cTZKkOCkNbMxbMwamgHBnDI7PSjO6
         o4qmrvTXmVdHQR6tNWlbamuSqeh2jEdnHVPcvcUtuNOkJa2RrYERtHMO8+rOrPfuBiBZ
         uwGDw/ql9bDbyvDQUJ9OHVpc0tlp4FZT9Ox1gIKMAQCWUAtSx4jam7jlCHjMRIdc1mvA
         udq64AaQTR3Ee39HK6ST/xLT0UEvr7qLICYLvfUJ6+EORH7jYAxz236RmTqNGi0cPvN9
         8Y3g==
X-Forwarded-Encrypted: i=1; AKwUvBxEy9A4eGy1S3RW6ctl1S2q+ctrdLhZrWGLqDfFNXSNYhn/51NzG8XBBxEvP5xuaugpFc2HkfHVCCA+aZHKeg==@vger.kernel.org
X-Gm-Message-State: AFq9FYLb1VPj1FxzHaBhEfObrqoYxtH+2y9ABZy6rqm52yGUHWLwB4V6
	zTp0Sqd+31Fut7yMcTGNGjisnmCiWRhvgcrLyad78ZFcOJIbfuGQ4c+1
X-Gm-Gg: AYBFou1A1wfHHj4QXAdeQHZD7+YDyot+0cA16Ubh5o321HuOcQ8G/JSf8GvNn3LtIRS
	W236ldaxZKzhV8fsUGRPkNtfXrhn4JvbZ1MHUgCMMQQZZ2mK66k6Pvl6Xo6f46CurkTm9qIEObL
	PQsgU3uQNQF7qDKSmG6c5PggIOFG1xxcUbwlwlifB23DRdh/99Iq6ctbB2fNYzf6cdP32AHoqeP
	zMq5HB8mEwlbGOqeAHVQSICg6wBhGL3OwX43sZ2K82aYdyIJcvPzZONEEvMibKL8AMMUP4AoL5H
	iA2LDYmVAzliGL9bQufREDEltIOMKHHKpuC0cMco7Yxvdnbsq9MgktCVO+nisy74GOyzqJOX/03
	8xAEyDYgg4FNetedA14y6COcV0lNwF7dJR+bIS7V69UMLNC7FSriRIdoA0MmYM6XwVCI0eUC3+o
	8PUZlaS1Of1wzvfJ2hcvgornYXsV+USIEFU/8vS9ETss8+zcNuH2jCmDI1QXH5WhmfDQB9wplec
	B6j
X-Received: by 2002:a05:600c:5308:b0:49e:823a:9dec with SMTP id 5b1f17b1804b1-4a18e43a395mr229443435e9.3.1791876614692;
        Tue, 13 Oct 2026 00:30:14 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bf3e044sm332839925e9.14.2026.10.13.00.30.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 00:30:12 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: [PATCH rtw-next v6 0/2] wifi: rtw88: channel switch in AP mode
Date: Tue, 13 Oct 2026 09:30:08 +0200
Message-ID: <20261013073010.358756-1-mehmet.fide@gmail.com>
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
the reserved page build makes twice, then implements
channel_switch_beacon on top of the firmware's beacon page.

Tested on an RTL8821CU, an RTL8822CU and an RTL8822BU (USB) with
hostapd 2.10 as AP: switches with counts 1 to 50, scans during a
countdown, hostapd stopped and started, the USB driver unbound and
bound and a firmware crash during a countdown, IBSS, a station
interface on the 8822CU associating while its AP counted down, and a
Windows station following the switches without a re-association. The
8821CU and 8822CU set was run on a PROVE_LOCKING kernel without a
lockdep report.

v6:
- the wiphy work patch of v5 is gone: the countdown work is an
  ieee80211 delayed work and csa_vif is driver state, both under the
  driver mutex, so rtw88 takes no wiphy lock anywhere (Ping-Ke)
- rtw_core_stop() cancels the countdown work and clears csa_vif, which
  covers the IPS path and the firmware recovery; the wiphy_lock() in
  the recovery work is gone (Ping-Ke)
- the BSS_CHANGED_BEACON path says why it starts the countdown, the
  replay after a hardware restart, and stops it when the beacon comes
  back without a switch announced (Ping-Ke)
- the downloads are paced from the first one with an absolute due
  time. Queued after each download, they drifted by about 10 ms per
  beacon interval on the ordered mac80211 workqueue; on a count of 50
  the AP switched half a second after its station had, and the
  station re-associated

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

Mehmet Fide (2):
  wifi: rtw88: download the beacon the reserved page was built with
  wifi: rtw88: support channel switch in AP mode

 drivers/net/wireless/realtek/rtw88/fw.c       | 120 +++++++++++++++---
 drivers/net/wireless/realtek/rtw88/fw.h       |   4 +
 drivers/net/wireless/realtek/rtw88/mac80211.c |  44 ++++++-
 drivers/net/wireless/realtek/rtw88/main.c     |   6 +-
 drivers/net/wireless/realtek/rtw88/main.h     |   3 +
 5 files changed, 156 insertions(+), 21 deletions(-)


base-commit: fbfa27d9b06f025c5f2cfa79d0e01e6400eeff2a
-- 
2.55.0

