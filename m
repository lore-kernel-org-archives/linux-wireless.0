Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2BA383300
	for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2026 21:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789334078; cv=none; b=QFF5u5SwUzYnaAKRGlDynTuSNO0h8LaYqNqDu4XyjZY1QyDtaPuplY6iWUmgbyojJ4e0LV0v+yFYPKSmoANNfHQVH8YP1EKPQmk4qAqhcJKejMVrhxrzhES8ODnr8KwhJkrZt/NTCUEX5fYRz0X7+8lojBjxwbA1a3BEDPlLDV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789334078; c=relaxed/simple;
	bh=dN1AB3YBIJUtyX/kbzrKm4MNplmeO5MjCCC+1TPpojA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BgqiWhzC7yYyHK25C2ZXyLoCpIQJ8CyGJG8TdFcTzo4YoCSpjMX6HHT/F09jYz/2UXk3fZKlBYaDchFPM1bCnXz8DzPCnZ0dKA7V/MayZozcYKPDbheAkNt4Bkix6CwB9DBhdv31hl5AfEhOPp9Q/8m+wi2k8G80he+zEDl5zyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pEkN6FUx; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pEkN6FUx"
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d6ff23d82eso1892685ad.3
        for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2026 14:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789334076; x=1789938876; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=sRqVz0u1manoSVxe8L38jItuWm21BczAEf0Q7tyCyHA=;
        b=pEkN6FUx6t9zfr0a5jkQ/fC6upzB5U4v3nBzEPvIOgOxVoXKSBP0++Fib09/Y/Blm8
         uuYvoqouCzLBzl1DjZYZ/VQ6fKlTLiG/S9uor4E5iPg+0lN9z4zEQ300xzw7G8iebf0Q
         osJ+AMaPxFOspp2LsiwSYZLsMnwMsx71MD5PczGpqK04f4D8YR+ublrWihAZI8nv+q72
         ldJo1LVX2LmfiEw6tnwVES0gZuQbpxrme1k0Lxj4KHGpbaKY1xajHssmS1L3HaYqi4RD
         GdIAhk/2rJEYDN/3Qetzy/bKNz3nh0TaPfXgvE+OHgZuT+V+ALNxokrceq4ZTn2CVAcu
         Fjgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789334076; x=1789938876;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sRqVz0u1manoSVxe8L38jItuWm21BczAEf0Q7tyCyHA=;
        b=StDBQW5OZMC9rl5TOOoSD1vevj28niQQnTBba9dWlG2YRZqBQLJgcxX8yi4ZGTr+QR
         OHkzbNxbhLnnEVvrLXVRd033P3S42aikFr5GA8r/ihS1z4C19jlThYxXCvwU+y5mIZUw
         90U5ES9+KUSsxqNHlRpeB2N+goezKFC2RuVItHVusma4X5aMH9lgt9HibqnEUfOzb7ha
         xLWxSRalkkZkuelMa/FHXU5RGUHaWMOeZ/eYex7Dvy+auJ2VXb/ODWyTY3lu3tF9XVwQ
         c18nn9UAha+a69k5FAepgsYOOmduvxSqFOPgAMd/hz6EGiC13TjTeOfCzoWkMJMZtyDi
         Qbrg==
X-Forwarded-Encrypted: i=1; AKwUvBzdx6JXqSa98QFnB3GQN/EjhCBuVsMBJVieByPkW3sdTmc5pnLGtNGgbz70djGgz6C1MPrqraNn2sMdmZimtQ==@vger.kernel.org
X-Gm-Message-State: AFuF++nFREcUsJqhXWWM0uog0eM9pLHUgE09x56Qu/+jF8Jfh8piG1S8
	hhpVYu2Y5dzXa3Rl9oARdfhcqlLN3FD+060OPY/bcmA1mHLtk8bt/W2Z
