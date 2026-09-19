Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E06C2EBB8C;
	Sat, 19 Sep 2026 04:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789790641; cv=none; b=j/Yoji/wzRzM196j+jy+FvIXbHD66slrASVojRcZGK6OmDii+QyB2dy+5DQWz1g27+8wDW6zUUMzxoHGKil5bB2JCtNTJqd/GId+B5js8m2zafJHrgdG2AoVG3r0e889oPk16lkLR4tbMnEixfsaum7tLGzSQqiqMqEWptltEhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789790641; c=relaxed/simple;
	bh=jIXpMWMqTfNbjfAnNvppdVl1w6ONaTpFaoUPTzfyVzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AQANF0ykfvmI0xLjwNvDWxPZ2HUeonJ3Ibqjj3KRe3oYUd9RzW3UxF6vzvkzrgTlSIZX6AhjixYePedJC52qWa3IPyi/j9xPn5mSo7vzMYv5BjLYDSViKmPGoN6DMKeWTyKp75mj99EfzYSFDUFxjtsKV66lCXLWHuzE2sH2QIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=OYG+AYYk; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="OYG+AYYk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Ht
	WSZWRMNX4bhHyHSQu4ttdFncL0psClFgEKMCNRY70=; b=OYG+AYYk953tdFH2NC
	6wiyrn4POGVoBRuxel/0JR/diD4Nwf8qjD0wCbva1JL9j3WOfvwnEzgOyCI4XAFb
	yRglavcV2kstxLF0H6cyrMeZ2eoJDnPUaM8VXTLX/W+ZCkUUGzXLrckUEqX2l4zf
	OHXpr3rIbgkxuziSmND08mIFs=
Received: from LAPTOP-BJS5C4G0 (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wAXD3qTCa5qcskdBg--.16979S3;
	Sat, 19 Sep 2026 12:03:39 +0800 (CST)
From: Heyang Tan <thy15333007817@163.com>
To: jeff.chen_1@nxp.com
Cc: francesco@dolcini.it,
	johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] wifi: nxpwifi: bound histogram debugfs output
Date: Sat, 19 Sep 2026 12:02:52 +0800
Message-ID: <20260919040253.590-2-thy15333007817@163.com>
X-Mailer: git-send-email 2.51.0.windows.1
In-Reply-To: <20260919040253.590-1-thy15333007817@163.com>
References: <20260919040253.590-1-thy15333007817@163.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAXD3qTCa5qcskdBg--.16979S3
X-Coremail-Antispam: 1Uf129KBjvJXoWxZr4DKr48GrWfKry5Ww1DAwb_yoW5Cr4Upr
	W3J3srZws7urnxJryDta1UAw1Fgayvva15Ww1kK3y7ZFnFk3s0qw10gayrJFy3CrWxKr13
	Zr90q34Yka4UXFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j289tUUUUU=
X-CM-SenderInfo: 5wk1ikatttiiixyrlqqrwthudrp/xtbC-huuWGquCZujwQAA3n

nxpwifi_histogram_read() writes histogram entries to a PAGE_SIZE buffer.
Each entry is formatted with sprintf(), so enough populated buckets can
write past the allocation.

Use scnprintf() with the remaining buffer space when formatting the
histogram.

Assisted-by: LLM
Signed-off-by: Heyang Tan <thy15333007817@163.com>
---
 drivers/net/wireless/nxp/nxpwifi/debugfs.c | 29 +++++++++++++---------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/debugfs.c b/drivers/net/wireless/nxp/nxpwifi/debugfs.c
index ccaf0eae3..fd738a811 100644
--- a/drivers/net/wireless/nxp/nxpwifi/debugfs.c
+++ b/drivers/net/wireless/nxp/nxpwifi/debugfs.c
@@ -211,25 +211,26 @@ nxpwifi_histogram_read(struct file *file, char __user *ubuf,
 
 	phist_data = priv->hist_data;
 
-	p += sprintf(p, "\n"
+	p += scnprintf(p, PAGE_SIZE - (p - (char *)page), "\n"
 		     "total samples = %d\n",
 		     atomic_read(&phist_data->num_samples));
 
-	p += sprintf(p,
+	p += scnprintf(p, PAGE_SIZE - (p - (char *)page),
 		     "rx rates (in Mbps): 0=1M   1=2M 2=5.5M  3=11M   4=6M   5=9M  6=12M\n"
 		     "7=18M  8=24M  9=36M  10=48M  11=54M 12-27=MCS0-15(BW20) 28-43=MCS0-15(BW40)\n");
 
 	if (ISSUPP_11ACENABLED(priv->adapter->fw_cap_info)) {
-		p += sprintf(p,
+		p += scnprintf(p, PAGE_SIZE - (p - (char *)page),
 			     "44-53=MCS0-9(VHT:BW20) 54-63=MCS0-9(VHT:BW40) 64-73=MCS0-9(VHT:BW80)\n\n");
 	} else {
-		p += sprintf(p, "\n");
+		p += scnprintf(p, PAGE_SIZE - (p - (char *)page), "\n");
 	}
 
 	for (i = 0; i < NXPWIFI_MAX_RX_RATES; i++) {
 		value = atomic_read(&phist_data->rx_rate[i]);
 		if (value)
-			p += sprintf(p, "rx_rate[%02d] = %d\n", i, value);
+			p += scnprintf(p, PAGE_SIZE - (p - (char *)page),
+				       "rx_rate[%02d] = %d\n", i, value);
 	}
 
 	if (ISSUPP_11ACENABLED(priv->adapter->fw_cap_info)) {
@@ -237,27 +238,31 @@ nxpwifi_histogram_read(struct file *file, char __user *ubuf,
 		     i++) {
 			value = atomic_read(&phist_data->rx_rate[i]);
 			if (value)
-				p += sprintf(p, "rx_rate[%02d] = %d\n",
-					   i, value);
+				p += scnprintf(p, PAGE_SIZE - (p - (char *)page),
+					       "rx_rate[%02d] = %d\n",
+					       i, value);
 		}
 	}
 
 	for (i = 0; i < NXPWIFI_MAX_SNR; i++) {
 		value =  atomic_read(&phist_data->snr[i]);
 		if (value)
-			p += sprintf(p, "snr[%02ddB] = %d\n", i, value);
+			p += scnprintf(p, PAGE_SIZE - (p - (char *)page),
+				       "snr[%02ddB] = %d\n", i, value);
 	}
 	for (i = 0; i < NXPWIFI_MAX_NOISE_FLR; i++) {
 		value = atomic_read(&phist_data->noise_flr[i]);
 		if (value)
-			p += sprintf(p, "noise_flr[%02ddBm] = %d\n",
-				     (int)(i - 128), value);
+			p += scnprintf(p, PAGE_SIZE - (p - (char *)page),
+				       "noise_flr[%02ddBm] = %d\n",
+				       (int)(i - 128), value);
 	}
 	for (i = 0; i < NXPWIFI_MAX_SIG_STRENGTH; i++) {
 		value = atomic_read(&phist_data->sig_str[i]);
 		if (value)
-			p += sprintf(p, "sig_strength[-%02ddBm] = %d\n",
-				i, value);
+			p += scnprintf(p, PAGE_SIZE - (p - (char *)page),
+				       "sig_strength[-%02ddBm] = %d\n",
+				       i, value);
 	}
 
 	ret = simple_read_from_buffer(ubuf, count, ppos, (char *)page,
-- 
2.34.1

