Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D996C1B4138
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 05:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787117597; cv=none; b=hNSecZpzlbzY9MRbbkD+JV77NesClZs2hXkuZ0Hso9mLuqKRmJJ2d/tFCLxD6XPex7rM+ka2LlYt36KPjFRskejmBn37XP6/tmOFgLn0miZ6u/j1dF6qNtpVYBInIv7zlAOgsJ3E+ESVo9LjqVBDlTnowkRnphP6dkZQK77eVW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787117597; c=relaxed/simple;
	bh=EmZHE81WAA2WSA7IBf7lSIvxURqpvQX/ag41CrUefR0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZJN0i+ZVEQxA3JvQ4FfV0fl91M+TCQHpotML+pEAgryst1JlE4Pjw/L2zjTDFZ5grebNwthJ/aTDmm3kGWpCj9h2rYyj/0CODDpzySF8rDJxDfWt08JPd3UX7OrKwY8TI/6/Wsdac/abxesB5+PJZqUhk2AV55ROHb19JWtAt10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PbV0+2eJ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=OzrkR2ug; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PbV0+2eJ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="OzrkR2ug"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67J5I2Hi3000174
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 05:33:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=JXSdA/m9q8d
	apbmxpgAkVziFeg/cZYAgdhW6EdHL4W0=; b=PbV0+2eJAngNfxZ1TWX3fEKAt9u
	iNXlP9pH0PSE7U27dZYHqRo9v8hMNt5Vz8dVRMtdr43tsZwNuFpbIwM/IytcHav8
	q+TEFbiVmeJerHFWEtZqmM0qKTGPWONSi7cGmfF5PGt+3xfIrxlvxA1tspMqXutJ
	JymLmHITFV+2x6QJY7P6eoFZsUrc7InQS0KedFxYaDjwh/IN70ieESC8P960DE64
	7CwFya/0UGO3R+ACedmaQ3ly1+c9NpEbhbo7ZPr/JYkigL83bf6mgRMJQuX75Vhk
	wx93yQPtK1lXTZK6R5yO11mHtm1e6rKoxE4zmP8Tx6L58sQwGMtGCrsVrWA==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g4yfkhgrh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 05:33:15 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38fa7b09921so1197053a91.1
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2026 22:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787117594; x=1787722394; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JXSdA/m9q8dapbmxpgAkVziFeg/cZYAgdhW6EdHL4W0=;
        b=OzrkR2ugU+CjVQMjs+8j+lPF98gokWoukIobLBVL8z+XxgCVONQEeOdWRT4cA9qmHE
         2psOEFTATueiB5pVSfPqiHcV9G3VcpvO1gbPmMHSOugHviUDBdi5Nqtohqfb+BbFK6KS
         dDaG+xfLLEBQwOERQMBVO9CGp/PRPXZc/smeA1NqSpZe3F75CuWJ/snPcUDyBdI3LuCV
         qjh4EejHnFCvPEQO8BdubIuKzcKncBfx5ywJDOsrjyKhdxRLifdJGXTgkZ6IkcUxXPjw
         iBsGjXn6m6YVQx+HlZkf9DHijdJrQ/05jPE7kUuDU0YPCC3klvPBizV0U4bOi4lOcwaY
         O19A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787117594; x=1787722394;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JXSdA/m9q8dapbmxpgAkVziFeg/cZYAgdhW6EdHL4W0=;
        b=Otd/0UB6X6Y4LvgqtUmqSH3Isn2jcoj2kfwhYGsxnn0520Lb4vfmFdSY1GiRW7bhKF
         lbG4nvOoef8EukMVkQW9zEg3d2X6Bq7wF963bxKCwVOIzWqLa81xBc+u+GwlC+HgiZqP
         Kx1H2XmTF2/961EWhioaesbivmlIetVT1wHL0gNzVCXK55e5KTrCSREKL/M0GXeRDmZf
         JGNSzje4DiFd1/6zZ1A9VedaSxoE6hb1y+ZMRKSm2XlnhBzapn1qZejO9HVLshrkrpMM
         4E1RwFbm1SoZ/ya8diBACl/DwRxQprmksazF6KSViS6E6JziGdn+Qybo0d1bQQ0VAe29
         N8Ig==
X-Gm-Message-State: AOJu0YwsKEBF+JGD+zIDEUMBlSjykSMe/hvhbgd+6SwjnvQZY0W7zvLR
	m3Tr8/z5DAwlx4RQ4mZrRKsjH1ZUErnIcJzLuzMBWBRuN7hk+3qfwYEXsfC4GBBqPh6Wdg/O6+7
	4AJ857Oo7gY3EG2UAKlbduWogLufyct07mCAcge3OI0/0xOw0+GFupHsYJ2wlDyFU/FUL9Q==
X-Gm-Gg: AR+sD109NLbPMVrQXjhk3AV7QoCXfwjOyeJuzhOUyUHD5Ip3SxZOXlMVXIg3P6s5dtp
	i414lbK+MdHpY9I5SoHhVObu9NDNehG3XUzqDxk+aFaj+p7SSCt0StltuUUpCy2wL+EB55sxRNI
	eziJcp4I+OqiUHQQFWkIXirf1S9rKKuz5XqJ5atU1WIU2lUMfJA2xjm/5wvdyNh+NVXkuxKL5xy
	5XKdX0JB9SVxLVE0CfLtjZKthq5lfmLEkBrHEz1+ZcermqXcsfLVDIwjOcVQFsnEPvL27WFYRdi
	8keNLOfV6Y6blphl3texOzshHh/kx7U0zPn1tdFgtRJGwlr6ut75KpW6QGxradGXwbUrd/MSHMX
	nPpVbz0wKn8yNxbv7HySV1NqddDx4F5nNQ8IgAGWVK+vo9pZtCn35
