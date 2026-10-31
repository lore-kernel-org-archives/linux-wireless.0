Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793465508;
	b=hQTvsxo3Jnh3pL/G4CZNOU2Qyvgpt/RtyqXlFfTdVojQVE9AQCnk8hUDL7McVZBsT07O
	 Ly1jcCyXN+fTn4Be3EtdIZ+Ao3cWX4S0cj1dwXG6FflI8Y8HIgfjrRSnMiqnuO2mW7hj9
	 xUGEWJZAmPeQ8Ce9R8rCotNIO3PLrAyFvFLQUyt23UHb2Km9PeW8qtr6XJ0aVDG2ttQIY
	 6joOsoZ5l5hhNsoTlk9KWiwOjLDJ9vD8GJoBrUBxk88LPVpWe6nsf006GTyAvuFbM2oUo
	 wGeX27NGHvfUg3aBb/H1P/1cSfOqozwnHUVmzff49UuUTyTU9nKvzL4wmoMt9D+pE2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793465508;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=wamDxm+VP+lDZGpMWBybMLeu3hwcWm7V1hzcMRK5N7o=;
	b=kxTssE7jyjv3j5Za0VUh2HZ/JKRhaSk77uM0lDdfb+rntyqL9ZeJKfMqHqtKMeQUJRPC
	 OamIRKh62TiGqDqiiaSynhXZ0Y4XmhX8RHNvOot9hFVAIwheU+Hm0aC9fWw0GckQYsFt/
	 ZL6O9K5U8dKI68gRNWTCyLDkw94bYvdzPdJc3NprZK/tzalmRLDSq9gAHQRuLLeSVt8AY
	 9rLrervHDFth/CqtoWyWWEUVhNvstmik1WuZKVhbqbdLTPUtc4Llpf75GVPEbb+0H2Q3H
	 WfPs13URGQeEREXn+3aAOVB4szO7LnNpwP43pvMi2WwZJHR39IlyocflXPA9EeeZFmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Bwn2Lao3;
	arc=none smtp.remote-ip=74.125.82.170
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B54606A31A
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 16:51:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41B54606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Bwn2Lao3
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-33bf40b0c8bso2098622eec.0
        for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 09:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793465507; x=1794070307; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wamDxm+VP+lDZGpMWBybMLeu3hwcWm7V1hzcMRK5N7o=;
        b=Bwn2Lao3kjB5WCX9xnwFU20qzEX3xCL2d6zJts5j5VBSh4d0UgIiLKoL7P7234AEGy
         eeoISXrjlbx4dNrleC/aLpLQlCrEPZWTfG5yyNFRhiXITJg3lc8NagDeAyzyURM9VhrT
         WbRKjIO3Jn5DbT1wEGrinndptMtX5CEFNOeEGXzRYpPfckOn5FUs+xbMnUW9Vw6TZcKI
         BmwNifIni2HqEWsTa2sCRH83Z5wJzjT6kTjIlUVTgbVCBSBxK5jZ/53/bAcCCBAHhzxG
         nGsmV81DwxEX7nXvQl9bRk8FkhHAB8UUuTv7kb7S37s7bQFVGeGBPsZ138+qIquawB3Y
         ktrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793465507; x=1794070307;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wamDxm+VP+lDZGpMWBybMLeu3hwcWm7V1hzcMRK5N7o=;
        b=hQNSb43EvsXocO5ie+hA/mRPz2otG+m2J/OF05w+bWnrjkQHnVxlj1x+2SDT3rFOkJ
         SaEB1UFkcFVlAhg6nNw3crW3H/tFKwXyo267uQaJyYTzdi07xl9FY2WU7HaQZdlx7WK3
         70QYy3A5xUMVyb+3BhdkPjQfVDmEzrkWHm+tYMxjaUOTUh1zS87jpskttOThEUHXg1SE
         pRg1ef5W4hrw8OVPDlFzfgAn8tjwEWIJ7FeEUKu64v7w7xgUVjo6BMdQwanJpati9/AH
         NiwF7y74Ucu5oy4LalxTOvp4B/iL5pQjMe4/nZySN1XSIE3j8InvTga1vGtqSENrbcC0
         HqdA==
X-Gm-Message-State: AFq9FYLe4OmXiCfIaMEU7g1uDEYtAOiqN1MrW6Bk2qA/ZOVt735mrOmh
	6C9cZzHb8czb5uPQg2Z5/Lze4YIEKdaAkcvIT1+x7y+8JDjeiYxGXkZrQZKFD1xo