X-Gm-Gg: AYBFou2kWED8LyFAHJui+ldgcdyQ/SC2edx5sqsONi14soSXgEgzWltKVNOaoYjEb6Q
	TZhqvFzPWgT7teX7xMzkMTG7Gsf0jNJlt4Y6BEwS6P7I7bojnMLXqdldRDCYtSQ88j2dU7AgEGd
	y+ubWLzB8rM1t3Hc4c0mJg+NcAuPJStwuw2FoDCqFL+lGkLy+L2UQlJ+0+Y6boEx6kNHVLkDMjB
	WC1oArWolsbXtIRFRBVAsqSonaxo12pkhne9JRNENiRW0pUfvmXRfQIxPW65fvWAw7HdAKm7t4S
	EbkYaNqS4hAveMNCsEUAwpaOWMag0tzlDWing2bznj4vC5zJkA0rr4E5ecAwQUQhB9nIKswwFXy
	amyxhQA01fkvtwbmuyp4hfl24prcZ3YvDMR19htXOMT2znmPMZkNtMBLqzhPosomecB+HP9JfCi
	eux5UXhyVtwDbGrrFFpEpJwNUgWMyG7XXLwW4KLMBeM40NIv4NeIgCIWeuECK5vol4ccqPzQ9t5
	byM18nY6UBM1SDbmiIW0ny702cFvb5OWQ8Vvzvi8kUhzcGpmKz6iJq8hulirBqso6k7O/wWkLfX
	hfsDfG07qVE03vLCNZzV
X-Received: by 2002:a17:90b:3904:b0:396:d27c:8696 with SMTP id 98e67ed59e1d1-39d9c392a75mr16748496a91.4.1789334076162;
        Sun, 13 Sep 2026 14:14:36 -0700 (PDT)
Received: from cachyos-aura ([45.112.148.109])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14365b348cbsm21382925c88.3.2026.09.13.14.14.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 14:14:35 -0700 (PDT)
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
	Navon John Lukose <navonjohnlukose@gmail.com>
Subject: [PATCH wireless v3 0/4] wifi: iwlwifi: recover the BE200 after D3cold removes its power
Date: Mon, 14 Sep 2026 02:44:24 +0530
Message-ID: <cover.1789333511.git.navonjohnlukose@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On a Lenovo Yoga Pro 7 14IAH10 the Intel Wi-Fi 7 BE200 (8086:272b) does not
survive D3cold. _PR3 removes the M.2 module's rail, and when the rail and
PERST# come back the card never restarts. The link does not train and
config space reads 0xffffffff until reboot.

Nothing here is BE200-specific. Patch 4's arming is gated on !integrated,
and the AML gate on this board also accepts 0x2526/0x271b (9000 series),
0x2723 (AX200) and 0x2725 (AX210). BE200 is the only one I have and the
only one I tested.

  Patch 1  cancel the ME recheck work on the probe error path.
  Patch 2  stop inferring CSME presence from a read that never landed.
  Patch 3  deselect the product reset mode at probe.
  Patch 4  arm the mode in .suspend, disarm in .resume, and reset when the
           disarm fails and the device reads all ones.

+60/-10. Patches 1 to 3 carry Fixes: and Cc: stable. Patch 4 has no Fixes:
and is Cc: stable+noautosel, because the device dying in D3cold is not a
regression from any commit. The driver simply never handled it.

The DMI quirk patch 4 Links to disables D3cold on the affected machines,
which keeps the module's rail up for every runtime idle from then on. This
keeps D3cold and pays ~7 s on the resumes that fail. Patches 1 to 3 stand
alone if you would rather take the quirk.

Tested on one machine, one BIOS, discrete only, with s2idle and hibernate.
s2idle was broken before this and is fixed now. Hibernate was never broken
and still works with the arming in .freeze. Methodology and the untested
surface are under the --- of patch 4.

Since v2:
https://lore.kernel.org/all/20260831130332.323549-1-navonjohnlukose@gmail.com/

- The ME recheck cancel, sent on its own before, is folded in as patch 1 so
  patch 2 does not widen the use-after-free it closes.
- Bjorn: the new tests use PCI_POSSIBLE_ERROR().
- Ilpo: str_enable_disable(). The same line now prints the error with %pe.

v1: https://lore.kernel.org/all/20260829095437.44716-1-navonjohnlukose@gmail.com/

Signed-off-by: Navon John Lukose <navonjohnlukose@gmail.com>

