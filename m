Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACDE24A3F1B
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 14:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791210806; cv=none; b=bSzQ5C4UOfuTxlwYVUALu5TQs1HktcaJL+wX2DWMjQPgn7Em9UlhPQRPQzv6aW3sh2vg7+ZPm0AyXrbmN7GGGPz/f4nlIVwsHf38oFeypiImJZc8FY0cNS6HUmNJUiDEXDg2dyUCrW6IQ9LrqgcS5A6WaW9RBZobjSsMzacWok0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791210806; c=relaxed/simple;
	bh=7BzsIt0W0zlX4zWFBkLaGVeP2JETAjfMyZaGXrAqybM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Cfly8ngIMqvqdQn4hhFH140N4Ni/4n0tEQSSGK6YY4X+blbIQ3B938gMzBUjlbwe+xK3QQP2ozvZbI5fpQSIY4N+uxsbiP0gwfXUTqzxwlIhcZqqI/f8HVBbRd0SK500SYPtGB8afbpbULa0yLrklGObi1M+hb7H2NItG6jRs/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=s5K8hurz; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s5K8hurz"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a0286c981dso17155075e9.2
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 07:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791210796; x=1791815596; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=d80qMXtt2qgyjUsH7NBGqXnx95+rJDKx3BYmmyNTE38=;
        b=s5K8hurzN0yZVMkyiJzg4O6s4KI+1QIWDfSQJJ8XHZyHC1D2dkw/XLLkbeHVC7OaS0
         jPr7bLHbp5nbSyctxehRoeVbeaIa1GmrtYuS5i7T/eJ7a/WzeU906eB/GnbdaPfVBeCK
         UtSwoUkkb+23CKitlsTIzyAdoER5+ADlCRgv/BX1zjPzQh+9oBEnjlTNIw2hMvLqxc6y
         eBYoW6zhMN5Sd4TH4acullMLLndHfOnrpnWUEN8ICeYBbSd2XmUstREa5STP4c8TPIrT
         qHSIlXJ6uh608gIW92o93VyrKppiLymfhtYLG3t3IYUJ8Rd/LJivUgkTmi0BH/ntnyV/
         AHAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791210796; x=1791815596;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d80qMXtt2qgyjUsH7NBGqXnx95+rJDKx3BYmmyNTE38=;
        b=R2sO4SKpws6CM8vkRMZzPw+tiYM13i18eQpcT/cMHifdbFZ78HnNRHJAAOQqkbKdE/
         N575zVKgRWIR1BFntOLuPNxqQZmkmOFFJhr+l4Su/3wHJ3YVtI5irxc3cO9QJCAmSBBY
         AwTynbI++kcLl2niTsi/P6r8lD8Xr4B6Hh6Cj/CpwfykmtOZfhWjxVM7HBsjg1NyMqlk
         l6wJ4DwBO+pDOZCMSl/wjBt/2KUif/QK2K2MA7WwRTBPZ7wgouxQ4y26x6v2JBOqMeuw
         sYnKHQJq1TaYz7xfiREh3U+7rEAkW/CXu1ZAKqIPtdq4vdneIi3f87jOvOdMBd6I8BA/
         vNeA==
X-Forwarded-Encrypted: i=1; AKwUvBy8kNh0z8UrTEgbIhsytHpVWOCV5q59lmVh4W1Ax9S7L7rUhfzB5k3xpgui0Mw8ZsybymnSE0iun5jbh3b1Sw==@vger.kernel.org
X-Gm-Message-State: AFuF++k080AL+0e2oJErp3O0cfxCpwmdl6yqnNuLwYL9af6llMD8/tZN
	u/EkekyUwTMndw/gxcMfYCJuCnSHHQmZtopea1NqdVE9OzghCBEhP2l7
X-Gm-Gg: AYBFou0E2kRojT3N4/Ay5f7aAyzCy64DUG3NYHHAPXivbpSMKs3iEDHXBx3mar0qFnK
	PCeH+PBBfp29UCRvrtkkFtemEnaQxEi/M5HWzNRuBNSFm0QbVMYwuc0Q1Z02buOMVANa5XJHrKc
	jmzLRLCR6hhiTwnpmol3fqtKaFn8hTyAXgzT6u430oPtqggXY2lJ4YlfakT33IXlWzjnsvLhheH
	jTjPE0veBAk9JSRFEZKRSK6t4XXyNPDcJba4UuEtX8JQAbBw0lv3JzrPDDwTHjbqbySYfKpjBmt
	dEdfV//N4cutgHOaJVecRm6CxLWGEQy6NnrDsf3fe/Hn8zpGm3E5Y2uTeJf0qLX2pp4wwMqDUAl
	wWDbLBplm0EIwG4VV4Ho0dv5Hr87hOZBWBJ81uS3VMb936HSJmnLGNFEuvtmnCntId8ULI480cO
	wiD9Or3vz39KF9glgRiDa3LHLVdN7cu1FFt/n0WWniwiLRiOEqjygTzJLrzG4KZRVMugckw5/ic
	XjY
X-Received: by 2002:a05:600c:3e0a:b0:4a1:6843:eabb with SMTP id 5b1f17b1804b1-4a16843efe6mr115141955e9.1.1791210795700;
        Mon, 05 Oct 2026 07:33:15 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a027f2a4c4sm363011895e9.2.2026.10.05.07.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 07:33:15 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: [PATCH rtw-next v3 0/2] wifi: rtw88: channel switch in AP mode
Date: Mon,  5 Oct 2026 16:33:11 +0200
Message-ID: <20261005143313.129670-1-mehmet.fide@gmail.com>
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

v3:
- 1/2: the beacon out-pointer is initialised in the caller (Luka)
- 2/2: the countdown work lives in the interface, remove_interface
  cancels it unconditionally, the queue wrapper and the comments are
  gone (Ping-Ke)
- 2/2: the TIM update and the PG backup on set_key skip the page
  download while a switch is announced; every beacon fetch advances
  the countdown (Luka)
- 2/2: the commit message names the refused hardware scan (Ping-Ke)
- the hardware scan path ran on an RTL8822CU, whose firmware has scan
  offload: a scan with the AP up keeps the beacon and the station, a
  scan during a countdown is refused

v2:
- 2/2: a hardware scan is refused while a switch is announced
- the rtw89 mention is gone from the cover

Mehmet Fide (2):
  wifi: rtw88: download the beacon the reserved page was built with
  wifi: rtw88: support channel switch in AP mode

 drivers/net/wireless/realtek/rtw88/fw.c       | 93 ++++++++++++++++---
 drivers/net/wireless/realtek/rtw88/fw.h       |  2 +
 drivers/net/wireless/realtek/rtw88/mac80211.c | 53 ++++++++++-
 drivers/net/wireless/realtek/rtw88/main.c     |  3 +-
 drivers/net/wireless/realtek/rtw88/main.h     |  2 +
 5 files changed, 138 insertions(+), 15 deletions(-)

-- 
2.55.0

