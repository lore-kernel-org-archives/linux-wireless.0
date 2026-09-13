Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A938E381E8C
	for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2026 21:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789334100; cv=none; b=N/V7HpvVBJgBa86z9FZaFnC0BDNK2w0s5Sztxo0nc3jl4BEI7MOTTZfVh49AHDq/rAikaMzzNq9QER/MjsUwVrDMfQ8BAhdjWxll+Ii1GXAf5m7BXGEwdnCtaOAW790RSWa6mZlWQ+Qy8eFmLc1IoEHZtHCebDvZDC8FT4NiOxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789334100; c=relaxed/simple;
	bh=5S57brZfntbokW9yTQaFkoIeQdSWtkXxT58VdRueKIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RHKUHVK2WG3mX75XlWSr5fKefnPSyD/Mm5uKJpTBh3NTiE1nKTrJ/50VyaonlZo4BdgyovF24FpSflHzefcWp/G86EmoxI+em7DihFx3C3/95opJPqNOMc6Tj920NaeCfMYl3CMKHVx39mGZ/HcHOyscvHU6acKXss0fttE0WV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g6u/Pz1X; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g6u/Pz1X"
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-39931869b4aso253514a91.1
        for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2026 14:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789334098; x=1789938898; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fqLh4xRNfrCxzg7nLdBNnTgwKu4FgQn3bI9T5uhw144=;
        b=g6u/Pz1XV7z5x31+Q0SGk6ZtiyCQKPFj7+8cLG3xhHcpNkHhxmd7XFnsG82qDVpkzF
         PpEYYa3sTQeZBx5ugWGhjwwt/Pr4MZXXQqnzRBWoA8y6cFdvKBKf6hmIY7x0PwfEJb6b
         vE/lpe5DXDnncxSNm27WXp+v2FLC4I2O7Xv6tNK0MwwodB/P4tnFOZRgm2Z4MncGdx4Q
         +KFZd6xWoK1xhBGSeT/WeQgyV0YvqLToNOt2QzaDHnHXL7lrhWRMK+evLxjGvkraYpOV
         tsAJjAJvrn1ubOeXDS6J/IyrfgTTdMRZSrHaPU7veVrSxU3S5MTePiHt0KYJRlOtQIa9
         iLRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789334098; x=1789938898;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fqLh4xRNfrCxzg7nLdBNnTgwKu4FgQn3bI9T5uhw144=;
        b=VMjzFNvtAq/7PB62nZiJamx1gPqZ61triWj0aRNSnlLEkx7KYoplkX2u3F6w5MQ01x
         WuZre7JLyXe4qSZ1IzQZIZtD9DV/Fc5t3oeEsYm0SM9MdZa96x9HByyePr2J/8gQ5p6N
         4z/xdYyiAmXMx/F/N0v4DSrV6Echku7XFuu7XxusR8R1iJ/K39KkfHY1c/6l88KYZWck
         2tJKaOxq+oViaWP/F6NOBcfHHely4ZKJBv+sTnH0L1rSonrWKtbQXeuHS+06wjfhls+u
         02W983oa6f5jII8SVH337r1EFt1CUxEOaCqhlG/rAssC9PS5rSdWR4kW97jk9C4iYQjD
         fwzQ==
X-Forwarded-Encrypted: i=1; AKwUvBxzA63bBT9Slweyh1esu3US63m94jdTImo4H5VD2FyClAWu3sxlbPNqNyr/88Xq7KvCLWajcDlu7HT5fMRVQw==@vger.kernel.org
X-Gm-Message-State: AFuF++l1e1lu0A/G6xuuMybScqHQaPRfuVuQstnrteNjWCMZ7xPYMVuy
	TiiI5WEbFhThoCzF5wwGdF4KaYiIb8wjkTjXWWMNuxUfLy+S9V4Ze0mV
