Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.50.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793647405;
	b=w0mcaiOuLYBzgUjYPY6lufC5RdVqxwdZuVQ+hxj3em8DlPSUiYHabyGMKfh8L6t+5oZw
	 GWZcAfcM5c7n/REOlJAOXfp5XNkG4sACuNFn4c+kKqm+FrtjgYZJL/ApzkkEiw8n62K0N
	 oAJXjyPDsBRhLHPQ3iJ60dRy/s3BD/tGCHR4NFjZNvkYsT+qDWGIOWShhpkWcTIBIqRyf
	 rfer8qC5ELSx40aM+nw52WjQvtZnqChvjLTESxCtCzd4SrvfUq2Nyp6G3osyiMoumZGe3
	 afk8CKRPlCQ7NWdV0amzBtBf3utgOp/4tOKzsAMAdEamms7MbQwfDuNUuGyD/Skh3KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793647405;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Subject:Message-ID:
	 MIME-Version:Content-Type:Content-Disposition;
	bh=lCfRb7dvzYLRNpL4mVmuKuvbGYc/kVOpnEXSzysG3Dw=;
	b=rMGSxDyVZl+QTY8tB9WApPHMQ2iRq8RgDsZ8uYbO4SVcnVMsBuWqTcX5jmGQcnIXBDUV
	 /qyRFJEBu9390tXumPVkjwELB3lH81lUTb6k0hv6ia+NVAMCfRnmytoqw/GRwl5GODT1c
	 9ufxDF1Zj+7lEuCIcN0oaMA8aWBaVJ4xGpo/AWWmB1y6mbzdxMJBGCfvcy/YB/6ouy7Iy
	 PLlx+yMl3jf9nh48Z9gHiABYrGUDfAz2s9De9m/k/fhH91OK51E4cNdZY1sfc9EXfEW3Z
	 I3F/IbFyZAveZqoD/+TMOBc60qcbW7vfoMr9LPIDoYcMYJ305c9763v4uhqRIDayEqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=Bphjrv4f;
	arc=none smtp.remote-ip=90.155.50.34
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944D4606A324;
	Mon,  2 Nov 2026 19:23:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 944D4606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=Bphjrv4f
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=lCfRb7dvzYLRNpL4mVmuKuvbGYc/kVOpnEXSzysG3Dw=; b=Bphjrv4fnqb1OAomlKaoz8NZ0u
	4F1tv5MGwjZ4/0riuR0Q4x34MoEZ8rmmLBSi6DyZyorUfv/kc2O8La75sWuUs1qyn5qKLQzUHjeIs
	VYGMJBnGsJMlUqzfXOODP+CefjQaVYYK3F4gLYTiHtRBlxnbLQzBvVRfx4fs3bYBgmwSTS7DjyWRz
	BxqkJxPpohyYuxqJjgA13xhKrk+NGC/mSSdi7RpouSd9jEq0D8l5DfhudutgLEC5+mHoQRz7Gz1fR
	Y8shKusMQbw0Ycj/YAsrOeKfOCm7/1F2JRHQhc+T8LejEHnK4TWDVL9zBuE0tgBwOVGkZphnU42s6
	rBeBr12w==;
Received: from willy by casper.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xNxcj-000000056Px-1CVj;
	Mon, 02 Nov 2026 19:23:17 +0000
Date: Mon, 2 Nov 2026 19:23:16 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	JB Tsai <jb.tsai@mediatek.com>, Xiong <xiong.huang@mediatek.com>,
	Charlie-cy Wu <charlie-cy.wu@mediatek.corp-partner.google.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: mt7921e hangs when hardware fails
Message-ID: <aujjJPq-Qth7UyMp@casper.infradead.org>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Something appears to have gone wrong with the mt7921e in my Framework
laptop, but my attempts to recover are hindered by the driver hanging.

lspci:

aa:00.0 Network controller: MEDIATEK Corp. MT7922 802.11ax PCI Express Wireless Network Adapter
	Subsystem: MEDIATEK Corp. Device e616
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupts: pin B disabled, MSI(X) routed to IRQ 207
	IOMMU group: 19
	Region 0: Memory at 6019200000 (64-bit, prefetchable) [size=1M]
	Region 2: Memory at 98000000 (64-bit, non-prefetchable) [size=32K]


Here's the relevant parts of my dmesg:

[   54.429097] mt7921e 0000:aa:00.0: enabling device (0000 -> 0002)
[   54.434064] mt7921e 0000:aa:00.0: ASIC revision: 79220010
[   54.532459] mt7921e 0000:aa:00.0: HW/SW Version: 0x8a108a10, Build Time: 2026
0724143257a
[   54.906027] mt7921e 0000:aa:00.0: WM Firmware Version: ____000000, Build Time
: 20260724143402
[   56.086928] mt7921e 0000:aa:00.0 wlp170s0: renamed from wlan0
[164937.892036] mt7921e 0000:aa:00.0: driver own failed
[164938.942093] mt7921e 0000:aa:00.0: driver own failed
[164939.995093] mt7921e 0000:aa:00.0: driver own failed
[164941.272075] mt7921e 0000:aa:00.0: Timeout for driver own
[164942.316076] mt7921e 0000:aa:00.0: driver own failed
(...)
[164962.212360] mt7921e 0000:aa:00.0: chip reset failed
[164962.212383] wlp170s0: Driver requested disconnection from AP 84:a0:6e:ee:3f:b7
[164965.388396] mt7921e 0000:aa:00.0: Message 00020001 (seq 4) timeout
[164968.464445] mt7921e 0000:aa:00.0: Message 00020001 (seq 6) timeout

(hundreds of similar lines)

So I tried to rmmod to see if reloading the module would fix anything.
Unfortunately, it hung like this:

$ sudo cat /proc/136298/stack
[<0>] __flush_work+0x315/0x4c0
[<0>] cancel_work_sync+0x5e/0x80
[<0>] mt7921_pci_remove+0xb0/0x190 [mt7921e]
[<0>] pci_device_remove+0x4a/0xb0
[<0>] device_release_driver_internal+0x19e/0x200
[<0>] driver_detach+0x48/0x90
[<0>] bus_remove_driver+0x78/0x110
[<0>] pci_unregister_driver+0x36/0xe0
[<0>] __do_sys_delete_module+0x1de/0x350
[<0>] do_syscall_64+0xe1/0x650
[<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e

I think something's wrong with the hardware at this point because lspci
-vvv reported something funny in config space which has disappeared
after a power cycle.  Unfortunately I didn't record it, nor did I dump
lspci -xxxx.  I'll do that next time this happens.

My call to action here is that this driver should more gracefully cope
with hardware that's not responding properly.  Whatever work is being
waited for in __flush_work needs to timeout (I left it overnight and it
didn't timeout) or be cancellable.

After a reboot, it's working fine.  I'm going to try stressing the laptop
to see if it fails again, but wanted to get this report out first.
