Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF96475356
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 11:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792149847; cv=none; b=qWaK9kwD7/98NBSKil7+bwwBnVm1z0J6uxJZdM6ABoAlnKNQjpHgc5As5tiHEj1Rdz2GoqQXZ2ShQ/vTLH3oqieNkNgBU3BHH/ccXuffMloYTSR36epT/IVvIKigtjf4Nr5H0QMKX604jR139d3Nm53OCzQBiNiEy3kii910g5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792149847; c=relaxed/simple;
	bh=93ufhYOiLuyUD74QPZ2sf8q18rw1bsl/SNae+3jX9rw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=baH7zJBthks6I2ULdjd0bupUt3bnT53UCk8dUE2ttMmtoLDrk7rlZHo6PwleuDkAdWmU+BnKlZYfFIAlPgH0snGE0mzZkWy1K5ZWVMod6ypyN2ylXUqNYoolwjlOB9AXycoyCnnz0T5DnAhsQdGIc7V7WwgvtJYcAVGSw2qs+A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=gBXGqNbz; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=aU+ypoIe; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="gBXGqNbz";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="aU+ypoIe"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69GAACCv1946429
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 11:24:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=Sue0K1r/0IfYxGQ4qyY1WgHNHZN4Dy5KY+3
	1i3C02Gg=; b=gBXGqNbz6FgTYmO33eYcO4uwEUf3iDWcuvgw5j8vb2n5pJX39n5
	BXgz59pOw/EXoopI2TeVGfWKDr14b9W1cVI8t4mI3SYmQjd+ahMoJY8fCOp2PRPV
	MOfJbCj2icfA2nW2CVCuav7AyUbCj0lR7kIQivBP+gZWClAHFB1ipMKgpsFbzeTf
	dwARh/ec2NImfrMdjuPBaS4N7od/dNr8ql3wIT61hlsemcgK78Xv4NQbMJvVqHnm
	lUzPMbX1EzlV6/nm2iwZUwrClkIQH8U9Bmke9yvUOlrEFEpK7KMM/r+29QpEyILJ
	eK9Tdmt5KfxbUyum/mNELP24mQzycTHe8sA==
