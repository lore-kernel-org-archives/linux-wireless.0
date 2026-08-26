Received: from mail-yx2-f11.google.com (mail-yx2-f11.google.com [74.125.224.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9262539902B
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 20:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.139
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787777875; cv=pass; b=jWWxnRQ2qRRMZEbFnMmMjVSqI8bwXX7jpSUy+QhPLt55vQZmFF/KMd75eCPS0KVHCto6VtBet3nM3hrRhiYYRjC9EQr68Nl22GK+1SCGCx3vYqV5YnR3rsuVKcvDEWVMG2rv17kSRNx9Vr62A0quV2BDuAQOOIPpoDw3+m9xzqY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787777875; c=relaxed/simple;
	bh=gK0yiN5K5EYANJa1YYELUTPZXoozVNQjTSBeyfXo9Rs=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=XCc13+5nCIN2nDd/QyhuKSj5YIsP1ehQcGNXerNCFVyDxDMcwHG0COUdrUuDh/BGGQEHJkWgLxF0wE01aJN1V1AP5aDDsuGokY9AiPlxOTu46Mkn7r0qKel8O5lwOwJ6/BmSCdajPyzcGyt6uMki9j+oxjg1OGt59d/dzQTzUyY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TCT//0/c; arc=pass smtp.client-ip=74.125.224.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TCT//0/c"
Received: by mail-yx2-f11.google.com with SMTP id 956f58d0204a3-66c70d59eb7so315273d50.0
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 13:57:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787777872; cv=none;
        d=google.com; s=arc-20260327;
        b=Y1Usg3fRr+hGI+mhayorszSXhMIYUPN85q5ae1p50VK5MGxZSJU9HgQK46ZaRb7hqY
         Rqavg+K6kFRqNzdrThEVH2wQi9RaCOxcGHE8sGV1CKmZiqdbTqme9MUgbC21E+EjKxKX
         GK4kK9gvW3mKz1jLwQCXM8tNgVppVhMfRG9gJWJisqNLlkxTf+Y+o1CKKPCFEIg9sL8l
         jliWW9rNmzo68e/stxUzAHux0fcPnxXLjADZftB3eQzcyPVgA/7dFMCCFaFXlZFFrBYZ
         cn9JuiAKeYLOilVVMyAyyb9gFPlbrnD56TyqvSWJsOMj6USzMXs57Jos/6BbcaJ8vOiV
         iBzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=gK0yiN5K5EYANJa1YYELUTPZXoozVNQjTSBeyfXo9Rs=;
        fh=qW0phhq3fb3oiohK/Mu9j1KY1zyRNiiioKFc5anvatM=;
        b=sJfSpFMbfY3At1f0HCFDMLVbLvfyfLnwfzMcTw5VLq1XXrSWrac9CwZRwN+SyGEIS3
         hQy5wnUS0Iwakbp231Q/mbEjyjdBWzajN1Qi4p2j52WuKOwY+C1dFSe5Z+UDoMql4oqA
         iQv2uGKZ16QwuBO/unT0SbGWSVsU4HjmKjOq50Oyxe7lnv+YmBNgrkkuMRXxJ71tB3B5
         p4vVYBWdVEFYk0GyK35MoSNnqs6LJf+mrofTQr1pa6IstutMJA5u5OgzZ7WBMQPIN9kN
         U+tDKs3Z+m3TZdQevMGoDmpoap+3azgQH9+vGGWB+lJQzB6cdTbL72WcK3ggzD90IAqe
         rXZg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787777872; x=1788382672; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=gK0yiN5K5EYANJa1YYELUTPZXoozVNQjTSBeyfXo9Rs=;
        b=TCT//0/cnQyrSFjy3I1u4RhbKa15+8V8DzVG0RCytllO1Jmn/pvSmh+oNdRKaUICBb
         uXE52o1ANW6UxjUfq24hgYAio+o+x1eYQ7gfBzjunKLn6wPLx4FYym162R/GSomnXTXz
         jx1+qredVIFrtoak3kdqtya4iXejes7ebNqHjZW1P35NXjRJBzPvojRqWvKWH0EATPXq
         hrqlMiQKHx7g66h3BD89GYKcWLueSDVVv+qgnQMqk3pBA43ETITLUK14b4stAeOMY98n
         slwlpq+K0Fz1uU1i3BJV5kaG89+DseVxpEXW7aQClEujsTOIbd+uOW2c9SSnSibhTFl1
         rEVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787777872; x=1788382672;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gK0yiN5K5EYANJa1YYELUTPZXoozVNQjTSBeyfXo9Rs=;
        b=d084LlyrjG0haGYhiqC2pS3nOMtN8OPGRhkqT4ymHBUYoxaPE+3Ka89E+8rQCsyWX+
         Wjdgf3UCefcxzFDAxGWt6gDm9gHPwpUcLKl3jxZ6MMa/ut6zFX3w84dVYanV1iF6eoNI
         m0NWTtSqhMfy0QERGZRcjAYAkzAu6Xs4XFjx+z0pjjvwU50XVoP6xhyq2HHA3P0u6z1c
         M4kBY+NUhthixup7c2FIJCajdSx4M9kDPO632t+HKh2TJcTPJHpEAURkuHw8Ih8c2WnJ
         KgZoIHcCmlwmAojMF+CPMDh+hP+9r6qXn1mp+7f51MK7k/lSfSyn3Crsc/nMNGqHsQNH
         9GTA==
X-Gm-Message-State: AFuF++nlRL80e5XjJUaWuBYQn7RyxC3cXrhcbCUlKkg6UjwpGI8Va54r
	hzI4Vi2+0RA/dR6hv1fkJ9wxFN0V0DBcr553DREJThB3qaPoOjdYpFHDQreCMDjsuhvWS7vFnO7
	B932uXfKloMmOwuoxgGacSpuTqWCRbPEXh54nvHsDJYVB
X-Gm-Gg: AR+sD10xbPY4i1GD9AJBWinkeLp00Kn5fDmlWW4nfIMrO3t1kELoxkit9+H0spAiVfN
	jrZDOSavDKyYrV8qmOQp5j/Bwg1Wf40t0601eOoXZDA5qS7+Hm2MLQlrNdsp4oliXvjBke39QDx
	YZklczpHSRScI4PlZwrnNSysn/QCAMFcoynrQUds/19mBqeJdq84nQf2rVoHxrHrF8hk50TqV2u
	xX5yeABefiSpvbP4kDbUiHsWwbFoxilSJRotrXlMbX/4t7uyOxWNwUkR1gt/6xzm5j0b7HOa5T1
	gxVWGOVJpBXsF+xi4o9ksrHm+VMQlFV2qj5pOjPImWfhUTnhqM3zkjN+gj4m9SjqoLUsqSo96lG
	I
X-Received: by 2002:a05:690e:1309:b0:664:c5f8:e342 with SMTP id
 956f58d0204a3-66e0e8b7b7bmr735619d50.3.1787777872448; Wed, 26 Aug 2026
 13:57:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Noah Yacob <noahgyacob@gmail.com>
Date: Wed, 26 Aug 2026 15:57:40 -0500
X-Gm-Features: AcwNN1UMo2t8e7G3XXUGHrqaLZMvTgARzeJ4MmbV-Bi2E4pxgkScpBesbqHoMH8
Message-ID: <CAFE5c2sfBBn+z-epYGffZskffGbcpafmD020-j-NK0waQ_QFwg@mail.gmail.com>
Subject: mac80211: HT disabled ("required MCSes not supported") on Xfinity
 network, RTL8852BE (rtw89) capped at ~20 Mbps on kernel 7.0.0
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

I'm reporting a throughput regression that appears to match an issue
discussed on the Arch Linux forums
(https://bbs.archlinux.org/viewtopic.php?id=313033), where other users
ran into the same symptom.

- Wi-Fi throughput dropped from near-gigabit speeds to a hard ~20 Mbps cap.
- Confirmed not an ISP or router issue: booting an older kernel
(6.8.0-138-generic) on the same machine, same hardware, same network,
restores normal (near-plan) speeds.
- Confirmed not a driver-installation issue: the in-tree rtw89 driver
is in use in both cases (no custom/out-of-tree driver).
- The regression is reproducible simply by booting the newer kernel
vs. the older one -- no other configuration changed.

Hardware / environment:
- Wi-Fi chipset: Realtek RTL8852BE (rtw89, rtw8852be), PCIe
- Driver in use: in-tree rtw89 (rtw89_8852be / rtw89_pci / rtw89_core
/ mac80211 / cfg80211)
- Firmware: rtw8852b_fw-1.bin, version 0.29.29.5 (da87cccd), cmd version 0
- OS: Linux Mint
- Broken kernel: 7.0.0-30-generic
- Working kernel: 6.8.0-138-generic (confirmed via dpkg -l | grep
linux-image and booting via GRUB "Advanced options")
- ISP: Comcast Xfinity, 1 Gbps plan

Symptom pattern:
On the affected kernel, dmesg / journal shows mac80211 disabling HT
("required MCSes not supported, disabling HT"), and the link
negotiates down to a 20 MHz, no-HT connection instead of HT/VHT/HE,
which caps throughput at roughly 20 Mbps regardless of my ISP plan
speed.

The fix that resolved this for other users in the linked Arch thread
is a community patch that removes mac80211's basic MCS/NSS check
(github.com/WoodyWoodster/mac80211-mcs-patch). That fix has since been
picked up into Arch's own kernel package as of version 7.0.13.

I'm submitting this to add a confirmed data point (RTL8852BE, kernel
7.0.0, Xfinity) in case it's useful for tracking or prioritizing a fix
upstream.

Happy to provide any other diagnostics that would help.
