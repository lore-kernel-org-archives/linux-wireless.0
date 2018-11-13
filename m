Return-Path: <SRS0=dsQx=NY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 301E0C43441
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Nov 2018 20:51:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF2D8223C8
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Nov 2018 20:51:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="t2jm58L9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BF2D8223C8
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727599AbeKNGvR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 14 Nov 2018 01:51:17 -0500
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:46518 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725748AbeKNGvR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Nov 2018 01:51:17 -0500
Received: from mail-irv-17.broadcom.com (mail-irv-17.lvn.broadcom.net [10.75.224.233])
        by rnd-relay.smtp.broadcom.com (Postfix) with ESMTP id 3151B30C0D2;
        Tue, 13 Nov 2018 12:51:22 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.10.3 rnd-relay.smtp.broadcom.com 3151B30C0D2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1542142282;
        bh=ivo4+GUqXQfVTeEB8Mte/g/xqsrpZqao7TPZ9oTEiz4=;
        h=From:To:Cc:Subject:Date:From;
        b=t2jm58L9ihxl/93N+T2HuBzxK8aNFJTl8t8mEM4BP/0QDeawd8zFSVS5mDYlZH+m8
         u8EjkZJ6B6UCgkjFK2smRlBcwEeWQTTBjPVX6eCVhhpbccnvIoNrBpwqNNzahaFVlw
         VMzSiXR0fztm6ff7/clR46aajanrpHoc07IgPksM=
Received: from bld-bun-01.bun.broadcom.com (bld-bun-01.bun.broadcom.com [10.176.128.83])
        by mail-irv-17.broadcom.com (Postfix) with ESMTP id DBAF781EBF;
        Tue, 13 Nov 2018 12:51:22 -0800 (PST)
