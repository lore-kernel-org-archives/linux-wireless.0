Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4627551C326
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 14:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790777384; cv=none; b=GgpQebxWC8C5OSuNkYxgedXRSjuhHD4pwbPCVjojnYkh7KzlfXIGsVdCMq2xRJ600sqt5UHocgUyBgujtm5hQLwG54xpDfnhodRX5lOUoax0CwOLYcQGVmlyANhpYniM4k3U3GY/b469TtEeDlePmuWXBEId3037YKqPAajpV6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790777384; c=relaxed/simple;
	bh=wzCxc32rbmkSY0PdhJCX09jC+IBkOV6kwaJVMIvonsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PkWx+TOvqktM2+HyXhMT9XXuFFm3uv11f4DKhGnAVNi59L5PW/sXjho31Plb+BbjsZUV3EJ6JJ9ESJ0PcnM04XmgL2dWsaMYHwGwwhSVx6Xp2KXU4XhkQdf7uosTR7jVmnkKWlyWPGobHXFg9+alySsktKcME/fFsl1PF578JtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L843pNPf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L843pNPf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790777363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9BxRhMSUFbC0ZUhx2ycCj3+AeDAxyb/zT+LTlcEooUE=;
	b=L843pNPfprcENN9Y3l2Bobgi/AVohhfoVQGZeRpsFeLMVTGt5wXKRZBT4Vkfsfv0zfaQuB
	+sRXrHv1tNWzHHpwFpbRZJTngCN9aqyWUBLDLmAjQ2LztFnX1auoQitiCo0PKlTzHPDqSv
	y//a0h25Sp6oCfq0yyAG/FWG5CsdxjM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-317--DlMhR4oP8mqRPeBD6UlLg-1; Wed,
 30 Sep 2026 10:09:18 -0400
X-MC-Unique: -DlMhR4oP8mqRPeBD6UlLg-1
X-Mimecast-MFC-AGG-ID: -DlMhR4oP8mqRPeBD6UlLg_1790777356
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 00CBD1977531;
	Wed, 30 Sep 2026 14:09:16 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8D5871956044;
	Wed, 30 Sep 2026 14:09:11 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: bhelgaas@google.com,
	alex@shazbot.org,
	jjohnson@kernel.org
Cc: johannes@sipsolutions.net,
	mani@kernel.org,
	jgg@ziepe.ca,
	yishaih@nvidia.com,
	skolothumtho@nvidia.com,
	kevin.tian@intel.com,
	linux-pci@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: [PATCH 2/7] vfio: Add qcom_vfio.h header for MSI cache protocol
Date: Wed, 30 Sep 2026 16:08:28 +0200
Message-ID: <20260930140833.576941-3-jtornosm@redhat.com>
In-Reply-To: <20260930140833.576941-1-jtornosm@redhat.com>
References: <20260930140833.576941-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Add shared header defining the communication protocol between
qcom-vfio-pci variant driver and Qualcomm device drivers (ath11k,
ath12k) for passing physical host MSI addresses to VMs.

Qualcomm device firmware requires physical host MSI addresses rather
than guest IOVA addresses. The qcom-vfio-pci driver caches host MSI
values in extended PCI config space with a magic signature "QMSI" for
VM discovery.

Protocol:
 1. Host: qcom-vfio-pci finds free space in extended config (0x100-0xFFF)
 2. Host: Writes magic signature "QMSI" (0x49534D51) followed by MSI data
 3. VM: Device driver searches for "QMSI" signature to locate cached MSI
 4. VM: Reads MSI values and programs device firmware

This avoids offset mismatch when QEMU filters certain capabilities,
causing host and VM to see different extended capability chains.

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
---
 include/linux/qcom_vfio.h | 88 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 88 insertions(+)
 create mode 100644 include/linux/qcom_vfio.h

