Received: from vtj.irix.systems (vtj.irix.systems [82.76.27.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2995B352030;
	Sun,  4 Oct 2026 11:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.76.27.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791112761; cv=none; b=dPCne0Etf0Z1pCfzpGK/B8vTB8VXBmGcZ3KAbKTTXQ/Z5PApN0+d03Yw6btozie3A6GMZKGRNrldXBY6buI+UCOF8m3vbtCut9d89MKOB73YzEUCZJ8R8a5qJMrfYiXlf/wse2omy3k132eSFS0ZxQrrBEEpqCsY16kvoqgNXck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791112761; c=relaxed/simple;
	bh=bsMET5anPF3RwC+qQFUohU0MnLNPDH0F34yoSoiiHTI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pGZ9sWX/WK3nVLtCehkLUegjUQdrp4oA0Ud36xS1smubHvftoVqRfwcqdNAguOy7iaZ+vqCi2D0EarnwSgL8h+DuI7Fshtnm/ZTiywmax6/NGq9qB134wVClqp2Ynmk1JYKf8arNBC+S0807ruS4E0h9Hy0ITjTVZB13ozc1xLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com; spf=pass smtp.mailfrom=andrei-z.com; dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b=DbtOzk0M; arc=none smtp.client-ip=82.76.27.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b="DbtOzk0M"
Received: from MAILGW-BIG.big.vtj.corp.irix.systems (localhost [127.0.0.1])
	by vtj.irix.systems (Proxmox) with ESMTP id A80C4103C0;
	Sun, 04 Oct 2026 14:19:18 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=andrei-z.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=sig1; bh=5iBoFGPkE06vjMhxF2D/
	+ekmdU8OvBVPkR8cZBYUeB4=; b=DbtOzk0MbjS0mOTH0gNUZtipf7LzVR6pmbJ3
	R/aMjNb1dQoymlVLelFWgEtAIknJj9SdOMuj39W9gOHa2Ksro5oypZ86KtiM3BaU
	1KWMD3fNDBmnfqeg+tiIPGqgqT0R0W4YttfmbFykcpZNASi30YhdStAnvSz4T37Y
	DhiBWgdkufnsM9XuuLTuZu9LxAbAIBOJXQ4FMA78P09mq+wDeBrO/2mdEJP/GrQt
	xfIkpVaFSwPq2WnqlwchMciMXFCoKj0K+8r8qNigexn5YZzYqgkhYTxDf44Jj/BU
	Hh6w5glmHNWjm4Pw0Qp+PZTjc2s8XE5i5kvCMpRI/utKTB+mBw==
Received: from VTJ-MX.corp.irix.systems (unknown [IPv6:2a02:2f04:1:9c24::6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by vtj.irix.systems (Proxmox) with ESMTPS id 376BD102F9;
	Sun, 04 Oct 2026 14:19:18 +0300 (EEST)
Received: from workspace.corp.irix.systems (2a02:2f04:1:9c23::c) by
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 14:19:17 +0300
From: Andrei-Alexandru Bleortu <me@andrei-z.com>
To: Jeff Johnson <jjohnson@kernel.org>
CC: <ath11k@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH ath-next 1/5] wifi: ath11k: add a debugfs file listing the firmware WMI services
Date: Sun, 4 Oct 2026 14:18:03 +0300
Message-ID: <2b36fb4e11a9d8bfbd5011074bc954278cf81447.1791111135.git.me@andrei-z.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1791111135.2.git.me@andrei-z.com>
References: <cover.1791111135.2.git.me@andrei-z.com>
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
at debug level. List the number of every set bit of the service map in
<soc>/wmi_services, so that the capabilities of a given firmware build
can be read directly.

Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1
Tested-on: IPQ5018 hw1.0 AHB WLAN.HK.2.7.0.1-01744-QCAHKSWPL_SILICONZ-1

Assisted-by: LLM
Signed-off-by: Andrei-Alexandru Bleortu <me@andrei-z.com>
---
 drivers/net/wireless/ath/ath11k/debugfs.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/debugfs.c b/drivers/net/wireless/ath/ath11k/debugfs.c
index 70922612d3..75d2e81c77 100644
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
-- 
2.47.3


