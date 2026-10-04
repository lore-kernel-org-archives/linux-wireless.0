Received: from vtj.irix.systems (vtj.irix.systems [82.76.27.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948013F482F;
	Sun,  4 Oct 2026 11:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.76.27.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791112892; cv=none; b=BwXpSDuWwmBTB4A0OWSJ6wn8ib2qOAnAJQAmiw/9tq+iQsu4kK5IjgzHQi7xFfSyFdOO4vSF5feZFm1Y65dNRD9nZpQBLmEVE4yLYsIMdyNjlMxg3JLIl6iaGqMHBAZmVRpDSZSMrXyMHLKfvUjW502mg9mxg8GFdq1ZXEgWmq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791112892; c=relaxed/simple;
	bh=gRfyOaDspY3w0AXOixfQJt+LhdKqRWtgqIj7C1luI9Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rAZojRuO9/9A5FSPdPtEucw2f9NoYUHxna63GTFByLmd18LurBt/aO2eoQH4PMoxT0dGnpmZX1+eA/35RXLRCTQglZVybBc39ykiLHdCg1Rdhq+5GejDLFRb8QVr3GiDeQq45w7Mv7lCMpTP58JUIZuzXl279X6yTrwq9Fuo7p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com; spf=pass smtp.mailfrom=andrei-z.com; dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b=bWam9cm/; arc=none smtp.client-ip=82.76.27.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b="bWam9cm/"
Received: from MAILGW-DELL.dell.vtj.corp.irix.systems (localhost [127.0.0.1])
	by vtj.irix.systems (Proxmox) with ESMTP id 8F27413C3A;
	Sun, 04 Oct 2026 14:21:29 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=andrei-z.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=sig1; bh=8wdFPkKVBD1u4gBOGxIY
	K1bcdkahVAWWGkvnOUYqIJY=; b=bWam9cm/a1SsiVLrPM2IGcwHz9qKJjBImvzw
	AbxiZ/uMx96b6aPmcRjhysoFkaKMcne6TfjZAGXS4GPH7GN9wM87gmwWRublxwEf
	kOAaQdWZrZyKRQBeN9ifMcgGav9btxJfHxDwFlRit+TC52uWSffi55IcFUy5hp8V
	P/SVcxOkmvVACLgx0hmi3uHvneWHomD0EWzTMozrGuMeDmjuup3uFByy1nWvhT4L
	LHKOCoWGNLKyfWfIVbR2VkLSP1pAkJVJw/bNDjLtPe6Bj+aR3O4j9hC4C/yIi9Hf
	5nAsvQL+Ag36iftrWgPKIGrJ/QOuDhEHQuaQMKCYYzjK6f2ihQ==
Received: from VTJ-MX.corp.irix.systems (unknown [IPv6:2a02:2f04:1:9c24::6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by vtj.irix.systems (Proxmox) with ESMTPS id C5AF513D27;
	Sun, 04 Oct 2026 14:21:28 +0300 (EEST)
Received: from workspace.corp.irix.systems (2a02:2f04:1:9c23::c) by
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 14:21:28 +0300
From: Andrei-Alexandru Bleortu <me@andrei-z.com>
To: Jeff Johnson <jjohnson@kernel.org>
CC: <ath11k@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH ath-next 3/5] wifi: ath11k: leave OBSS PD off when spatial reuse is not configured
Date: Sun, 4 Oct 2026 14:18:05 +0300
Message-ID: <794ed7804f86fb8b8b607a703ce110a0b18e9b9f.1791111135.git.me@andrei-z.com>
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

mac80211 reports BSS_CHANGED_HE_OBSS_PD when an HE AP starts even if
user space configured no spatial reuse parameters, with he_obss_pd
.enable false. ath11k ignored the flag and, with an empty SR Control,
enabled non-SRG OBSS PD at its default maximum threshold of -62 dBm,
where IEEE Std 802.11-2024, 26.10.2.4 puts the non-SRG OBSS PD maximum
at -82 dBm plus an offset that the AP did not advertise.

Disable OBSS PD unless it is enabled, as ath12k does.

Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1

Assisted-by: LLM
Signed-off-by: Andrei-Alexandru Bleortu <me@andrei-z.com>
---
 drivers/net/wireless/ath/ath11k/mac.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index c1fa42edd3..a10d191b1a 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -3373,7 +3373,8 @@ static int ath11k_mac_config_obss_pd(struct ath11k *ar,
 
 	/* Set and enable SRG/non-SRG OBSS PD Threshold */
 	param_id = WMI_PDEV_PARAM_SET_CMD_OBSS_PD_THRESHOLD;
-	if (test_bit(ATH11K_FLAG_MONITOR_STARTED, &ar->monitor_flags)) {
+	if (test_bit(ATH11K_FLAG_MONITOR_STARTED, &ar->monitor_flags) ||
+	    !he_obss_pd->enable) {
 		ret = ath11k_wmi_pdev_set_param(ar, param_id, 0, pdev_id);
 		if (ret)
 			ath11k_warn(ar->ab,
-- 
2.47.3


