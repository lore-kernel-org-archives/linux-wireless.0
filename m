Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3C55304D1
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 13:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790169800; cv=none; b=VApm1EJowSv9++nIyupvQUckFa4ri9EyqnqhWlbzEZYsOWuFF5JD20MM2o2oXPBHi6ZYU6Q8AXnIPaq8y46iBj/VCJyj9hZEk0uZlOLxWvoMgZBTD3SjRtiCGrv0D8qGeNTmb+B1sqeGypNM391Lmu7pxlbMvrlAqoutVsqyhD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790169800; c=relaxed/simple;
	bh=CBMoOcQSJV0envXaeE2VfMihOHslrN6apNgntTtzWDI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QYK4AgvdFFGTg5AwtgYxf9wRPIj6A4HAVFO/FW+Hj5orVIu68TF5/ElJmoLwzDRyXmYiDAArpNcyZpEbhK5E4NQqarLPhAz0EteQ6Qp6hIutekD/+enjqnLx70ih+9yZgPKaWNwR2Bofw0RFZe4YUsWsiFchzy1+d0Lo+J++apg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qly6zEal; arc=none smtp.client-ip=209.85.217.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qly6zEal"
Received: by mail-vs1-f47.google.com with SMTP id ada2fe7eead31-78a338fe106so1839009137.0
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 06:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790169797; x=1790774597; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Soq+uaSVZc0Vr6aYGk5pA/lJkY6ZZ4f3sD6Luc3ZKWU=;
        b=Qly6zEal7zDUel/nZTRy+obsHNnuU6n9CGdfpvMp4dKCjIQhuypPjsMY2yP71WCq5B
         VS/hEO1wtT52ad5Vqdut49Ur1Skwzzi4yjkdhlxU0NhcsH0LXIQMTjvv4zXZcUD4Nlpx
         LX5Il51px6sTc1mrsvOYKiReU571qv6d9stYNWR+T2k34j8bHVxYm+qrWe3XIY87yEW5
         sGFtmZJ8Vc9OKNrZtB5kE0pR6au1k+rbh2a65Xg58R2TDMJ8W+IyKHIMIim6XsR458c+
         mPbAd4gVlfOohowu+uQ8ozBzLZBkSqzdraVVDgzRWFpvmJb7i/UyKpUEE2olI128UMC0
         iHkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790169797; x=1790774597;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Soq+uaSVZc0Vr6aYGk5pA/lJkY6ZZ4f3sD6Luc3ZKWU=;
        b=piTPtXy8Y1RPAh69kgq08NTt8OxlsKgKrqnEJL8d9dicnq4aBrtMu49RXODyphzK3a
         g1Jxot7am91SYL0hGQWV5dPPcl5+1c9K752Ka2PMcsTy59+UTAVkx3IUVUz7PHqkXm8y
         85DPY3EEXkvM/95KP0TUjd+NFPLUpTTRrhD/xgNKphKaa1mMECucsBSU6s2BHFHHjsoE
         DjIOF3udACdfueeFVMaMfvnU/GXfvdwoXqZZdVoFKPl/eDDEoyz+wxncTYeix9ciLBsQ
         5SQrK+ZxX6mm25b4Kf1jpKRcqDw8qT+3G9n7v8NdJ0XiA0VrzUzki5//UPSVqD2EGXgh
         BKHw==
X-Gm-Message-State: AFuF++kb1IXYEnpqTSorNcpR3YIAb1QHWNPGtlV0i1TqaoFTEfZ3Lplu
	NIFLJaY92h0aNoiIDPsubNo9/1QpVh6v6Mb+hB+yPUDDDWp6GHULgwN4oY/SOAUG
X-Gm-Gg: AYBFou2ok02bsjUaMrqbnVNnmK/4Fbg8nM1AaTFCf1mtb2DCRk8XLGWA4mzZnYkNxMp
	OEVZydHFBUCDWaEAux7nsFmWvRbAF7NQ2LVQOIj/k0rjXpnl9Y5C6mPc/emGe7TgVD5xrPjUdXg
	ry/HvMSt2An3K+JGf7z3FIsNOfJWoo37sWsUe4fIv0pOAYg1hyziM4hA3Szye7kTjcwfXbcqwAu
	4ocNHPTG+9yhA8rDPz0PBeA7NiWLv9u4j2w5rT6FHtjZyqYZdN68+MIvYbphPoaSKm9MfhPLWVY
	NZ3Xfpd99dUM3dOHi6cSD8/DEUB3t/R/Ms7pLP1CXGShGOULCkv+BYnQ+AzuR2cewEWfs6zJS8h
	BZAsgbmLFE40pK7Z4mcbI2BIGhIKPAqMlFPP6UOyzz9mYPujlgkXOFeDCifob8Heq0N/jEJxIfU
	dB9jXJWzjs++ewz0ZhqhlTcMmJNezPp3Ne3DyaJSmXO2Vuw3NlmsDnvMmsFUIXYABe3ORu4Vk/E
	nvqzRgOBgW/TJcimDNenZCx4LWjPXW1AY9E9yBiBTZThms=
X-Received: by 2002:a05:6102:8192:10b0:785:6b42:b7b0 with SMTP id ada2fe7eead31-7aa9df8e032mr4971928137.4.1790169796917;
        Wed, 23 Sep 2026 06:23:16 -0700 (PDT)
Received: from localhost.localdomain ([190.177.169.131])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-98517a8ecaesm2910924241.12.2026.09.23.06.23.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 06:23:15 -0700 (PDT)
From: Cristian Papa <pcristian292@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: nbd@nbd.name,
	lorenzo@kernel.org,
	ryder.lee@mediatek.com,
	shayne.chen@mediatek.com,
	sean.wang@mediatek.com,
	linux-mediatek@lists.infradead.org