Received: from mail-dl1-f69.google.com (mail-dl1-f69.google.com [74.125.82.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hbg5yrq5h-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 11:24:01 +0000 (GMT)
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-155a75f91e1so949752c88.1
        for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 04:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792149840; x=1792754640; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Sue0K1r/0IfYxGQ4qyY1WgHNHZN4Dy5KY+31i3C02Gg=;
        b=aU+ypoIeg6l7szg4WYQIANdSemPOWF/Atl6VEI9AbxDGypdWuuaqeQ4N1zFIK0mYkw
         A2pOTMrZn08hKrPqySM8/hERg5+QAcGrB4O47Ayeu8uJXcFuMZTlgYBX/+W3z7pYlt9O
         +zsea2rzANpdf62IDuo9uWSxBW/B+ajKu5yF2PAPS7Be5e9b9F8QGmSCLQh6hqCVofVS
         yu2oUP3YY4xNM93o7MO92IgB0QmCLjNBLBk1ltVOecoQqLlQ7kKRTpv68iw5pNNAY1nk
         bffAOwl+OLhUDeNmsLeT/qc1+CTXsBrnMrAUPD/nB0BReFmH+MTyJETqCgENFVIEDAc2
         KXCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792149840; x=1792754640;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Sue0K1r/0IfYxGQ4qyY1WgHNHZN4Dy5KY+31i3C02Gg=;
        b=BPokCDczoykhykFo3FpRw5LzPlSMQmuQsDlWiPj88oPAp6ebhoXk8bx62PwBI21wvN
         wEdypmAtvblDzWA5an6KEM4I3fw+A+og1t2A0pJOOS9sPm9XvxvPKe0r3EM8cZ+S6q8U
         Ip7NFwjQBMBMJ4Hl3Jxs2KD+iqeM1+kC+NghH6hhCb/K2MJzVS6yfVfRVRN0jVO7J4wh
         m2S2t+R4ty/TwZUpFDT49BZmhP8H4yJKpuLQpPhwzOo7f7pJK0csQQN82MY+sLZ7E3kP
         DjZM5QHIIvMCuhdOmLUpF1OHWonIgy6m+75NEbB5pJIj7A8IKQB2P5NQJ9mWK8Ickkee
         +fKw==
X-Gm-Message-State: AFq9FYK8RUMJdSO1FqYyiU48TAmmQhH/d/+ar4jEiMASYd68Sw53OWqv
	OK5GKedyBBpcES+IMzxW+JuxQmIaz6XnPk795pPxL9PXeiYNmKg0kmiao/E1h+LGpccr0PIyXuN
	FxDr/MAMdfolOcDSe3+EOhkjx94jgt6pTAOvI6q9AYsun1jZ/8tzggQJF85sEKyC4m5rScw==
X-Gm-Gg: AYBFou2X1M5JTtcnERyPh18N8IFUMOOU5yn4g+JPUGu/zNhs91/2w93ZaaL7w8SX0aI
	TJ0oBeYYdijro/UG0oCMFK7oD0nYV54zfwEJDs4tA6MHJkrBUy8NN/ie20Z3d20fZdHSdmDeBgU
	bUsM9FHFsUkOQ/roAhLZXSUVLmUCBmrFPatqGf7WVYSGlqUz2gQDBdeLIFqwK4Vt+Bfpq5spy3M
	6hSJ5SrhXs/A11gp7gSoBV/OMReF3HZRafKBQKbe/sedpgQ742JY5WRxcYMD2gnychTfpzHv3Kd
	cQG+h6uZI7icYAGJZbEQWxVLvBFWiDsK/RAHjKOAvg9EA6mjAZz17FrxQGqa21rAMGAX0NR0g5/
	k5oyDhLaQeYw+3b0QYgLUohEO2c0GPdYl
X-Received: by 2002:a05:701b:4504:10b0:182:c472:b123 with SMTP id a92af1059eb24-182c472d135mr2637381c88.1.1792149840286;
        Fri, 16 Oct 2026 04:24:00 -0700 (PDT)
X-Received: by 2002:a05:701b:4504:10b0:182:c472:b123 with SMTP id a92af1059eb24-182c472d135mr2637343c88.1.1792149839634;
        Fri, 16 Oct 2026 04:23:59 -0700 (PDT)
Received: from hu-daizhuan-sha.qualcomm.com ([114.94.8.21])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1831b859142sm5190104c88.18.2026.10.16.04.23.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 04:23:59 -0700 (PDT)
From: Daizhuang Bai <daizhuang.bai@oss.qualcomm.com>
To: jjohnson@kernel.org
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ath12k: pci: encode qmi_instance using QRTR NID bit layout
Date: Fri, 16 Oct 2026 16:53:55 +0530
Message-ID: <20261016112355.1108488-1-daizhuang.bai@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: UADR1Pisc8FpcPFIQaXe-3I9VrbyhX0s
X-Authority-Analysis: v=2.4 cv=M+HYuCws c=1 sm=1 tr=0 ts=6ad20951 cx=c_pps
 a=kVLUcbK0zfr7ocalXnG1qA==:117 a=Uz3yg00KUFJ2y2WijEJ4bw==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=EUspDBNiAAAA:8
 a=1poW-r593qKSufNXtKQA:9 a=vr4QvYf-bLy2KjpDp97w:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA0NSBTYWx0ZWRfX0F/kInpKccVp
 iYyUgxbXGCUSFcvWGuGHzmVq23bjHNQ+91xlwj+powEGFfPJ/5fHJ2HT61IFU5NLHTdBViXVv5O
 HfT6Zr0bX2YQA4IZ6+dUuLDnm4YhFYw=
X-Proofpoint-GUID: UADR1Pisc8FpcPFIQaXe-3I9VrbyhX0s
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA0NSBTYWx0ZWRfX+tUsmO6+/BcP
 d2PFYTBCJm1aUfB/8tfM2pgS7QVAE4zchYfNliLioRxd6bjlUvE3P5BOIwbbu6xiX4LgceqD5rr
 dcIo8+q682dgDHty3ellt8YZ6/ewsE8cf4gaWYsscYGWZCv7L6g9NVEtXcTerIQCziwJ27lZABd
 TQVzdKQ4MemtJ7w+2c3r7GLZigk7qmRQ+gDlb9gvG0qFYh4isNLE1/POfgBLF+SVyhyHj4ZAaMR
 9fnyAKzsMnSX9Z461vGUMHvXiX42VFAUXmZFfa/tHZI93O9AuugdGzZwqpl9l/0KgTKAPBDE82l
 +WF29kE06nTLEZBp7raTZKsRMZGLuqBrrAlXqctoLiniMPD9GO8/P4M7N9UEcW+bNMoKoXzE8B2
 SGb1CM/82x1TFQP4sOvD1jG4uiZeo0vtFXXfqaEOaEEz9vzigSwbfcoNEs5O1p8edZ+bbf7RE3N
 iqDQMzMD+bi3pF85pSA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 impostorscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160045

With ATH12K_FW_FEATURE_MULTI_QRTR_ID enabled, firmware derives the WLAN
QRTR node ID as:
  NID = IPC_ROUTER_DEFAULT_PROCESSOR_ID + PCIE_LOCAL_RSV0[15:0]

The host programs qmi_instance into PCIE_LOCAL_RSV0. Using an
incompatible bit placement can overlap node IDs used by other
processors and cause QRTR node registration conflicts.

Encode qmi_instance using the WLAN QRTR NID bit layout:
  bits [9:6]   PCI bus number
  bits [12:10] PCI domain number

The proc_id bits [5:0] are fixed to WLAN (7) in firmware and are not
encoded by the host.

Update QRTR_PCI_* masks to match these bit ranges and remove duplicate
mask definitions.

Tested-on: QCC2072 hw1.0 PCI CI_WLAN.COL.1.0.c2-00229.1-QCACOLSWPL_V1_TO_SILICON-1

Signed-off-by: Daizhuang Bai <daizhuang.bai@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/pci.c | 9 +++++++--
 drivers/net/wireless/ath/ath12k/pci.h | 6 ++----
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
index 12bbb75570f1..ac4bfd5b247d 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -711,9 +711,14 @@ static void ath12k_pci_init_qmi_ce_config(struct ath12k_base *ab)
 	ab->qmi.service_ins_id = ab->hw_params->qmi_service_ins_id;
 
 	if (ath12k_fw_feature_supported(ab, ATH12K_FW_FEATURE_MULTI_QRTR_ID)) {
+		/*
+		 * QRTR NID layout: [12:10] domain, [9:6] bus, [5:0] proc_id.
+		 * proc_id is fixed for WLAN and is not encoded into qmi_instance.
+		 */
 		ab_pci->qmi_instance =
-			u32_encode_bits(pci_domain_nr(bus), DOMAIN_NUMBER_MASK) |
-			u32_encode_bits(bus->number, BUS_NUMBER_MASK);
+			u32_encode_bits(bus->number, QRTR_PCI_BUS_NUMBER_MASK) |
+			u32_encode_bits(pci_domain_nr(bus),
+					QRTR_PCI_DOMAIN_NR_MASK);
 		ab->qmi.service_ins_id += ab_pci->qmi_instance;
 	}
 }
diff --git a/drivers/net/wireless/ath/ath12k/pci.h b/drivers/net/wireless/ath/ath12k/pci.h
index 0e0e2020c6ae..35e8e0fe15cd 100644
--- a/drivers/net/wireless/ath/ath12k/pci.h
+++ b/drivers/net/wireless/ath/ath12k/pci.h
@@ -61,8 +61,6 @@
 
 #define PCIE_LOCAL_REG_QRTR_NODE_ID(ab) \
 	((ab)->hal.regs->qrtr_node_id)
-#define DOMAIN_NUMBER_MASK			GENMASK(7, 4)
-#define BUS_NUMBER_MASK				GENMASK(3, 0)
 
 #define PCI_BAR_WINDOW0_BASE	0x1E00000
 #define PCI_BAR_WINDOW0_END	0x1E7FFFC
@@ -73,8 +71,8 @@
 #define PCI_PARF_END		0x1E0BFFC
 #define PCI_MHIREGLEN_REG	0x1E0E100
 #define PCI_MHI_REGION_END	0x1E0EFFC
-#define QRTR_PCI_DOMAIN_NR_MASK		GENMASK(7, 4)
-#define QRTR_PCI_BUS_NUMBER_MASK	GENMASK(3, 0)
+#define QRTR_PCI_BUS_NUMBER_MASK	GENMASK(9, 6)
+#define QRTR_PCI_DOMAIN_NR_MASK		GENMASK(12, 10)
 
 struct ath12k_msi_user {
 	const char *name;

base-commit: cd026e68fdbf88b9cc522b76c7a9d92c9a41f709
-- 
2.43.0

