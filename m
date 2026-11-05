Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793916057;
	b=PaQXxSC2H+G2lYkmOccz1fuDUdbI+nygeRuzVsYin2H3J51wbuGzmJrhZfgd7SSNLBsw
	 9zwYORN8aTzFT+rIteN6E1eR7sa+B2cJm82ZjXRUT2Pqq8OMos25nUDiLv1heeoLHUz1Q
	 Gv7zggZIRPkhWLiykRhlBb8EaiJK4L2UGU7VjJKFurnPE2ftK7fASH/mWQqt+OcDktwGP
	 9h86JgptIlERfSPoG2UH+bzMWlqjIOS7s5ENszzzfzHmI0BBTll5vXBwnLv/MUrd/fAAB
	 +nfBjxqRsoZKSxjIbSPuQg0VjzHnPNNWScuQc7v0+ws+fBL69G68KT3uFE6cFmaq1ZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793916057;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=7JEnT0whAk4GTsqtOJMLoD+zA06WiG1bCm/NekxzR6k=;
	b=iQ5KiffvbgqHirsG83a48vEUcQ+F9H9dO4jIw0UdTsOgYys9s5rTPkXa5oIKkml79KMn
	 x+UlTxs/Z4ZDMqwz4YskbJrYaPQCeFEd325kbYoYKAxaNHhan67WVm2PB8Et9H51MP9I/
	 3QHS2q8Cfyq/I6gGEr8bGI5sHHl+gzEXcapeivQU4MFKPCjLwjoBgBx8+FseZdmUwQK+Z
	 UcxlF+qRcLh4bp55bwCgwXqIJtxy7Eoi+Vm7RLYkCcq9WBXlnAPL12iiRxnl9tfIEf2Wt
	 WhtYhm0N8bw+D7s1utFCizR3G2qUTzap+qFk2lV44B2bxE2UXrzd+GpQxOvUph1uCVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kEqGXBYg;
	arc=none smtp.remote-ip=209.85.221.45
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9D0606A329
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 22:00:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1B9D0606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kEqGXBYg
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48e4831c028so44888f8f.0
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 14:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793916055; x=1794520855; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7JEnT0whAk4GTsqtOJMLoD+zA06WiG1bCm/NekxzR6k=;
        b=kEqGXBYgpnUK6qIjrIyxN1lwtzrps2WlBIKNoXwQ/30yLrcGVAYyamHWDSYReJC9wH
         gVvrXFugQgWuEHVuakKBHBeV5YZM544f4WBnaBGC5zLozRbjVrjqcF2/W+KhIpUme74q
         4dk1y/lFD/lx5G9qSZK0qG3pTkhYZTP9/OBdHdZu6rntucGdYi6N1MwMb7R2wemfTvor
         0HT9pomgQf0bxCSOu3Da2VcljVqdiPPTJ2YTHzVaBvwilxNbPjXh8nS1un14EafQCIH0
         ILn9TxQFcTnoqtmOYXNrX6Ki43T32h0pJaAjrQ0c7YEnrNxU8eCas6coKdQRgg3NDjSB
         7VvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793916055; x=1794520855;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7JEnT0whAk4GTsqtOJMLoD+zA06WiG1bCm/NekxzR6k=;
        b=1fHXnRLx6itW4YgFgkfWgzMUtPwxNcm0wONnQHAEPbHRwrxZX0cxM30Ss/rfoqT/t+
         f3WtXKGA4Pp6ecFYY4UAEhVV8N+gBFrCn7WQprH+PMewY4+8ynSvmtoQDAXUR0Vh0kQB
         qQ69MYC4KopYVYG07Pev9P3FYwPDCPxSS6P1vsPBc7bQ9a/2XbT3lrAX84bqq9ke0AJK
         xcY19wKtx0diS57cPOWniziRgT+15M2hw4Me24bo90wGvJwqirnGJiWJ1bfBudKE/Hel
         OrG2X1B93895f33qyicaSfTbFHAas/CiSWc5GM/ipvAmGD46Djm/5FjSr0H3u9gVYbze
         7mKw==
