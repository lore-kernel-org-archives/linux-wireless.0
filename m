Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB2351CF74
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 14:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790777399; cv=none; b=SUjBBSfAZfNlhkYYFLUUimCWIXwnw+kxR0nhaqTrN7LdtOls0jdiBe2MXlQHvdfMjJzZor3GKDLDHp/0OJrPVv+A38GtSzvBHLWOII5ShAPKvUKYd8nsFHy8njQvsxs4xoSy8wf5h+X93zlCpbaiUKHW04Jpb7W9wVjjbWWqvBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790777399; c=relaxed/simple;
	bh=sLDljgy2iUfR4ux4LRoswkUrAQGhocHxixSmputVTh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pbyUOLqp7b+Hgtgb4HnY1mmYX5bOjexX504Y+mQOtFTtp7//MsKINZ77kYWhny0rki7Vjh1lO4Roguapm5Tsgcd3vNYLunydqsIb9nTIOmValMAfP/5k9uh5C1/BNlH9MZ0yp2qkpFEUFYuGPxWCDZWA3cqtyVXLvxxMvMgY5vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CyRU5ysX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CyRU5ysX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790777378;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0YVhvO5SMCN7TMiG9ZoSdhyJXNnNMq+CHd4JeeSj0hY=;
	b=CyRU5ysX8H6/vA2TdH4Q98cmjGsM7YanqK0tF/3tLRI3Z1sX3PSSNxxiNcZtc3Sy+btbsd
	Tgv1x4speNnygi8P4sgNoO2Y3TBjyJQJD3Q0jL2HaFMO/aud3k0ki3WGjH9IjMhgLEBceA
	VDbele8IW+eaEo5G6l0eBhJewpbxXIs=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-610-S2DnP1ZkNd6ZrH8EgANtGw-1; Wed,
 30 Sep 2026 10:09:32 -0400
X-MC-Unique: S2DnP1ZkNd6ZrH8EgANtGw-1
X-Mimecast-MFC-AGG-ID: S2DnP1ZkNd6ZrH8EgANtGw_1790777369
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 50813180899A;
	Wed, 30 Sep 2026 14:09:29 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 125A61956044;
	Wed, 30 Sep 2026 14:09:24 +0000 (UTC)
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
Subject: [PATCH 4/7] ath11k: add PCIe link recovery retry
Date: Wed, 30 Sep 2026 16:08:30 +0200
Message-ID: <20260930140833.576941-5-jtornosm@redhat.com>
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
 drivers/net/wireless/ath/ath11k/pci.c | 39 ++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 7 deletions(-)

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
+	unsigned long timeout;
+	bool link_recovered = false;
 	u32 val, delay;
 
 	val = ath11k_pcic_read32(ab, PCIE_SOC_GLOBAL_RESET);
@@ -211,14 +213,29 @@ static void ath11k_pci_soc_global_reset(struct ath11k_base *ab)
 
 	mdelay(delay);
 
-	val = ath11k_pcic_read32(ab, PCIE_SOC_GLOBAL_RESET);
-	if (val == 0xffffffff)
-		ath11k_warn(ab, "link down error during global reset\n");
+	/* Wait for PCIe link to recover, especially important in VM environments
+	 * where timing can vary significantly from bare metal.
+	 */
+	timeout = jiffies + msecs_to_jiffies(5000);
+	while (time_before(jiffies, timeout)) {
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
@@ -373,8 +390,10 @@ static void ath11k_pci_force_wake(struct ath11k_base *ab)
 	mdelay(5);
 }
 
-static void ath11k_pci_sw_reset(struct ath11k_base *ab, bool power_on)
+static int ath11k_pci_sw_reset(struct ath11k_base *ab, bool power_on)
 {
+	int ret;
+
 	mdelay(100);
 
 	if (power_on) {
@@ -387,8 +406,12 @@ static void ath11k_pci_sw_reset(struct ath11k_base *ab, bool power_on)
 
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
@@ -818,7 +841,9 @@ static int ath11k_pci_power_up(struct ath11k_base *ab)
 
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

