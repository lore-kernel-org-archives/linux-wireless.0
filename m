Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C369243802B
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 10:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786010860; cv=none; b=bTIhUtmbTmCuZokAQ460qoMcQj0fdrfmhwe2rZ96MF6/lXIFUA0vTsXbpmB6yDrpT0h4q3jMspCoJRmXVEk352eIaXW/ndwTkNgHsyllSNd0ZN+hnKwgmRna6R/4jBs+mt6Nx2WUqFbupFDJGsd4QhtBOevA9FgHFeFw2HEDSO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786010860; c=relaxed/simple;
	bh=Nos9PmBDlRSlqKK9yIhV2JUoRxNyQBtaRS9UkHvyeUM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=X3Hu5c+nlD6yxgg2Fd1Gjs2MpBIfGDIfB8WO5zUoV6rLT0SLJpKgyrxKClRKI2Ca8u7/U+BzwgmJos75bxDoNFUYABTodHu9hkjrPNc029CQ0gRc97LEIdemTQ4yYeDFwWQN+VuM8Yrdujkcfbul5prsNBdD6qvnZbbIW77FrRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=TmLBIQ6I; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=L1YnBiRr; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="TmLBIQ6I";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="L1YnBiRr"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6769ncqj1308822
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2026 10:07:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=WfGjm0JB1ke
	59rn7c3qNVGhDamzhVdkvGmTOqnhyvnI=; b=TmLBIQ6Igeip0mPW3YDrjZcm/Kw
	8cj9dN01JPF8uRIBOv8Z/N0orgPeY6vbFYo7hzPxr+EZI0lQiisac1tLA/iWhNMp
	z/xAC81IYZuhu1GpDQyWbnkJxXN7s/vKpi0UwAhauY09hVoQNlWOcCwVxOgU8N6+
	1Y00PWYLf3zvgJFsrZg27oDApzL9UwBj3VeCtf4Po8Y+m+ID2CTItk0VTLoVnBZd
	5yuSUdsBUk50oOnK/ZvWAdK8u/GNdZgZf6IeQKx55Xgq2esknYLXNoMkng+7czuB
	/HdQDB70VU0e51QOrq9i3KLwZxw+f6dKiG/lGnQlUjvD4emwR448GezHtwg==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvp728jxu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 10:07:31 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cfc52ddc55so26374215ad.3
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 03:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786010851; x=1786615651; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WfGjm0JB1ke59rn7c3qNVGhDamzhVdkvGmTOqnhyvnI=;
        b=L1YnBiRrbNfsvBaTet5FQ52hKno6W1ICbTUM6j2eBLzBgmDAYlIF4n0w4b+ShBXIur
         vq9RlXWqfLs1X+1M2lV0TxQSwEvcD07qxBBl7Dbv1HRNuTlOfbNOSRMPMiLFFaHTirkm
         DfMaysg2cNFC9EYPHbzuPzZ3NeJWa8v3KdO/OIWFqNUPbDep2HOCbhFp99Xic2CKV5uw
         iux9B+isQZ/VuwSCNTnWt7hzys6iHtJ+qndZoFIXkUboBA4EkQNVyLqf24g6rmDsSbA0
         dSiawQFaDHgvChmEIyI1xfV+ZDcLR+Re8NPHElNnrhgKdGiyWploAoTk7X2imDjXPzIz
         Ttug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786010851; x=1786615651;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WfGjm0JB1ke59rn7c3qNVGhDamzhVdkvGmTOqnhyvnI=;
        b=aB9cGeRzqPwB9ckWb9gzYz8hoGXeBpM4rO4+w67r5bqltcZDX80G268e6sQIlQA8GR
         057tY4hmS1pTfuN4t6ZUnNO4RVCTlP4JLxGIvK8/Pm8yCnkIEBW+/x86zTZUzh7v/k7I
         TkAb5iwu4V9ArdB1tPMGDf+P1ZvpwOimwVhysMb+SaDH1NdENNMiu6RXVS7NK5oXe0O6
         +Mks181RcX8egbOPQPxHsk3YsrXr2MUB64d95zFhHBHFZXWGpk0k/Ltzq8XKNqgDYcmr
         m02Z86K2JPSDSoFKrTVCUvYtUZYFJR7i2VtFkyS9qxFzhshbJOs520cAi/ux8A83ox66
         rptA==