X-Gm-Gg: AYBFou0LvcdFsW9jHlen9aSzdhKOuHL5L9aeHSq3O6nXarrFxke1U4UcvIpNqx9AYsm
	GybOzODzVSsFiWvht/ryjJacQi5wKxSj8NxycA8ru9wPCat0lwCgOWM+QWH6wBue6+9ROjAke7Q
	5mHq8p+aGEiWhAJyGJqEf80DdptETUheDZ2zsUtm7Fxdyvk28kcdRzeGMVcZEMBc4stXSde1mi8
	+O427xIo9AXjwkvYn5YJuqv0usBSO4k92Vn/GwSCbUc3BokaWIk5Mo6q6m1OV3hu+EWcATTgJ92
	G9+FrlOqS3ZnJLGGMDM16udheKnCLF4lDmia5U3iC1ZcIrVpV4PwqZjg/4to+bboHRyjcedGP0L
	xy/Ak8tuprRuQL25u/7+3G0yvnVd0ImPVH9eBPDF57kjH8iSMZnPU1z0DM1Js+RTSvx+80DLg5+
	Ja7mJ5C0OP7Q3G5PV+sXS29tapsaCxTuOdg+08ApSlM9X/k/DEipdwlf/o1HytxD7Sr4NiX38uC
	+54UlI47yuZXQrO7jHPJpt16VTRSC0FnqqLTgFIQd9EVdRlNwgOBP/3WIGEG/61l/gSRG+t/hJt
	FUHojlnXe4NETATuRWfj
X-Received: by 2002:a17:90b:3d92:b0:398:bac0:238e with SMTP id 98e67ed59e1d1-39d9c3bc1demr17614375a91.6.1789334097976;
        Sun, 13 Sep 2026 14:14:57 -0700 (PDT)
Received: from cachyos-aura ([45.112.148.109])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14365b348cbsm21382925c88.3.2026.09.13.14.14.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 14:14:57 -0700 (PDT)
From: Navon John Lukose <navonjohnlukose@gmail.com>
To: miriam.rachel.korenblit@intel.com,
	linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	helgaas@kernel.org,
	ilpo.jarvinen@linux.intel.com,
	emmanuel.grumbach@intel.com,
	nika@nikableh.moe,
	mpearson-lenovo@squebb.ca,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Navon John Lukose <navonjohnlukose@gmail.com>,
	stable+noautosel@kernel.org
Subject: [PATCH wireless v3 4/4] wifi: iwlwifi: pcie: recover a device that lost power in D3cold
Date: Mon, 14 Sep 2026 02:44:28 +0530
Message-ID: <87d0a74f482d9dbd6fc529eee86ebfa2c3025cf5.1789333511.git.navonjohnlukose@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1789333511.git.navonjohnlukose@gmail.com>
References: <cover.1789333511.git.navonjohnlukose@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On some boards D3cold cuts a discrete module's power rail and the device
never comes back. The link does not train and config space reads all ones
until reboot.

The product reset the driver already implements recovers it, but the vendor
DSM that selects the product reset mode reads the device's PCI ID out of
config space first, so it can only be armed while the device still answers.
iwl_trans_pcie_removal_wk(), the only place that arms it, is too late.

Arm it in .suspend and disarm in .resume. If the disarm fails and
CSR_HW_REV reads all ones, run the product reset. Skip integrated CNVi,
whose DSM takes an AML path I cannot test. The DSM failure log drops to
debug, since .suspend would otherwise hit it on every suspend on boards
without the DSM.

Cc: stable+noautosel@kernel.org # new suspend/resume behaviour, one machine
Link: https://bugzilla.kernel.org/show_bug.cgi?id=221695
Link: https://lore.kernel.org/all/20260722021321.68902-1-nika@nikableh.moe/
Link: https://lore.kernel.org/all/20260829093922.37103-1-navonjohnlukose@gmail.com/
Signed-off-by: Navon John Lukose <navonjohnlukose@gmail.com>
---
The bugzilla and the first lore Link: are other BE200/GL reports of the
same 0xffffffff-until-reboot, on machines I do not have. The second is my
own analysis of this machine's AML.

