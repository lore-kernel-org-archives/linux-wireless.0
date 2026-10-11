Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BDA8390998
	for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 07:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791704794; cv=none; b=oDh6x2YmSD3RJuXZfrtgomLmBOxWnTmLWVxMoPPKACjBS2xm64OWVDpNltDQDFDnOV4y354OxcAXPv1Rod3prECQBQJs9jZH3FrDOBKVLrFt9DMudeRnrqCAgRYR9KaftR4BqL89Tr3hqXyJL94blMvkipGTdSLqRv8Rilph+Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791704794; c=relaxed/simple;
	bh=Ljeyp9ABQO2qfh8sjkpHMfXDEQV39t4pJ6IBh9jqB2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EZSwL68fiDMqwppekt15NcIoyzMEJI/IPInuqXIsTKaE0TBcKaoRsNM2IZXsCQKsHgoLPu1xKtLY/LoFiBLFAA9BM6MhiLrToRIOBcIAgF/kRH3t2J/JKwEvsZCA7yPexn8dPhfdk+Fb8la7jpbDlncFRWMX3/MRLMdFyKDZlCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OvS+OQUQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OvS+OQUQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791704792;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zzzwp5zy+LY+qWJ9KEvPG/+UEU2CjzUHFxKDeJ7Rm6I=;
	b=OvS+OQUQLhLrrxowTgclgF0zWvriPzXBEHAXAspCQYuWtshtoWfFqGbsjBjoYvojXDXVtm
	cYY+zhDArFHOxZAmMkLa2MhfLjZhMORN4u9aABy3oEO+Ta+52PbnOj7beUMQkwMX36SINn
	CyOp90D/ePJWpcd4rhjwRrJVoIDn3Mw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-213-wYaZKKUgOQyaqCsDQ-u4mw-1; Sun,
 11 Oct 2026 07:46:23 +0000
X-MC-Unique: wYaZKKUgOQyaqCsDQ-u4mw-1
X-Mimecast-MFC-AGG-ID: wYaZKKUgOQyaqCsDQ-u4mw_1791704781
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 963D91954AD5;
	Sun, 11 Oct 2026 07:46:20 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7211B1956041;
	Sun, 11 Oct 2026 07:46:16 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jgg@ziepe.ca,
	alex@shazbot.org,
	bhelgaas@google.com,
	jjohnson@kernel.org
Cc: johannes@sipsolutions.net,
	mani@kernel.org,
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
Subject: [PATCH v2 7/7] ath12k: Use VFIO MSI cache when available
Date: Sun, 11 Oct 2026 09:45:14 +0200
Message-ID: <20261011074514.515894-8-jtornosm@redhat.com>
In-Reply-To: <20261011074514.515894-1-jtornosm@redhat.com>
References: <20261011074514.515894-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

The Qualcomm ath12k firmware requires physical host MSI addresses for
interrupt configuration but cannot handle IOVA-based MSI addressing in
virtualized environments.

When the device is passed through to a VM via VFIO:
- The guest kernel allocates MSI vectors and sees IOVA addresses
- The ath12k firmware expects physical host MSI addresses
- Providing IOVA to the firmware causes interrupt delivery to fail
- Result: device is non-functional in VMs

The qcom-vfio-pci variant driver (introduced in earlier patches) solves
this by caching the physical host MSI values and exposing them through
PCI extended config space with a "QMSI" magic signature for discovery.

Search for the QMSI magic signature in extended config space. If found,
the device is running on a VM and we can read the cached host MSI values
from that location. If the VFIO cache is not present (i.e. on baremetal),
fall back to standard PCI MSI configuration.

This change is transparent, arch independent and requires no user
configuration when used with the qcom-vfio-pci driver.

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
---
v2: Address Sashiko comments:
  - Guard config_msi_data() to skip overwrite when VFIO cached values
    are already set, preventing guest virtual MSI data from overwriting
    host physical values
v1: https://lore.kernel.org/all/20260930140833.576941-8-jtornosm@redhat.com/

 drivers/net/wireless/ath/ath12k/pci.c | 46 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath12k/pci.h |  6 ++++
 2 files changed, 52 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
index 65712486d312..a9f3b2e18c45 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -8,6 +8,7 @@
 #include <linux/interrupt.h>
 #include <linux/msi.h>
 #include <linux/pci.h>
+#include <linux/qcom_vfio.h>
 #include <linux/time.h>
 #include <linux/vmalloc.h>

