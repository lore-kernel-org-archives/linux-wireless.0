Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20CC3D8128
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 08:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785312577; cv=none; b=Mg8UC3pa5H4I4+TUY0OEKyojc6upu58aJk2Na/QyDWOvq+7XCn+N3oQCr2SPmVGO8sNSVhfSaiiwTcbNrRlNmsp6+2KJyvI1diY0zlP5yTw8MZ2zKIbdZZ+68a6eEO0LTDQeerad720fJ062jO3n3qNy6hZV3vumT2XXPvDtvOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785312577; c=relaxed/simple;
	bh=YPwdDWzV72wXEvwOmVz4zO0Wuk3ynnVZ66yS2A96G4A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rWFdiCDhdNtL89ZT0PqJoRaJ5QN1YWJVR/1dBOeMmBCAbpfsl9axlaCdDxCPqYBaNh/oHTaEuup5L9glF0NBIp9Jf6MNOxkswQpPdu834mA+nejDuQPzH1WdSMETo1ALdmdjp1EpGfYK8oUAFae3wjvQjdx/Ycz96NW0LYMFk7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pQ6pHA+8; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pQ6pHA+8"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-47db714766aso1057430f8f.0
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 01:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785312574; x=1785917374; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PQGPp7H4ZR1+G13BP75L3PYyXUIdHtICat2MzwnzvU0=;
        b=pQ6pHA+89Pvv/mpBZTGVqLJRbuAqi8ek0FccWzjqfTzklajdvRKHNU01IVzG6Aa1jw
         MoWSy8ul5B743rwOVJ+uQESsZV/0RJLewMrc5iPSXtQxG49ws5X6/zMMyIR1wEs0Qv6O
         ehnf1bjekSpqvaf35DMnR9gTylfpW5dcwHIzMHOsNrYMyq9I0XJPw98S7eD5FEyfjkt8
         J6xa7ak2IsKgKn+3Fq6FJJbo22t2EVTj6X6MDBKyb9pjLQAPwcZbMTNkH+twG65ccmdA
         6eIIxH/kFAPizn7ZDMwE0t0KTHD0OtjPmslm8wOauhIJZ9+zamloHzZYCCdfYvnOXeHd
         MKyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785312574; x=1785917374;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PQGPp7H4ZR1+G13BP75L3PYyXUIdHtICat2MzwnzvU0=;
        b=dTYNqvl0mA5ALePKtr81KX07PexfAx7y1nEUd5bfNkSicN2iSoVowJFgrIraLLQOV/
         EADFqDWxYBi7WWbmjc5NTHfV1+WYNF10lF9ka1KWUVUsYi/2RS9nMbk9rrzXBOFSOTCl
         e/qsZ4Icppdf8Rg6Rf8l3fCG6RduNLM2roAc8JGQx0fi1UdJ0EhAY+KJAJ7PeVJkbePk
         irw4FWLn5kr8ewfbWSxt+pZRsvJwPEQHn9W/iwYdD7bDcfVSx9HS7KZHNmOGPFFmfVvL
         2CQCc4rnq5xuDG1/2hSkpz7vYFCjOCodwQATCm+5rjYb04goF9SkU8pjfsPqRJBvJ89M
         629A==
X-Gm-Message-State: AOJu0YwkLZNjPEh6+bKh0MmVWi3x8Pu/22SZOySVnQn82iiaJ/828p7w
	tAD8Vp0VdCnRw4+sLWbcg2qUvc2sjfmV/PD23KMp54Mjc6jDfIh+QphdIzG14w==
