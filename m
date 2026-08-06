Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921CB389116
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 12:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786018198; cv=none; b=bJ6U8qRNRJ/53iS3AjIdJdjn5Z7Mky00oe/g30KtkcqPSWCd5fCTtLIHZWbmyvEyYdVj+isH5y3mAloXC9d9UORQLq/NA9im4yPHoJjldEn2JAFsOSnjTaJI6/RQGi2s8qg3X918yKKT2kEhldnaymG2gBMWa6e91Qw737/xyZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786018198; c=relaxed/simple;
	bh=Nos9PmBDlRSlqKK9yIhV2JUoRxNyQBtaRS9UkHvyeUM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DK0JC3swwi9LK5+bSUGdVV6ZCE4RHWVBUnORAIZcgfYfctTWObDKm5Iwaz8PfKhm3g1UzmIPUPxgZGMQehEH5gM5bJxrqVSogETntTYBeeHQhMirCNs7Ro8Em9YYV0qFxMWW6bKYMxGARraj6+z3oPX05SbDaNzZAw2z7o6uyL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=AEBPcCUa; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=UcheFEfh; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="AEBPcCUa";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="UcheFEfh"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6769ndcj1308830
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2026 12:09:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=WfGjm0JB1ke
	59rn7c3qNVGhDamzhVdkvGmTOqnhyvnI=; b=AEBPcCUayOYg3mCrdXGgBV4+zWB
	LsETg89VdNaTvutjm/wV5HRvXLhFSDuAGNXcZ7ukEOmxkgFVR6W3MWCuDuPaw27X
	ECPn9RP4Td9xu76z3f5zFfDHBaIVnVtH3VIKOoQfxOVYS2OlHQZ+rYZfRRVVRQ+f
	Ltxt4b/rW+JRFFdw0/M+909SU3Rv0F1Pszr/PVbLZ2FagMEY/Z0Ak0udCXjBfx8s
	UWhLvtEZ1qZYC77nlUICjxPNeIex/bI03xg83VsntE/nQsKKVWcA06665d92p3k/
	Z4MiFkhu8mVkkEDPwmwashGDutAKO8Z4TYtHnUGHJ8LVrkCHUNLOOXbAY2g==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvp72956g-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 12:09:56 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38e667368f0so3485039a91.2
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 05:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786018195; x=1786622995; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WfGjm0JB1ke59rn7c3qNVGhDamzhVdkvGmTOqnhyvnI=;
        b=UcheFEfhwg4vIDghdoqfOKzT0XZoCcWubRRGh7WG0rlvT/5gARsb3TdFkIV515QiX4
         e9b0jxhVtnmtPFhDy3g9y4fuHd/s0bTsZc9GlfsimAyMcW76r1Fqza/KifuXMi/H7jh/
         gOpki/RTBdJ3e6O+CmVrIQo//VJ96bmHJB0Xx0q2Egx8alEchb8kbsLV80/XhZwcwwqv
         OSvC1We/vJBtVqG+osRMuaFvhnPmWcovd2wlzCtd3gu6EPnhZhWafRsys2biwQnvuE5j
         Pw1kwlgJHyaX1zc/e1dWSjXxdh8VV0MkjfR5ERXyhhYfEI3KxkR0WpHw3pFlniezlr4T
         76sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786018195; x=1786622995;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WfGjm0JB1ke59rn7c3qNVGhDamzhVdkvGmTOqnhyvnI=;
        b=oC6rH164VudZfOCxXkff8Oc8FwZuGkzNyzRb7FfXV4XiDCZT8rFC02gn6h8Sye/lmE
         3b8wdHP9Jv4tT1zyVLxMQhYJnyNY+1T0tCGbBvlNOgo5+I4Wqjqg7wlrqN4yhUM87fi/
         Myfpd/Phlt5vbVb8rsYPy0ymQBhxdD36uu8c43Orz6LayZRIkZiWV9uBOXw5MxqPHFxS
         +H0t3EusqHNZxMcoOltGmYlnbaYNF+HkyuEMMECw9+fOzEAngqN/oQBVKqAEEsVa/yG9
         /fI/XC1E1sLeqhHeiNJZZv18CIraWTP34ECR7A/e7iWGQoGhaycrlTZa38yjO5XuTyfc
         EBvA==
