Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.231.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793041842;
	b=I2HfQc+6KcdqjAJLODG6Ij2tOJHjwFaTnD1cjvjx5CfCKvjtRJBzzLFFOybrpKoRDErl
	 h0EFwGvvXT2lrDYcgvYMtee6GfvN4TacF1ypvHI99uAA5ahQy44vytEl/pJtepXEltlk/
	 6KmKxxrZZORa5/dXNrKJm2iX25vndCakKUEdLcMmDAaEuEMFG9gEhUienBuCUVPyhz+om
	 4/lhmLscdavREx4nni/cexbxLRAvOW9W3b2EmeU1x83N9VDDNZkqfN2KJ5DdzrdRosSMX
	 6QueBEjYULE0wGedWgGGnA+EChu7zqDfho3HBNqFUJN3RyMDcYizZifDHE3zg772LcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793041842;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:Subject:Date:
	 Message-Id:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=Vyh3iBjJiIVu4mxU7sYBtj/3/lKMxZvgStAYP3dEPdE=;
	b=nEnyPRcwhFq4m7dz88OQxaz6U8TMrBxDGVKoh27Y4psc3iXsHyqZprJRbj82Je0vjuen
	 +M2wzl+tfpICsEgqKhh28w2ycTRoecA4kOZl5OdlYVSPou1vk3pG1sV5Kw9wf2v5GeM/a
	 uLYvvWftQW7BO8264k+rqli7xYnUiytCWmHMtdv85i+lqHIPDG4ZxgsltcRr7PKtCyabT
	 iVVw0CWorJDiBejojukPdYp42jDTtJLtmW1cTtmGRanty5UYttAGF/Hku40vmSVmMGGtO
	 IraZ3IK4vEgirLd0aD0cfTuYYlsNpvRwfWf1rY67BaLT/XeHu5sARD3KcKYxMn8IcVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=sShvy7za;
	arc=none smtp.remote-ip=74.125.231.130
Received: from mail-oo2-f2.google.com (mail-oo2-f2.google.com [74.125.231.130])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23001606A31E
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 19:10:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 23001606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=sShvy7za
Received: by mail-oo2-f2.google.com with SMTP id 46e09a7af769-824413e10dcso1692039a34.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 12:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793041841; x=1793646641; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Vyh3iBjJiIVu4mxU7sYBtj/3/lKMxZvgStAYP3dEPdE=;
        b=sShvy7zangLTRy5ngZOGMlPg2vVwKdPo/iJKehA9yjLv3k47wBx3uCpGjyjXeCOv6J
         wFb16CIlM6Gc4VYDMrA3bVZWvlMIWI3V7BUeQQm04IbJ/0wkptBA+i06vjQsu/CgJ/lN
         J0wuX1rsX/3c6bYxWrvKY/+e2NvppCdZtbXgU+Dkv1r8OdamXVmaEd2FHiu5A9iu37Zc
         ZSEjDgHKUoMu5iglBz5ZRB/hVs9jOH3L+h0aZ3lKY9XklpejSxcLP+8pxohseIA0le2J
         z7kTArcUULKqgz/CStma2b/JeGtpvwxiNOxWXPTLLMu8VmwMMM0hTksRVVmatRnfmxZA
         i78g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793041841; x=1793646641;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Vyh3iBjJiIVu4mxU7sYBtj/3/lKMxZvgStAYP3dEPdE=;
        b=f/gzCrUaZLHc8BdVWrm/IGuJUp9pYRSwlwUZnfMnWR4WyWC5cLZoVqC7wG/ZgyXf85
         w4aKEBWWYt4v+MTbSrjhcYxTuTU3J0jfC6WypjHjEEH19hzN32vzCmfL2+NUcD8OLHjx
         8N9SVBs5qMrALgMrgGGp/wSc1FkpjqXMSHRJsxmmjZ5KQtICz9kJ4UEhTRWzhv9WZ1li
         sZXgCXnOHIohQvTaeU0PHq3V+5muV4AZ7HcUmF9wwqssbt00teoTKCRIdhT4MxdK3j8M
         KLoFRqdpseZgHdzDP/4SJZkjq/0bSTaEO4Vghq9BVE/oYDd1679Qaw44RF4Nk5KZ6dBB
         wzzg==
X-Gm-Message-State: AFq9FYL21B9Sh5oHe37hLZHsG1cdBE2a/sy+kqhaWgfnOtBREA/OJIYI
	AwvUfil1Pe0xt1tHmYe3jE5R4ILJM2pqXT4MNqwHphOQmFN/JOUfj6bK
X-Gm-Gg: AYBFou2nd6eoPcDxTVRCBKRfXLMj/WDjlBqXpTGIRlzTrDtuNytJv7jsRvK5NbeDu1j
	QffhoT81V1KFzKHzU/OHfG0jtzMsC5MGblO62rcW4wADS+SAGZqyzjRP7Hzp8FgXTnFIPxHfDcO
	aq4cmBOBJ3dd9L3XNoCz0abHoKT63tRbLFdVrvjg/VS7yDRx2b070MRzvavytvhKl+yPVW3g5Cb
	3PcUMOuXPAaRyi0ZOVHUBdbUXQUTA0ojE9aJUS3coyMJBroHwqiV79ZYZ4XrBBRo2mte9t3o+B7
	sYTOeI9eOzjDB/2jDKXYggrrO3McPokUi/TP8Q9nnjWBb0o/DtLLJLGS4U3HfzC8QG1wGXr0wXa
	si/vJREzqJL9aZLJp6qOAJfr8NecaboFF6NBDsQzZ+JaAxdtPx9E5mlP85fvEp7rl0a3YnACg9z
	w6c19O4Wj+A/+1HPLdR63h6dcdJxGiIiDaobrVtikfHtMrKMNWle5Fg/5z+TsaSqhKbPDmsWvE1
	+2K3vUCF3x+eTceJo+oGwfAsOselsLwAjqr2eyvvexhBJHGXXhssdRvYnescGVr8eehSiiRKYcR
	MatJSMsKQTek7Xs+oyQ+3S6bMrt0TThU5GhTlaifBIPSBA==
