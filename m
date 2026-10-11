Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8AA390998
	for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 07:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791704765; cv=none; b=XntVRsez91d69BTOMYB3sa/mks44ns593Ub8d/RsdOQlguXYCT1E3zQp0N0ISqGled/3tjCHfQg4jm8nzvfdhzrAARh1t92qk/UI9BWmS9pcqlSxBrxiP01RiEnFsJKlfUGZAVii55Fa0AaPJhs72hw9HHWvAFqcJcgIJ/fHZIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791704765; c=relaxed/simple;
	bh=2ZF3rDwsebEJFK3d7A1BvIKFWdPHamkvAPHXWNUai+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iAMaaa/3J8gowaHMCJCbsPywjzGZ9HP2cqE72LEVnAhWflSLX5d45f2qQzn3zl7TDQ2LakUYF+o0vRiU+RaFiadASrrvd3u/YFlLQYFwEZa70CIqiuDpcFxRLl0VDOPQ855BszdxiAuMeTTpw3hNX+ohsWWGgz5TCM1rT60Z9PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g7znxKxF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g7znxKxF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791704763;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9eskwLgMwD2YS4xUD+rb73EOM3qCajRipGLWj2T/h90=;
	b=g7znxKxFSGliJiaJE9pRBnZcly+Q/2faBXoUch0xPRUp9Qlq04/OU2xTeuMMeeBG8b+ZG5
	kPwXU2EHWPc+a5QGtOb8Z0SoAjaZS7wJAQnEMjzGeFdIZBoG47TPSkLXx1Ufn8sabMNj/4
	hidB3js9EiCFOO9uDWI0wMiYQCDT3fk=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-74-3MzqQL0NMde1fKR9P7nNOg-1; Sun,
 11 Oct 2026 07:45:59 +0000
X-MC-Unique: 3MzqQL0NMde1fKR9P7nNOg-1
X-Mimecast-MFC-AGG-ID: 3MzqQL0NMde1fKR9P7nNOg_1791704757
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 632851954ACF;
	Sun, 11 Oct 2026 07:45:57 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A906D1956041;
	Sun, 11 Oct 2026 07:45:53 +0000 (UTC)
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
Subject: [PATCH v2 4/7] ath11k: add PCIe link recovery retry
Date: Sun, 11 Oct 2026 09:45:11 +0200
Message-ID: <20261011074514.515894-5-jtornosm@redhat.com>
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
v2: Address Sashiko comments:
    - Replace jiffies-based timeout with iteration counter to work
      correctly in atomic/panic contexts where jiffies does not advance
      (consistency with ath12k patch 6/7)
v1: https://lore.kernel.org/all/20260930140833.576941-5-jtornosm@redhat.com/

 drivers/net/wireless/ath/ath11k/pci.c | 38 ++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
index 7114eca8810d..4fc6aaf036c1 100644
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
@@ -211,14 +213,28 @@ static void ath11k_pci_soc_global_reset(struct ath11k_base *ab)
 
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
@@ -373,8 +389,10 @@ static void ath11k_pci_force_wake(struct ath11k_base *ab)
 	mdelay(5);
 }
 
-static void ath11k_pci_sw_reset(struct ath11k_base *ab, bool power_on)
+static int ath11k_pci_sw_reset(struct ath11k_base *ab, bool power_on)
 {
+	int ret;
+
 	mdelay(100);
 
 	if (power_on) {
@@ -387,8 +405,12 @@ static void ath11k_pci_sw_reset(struct ath11k_base *ab, bool power_on)
 
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
@@ -818,7 +840,9 @@ static int ath11k_pci_power_up(struct ath11k_base *ab)
 
 	ab_pci->register_window = 0;
 	clear_bit(ATH11K_FLAG_DEVICE_INIT_DONE, &ab->dev_flags);
-	ath11k_pci_sw_reset(ab_pci->ab, true);
+	ret = ath11k_pci_sw_reset(ab_pci->ab, true);
+	if (ret)
+		return ret;
 
 	/* Disable ASPM during firmware download due to problems switching
 	 * to AMSS state.
-- 
2.53.0