X-Gm-Message-State: AOJu0Ywc/AM0tekzElD4Wr0O2R+w5G8/fGCMkfOG10jggq0mJu9c/iHn
	Gy7SDR6xB4fLKDXL71rgIXhZqPzbx/T2kYyabUQzZsW7Ndtb7m1MreErFqK44J2XvxIb8mSgjoJ
	PJSHcidAFVgjLKuAoxTOvQOposaJAQ4A74ts3PIAxD36v5/SVJksPzhQ3SFVbfjn3ISq4hQ==
X-Gm-Gg: AR+sD11vRrdZL9g5syQhg5HeNjVQfGqYpIJJU/GyD/clAjJFzwPTww3Rc1yp+OVonDE
	iM/f2lgxuX0W3BjApqsTS3tumIbnxJj6HSjaLs+fL97lf+xZGMvyEO24fvO/IV39W+yI6JXd3TT
	zANA7RS4N9+nvPgTfR8BOU9rs51Z8doMuX/0Al+a4pnDA/JgthNEvuafRz57kGX//XV9LDyd6yN
	+FHKE5e2HmrGtZyQa7EiyLVDNLVWPe7UqSBdNEN6ZNLJMDyL0dfOwrfizlrlOcs2Ked/igDHQ3u
	TsUJgu9G72+OphDX6q54i+cWH0RC+mGCnNXioUfSYc2d1IubcXryNLplbUI/q594vbUXJfkFcSR
	BKjfSfDnlgDybg8hbRg0W+1brErT1H2E8DlMfhpITkdIXctlsQmXn
X-Received: by 2002:a17:90b:56ce:b0:38d:f94d:4c6e with SMTP id 98e67ed59e1d1-3903c5faa8amr15295121a91.17.1786018195021;
        Thu, 06 Aug 2026 05:09:55 -0700 (PDT)
X-Received: by 2002:a17:90b:56ce:b0:38d:f94d:4c6e with SMTP id 98e67ed59e1d1-3903c5faa8amr15295045a91.17.1786018194496;
        Thu, 06 Aug 2026 05:09:54 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39085db4a6csm1469079a91.3.2026.08.06.05.09.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 05:09:53 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next v2 4/8] wifi: ath12k: add device DP stats reset support via debugfs
Date: Thu,  6 Aug 2026 17:39:23 +0530
Message-Id: <20260806120927.3607733-5-pardeep.kaur@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260806120927.3607733-1-pardeep.kaur@oss.qualcomm.com>
References: <20260806120927.3607733-1-pardeep.kaur@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: ukV0bahsxWlGeYqfrsTBK7AfiH9aJjnz
X-Authority-Analysis: v=2.4 cv=JYCMa0KV c=1 sm=1 tr=0 ts=6a747994 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=EUspDBNiAAAA:8
 a=_Iy9b4Js2nCRBGGyCYcA:9 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDA5NSBTYWx0ZWRfX7+3deVuh4IkL
 Ifoe2WjE1m6mfsB7tAYOUHB6ux0QSpAZqWbXe770p7x6WXA6x1iqMUM7YZpStZfiyhqzygPMF3y
 D0jPSYXmQXaH13LDQreEhMLzrmtFie23CMzAjFn7+Vd24UM17SPP9Gaxevh1Zg0vyMirefMIuTK
 yO9FigzgCV3REEXUS2hPXTLt+8rOPGMpBKTzExUhjMNP860bcNZga7OZLWEi6kFhJZvEBdnC5JX
 L6CNutt9ALyNAYmV04J9zROUJAwowFV1KgxkM/oyVFEccabYmcbVzk7E/+wwmqwM8D68WWUUJ4B
 GPS6hRK4eA2RRLMDQfVkHmuNq9mEqeKy9z4V96FPQ+sfaJ40O8maPX+ZnsK4Wq2m+4GxyDdUQ7p
 phDEtPXX2Rp2YOOxVvdQelfT1yriS5QhI1HANOHz783lm2Bt7Zgox8W3IJvFyWmT/JE8WozrS/3
 eo8ae+1A0i6D9OOPMLg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDA5NSBTYWx0ZWRfX5xK+ERulYbFy
 IWIY3DN3ZwLUl0n71LsC/tgUvsYX16IwLzv1IZrO/1aSoQTXDgTjBndvXUIWn29VX3ItFtJ1CW3
 B/fRqsflDwfXPPIpuajLRUJMkgyxXq4=
