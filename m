Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43EB03FE36D
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 18:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785003116; cv=none; b=Y78K4vEQEJzIc2FEqb6v8+TbKKiG7Em4o56TuUoVF0PnyLcp+V3ej4fkz+Z02kuWlvLa7G2OMVaU3jNOu39wd0DCnyhsxKygmMe+r7dJ53B0WS67PeqR+Fy9vVo+8DUM1Os4vyQrC5yIdUT/pUfRT44zQgc+1SDrx6cyAbnupew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785003116; c=relaxed/simple;
	bh=JQSnlNO/PEx6fax5+CMawUnUYx7GOpw9n3z/aV+183U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QG6cUQcCRVtLn+iM86L42B/5javaa42wNlDrO8IGgxFqFFfH/91GCt23TYKM9P0Oai7IL1M5u3qYsi0iUGmZhFSIxBSxCXBzGWkxPyJ7+V07zkJGqORxVVdvCLQMBGOgfVXJCX2uoOgPkO45fkhsKQegBG6wbLusQy5sGGxJcdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=MVxezweS; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jv7CdbvX; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="MVxezweS";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jv7CdbvX"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66PGvC0H1974796
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 18:11:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	1nx9ftBvzkJRdfVo/u4AmKjPWikvN0dHE7MjZ+firGU=; b=MVxezweSTthbYFLe
	yaWTq2MIoa9JIG8i32UpCp43VyfLRWwjVk9elK9CHL2LnIqAxYu9Sjz+LMgTkN4y
	re9zHe8kD4UJzo/4+2+R1qekUasoa584pHwkEajm7G+jsdWy0YL3abEcuXwdKA6r
	PKu/Z0Xfj3cSHA8wzcQX6X0Xx77GmuTpFBjRMFKC0GWSOfwDM17qd/3RxxRMatoO
	F5T/0fNsCNzRpUu1FT/w58BXIlg8S0ZYq2KGemI9tqlbMcoFldo+Ilv+839bYOXC
	6v6TKkyr+GbP3f8Fi2gf3S0uFGxzMR3oxPCTWR5XY2bza/jJF+0VpVb1FPLKPr+O
	FN1G4w==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fmpajh8yh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 18:11:53 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38e2f61c09dso1943083a91.2
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 11:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785003113; x=1785607913; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1nx9ftBvzkJRdfVo/u4AmKjPWikvN0dHE7MjZ+firGU=;
        b=jv7CdbvXaeEfOZIocsAueX1VYPKQEt6wPLNVh5l1GOq1l1XK7PVZt9lLeFpjw98UKT
         iyOyRlGQDhPKs170tgorggvAKOg4EFmidVURk4WdnJrKqVKhYXA6Rmq50rJtT8XTD3+T
         K4WsWkX36l49qX/+5EqNMIohmZh9213aV+JrMAG09HyIT0mfoS/ugJ7+K37N5MKj0zAZ
         XLFBR+/G4P1vKU8o6l2FJMOhFci9gEpHOcJGqLaKbckMS0UGNnAMIenllKXtU/Q+KuO3
         fMfMfVNPRu7Mbdge8KDfry9qTBVN7IjVw4+TAF788qbm6RNfkG115eIxclLWHiQANR8p
         +V5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785003113; x=1785607913;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1nx9ftBvzkJRdfVo/u4AmKjPWikvN0dHE7MjZ+firGU=;
        b=IT0zPbJxWFrqkhMMmZ2vAS7/F2s9ewValkKinn1BQ2Bdp3yLDilcjnTfwW2vxP8Pe5
         hGmmXVv26LAnAfJCASmT4w7Wv7vYK+kI939VqUxqMvIZByc1HNX7JJhRkc0r519H+Z2i
         H+3KX8LfVGCdCY4bRyFhLh8OmQF1bUZ7GPs/Vj+2gJnreaPeJ7v+7PJezZZWgmXZ8rr3
         mkaihXgm/f0XW+eOiirPkLjg7HzyvoM6ui2Z745KcXfw9k2yWZMYbiiFHC02NLjCCu4d
         snAWxP0+KX3VWuLGL9/XHYGn/PkSYo0NG+Vb5eC2cVF5Rb+Q2oSjfqIuWVNcZDoFYdvW
         xlTg==
X-Gm-Message-State: AOJu0YwhPSarQJsWf2iVSNXi1uFcqYnmLJDB5yLyJTz8Seclz8XCbz0O
	3f1YQgoAsfPVuAT0Q3NCeK4YCSqh8nQB0QczyGg1vtvsCIxJL0T/B6T7ctqmQokRAmWJwgucCO1
	gOLY4T/PPdz2fw0SkumXZQpYQt2dBZL/2Me2XCi2wTJlDLUM5TTl0DMSpUeD2U/nA0veOMcSNAx
	ggPQ==