Subject: [RFC PATCH 0/2] wifi: mt76: mt7603: bound the frames a station keeps in the hardware
Date: Wed, 23 Sep 2026 10:22:54 -0300
Message-ID: <20260923132257.8729-1-pcristian292@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt7603 completes a frame to mac80211 as soon as DMA has copied it, so
AQL never sees the frames the hardware still holds for a station. On a
TP-Link Archer XR500v (EN751221 + MT7603E) with one client, counters
added to upstream mt76 showed the hardware holding about 200 frames for
a single downloading client, nearly the whole 256-entry tx ring, and up
to 740 under bidirectional load.

With a client that toggles PM often (here a Samsung Galaxy A56 with
Bluetooth on, which enters power save several times per second under
load), every PS entry loops all of those frames back to the host, and
the PS queue keeps only 64 of them. The frames freed per second roughly
matched the client's TCP retransmissions per second.

The series holds a station's tx queues while the hardware owes it too
many TX statuses (a new MT_WCID_FLAG_TX_HOLD, honoured by the mt76 tx
scheduler like the non-AQL limit), and sizes the PS queue so that what
the hardware loops back fits. It depends on "wifi: mt76: mt7603: don't
drop short frames looped back on PS entry" [1], without which the count
leaks one frame for every BlockAck request that is looped back.

This is an RFC because I am not sure a driver-side hold is the approach
you want. Questions:

- Would you rather keep the airtime of each frame accounted until its TX
  status, so that AQL sees what the hardware holds, instead of a count
  in the driver?
- The marks (hold at 96, release at 48) and the PS queue size (tx ring
  minus 64) were tuned with one client only.
- If a held station sees neither a TX status nor a loop-back return for
  a second, its count is reset. In the tests below this happened 0 to 3
  times in 30 minutes, probably when the client slept for more than a
  second with frames still in the hardware. Is there a better signal?
- The raw re-send of the PS queue on wake-up bypasses the hold, so the
  count can briefly exceed the high mark (up to 134 here).

Either change alone makes things worse, which is why the cap and the PS
queue size are one patch. In a 30 minute bidirectional test (iperf3
-P 4, one client, a ping from a wired host every 200 ms) that cycled
through the four combinations every minute, about 7 minutes each:

                          upstream  bigger PSQ     cap  cap + PSQ
  frames in hw (max)           748         844      98        134
  PSQ frees per second          92         213      51          0
  downlink Mbit/s             12.2        15.2    10.6       17.0
  seconds without downlink      45         108     111         10
  longest stall (s)             10          53      16          1
  retransmits per second      15.4         8.9    10.2        3.0
  uplink Mbit/s               64.0        60.7    63.8       59.3
  ping median/p99 (ms)     119/339    145/2915 125/482    130/292
  pings lost                  6.0%       13.7%    7.5%      0.13%

The stalls come in bursts of PM toggling, with up to 22-28 PS entries
per second. In the worst stretch, the minute with the cap and the
bigger queue had 2 seconds without downlink progress, against 20, 41 and
39 in the neighbouring minutes of the other combinations.

Two shorter runs toggled the cap alone (PS queue of 64) every 30
seconds, over 60 seconds of download and 300 of bidirectional traffic,
with a 2.4 GHz wireless headset dongle nearby. In the download phases,
with the cap: PSQ frees went from 59.5 to 7.3 and from 54.5 to 5.3 per
second, retransmits from 54.9 to 8.2 and from 58.8 to 9.1 per second,
the ping median from 38 to 23 and from 32 to 25 ms, and throughput from
56 to 61 and from 59 to 63 Mbit/s. Bidirectional retransmits went from
13.5 to 6.0 and from 13.8 to 8.3 per second.

Testing: OpenWrt with kernel 6.18.41 and the mac80211 backport of
6.18.39, openwrt/mt76 at be5ce79105 plus [1], this series, the board's
local patches (EEPROM file from DT, two crash fixes, beacon stall
recovery, fixes for the mt76x2e radio) and debugfs counters that are
not part of the series. AP on channel 1, HT20. One device and one client
only: no MT7628/MT7688, and nothing with several busy stations. The
series is against wireless-next; on openwrt/mt76, where it was built
and tested, patch 1 only differs in context (mt76_wcid_primary() in the
non-AQL check).

[1] https://lore.kernel.org/linux-wireless/20260922220814.15070-1-pcristian292@gmail.com/

Tools: an AI coding assistant (Claude Opus 5.5 in Claude Code) wrote the
instrumentation, analyzed the data, and drafted these patches and this
letter; the tests ran on my device.

Cristian Papa (2):
  wifi: mt76: let a driver hold a station's tx queues
  wifi: mt76: mt7603: bound the frames a station keeps in the hardware

 drivers/net/wireless/mediatek/mt76/mt76.h     |  1 +
 .../wireless/mediatek/mt76/mt7603/debugfs.c   | 32 ++++++++++
 .../net/wireless/mediatek/mt76/mt7603/dma.c   |  7 ++-
 .../net/wireless/mediatek/mt76/mt7603/init.c  |  2 +
 .../net/wireless/mediatek/mt76/mt7603/mac.c   | 58 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7603/main.c  | 20 +++++--
 .../wireless/mediatek/mt76/mt7603/mt7603.h    | 51 ++++++++++++++++
 drivers/net/wireless/mediatek/mt76/tx.c       |  7 +++
 8 files changed, 172 insertions(+), 6 deletions(-)


base-commit: 10cfa109c880092df32e396647b4afdca9be8350
prerequisite-patch-id: b2c7fb85fb032bec084c6e325be32ea1172af916
-- 
2.47.3

