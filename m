Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CFEA483BDB
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 09:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791364417; cv=none; b=AmSDnPrFyQg7E7w+nIz2uYGai/KvlOIKwjMCtiMN3hE7OQnISGMo5/FUNOk1IkCRpSZDwGpgibXa0CA1N49OvSIopE2R1QuzbcgdIczhqjxfwZH72of9RQeca3LVVwozThFNtIw+/Igdt0LycILGXlQVt569FvRW8tqqWMjGH+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791364417; c=relaxed/simple;
	bh=1haQIVkT36yMZQ2LPONfTmKFM5Rpi4SAvxl9vaFUBdw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DOJMKPoIw9bQeMFqgR6g9Jx/LvuIZID+FaU2G6g8Me/c1BJnCbpQ3TkT2d5P+aOj+JfYbkim5K4jwSVr2d52o8BLTBbRZocvaDm5XhkUr27RiMZXJzpHAuvmwnWFlk4cQ0D8+sUg1K//lMRy71V6TtldIH4AkljrqnxJ4ODdOYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mztPi0rP; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mztPi0rP"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a0286c981dso34627325e9.2
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2026 02:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791364366; x=1791969166; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=oBG4Nfac7OkzhOS50O/7A/RERsw5p2FWRxDEx4wKLw0=;
        b=mztPi0rPLSNoUmEWphbzUQqN3CkColUusFjtUgbnCx574akM0vjCgv+FfO/u0PijSm
         U4dQCbGpH0Je0roRR9AnzvCvLVQOflKZZbPpgcJ6pZB05v4ldKlBXllpYJzW6TWMDbY7
         9QkguUwWERbLDXneRhorSHIXDlXamBF7A9exhLILH6di4gvL0Km5eud3JaKT3j3VZKAt
         HibqDIoqGV4ffFkPFqEriSt1mcCX95dagIZrljrLinQ+mkpQVmeB7zV2Expb39Pp6Lvc
         WHjg6w2b6gbxMQ6fmZvvKt0Hm1pxeHhidEUn+iX3AiAHYJl9a3gZTo2nMqkQFpd+bcO5
         VgyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791364366; x=1791969166;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oBG4Nfac7OkzhOS50O/7A/RERsw5p2FWRxDEx4wKLw0=;
        b=khwv7bHvWOSXMPeOJRCDpFJb1mEqaSmsJWQpA9+FAZqxgX14qx/+3Q/7IVFQFyccoq
         8AkdmcjJ2QV0XjJpORXIS1554fqIL/r6qG46XoGJPnDiw9SPsByIossu4SX5U7DBf1hq
         7jAz3SZEo/9w+ItgHm5kW2mNIrhNPgmfEnsCodhHKCs6xQpXI2pSXOtUgE455v2qhqpa
         WvVsras8XmbwCIdpwWV8DTbm41P4ojJpou9RS1THnQCtnMo0tB3OaOyYhwDrWDFelllV
         nQ3rNJh7/z8kEkzxBx3SqV/jFP+nZsoaJhMYk90YBRQjt4QeaHP5VbhTakCeniTt1svO
         WqRQ==
X-Gm-Message-State: AFuF++nysIPyXhpjOZyuWbibunJHD8MnyvyIWRsx6cNnwy2DGnW2M6w+
	Ud848x0NZvUadVmhiCbhZf6LxNY8bacqUbwy6Rq6hj+CxDP2kNVij5Yv
X-Gm-Gg: AYBFou0SybXoD6OB9n3pvXAULkLQkz9f/RSIi+rC/F4fbkk6sQk57QOKM5BR/oP9ucR
	1skaXuyRvvdl+lrI7TKxLoFdL2N4hZTif45rQO0WdjrMFg7fPedCZr3xlpVEvlA4AgUv5EypObZ
	gvkC2/Z3BUwRPvrR/+4ML9fyNeufS9/f7My6vuBv2Eowgu+/VncSCeMY2oslUBRMO9/S40cE1iS
	PqqHwNoN2kC9F3tuRjejkiv7+Jxntt2RAW3L7QFEzz1mveHf/x4CFsOlGrf0pqnYlIdygQSCPP9
	00L6ET05iXMGIeF2D/TBptUBT3hchrgtBczYAEsMPOIud3e74MsiMgW4MX4U4DQpgJB2LktD4Hk
	on9w6GdtHjsou9opAC71uXi9UASqLLUKHuvwRFWIgXqaGpuAP+XrXvRWdATABMnZiXISG+UyW1E
	8QhBbDQY/YVYhajPdGd4wvY8+Ac193+QNnelNd9gs0Gb3/c1OI/ZLdnsqrYIIb6Y9iiyZwQ48Mo
	4Y=
X-Received: by 2002:a05:600c:3155:b0:4a1:7ecc:b23c with SMTP id 5b1f17b1804b1-4a18041ad89mr18602825e9.6.1791364365598;
        Wed, 07 Oct 2026 02:12:45 -0700 (PDT)
Received: from PC ([176.229.9.157])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1822af9d5sm17617555e9.15.2026.10.07.02.12.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 02:12:36 -0700 (PDT)
From: Jeremy Fareau <jeremy.fareau@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kalle Valo <kvalo@kernel.org>,
	Brian Norris <briannorris@chromium.org>,
	Jeremy Fareau <jeremy.fareau@gmail.com>
