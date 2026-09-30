Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F1A51DB09
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 14:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790777401; cv=none; b=RYhU2gaHRHNBRXOlgV7rL1tEqQwNPErO/ScheI2hKKYnkX3Js0Ju8/MOAEq/5oghSxgFPSBtcZfUvRV9rcijYK3O6pphq8jsfPZmVB/w9e8aG9oNhgTBlJcGYs8r8jmgCAzBBd6UC+yn8/DzhRiSTDkyhFlwZw40lW5XF3vrPFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790777401; c=relaxed/simple;
	bh=ChDbrJBtKwVpjhyNqwXNVijk17LuvlzsmCBx2JvRS48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cm6edSsm67oCZ6bbW8vcuoux90v7kLy3GyBsXwlZZKAQ2lowboTb9Y8vfCWTkK2hQ1LoP3FSOEHSoLiPN5IE8mY5ot8ryit1EhTALKys6uY+TD+vaWgQPxswdvk/ZxKtOyeC4tb9Hfys/jvZ4Ix7mBmB3FY+wFnDTKGeS6U5E3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h+6MEcMr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h+6MEcMr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790777390;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L1hpiA9PSrEgTziY9kUXLTeM8Im79Dj/E5wLN7KEwBw=;
	b=h+6MEcMrzcHsETN7t+H7efO4rWLv/nFvnJVALWMr9UvhXFLR98fDHfZh0pi62X1B+sCL9u
	iBlijxS1MZgnGQ+Rd3fp4I7oux+AsFM5DkundCHWs9YBpOg2yi7eiq4tQoSO5F6APT3XBt
	ADJ8yl6gfzD4LZGCijxZFXabbylEN7U=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-649-vG0PtuP-M6KWTOdKg7iCaw-1; Wed,
 30 Sep 2026 10:09:46 -0400
X-MC-Unique: vG0PtuP-M6KWTOdKg7iCaw-1
X-Mimecast-MFC-AGG-ID: vG0PtuP-M6KWTOdKg7iCaw_1790777384
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 50ECE180214B;
	Wed, 30 Sep 2026 14:09:44 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 86EC51956044;
	Wed, 30 Sep 2026 14:09:40 +0000 (UTC)
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
Subject: [PATCH 5/7] ath11k: Use VFIO MSI cache when available
Date: Wed, 30 Sep 2026 16:08:31 +0200
Message-ID: <20260930140833.576941-6-jtornosm@redhat.com>
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

The Qualcomm ath11k firmware requires physical host MSI addresses for
interrupt configuration but cannot handle IOVA-based MSI addressing in
virtualized environments.

When the device is passed through to a VM via VFIO:
- The guest kernel allocates MSI vectors and sees IOVA addresses
- The ath11k firmware expects physical host MSI addresses
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
 drivers/net/wireless/ath/ath11k/pci.c | 33 +++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
index c372676b097f..99a3a709831c 100644
--- a/drivers/net/wireless/ath/ath11k/pci.c
+++ b/drivers/net/wireless/ath/ath11k/pci.c
@@ -10,6 +10,7 @@
 #include <linux/of.h>
 #include <linux/time.h>
 #include <linux/vmalloc.h>
+#include <linux/qcom_vfio.h>
 
 #include "pci.h"
 #include "core.h"
@@ -463,8 +464,11 @@ static int ath11k_pci_alloc_msi(struct ath11k_pci *ab_pci)
 	struct ath11k_base *ab = ab_pci->ab;
 	const struct ath11k_msi_config *msi_config = ab->pci.msi.config;
 	struct pci_dev *pci_dev = ab_pci->pdev;
+	u32 msi_addr_lo = 0, msi_addr_hi = 0;
 	struct msi_desc *msi_desc;
+	u16 msi_data = 0;
 	int num_vectors;
+	int msi_offset;
 	int ret;
 
 	num_vectors = pci_alloc_irq_vectors(pci_dev,
@@ -488,6 +492,35 @@ static int ath11k_pci_alloc_msi(struct ath11k_pci *ab_pci)
 	}
 	ath11k_info(ab, "MSI vectors: %d\n", num_vectors);
 
+	/*
+	 * Try to get host MSI address from VFIO cache.
+	 * When running on a VM, the ath11k firmware requires physical host
+	 * MSI addresses and cannot handle guest IOVA addresses.
+	 * qcom-vfio-pci writes host MSI values to extended config space with
+	 * a magic signature "QMSI" for discovery. Search for it.
+	 */
+	msi_offset = qcom_vfio_find_msi_cache(pci_dev);
+	if (msi_offset) {
+		pci_read_config_dword(pci_dev,
+				      msi_offset + QCOM_VFIO_MSI_ADDR_LO_OFFSET,
+				      &msi_addr_lo);
+		pci_read_config_dword(pci_dev,
+				      msi_offset + QCOM_VFIO_MSI_ADDR_HI_OFFSET,
+				      &msi_addr_hi);
+		pci_read_config_word(pci_dev,
+				     msi_offset + QCOM_VFIO_MSI_DATA_OFFSET,
+				     &msi_data);
+
+		if (msi_addr_lo && msi_addr_lo != 0xFFFFFFFF) {
+			ab->pci.msi.addr_lo = msi_addr_lo;
+			ab->pci.msi.addr_hi = msi_addr_hi;
+			ab->pci.msi.ep_base_data = msi_data;
+			ath11k_info(ab, "VFIO MSI cache at offset 0x%x: addr_lo=0x%x addr_hi=0x%x data=%d\n",
+				    msi_offset, msi_addr_lo, msi_addr_hi, msi_data);
+			return 0;
+		}
+	}
+
 	ath11k_pci_msi_disable(ab_pci);
 
 	msi_desc = irq_get_msi_desc(ab_pci->pdev->irq);
-- 
2.55.0