X-Received: by 2002:a17:90b:384d:b0:380:71eb:4014 with SMTP id 98e67ed59e1d1-395810cda44mr4056755a91.15.1787117594235;
        Tue, 18 Aug 2026 22:33:14 -0700 (PDT)
X-Received: by 2002:a17:90b:384d:b0:380:71eb:4014 with SMTP id 98e67ed59e1d1-395810cda44mr4056662a91.15.1787117593734;
        Tue, 18 Aug 2026 22:33:13 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957f4c9918sm404261a91.0.2026.08.18.22.33.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 22:33:13 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next v4 4/8] wifi: ath12k: add device DP stats reset support via debugfs
Date: Wed, 19 Aug 2026 11:02:43 +0530
Message-Id: <20260819053247.1420393-5-pardeep.kaur@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260819053247.1420393-1-pardeep.kaur@oss.qualcomm.com>
References: <20260819053247.1420393-1-pardeep.kaur@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=NoPhtcdJ c=1 sm=1 tr=0 ts=6a85401b cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=EUspDBNiAAAA:8
 a=_Iy9b4Js2nCRBGGyCYcA:9 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: qRaigv_q69_IkyqgmVRZ2XkNAy59ECDX
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE5MDAzOSBTYWx0ZWRfX6BIT7dEo/JDL
 aI8aUWvk4rRdnIyXimWAJ2zK9B4gFAfIGzb/tD4iyivyvRQwGZ1GGK2srKkxAqld8q3pK9/NEEN
 RNowkZ6PZK37OFzMVvusLYJ4Z5iwO7I=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE5MDAzOSBTYWx0ZWRfX6YTuLrLTmooq
 tNj9/v05Q5ZvgzAaGpfo0eajggs4ymVXmYvDHly7RkSt/QmB/as3ZQtwYQPjLvlAum4BNvWreYA
 dXKRSj+TpCTOvv+MIr7AOKhJSG/5MO/Xu6ETlDu2RMgLuuFV32TVchOOqvQ/e9JcKMth+6P/lkn
 fR6ZbSV29ENvpBEBshvwCp+GkvWVWbKtSnDzjqpyvL5GRe9ki+7A7m6iTspKZrL2ocr8ssYzUtn
 Mg0AXdOYSMeAopVglz/b+a5fIH5EhFhfmrkXpcGVMYobbYNgz/YkHVgQ6+ANWE/lV43Iz03T9NA
 BYMyyBQXz7yi+cUDMVbgurD2xU5lMVCfBia6mMLulc/QmLDJSuLTTyc09XWdoiziOEw5RJc+6gP
 bix0k4WkxgbQwuT/pn6XltT9bD/lJm+B0p5s4WlN47jq7VdxF4KQ4kiDjNiIlpcNTE97Jao4u6O
 pCpRamz3OUbYeqXiL+Q==
X-Proofpoint-GUID: qRaigv_q69_IkyqgmVRZ2XkNAy59ECDX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_01,2026-08-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 adultscore=0 priorityscore=1501 phishscore=0
 spamscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608190039

From: Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>

There is no way to reset device DP stats counters without reloading
the driver, making it difficult to isolate issues to a specific time
window during debugging.

Add a write handler to the device_dp_stats debugfs file so that
writing 'reset' clears all device DP stats counters. Change the file
mode from 0400 to 0600 to allow write access. Use
simple_write_to_buffer() to correctly handle partial writes and
non-zero ppos, consistent with ath12k_write_simulate_fw_crash() in

No lock is taken around the memset since the counters are updated
locklessly in the datapath; taking dp_lock would be misleading as it
does not protect device_stats updates.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6.r1-00402-QCAHKSWPL_SILICONZ-1

Signed-off-by: Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>
Co-developed-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Signed-off-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/debugfs.c | 34 ++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/debugfs.c b/drivers/net/wireless/ath/ath12k/debugfs.c
index ec49692107a8..68acb4cb9c4f 100644
--- a/drivers/net/wireless/ath/ath12k/debugfs.c
+++ b/drivers/net/wireless/ath/ath12k/debugfs.c
@@ -1220,8 +1220,40 @@ static ssize_t ath12k_debugfs_dump_device_dp_stats(struct file *file,
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
+	/* filter partial writes and invalid commands */
+	if (*ppos != 0 || count >= sizeof(buf) || count == 0)
+		return -EINVAL;
+
+	ret = simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, user_buf, count);
+	if (ret < 0)
+		return ret;
+
+	/* drop the possible '\n' from the end */
+	if (buf[*ppos - 1] == '\n')
+		buf[*ppos - 1] = '\0';
+
+	if (!strcmp(buf, "reset")) {
+		memset(device_stats, 0, sizeof(*device_stats));
+		return count;
+	}
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
@@ -1232,7 +1264,7 @@ void ath12k_debugfs_pdev_create(struct ath12k_base *ab)
 	debugfs_create_file("simulate_fw_crash", 0600, ab->debugfs_soc, ab,
 			    &fops_simulate_fw_crash);
 
-	debugfs_create_file("device_dp_stats", 0400, ab->debugfs_soc, ab,
+	debugfs_create_file("device_dp_stats", 0600, ab->debugfs_soc, ab,
 			    &fops_device_dp_stats);
 }
 
-- 
2.34.1