X-Proofpoint-GUID: ukV0bahsxWlGeYqfrsTBK7AfiH9aJjnz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 priorityscore=1501 phishscore=0 adultscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 suspectscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608060095

From: Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>

There is no way to reset device DP stats counters without reloading
the driver, making it difficult to isolate issues to a specific time
window during debugging.

Add a write handler to the device_dp_stats debugfs file so that
writing 'reset' clears all device DP stats counters. Change the file
mode from 0400 to 0600 to allow write access. Use strcmp() with
newline stripping to match the input, consistent with the existing
pattern in debugfs.c. Return -EINVAL on unrecognised input.

No lock is taken around the memset since the counters are updated
locklessly in the datapath; taking dp_lock would be misleading as it
does not protect device_stats updates.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6.r1-00402-QCAHKSWPL_SILICONZ-1

Signed-off-by: Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>
Co-developed-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Signed-off-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/debugfs.c | 35 ++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/debugfs.c b/drivers/net/wireless/ath/ath12k/debugfs.c
index ec49692107a8..0e446a666f4c 100644
--- a/drivers/net/wireless/ath/ath12k/debugfs.c
+++ b/drivers/net/wireless/ath/ath12k/debugfs.c
@@ -1220,8 +1220,41 @@ static ssize_t ath12k_debugfs_dump_device_dp_stats(struct file *file,
 	return ret;
 }
 
+static ssize_t
+ath12k_debugfs_write_device_dp_stats(struct file *file,
+				     const char __user *user_buf,
+				     size_t count, loff_t *ppos)
+{
+	struct ath12k_base *ab = file->private_data;
+	struct ath12k_dp *dp = ath12k_ab_to_dp(ab);
+	struct ath12k_device_dp_stats *device_stats = &dp->device_stats;
+	char buf[20] = {};
+	int ret;
+
+	if (count >= sizeof(buf))
+		return -EINVAL;
+
+	ret = copy_from_user(buf, user_buf, count);
+	if (ret)
+		return -EFAULT;
+
+	/* drop the possible '\n' from the end */
+	if (count > 0 && buf[count - 1] == '\n')
+		buf[count - 1] = '\0';
+
+	if (!strcmp(buf, "reset")) {
+		memset(device_stats, 0, sizeof(*device_stats));
+		return count;
+	}
+
+	ath12k_warn(ab, "unsupported command: %s\n", buf);
+
+	return -EINVAL;
+}
+
 static const struct file_operations fops_device_dp_stats = {
 	.read = ath12k_debugfs_dump_device_dp_stats,
+	.write = ath12k_debugfs_write_device_dp_stats,
 	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
@@ -1232,7 +1265,7 @@ void ath12k_debugfs_pdev_create(struct ath12k_base *ab)
 	debugfs_create_file("simulate_fw_crash", 0600, ab->debugfs_soc, ab,
 			    &fops_simulate_fw_crash);
 
-	debugfs_create_file("device_dp_stats", 0400, ab->debugfs_soc, ab,
+	debugfs_create_file("device_dp_stats", 0600, ab->debugfs_soc, ab,
 			    &fops_device_dp_stats);
 }
 
-- 
2.34.1

