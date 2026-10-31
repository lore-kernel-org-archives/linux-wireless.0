Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793486420;
	b=tCnoPglc55gFiulFU8S1RkE9q7bZdhgiANIQKKSz8oGijrGmuMgavgYohNBNbmaKeHER
	 1B+rIoaJJGFomHLSqcb97eMrjwGT24pz4MjgyjxlZbljy1WZvgT/HP0swTBXQmV2MT/MZ
	 QCxfnvVR58nYbJsByi+1kIAMTfXiN5/0Yp9uRYNCHzw8KoNHs6mwWCtxEJQGSeW1jpXWp
	 G5VznKo1aY9hGSJrigRyE0QxJtdTdMxkqS6dS1sfTmy2xqWtKu7d7xMVFAF+lU1BBr/9U
	 0zFL337LyVq4z317xto07sxSYyXMiTunDPuExldyj1cpGvSY+db3ZVL4oX22KeFgaHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793486420;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Q5uvZDT1R9J4d3TC3fA2zDEXnWmfjPoepqdpmR39X5E=;
	b=LXQFvfX4Gl3skj0wgUAwlxOPL7WmgPgkv+LVgLjEH8Q8VvXPh7RnNQ/GlypJzDMhmA/W
	 DHxzYSCVDmspZGqxo7Eq67mitTXk//UGnn5ag0dS3SDvpeleiitrq3U0F+0PZOY8sOtdB
	 tuqnDSXNqjuVEM0LwuWZ95K85ddxN8Cyu/sZhnOn0uRzfVsYm1iR+GQEQcfh5QZErl7mB
	 pfjIyBVb9WAW6pFGfq/bUc6VLVa9aMuhh6YhQy831hqjga+KEJ7qUhBwAiszmRYfy9siG
	 OwQwAYP6w0qezcaoWAoKa3MjkhPV2jlO4ErPVhWxmEGEAlpJFVzuNhGsd3iI8g5IbOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nKUURtNl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1EC606A31C
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 22:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nKUURtNl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE0291F000C1;
	Sat, 31 Oct 2026 22:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793486420;
	bh=Q5uvZDT1R9J4d3TC3fA2zDEXnWmfjPoepqdpmR39X5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nKUURtNlbEjHNFFbeN65HrTkp7Y0dEK2zzJ0ulw8wEQ+yhR11bAQ0nYMJgqkETaCh
	 SpGdwFbN6zPbuzfHtK4lWVvU4glnvwvbZOdiLyxQXCsrQbdNaIEQ2ZxfTkKRHC464I
	 ob1Pj3aYbYWAHazkmAgVw2suG/bSQu2xWlW1jL/nEVrAJVVMjfteS1ZYg1BLrhQELb
	 t0zAj3dJairsPJg1P0JUzaFLC26ifKfMxIXi9r7vX1dFgtveiMCdtDDs9hto50Vz1q
	 9wkziizQB1qarYz130nh6xWKc1L6WuT/Y3CPRuW9r8fis6XuI0CgvQodoJjqhPtCZs
	 fkSRi240pOEjQ==
From: Vladimir Zapolskiy <vz@kernel.org>
To: Jeff Johnson <jjohnson@kernel.org>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Cc: Kalle Valo <kvalo@kernel.org>,
	Carl Huang <quic_cjhuang@quicinc.com>,
	Pradeep Kumar Chitrapu <quic_pradeepc@quicinc.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Bhagavathi Perumal S <quic_bperumal@quicinc.com>,
	linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org
Subject: [PATCH v2 2/2] wifi: ath12k: Unprepare MHI on power up failure
Date: Sun,  1 Nov 2026 00:40:09 +0200
Message-ID: <20261031224009.2323055-3-vz@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20261031224009.2323055-1-vz@kernel.org>
References: <20261031224009.2323055-1-vz@kernel.org>
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

