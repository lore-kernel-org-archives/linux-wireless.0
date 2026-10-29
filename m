Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793291937;
	b=Lt5MjBERmG6UD39+S+4O92m69DUCF1EKHGCsgG/kDmoVVQL22TPrrXLL5kzxUNXFJOcP
	 r6OmU/jiYHY9I+nIfEUXbcfEc+609MgFmT8xDNK0RzwxyCNvT2K1YO0rfSjkU1c+KyBLd
	 4p9Wi5fnIeXYzl0hzvFvXcjx1J4ZaxcC5BfAmQxIqqefU16ncMBZY4wzOw6TIGnj33ILY
	 02Mu8l3PNeLw+Ht10TDys/u71oApZJ4SheTxIYu1RGC3AqwlMbmERtKBn75dRFOD0lDvr
	 aAmcQFbHgJaXofrzu5WToO55eOE9BNO7LhggCHt+P8LXVK9lmvoJ5c7TcQOJ0IsJA0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793291937;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=bNMG+lIhxZcEUu3kzAXgyCfzh9SPkmetdc8XLLC9LrM=;
	b=iUKkMczhR/3FENMDZnGrM9ALHRk5l3A1X4k2s1weG/DKDRh7qIIzAcR/+XS8U2Dji8Bl
	 48TALAWRikUtyS1EhJumefaWdPYNMvw127TiDykz6YiS5l8KLOAH/f+bTHbbvnkYRRKo0
	 GGS+rzdvo8X3DnjlZXtzD1uqNTKD5+URKrBrGwg87YlZphRQj3S0Dqlj0atutrA3zSqOx
	 omEteS2CvxYnKW/INY6/CLcUUOsF/dro2Wp/KYfAFoPqbb8vTRbU8487zATrlyBEw6b9y
	 1qbdmn02bY+FAumCybIZKs9lYeCmFQdH0vWgIi/dCLUeF51A1fal6JXM9GqtypZ4KzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LiDA9ZqL;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602A5606A32E
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 16:38:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 602A5606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LiDA9ZqL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793291936;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bNMG+lIhxZcEUu3kzAXgyCfzh9SPkmetdc8XLLC9LrM=;
	b=LiDA9ZqLwdSNF4nS4PKFTvPmzrSPT1an24hPMnbfTCNCediQ/TYihqHEnfBt8nOTg6DjJ8
	CtY2IdwSVb7Bu8aJG/HoLJNGz3B//0PVBEL7H3J2XV4TEL5k042aT6sTOP0zUxzahQ2i2c
	csGVScCs4gjKJJ7RGX3PDCA6hWJceu4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-428-eg23MM3yOHGLfjy1yaOlzQ-1; Thu,
 29 Oct 2026 12:38:53 -0400
X-MC-Unique: eg23MM3yOHGLfjy1yaOlzQ-1
X-Mimecast-MFC-AGG-ID: eg23MM3yOHGLfjy1yaOlzQ_1793291930
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 999A9180B5F2;
	Thu, 29 Oct 2026 16:38:50 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 57B161955F0A;
	Thu, 29 Oct 2026 16:38:46 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jgg@ziepe.ca,
	alex@shazbot.org,
	pbonzini@redhat.com,
	seanjc@google.com,
	bhelgaas@google.com,
	jjohnson@kernel.org
Cc: johannes@sipsolutions.net,
	mani@kernel.org,
	lpieralisi@kernel.org,
	kwilczynski@kernel.org,
	robh@kernel.org,
	vkuznets@redhat.com,
	kevin.tian@intel.com,
	linux-pci@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: [PATCH v3 8/8] PCI: add QCN9274 to reset quirks and KVM MSI domain
Date: Thu, 29 Oct 2026 17:37:13 +0100
Message-ID: <20261029163713.1366077-9-jtornosm@redhat.com>
In-Reply-To: <20261029163713.1366077-1-jtornosm@redhat.com>
References: <20261029163713.1366077-1-jtornosm@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

In order to have Qualcomm QCN9274 (PCI ID 17cb:1109) completely
operational from VM environments, add to:

1. quirk_no_bus_reset: Disable broken bus reset, as with WCN6855 and
   WCN7850.

2. pci_dev_specific_reset_methods: Use the existing
   reset_qualcomm_wlan function. Unlike WCN7850, the QCN9274 is not
   initialized at all without a valid device-specific reset method.

3. kvm_msi_devids in pci-kvm-msi: Enable KVM MSI domain support for
   VFIO passthrough to VMs.

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
---
v3: new
v2: https://lore.kernel.org/all/20261011074514.515894-1-jtornosm@redhat.com/

 drivers/pci/controller/pci-kvm-msi.c | 1 +
 drivers/pci/quirks.c                 | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/pci/controller/pci-kvm-msi.c b/drivers/pci/controller/pci-kvm-msi.c
index e935e5d9846d..b008e73fedce 100644
--- a/drivers/pci/controller/pci-kvm-msi.c
+++ b/drivers/pci/controller/pci-kvm-msi.c
@@ -336,6 +336,7 @@ static int kvm_msi_create_domain(struct pci_dev *ref_dev)
 static const struct pci_device_id kvm_msi_devids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_QCOM, 0x1103) },	/* WCN6855 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_QCOM, 0x1107) },	/* WCN7850 */
+	{ PCI_DEVICE(PCI_VENDOR_ID_QCOM, 0x1109) },	/* QCN9274 */
 	{ }
 };
 
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 7f1f47ea2ee4..89d82675a76c 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3818,6 +3818,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0034, quirk_no_bus_reset);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x003e, quirk_no_bus_reset);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_QCOM, 0x1103, quirk_no_bus_reset); /* WCN6855 */
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_QCOM, 0x1107, quirk_no_bus_reset); /* WCN7850 */
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_QCOM, 0x1109, quirk_no_bus_reset); /* QCN9274 */
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_QCOM, 0x0308, quirk_no_bus_reset); /* SDX62/SDX65 */
 
 /*
@@ -4398,6 +4399,7 @@ static const struct pci_dev_reset_methods pci_dev_reset_methods[] = {
 	{ PCI_VENDOR_ID_QCOM, 0x0308, reset_qualcomm_modem }, /* SDX62/SDX65 modems */
 	{ PCI_VENDOR_ID_QCOM, 0x1103, reset_qualcomm_wlan },  /* WCN6855 WLAN */
 	{ PCI_VENDOR_ID_QCOM, 0x1107, reset_qualcomm_wlan },  /* WCN7850 WLAN */
+	{ PCI_VENDOR_ID_QCOM, 0x1109, reset_qualcomm_wlan },  /* QCN9274 WLAN */
 	{ 0 }
 };
 
-- 
2.56.0

