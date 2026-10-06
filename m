Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017704A2A50
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 17:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791307092; cv=pass; b=uMb4jEKZ0vy7I6sVwMzb/h2YaPIlBHAwm7Wc5G17pChrrqWGZGHip59B/fiSPc5fIqRZYK/w79QLhsoFb7FCkmqJJIuMc8yXIG55ZXLaXxQEwYQfiwXXCj/3W/SsiALPGiAo3g7+t7aVkbqZ49Z88FJmFwayrX58zIJcfwEWs9s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791307092; c=relaxed/simple;
	bh=Z7RWaUukp2vJp/lKLw/pvzkwQI1/3q3Xs3o+sRxD9Bw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=r79jX9WUptPVOHtpSaQOrUHam5dAEXWE/zJEqa2x25zCt2LzbvVwZfO48mP9RUVoxOxqBidUjGPtxbmvFeYZ7iPMJtQbX44tq3DEKuxRTLYwNqToV3mMto0oJGxvyjmHRh9XY/9TXiAekwpUTOFMT0LAOJ/86m+5om1o7s+f3wU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NS8wAura; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NS8wAura"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-53396adbc53so32911561cf.3
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2026 10:18:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791307088; cv=none;
        d=google.com; s=arc-20260327;
        b=gzszTGRF7Cev3Ny6ScCq+YumXd8lt6THNG2y7xqHYTluKj5qSMYbEAo8VpvqhbqzWE
         lTfcxKa2LE6YMkGANIj0H2HHSTCLEwn/irlzDsFKMMYXnMSjnPMeeOyZBAiBx1I5z9uG
         sGR31VpNAVByd1nOxc2yuUEZ7y/6T9zbZnJqAhqQ2uzbTCIkLej+2begrlcZZy2G8QsI
         GluXAMnz8EPVhHUFJP0jck5jPLcuuX8kys914dyU7KplBQ5kC8fx1GJlp4M/RkDJ56bj
         TmzmIOm1nCqOzMeoqFd3/5GoQhevhDVPK4JNSb5GuTyh0QarqOsol8TlcKnzWaI+iEfi
         NKoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=IYoFhdR6a50T0V6unvIVYfJRbGq2pHrg3/lVy4LzpxI=;
        fh=biOthnk5BxDARXC2JC6lJC6G8EmFR3L0T2E/HzaCDX0=;
        b=sI/bLDvwxBYNGemGT87oeBLoLJNfYIu2Irywwi73/Abvr5m0YFlc4mYn5Va9cZh+ns
         eGJYlfzGgVSj3oDN3nijB+wiLsXfzQeM9SG02H4xe8H1ZBEyyZvrMhm9sm4tWdGatjkU
         aNCE7/1ZirzQU5ozIq22IQBF10iIyyJIAb1XzGiQfhp1o9Cckz6RtyKHS5XAJRvIXj0a
         PBt4DkW7EOWNry62Lsy6wn/ZYJo04XuvCykozhLCHKeOveDKThw7Jt4O4o5cnLuDuAvN
         du5M8RnmWQ237sDPBUYbp8BbBaEyuDILOYmr/iY+ZbDvLKuImN2HH4sc6tT8bX7S6SXH
         Y9uQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791307088; x=1791911888; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IYoFhdR6a50T0V6unvIVYfJRbGq2pHrg3/lVy4LzpxI=;
        b=NS8wAurax6ZQjMqroLtD2uG3W5wKTZqoOwZRScKOwQb6iDn3zexcZWHlswLia4V7Pe
         B02lMR2dG6gQxSKIWfYMUM6NBzlnqdGdHoDttB3GantZD56+nBG9huKymXvwTwHVpzsx
         ikpmoLNULv2gu3cQw/KWrybGjOtAdWV0xlygVABT9RFtwkw08WzP1gvCaaO86qfHhzkb
         yhh7pvdjFCmf6SMZ27TELBBgIV2U6jSTtQDYlncb6lLprdnoCt9YNZE4l24KxQkcFnBx
         T1RUgI+5A+5oZfJjjPeoSQnGsEZe3RYoLzzgJ2YFYsqIo6GewzjWv2PUZQw5IxRqn+8j
         Y0rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791307088; x=1791911888;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=IYoFhdR6a50T0V6unvIVYfJRbGq2pHrg3/lVy4LzpxI=;
        b=R1qkc7KFPCZLwMj4k4qQgKo94UR0kG97q982QfaWxTjEyY0l5IVIAGF98+x6vNqjjv
         RGTKNetTaFftsLn7LnAeQR3VPJ1pYfOM5nS3/ALQxhETYvF8O5p0jNIC055ucTof7ucZ
         AhTThj3+Pb//bn7RRQIABAk58h/+FvL9r2zjdRv8J5Wrj1i+g/gk2gEa9EYeRF8b4d9x
         KSZ2v/7xq7EJ9BxohW+c50BrOYUjzmw8QWz5S4ejMk/wdI0Q8lHNIg6ef/K2R42TocA3
         LHpQJlyGPyH7m1THFiLtVUnZ1bxOvoaP8Cn0tpI0D6RHUyDSk+CPhbY9ytD5KVJlNv/p
         9a/Q==
X-Gm-Message-State: AFuF++n4Eua+qunJfnHpZvOWxNlmg2pPrF+hTkKo0SEClxrNGA2O8+WZ
	SMqoOkKhI0d7QA4EIzRNkHZlPEtC6DcqcgdKGHx2fjgznFbCLoiJq+19E+dMA7gBlrmaBbXn+Jp
	GqJpOjC8hfS5iK75hbuNDPr/ErWgoj6TrnJHnp2R/oeto