X-Gm-Message-State: APuU4Z/iysk2dnYNzvozleAmTL2v8WCsR0brhU+UB/JChSjmlVr2pnxp
	IK42zGfhqqLGiSW6h1Mpatw/lvB6UCqkRBqxFoNGfBBMA5XrKmiAbB9ZzSDabAVKqc4=
X-Gm-Gg: AYBFou2M44J3NJz83zZkYK5Adrq0sTxl74O64Uuf4fIuxfTGnTlKnpq4Mw0DpRCpbcD
	VM469wiJFJcOF7zNm9tOl5Dpu0+fdmMSpBos3eNxtKgJNUD32Z7llh/6kap4Ph13uY3Z2e3NkH4
	0QaKUOUlE4yzjGYrx5yd9ZwIs4kFuM4C1dwpGKD4Q2v6Ob70MSrRyzLJvY3qrZKEiaK0Hx8rRwb
	F0Ptw8wIiupyCJoDgw+nx+5tRTEDuAqCZviOyrwHBPJYE/N7sE9lCM+FXLjDdrW1c25p1RHyaML
	I5GxfPs/NTHUpDKmUdALZdeFcUkh1lj1c7Bwn7zlRUcazhfnbwZSLbI8hr5ThlLhDpUMH6jhngE
	2/iJYI3mkIYDA7AAJDop+q6K84kxGCmOsjokwrvMxsq6eHl9iBxkQSlP+0JDTlsuv7Px894hHfV
	J+RGjQuBP/BwnhehBytd2j5uXBQsspapnmJnqSBSQKPQhZ050OWOf0vLDQ2mjIM5wZdu7pQvhTr
	QYMeoAvy0F2YAYXddSbsOUwwJR86mqov3pCQxzPO4J/yY1Xeb15udI8+f2mBpM6HrmQttsZKAgN
	f7ZEeQ054ppJsnODdVktIH009zbqEnfZGREL/ZptniJOG3OjQOEuE9zx68fnHulVXwuLzuma5t4
	Q1GKnlmfJ
X-Received: by 2002:a5d:5887:0:b0:492:880f:494e with SMTP id ffacd0b85a97d-492880f4996mr1214831f8f.40.1793916055427;
        Thu, 05 Nov 2026 14:00:55 -0800 (PST)
Received: from soeren-MS-7A32.tail37253f.ts.net ([2001:a61:13ae:e301:329c:23ff:fea4:379])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48feda203b6sm11922212f8f.48.2026.11.05.14.00.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 14:00:55 -0800 (PST)
From: Soeren Coremans <sorencoremans@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	Soeren Coremans <sorencoremans@gmail.com>
Subject: [PATCH wireless-next 3/3] wifi: brcmfmac: pcie: recover from fatal PCIe errors
Date: Thu,  5 Nov 2026 22:59:54 +0100
Message-ID: <20261105215954.184290-4-sorencoremans@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105215954.184290-1-sorencoremans@gmail.com>
References: <20261105215954.184290-1-sorencoremans@gmail.com>
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

brcmfmac registers no pci_error_handlers, so a fatal AER error leaves
the device dead until reboot ("AER: can't recover (no error_detected
callback)"). On a BCM4366 this happens after some firmware traps: the
trap starts a driver reset, and about 0.7 s later the downstream port
reports an FCP error.

Add error handlers:

- error_detected: mark the bus down, block the driver's own reset work
  and request a link reset.
- slot_reset: restore the config space saved at probe, then check that
  the backplane answers; a wedged card would stall the CPU on every
  MMIO read during firmware download.
- resume: re-probe the device from a work item. The link reset returns
  the chip to its power-on state, which brcmf_pcie_reset() does not
  fully re-initialise: after it, association failed in 5 of 9 runs,
  while 16 of 16 re-probes recovered.

A dongle setup that fails while recovery is in progress no longer
releases the driver, as that would race with the re-probe.

Tested with aer_inject (FCP on the downstream port), alone and 0.3 s
after a debugfs-triggered reset: WiFi back within 6-12 s in 16 of 16
runs, on a BCM4366/4 (14e4:43c3) with a kernel built from the
Ubuntu 7.0.0-42 source, which is based on v7.0.14.

