Received: from mail-wr2-f34.google.com (mail-wr2-f34.google.com [74.125.225.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909743B42C5
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 07:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790754290; cv=none; b=An8yNgEkABS8M5pE1u/MQlyq9/QeewhqRTpX7s3kS2kbqZX4asTLc9ATHMqQTnDx4DTkOuQGXL0CdgWPQofJSiHMsDrugHwQsv4mdD0yxL4FhXhNWrFWa6yvmBOX9untyXGY+ILOndcLOSJ2EbnrkPkzEfzedrc2wwVqvYhLKrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790754290; c=relaxed/simple;
	bh=LDVQ7lyg+1YS+lGp9uMmKlAPQeI0BGbetpenCTNZP4M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R7ZIUfx4oiKL+8wzEkNU1zQHr2KVQwkKWHiscGV6dq6yq6eih5coDmmEfNHZ29Wj4PCdZdXQf2MnqwT/2LltJeKiE/bJR97MRmq3ArGELUT4diySwboB4LKUf+W9PwX4rpS1i2CwEW4p+9RHGQs47++PO4+LjZaTxYfikUXcMF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PUMvNXgG; arc=none smtp.client-ip=74.125.225.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PUMvNXgG"
Received: by mail-wr2-f34.google.com with SMTP id ffacd0b85a97d-48b01c41135so167263f8f.0
        for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 00:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790754287; x=1791359087; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=aP3HpmdVFomE22DhxX8rVgzIVeQZvs2xgSWS4MOQb8k=;
        b=PUMvNXgGOfQeulr935xCGc/pRvA4axgkmAm8l54Fa3YBFtIu30RcpM6x3fhfmqbSAN
         Zk4sArm+HUYaCyh3SoDEtpmpPvPBK+vu7wyYzhuAS6Uz4U+F5J8lAgDNEoBQat0uVBhH
         jVDc0ESqJqI7/e8am/atl53qbK5WUTH2YjNeocXnORER13SlChEZXL0w7jzTObX8NDNe
         +UJPXAD5aLWJ5CwKj2HKimAekq6bx4QcQAreYc0m1gH622XHH2wAGRS/xitjoZ+ZdB3L
         y9hoDv0Yf2FORtQcQibgJMy1cwfyNPWmD2rg4UUf95GkPDhpfusRKzvXe82TMvNIthB4
         ompw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790754287; x=1791359087;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aP3HpmdVFomE22DhxX8rVgzIVeQZvs2xgSWS4MOQb8k=;
        b=eTH0w42Dk/Y+9BVGFhXHchkQ022bC4m7TVL5Fti5HbRt0MBnxVB8pA2dvj4ujuHIqa
         hx20Yl3UbzaiJYb7ubU/+KPsLFby1c3K0gT7mHYvIoVpnUxtcakfQWRjjuCAC8uDLe6b
         Qu3htGtXxGcNJlc38uOaielw1A+cCyVCb15wRTN+6zOjf1N80Qj/80d34W5+uvRGa1Ju
         0cptuO7mqMAMdsz+r0bs4C5vHfKs4H5aaUBn51yto4fLhOWlMUCcfl+LGSEuKHbcMi6P
         KS4K14fvazDLWAecSyZcTzTL2t/NQNIiz+a/wZcpxgOrbnwXIyQSFZb60jAl/udzU1LU
         h5SQ==
X-Forwarded-Encrypted: i=1; AKwUvBz0xXk8sAuiZuiPvuTded6/5ZiswgHYMwPqjdwM3H+qJ3Xp9pD+WZaXNOLMhDktY/rfDZEMq+8E0vhVPTqiag==@vger.kernel.org
X-Gm-Message-State: AFuF++l7oYuVeyeHqdfwOpSultXB4EZA1gMXib6qeZ2tI/QQH3tMxJJF
	VKkvOVvn1of8OKaOoNADZRFP/DHCur2uNLxyw/NMUDp6MoA4ztoD+q+L
X-Gm-Gg: AYBFou0PeIQfBWubsBdMQw/0OPELqF3ZHQyoeXVdDhPWgxlYjxxKA6sZYU0YDzEAPCi
	FxQOPqXYXiKvgJIwnqY0+dHEQIP+MmteLFDyD7+rIT7aJ6Fgwx/BqXNcoe+IrNyYQGnsHC+bzZA
	tlezSZUXNwFOK/eyetG/6azJzWZDnTvSrJdScPhOechyyOKWxIfCaTES95TQlcKkj8IiALwvijz
	gxOyCU0Oyqb96SPpPONpfmB9tXauIGjaMC+3qvE0sZtc5DT3JhdG2rEcKeIghiHsiURs5k0nKOH
	bnf45auu0Rsw+AUAyt/3CDXWHR218ELFPUicl7Sgct89IoLM6oTcKTaimjVtLdbBStwbHaAnT8f
	ZE1uD6II+IYfA4Xb/TXEZY8TGew8qhOY7c6/QHyu0vShhwGA/GZzzTmGFZJ5aU0BcCVlJfFesbZ
	wjLnlCbeLfmTDlRYv8ohNOFgquwEHdpqMYMpcZuKOZ8P5QKEwAcBjhbOzjFlAzf1aHJ70goRqMZ
	6z0
X-Received: by 2002:a05:600c:1f84:b0:49c:eb04:1c49 with SMTP id 5b1f17b1804b1-4a01b00c503mr6110215e9.13.1790754286577;
        Wed, 30 Sep 2026 00:44:46 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a017bad33fsm23934595e9.4.2026.09.30.00.44.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 00:44:45 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: [PATCH rtw-next v2 0/2] wifi: rtw88: channel switch in AP mode
Date: Wed, 30 Sep 2026 09:44:42 +0200
Message-ID: <20260930074444.1991223-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mehmet Fide <mehmet.fide@screeningeagle.com>

hostapd's CHAN_SWITCH fails on an rtw88 AP because the driver does not
announce channel switch support, so the only way to move the AP to
another channel is to stop and start it, and every client drops.

This adds the support the way rtw89 has it (edba3f107844 "wifi: rtw89:
implement channel switch support"). The first patch is needed for it:
rtw_fw_download_rsvd_page() fetched the beacon from mac80211 twice per
update, which advanced the CSA countdown twice per beacon interval.

Tested on 6.12.111 with RTL8821CU and RTL8822BU as an AP (hostapd 2.11,
one and two stations): CHAN_SWITCH with counts 1 to 5, the stations
follow without loss; aborted countdowns and STA mode scans are clean.
The hw scan path is compile-tested only, these firmwares have no scan
offload.

v2:
- rtw_download_beacon() takes the beacon from the page build and fetches
  its own for the hw scan; v1 left the scan with -ENOENT (Luka Gejak).
- a hw scan is refused while a switch is announced (Ping-Ke).
- one wiphy delayed work per device instead of a delayed work per vif:
  serialized with mac80211, not re-initialized by a hw restart, checks
  RTW_FLAG_RUNNING, cancelled on stop_ap, vif removal and WoWLAN
  suspend, covers IBSS; it starts one beacon interval after the
  countdown beacon so the count on air is not skipped.
- commit message of 2/2 without the rtw89 reference (Ping-Ke).


Mehmet Fide (2):
  wifi: rtw88: download the beacon the reserved page was built with
  wifi: rtw88: support channel switch in AP mode

 drivers/net/wireless/realtek/rtw88/fw.c       | 75 +++++++++++++++----
 drivers/net/wireless/realtek/rtw88/fw.h       |  1 +
 drivers/net/wireless/realtek/rtw88/mac80211.c | 46 ++++++++++++
 drivers/net/wireless/realtek/rtw88/main.c     |  4 +-
 drivers/net/wireless/realtek/rtw88/main.h     |  1 +
 5 files changed, 113 insertions(+), 14 deletions(-)

-- 
2.55.0