X-Gm-Gg: AR+sD11xFA++VyX+nKcBA1FLAIqIc5VXXxmyU+FgdciBhM1u2YmyFC2+r7ROKSMEDHm
	kUIQ68X0wAWrsr7bMVisgwDjJXWwprMLb2b1hfB9nU6+HQ67GfAMyq9jqpBM6+IlCMbL5VFHqIL
	lGl+qedAcOaJjSmyx7qjflvlrxFCQTKm521XUwtDzFYxNuR6+t/Zq2Iezk7iVk4BJv3FBINDPtb
	tpjLAEzx6bNwhkZqyUSOM7oOpfmXDZrdg5VcM1s1a7zlAiUusyePFut7sPd8fXANStsktXb9vVe
	RaZURR4svJgWGnd9iI5C9w/2jYwH7i+NFJ6wKpEmtFptczeQGMjahi0hV5aihl96INdRfEKXdW2
	C1Vxd8+j8Gkomz1bWiYlYyO/5a+WGiLrx+a8Oz3SLioK4TJBqQroD7JI=
X-Received: by 2002:a17:90b:184e:b0:380:9504:9780 with SMTP id 98e67ed59e1d1-38f2977882cmr2975766a91.29.1785003112812;
        Sat, 25 Jul 2026 11:11:52 -0700 (PDT)
X-Received: by 2002:a17:90b:184e:b0:380:9504:9780 with SMTP id 98e67ed59e1d1-38f2977882cmr2975747a91.29.1785003112333;
        Sat, 25 Jul 2026 11:11:52 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13d13003f12sm64692635c88.2.2026.07.25.11.11.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2026 11:11:50 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Date: Sat, 25 Jul 2026 11:11:46 -0700
Subject: [PATCH ath-next 2/2] wifi: ath12k: rename firmware_mode enum
 members to use QMI namespace
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260725-consolidate-firmware_mode-v1-2-aedff0ce0ba5@oss.qualcomm.com>
References: <20260725-consolidate-firmware_mode-v1-0-aedff0ce0ba5@oss.qualcomm.com>
In-Reply-To: <20260725-consolidate-firmware_mode-v1-0-aedff0ce0ba5@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-ORIG-GUID: w07nGY5irIX217L2gIbpTh7EUKbvOgkm
X-Authority-Analysis: v=2.4 cv=A8Bc+aWG c=1 sm=1 tr=0 ts=6a64fc69 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=qg84H81dDRxm8dBP63MA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-GUID: w07nGY5irIX217L2gIbpTh7EUKbvOgkm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI1MDE3MyBTYWx0ZWRfX8LaKvmeMUahd
 j2O0k1zV3bLzcc8FXmQvO5DQYkEzKdbS5R7Ny3mh99z/dJbOs/9JogszAEUJuJ7y//o+9q2kS2z
 UZkqjv4VbhXYlCvUMRHj/PHHKygvPjFN4aio+vBMmvmONP/c9mU4VjOxK99Lcx5oE4/OxwzxbGB
 QCUYgAtbSSh2c5nV3ZxxoyGVOSRyIOZ5/9uH8ufjVvNOKsY1gXLb8Q2S1KPj8vqi8l3bmleiwE3
 YlMFulAhGngqiHZEeUFFqj+G659MVtnoTpaAOVayiA3Kg18ch6Y9/tsT8S09u08AqqqlizwVR/P
 XVVm0czgXrR6Q5Js0rb+fN70eRE+tiVgCDl4r1TqSSgkgE/7gIRaO04x95fBXln7NNVrXrONK64
 AfJsKThVZdv6GAMEjndM+U51BdaS2l2bliA0AHx+lVtWI6ngXjHo1Kkw/I/UAmjb/7OFNiGTk2t
 I3jKLiwbhKJRasA0jIA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI1MDE3MyBTYWx0ZWRfX3+3yKc1F3tYk
 Q1fYSmEcKvxWmjEtHT71PQKokz6U7lSBRWki452HoJPOOz/smqTe+XVwiAihqcqOqNFkxVIulNC
 JaZBUEShp+/UYBdAklKDFv16v9zB40s=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-25_05,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 bulkscore=0 malwarescore=0 priorityscore=1501
 impostorscore=0 adultscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607250173

The enumerator names ATH12K_FIRMWARE_MODE_* lack the QMI infix that all
other constants in qmi.h use (ATH12K_QMI_FILE_TYPE_*,
ATH12K_QMI_BDF_TYPE_*, ATH12K_QMI_MEMORY_MODE_*, etc.).  Rename them to
ATH12K_QMI_FIRMWARE_MODE_* for consistency and to prevent a future
re-introduction of ATH12K_FIRMWARE_MODE_* names causing a silent collision.

