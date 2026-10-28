Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793184222;
	b=Ml+wV9nzCglYa97ymZScXWy6CMm2B55wDXRanle9C2gFsvG+5k6mrYaKu17ov7t5BXGE
	 o5bwCheRtGYyPGg9/B+hPT85UFruWwtzQMi7MJJVmfazrJP+jhv3crCRVMS1kQAyraeJ1
	 i+//A2jTEPb1faHlzbZ1OHNbGIkxt3APVx8S9caYg85CHobw7cFp2sBIRJpoyW1b1W7QA
	 8IRf7JZEmNJS1X5fbYqUNbFb2QPrTvrf2h2CxqopwllKyRCy2CfqlWuG+56EMI/ZYiQPn
	 3XA22wIQm6rcF4sbq+/HOwUgrLQcS8Jau2mWZ8xbwfqKE6KBh+Z2WvTO3qzESwcc89w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793184222;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ai47clIcETbb5x0K9gRtv2yXoRDAA5PFtwgsEioEvA8=;
	b=Qs/qJOPQQr5cfcD27mxaTFZloYPCdHjfu220/dL5vY8BaOKGjgibYi+CN2Gah/xGyFN4
	 96Jauz4Te3iODL4PMJ6fHPG1Hi2sKP8HZeIHv9uHfxFg/TvOXMcB/SV0dkKxtBh6hwl6T
	 U+RFkz2y7CLP/3xHwQMCcfrTeA38jto71puV+yUw7iEj9Pt58eNoyQEbVElbg0NEvFp/T
	 sHWOwcUZ+784Cm9TqCoGn/SI+MOt936Kx10mg7g7qgtV2mks7+s90ZDabb422PxkGyn08
	 9ltjca/ZiVr24LUb9XwjsGbAm4JFOzoqHbKQq3ImNaM1Pe2NgYpYgU0d0Tkvhw3fyXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a58evAcO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992BA606A33C
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 10:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a58evAcO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00E7A1F031E2;
	Wed, 28 Oct 2026 10:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793184222;
	bh=ai47clIcETbb5x0K9gRtv2yXoRDAA5PFtwgsEioEvA8=;
	h=From:To:Cc:Subject:Date;
	b=a58evAcOZtq4Xq8lH58Pan7Kmgvizf9cIKwrCLFphCLyrHOAghvhqpAGU4qz4uXBH
	 WkkNKBdhBli0KcZa8zXPgk8euCR4Kg1J1XH8e+5Q3+iclsvXdapV2pFuIWDwVNERBA
	 /HIeL3+zMcR69ZSaseCFSomQqigvqh4h40nMLEH8Vd4kEvzJ0Sq4pv1PQZzwrLu0h7
	 EtxrZg/USOO6DyIh4HUWiFfGhm8WmYUdlvHR8xoC41rkS+0iDtd5Tn8JtbITx/VuH7
	 h22jq8Q1wPL2ouVQSzOeZFtAf6iTaUHniir9cunX9Hm7/2wTuB5puvRTdH18L17ogh
	 TS+xJmUA+2reQ==
From: Vladimir Zapolskiy <vz@kernel.org>
To: Jeff Johnson <jjohnson@kernel.org>,
	Kalle Valo <kvalo@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org
Subject: [PATCH] wifi: ath11k: Unprepare MHI on power up failure
Date: Wed, 28 Oct 2026 12:43:36 +0200
Message-ID: <20261028104336.1686334-1-vz@kernel.org>
X-Mailer: git-send-email 2.51.0
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

If MHI power up fails, for instance it happens due to a missing firmware,
ath11k_mhi_start() returns without undoing mhi_prepare_for_power_up().
Then the failed probe or power up unwinding frees the MHI controller,
but the MHI device context and the RDDM image table allocated by
mhi_prepare_for_power_up() are leaked along with their DMA buffers:

  % cat /sys/kernel/debug/kmemleak
  unreferenced object 0xffff00079156a140 (size 64):
    comm "(udev-worker)", pid 595, jiffies 4294893781
    hex dump (first 32 bytes):
      00 d0 f1 80 00 80 ff ff 00 50 f1 80 00 80 ff ff  .........P......
      00 d0 f7 80 00 80 ff ff 00 30 fc ff 00 00 00 00  .........0......
    backtrace (crc 62662f0a):
      kmemleak_alloc+0x34/0x40
      __kmalloc_cache_noprof+0x224/0x3b8
      mhi_prepare_for_power_up+0x58/0x548 [mhi]
      ath11k_mhi_start+0x30/0xb8 [ath11k_pci]
      ath11k_pci_power_up+0xcc/0x188 [ath11k_pci]
      ath11k_core_init+0x8c/0x190 [ath11k]
      ath11k_pci_probe+0x4e0/0x870 [ath11k_pci]
      local_pci_probe+0x40/0xa8
      pci_call_probe+0x64/0x190
      pci_device_probe+0xac/0x138
      really_probe+0xbc/0x298
      __driver_probe_device+0x16c/0x19c
      driver_probe_device+0x3c/0x114
      __driver_attach+0x98/0x19c
      bus_for_each_dev+0x74/0xd0
      driver_attach+0x24/0x30
  unreferenced object 0xffff0007916fb800 (size 512):
    comm "(udev-worker)", pid 595, jiffies 4294893781
    hex dump (first 32 bytes):
      00 60 04 81 00 80 ff ff 0a 00 00 00 00 00 00 00  .`..............
      00 10 e0 82 00 80 ff ff 00 00 00 00 00 00 00 00  ................
    backtrace (crc 52e9e075):
      kmemleak_alloc+0x34/0x40
      __kmalloc_noprof+0x280/0x440
      mhi_alloc_bhie_table+0x54/0x168 [mhi]
      mhi_prepare_for_power_up+0x318/0x548 [mhi]
      ath11k_mhi_start+0x30/0xb8 [ath11k_pci]
      ath11k_pci_power_up+0xcc/0x188 [ath11k_pci]
      ath11k_core_init+0x8c/0x190 [ath11k]
      ath11k_pci_probe+0x4e0/0x870 [ath11k_pci]
      local_pci_probe+0x40/0xa8
      pci_call_probe+0x64/0x190
      pci_device_probe+0xac/0x138
      really_probe+0xbc/0x298
      __driver_probe_device+0x16c/0x19c
      driver_probe_device+0x3c/0x114
      __driver_attach+0x98/0x19c
      bus_for_each_dev+0x74/0xd0

The MHI device is already powered down by mhi_sync_power_up() on
failure, but mhi_unprepare_after_power_down() still has to be
called on error path to release the allocated resources.

Fixes: 3df6d74aedfd ("ath11k: mhi: use mhi_sync_power_up()")
Signed-off-by: Vladimir Zapolskiy <vz@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mhi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath11k/mhi.c b/drivers/net/wireless/ath/ath11k/mhi.c
index a6c9ff112c68..76c194573ec7 100644
--- a/drivers/net/wireless/ath/ath11k/mhi.c
+++ b/drivers/net/wireless/ath/ath11k/mhi.c
@@ -446,6 +446,7 @@ int ath11k_mhi_start(struct ath11k_pci *ab_pci)
 	ret = mhi_sync_power_up(ab_pci->mhi_ctrl);
 	if (ret) {
 		ath11k_warn(ab, "failed to power up mhi: %d", ret);
+		mhi_unprepare_after_power_down(ab_pci->mhi_ctrl);
 		return ret;
 	}
 
-- 
2.51.0

