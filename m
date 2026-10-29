Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793291902;
	b=hHefiuWvENtqZohWqsxVO9OCJKb5Y2p+i4/vULLhrt/kJ59oymrOB5E6ZgvZ5HrVB+qW
	 qWxQNGqGiqmoEzT7C1/aclIPSIJnrOa7l5Yz7toBC3Rtw4kCC0uNop95OOzyvT370dfaa
	 NJFIsaTYnD4jENYIn1BksjwNC4e9aFuWW5vkfrYUU51Q9uPcrIbVk7jB6biJNZtsLS3Ev
	 pGxOMbIaUC7HNLt2tmmEbaUgjD7NQwjuyyemnNDI03ss+1uyvYh8WdA6TSuxIhCqDXurv
	 ya+DOwIOgnQoL6kljN4DkrwlmkAGbNIyVhaY1a+prkeVYWVoQYVS5nn0yZWmKufpr9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793291902;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=Rk+pfvv1vb7NTTtSUJmQv83uHi7ByrRhQkXx66jSAVY=;
	b=C4upovLyARA2+7L7rUpEO/nBBD7kpCZhEpMFi+FWHISiMNQ4d04KHsw7/6JhHBZYvLMV
	 2VQ61C8SfY/4dsweoOoM734DHJsAzcb+sQGLsEtVjDpUPi/MXOtEXJW0BsrgsRVkAgmKa
	 v2BcBWN1gs7YXZtlqTvgtfFUXgG9MBvGjbGhNsEIMeCIFd/3Wbf0/1Wq3jXEQCRnjFBLm
	 LyAohRT+Tx4imw+C8fx7WilXArDs6tt3IgTqdaWKyt/UK6KlrPI0oqoWD2yhiinM5gMNv
	 l/GiQm+WMO52Jxqgx8w+dTKu7Lu34j5K5LUXK69zHS8sPqcbkyV6KWa/tnyChWVaABg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=fNUzvZdA;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECFDD606A31C
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 16:38:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ECFDD606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=fNUzvZdA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793291899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rk+pfvv1vb7NTTtSUJmQv83uHi7ByrRhQkXx66jSAVY=;
	b=fNUzvZdAeH61BunZr5X5AHdcFZb4wxNr3DqYi5GHeoVGkJKeGFdGafPa/otgzDRmqqoDre
	A63Zd55FuByEQZ/cotwCJJ/Bpxk7eTpN08lATmS1Y5WUwOJt7eYwc6n1Y7BopHRW/SaoUi
	ELzRjUsNXBzjB2LvGpKVhernYbCQWTw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-684-9LRORvpiNdStrDF32nnCug-1; Thu,
 29 Oct 2026 12:38:16 -0400
X-MC-Unique: 9LRORvpiNdStrDF32nnCug-1
X-Mimecast-MFC-AGG-ID: 9LRORvpiNdStrDF32nnCug_1793291894
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0B18E1935311;
	Thu, 29 Oct 2026 16:38:14 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 794E61956088;
	Thu, 29 Oct 2026 16:38:09 +0000 (UTC)
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
Subject: [PATCH v3 4/8] ath11k: add PCIe link recovery retry
Date: Thu, 29 Oct 2026 17:37:09 +0100
Message-ID: <20261029163713.1366077-5-jtornosm@redhat.com>
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

When ath11k devices are passed through to VMs via PCIe passthrough,
the PCIe link may not stabilize immediately after global reset due to
virtualization layer timing variations. This causes MHI initialization
to fail with "BHI offset: 0xffffffff is out of range" errors because
the device is read before it's ready.

Currently, ath11k_pci_soc_global_reset() just warns if the link is
down but continues anyway, leading to inevitable MHI failures.

This patch adds:
1. A retry loop (up to 5000ms) to wait for the PCIe link to recover
   after global reset (similar to the existing ath12k LTSSM retry logic)
2. Proper error propagation to prevent continuing with a dead link

This is especially important for VM environments where timing can vary
significantly from bare metal.

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
---
v3: no modification
v2: https://lore.kernel.org/all/20261011074514.515894-5-jtornosm@redhat.com/

 drivers/net/wireless/ath/ath11k/pci.c | 38 ++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
index a163168f3617..7e29ebaf9773 100644
--- a/drivers/net/wireless/ath/ath11k/pci.c
+++ b/drivers/net/wireless/ath/ath11k/pci.c
@@ -190,8 +190,10 @@ static void ath11k_pci_restore_window(struct ath11k_base *ab)
 	spin_unlock_bh(&ab_pci->window_lock);
 }
 
-static void ath11k_pci_soc_global_reset(struct ath11k_base *ab)
+static int ath11k_pci_soc_global_reset(struct ath11k_base *ab)
 {
+	bool link_recovered = false;
+	int retries = 250;
 	u32 val, delay;
 
 	val = ath11k_pcic_read32(ab, PCIE_SOC_GLOBAL_RESET);
@@ -215,14 +217,28 @@ static void ath11k_pci_soc_global_reset(struct ath11k_base *ab)
 
 	mdelay(delay);
 
-	val = ath11k_pcic_read32(ab, PCIE_SOC_GLOBAL_RESET);
-	if (val == 0xffffffff)
-		ath11k_warn(ab, "link down error during global reset\n");
+	/* Wait for PCIe link to recover, especially important in VM environments
+	 * where timing can vary significantly from bare metal.
+	 */
+	while (retries-- > 0) {
+		val = ath11k_pcic_read32(ab, PCIE_SOC_GLOBAL_RESET);
+		if (val != 0xffffffff) {
+			link_recovered = true;
+			break;
+		}
+		mdelay(20);
+	}
+	if (!link_recovered) {
+		ath11k_err(ab, "PCIe link failed to recover - device may need power cycle\n");
+		return -ETIMEDOUT;
+	}
 
 	/* Restore window register as its content is cleared during
 	 * hardware global reset, such that it aligns with host cache.
 	 */
 	ath11k_pci_restore_window(ab);
+
+	return 0;
 }
 
 static void ath11k_pci_clear_dbg_registers(struct ath11k_base *ab)
@@ -377,8 +393,10 @@ static void ath11k_pci_force_wake(struct ath11k_base *ab)
 	mdelay(5);
 }
 
-static void ath11k_pci_sw_reset(struct ath11k_base *ab, bool power_on)
+static int ath11k_pci_sw_reset(struct ath11k_base *ab, bool power_on)
 {
+	int ret;
+
 	mdelay(100);
 
 	if (power_on) {
@@ -391,8 +409,12 @@ static void ath11k_pci_sw_reset(struct ath11k_base *ab, bool power_on)
 
 	ath11k_mhi_clear_vector(ab);
 	ath11k_pci_clear_dbg_registers(ab);
-	ath11k_pci_soc_global_reset(ab);
+	ret = ath11k_pci_soc_global_reset(ab);
+	if (ret)
+		return ret;
 	ath11k_mhi_set_mhictrl_reset(ab);
+
+	return 0;
 }
 
 static void ath11k_pci_init_qmi_ce_config(struct ath11k_base *ab)
@@ -822,7 +844,9 @@ static int ath11k_pci_power_up(struct ath11k_base *ab)
 
 	ab_pci->register_window = 0;
 	clear_bit(ATH11K_FLAG_DEVICE_INIT_DONE, &ab->dev_flags);
-	ath11k_pci_sw_reset(ab_pci->ab, true);
+	ret = ath11k_pci_sw_reset(ab_pci->ab, true);
+	if (ret)
+		return ret;
 
 	/* Disable ASPM during firmware download due to problems switching
 	 * to AMSS state.
-- 
2.56.0

