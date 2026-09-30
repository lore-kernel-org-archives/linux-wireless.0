Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8314E0B60
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 14:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790777364; cv=none; b=RRhcykro/fVYGh8B1w1tHPgU+wKKB2shLT/0wOi+MAro/80JUMJ83+hIdEHbv8z92Kh1N0ggjei2m+Fo2QvlcvvTxXi4CiuPaWtqpp0aVcSOn00ObQDRUkbgfe2UyRh+44S8h5wkYFqhLaDPwKRJ1ko2pX9VqhK8BGyUCPiws+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790777364; c=relaxed/simple;
	bh=VXYSIpNBzjljxOOTtdon4+ERsroM+GnS8vRAxuANfWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u/ydoAR+OvTc6yK0wAymhk9vwawmfY5FBCfQhap3gd3ESglp+LvTPDzD5nXfNItKBrB8SdgxL0d4UQF8faxrMofB/LAefnzagw/TA6Nq+KixqBOcV8NapWGUOj1dVX7qBjnQ565fI2K6Gc06Doej4oQjndieE6zFqfZ/ZIhQqFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UO9k3RCN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UO9k3RCN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790777354;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p3xqmKVAFV4WbQWRk7ZQhQ7LMEFnygykagJl6VwnyQI=;
	b=UO9k3RCN5WMT0N1dqd0XUxvEHuECzVYmftS+qvQuLb0/JA99Pre8UnuB7l3YBB3Hb2MGIL
	mHDxh8q8dsw35kA10bRA1bBI65OSukcDTpz7VkzInRo2HxtJTvdFYYTpwYSdkpIVFVNGdc
	wo+7ISbgkZSLp5yjUgs/Cuc/64eohec=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-307-SOCXgrpmO5qWs48VnazhLw-1; Wed,
 30 Sep 2026 10:09:09 -0400
X-MC-Unique: SOCXgrpmO5qWs48VnazhLw-1
X-Mimecast-MFC-AGG-ID: SOCXgrpmO5qWs48VnazhLw_1790777347
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 098451954B1D;
	Wed, 30 Sep 2026 14:09:07 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 717C31956044;
	Wed, 30 Sep 2026 14:09:02 +0000 (UTC)
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
Subject: [PATCH 1/7] PCI: Add pci_find_free_ext_cap_offset() helper
Date: Wed, 30 Sep 2026 16:08:27 +0200
Message-ID: <20260930140833.576941-2-jtornosm@redhat.com>
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

Add helper function to find free space in PCI extended configuration
space. This is needed by VFIO variant drivers that need to use unused
extended config space for device-specific purposes, such as passing
metadata to VMs.

The function scans the extended capability chain and returns an offset
to a gap of at least the requested size. This allows drivers to safely
use extended config space without conflicting with existing capabilities.

Use case: The qcom-vfio-pci variant driver uses this to find space for
caching host MSI addresses that need to be passed to Qualcomm device
firmware in VMs.

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
---
 drivers/pci/pci.c   | 54 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h |  3 +++
 2 files changed, 57 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 8f7cfcc00090..7fa261140457 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -552,6 +552,60 @@ u16 pci_find_ext_capability(struct pci_dev *dev, int cap)
 }
 EXPORT_SYMBOL_GPL(pci_find_ext_capability);
 
+/**
+ * pci_find_free_ext_cap_offset - Find free space in extended config
+ * @dev: PCI device to query
+ * @size: Minimum size needed (in bytes)
+ *
+ * Scans the extended capability chain to find a gap of at least @size bytes
+ * in the extended configuration space (0x100-0xFFF). This can be used by
+ * drivers that need to use unused extended config space for device-specific
+ * purposes (e.g., VFIO quirks for VM passthrough).
+ *
+ * Returns the offset to free space, or 0 if no suitable gap found.
+ */
+int pci_find_free_ext_cap_offset(struct pci_dev *dev, size_t size)
+{
+	int pos = PCI_CFG_SPACE_SIZE;
+	int last_cap_start = 0;
+	int free_offset;
+	u32 header;
+	int next;
+
+	if (!pci_is_pcie(dev))
+		return 0;
+
+	while (pos >= PCI_CFG_SPACE_SIZE) {
+		if (pci_read_config_dword(dev, pos, &header))
+			break;
+
+		if (header == 0 || header == 0xffffffff)
+			break;
+
+		last_cap_start = pos;
+		next = PCI_EXT_CAP_NEXT(header);
+		if (!next)
+			break;
+		pos = next;
+	}
+
+	/*
+	 * Use space after the last capability. We align to the next capability
+	 * boundary (typically 4-byte aligned). Start at a safe offset past the
+	 * last capability - capabilities vary in size, so use a conservative
+	 * offset. Most extended capabilities are <= 64 bytes.
+	 */
+	if (last_cap_start) {
+		free_offset = last_cap_start + 64;
+		free_offset = ALIGN(free_offset, 4);
+		if (PCI_CFG_SPACE_EXP_SIZE - free_offset >= size)
+			return free_offset;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pci_find_free_ext_cap_offset);
+
 /**
  * pci_get_dsn - Read and return the 8-byte Device Serial Number
  * @dev: PCI device to query
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 2c4454583c11..5d1ccbb2ed29 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1287,6 +1287,7 @@ u8 pci_find_ht_capability(struct pci_dev *dev, int ht_cap);
 u8 pci_find_next_ht_capability(struct pci_dev *dev, u8 pos, int ht_cap);
 u16 pci_find_ext_capability(struct pci_dev *dev, int cap);
 u16 pci_find_next_ext_capability(struct pci_dev *dev, u16 pos, int cap);
+int pci_find_free_ext_cap_offset(struct pci_dev *dev, size_t size);
 struct pci_bus *pci_find_next_bus(const struct pci_bus *from);
 u16 pci_find_vsec_capability(struct pci_dev *dev, u16 vendor, int cap);
 u16 pci_find_dvsec_capability(struct pci_dev *dev, u16 vendor, u16 dvsec);
@@ -2160,6 +2161,8 @@ static inline u8 pci_find_next_capability(struct pci_dev *dev, u8 post, int cap)
 { return 0; }
 static inline u16 pci_find_ext_capability(struct pci_dev *dev, int cap)
 { return 0; }
+static inline int pci_find_free_ext_cap_offset(struct pci_dev *dev, size_t size)
+{ return 0; }
 
 static inline u64 pci_get_dsn(struct pci_dev *dev)
 { return 0; }
-- 
2.53.0

