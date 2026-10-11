Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA87739734E
	for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 07:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791704743; cv=none; b=PhSk0iuAk4xR/5w8JJMpeeSf3PTY09FzOqKHJ7U+8OgAT2iP1ResJufXVps42YoOWmaf2hMixj9dDpeExcdj/Jgw/8/ejdNduenk2+1+1CR73uCQoMpykwrJiJl+ts1Q0sRpKciNPJlHHXiIdw6Usv414v6pjo7lf0s0ioPhdYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791704743; c=relaxed/simple;
	bh=xHRG0l0Pya1dV8UJGqCGQcUPAjxiJ5JrYl2BvpfeHhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tiLe0/nAuqvZC+KKiDylHvTj9wiEkUNkX1emOYZmaDPxk8KYE9R8FUid5EOXU1pMdz78BWgV+ztgpwiZtcBnem2EM+4UerXHN3RELzLvr0bow6bIW9XgJ3jBY/FbXNALUPjyDDOc3DhZ3O3mFK+2cYL+/ekVQVeN838I9y8NuXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F/b9Z/00; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F/b9Z/00"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791704740;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sh45bfH6uhfT3Ksu8Vh+24tRbIBlwKOVnSGn6jCmHg4=;
	b=F/b9Z/00ExNHRAJKTRiyTwTqfkE/sycTMp3yCJmWsJYpaqHO2ONgCoor51vDS26NaXT2g5
	Yy7xeh+MPhCq2jmAzTZGsaK61EaxhSooMwHaLbBTonkCbQKkbIWBg2CimdumPLMi0r8bJy
	EMps3i6dS6jlq10NTUo1LzzG2SbbRv4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-113-zjclJS8vPteu2r2wac3_Jg-1; Sun,
 11 Oct 2026 07:45:37 +0000
X-MC-Unique: zjclJS8vPteu2r2wac3_Jg-1
X-Mimecast-MFC-AGG-ID: zjclJS8vPteu2r2wac3_Jg_1791704735
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 50ADD1954ACF;
	Sun, 11 Oct 2026 07:45:34 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9DB8E1956041;
	Sun, 11 Oct 2026 07:45:29 +0000 (UTC)
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
Subject: [PATCH v2 1/7] PCI: Add pci_find_free_ext_cap_offset() helper
Date: Sun, 11 Oct 2026 09:45:08 +0200
Message-ID: <20261011074514.515894-2-jtornosm@redhat.com>
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

Add helper function to find free space in PCI extended configuration
space. This is needed by VFIO variant drivers that need to use unused
extended config space for device-specific purposes, such as passing
metadata to VMs.

The function walks the extended capability chain (with TTL to prevent
infinite loops on malformed chains), then scans for a contiguous region
of zeroed space of at least the requested size. This avoids hardcoding
capability sizes and correctly handles capabilities of any length.

Use case: The qcom-vfio-pci variant driver uses this to find space for
caching host MSI addresses that need to be passed to Qualcomm device
firmware in VMs.

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
---
v2: Address Sashiko comments:
    - Add TTL to capability chain walk to prevent infinite loops on
      malformed capability chains (matching pci_find_next_ext_capability)
    - Replace hardcoded 64-byte offset with zero-scan approach to
      correctly handle capabilities of any size
    - Fix potential integer underflow in size comparison
    - Add cfg_size and size parameter validation
v1: https://lore.kernel.org/all/20260930140833.576941-2-jtornosm@redhat.com/

 drivers/pci/pci.c   | 72 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h |  3 +++
 2 files changed, 75 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 8f7cfcc00090..7fa261140457 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -552,6 +552,78 @@ u16 pci_find_ext_capability(struct pci_dev *dev, int cap)
 }
 EXPORT_SYMBOL_GPL(pci_find_ext_capability);
 
+/**
+ * pci_find_free_ext_cap_offset - Find free space in extended config
+ * @dev: PCI device to query
+ * @size: Minimum size needed (in bytes)
+ *
+ * Scans the extended capability chain and then searches for a contiguous
+ * region of zeroed space of at least @size bytes in the extended
+ * configuration space (0x100-0xFFF). This can be used by drivers that
+ * need to use unused extended config space for device-specific purposes
+ * (e.g., VFIO quirks for VM passthrough).
+ *
+ * Returns the offset to free space, or 0 if no suitable gap found.
+ */
+int pci_find_free_ext_cap_offset(struct pci_dev *dev, size_t size)
+{
+	int ttl = (PCI_CFG_SPACE_EXP_SIZE - PCI_CFG_SPACE_SIZE) / 8;
+	int pos = PCI_CFG_SPACE_SIZE;
+	int start = 0, run = 0;
+	int highest_pos = 0;
+	u32 header;
+	int offset;
+
+	if (!pci_is_pcie(dev) || dev->cfg_size <= PCI_CFG_SPACE_SIZE)
+		return 0;
+
+	if (size == 0 || size > PCI_CFG_SPACE_EXP_SIZE - PCI_CFG_SPACE_SIZE)
+		return 0;
+
+	if (pci_read_config_dword(dev, pos, &header))
+		return 0;
+	if (header == 0 || header == 0xffffffff)
+		return 0;
+
+	while (ttl-- > 0) {
+		if (pos > highest_pos)
+			highest_pos = pos;
+
+		pos = PCI_EXT_CAP_NEXT(header);
+		if (!pos || pos < PCI_CFG_SPACE_SIZE)
+			break;
+
+		if (pci_read_config_dword(dev, pos, &header))
+			break;
+		if (header == 0 || header == 0xffffffff)
+			break;
+	}
+
+	if (!highest_pos)
+		return 0;
+
+	for (offset = highest_pos; offset <= (int)PCI_CFG_SPACE_EXP_SIZE - 4;
+	     offset += 4) {
+		u32 val;
+
+		if (pci_read_config_dword(dev, offset, &val))
+			break;
+
+		if (val == 0) {
+			if (run == 0)
+				start = offset;
+			run += 4;
+			if (run >= (int)size)
+				return start;
+		} else {
+			run = 0;
+		}
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