@@ -783,8 +784,11 @@ static int ath12k_pci_msi_alloc(struct ath12k_pci *ab_pci)
 {
 	struct ath12k_base *ab = ab_pci->ab;
 	const struct ath12k_msi_config *msi_config = ab_pci->msi_config;
+	u32 msi_addr_lo = 0, msi_addr_hi = 0;
 	struct msi_desc *msi_desc;
+	u16 msi_data = 0;
 	int num_vectors;
+	int msi_offset;
 	int ret;

 	num_vectors = pci_alloc_irq_vectors(ab_pci->pdev,
@@ -812,6 +816,39 @@ static int ath12k_pci_msi_alloc(struct ath12k_pci *ab_pci)

 	ath12k_info(ab, "MSI vectors: %d\n", num_vectors);

+	/*
+	 * Try to get host MSI address from VFIO cache.
+	 * When running on a VM, the ath12k firmware requires physical host
+	 * MSI addresses and cannot handle guest IOVA addresses.
+	 * qcom-vfio-pci writes host MSI values to extended config space with
+	 * a magic signature "QMSI" for discovery. Search for it.
+	 */
+	msi_offset = qcom_vfio_find_msi_cache(ab_pci->pdev);
+	if (msi_offset) {
+		pci_read_config_dword(ab_pci->pdev,
+				      msi_offset + QCOM_VFIO_MSI_ADDR_LO_OFFSET,
+				      &msi_addr_lo);
+		pci_read_config_dword(ab_pci->pdev,
+				      msi_offset + QCOM_VFIO_MSI_ADDR_HI_OFFSET,
+				      &msi_addr_hi);
+		pci_read_config_word(ab_pci->pdev,
+				     msi_offset + QCOM_VFIO_MSI_DATA_OFFSET,
+				     &msi_data);
+
+		if (msi_addr_lo && msi_addr_lo != 0xFFFFFFFF) {
+			ab_pci->msi_addr_hi = msi_addr_hi;
+			ab_pci->msi_addr_lo = msi_addr_lo;
+			ab_pci->msi_ep_base_data = msi_data;
+			ab_pci->msi_addr_cached = true;
+
+			ath12k_info(ab,
+				    "using host MSI from VFIO at offset 0x%x: addr_lo=0x%x addr_hi=0x%x data=%d\n",
+				    msi_offset, msi_addr_lo, msi_addr_hi, msi_data);
+			return 0;
+		}
+	}
+	ab_pci->msi_addr_cached = false;
+
 	ath12k_pci_msi_disable(ab_pci);

 	msi_desc = irq_get_msi_desc(ab_pci->pdev->irq);
@@ -843,7 +880,10 @@ static void ath12k_pci_msi_free(struct ath12k_pci *ab_pci)
 static int ath12k_pci_config_msi_data(struct ath12k_pci *ab_pci)
 {
 	struct msi_desc *msi_desc;

+	if (ab_pci->msi_addr_cached)
+		return 0;
+
 	msi_desc = irq_get_msi_desc(ab_pci->pdev->irq);
 	if (!msi_desc) {
 		ath12k_err(ab_pci->ab, "msi_desc is NULL!\n");
@@ -1083,6 +1123,12 @@ void ath12k_pci_get_msi_address(struct ath12k_base *ab, u32 *msi_addr_lo,
 	struct ath12k_pci *ab_pci = ath12k_pci_priv(ab);
 	struct pci_dev *pci_dev = to_pci_dev(ab->dev);

+	if (ab_pci->msi_addr_cached) {
+		*msi_addr_hi = ab_pci->msi_addr_hi;
+		*msi_addr_lo = ab_pci->msi_addr_lo;
+		return;
+	}
+
 	pci_read_config_dword(pci_dev, pci_dev->msi_cap + PCI_MSI_ADDRESS_LO,
 			      msi_addr_lo);

diff --git a/drivers/net/wireless/ath/ath12k/pci.h b/drivers/net/wireless/ath/ath12k/pci.h
index 0e0e2020c6ae..ee3696d40dfb 100644
--- a/drivers/net/wireless/ath/ath12k/pci.h
+++ b/drivers/net/wireless/ath/ath12k/pci.h
@@ -129,6 +129,12 @@ struct ath12k_pci {
 	/* enum ath12k_pci_flags */
 	unsigned long flags;
 	u16 link_ctl;
+
+	/* Cached host MSI address for firmware configuration in VMs */
+	u32 msi_addr_hi;
+	u32 msi_addr_lo;
+	bool msi_addr_cached;
+
 	unsigned long irq_flags;
 	const struct ath12k_pci_ops *pci_ops;
 	u32 qmi_instance;
--
2.55.0