X-Gm-Message-State: AOJu0Yw34L2jNppSphzabQBFKiaArppzSrCCKioTOQB5jXU5MLqx+0LT
	LJLa/ygLrJEZXrZ+mO6jKWU/dPul7rLRNhUB/XAGJaMLl5/1EbnrRHgmMHWpkn6VMtT/OOaOPUb
	nWUqNuCiD5TSEHhgzuAQUa4G1zDFKuKrsS4WG6IYxHywKSiSYV/DLeCh0EQCIqHJQ1FLaa22Erw
	hz3g==
X-Gm-Gg: AR+sD1104lnckGJX8HaI/aUamRiwwGwccRgf5KuHrAOYuNu9PAle4dsGE0TrmqbUdVD
	3U5iBWCnw5Jy/uiibrrMCBJc64ojAVeghwNU+xMmdrnx7uiqwDax1+Da/ft7gei5v+kh9EPKVNK
	SUG4qne3wiT+ZU7QFW+1esLy6EYNOuN6FkDDS8vcrjrcUdSXSRpEuwdMvhw1mFQ4YK2oHXi9lVs
	3pUSGs04aImOXO6vMTuq8UbbmPEH9sI5FMm9T243x5PkPijn6pxKtx5qf3q1ChdJrVQqxtnAxrq
	2wE6ga3rlAKv4y236jAlYaloSPeBLIA++Z9oC6+NvPZuLDSVGAyKe8ZxgOu4GowbAya3o6MP1QR
	dDfDbJALuDbZsTtjPLrxYnf+jI42d7jU7HAqXUHwx6+W3CL6nmVy2
X-Received: by 2002:a17:903:287:b0:2ca:660:b1d with SMTP id d9443c01a7336-2d106da93b5mr1009035ad.11.1786010850654;
        Thu, 06 Aug 2026 03:07:30 -0700 (PDT)
X-Received: by 2002:a17:903:287:b0:2ca:660:b1d with SMTP id d9443c01a7336-2d106da93b5mr1008675ad.11.1786010850246;
        Thu, 06 Aug 2026 03:07:30 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d0b6fbf2c6sm24027115ad.34.2026.08.06.03.07.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 03:07:29 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next 4/8] wifi: ath12k: add device DP stats reset support via debugfs
Date: Thu,  6 Aug 2026 15:36:58 +0530
Message-Id: <20260806100702.3479326-5-pardeep.kaur@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260806100702.3479326-1-pardeep.kaur@oss.qualcomm.com>
References: <20260806100702.3479326-1-pardeep.kaur@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: OBTCNPe-0Tv5RlCngFEkOe9ol2ruaJ8k
X-Authority-Analysis: v=2.4 cv=JYCMa0KV c=1 sm=1 tr=0 ts=6a745ce3 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=EUspDBNiAAAA:8
 a=_Iy9b4Js2nCRBGGyCYcA:9 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDA3OSBTYWx0ZWRfX3TIUyJSnU4j8
 iPkU0sOv7gaezgs0TiirOFlhv3a9Ldj19TpdnjkXHI4rV9j8I78cWLVGGTeopaesbRIPoujGDzi
 ZX69NIriTFwrfbeB3i0y30dPF6FEyQgpEEgjTV1eIToGulZHY4H36JaAQrQrMt10fAdJrtkZFfZ
 AG5UG6MgIuY7rhRYBlqg1iDQ0ANyVkDBFE0XfVsZSfYlZGilTnOV1OEzA5nfYD5rdqV5QEwCO1f
 NEQl1tWQBjIdb2ZV5xIMFgbxcGgdgL8qTljW04csAtQOgZA92bhQV5pjRz+APqU2V2ea0iKIL0a
 NS+8pnx6hpb4zxD0YCFjiNlH64AqwGNQkO3f8RsVZUuB7Xgfm5Vqeillxf5OrOvVaSZZSXVPshP
 fip/v+W+KSm0UtpoppGV1FvzGGu6Br2Ly1cmbTWUHDUXhwzsbL3eBdogRG1+iSAaPG6liX14n/g
 Q5kvEutdkElAd20/a7g==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDA3OSBTYWx0ZWRfXwN95JPtTCX8k
 igPmRrWp/v/FGIzETH2yE04BYLDg2sawTEkgjgovjaDahIIVbWAezEDS3IF0PSJDqgmwR1XoWzQ
 bQMawS6742Og5laPa9RiA2uwv6zYmlw=
X-Proofpoint-GUID: OBTCNPe-0Tv5RlCngFEkOe9ol2ruaJ8k
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 priorityscore=1501 phishscore=0 adultscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 suspectscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608060079

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