X-Gm-Gg: AYBFou1W/JM34g+eZaBhKv3LZajh1U7BZPqNiJqR+lngPzEOMpX8RXUUbnqp48eN6wl
	WRQiPyvXmK8bU7WhIp57yKWrkkES6eL+kd6Dev9OZqrq24lWAMkhWmid3xJgIp72GnuPYxnUv60
	RgD/lOqNcbte7k9TVrvDHt0uHNCmqRi3lZ1joSuo+tSeiw/RplOe8nr3/13HWGgH8NBgD275cut
	eKgWr1Zkg5WI8FgVBuSMRPnQnZQC4trKDgG2pvPpncy5jXFWoQCPt7ejUJTE+rUsQlT7QjTCZJo
	Nv6tYJ25V9V8o5qdnqqqSh3yow7LtFA94DOFUgfyTwKK1ROiUJYO2mHIJF4Ww5RPdgz73LKp+dF
	BCMo1DNFhIPZ3fTE+Ik0FDT3LP3Uxeeew
X-Received: by 2002:a05:620a:2584:b0:93e:795c:9d07 with SMTP id
 af79cd13be357-93e8f382b1emr394780685a.35.1791307088187; Tue, 06 Oct 2026
 10:18:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: =?UTF-8?B?0JPQtdC+0YDQs9C40Lkg0JHQtdGA0LjQtNC30LU=?= <game.advencher229@gmail.com>
Date: Tue, 6 Oct 2026 20:17:56 +0300
X-Gm-Features: AclHuK9rzk0D650Q1s01qstkldc1WfPiCtqEKEuBYsW4iS9PUILAiEQMdqamknI
Message-ID: <CAEhAYcrrRyZvNU4i+jznPW4jxS1F_s5iH6AMZE4_mVgLbtAhXQ@mail.gmail.com>
Subject: Subject: [REGRESSION] mt7921e: ~20% lower throughput on first
 association after boot (7.1/7.2), reconnect restores it
To: linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, 
	Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, 
	regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Hi,

On my laptop the MT7921 (PCIe, mt7921e) gets about 20% lower TCP
throughput on the first association after boot with 7.1.10 and 7.2.8.
Simply re-associating (NetworkManager "connection up" on the same
profile, nothing else changed) immediately restores full speed.
6.18.55 is fast right from boot.

Hardware / software
- Lenovo IdeaPad 5 Pro 16ACH6 (82L5), Ryzen 7 5800H
- 03:00.0 MEDIATEK MT7921 [14c3:7961], subsystem 17aa:e0bc,
  ASIC revision 79610010
- WM firmware ____010000, build 20260224110949 (linux-firmware
  20260916; the MT7961 files are identical to 20260622)
- Arch Linux kernels: 6.18.55-1-lts (good), 7.1.10-arch1-1 (bad),
  7.2.8-arch1-2 (bad)
- NetworkManager 1.58.1, wpa_supplicant 2.12, WPA3-SAE, CCMP
- AP: TP-Link 802.11ac router (no HE), 5 GHz channel 48, 80 MHz
- iw reports the same rates in both states (VHT-MCS 9, NSS 2, 80 MHz,
  SGI, 866.7 Mbit/s rx/tx), signal -37..-52 dBm

Measurement
4 and 8 parallel HTTP downloads and 4 parallel uploads (curl, 8 s
each) to an Ookla speedtest server 3-7 ms away (ping min/avg),
bound directly to wlan0. The ISP plan tops out at ~530 Mbit/s,
which is also what a phone on the same AP gets, so "fast" below is
capped by the uplink.

Results in Mbit/s (ranges over 2-3 rounds)

  kernel   state                                  down     up
  6.18.55  right after boot                       525-531  510-538
  7.2.8    first association, ~5 h uptime         402-431  470-483
  7.2.8    first association, fresh boot          340-431  368-430
  7.2.8    first association, fresh boot          426-443  409-472
  7.2.8     -> same boot, reconnect only          520-531  525-538
  7.1.10   first association, fresh boot          359-426  421-496
  7.1.10    -> regdb installed, RU, reconnect     519-531  521-537
  7.1.10    -> regdomain back to 00, reconnect    522-530  530-539
  7.1.10    -> modprobe -r + modprobe mt7921e     516-526  536-539
              (plus one outlier at 388 down)

The slow state persists for the whole session: on one 7.2.8 boot the
journal shows a single association at boot and it was still slow
about 5 hours later. The fast state after a reconnect has so far been
observed for about 10 minutes without another re-association.

Ruled out
- power_save off (iw): no meaningful change (+~3%)
- PCIe ASPM: disabling L1.1/L1.2 and then L1 for 03:00.0 via sysfs
  on 7.1.10: no change
- Regulatory: slow both with regulatory.db missing (world regdomain
  00) and with wireless-regdb installed (driver sets RU before the
  association). After a reconnect it is fast with either 00 or RU.
- Firmware: the same files on all kernels
- Association parameters are the same on the slow and the fast
  association (SAE, PTK=CCMP GTK=CCMP)

Not tested yet: Bluetooth coexistence (the combo chip's BT is powered
with no devices connected; hci0 finishes setup ~4 s before the first
Wi-Fi association) and suspend/resume. I have not bisected yet. I can
test patches, enable debug options or try more kernels if that helps;
I also have ethtool -S and station dumps from both states.

#regzbot introduced: v6.18..v7.1

Thanks,
Georgy B.