X-Received: by 2002:a05:6808:50a6:b0:4ec:4c7e:37b5 with SMTP id 5614622812f47-55c002c4d6cmr5571600b6e.29.1793041840897;
        Mon, 26 Oct 2026 12:10:40 -0700 (PDT)
Received: from [10.10.18.223] (wsip-64-207-253-118.tu.ok.cox.net. [64.207.253.118])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-55c03dc3524sm5740834b6e.0.2026.10.26.12.10.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 12:10:40 -0700 (PDT)
From: Ryan Brue <ryanbrue.dev@gmail.com>
Subject: [PATCH 0/4] wifi: mt76: mt7663s: two fixes and fewer SDIO status
 reads
Date: Mon, 26 Oct 2026 14:10:35 -0500
Message-Id: <20261026-rbrue-sheldon-upstreaming-mt7663s-v1-0-944b1f7e63a8@gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAA/x3NUQqDMAwA0KuEfBuwKXSjVxn7cG3UwKyS6BiId
 x/sXeCd6GIqjhlONPmo69owQ+gAyzy0SUgrZkDuOYWeA9nLDiGf5V3XRsfmu8mwaJto2W8pRSf
 mEkONY0n3ih3gZjLq9388ntf1A00N4KtzAAAA
X-Change-ID: 20261021-rbrue-sheldon-upstreaming-mt7663s-22c31d3fc68d
To: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, 
 Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>, 
 Sean Wang <sean.wang@mediatek.com>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
 Ryan Brue <ryanbrue.dev@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793041838; l=2308;
 i=ryanbrue.dev@gmail.com; s=20260906; h=from:subject:message-id;
 bh=tyqWodcb4HgA2IBe3psm2WrhLsTpaYYAyzN5LeZv4/A=;
 b=E4ysnrAqpc/wKUI5mzFLxFe8CxGZEzCtxfGQ1JNY+laZcPUAM6KONFWstDZqbNG1+jqMwAzk5
 HJ/ByhvWs+cCbQl2zCyqQISK2s1XAC/Ns8YnvGdS8EMZajk3AVJWTye
X-Developer-Key: i=ryanbrue.dev@gmail.com; a=ed25519;
 pk=KsUvVaP//v/2q+ZBuacc7cLbsyEYn+AD71Sn28oZWKo=

These came out of bringing up the MT7663 SDIO module of the Amazon Fire
TV Stick (3rd generation, MT8695) on mainline. The board's devicetree
is not upstream yet.

Patches 1 and 2 are fixes. With the offload firmware, a hw scan with a
random source address ends at once with no results, so NetworkManager,
which randomizes by default, finds no networks; patch 1 stops
advertising random-address scans on SDIO. Patch 2 lets mt7663s wait
while btmtksdio holds the ROM patch semaphore, instead of failing to
load its firmware when Bluetooth probes first. The matching btmtksdio
fixes for the same race are posted separately to linux-bluetooth.

Patches 3 and 4 make the txrx worker cheaper on the bus: the interrupt
mask writes become CMD52s, and mt7663s takes the next interrupt status
from the end of each RX read (RX enhance mode) instead of reading WHISR
before every RX read. On this board they halve the status reads; the
link is air-limited, so throughput did not change.

All four were tested on v7.3 on the stick, with btmtksdio built in; six
boots in a row brought up both functions, with each driver downloading
the patch first at least once. They apply cleanly to the mt76 tree, where
they were build-tested with W=1.

This series was developed with the help of an LLM coding assistant.

Signed-off-by: Ryan Brue <ryanbrue.dev@gmail.com>
---
Ryan Brue (4):
      wifi: mt76: mt7663s: don't advertise random MAC address scans
      wifi: mt76: mt7615: wait while Bluetooth downloads the MT7663 patch
      wifi: mt76: sdio: use CMD52 to mask and unmask the interrupt
      wifi: mt76: mt7663s: use RX enhance mode

 drivers/net/wireless/mediatek/mt76/mt76.h        | 10 +++++++++
 drivers/net/wireless/mediatek/mt76/mt7615/init.c |  6 +++++
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c  | 14 ++++++++++--
 drivers/net/wireless/mediatek/mt76/mt7615/sdio.c | 28 +++++++++++++++++++-----
 drivers/net/wireless/mediatek/mt76/sdio.c        |  3 +++
 drivers/net/wireless/mediatek/mt76/sdio_txrx.c   | 21 +++++++++++++-----
 6 files changed, 69 insertions(+), 13 deletions(-)
---
base-commit: 16f56d6e78fb3cdb3214bdc6a61c2b1c567c9aa0
change-id: 20261021-rbrue-sheldon-upstreaming-mt7663s-22c31d3fc68d

Best regards,
-- 
Ryan Brue <ryanbrue.dev@gmail.com>