diff --git a/include/linux/qcom_vfio.h b/include/linux/qcom_vfio.h
new file mode 100644
index 000000000000..c59c81936e84
--- /dev/null
+++ b/include/linux/qcom_vfio.h
@@ -0,0 +1,88 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* SPDX-FileCopyrightText: Copyright Red Hat */
+
+#ifndef _QCOM_VFIO_H_
+#define _QCOM_VFIO_H_
+
+#include <linux/pci.h>
+
+/*
+ * MSI Address Passthrough Quirk
+ *
+ * Qualcomm device firmware requires physical host MSI addresses rather than
+ * guest IOVA addresses. The qcom-vfio-pci variant driver caches host MSI
+ * values in extended PCI config space with a magic signature for VM
+ * discovery.
+ *
+ * Protocol:
+ *  1. Host: qcom-vfio-pci finds free space in extended config (0x100-0xFFF)
+ *  2. Host: Writes magic signature "QMSI" (0x49534D51) followed by MSI data
+ *  3. VM: Device driver searches for "QMSI" signature to locate cached MSI
+ *  4. VM: Reads MSI values and programs device firmware
+ *
+ * This avoids offset mismatch when QEMU filters certain capabilities, causing
+ * host and VM to see different extended capability chains.
+ *
+ * Layout in extended config space:
+ *   +0x00: Magic signature "QMSI" (0x49534D51)
+ *   +0x04: MSI address low 32 bits
+ *   +0x08: MSI address high 32 bits
+ *   +0x0C: MSI data (16 bits)
+ *
+ * Applicable to:
+ *  - ath11k WiFi (PCI ID 0x17cb:0x1103)
+ *  - ath12k WiFi (PCI ID 0x17cb:0x1107)
+ */
+
+/* Magic signature "QMSI" to identify cached MSI data */
+#define QCOM_VFIO_MSI_MAGIC		0x49534D51
+
+/* Space needed for magic + MSI passthrough data */
+#define QCOM_VFIO_MSI_SPACE_SIZE	16
+
+/* Relative offsets from base discovered by qcom_vfio_find_msi_offset() */
+#define QCOM_VFIO_MSI_MAGIC_OFFSET	0x00	/* Magic signature "QMSI" */
+#define QCOM_VFIO_MSI_ADDR_LO_OFFSET	0x04	/* Host MSI address low 32 bits */
+#define QCOM_VFIO_MSI_ADDR_HI_OFFSET	0x08	/* Host MSI address high 32 bits */
+#define QCOM_VFIO_MSI_DATA_OFFSET	0x0C	/* Host MSI data (16 bits) */
+
+/**
+ * qcom_vfio_find_msi_offset - Find free space for host to cache MSI
+ * @pdev: PCI device
+ *
+ * Host-side function: Finds free space in extended config to write MSI cache.
+ * Uses PCI core utility to scan capability chain.
+ *
+ * Returns: Offset in extended config space (>= 0x100), or 0 if no space found
+ */
+static inline int qcom_vfio_find_msi_offset(struct pci_dev *pdev)
+{
+	return pci_find_free_ext_cap_offset(pdev, QCOM_VFIO_MSI_SPACE_SIZE);
+}
+
+/**
+ * qcom_vfio_find_msi_cache - Locate cached MSI data by magic signature
+ * @pdev: PCI device
+ *
+ * VM-side function: Searches extended config space for "QMSI" magic signature
+ * to locate host-cached MSI values. This avoids offset mismatch when QEMU
+ * filters certain capabilities.
+ *
+ * Returns: Offset of MSI data (after magic), or 0 if not found
+ */
+static inline int qcom_vfio_find_msi_cache(struct pci_dev *pdev)
+{
+	u32 magic;
+	int offset;
+
+	for (offset = 0x100; offset <= 0xf00; offset += 4) {
+		if (pci_read_config_dword(pdev, offset, &magic))
+			continue;
+		if (magic == QCOM_VFIO_MSI_MAGIC)
+			return offset;
+	}
+
+	return 0;
+}
+
+#endif /* _QCOM_VFIO_H_ */
-- 
2.53.0

