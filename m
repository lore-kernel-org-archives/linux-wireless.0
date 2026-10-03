Received: from vtj.irix.systems (vtj.irix.systems [82.76.27.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90ED344E66D;
	Sat,  3 Oct 2026 15:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.76.27.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791042969; cv=none; b=DYVlHDCUabSOUIxgqqLW8/Fq0P+o8h5+EueNmG4vC8zND84og2OG5jEq/lQzcfD+4YiuK8OwIvJ+L8J9SS8GRWOZrQO0dVXxVuRK4XaruwstNHHyj1lfhBWpz/TmJ8oDxskr/Ss/ivsAxLiGKlOOC3TMhQ85nCb7hGVGhlPOECo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791042969; c=relaxed/simple;
	bh=uV5mbUIQd3fKYj6e3meqTeTtc3MmOvdIOIgcLPXYz3Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XppxToCPm3qUGbWEm9mIr9io1SwK3XOSBfsjqqcTcFenkcTxpTj7VXz4haFNt45+hjbrKtsDdn0iRF1pjCJL20xvO0eoj7oolUecxKyZMG4Bgz419QX3g/R/xPf8y91+p38lRVkqGTIKkRiE8tMFfl8wU9R0rYMtD6JOK0twLQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com; spf=pass smtp.mailfrom=andrei-z.com; dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b=a5UhJq/r; arc=none smtp.client-ip=82.76.27.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b="a5UhJq/r"
Received: from MAILGW-HP.hp.vtj.corp.irix.systems (localhost [127.0.0.1])
	by vtj.irix.systems (Proxmox) with ESMTP id BF8961603B;
	Sat, 03 Oct 2026 18:55:48 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=andrei-z.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=sig1; bh=z4ZWY2lYUWLTnEVfGSFV
	Ya6IQCkfgmn3BeS8my0FevU=; b=a5UhJq/rblD21Q5QmLvrHHrLbOqnV0YaKYbe
	fq3sTcNIwUQypAzVVytVL8Y+JYwFQR/nxF//EhJA0q/sUoCwGpJuAghiOejlxK9x
	jZllmtJ1Tb+hxmX+0KE/GjcofLP5n+4uaOVL9jxSCCkaJN0c8IJ0yKI0BD64o+sW
	vOMn+w6DRAPKEpftIvEHHotMhWE7X4hD1qj64aJ97kCpgwchVmXTjeIbZAOV4ble
	dSz5oi6rTgP6naChDci8gjGxN/4OGN6IM6efgkID0pwA1qY5wOt3MCa8eCzqxfE1
	X2IOXV+5rzeQuSQhF0j+L03vuL+Di+PzE2/qZQnE5JLLj2RVxw==
Received: from VTJ-MX.corp.irix.systems (unknown [IPv6:2a02:2f04:1:9c24::6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by vtj.irix.systems (Proxmox) with ESMTPS id 0201B15CF5;
	Sat, 03 Oct 2026 18:55:48 +0300 (EEST)
Received: from workspace.corp.irix.systems (2a02:2f04:1:9c23::c) by
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sat, 3 Oct 2026 18:55:47 +0300
From: Andrei-Alexandru Bleortu <me@andrei-z.com>
To: Jeff Johnson <jjohnson@kernel.org>, Johannes Berg
	<johannes@sipsolutions.net>
CC: <ath11k@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>, Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 1/4] wifi: ath11k: add a debugfs file listing the firmware WMI services
Date: Sat, 3 Oct 2026 18:55:39 +0300
Message-ID: <20261003155542.96363-2-me@andrei-z.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261003155542.96363-1-me@andrei-z.com>
References: <20261003155542.96363-1-me@andrei-z.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) To
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6)

Whether a feature is available often comes down to a WMI service bit
the firmware reports at boot, and ath11k only logs the ext services,
at debug level. List every set bit of the service map in
<soc>/wmi_services, as ath10k's file of the same name does, so the
capabilities of a given firmware build can be read directly.

Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1
Tested-on: IPQ5018 hw1.0 AHB WLAN.HK.2.7.0.1-01744-QCAHKSWPL_SILICONZ-1

Assisted-by: LLM
Signed-off-by: Andrei-Alexandru Bleortu <me@andrei-z.com>
---
 drivers/net/wireless/ath/ath11k/debugfs.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/debugfs.c b/drivers/net/wireless/ath/ath11k/debugfs.c
index 70922612d..75d2e81c7 100644
--- a/drivers/net/wireless/ath/ath11k/debugfs.c
+++ b/drivers/net/wireless/ath/ath11k/debugfs.c
@@ -851,6 +851,18 @@ static const struct file_operations fops_sram_dump = {
 	.llseek = default_llseek,
 };
 
+static int ath11k_wmi_services_show(struct seq_file *m, void *v)
+{
+	struct ath11k_base *ab = m->private;
+	unsigned int i;
+
+	for_each_set_bit(i, ab->wmi_ab.svc_map, WMI_MAX_EXT2_SERVICE)
+		seq_printf(m, "%u\n", i);
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(ath11k_wmi_services);
+
 int ath11k_debugfs_pdev_create(struct ath11k_base *ab)
 {
 	if (test_bit(ATH11K_FLAG_REGISTERED, &ab->dev_flags))
@@ -862,6 +874,9 @@ int ath11k_debugfs_pdev_create(struct ath11k_base *ab)
 	debugfs_create_file("soc_dp_stats", 0400, ab->debugfs_soc, ab,
 			    &fops_soc_dp_stats);
 
+	debugfs_create_file("wmi_services", 0400, ab->debugfs_soc, ab,
+			    &ath11k_wmi_services_fops);
+
 	if (ab->hw_params.sram_dump.start != 0)
 		debugfs_create_file("sram", 0400, ab->debugfs_soc, ab,
 				    &fops_sram_dump);

