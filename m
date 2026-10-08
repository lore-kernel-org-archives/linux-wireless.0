Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CE749B446
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 10:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791455076; cv=none; b=ic/xGDThkU0MLOicaXaplVNfYnVqh8LndAiWmhE24D6H7GUW5k1u1YEIbuijcFB+1poVd5jK/BmXXoYQmANr7+dWG6xcGW1t3oYBLt1978TniGHyiAI0p/XM6HejnqzmnX4dHYDe6RUaDR1IFSBdvdyBJT4WVIoJYk+txRyEulA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791455076; c=relaxed/simple;
	bh=rRMM//ZnpxJltK4zSN2FHrpMTsMARWNfq6pGEEkmt8A=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DIPGVlte4lHenWMcScwPf6o7NRdcDWzuHVf90/NCwhdQrlq7FhnuxDNE3XEeXOFfgyr9YAqYmsiTQzaNPfruhIxQqbqMpwJqQAEE3gBwyFfD9B2mr1HHpk0PVMshh9RrphPl0IRDr4ewIGiDhNCC+LzTtd0VDSL8SKav1U2ECEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=f0Djo/nk; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=QNIPzsIk; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="f0Djo/nk";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="QNIPzsIk"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6987KJo13307406
	for <linux-wireless@vger.kernel.org>; Thu, 8 Oct 2026 10:24:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	9H3Ce4+vKYoYWvdI5qu3qKu/KamdGmH7SUP3e35shDE=; b=f0Djo/nkhyfeWena
	rN5ES7SAAvtM/VPbN84CbdMbXue6gNseTXuNM8fs7fFU2rFdHqy1guvJaI0amlE8
	QwEvWpF/kDmkoXMjJOO20afiR7J/bs9RFeSX6e1sotIkIpSjLFktiIa+FIqYpaWH
	ISrrIdNhsAWhZZykASnAd4pFu2oAHPFxYPKqvLRQw368Q16q1U+LCP2sDQGTJSIf
	r0wEpNtEmYRFS0ZJRF641Wsenfu3Caigq/MsLvFFRk1Ro74gDpNUl9v+x1AH3E2O
	2GeGsj9ChpI7JGjh6T8ZKwk96rq0HcUvs6gEDtOHdHDX7BYZPQ0sj95EAZjbWiFi
	ACKbvQ==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h60sga140-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 10:24:34 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2d6f80c76e6so60575005ad.3
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 03:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791455074; x=1792059874; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9H3Ce4+vKYoYWvdI5qu3qKu/KamdGmH7SUP3e35shDE=;
        b=QNIPzsIkH5SMEsOviSlJdO0FVTamco96Mdhc2wAtF/Alc+b7c1dZvLYuU6yrk59cb4
         yioHc9N2eAH79PF6NwcEnXrdBlKcg9yIJ7Kvbt49j8KqPmghy82UfjVwVx6ra7OCd2gw
         92kD1+nkUBsUajsFPnIWT7aLamjv3GRLg6+Q1sU3bldCpJZlKf1aprk9pxBQbHLDddlz
         muXcjMEp4epejPYvBwmUROfcQ9EJJxl0bjsaiykhNBtrBQVGvsIwvdOnd7HMM9LLbSB4
         OhNEkDYYKbk4HVe3Y/dEO8EAlT2codrEelIwlTvRhDvZ8uh7rKNIGD0XnHMjK4yo/l8c
         mwsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791455074; x=1792059874;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9H3Ce4+vKYoYWvdI5qu3qKu/KamdGmH7SUP3e35shDE=;
        b=bLpcT06eZiQ+SRe3F0tKu3qs1juQURwcFOHfYGb3SbkwQuOujOVm6wYmh4n+kHLskl
         L2eInrLu4Oa38RD2xoRmsnluHMIzpVaKbLFOLAGpyHyY3f+w5/CKrb98NAnUSbuy07oF
         myj2sTCf2OKNpp0a4m8v6aaq52VYTp7IQaRGwMB1ejwSp/TVXRfyvrMLxMjXycVaKK9Z
         ZUUbl+64Dvbiwm1OrbNKllWhuhuGsHwK7Gd6A+NW85yJWz8Aev1Q5xCTV/yg2VTy5oV0
         wyqYRlzT4fZT6JVDkgtIfxSZh1jBi3zw8hLJCy94SV5bQUsLo2KT+0Bj2HRo6Ow+yBLR
         WGbA==
X-Gm-Message-State: AFq9FYJdx4eRbxNKL9+ptO0lgEEdNF5bQhzpPJwKNykF1ZOtWgLrkSNH
	ArfjAt7bYiYk7CnEyGg9m/i3EC+fAFgrJsTQ4NPu/2+mEMm6WZKB6bA5PJdfatWw2wS/PzFQM6q
	pbnzASwprfsomHKN+9byH9OJ6QjuYQBArks1gcKMVz18a9jQthxxejrG9mzBicXocV6At+w==
