Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C79633556D
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 08:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789028242; cv=none; b=drHfj+s9QAwzvMAxH2/TJgoQGa7nZsVT159E4ZnBo3W+EuCSIMOaa+RqyuUKK6bhYG1R6eIqwmNhXYTzG338CX6LtvJl/ZuLroE8fAOx12kHCe2BPCa2/iIx8jp0EO+bQYgd0scdJl3i3gWEHAS6am8+lowSgwoSXj5YQ2qj9NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789028242; c=relaxed/simple;
	bh=w6XJjtdMq8EKHc9pVdEX8u3tdtWz759iuTuOB4Jpuaw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y40JFJar4Df+kbgbGge6+RnDCLBpBWae0U1LL93c9V2GAoXM88ALsn7IpzGTNdk2NoVbYys4R4/ZvMwPLs/tqB2dO65lAtRp4t+B6TEUZXBALOsMGtVkWHX4chU4NcDYdsB1an8NC4NNdpcWAauPFylEA/5AyvahuL/PW0EHXJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BWgxJ0kb; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BWgxJ0kb"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-90cc107c451so43707376d6.0
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 01:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789028239; x=1789633039; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=UuIcbp9Glx2f/SBMrmwHmlzrrBdIDZEXanHorc79Bhs=;
        b=BWgxJ0kbY3wpbm0ZaKZqlgPLWJpp+mTrZ51tWgvp4akdqi4J4BuiYAmOJyMw81+OSN
         IxeU7rbOe6XQzX+TVd9J+T0S9fKc9tm+cBMqtsQVmeru2uuvVgFBC3W7xpGogiPMDkdL
         4KCNTygo7zBgyjfxO1gc1mWyigpirA66WSNv0nWbe4yuyKIFjhhoKGxz/jqQTnaptXob
         KZfBs/xSLjaunhHHnjEvG8E/lhmcKhDHCg93t+Sz/uR65Bh/Nps7ZEdV6mg0GoD5Di4t
         o/mvp98jtQbmKGK2UNmS3Ds3AKTpd4xFUkYXw/d5BC92xdF/d3QLh8+T5aRIeyijz2Dp
         R9pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789028239; x=1789633039;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UuIcbp9Glx2f/SBMrmwHmlzrrBdIDZEXanHorc79Bhs=;
        b=o0UdncMvqrM5S4nNFjwPwWAC6U4MvhbJOMMnIyq4WJAWzfXUL2JDoX09VWXm8skgnt
         +9JdIjDRBaWWuckRHkL50dY9kQwzmj7V9qUtSyUff0Km27P0rczdZw0ZwAdQ1G7JNCXe
         IUuTFxMqUv6VGlIyKXCT08sB9xUQ12KpCtNT05mbiXCMIIikE6IaeHYX+jMccm//Ehk2
         Wvz2TPV+Je+dT2FA2z2fFtsNdgzFxYau9t/lZXQ8ErZX1INvsoNCXVdBGYkJ4Iom/1yn
         ugXtuyUWnzM+Em5Co8hL6XgDElXifOX6NYWD5wqgPEa9pIb4GXwCkXv6wYJSUWMGls1y
         OLWQ==
X-Forwarded-Encrypted: i=1; AKwUvBwZw5pLQBR3HuuMjTLrmZktB6ziMpsKMiC/RHiBssf5G/9+rXFqTgalmIprdFlpsXEB3HeTUZ3jrAwKfrUh+Q==@vger.kernel.org
X-Gm-Message-State: AFuF++l8feSGBE3TbHuEwwMz1GUgTaNRmeuGjQvE8StSuymlEfhxnGlt
	Z4TkRZbtyrOm6VGXvqZWxyaE5Zt47U0wd6LaEnSgtPOdha2sDs1FJ0xEGkZAXI4d
X-Gm-Gg: AYBFou21GKJvtAUCXWs8g7rkXoGkv8CN3LmCPmtLpmvZnNADXdYJfDoIepQFWJJMSUd
	bE76enbj7syv26lMy8By+8gnsCMUqeNnBaPEZ36ZPRE7ye5dtllu9f6+OCAhtDuc77WEbzb7uWj
	/i8GTrTbbhhvY/7dApKuHMAAUV0P1NuouTrQV1iMPe06Fq+wpG0UeBbb0t8rFmZPphKVdcI2Vdg
	0PYtMuTX023X0pszChgNKBe66JJwhHtA1XVpdfukGXM3eknonrXW1eSN3/m5XbXKSY8xWb7TW0h
	6KDeKyEWAFq+hV9kh9Ufw81TNi1kzzPPd5nxsJ3SyNP8IH0L7VRGjoMumgCQPitRFJquLF5j4Sa
	JeMvTdClFwRyHailGHzeRk/v99umIc50rjdNXwbM99+CRebfg5dRuGF+LRpe3arDu+9fr77+jRa
	ZE4ICEJFQScax6D5UrCTDcTuVHAsb+14BpQmJhPkkln7N0/DVP5JdJLDlms/BFl7qSNnNJCd/PB
	WP1MPKcmaNzrWQ=
