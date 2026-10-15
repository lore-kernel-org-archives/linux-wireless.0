Received: from mail-108-mta197.mxroute.com (mail-108-mta197.mxroute.com [136.175.108.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D513F9A1E
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 19:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792091655; cv=none; b=IICwRKPwuqK3zcL5NwmqYJp1GWpgRgibIS+0J+j/lM9sZYLAdeJVunqqvyByhScqLqjKoxDPvL3m01ZzqnM5i7askn6VyoyvR/t8sKi8ch6fQCwDxhuu+ZOefKNdDw1MxNwxflDlvDYYdconWPXtj4hH2RmdSGwgFIZnxgnIIQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792091655; c=relaxed/simple;
	bh=V1cateW2vlCeySqhvNeYYB7nnq2yxEfiP722wyAUBoA=;
	h=From:To:Cc:Date:Message-ID:Subject:Content-Type:MIME-Version; b=pJmv168dXm2X9hEUceKiacBQqBAFuG9z7Xn3XwIR/Lgk8wJHw5fDM7X4liLkPTp5Mb1y/UbxXv3uo2px6aNAFwsMOR/vOXSODwaPyz0X1INKmF7KoSc2QgIRmeJo7Z17e1aYH6X+w3ozzS0H57ODzeeNRjEFgbj5c0BeGiNDL/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gobeyond.pa; spf=pass smtp.mailfrom=gobeyond.pa; dkim=pass (2048-bit key) header.d=gobeyond.pa header.i=@gobeyond.pa header.b=nSix/Z01; arc=none smtp.client-ip=136.175.108.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gobeyond.pa
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gobeyond.pa
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gobeyond.pa header.i=@gobeyond.pa header.b="nSix/Z01"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta197.mxroute.com (ZoneMTA) with ESMTPSA id 1a140f7bd4e00028b2.009
 for <linux-wireless@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Thu, 15 Oct 2026 19:09:00 +0000
X-Zone-Loop: 8aff087fb5da47af5ad3e30c9b47659fb3d5248dea4f
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=gobeyond.pa
	; s=x; h=MIME-Version:Content-Transfer-Encoding:Content-Type:Subject:Date:Cc:
	To:From:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:
	References; bh=c1wxOEV7L45e84KQT9SL6c5mDvEEhGKj0pumGCGP/a4=; b=nSix/Z01BgYCCU
	vAybHUYiL3aiIXL+fEDtXM4yYaKQW0oQrltO0TPxpedJMy1ky+QWSGvWJhnpIL92mDLoD4JzelRj5
	vspcO9YUo7A0bsrTeh0kphqsRgjgCt4ZQahvljUcviq11gK9D9K1pO5e16l1Fjp7qqVFc3K8B9ddX
	aWc39KxpFAvvAUKETsjH4AaQ7JwmOWFCjVrkkC+Tn+n7nVDOcu9aKubfrT8fM4UQz2VnlaNjIia26
	0DqyhwxMZnZzppIWigPH6fVTiMAW85FpgSaWzUTr9XdVffW80of77Hth+VO3evX6ZMdOsfJ+yeY9m
	BGtjntfadiG8T7qEXcFg==;
From: Shimon <shimon@gobeyond.pa>
To: linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>,
 Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>,
 Sean Wang <sean.wang@mediatek.com>, Marcel Holtmann <marcel@holtmann.org>,
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
 linux-bluetooth@vger.kernel.org, shimon@gobeyond.pa
Date: Thu, 15 Oct 2026 14:08:33 -0500
Message-ID:
 <179209131379.1251175.8756794738527947285.mt7921-bt-pcie-rfc@gobeyond.pa>
Subject: [RFC PATCH] wifi: mt76: mt7921: add manual MT7961 Bluetooth reset
 through PCIe
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Authenticated-Id: shimon@gobeyond.pa

An MT7961 combo device can stop enumerating its Bluetooth USB function
while the Wi-Fi PCIe register interface remains accessible. On the tested
system, USB descriptor/address failures (-110/-62) persisted across a warm
reboot and USB port/controller reprobes. The btmtk USB reset path cannot
reach the device in that state.

Expose a root-write-only bt_reset debugfs operation that runs the existing
MT7961 btmtk_usb_subsys_reset() register sequence through PCIe. Require an
MMIO transport and chip ID 0x7961, hold the mt792x mutex, and return a
timeout if the reset-done bit does not arrive. A separate USB port reprobe
may still be required to enumerate Bluetooth afterwards.

Keep this an explicit diagnostic/recovery operation. It does not introduce
automatic resets or address the cause of recurring idle disconnects.

Signed-off-by: Shimon <shimon@gobeyond.pa>
---
RFC for Linux mt76 and Bluetooth maintainers; not a merge-ready fix.

Based on the mt76 branch of https://github.com/nbd168/wireless at
2e6968e9286f3573016b9f804d4945373a21c489. Patch applicability was checked against
that tree using kernel paths. No complete build of that current tree has
been performed; full module builds/linking passed with Linux 7.2.9 sources
and matching Arch 7.2.9-arch1-1 headers. Checkpatch passes for this posting.

Hardware/testing:
- MT7961 chip ID 0x7961, revision 0x8a10; PCI 14c3:0608, USB 0e8d:0608.
- Gigabyte X570S AORUS ELITE AX / AMD Matisse, BIOS F9.
- Linux 7.2.9-arch1-1, BlueZ 5.87, BT firmware build 20260224111243.
- One wedged-adapter recovery succeeded using the same register sequence
  through the existing regidx/regval interface, followed by USB reprobe.
- The new callback was tested on a healthy controller with BlueZ stopped
  and btusb unbound: input 0 returned EINVAL; input 1 completed in 0.050s;
  a USB port reprobe restored HCI enumeration and firmware setup. Wired
  access remained available. This was not a new natural-wedge recovery.
- The patched module has been installed through DKMS and remained loaded.
  After fresh mouse pairing October 12, the owner reported normal use
  through October 14. Logs showed no recurring enumeration fault or
  Bluetooth service restart in that observation period. This is evidence
  of no observed regression, not that this manual callback prevents faults.
- The manual absent-adapter helper now uses this callback without a raw
  register fallback. Six fake-sysfs tests cover the helper's guards/error
  handling; these do not validate kernel synchronization or real hardware.
  No new naturally wedged adapter has yet exercised the integrated helper.

Feedback requested:
- Is mt7921 debugfs an appropriate home for this recovery operation, or
  should it use a shared combo-device abstraction?
- What coordination with btusb/btmtk setup, suspend and reset is required?
  The mt792x mutex does not serialize those Bluetooth driver operations.
  Our wrapper refuses to run while an HCI adapter exists or Wi-Fi is in
  use, but the kernel operation itself does not enforce those conditions.
- Are additional runtime-PM/reset-state checks needed? The existing
  mt792x mutex helper requests a PM wake without propagating its result.
- Is there a supported sequence that avoids the external USB port reprobe?

This RFC and its submission text were prepared with AI assistance.

 .../wireless/mediatek/mt76/mt7921/debugfs.c   | 44 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt792x_regs.h  |  8 ++++
 2 files changed, 52 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
index 62bf333..0f98900 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
@@ -247,6 +247,48 @@ static int mt7921_chip_reset(void *data, u64 val)
 
 DEFINE_DEBUGFS_ATTRIBUTE(fops_reset, NULL, mt7921_chip_reset, "%lld\n");
 
+static int mt7921_bt_reset(void *data, u64 val)
+{
+	struct mt792x_dev *dev = data;
+	int ret = 0;
+
+	if (val != 1)
+		return -EINVAL;
+
+	if (!mt76_is_mmio(&dev->mt76))
+		return -EOPNOTSUPP;
+
+	mt792x_mutex_acquire(dev);
+	if (mt76_rr(dev, MT_HW_CHIPID) != 0x7961) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	/* Match the MT7961 sequence in btmtk_usb_subsys_reset(). PCIe can
+	 * still reach these registers when Bluetooth's USB interface is wedged.
+	 * A USB port reprobe may be needed afterwards to enumerate it again.
+	 */
+	mt76_wr(dev, MT7921_BT_EP_RST_OPT, 0x00010001);
+	mt76_rr(dev, MT7921_BT_WDT_STATUS);
+	mt76_wr(dev, MT7921_BT_SUBSYS_RST, 1);
+	mt76_wr(dev, MT7921_BT_UDMA_INT_STA, 0xff);
+	mt76_rr(dev, MT7921_BT_UDMA_INT_STA);
+	mt76_wr(dev, MT7921_BT_UDMA_INT_STA1, 0xff);
+	mt76_rr(dev, MT7921_BT_UDMA_INT_STA1);
+	msleep(20);
+	mt76_wr(dev, MT7921_BT_SUBSYS_RST, 0);
+	mt76_rr(dev, MT7921_BT_SUBSYS_RST);
+
+	if (!mt76_poll_msec(dev, MT7921_BT_MISC,
+			    MT7921_BT_RST_DONE, MT7921_BT_RST_DONE, 1000))
+		ret = -ETIMEDOUT;
+out:
+	mt792x_mutex_release(dev);
+	return ret;
+}
+
+DEFINE_DEBUGFS_ATTRIBUTE(fops_bt_reset, NULL, mt7921_bt_reset, "%lld\n");
+
 static int
 mt7921s_sched_quota_read(struct seq_file *s, void *data)
 {
@@ -284,6 +326,8 @@ int mt7921_init_debugfs(struct mt792x_dev *dev)
 	debugfs_create_file("idle-timeout", 0600, dir, dev,
 			    &fops_pm_idle_timeout);
 	debugfs_create_file("chip_reset", 0600, dir, dev, &fops_reset);
+	if (mt76_is_mmio(&dev->mt76))
+		debugfs_create_file("bt_reset", 0200, dir, dev, &fops_bt_reset);
 	debugfs_create_devm_seqfile(dev->mt76.dev, "runtime_pm_stats", dir,
 				    mt792x_pm_stats);
 	debugfs_create_file("deep-sleep", 0600, dir, dev, &fops_ds);
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_regs.h b/drivers/net/wireless/mediatek/mt76/mt792x_regs.h
index 3587f61..0e36505 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_regs.h
@@ -421,6 +421,14 @@
 #define MT_CBTOP_RGU_WF_SUBSYS_RST	MT_CBTOP_RGU(0x600)
 #define MT_CBTOP_RGU_WF_SUBSYS_RST_WF_WHOLE_PATH BIT(0)
 
+#define MT7921_BT_MISC			0x70002510
+#define MT7921_BT_RST_DONE		BIT(8)
+#define MT7921_BT_SUBSYS_RST		0x70002610
+#define MT7921_BT_UDMA_INT_STA		0x74000024
+#define MT7921_BT_UDMA_INT_STA1		0x74000308
+#define MT7921_BT_WDT_STATUS		0x740003a0
+#define MT7921_BT_EP_RST_OPT		0x74011890
+
 #define MT7925_CBTOP_RGU_WF_SUBSYS_RST	0x70028600
 #define MT7925_WFSYS_INIT_DONE_ADDR	0x184c1604
 #define MT7925_WFSYS_INIT_DONE		0x00001d1e
base-commit: 2e6968e9286f3573016b9f804d4945373a21c489
-- 
2.56.0

