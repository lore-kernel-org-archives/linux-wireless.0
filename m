Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793486417;
	b=B15c9QmbzvIFwGqjyX9OWgocXYHNbSkM92unXv4l3q1ACbkqCwdf4OTDBCW1XCiTgIrN
	 pECnXRSXuUeiFP6v9Hr8JakZt1H1QsQT1Vs1XoGcECFH3gyWXbKWf0tJTN6I4MvzylbZu
	 iC1kqd9mhqJR0CrGWXOCkyJuSNDOZ1xVvzf6LfL1ZHJNIpgkqB7SmlBNZwxtSiCaPmZJ4
	 25AB2KaKoiQaCwU0TQC4ZPxHvT8XfmQvyniRVC8f+yn8CNv6FzBnD5vlP0gK9YqEgp8Zx
	 zZFpwegoWuJtk/COiOksATkts++UwEdCZri8+cqOBNKy/fdaWiVrRnWE1jI+sHs21pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793486417;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=mBvw50yPLPYUlVxj9yc0bSSwNVREdoF5g4TMhpTFVYk=;
	b=vUlO02ZFgGz8z1eJ2u7rC5Lp59Ic+Ho1g2k7vTMpAULSTXZNYqhxP8JISlA+CGTpwqhI
	 m87LeCFcs3Dpkg16QyqozdMxCBN7hW3chx6UikJEZmWHsmua0wjjNLDvjcJuxuoN+tmbP
	 JITEhQKZGX9FUsE1LtYk6sSfkh88nV7iHDRzs+Yyf/CAJob2FgfUc06rOy0qeUe9dqoJy
	 Mx5eZUbpZtt6wwxY7y1ZGOXq/VbHov9gNVWYaab4/DcVMNooD6XpsYqfQwFcEP/dOQvR1
	 np0ldixEALuHOdgLfhrSPg9kcgKq4J5KWoico09y7VsUgZQpfAM/gpT8kQg3srTFw0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VvS+A7IS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA91606A31A
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 22:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VvS+A7IS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 009531F00919;
	Sat, 31 Oct 2026 22:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793486417;
	bh=mBvw50yPLPYUlVxj9yc0bSSwNVREdoF5g4TMhpTFVYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VvS+A7ISAQr/CJBK7QfPZpu/bX28mEynqsvwPqCUR4lYJE8ZVzLuIvoQZF8X8HiBp
	 TfRakfROd5A1BM4ZPLN4PfkERS3pckUjt/OWek8iOXrj5EG4HhcXOxw6BhzRrSoQ4Z
	 2tsQweik6xnwsWt4Kk9a22t7tz17YvqEA8UyNOZIjcXLU0qNzugIEEr0HMCzc9o732
	 wHHWsMcj9pKjzfLdcovJWhUA+GumTyGaWPc8q+ckeBQZByzahOgDMHAcfeC3d4Rmt7
	 MGpNuwuSOPbNJ3q8kX1qIasW6GNN7czyRE55Ttn8d0Pmdc9Duwy/84GGKxLK6A44u6
	 ZZnZteWRpqDyA==
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
Subject: [PATCH v2 1/2] wifi: ath11k: Unprepare MHI on power up failure
Date: Sun,  1 Nov 2026 00:40:08 +0200
Message-ID: <20261031224009.2323055-2-vz@kernel.org>
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

If MHI power up fails, for instance due to a missing firmware file,
ath11k_core_init() does not power down the device on this error,
the MHI controller stays prepared, and the MHI device context and
the RDDM image table allocated by mhi_prepare_for_power_up() are
not released, here is a report from kmemleak:

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

Track the prepared state of MHI in a new ab_pci flag, and unprepare it
in ath11k_mhi_unregister() if it is still set. The prepared state is
intentionally kept on power up failure, because the RDDM image may still
be read by a firmware crash dump collection in the reset work. After a
failed power up in the reset or resume path the device stays bound, and
ath11k_mhi_stop() releases the resources on the next power down, as
before.

Also unprepare MHI in ath11k_mhi_stop() only if the flag is set. If
mhi_prepare_for_power_up() fails in the reset or resume path, it
releases the device context on its own error path, and the unconditional
mhi_unprepare_after_power_down() in a later ath11k_mhi_stop() frees the
command ring buffers again and dereferences the NULL device context.

Fixes: 3df6d74aedfd ("ath11k: mhi: use mhi_sync_power_up()")
Signed-off-by: Vladimir Zapolskiy <vz@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mhi.c | 9 ++++++++-
 drivers/net/wireless/ath/ath11k/pci.h | 1 +
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/mhi.c b/drivers/net/wireless/ath/ath11k/mhi.c
index a6c9ff112c68..7cc652292d6f 100644
--- a/drivers/net/wireless/ath/ath11k/mhi.c
+++ b/drivers/net/wireless/ath/ath11k/mhi.c
@@ -425,6 +425,10 @@ void ath11k_mhi_unregister(struct ath11k_pci *ab_pci)
 {
 	struct mhi_controller *mhi_ctrl = ab_pci->mhi_ctrl;
 
+	/* MHI stays prepared after a failed power up */
+	if (test_and_clear_bit(ATH11K_PCI_MHI_PREPARED, &ab_pci->flags))
+		mhi_unprepare_after_power_down(mhi_ctrl);
+
 	mhi_unregister_controller(mhi_ctrl);
 	kfree(mhi_ctrl->irq);
 	mhi_free_controller(mhi_ctrl);
@@ -443,6 +447,8 @@ int ath11k_mhi_start(struct ath11k_pci *ab_pci)
 		return ret;
 	}
 
+	set_bit(ATH11K_PCI_MHI_PREPARED, &ab_pci->flags);
+
 	ret = mhi_sync_power_up(ab_pci->mhi_ctrl);
 	if (ret) {
 		ath11k_warn(ab, "failed to power up mhi: %d", ret);
@@ -463,7 +469,8 @@ void ath11k_mhi_stop(struct ath11k_pci *ab_pci, bool is_suspend)
 	else
 		mhi_power_down(ab_pci->mhi_ctrl, true);
 
-	mhi_unprepare_after_power_down(ab_pci->mhi_ctrl);
+	if (test_and_clear_bit(ATH11K_PCI_MHI_PREPARED, &ab_pci->flags))
+		mhi_unprepare_after_power_down(ab_pci->mhi_ctrl);
 }
 
 int ath11k_mhi_suspend(struct ath11k_pci *ab_pci)
diff --git a/drivers/net/wireless/ath/ath11k/pci.h b/drivers/net/wireless/ath/ath11k/pci.h
index 1e3005a4b64c..1e811245c1a5 100644
--- a/drivers/net/wireless/ath/ath11k/pci.h
+++ b/drivers/net/wireless/ath/ath11k/pci.h
@@ -55,6 +55,7 @@
 
 enum ath11k_pci_flags {
 	ATH11K_PCI_ASPM_RESTORE,
+	ATH11K_PCI_MHI_PREPARED,
 };
 
 struct ath11k_pci {
-- 
2.51.0