Lenovo Yoga Pro 7 14IAH10 (Arrow Lake-H, Core Ultra 9 285H), BIOS
QGCN35WW, discrete BE200 SUBSYS_00F48086, Bluetooth on USB, no CSME,
stock ACPI tables.

Before the patch s2idle left the device dead until reboot. With it the
device comes back, both with wifi connected at suspend and with the radio
down, the case where .suspend runs with no op_mode. Skipping just the
_RST call and leaving the remove and rescan in place left it absent.

With debug=0x100 one cycle logs the intended path end to end:

    iwl_trans_pcie_set_product_reset Enabled product reset via DSM
    iwl_trans_pcie_check_product_reset_mode product reset mode is 0x1
    iwl_trans_pcie_set_product_reset can't disable product reset via DSM (-ENODEV)
    device not responding after resume
    scheduling reset (mode=6)
    iwl_trans_pcie_set_product_reset can't enable product reset via DSM (-ENODEV)
    iwl_trans_pcie_call_reset called _RST on _PRR object
    iwl_trans_pcie_set_product_reset Disabled product reset via DSM

mode=6 is IWL_RESET_MODE_PROD_RESET, so the request was not downgraded,
and the last line is the probe deselect patch 3 adds. Wifi is usable about
5 s after .resume returns, 7 s end to end: 4.4 s of that is the platform's
_RST and ~2 s is the PCI core retrying the link before .resume runs.

What is untested or untestable with one machine:

- .suspend and .resume are untouched on integrated/CNVi, where the arming
  helper returns early and prod_reset_set is never set. Getting the CNVi
  case working needs someone with the hardware.
- This box has no CSME, so the ME path is untested. Where me_present is
  non-zero the request is downgraded to IWL_RESET_MODE_FUNC_RESET, but the
  device should still come back, since the mode is already armed and _RST
  does the product reset regardless. Bluetooth is not torn down first,
  which is the pre-existing hazard the previous patch describes.
- The failure looks specific to s2idle. One real hibernate cycle armed the
  mode in .freeze and cleared it again on restore, both confirmed by the
  DSM readback, and the device came back without needing the reset at all.
  Hibernate cold-boots to resume, so the part gets a genuine power-on
  reset, where s2idle cuts the rail and leaves it wedged.
- A device that dies at runtime is still unrecoverable. That needs the same
  thing hooked to runtime PM, which iwlwifi does not implement.

 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 24 ++++++++++++++++++
 .../intel/iwlwifi/pcie/gen1_2/internal.h      |  4 +++
 .../intel/iwlwifi/pcie/gen1_2/trans.c         | 25 ++++++++++++++-----
 3 files changed, 47 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index a3e6c9e..96fb7fc 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -1204,11 +1204,19 @@ static void iwl_pci_remove(struct pci_dev *pdev)
 
 static int iwl_pci_suspend(struct device *device)
 {
+	struct iwl_trans *trans = pci_get_drvdata(to_pci_dev(device));
+
 	/* Before you put code here, think about WoWLAN. You cannot check here
 	 * whether WoWLAN is enabled or not, and your code will run even if
 	 * WoWLAN is enabled - don't kill the NIC, someone may need it in Sx.
 	 */
 
+	/* Arming has to happen while the device still answers, because the
+	 * AML gates this DSM on reading the device's PCI ID out of config
+	 * space. It does not touch the NIC.
+	 */
+	iwl_trans_pcie_arm_product_reset(trans, true);
+
 	return 0;
 }
 
@@ -1230,6 +1238,22 @@ static int _iwl_pci_resume(struct device *device, bool restore)
 	 */
 	pci_write_config_byte(pdev, PCI_CFG_RETRY_TIMEOUT, 0x00);
 