Subject: [PATCH wireless 0/2] wifi: rtw88: channel and control frame filter lost on interface restart
Date: Wed,  7 Oct 2026 12:12:23 +0300
Message-ID: <20261007091225.413-1-jeremy.fareau@gmail.com>
X-Mailer: git-send-email 2.53.0.windows.2
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Two fixes for rtw88, both with the same root cause: after an interface
stop/start cycle the chip is reset by power_off()/power_on(), but
mac80211 only calls config() and configure_filter() when its own state
changes. After the cycle nothing has changed from mac80211's point of
view, so neither the radio channel nor the control frame filter is
reprogrammed.

The user-visible effect is that iw reports the configured channel while
the adapter listens elsewhere, with no error anywhere. This makes an
RTL8814AU look like broken hardware in monitor mode.

Patch 1 programs the channel in rtw_ops_start(). The IPS resume path
already does this in rtw_ips_pwr_up(); only the ieee80211_ops::start()
path was missing it. It is deliberately not placed in rtw_core_start()
so that the IPS path, and its rtw_coex_ips_notify(COEX_IPS_LEAVE)
ordering, is left untouched.

Patch 2 restores REG_RXFLTMAP1 in rtw_core_start(), next to the RCR
restore that exists for the same reason. It applies on top of
ed51a86b787f ("wifi: rtw88: Enable receiving control frames in monitor
mode"), which enables the filter but does not restore it after the chip
is powered back on.

Test setup
==========

Raspberry Pi 4B, aarch64, Ubuntu 26.04.1, kernel 7.0.0-1020-raspi,
in-kernel rtw88 with ed51a86b787f backported. Two adapters on the same
host, both in monitor mode on channel 6, captured in parallel:

  - ALFA AWUS1900     RTL8814AU   rtw88_8814au
  - Linksys WUSB6300  RTL8812AU   rtw88_8812au

Isolating the channel defect. Six runs, full USB unbind/rebind between
each, 25 s captures:

  run  sequence after "ip link up"          frames
   1   set channel 6                             3
   2   set channel 6 again                       0
   3   set channel 6 twice in a row              3
   4   no set channel at all                     3
   5   set channel 11 - a real change          431
   6   WUSB6300 control, same as run 1        2438

Only an actual channel change reaches the hardware.

Both patches applied, five consecutive down/up cycles, 25 s captures,
total frames and control frames:

  cycle   AWUS1900            WUSB6300
    1     6639 / 4556         2274 / 1506
    2     9622 / 7754         2937 / 2214
    3     6847 / 4985         2166 / 1475
    4     7420 / 5542         2493 / 1789
    5     7703 / 5250         2440 / 1625

Without the patches the control counts are 0 on both adapters, and the
AWUS1900 total drops to 0-4 from the first cycle on.

Also verified
=============

  - rtw_set_channel() takes no lock and every caller already holds
    rtwdev->mutex, so the added call in rtw_ops_start() is correctly
    serialised.
  - Station mode unaffected: scans return 28 then 34 BSS (AWUS1900),
    10 then 11 (WUSB6300).
  - Three rmmod/insmod cycles, clean.
  - dmesg: no WARNING, BUG, Oops or call trace.
  - checkpatch.pl --strict: 0 errors, 0 warnings, 0 checks.
  - Build: no code warnings.

NOT verified
============

  - PCI and SDIO paths. Patch 2 touches rtw_core_start(), shared by all
    bus types. Only USB was exercised; no PCI or SDIO hardware was
    available.
  - lockdep. CONFIG_PROVE_LOCKING is not enabled on the test kernel, so
    the absence of a deadlock rests on code review and on use, not on
    instrumentation.
  - Other chips. Only RTL8814AU and RTL8812AU were exercised. Patch 2
    also concerns RTL8723D, RTL8703B and RTL8821A by construction.
  - Bisection. The Fixes: tag on patch 1 was derived by reading the
    history, not by bisecting.

The series is based on mainline 69f80fef3153 (v7.3-rc7). Happy to rebase
onto wireless/main if that is preferred.

Tooling disclosure
==================

Per Documentation/process/generated-content.rst: the diagnosis, the code
and the commit messages in this series were produced by an AI coding
assistant over an interactive session. I was investigating why an
RTL8814AU adapter captured nothing in monitor mode while an RTL8812AU on
the same host captured normally; the assistant proposed and discarded
two incorrect hypotheses (USB power, then a first-configuration-only
effect) before the measurement table above isolated the real mechanism.
It then wrote the fixes, built them, and ran the tests listed here on
the hardware described. All numbers quoted are from that hardware, not
from the model.

I have read and understood both changes and I am taking responsibility
for them; the Signed-off-by tags below are mine. Both patches also carry
Assisted-by: LLM per Documentation/process/coding-assistants.rst.

The patches, the raw measurements and this summary are also at
https://github.com/jeremyfa55/rtw88-monitor-fixes

Jeremy Fareau (2):
  wifi: rtw88: program the channel when the device is started
  wifi: rtw88: restore the control frame filter when the device is
    started

 drivers/net/wireless/realtek/rtw88/mac80211.c | 16 ++++++++++++++--
 drivers/net/wireless/realtek/rtw88/main.c     |  8 ++++++++
 drivers/net/wireless/realtek/rtw88/main.h     |  1 +
 3 files changed, 23 insertions(+), 2 deletions(-)

-- 
2.51.0