If MHI power up fails, ath12k_mhi_start() returns with MHI still left in
the ATH12K_MHI_INIT state, and on this error ath12k_core_soc_create()
frees the MHI controller data, but does not power down the device and
does not free the MHI device context and the RDDM image table allocated
earlier by mhi_prepare_for_power_up(), this is reported by kmemleak:

  unreferenced object 0xffff00081c048100 (size 64):
    comm "(udev-worker)", pid 556, jiffies 4294893304
    hex dump (first 32 bytes):
      00 50 1d 80 00 80 ff ff 00 d0 df 80 00 80 ff ff  .P..............
      00 d0 05 81 00 80 ff ff 00 d0 fd ff 00 00 00 00  ................
    backtrace (crc 87372616):
      kmemleak_alloc+0x3c/0x50
      __kmalloc_cache_noprof+0x248/0x430
      mhi_prepare_for_power_up+0x60/0x558 [mhi]
      ath12k_mhi_start+0x44/0x1c8 [ath12k]
      ath12k_pci_power_up+0x1f4/0x398 [ath12k]
      ath12k_core_init+0x128/0x510 [ath12k]
      ath12k_pci_probe+0x814/0xe30 [ath12k]
      local_pci_probe+0x48/0xb8
      pci_call_probe+0x6c/0x1a0
      pci_device_probe+0xb4/0x148
      really_probe+0xc4/0x2a8
      __driver_probe_device+0x174/0x1b0
      driver_probe_device+0x44/0x128
      __driver_attach+0xa0/0x1b0
      bus_for_each_dev+0x7c/0xe8
      driver_attach+0x2c/0x40

After a failed power up in the reset or resume path the device stays
bound, but ath12k_pci_power_down() does not stop MHI, because
ATH12K_PCI_FLAG_INIT_DONE is not set. So the resources are leaked on
removal as well, and the stale ATH12K_MHI_INIT state bit makes every
later ath12k_mhi_start() fail until the device is rebound.

Release a prepared but not powered up MHI controller in
ath12k_mhi_unregister() and before preparing it again in
ath12k_mhi_start(). It is intentionally not released on the power up
error path, because the RDDM image may still be read by a firmware
crash dump collection in the reset work.

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Vladimir Zapolskiy <vz@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mhi.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/mhi.c b/drivers/net/wireless/ath/ath12k/mhi.c
index ee87f00bc5de..1b8d47eb5984 100644
--- a/drivers/net/wireless/ath/ath12k/mhi.c
+++ b/drivers/net/wireless/ath/ath12k/mhi.c
@@ -276,10 +276,22 @@ int ath12k_mhi_register(struct ath12k_pci *ab_pci)
 	return ret;
 }
 
+/* MHI stays prepared after a failed power up, release it here */
+static void ath12k_mhi_unprepare_stale(struct ath12k_pci *ab_pci)
+{
+	if (!test_bit(ATH12K_MHI_INIT, &ab_pci->mhi_state) ||
+	    test_bit(ATH12K_MHI_POWER_ON, &ab_pci->mhi_state))
+		return;
+
+	mhi_unprepare_after_power_down(ab_pci->mhi_ctrl);
+	clear_bit(ATH12K_MHI_INIT, &ab_pci->mhi_state);
+}
+
 void ath12k_mhi_unregister(struct ath12k_pci *ab_pci)
 {
 	struct mhi_controller *mhi_ctrl = ab_pci->mhi_ctrl;
 
+	ath12k_mhi_unprepare_stale(ab_pci);
 	mhi_unregister_controller(mhi_ctrl);
 	kfree(mhi_ctrl->irq);
 	mhi_free_controller(mhi_ctrl);
@@ -485,6 +497,8 @@ int ath12k_mhi_start(struct ath12k_pci *ab_pci)
 
 	ab_pci->mhi_ctrl->timeout_ms = MHI_TIMEOUT_DEFAULT_MS;
 
+	ath12k_mhi_unprepare_stale(ab_pci);
+
 	ret = ath12k_mhi_set_state(ab_pci, ATH12K_MHI_INIT);
 	if (ret)
 		goto out;
-- 
2.51.0