+	/* Two signals that the device didn't come back from D3cold: the
+	 * platform can't deselect the mode armed in .suspend (so it can't see
+	 * the device either), and the device doesn't answer. This runs before
+	 * the op_mode test because the firmware may never have been loaded.
+	 */
+	if (trans_pcie->prod_reset_set) {
+		iwl_trans_pcie_arm_product_reset(trans, false);
+		if (trans_pcie->prod_reset_set &&
+		    PCI_POSSIBLE_ERROR(iwl_read32(trans, CSR_HW_REV))) {
+			IWL_ERR(trans, "device not responding after resume\n");
+			iwl_trans_pcie_reset(trans, IWL_RESET_MODE_PROD_RESET);
+			return 0;
+		}
+		trans_pcie->prod_reset_set = false;
+	}
+
 	if (!trans->op_mode)
 		return 0;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/internal.h
index d84c7c1..1caaff9 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/internal.h
@@ -495,6 +495,8 @@ struct iwl_pcie_txqs {
  * @isr_stats: interrupt statistics
  * @napi_dev: (fake) netdev for NAPI registration
  * @txqs: transport tx queues data.
+ * @prod_reset_set: the product reset mode is selected in the platform;
+ *	system suspend/resume only, so process context only
  * @me_present: WiAMT/CSME is detected as present (1), not present (0)
  *	or unknown (-1, so can still use it as a boolean safely)
  * @me_recheck_wk: worker to recheck WiAMT/CSME presence
@@ -605,6 +607,7 @@ struct iwl_trans_pcie {
 
 	struct iwl_pcie_txqs txqs;
 
+	bool prod_reset_set;
 	s8 me_present;
 	struct delayed_work me_recheck_wk;
 
@@ -657,6 +660,7 @@ bool _iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans, bool silent);
 
 void iwl_trans_pcie_check_product_reset_status(struct pci_dev *pdev);
 void iwl_trans_pcie_check_product_reset_mode(struct pci_dev *pdev);
+void iwl_trans_pcie_arm_product_reset(struct iwl_trans *trans, bool arm);
 
 /*****************************************************
 * RX
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
index d93d8f9..a764c6d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
 #include <linux/pci.h>
+#include <linux/string_choices.h>
 #include <linux/interrupt.h>
 #include <linux/debugfs.h>
 #include <linux/sched.h>
@@ -2075,7 +2076,7 @@ void iwl_trans_pcie_check_product_reset_mode(struct pci_dev *pdev)
 	ACPI_FREE(res);
 }
 
-static void iwl_trans_pcie_set_product_reset(struct pci_dev *pdev, bool enable,
+static bool iwl_trans_pcie_set_product_reset(struct pci_dev *pdev, bool enable,
 					     bool integrated)
 {
 	union acpi_object *res;
@@ -2089,17 +2090,29 @@ static void iwl_trans_pcie_set_product_reset(struct pci_dev *pdev, bool enable,
 						 DSM_INTERNAL_PLDR_CMD_SET_MODE,
 						 mode);
 	if (IS_ERR(res)) {
-		if (enable)
-			IWL_ERR_DEV(&pdev->dev,
-				    "ACPI _DSM not available (%d), cannot do product reset\n",
-				    (int)PTR_ERR(res));
-		return;
+		IWL_DEBUG_DEV_POWER(&pdev->dev,
+				    "can't %s product reset via DSM (%pe)\n",
+				    str_enable_disable(enable), res);
+		return false;
 	}
 
 	ACPI_FREE(res);
 	IWL_DEBUG_DEV_POWER(&pdev->dev, "%sabled product reset via DSM\n",
 			    enable ? "En" : "Dis");
 	iwl_trans_pcie_check_product_reset_mode(pdev);
+	return true;
+}
+
+void iwl_trans_pcie_arm_product_reset(struct iwl_trans *trans, bool arm)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	/* discrete only: the integrated arming mask is untested */
+	if (trans->mac_cfg->integrated)
+		return;
+
+	if (iwl_trans_pcie_set_product_reset(trans_pcie->pci_dev, arm, false))
+		trans_pcie->prod_reset_set = arm;
 }
 
 void iwl_trans_pcie_check_product_reset_status(struct pci_dev *pdev)