X-Gm-Gg: AYBFou3KhrmSZvoubDlh/mEM+l4yadXYO/17DnbibnLqFf76hCf7M3tCEPRb1xGRpp4
	QIeDLzt9NY958NvgAE0xXrjGGK4vD/mvQAO0Vfdx6wDUgUxNE6ZmDPOFwSt8nCx8C6jACPRAm/w
	9RK0+rt8m9wV1BdHU4tomGlhEvvGFJpDliMJr5a5A6VKMdZ/KDsbFYfIXPGnLGHtYjiJtAsXk01
	bV06jvGUsmOWYCwtgR07hUxChsF4w6LuyLPs4mjS3QlkE6KRKeXqY6bACa91hrFPuO+i/NKTt6v
	0lalQvgid5CNW0edfEtk1mbdkBSr5rMO6tn0JtsitnKu3rt2PNeIbN8wLRDQaXLWDAybnpvDTXX
	Foc/F+sDHHzbZ47PL0qzslh9cOVJhqEuRXulF/1e+d+nEe8EHI/c9RiUgIQeZAXMt9RyMiNz5Kr
	E1qL/D6cgCoSYe5B9Kg+QQbQ==
X-Received: by 2002:a17:902:e74d:b0:2e6:13b1:e196 with SMTP id d9443c01a7336-2e613b1f621mr33978085ad.74.1791455073915;
        Thu, 08 Oct 2026 03:24:33 -0700 (PDT)
X-Received: by 2002:a17:902:e74d:b0:2e6:13b1:e196 with SMTP id d9443c01a7336-2e613b1f621mr33977965ad.74.1791455073445;
        Thu, 08 Oct 2026 03:24:33 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e6046fe39csm22081655ad.16.2026.10.08.03.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 03:24:32 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Date: Thu, 08 Oct 2026 15:54:02 +0530
Subject: [PATCH ath-next 06/17] wifi: ath12k: move multi MSI vector flag to
 ath12k_dev_flags
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261008-mpp_bringup-v1-6-2c5797b5e4ac@oss.qualcomm.com>
References: <20261008-mpp_bringup-v1-0-2c5797b5e4ac@oss.qualcomm.com>
In-Reply-To: <20261008-mpp_bringup-v1-0-2c5797b5e4ac@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath12k@lists.infradead.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Proofpoint-GUID: -ZI7QqWzRG8V6lbnQJE7R3FvenjAgS0k
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDA0MSBTYWx0ZWRfX6N3O8ZSkrHwZ
 ihJd5WXIHwa5R4ZHlF2I5D5bUxkQfNhGbTtgpLChsm3tFQPU/DynFrGphe5OA+HV0eji5PYjWRB
 fff7ZIQ+wg4U/5lkqmU8vNZftaBmfBY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDA0MSBTYWx0ZWRfX8b/Kx+phjok5
 On6+8NTTk/VK6o99E+Htaz0LRnTigvaXPLApZbBWCUKPN5rOcpYIj4l3XxMhxPUSend2qhI0eyj
 CMoooWwcOovMnH4scDCYvxwTQ0vT+zPUmwIr1F20OVIhZq62uSU4fVrpR39RA/0vT7Asdls6/F4
 OVeAMUljEoxv7LQ1rk7KpibFycGTaQDPZnM+q7GPmOC6Co0zdFwr1RIM6h828hA7Uxqe5l5W66D
 3wKIKfcrG4/YZobpeiYoxzCbxlsDFF174kxxFfHLf1oRvuN9l9bKTzny4+5mvt28e2a8Q9udRvF
 HxKGwc+IJPpXlivBljEyTstWkymslG9wybDmbYvPmc64GcCC1G6AQrbMdDQHwXQrteexnJDZKGp
 gVaJmutYbDxcbgdiir+X0PClvLNSCzrgL16AwXoWZfhnIuQQz0ofRhHSHuhtBNJrh2Aok1D4RIa
 HkFelDyOH5Ht4WjfJmQ==
X-Authority-Analysis: v=2.4 cv=DfWCOftW c=1 sm=1 tr=0 ts=6ac76f62 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=jN1JcmgayTw_7mYEAw8A:9 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-ORIG-GUID: -ZI7QqWzRG8V6lbnQJE7R3FvenjAgS0k
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_03,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 phishscore=0 clxscore=1015
 priorityscore=1501 suspectscore=0 spamscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610080041

QCN6432 uses MSI vectors, but although it is a PCIe device, it is
attached to the WCSS Q6 processor and registered as an AHB platform
device. As a result, it does not have a valid ab_pci context while
still reusing PCI IRQ APIs.