While here, add a comment noting that values 2-3 are reserved by the
firmware QMI ABI to explain the gap before ATH12K_QMI_FIRMWARE_MODE_OFF = 4.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/core.c | 2 +-
 drivers/net/wireless/ath/ath12k/mac.c  | 2 +-
 drivers/net/wireless/ath/ath12k/pci.c  | 2 +-
 drivers/net/wireless/ath/ath12k/qmi.c  | 4 ++--
 drivers/net/wireless/ath/ath12k/qmi.h  | 8 ++++----
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
index a052a77828f3..d023c646478f 100644
--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -795,7 +795,7 @@ static int ath12k_core_soc_create(struct ath12k_base *ab)
 	int ret;
 
 	if (ath12k_ftm_mode) {
-		ab->fw_mode = ATH12K_FIRMWARE_MODE_FTM;
+		ab->fw_mode = ATH12K_QMI_FIRMWARE_MODE_FTM;
 		ath12k_info(ab, "Booting in ftm mode\n");
 	}
 
diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 553bcad0b5d0..6ed1f5502507 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -859,7 +859,7 @@ struct ath12k *ath12k_mac_get_ar_by_pdev_id(struct ath12k_base *ab, u32 pdev_id)
 		return NULL;
 
 	for (i = 0; i < ab->num_radios; i++) {
-		if (ab->fw_mode == ATH12K_FIRMWARE_MODE_FTM)
+		if (ab->fw_mode == ATH12K_QMI_FIRMWARE_MODE_FTM)
 			pdev = &ab->pdevs[i];
 		else
 			pdev = rcu_dereference(ab->pdevs_active[i]);
diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
index 907d29b1020c..6441927b5382 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -1556,7 +1556,7 @@ static int ath12k_pci_probe(struct pci_dev *pdev,
 	ab_pci->ab = ab;
 	ab_pci->pdev = pdev;
 	ab->hif.ops = &ath12k_pci_hif_ops;
-	ab->fw_mode = ATH12K_FIRMWARE_MODE_NORMAL;
+	ab->fw_mode = ATH12K_QMI_FIRMWARE_MODE_NORMAL;
 	pci_set_drvdata(pdev, ab);
 	spin_lock_init(&ab_pci->window_lock);
 
diff --git a/drivers/net/wireless/ath/ath12k/qmi.c b/drivers/net/wireless/ath/ath12k/qmi.c
index c466c3ae793a..280e50a1f31d 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.c
+++ b/drivers/net/wireless/ath/ath12k/qmi.c
@@ -3460,7 +3460,7 @@ static int ath12k_qmi_wlanfw_mode_send(struct ath12k_base *ab,
 
 	ret = qmi_txn_wait(&txn, msecs_to_jiffies(ATH12K_QMI_WLANFW_TIMEOUT_MS));
 	if (ret < 0) {
-		if (mode == ATH12K_FIRMWARE_MODE_OFF && ret == -ENETRESET) {
+		if (mode == ATH12K_QMI_FIRMWARE_MODE_OFF && ret == -ENETRESET) {
 			ath12k_warn(ab, "WLFW service is dis-connected\n");
 			return 0;
 		}
@@ -3623,7 +3623,7 @@ void ath12k_qmi_firmware_stop(struct ath12k_base *ab)
 
 	clear_bit(ATH12K_FLAG_QMI_FW_READY_COMPLETE, &ab->dev_flags);
 
-	ret = ath12k_qmi_wlanfw_mode_send(ab, ATH12K_FIRMWARE_MODE_OFF);
+	ret = ath12k_qmi_wlanfw_mode_send(ab, ATH12K_QMI_FIRMWARE_MODE_OFF);
 	if (ret < 0) {
 		ath12k_warn(ab, "qmi failed to send wlan mode off\n");
 		return;
diff --git a/drivers/net/wireless/ath/ath12k/qmi.h b/drivers/net/wireless/ath/ath12k/qmi.h
index 27b69847a15e..6da10f3cb597 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.h
+++ b/drivers/net/wireless/ath/ath12k/qmi.h
@@ -603,13 +603,13 @@ enum ath12k_qmi_mem_mode {
 
 enum ath12k_qmi_firmware_mode {
 	/* the default mode, standard 802.11 functionality */
-	ATH12K_FIRMWARE_MODE_NORMAL,
+	ATH12K_QMI_FIRMWARE_MODE_NORMAL,
 
 	/* factory tests etc */
-	ATH12K_FIRMWARE_MODE_FTM,
+	ATH12K_QMI_FIRMWARE_MODE_FTM,
 
-	/* firmware offline */
-	ATH12K_FIRMWARE_MODE_OFF = 4,
+	/* firmware offline; values 2-3 reserved by firmware ABI */
+	ATH12K_QMI_FIRMWARE_MODE_OFF = 4,
 };
 
 static inline void ath12k_qmi_set_event_block(struct ath12k_qmi *qmi, bool block)

-- 
2.43.0

