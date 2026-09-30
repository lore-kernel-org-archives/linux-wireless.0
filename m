Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D6B4EC66A
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 14:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790777439; cv=none; b=dN//5T42+UgUXm760Gi4SB5EGJgCS92D71t62WVAmdRo8AVTR3iGMWRU0+/fQlC8ZX7O/3J7rtyOsvvHU1jw8GfRxmVuB2R0IyOLn3sN8N/85+cqT51WbK8bkTG2rxpISIqyumV/6vrlyAlN5QMJYRDYWiU1w4KKDTQdzGa8mcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790777439; c=relaxed/simple;
	bh=Jx2dPRIHA4h4yESf8m5wxC6nG+dWMUEuY6w/WT6qrdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OwRMDBM3S6pI+iEqTJ5GSm9JhlBx4+oU1S49+nutLVdpF5fqexFKQZP4pL/ZbOGnlRllTvUZTQNUHU8s0NdUbl+HQZInl57Hlr+u5GuKBjgmhepU6FchziGxhT6BhiQfqZea78tIBZWcWyhdEuwI6E0TQJ+0Tgg+14GPH9Vdn2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g4H82C5o; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g4H82C5o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790777405;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9lKY5zSooUG9J2WAMt80T6mv1JymFjL65pHqXNpRbZ0=;
	b=g4H82C5o7GEcScHmdL7HMEGJJheCZIgsfZ8VZ6MkAxa1BuFqsq7RMnBYE28j4+AFsU0Ofb
	2adnYBiMjOKIZBRX+s7IalH2YKySMjmejKJR+mmBFbgf/Xd65WwWRx9Igw96yA4t8ppLBT
	nYYBgv0WBP40DQvhmkEDgOl8CPAuEM0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-684-1gEACnZ4PZGdvatH_SoJfQ-1; Wed,
 30 Sep 2026 10:10:01 -0400
X-MC-Unique: 1gEACnZ4PZGdvatH_SoJfQ-1
X-Mimecast-MFC-AGG-ID: 1gEACnZ4PZGdvatH_SoJfQ_1790777399
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2B9DD18001F7;
	Wed, 30 Sep 2026 14:09:59 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 10BCD1956044;
	Wed, 30 Sep 2026 14:09:54 +0000 (UTC)
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
Subject: [PATCH 7/7] ath12k: Use VFIO MSI cache when available
Date: Wed, 30 Sep 2026 16:08:33 +0200
Message-ID: <20260930140833.576941-8-jtornosm@redhat.com>
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
 drivers/net/wireless/ath/ath12k/pci.c | 43 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath12k/pci.h |  6 ++++
 2 files changed, 49 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
index 65712486d312..832d3cf652d9 100644
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
@@ -1083,6 +1120,12 @@ void ath12k_pci_get_msi_address(struct ath12k_base *ab, u32 *msi_addr_lo,
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