Navon John Lukose (4):
  wifi: iwlwifi: pcie: cancel the ME recheck work on probe failure
  wifi: iwlwifi: pcie: don't infer CSME presence from a failed read
  wifi: iwlwifi: pcie: deselect the product reset mode at probe
  wifi: iwlwifi: pcie: recover a device that lost power in D3cold

 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 24 +++++++++++
 .../intel/iwlwifi/pcie/gen1_2/internal.h      |  4 ++
 .../intel/iwlwifi/pcie/gen1_2/trans.c         | 42 ++++++++++++++-----
 3 files changed, 60 insertions(+), 10 deletions(-)

Interdiff against v2:

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 5d01a4d..80d6c25 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -1245,7 +1245,7 @@ static int _iwl_pci_resume(struct device *device, bool restore)
 	if (trans_pcie->prod_reset_set) {
 		iwl_trans_pcie_arm_product_reset(trans, false);
 		if (trans_pcie->prod_reset_set &&
-		    iwl_read32(trans, CSR_HW_REV) == ~0U) {
+		    PCI_POSSIBLE_ERROR(iwl_read32(trans, CSR_HW_REV))) {
 			IWL_ERR(trans, "device not responding after resume\n");
 			iwl_trans_pcie_reset(trans, IWL_RESET_MODE_PROD_RESET);
 			return 0;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
index 56eb35d..a764c6d 100644
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
@@ -2090,8 +2091,8 @@ static bool iwl_trans_pcie_set_product_reset(struct pci_dev *pdev, bool enable,
 						 mode);
 	if (IS_ERR(res)) {
 		IWL_DEBUG_DEV_POWER(&pdev->dev,
-				    "can't %sable product reset via DSM (%d)\n",
-				    enable ? "en" : "dis", (int)PTR_ERR(res));
+				    "can't %s product reset via DSM (%pe)\n",
+				    str_enable_disable(enable), res);
 		return false;
 	}
 
@@ -4206,7 +4207,7 @@ static void iwl_pcie_recheck_me_status(struct work_struct *wk)
 	u32 val;
 
 	val = iwl_read32(trans_pcie->trans, CSR_HW_IF_CONFIG_REG);
-	if (val != ~0U)
+	if (!PCI_POSSIBLE_ERROR(val))
 		trans_pcie->me_present = !!(val & CSR_HW_IF_CONFIG_REG_IAMT_UP);
 }
 
@@ -4228,7 +4229,7 @@ static void iwl_pcie_check_me_status(struct iwl_trans *trans)
 	/* iwl_read_prph() returns 0x5a5a5a5a if it never reached the NIC, and
 	 * that value has WIAMT_KNOWN set and WIAMT_PRESENT clear
 	 */
-	if (val != ~0U && !iwl_trans_is_hw_error_value(val) &&
+	if (!PCI_POSSIBLE_ERROR(val) && !iwl_trans_is_hw_error_value(val) &&
 	    (val & CNVI_SCU_REG_FOR_ECO_1_WIAMT_KNOWN)) {
 		trans_pcie->me_present =
 			!!(val & CNVI_SCU_REG_FOR_ECO_1_WIAMT_PRESENT);
@@ -4236,8 +4237,8 @@ static void iwl_pcie_check_me_status(struct iwl_trans *trans)
 	}
 
 	val = iwl_read32(trans, CSR_HW_IF_CONFIG_REG);
-	if (val != ~0U && (val & (CSR_HW_IF_CONFIG_REG_ME_OWN |
-				  CSR_HW_IF_CONFIG_REG_IAMT_UP))) {
+	if (!PCI_POSSIBLE_ERROR(val) && (val & (CSR_HW_IF_CONFIG_REG_ME_OWN |
+					       CSR_HW_IF_CONFIG_REG_IAMT_UP))) {
 		trans_pcie->me_present = 1;
 		return;
 	}
@@ -4388,6 +4389,8 @@ int iwl_pci_gen1_2_probe(struct pci_dev *pdev,
 
 	if (IS_ERR(iwl_trans->drv)) {
 		ret = PTR_ERR(iwl_trans->drv);
+		/* iwl_pcie_check_me_status() may have armed this */
+		cancel_delayed_work_sync(&trans_pcie->me_recheck_wk);
 		goto out_free_trans;
 	}
 
