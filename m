Received: from mail-wr2-f35.google.com (mail-wr2-f35.google.com [74.125.225.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991FA524AE6
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 12:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790685846; cv=none; b=FgstqG3L4w3XoADOpCZwTuFvHbChIoXsstbHqKVwFiOiIDuWO3gm6b1BFlR8aw2KKAqnXYqCW8ikEYyVjyZcitXZkjTCjJzjxmot98EZ4A+3jg5wnzB4K3KS0Xya5I3VFfP8r3tnJqKX0xnJxk4/koSGanStfDnDqjIE1rIqL/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790685846; c=relaxed/simple;
	bh=U7m0o9CyvN16ZdCK9UMVN5kQKeSCp5XXgewGbIatDOM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z9ohZlXO2ruUvcZFUgtf9Of2J80isw2Zsv01thh3sSCutwyyOZhPI5UAyG5kfuilMz8/4AaiQTds/St2htMd5mwe4YIaT+lBVQaDwN4eW3bAlbWyJqDEVA5NMkIrWviW48bHJxW6uJRfgBn/qBmgzbWaZeWxjqPF5FG4Hdf0/5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pYvVBSMr; arc=none smtp.client-ip=74.125.225.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pYvVBSMr"
Received: by mail-wr2-f35.google.com with SMTP id ffacd0b85a97d-4887f690df6so2957733f8f.1
        for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 05:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790685843; x=1791290643; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Lsz7W/gFcNJmLY241fJ0lph8+ZwTQ5HGSLaR0rXfueQ=;
        b=pYvVBSMrf0PP6hfEdurKGSlamDkyrlim9HpSMjU+nnAY22gwHfgus/s0al75qwoH0b
         z66GV9rbRq7pjzQLhk06MjupalQPDHcHUv209MYnoN7Vp4MJMKsS5leTez0z6fTcgfLY
         rNmWua0seA8EielJSsqlby1VvUeofYpkIhZXxugw/7J0akN1015Z0yTYKDM5zbLBAsfu
         61Sw+Y3Ak26f6W53ggbOD9mwbDDiijC5QY1Mjcv/nxsOW8ogLirxQBH71eW6dGfGerSt
         TUttvIrmMBBdksogAxCWo/OFqroUOgcFvQsieZQmeznKL/aIdipw1uQlDEE2ImcdvU7E
         49Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790685843; x=1791290643;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Lsz7W/gFcNJmLY241fJ0lph8+ZwTQ5HGSLaR0rXfueQ=;
        b=UTio6AVp4zwo8pZ1L/owBEMsiu15cg1Rfqczg0C46iKgF5MBhqcBnib6RL9K3Fmmv0
         vzLYR56ZGM0YQJOlYskIb8vYualKzuLOjFZDms0m7TyOTUVGPMDzvgYzPCp9ml0zI17g
         LaP9IAw1NtsPsRQZyQYM2+rs2Hu97PJunBUxIqZbrFyJl6e8yIAWGxy+p58uuriRkSqp
         2DychwncMYTAwmzco4kqOsn1eKO2HTf/nVPBh4QNr7K01ECUV6WLUeqYxZ4Sxw60U+Hr
         m9dQ6+TkNh4p4dEFtkTPxwuyE32EHIcVwfs+rKOsCuKleghLAh5dViZNKG3/mGk7UBAn
         WPAg==
X-Forwarded-Encrypted: i=1; AKwUvBxCrItVV3eiIOV8uX7a498Hdiz1Vg4tL+aB2XXLriegktP2xNRus94SGnUlcNFfl6zKXhXIhVdslC7Y0TekIg==@vger.kernel.org
X-Gm-Message-State: AFuF++kEWIjrJyg7QbqpG9jS+xx31FE2fQDL0TVhw46icT28r+P9rAeZ
	YBh1B/hYB3JrnizaR3R/fry+Orfs4+2Smk6JL6tbX1ALiENjsIQ9NSgt
X-Gm-Gg: AYBFou3xaUM4+4HVo96b4VycFN96i1f+VRrMvDfgOpjQl89su6tl1CF91vlzW8ygjym
	8o+ycPu1sTQyABEDz6HmBd1/S78c/hgOBzMZ1JcSv96u40z4ij38m3w8XKi5vTHORe06xapk3kY
	Zk0yLajS8Kg6s0ASMB86JA4ZBj9tEUZJBgBGuA4XvAI0H5FuOykXpn8PEYvhBvHuoNCqM18De9q
	GRtcPlSUu0R/cF5c25MvtsLDPTiYQGPfRqejNYMGVi9136eoyIYGEIsI5wIV6VwQ8oPlrWN0Fav
	HfzOfy/XMikFctkmKhPWbVzEfBziBRzkdn5dxuCl217ZdEff8WND6IWyDUHMk/YXSiuERQLDkbH
	jmZOVdSAIVpSEraojlG/q8m1jBCaHbW2SD2msf/1v05/+BpVpC094Mqhttkjb/+SKPxraUlBEj6
	pCnjAYdGEipktqRD8fPWWjCoGLA79+SXWsiLmdcvZ+SgtZyic2cuW8v8WUXORrF1VC3qYLHTBPl
	UPJ
X-Received: by 2002:a05:600c:4505:b0:49b:9105:cdaf with SMTP id 5b1f17b1804b1-49fe66d069dmr256257375e9.8.1790685842393;
        Tue, 29 Sep 2026 05:44:02 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a012387337sm33002265e9.8.2026.09.29.05.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 05:44:01 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: [PATCH rtw-next 0/2] wifi: rtw88: channel switch in AP mode
Date: Tue, 29 Sep 2026 14:43:58 +0200
Message-ID: <20260929124400.3856049-1-mehmet.fide@gmail.com>
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
implement channel switch support"): WIPHY_FLAG_HAS_CHANNEL_SWITCH and a
channel_switch_beacon op that keeps the beacon in the firmware's
reserved page current while the countdown runs, then calls
ieee80211_csa_finish().

The first patch is needed for that: rtw_fw_download_rsvd_page() fetched
the beacon from mac80211 twice per update, once for the page and once
for the standalone beacon download, which advanced the CSA countdown
twice per beacon interval. It now downloads the beacon the page was
built with.

Tested on 6.12.111 with identical hunks, hostapd 2.11 on nl80211:
- RTL8821CU (Edimax AC600, fw 24.11.0) and RTL8822BU (Edimax EW-7822ULC,
  fw 27.2.0) as an AP on arm64 hosts, with one and with two associated
  clients (an AR9271 and an RTL8822BU station).
- CHAN_SWITCH with count 1: the radio moves within 0.6 s, the client
  re-associates as expected without a CSA element.
- count 2, 3 and 5: CSA announced, AP-CSA-FINISHED, radio on the new
  channel within 0.8 s, the clients stay associated with no packet
  loss (worst round trip 168 ms); an iperf3 stream on one of them ran
  on through the switch.
- a countdown aborted by stopping hostapd or unloading the modules:
  clean; STA mode scan: fine; no warning in dmesg in any run.
- every rtw88 chip option built with W=1 and sparse.

Mehmet Fide (2):
  wifi: rtw88: download the beacon the reserved page was built with
  wifi: rtw88: support channel switch in AP mode

 drivers/net/wireless/realtek/rtw88/fw.c       | 54 +++++++++++++++----
 drivers/net/wireless/realtek/rtw88/fw.h       |  1 +
 drivers/net/wireless/realtek/rtw88/mac80211.c | 14 +++++
 drivers/net/wireless/realtek/rtw88/main.c     |  3 +-
 drivers/net/wireless/realtek/rtw88/main.h     |  2 +
 5 files changed, 64 insertions(+), 10 deletions(-)

-- 
2.55.0

