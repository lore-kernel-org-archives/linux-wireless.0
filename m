Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793291921;
	b=tYWGDSTjjFEV1HwVmdukZ8f5YfZLOFYVWRrdcqwa+lpxIuKG3ynA/z0KZV79E80y4lbj
	 A8x9uWEXxhXFN9fNEvxUrXdt80WFfEbNPg6pc+V3gsxr/9t8jGDrKgmcDJUuaTFMIwsxy
	 PXW6YB03AowzikZOEdmnnETIjLLFJPjCxWrAtGRXlY4zY6kjfVNgy0efjRUk4dHF+9sTN
	 Oe54uGhAR5I+7Kqe4Pv3WLeVn+UqhDaMQsyZmo5imuls87PIOc1IVgOIrbPGwkMI4kezC
	 UsUyc7Azt2U4Teg6x42x1GvgtDpS+1yEiNQ6TOahtBjdf3mJbwd9800h0GFgvmh10iA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793291921;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=Kd9tL7nbYj58IN9wQcXJ3Dyge2/jqnTJA16TRM9TzyM=;
	b=1gosa3Rbhylk42RreHv4iwhSN/z9pSJxLaRv6nZij78CMFLeB6E8A+b/HpGFGNmvOrJv
	 LHe/KBekZ8Hf/bIUu0sjqDkHGF7CPRwxBosnlLBkK7cKx7qKAZuzgZSeDITVoeILwj7K1
	 J5t0h3ax6oPzylDQGKa8YgpW25dxNzznPsAuvf/6iSrnl6oi+8rl97sh1A8281fzw+Kig
	 3tXt55MNuxndKp2ZBMefKMalpIVlPT9b3nUO1ybBi7sL8ySrKhodmDEc1sjMwpWW8DmGf
	 DZomdoV9orNCizjy7kDXYN/mQvZP6trLGgl10VjWOgcRRw7LF4fggG1PD0khxCBvRBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=i4gQ0uj2;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD71E606A31D
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 16:38:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DD71E606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=i4gQ0uj2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793291919;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kd9tL7nbYj58IN9wQcXJ3Dyge2/jqnTJA16TRM9TzyM=;
	b=i4gQ0uj2oVj9LYOslrymUnVZ2qvugEr0IZsXCbDH52lhwdjScp5qsz8WBVXLDcjqD8QfNS
	zSTcd41CQB424NLubyPZfn8j9OMcXqOZiFy3inhZvsB5IKIjbkYw6cUpPudLH4emL+l28D
	PXzquahR3yldQGWml4shZ9OAq4maQjU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-588-e7qNfC78PaKQ5hKdG1KwUw-1; Thu,
 29 Oct 2026 12:38:36 -0400
X-MC-Unique: e7qNfC78PaKQ5hKdG1KwUw-1
X-Mimecast-MFC-AGG-ID: e7qNfC78PaKQ5hKdG1KwUw_1793291914
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B9801180B5CC;
	Thu, 29 Oct 2026 16:38:33 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 669011955F01;
	Thu, 29 Oct 2026 16:38:29 +0000 (UTC)
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
Subject: [PATCH v3 6/8] ath12k: add PCIe link recovery retry
Date: Thu, 29 Oct 2026 17:37:11 +0100
Message-ID: <20261029163713.1366077-7-jtornosm@redhat.com>
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

When ath12k devices are passed through to VMs via PCIe passthrough,
the PCIe link may not stabilize immediately after global reset due to
virtualization layer timing variations. This causes MHI initialization
to fail with "BHI offset: 0xffffffff is out of range" errors because
the device is read before it's ready.

Currently, ath12k_pci_soc_global_reset() just warns if the link is
down but continues anyway, leading to inevitable MHI failures.

This patch adds:
1. A retry loop (up to 5000ms) to wait for the PCIe link to recover
   after global reset (similar to the existing LTSSM retry logic)
2. Proper error propagation to prevent continuing with a dead link

This is especially important for VM environments where timing can vary
significantly from bare metal.

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
---
v3: no modification
v2: https://lore.kernel.org/all/20261011074514.515894-7-jtornosm@redhat.com/

 drivers/net/wireless/ath/ath12k/pci.c | 38 ++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
index 12bbb75570f1..f7879fb48d32 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -181,8 +181,10 @@ static void ath12k_pci_restore_window(struct ath12k_base *ab)
 	spin_unlock_bh(&ab_pci->window_lock);
 }
 
-static void ath12k_pci_soc_global_reset(struct ath12k_base *ab)
+static int ath12k_pci_soc_global_reset(struct ath12k_base *ab)
 {
+	bool link_recovered = false;
+	int retries = 250;
 	u32 val, delay;
 
 	val = ath12k_pci_read32(ab, PCIE_SOC_GLOBAL_RESET);
@@ -206,14 +208,28 @@ static void ath12k_pci_soc_global_reset(struct ath12k_base *ab)
 
 	mdelay(delay);
 
-	val = ath12k_pci_read32(ab, PCIE_SOC_GLOBAL_RESET);
-	if (val == 0xffffffff)
-		ath12k_warn(ab, "link down error during global reset\n");
+	/* Wait for PCIe link to recover, especially important in VM environments
+	 * where timing can vary significantly from bare metal.
+	 */
+	while (retries-- > 0) {
+		val = ath12k_pci_read32(ab, PCIE_SOC_GLOBAL_RESET);
+		if (val != 0xffffffff) {
+			link_recovered = true;
+			break;
+		}
+		mdelay(20);
+	}
+	if (!link_recovered) {
+		ath12k_err(ab, "PCIe link failed to recover - device may need power cycle\n");
+		return -ETIMEDOUT;
+	}
 
 	/* Restore window register as its content is cleared during
 	 * hardware global reset, such that it aligns with host cache.
 	 */
 	ath12k_pci_restore_window(ab);
+
+	return 0;
 }
 
 static void ath12k_pci_clear_dbg_registers(struct ath12k_base *ab)
@@ -299,8 +315,10 @@ static void ath12k_pci_force_wake(struct ath12k_base *ab)
 	mdelay(5);
 }
 
-static void ath12k_pci_sw_reset(struct ath12k_base *ab, bool power_on)
+static int ath12k_pci_sw_reset(struct ath12k_base *ab, bool power_on)
 {
+	int ret;
+
 	if (power_on) {
 		ath12k_pci_enable_ltssm(ab);
 		ath12k_pci_clear_all_intrs(ab);
@@ -309,8 +327,12 @@ static void ath12k_pci_sw_reset(struct ath12k_base *ab, bool power_on)
 
 	ath12k_mhi_clear_vector(ab);
 	ath12k_pci_clear_dbg_registers(ab);
-	ath12k_pci_soc_global_reset(ab);
+	ret = ath12k_pci_soc_global_reset(ab);
+	if (ret)
+		return ret;
 	ath12k_mhi_set_mhictrl_reset(ab);
+
+	return 0;
 }
 
 static void ath12k_pci_free_ce_irq(struct ath12k_base *ab, int num_ce)
@@ -1452,7 +1474,9 @@ int ath12k_pci_power_up(struct ath12k_base *ab)
 
 	ab_pci->register_window = 0;
 	clear_bit(ATH12K_PCI_FLAG_INIT_DONE, &ab_pci->flags);
-	ath12k_pci_sw_reset(ab_pci->ab, true);
+	ret = ath12k_pci_sw_reset(ab_pci->ab, true);
+	if (ret)
+		return ret;
 
 	/* Disable ASPM during firmware download due to problems switching
 	 * to AMSS state.
-- 
2.56.0