X-Gm-Gg: AYBFou3aqCAS+yVjcWL2Pe+qkRBayy7RlZWtCj13TVl6qDfIElAb7Ah1SQWSoSN3b0N
	3enzfvRc9PFg9t3Lyxc/xqRtQeXlF67Jgyn4sArXkjIsEkg6h54m3OeYHl7+fMvMSVero0tlzf1
	ZbY6Cp+hvR1sFp69mXWW4X6sZGQVgzxMB+tJ3Cf9BBkHl6TJE1sqCY6mpa9oY+0VfJNRyjKxDe3
	NZpWZ7KIsjzPyE2uXPm52kkArYom+0qbaufbY8zs6xnAG2abLGFGggtgCZC6hvoWjLJC8MPNFYT
	f2CdxyyWgfZdXL/1wuHzFHn8/2gf3phTxWhRSOezOAyabkEseHl+NlwdGRAANMn76cBJZrkCWIm
	QVtuF0ZIyXkpVH3Zfu+zW9teSYsAiOoCAJ41zniCgtz83/Qnon33FvmOHf17i+rQ9pJ0Pxs1fPv
	i3HW9WwKkp3lUrMfuBUVe8epmRYiUS0DOmcuhUI0m/J0HknGC26YQzhJZdjiO9kg4g5oFUEWhKf
	9vxj01oOn0q/D15ozjFzQz3Ee8pW+fn+p5BC1k0OB47pgAYwBemnOz++1J+ICo7pVfqb1oXWjTM
	eKqMXMQGoAZA5aLNZ0/hjX68uN/41TZI1Yhnzd7M8TLO7iG8iecibDyNkIEuDhrPITvYEmD0zSN
	+ENbe2R6s
X-Received: by 2002:a05:701b:4182:20b0:1a5:52f6:db9a with SMTP id a92af1059eb24-1ac5ca23c29mr8395084c88.22.1793465506993;
        Sat, 31 Oct 2026 09:51:46 -0700 (PDT)
Received: from acemagic-m1.tail4fb79.ts.net ([2401:7400:c804:b668:bba7:148:3987:1383])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac1abcf67csm17421611c88.21.2026.10.31.09.51.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 09:51:46 -0700 (PDT)
From: Ho Jie Feng <hjf3108@gmail.com>
To: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Ho Jie Feng <hjf3108@gmail.com>
Subject: [PATCH wireless-next v2 0/7] wifi: rt2x00: improve the throughput of rt2800usb
Date: Sun,  1 Nov 2026 00:51:07 +0800
Message-ID: <20261031165117.2868671-1-hjf3108@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series improves the throughput of rt2800usb.

Implements
- Frequency offset calibration
- Better fallback rates
- Aggregation
- GRO

Tested on WNDA4100 RT3593, 5 GHz with iperf3

  patch                          before        after
                                 TX    RX      TX    RX
  2 crystal calibration          27.7  31.6    28.5  69.7
  3 MCS16 to MCS8 TX status      27.0  70.0    29.4  70.0
  6 RX bulk aggregation          30.5  67.8    30.5  80.9
  7 threaded NAPI with GRO       30.5  80.9    30.5  161.7

RT3070 did not have any visible change for both TX and RX.

Ho Jie Feng (7):
  wifi: rt2x00: start the link tuner when an interface is added
  wifi: rt2800: calibrate the crystal of RT3593 with the beacons
  wifi: rt2800: make MCS 16 fall back to MCS 8 on devices with 3 TX
    chains
  wifi: rt2800: don't report an A-MPDU length to minstrel_ht
  wifi: rt2800: support A-MSDU in A-MPDU
  wifi: rt2800usb: enable RX bulk aggregation
  wifi: rt2x00usb: use a threaded NAPI with GRO for RX

 drivers/net/wireless/ralink/rt2x00/rt2800.h   |   1 +
 .../net/wireless/ralink/rt2x00/rt2800lib.c    | 113 +++++++++++++++++-
 .../net/wireless/ralink/rt2x00/rt2800lib.h    |   4 +
 .../net/wireless/ralink/rt2x00/rt2800usb.c    |  33 ++++-
 .../net/wireless/ralink/rt2x00/rt2800usb.h    |   6 +
 drivers/net/wireless/ralink/rt2x00/rt2x00.h   |  21 +++-
 .../net/wireless/ralink/rt2x00/rt2x00dev.c    | 106 +++++++++++-----
 .../net/wireless/ralink/rt2x00/rt2x00lib.h    |   2 +
 .../net/wireless/ralink/rt2x00/rt2x00link.c   |   9 ++
 .../net/wireless/ralink/rt2x00/rt2x00mac.c    |  13 ++
 .../net/wireless/ralink/rt2x00/rt2x00mmio.c   |   2 +-
 .../net/wireless/ralink/rt2x00/rt2x00usb.c    |  52 ++++++--
 12 files changed, 318 insertions(+), 44 deletions(-)


base-commit: 2c50cd5d10e8723797f28c7978f1f61688e0c0d2
-- 
2.53.0