X-Gm-Gg: AR+sD12tt9W2IQqZaez97AEDDeCL8b6K7KicpAoOKeNOYKTRDlwE89L71+ev9ecHTat
	VCRsuLJmu0y5ypfn0Ld3eikokY5PgAyZl9S0NDarolXy3uuQpfb4QzaR8ggA2/VviA0aaLrwU6f
	6DyaVK4jO7Ar6/aCMwCbx/NF4hPn4IKBSnM6s4atSJYup7iKq3STiAAlw24M5bDCebdthqYT1Me
	Q9wzo+LnNP2f/YvOKtkIByd8fdr7Lvu1Jr+HTaC9rN5e2t9vHlC55viS1KWKmEggfT8SpsIRjbo
	DSFjRmG+AbltxogdIQCAwLZKEDY4i9ddx5CXTR+EWfGqZHU7RQuKzOOIB4as0Z0NrZhHGuAW84x
	8uLj+RNpXC6KLS1XpBaPN5yVmvWrGUN/bZfYwhKevpYzEJoV5t2HAqSt0xAqZhocbuV/9sjkxCu
	t5kCGjSJICD59d6EtztNre7TX9npY1quhM8pkGillLx5YEtc+Cri3OtL/hQmBztgYCi3B4N3dfT
	l5mgk+sfcIGpSFZATFstCNROigNS6xKUg==
X-Received: by 2002:a05:600c:19cb:b0:495:7016:b875 with SMTP id 5b1f17b1804b1-497fd3098f0mr11122455e9.13.1785312573650;
        Wed, 29 Jul 2026 01:09:33 -0700 (PDT)
Received: from syracuse.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4957bff4784sm345456145e9.4.2026.07.29.01.09.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 01:09:33 -0700 (PDT)
From: Nicolas Escande <nico.escande@gmail.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH ath-current] wifi: ath11k: reset ar->num_station on hardware start
Date: Wed, 29 Jul 2026 10:09:32 +0200
Message-ID: <20260729080932.3462066-1-nico.escande@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When (multiple) hw restart occurs, we end up in a situation where we
cannot accept new stations / mesh peers. This seems to be the
'num_stations' in 'struct ath11k' that did not get reseted properly in
this case. In ath11k_mac_op_start(), it was indeed the only accounting var
that did not get reseted so let's clear it too.