Also tested against real FCP errors, without injection: resets under WiFi
traffic caused 3 in 47 runs, and all 3 recovered within 4-11 s.

This relies on the console read fix earlier in this series: without it,
a reset that is already running on the dead device never finishes, and
error_detected() waits for it forever.

Found and written with the help of an AI coding assistant (Claude Opus
5.5); the cover letter describes how.

Signed-off-by: Soeren Coremans <sorencoremans@gmail.com>
---
 .../broadcom/brcm80211/brcmfmac/pcie.c        | 128 +++++++++++++++++-
 1 file changed, 127 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 5abc85013110..9c23e5b83b73 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -344,6 +344,7 @@ struct brcmf_otp_params {
 struct brcmf_pciedev_info {
 	enum brcmf_pcie_state state;
 	resource_size_t tcm_size;
+	bool in_pci_recovery;
 	bool in_irq;
 	struct pci_dev *pdev;
 	char fw_name[BRCMF_FW_NAME_LEN];
@@ -2137,6 +2138,7 @@ static int brcmf_pcie_get_resource(struct brcmf_pciedev_info *devinfo)
 	}
 
 	pci_set_master(pdev);
+	pci_save_state(pdev);
 
 	/* Bar-0 mapped address */
 	bar0_addr = pci_resource_start(pdev, 0);
@@ -2598,6 +2600,11 @@ static void brcmf_pcie_setup(struct device *dev, int ret,
 
 fail:
 	brcmf_err(bus, "Dongle setup failed\n");
+	/* PCIe error recovery is in progress and re-probes the device once
+	 * the link is back; releasing the driver here would race with it.
+	 */
+	if (READ_ONCE(devinfo->in_pci_recovery))
+		return;
 	brcmf_pcie_bus_console_read(devinfo, true);
 	brcmf_fw_crashed(dev);
 	device_release_driver(dev);
@@ -3153,11 +3160,117 @@ static const struct pci_device_id brcmf_pcie_devid_table[] = {
 MODULE_DEVICE_TABLE(pci, brcmf_pcie_devid_table);
 
 
+static pci_ers_result_t brcmf_pcie_error_detected(struct pci_dev *pdev,
+						  pci_channel_state_t state)
+{
+	struct brcmf_bus *bus = dev_get_drvdata(&pdev->dev);
+	struct brcmf_pciedev_info *devinfo;
+
+	if (!bus)
+		return PCI_ERS_RESULT_DISCONNECT;
+	if (state == pci_channel_io_perm_failure)
+		return PCI_ERS_RESULT_DISCONNECT;
+	if (state == pci_channel_io_normal)
+		return PCI_ERS_RESULT_CAN_RECOVER;
+
+	devinfo = bus->bus_priv.pcie->devinfo;
+	brcmf_err(bus, "PCIe link frozen, resetting\n");
+	WRITE_ONCE(devinfo->in_pci_recovery, true);
+	devinfo->state = BRCMFMAC_PCIE_STATE_DOWN;
+	brcmf_bus_cancel_reset_work(bus);
+
+	return PCI_ERS_RESULT_NEED_RESET;
+}
+
+static pci_ers_result_t brcmf_pcie_slot_reset(struct pci_dev *pdev)
+{
+	struct brcmf_bus *bus = dev_get_drvdata(&pdev->dev);
+	struct brcmf_pciedev_info *devinfo;
+	u16 vendor;
+
+	if (!bus)
+		return PCI_ERS_RESULT_DISCONNECT;
+	devinfo = bus->bus_priv.pcie->devinfo;
+
+	pci_restore_state(pdev);
+	pci_save_state(pdev);
+	pci_set_master(pdev);
+
+	pci_read_config_word(pdev, PCI_VENDOR_ID, &vendor);
+	if (vendor != pdev->vendor)
+		return PCI_ERS_RESULT_DISCONNECT;
+
+	/* Config space can answer while the backplane is wedged; reloading
+	 * firmware into such a card stalls the CPU on every MMIO read.
+	 */
+	if (devinfo->ci) {
+		u32 chipid;
+
+		brcmf_pcie_select_core(devinfo, BCMA_CORE_CHIPCOMMON);
+		chipid = READCC32(devinfo, chipid);
+		brcmf_pcie_select_core(devinfo, BCMA_CORE_PCIE2);
+		if (chipid == 0xffffffff) {
+			brcmf_err(bus, "card not responding after link reset\n");
+			return PCI_ERS_RESULT_DISCONNECT;
+		}
+	}
+
+	return PCI_ERS_RESULT_RECOVERED;
+}
+
+static struct workqueue_struct *brcmf_pcie_err_wq;
+
+struct brcmf_pcie_reprobe {
+	struct work_struct work;
+	struct pci_dev *pdev;
+};
+
+static void brcmf_pcie_reprobe_worker(struct work_struct *work)
+{
+	struct brcmf_pcie_reprobe *rp =
+		container_of(work, struct brcmf_pcie_reprobe, work);
+	int err;
+
+	err = device_reprobe(&rp->pdev->dev);
+	if (err)
+		pci_err(rp->pdev, "re-probe after PCIe error failed: %d\n", err);
+	pci_dev_put(rp->pdev);
+	kfree(rp);
+}
+
+/* A link reset returns the chip to its power-on state, which only a full
+ * probe initialises correctly. The re-probe frees all driver data, so it
+ * runs from a work item that holds nothing but the PCI device.
+ */
+static void brcmf_pcie_resume_from_error(struct pci_dev *pdev)
+{
+	struct brcmf_bus *bus = dev_get_drvdata(&pdev->dev);
+	struct brcmf_pcie_reprobe *rp;
+
+	if (!bus || !READ_ONCE(bus->bus_priv.pcie->devinfo->in_pci_recovery))
+		return;
+
+	rp = kzalloc_obj(*rp);
+	if (!rp)
+		return;
+	brcmf_err(bus, "PCIe link recovered, re-probing\n");
+	INIT_WORK(&rp->work, brcmf_pcie_reprobe_worker);
+	rp->pdev = pci_dev_get(pdev);
+	queue_work(brcmf_pcie_err_wq, &rp->work);
+}
+
+static const struct pci_error_handlers brcmf_pcie_err_handler = {
+	.error_detected = brcmf_pcie_error_detected,
+	.slot_reset = brcmf_pcie_slot_reset,
+	.resume = brcmf_pcie_resume_from_error,
+};
+
 static struct pci_driver brcmf_pciedrvr = {
 	.name = KBUILD_MODNAME,
 	.id_table = brcmf_pcie_devid_table,
 	.probe = brcmf_pcie_probe,
 	.remove = brcmf_pcie_remove,
+	.err_handler = &brcmf_pcie_err_handler,
 #ifdef CONFIG_PM
 	.driver.pm = &brcmf_pciedrvr_pm,
 #endif
@@ -3167,8 +3280,17 @@ static struct pci_driver brcmf_pciedrvr = {
 
 int brcmf_pcie_register(void)
 {
+	int err;
+
 	brcmf_dbg(PCIE, "Enter\n");
-	return pci_register_driver(&brcmf_pciedrvr);
+	brcmf_pcie_err_wq = alloc_workqueue("brcmf_pcie_err", 0, 0);
+	if (!brcmf_pcie_err_wq)
+		return -ENOMEM;
+
+	err = pci_register_driver(&brcmf_pciedrvr);
+	if (err)
+		destroy_workqueue(brcmf_pcie_err_wq);
+	return err;
 }
 
 
@@ -3176,4 +3298,8 @@ void brcmf_pcie_exit(void)
 {
 	brcmf_dbg(PCIE, "Enter\n");
 	pci_unregister_driver(&brcmf_pciedrvr);
+	/* Unregistered first so no new re-probe can be queued; this drains
+	 * a pending one before the module text goes away.
+	 */
+	destroy_workqueue(brcmf_pcie_err_wq);
 }
-- 
2.53.0