Received: by bld-bun-01.bun.broadcom.com (Postfix, from userid 25152)
        id 617A3B02B40; Tue, 13 Nov 2018 21:51:20 +0100 (CET)
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-efi@vger.kernel.org, linux-wireless@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH] firmware: efi: add NULL pointer checks in efivars api functions
Date:   Tue, 13 Nov 2018 21:51:18 +0100
Message-Id: <1542142278-14352-1-git-send-email-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Since commit ce2e6db554fa ("brcmfmac: Add support for getting nvram
contents from EFI variables") we have a device driver accessing the
efivars api (since next-20181107). Several functions in efivars api
assume __efivars is set, ie. will be accessed after efivars_register()
has been called. However, following NULL pointer access was reported
calling efivar_entry_size() from the brcmfmac device driver.

[   14.177769] Unable to handle kernel NULL pointer dereference at
		virtual address 00000008
[   14.197303] pgd = 60bfa5f1
[   14.211842] [00000008] *pgd=00000000
[   14.227373] Internal error: Oops: 5 [#1] SMP ARM
[   14.244244] Modules linked in: brcmfmac sha256_generic sha256_arm snd cfg80211 brcmutil soundcore snd_soc_tegra30_ahub tegra_wdt
[   14.269109] CPU: 1 PID: 114 Comm: kworker/1:2 Not tainted 4.20.0-rc1-next-20181107-gd881de3 #1
[   14.269114] Hardware name: NVIDIA Tegra SoC (Flattened Device Tree)
[   14.269154] Workqueue: events request_firmware_work_func
[   14.269177] PC is at efivar_entry_size+0x28/0x90
[   14.269362] LR is at brcmf_fw_complete_request+0x3f8/0x8d4 [brcmfmac]
[   14.269369] pc : [<c0c40718>]    lr : [<bf2a3ef4>]    psr: a00d0113
[   14.269374] sp : ede7fe28  ip : ee983410  fp : c1787f30
[   14.269378] r10: 00000000  r9 : 00000000  r8 : bf2b2258
[   14.269384] r7 : ee983000  r6 : c1604c48  r5 : ede7fe88  r4 : edf337c0
[   14.269389] r3 : 00000000  r2 : 00000000  r1 : ede7fe88  r0 : c17712c8
[   14.269398] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[   14.269404] Control: 10c5387d  Table: ad16804a  DAC: 00000051

Disassembly showed that the local static variable __efivars is NULL. Likely
because efivars_register() is not called on this Tegra platform. So adding
a NULL pointer check in efivar_entry_size() and similar functions while at
it. In efivars_register() a couple of sanity checks have been added.

Cc: Hans de Goede <hdegoede@redhat.com>
Reported-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/firmware/efi/vars.c | 108 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 87 insertions(+), 21 deletions(-)

diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index 9336ffd..5fbd8e7 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -318,7 +318,12 @@ struct variable_validate {
 static efi_status_t
 check_var_size(u32 attributes, unsigned long size)
 {
-	const struct efivar_operations *fops = __efivars->ops;
+	const struct efivar_operations *fops;
+
+	if (!__efivars)
+		return EFI_UNSUPPORTED;
+
+	fops = __efivars->ops;
 
 	if (!fops->query_variable_store)
 		return EFI_UNSUPPORTED;
@@ -329,7 +334,12 @@ struct variable_validate {
 static efi_status_t
 check_var_size_nonblocking(u32 attributes, unsigned long size)
 {
-	const struct efivar_operations *fops = __efivars->ops;
+	const struct efivar_operations *fops;
+
+	if (!__efivars)
+		return EFI_UNSUPPORTED;
+
+	fops = __efivars->ops;
 
 	if (!fops->query_variable_store)
 		return EFI_UNSUPPORTED;
@@ -429,13 +439,18 @@ static void dup_variable_bug(efi_char16_t *str16, efi_guid_t *vendor_guid,
 int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
 		void *data, bool duplicates, struct list_head *head)
 {
-	const struct efivar_operations *ops = __efivars->ops;
+	const struct efivar_operations *ops;
 	unsigned long variable_name_size = 1024;
 	efi_char16_t *variable_name;
 	efi_status_t status;
 	efi_guid_t vendor_guid;
 	int err = 0;
 
+	if (!__efivars)
+		return -EFAULT;
+
+	ops = __efivars->ops;
+
 	variable_name = kzalloc(variable_name_size, GFP_KERNEL);
 	if (!variable_name) {
 		printk(KERN_ERR "efivars: Memory allocation failed.\n");
@@ -583,12 +598,14 @@ static void efivar_entry_list_del_unlock(struct efivar_entry *entry)
  */
 int __efivar_entry_delete(struct efivar_entry *entry)
 {
-	const struct efivar_operations *ops = __efivars->ops;
 	efi_status_t status;
 
-	status = ops->set_variable(entry->var.VariableName,
-				   &entry->var.VendorGuid,
-				   0, 0, NULL);
+	if (!__efivars)
+		return -EINVAL;
+
+	status = __efivars->ops->set_variable(entry->var.VariableName,
+					      &entry->var.VendorGuid,
+					      0, 0, NULL);
 
 	return efi_status_to_err(status);
 }
@@ -607,12 +624,17 @@ int __efivar_entry_delete(struct efivar_entry *entry)
  */
 int efivar_entry_delete(struct efivar_entry *entry)
 {
-	const struct efivar_operations *ops = __efivars->ops;
+	const struct efivar_operations *ops;
 	efi_status_t status;
 
 	if (down_interruptible(&efivars_lock))
 		return -EINTR;
 
+	if (!__efivars) {
+		up(&efivars_lock);
+		return -EINVAL;
+	}
+	ops = __efivars->ops;
 	status = ops->set_variable(entry->var.VariableName,
 				   &entry->var.VendorGuid,
 				   0, 0, NULL);
@@ -650,13 +672,19 @@ int efivar_entry_delete(struct efivar_entry *entry)
 int efivar_entry_set(struct efivar_entry *entry, u32 attributes,
 		     unsigned long size, void *data, struct list_head *head)
 {
-	const struct efivar_operations *ops = __efivars->ops;
+	const struct efivar_operations *ops;
 	efi_status_t status;
 	efi_char16_t *name = entry->var.VariableName;
 	efi_guid_t vendor = entry->var.VendorGuid;
 
 	if (down_interruptible(&efivars_lock))
 		return -EINTR;
+
+	if (!__efivars) {
+		up(&efivars_lock);
+		return -EINVAL;
+	}
+	ops = __efivars->ops;
 	if (head && efivar_entry_find(name, vendor, head, false)) {
 		up(&efivars_lock);
 		return -EEXIST;
@@ -687,12 +715,17 @@ int efivar_entry_set(struct efivar_entry *entry, u32 attributes,
 efivar_entry_set_nonblocking(efi_char16_t *name, efi_guid_t vendor,
 			     u32 attributes, unsigned long size, void *data)
 {
-	const struct efivar_operations *ops = __efivars->ops;
+	const struct efivar_operations *ops;
 	efi_status_t status;
 
 	if (down_trylock(&efivars_lock))
 		return -EBUSY;
 
+	if (!__efivars) {
+		up(&efivars_lock);
+		return -EINVAL;
+	}
+
 	status = check_var_size_nonblocking(attributes,
 					    size + ucs2_strsize(name, 1024));
 	if (status != EFI_SUCCESS) {
@@ -700,6 +733,7 @@ int efivar_entry_set(struct efivar_entry *entry, u32 attributes,
 		return -ENOSPC;
 	}
 
+	ops = __efivars->ops;
 	status = ops->set_variable_nonblocking(name, &vendor, attributes,
 					       size, data);
 
@@ -727,9 +761,13 @@ int efivar_entry_set(struct efivar_entry *entry, u32 attributes,
 int efivar_entry_set_safe(efi_char16_t *name, efi_guid_t vendor, u32 attributes,
 			  bool block, unsigned long size, void *data)
 {
-	const struct efivar_operations *ops = __efivars->ops;
+	const struct efivar_operations *ops;
 	efi_status_t status;
 
+	if (!__efivars)
+		return -EINVAL;
+
+	ops = __efivars->ops;
 	if (!ops->query_variable_store)
 		return -ENOSYS;
 
@@ -829,13 +867,18 @@ struct efivar_entry *efivar_entry_find(efi_char16_t *name, efi_guid_t guid,
  */
 int efivar_entry_size(struct efivar_entry *entry, unsigned long *size)
 {
-	const struct efivar_operations *ops = __efivars->ops;
+	const struct efivar_operations *ops;
 	efi_status_t status;
 
 	*size = 0;
 
 	if (down_interruptible(&efivars_lock))
 		return -EINTR;
+	if (!__efivars) {
+		up(&efivars_lock);
+		return -EINVAL;
+	}
+	ops = __efivars->ops;
 	status = ops->get_variable(entry->var.VariableName,
 				   &entry->var.VendorGuid, NULL, size, NULL);
 	up(&efivars_lock);
@@ -861,12 +904,14 @@ int efivar_entry_size(struct efivar_entry *entry, unsigned long *size)
 int __efivar_entry_get(struct efivar_entry *entry, u32 *attributes,
 		       unsigned long *size, void *data)
 {
-	const struct efivar_operations *ops = __efivars->ops;
 	efi_status_t status;
 
-	status = ops->get_variable(entry->var.VariableName,
-				   &entry->var.VendorGuid,
-				   attributes, size, data);
+	if (!__efivars)
+		return -EINVAL;
+
+	status = __efivars->ops->get_variable(entry->var.VariableName,
+					      &entry->var.VendorGuid,
+					      attributes, size, data);
 
 	return efi_status_to_err(status);
 }
@@ -882,14 +927,19 @@ int __efivar_entry_get(struct efivar_entry *entry, u32 *attributes,
 int efivar_entry_get(struct efivar_entry *entry, u32 *attributes,
 		     unsigned long *size, void *data)
 {
-	const struct efivar_operations *ops = __efivars->ops;
 	efi_status_t status;
 
 	if (down_interruptible(&efivars_lock))
 		return -EINTR;
-	status = ops->get_variable(entry->var.VariableName,
-				   &entry->var.VendorGuid,
-				   attributes, size, data);
+
+	if (!__efivars) {
+		up(&efivars_lock);
+		return -EINVAL;
+	}
+
+	status = __efivars->ops->get_variable(entry->var.VariableName,
+					      &entry->var.VendorGuid,
+					      attributes, size, data);
 	up(&efivars_lock);
 
 	return efi_status_to_err(status);
@@ -921,7 +971,7 @@ int efivar_entry_get(struct efivar_entry *entry, u32 *attributes,
 int efivar_entry_set_get_size(struct efivar_entry *entry, u32 attributes,
 			      unsigned long *size, void *data, bool *set)
 {
-	const struct efivar_operations *ops = __efivars->ops;
+	const struct efivar_operations *ops;
 	efi_char16_t *name = entry->var.VariableName;
 	efi_guid_t *vendor = &entry->var.VendorGuid;
 	efi_status_t status;
@@ -940,6 +990,11 @@ int efivar_entry_set_get_size(struct efivar_entry *entry, u32 attributes,
 	if (down_interruptible(&efivars_lock))
 		return -EINTR;
 
+	if (!__efivars) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	/*
 	 * Ensure that the available space hasn't shrunk below the safe level
 	 */
@@ -956,6 +1011,8 @@ int efivar_entry_set_get_size(struct efivar_entry *entry, u32 attributes,
 		}
 	}
 
+	ops = __efivars->ops;
+
 	status = ops->set_variable(name, vendor, attributes, *size, data);
 	if (status != EFI_SUCCESS) {
 		err = efi_status_to_err(status);
@@ -1138,6 +1195,15 @@ int efivars_register(struct efivars *efivars,
 	if (down_interruptible(&efivars_lock))
 		return -EINTR;
 
+	if (WARN(!efivars || !ops, "Invalid parameters\n"))
+		return -EINVAL;
+
+	/* check mandatory efivars operations */
+	if (WARN_ON(!ops->get_variable) ||
+	    WARN_ON(!ops->set_variable) ||
+	    WARN_ON(!ops->get_next_variable))
+		return -EINVAL;
+
 	efivars->ops = ops;
 	efivars->kobject = kobject;
 
-- 
1.9.1