X-Received: by 2002:a05:620a:3942:b0:939:b8d6:9b1c with SMTP id af79cd13be357-939b8d69ba7mr2142775385a.19.1789028239422;
        Thu, 10 Sep 2026 01:17:19 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939a57535a1sm1087723885a.0.2026.09.10.01.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 01:17:19 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: [PATCH rtw-next v3 0/3] wifi: rtw88: usb: keep bmc traffic from exhausting the TX page pool
Date: Thu, 10 Sep 2026 10:17:13 +0200
Message-ID: <20260910081716.769081-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mehmet Fide <mehmet.fide@screeningeagle.com>

An rtw88 USB AP with one station in power save and ordinary multicast
chatter (mDNS, SSDP) starves its own TX page pool: every broadcast and
multicast frame goes to the after-DTIM high queue, which drains a few
frames per DTIM inside a 2 TU ATIM window, and the driver hands over as
many as the network produces. On an RTL8822BU the free page count at
0x240 goes from 1803 to 16 in ~100 s and stays there for as long as the
traffic lasts; nothing else gets out, nobody can join, the reserved page
download fails ("error beacon valid"). Only a reboot recovers.

The series closes this from three sides:

  1/3 bounds what the driver feeds the high queue (a small budget below
      the measured drain rate, the excess leaves on the AC queue),
  2/3 admits only the frames a dozing station actually needs to the
      after-DTIM path (ARP, EAPOL, DHCP, the vendor driver's default
      "allow special" filter), everything else goes out at line rate,
  3/3 widens the ATIM window to 0xa while an AP interface is up, as the
      vendor driver does, so the high queue drains faster to begin with.

With 1/3 + 2/3 the pool stays at 1803 through a 180 s storm on the
RTL8822BU, a DHCP flood still takes the after-DTIM path and is held by
the budget, join/ping cycling without power save is unchanged (10/10).
The beacon-early C2H that Ping-Ke found usable in AP mode is the
long-term route to IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING; that is a
separate series, this one does not depend on it.

v3 is the review of v2 only, no functional change, so the v2 bench
results above still apply.

v1: https://lore.kernel.org/linux-wireless/20260902104146.3853102-1-mehmet.fide@gmail.com/
v2: https://lore.kernel.org/linux-wireless/20260907190901.1056945-1-mehmet.fide@gmail.com/

v3:
- rebased on rtw-next
- 1/3: the refill macro comment now says what one interval buys, the
  bookkeeping comment is a single line and the block got the blank
  lines (Ping-Ke); Acked-by added
- 2/3: the IP/UDP test written in positive form (Ping-Ke)
- 3/3: unchanged, Acked-by added

v2:
- 1/3: macro for the refill interval, 'budget' naming, refill
  bookkeeping rewritten and commented, blank lines (Ping-Ke)
- 2/3: classification from skb->protocol / ip_hdr() / udp_hdr() and the
  control port flag as in rtw89, SNAP parser gone, include order (Ping-Ke)
- 3/3: new, REG_ATIMWND 0xa in AP mode, default restored on stop (Ping-Ke)

Mehmet Fide (3):
  wifi: rtw88: usb: bound what the driver feeds the after-DTIM queue
  wifi: rtw88: usb: only let the frames a dozing station needs use the
    after-DTIM queue
  wifi: rtw88: widen the ATIM window while an AP interface is up

 drivers/net/wireless/realtek/rtw88/mac80211.c |  2 +
 drivers/net/wireless/realtek/rtw88/reg.h      |  2 +
 drivers/net/wireless/realtek/rtw88/usb.c      | 66 +++++++++++++++++--
 drivers/net/wireless/realtek/rtw88/usb.h      |  5 ++
 4 files changed, 71 insertions(+), 4 deletions(-)


base-commit: f71dd599a98182d6bc34dce39977f928068ecd64
-- 
2.55.0