Move ATH12K_PCI_FLAG_MULTI_MSI_VECTORS from ath12k_pci_flags to
ath12k_dev_flags so it can be used without relying on PCI-specific context.
Rename it to ATH12K_FLAG_MULTI_MSI_VECTORS accordingly.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.6-01322-QCAHKSWPL_SILICONZ-1
Tested-on: QCN6432 hw1.0 AHB WLAN.WBE.1.6-01322-QCAHKSWPL_SILICONZ-1

Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/core.h |  1 +
 drivers/net/wireless/ath/ath12k/mhi.c  |  4 ++--
 drivers/net/wireless/ath/ath12k/pci.c  | 22 ++++++++++------------
 drivers/net/wireless/ath/ath12k/pci.h  |  1 -
 4 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.h b/drivers/net/wireless/ath/ath12k/core.h
index d87c59f68c12..eaea601ab32d 100644
--- a/drivers/net/wireless/ath/ath12k/core.h
+++ b/drivers/net/wireless/ath/ath12k/core.h
@@ -278,6 +278,7 @@ enum ath12k_dev_flags {
 	ATH12K_FLAG_QMI_FW_READY_COMPLETE,
 	ATH12K_FLAG_FTM_SEGMENTED,
 	ATH12K_FLAG_FIXED_MEM_REGION,
+	ATH12K_FLAG_MULTI_MSI_VECTORS,
 };
 
 struct ath12k_tx_conf {
diff --git a/drivers/net/wireless/ath/ath12k/mhi.c b/drivers/net/wireless/ath/ath12k/mhi.c
index ee87f00bc5de..56e697fbdad5 100644
--- a/drivers/net/wireless/ath/ath12k/mhi.c
+++ b/drivers/net/wireless/ath/ath12k/mhi.c
@@ -86,7 +86,7 @@ static int ath12k_mhi_get_msi(struct ath12k_pci *ab_pci)
 
 	msi_data = base_vector;
 	for (i = 0; i < num_vectors; i++) {
-		if (test_bit(ATH12K_PCI_FLAG_MULTI_MSI_VECTORS, &ab_pci->flags))
+		if (test_bit(ATH12K_FLAG_MULTI_MSI_VECTORS, &ab->dev_flags))
 			irq[i] = ath12k_pci_get_msi_irq(ab->dev,
 							msi_data++);
 		else
@@ -248,7 +248,7 @@ int ath12k_mhi_register(struct ath12k_pci *ab_pci)
 		goto free_controller;
 	}
 
-	if (!test_bit(ATH12K_PCI_FLAG_MULTI_MSI_VECTORS, &ab_pci->flags))
+	if (!test_bit(ATH12K_FLAG_MULTI_MSI_VECTORS, &ab->dev_flags))
 		mhi_ctrl->irq_flags = IRQF_SHARED | IRQF_NOBALANCING;
 
 	mhi_ctrl->iova_start = 0;
diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
index 736e40492b41..e6fe891e58b1 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -341,13 +341,12 @@ static void ath12k_pci_free_irq(struct ath12k_base *ab)
 
 static void ath12k_pci_ce_irq_enable(struct ath12k_base *ab, u16 ce_id)
 {
-	struct ath12k_pci *ab_pci = ath12k_pci_priv(ab);
 	u32 irq_idx;
 
 	/* In case of one MSI vector, we handle irq enable/disable in a
 	 * uniform way since we only have one irq
 	 */
-	if (!test_bit(ATH12K_PCI_FLAG_MULTI_MSI_VECTORS, &ab_pci->flags))
+	if (!test_bit(ATH12K_FLAG_MULTI_MSI_VECTORS, &ab->dev_flags))
 		return;
 
 	irq_idx = ATH12K_MSI_IRQ_CE0_OFFSET + ce_id;
@@ -356,13 +355,12 @@ static void ath12k_pci_ce_irq_enable(struct ath12k_base *ab, u16 ce_id)
 
 static void ath12k_pci_ce_irq_disable(struct ath12k_base *ab, u16 ce_id)
 {
-	struct ath12k_pci *ab_pci = ath12k_pci_priv(ab);
 	u32 irq_idx;
 
 	/* In case of one MSI vector, we handle irq enable/disable in a
 	 * uniform way since we only have one irq
 	 */
-	if (!test_bit(ATH12K_PCI_FLAG_MULTI_MSI_VECTORS, &ab_pci->flags))
+	if (!test_bit(ATH12K_FLAG_MULTI_MSI_VECTORS, &ab->dev_flags))
 		return;
 
 	irq_idx = ATH12K_MSI_IRQ_CE0_OFFSET + ce_id;
@@ -427,13 +425,13 @@ static irqreturn_t ath12k_pci_ce_interrupt_handler(int irq, void *arg)
 
 static void ath12k_pci_ext_grp_disable(struct ath12k_ext_irq_grp *irq_grp)
 {
-	struct ath12k_pci *ab_pci = ath12k_pci_priv(irq_grp->ab);
+	struct ath12k_base *ab = irq_grp->ab;
 	int i;
 
 	/* In case of one MSI vector, we handle irq enable/disable
 	 * in a uniform way since we only have one irq
 	 */
-	if (!test_bit(ATH12K_PCI_FLAG_MULTI_MSI_VECTORS, &ab_pci->flags))
+	if (!test_bit(ATH12K_FLAG_MULTI_MSI_VECTORS, &ab->dev_flags))
 		return;
 
 	for (i = 0; i < irq_grp->num_irq; i++)
@@ -462,13 +460,13 @@ static void __ath12k_pci_ext_irq_disable(struct ath12k_base *ab)
 
 static void ath12k_pci_ext_grp_enable(struct ath12k_ext_irq_grp *irq_grp)
 {
-	struct ath12k_pci *ab_pci = ath12k_pci_priv(irq_grp->ab);
+	struct ath12k_base *ab = irq_grp->ab;
 	int i;
 
 	/* In case of one MSI vector, we handle irq enable/disable in a
 	 * uniform way since we only have one irq
 	 */
-	if (!test_bit(ATH12K_PCI_FLAG_MULTI_MSI_VECTORS, &ab_pci->flags))
+	if (!test_bit(ATH12K_FLAG_MULTI_MSI_VECTORS, &ab->dev_flags))
 		return;
 
 	for (i = 0; i < irq_grp->num_irq; i++)
@@ -626,7 +624,7 @@ static int ath12k_pci_ext_irq_config(struct ath12k_base *ab)
 static int ath12k_pci_set_irq_affinity_hint(struct ath12k_pci *ab_pci,
 					    const struct cpumask *m)
 {
-	if (test_bit(ATH12K_PCI_FLAG_MULTI_MSI_VECTORS, &ab_pci->flags))
+	if (test_bit(ATH12K_FLAG_MULTI_MSI_VECTORS, &ab_pci->ab->dev_flags))
 		return 0;
 
 	return irq_set_affinity_and_hint(ab_pci->pdev->irq, m);
@@ -762,7 +760,7 @@ static int ath12k_pci_msi_alloc(struct ath12k_pci *ab_pci)
 					    PCI_IRQ_MSI);
 
 	if (num_vectors == msi_config->total_vectors) {
-		set_bit(ATH12K_PCI_FLAG_MULTI_MSI_VECTORS, &ab_pci->flags);
+		set_bit(ATH12K_FLAG_MULTI_MSI_VECTORS, &ab->dev_flags);
 		ab_pci->irq_flags = IRQF_SHARED;
 	} else {
 		num_vectors = pci_alloc_irq_vectors(ab_pci->pdev,
@@ -773,7 +771,7 @@ static int ath12k_pci_msi_alloc(struct ath12k_pci *ab_pci)
 			ret = -EINVAL;
 			goto reset_msi_config;
 		}
-		clear_bit(ATH12K_PCI_FLAG_MULTI_MSI_VECTORS, &ab_pci->flags);
+		clear_bit(ATH12K_FLAG_MULTI_MSI_VECTORS, &ab->dev_flags);
 		ab->msi.config = &msi_config_one_msi;
 		ab_pci->irq_flags = IRQF_SHARED | IRQF_NOBALANCING;
 		ath12k_dbg(ab, ATH12K_DBG_PCI, "request MSI one vector\n");
@@ -1152,7 +1150,7 @@ int ath12k_pci_start(struct ath12k_base *ab)
 
 	set_bit(ATH12K_PCI_FLAG_INIT_DONE, &ab_pci->flags);
 
-	if (test_bit(ATH12K_PCI_FLAG_MULTI_MSI_VECTORS, &ab_pci->flags))
+	if (test_bit(ATH12K_FLAG_MULTI_MSI_VECTORS, &ab->dev_flags))
 		ath12k_pci_aspm_restore(ab_pci);
 	else
 		ath12k_info(ab, "leaving PCI ASPM disabled to avoid MHI M2 problems\n");
diff --git a/drivers/net/wireless/ath/ath12k/pci.h b/drivers/net/wireless/ath/ath12k/pci.h
index 47c8760536e4..3097afb03432 100644
--- a/drivers/net/wireless/ath/ath12k/pci.h
+++ b/drivers/net/wireless/ath/ath12k/pci.h
@@ -100,7 +100,6 @@ enum ath12k_pci_flags {
 	ATH12K_PCI_FLAG_INIT_DONE,
 	ATH12K_PCI_FLAG_IS_MSI_64,
 	ATH12K_PCI_ASPM_RESTORE,
-	ATH12K_PCI_FLAG_MULTI_MSI_VECTORS,
 };
 
 struct ath12k_pci_ops {

-- 
2.34.1