This avaoids problems like those:

	[1248828.088023] WARNING: CPU: 0 PID: 12281 at net/mac80211/util.c:1682 ieee80211_reconfig_stations+0x98/0xc0
	[1248828.088029] Modules linked in: ath11k_pci XXX [last unloaded: ath11k_pci]
	[1248828.088053] CPU: 0 UID: 0 PID: 12281 Comm: kworker/0:0 Tainted: G        W          XXX
	[1248828.088058] Tainted: [W]=WARN
	[1248828.088059] Hardware name: XXX (DT)
	[1248828.088060] Workqueue: events_freezable ieee80211_restart_work
	[1248828.088064] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
	[1248828.088068] pc : ieee80211_reconfig_stations+0x98/0xc0
	[1248828.088070] lr : ieee80211_reconfig_stations+0x94/0xc0
	[1248828.088073] sp : ffffff800025bc10
	[1248828.088074] x29: ffffff800025bc10 x28: 0000000000000001 x27: ffffff8027b19640
	[1248828.088078] x26: ffffff802a5619c8 x25: ffffff8027b199f0 x24: ffffff8027b19880
	[1248828.088082] x23: ffffff802a560e40 x22: ffffff8027b18880 x21: ffffff802a560800
	[1248828.088087] x20: 0000000000000001 x19: ffffff8027c71000 x18: ffffffffffffffff
	[1248828.088091] x17: 128c0801a9c37469 x16: 766e692d32464545 x15: ffffffffffffffff
	[1248828.088095] x14: 000000000000001f x13: 00000000000000b1 x12: 0000000000000001
	[1248828.088099] x11: ffffffc081061518 x10: ffffff800025baf0 x9 : ffffffc0808097f8
	[1248828.088103] x8 : 00000000ffffffd0 x7 : 0000000000000000 x6 : 000000000000003f
	[1248828.088107] x5 : 0000000000000000 x4 : 0000000000000000 x3 : ffffff8011ef2e80
	[1248828.088110] x2 : 0000000000000000 x1 : ffffff8011ef2e80 x0 : 00000000ffffff97
	[1248828.088115] Call trace:
	[1248828.088116]  ieee80211_reconfig_stations+0x98/0xc0 (P)
	[1248828.088119]  ieee80211_reconfig+0x774/0x1438
	[1248828.088123]  ieee80211_restart_work+0x10c/0x178
	[1248828.088127]  process_one_work+0x178/0x3c0
	[1248828.088130]  worker_thread+0x280/0x440
	[1248828.088133]  kthread+0xe0/0xf8
	[1248828.088137]  ret_from_fork+0x10/0x20
	[1248828.088141] ---[ end trace 0000000000000000 ]---
	[1248828.090658] mesh1: HW problem - can not stop rx aggregation for 72:fc:8f:a8:f1:ed tid 0
	[1248828.090667] mesh1: HW problem - can not stop rx aggregation for 72:fc:8f:a8:f1:ed tid 3
	[1248828.090670] mesh1: HW problem - can not stop rx aggregation for 72:fc:8f:a8:f1:ed tid 4
	[1248828.090689] wlan2: HW problem - can not stop rx aggregation for 78:64:c0:26:8e:69 tid 0
	[1248828.090694] wlan2: HW problem - can not stop rx aggregation for 78:64:c0:26:8e:69 tid 1
	[1248828.090697] wlan2: HW problem - can not stop rx aggregation for 78:64:c0:26:8e:69 tid 5
	[1248828.090700] wlan2: HW problem - can not stop rx aggregation for 78:64:c0:26:8e:69 tid 6
	[1248828.090704] wlan2: HW problem - can not stop rx aggregation for be:3b:3d:84:3a:00 tid 0
	[1248828.090707] wlan2: HW problem - can not stop rx aggregation for be:3b:3d:84:3a:00 tid 1
	[1248828.090710] wlan2: HW problem - can not stop rx aggregation for be:3b:3d:84:3a:00 tid 6
	[1248836.686596] ath11k_warn: 39 callbacks suppressed
	[1248836.686604] ath11k_pci 0000:04:00.0: refusing to associate station: too many connected already (128)
	[1248836.686609] ath11k_pci 0000:04:00.0: Failed to add station: e8:51:9e:d6:93:22 for VDEV: 1
	[1248941.120126] ath11k_pci 0000:04:00.0: failed to flush sta transmit queue, data pkts pending 2
	[1248941.120186] ath11k_pci 0000:04:00.0: failed to clear all peer keys for vdev 2: -2
	[1248941.120190] ath11k_pci 0000:04:00.0: Failed to disassociate station: 92:14:23:65:57:fc
	[1248941.120196] ath11k_pci 0000:04:00.0: failed to lookup peer 92:14:23:65:57:fc on vdev 2
	[1248941.120200] ath11k_pci 0000:04:00.0: failed to find peer vdev_id 2 addr 92:14:23:65:57:fc in delete
	[1248941.120204] ath11k_pci 0000:04:00.0: Failed to delete peer: 92:14:23:65:57:fc for VDEV: 2
	[1248941.120207] ath11k_pci 0000:04:00.0: Failed to remove station: 92:14:23:65:57:fc for VDEV: 2
	[1248941.121319] ath11k_pci 0000:04:00.0: refusing to associate station: too many connected already (128)
	[1248941.121326] ath11k_pci 0000:04:00.0: Failed to add station: 92:14:23:65:57:fc for VDEV: 2
	[1248941.123036] ath11k_pci 0000:04:00.0: refusing to associate station: too many connected already (128)

Tested-on: QCN9074 PCI WLAN.HK.2.9.0.1-01977-QCAHKSWPL_SILICONZ-1

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
---
 drivers/net/wireless/ath/ath11k/mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index ae91b57c8422..c1fa42edd363 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -6716,6 +6716,7 @@ static int ath11k_mac_op_start(struct ieee80211_hw *hw)
 	ar->num_started_vdevs = 0;
 	ar->num_created_vdevs = 0;
 	ar->num_peers = 0;
+	ar->num_stations = 0;
 	ar->allocated_vdev_map = 0;
 
 	/* Configure monitor status ring with default rx_filter to get rx status
-- 
2.55.0

