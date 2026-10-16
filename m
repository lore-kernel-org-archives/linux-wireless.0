Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA6437C926
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 03:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792120940; cv=none; b=Jwu7x4b/q8SyVDmP9RzFvv+rSz0qqvdSqbgXZ6Q/42lQUUUV32zpvFuOk/OjGAQZmtf2vTq/TtW09ZPjhd8V18TCDenU9oHw1L3rXqYKhk0GNPtNjSzxG1ofa9Ieq/TM3YpYpt3Stq+zBikr3PtN247BLSR4LN5h0l4eg59Kp1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792120940; c=relaxed/simple;
	bh=rRMM//ZnpxJltK4zSN2FHrpMTsMARWNfq6pGEEkmt8A=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Z1pbX1/uJQttH60W5kMPPuz7w+Ifguxhuv+l1N9xwMtUrb7egzuIwlm9ndesc+tl0eBwjSONPcUIgOWYRaqT1UB9scwDn6jcXjUpZ0/6pz+1L6+FOx42J8tLKOBzhLccVtN0cfTBE5MMKbkfmiDzynsuPsM8uw8m7jjS5KaFTBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=VKB6X1Xw; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=VLvaTwHo; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="VKB6X1Xw";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="VLvaTwHo"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FNg0is1635320
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 03:22:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	9H3Ce4+vKYoYWvdI5qu3qKu/KamdGmH7SUP3e35shDE=; b=VKB6X1XweT9cMFtL
	sHMG70ujvghao4/DgRv0Mr3Ywwf2Ijo4P3L0sqrH1YOPWSsqYrKRTuPpT10C5ASW
	4UdshHGeHjXEsOcgnzveWMp14mDPC3vWCU9IJ/ObjKrGDHXtmvv/uMwuNwcei+VF
	6u350vzROcFaMdtj8j4wlQMEvTQXqCbS0f7kSB3Hz9PbkbNJI93R1xGxGtxIBHR5
	0VdR2Yd3iqN93/elwVNhHdmZSu7nWLjC7DDXrMS6HQ54UKxTzTXJr5fN2NR9nUxp
	+tuS7Gn6qtA4YF8rYEhgGjuP/JQ5fnneQEs4A2u6Gy89DZBt5WO70vBTDtxU+TIP
	8L2Niw==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hb8r10m1r-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 03:22:17 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-35c3c370b17so7209634eec.0
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 20:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792120937; x=1792725737; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9H3Ce4+vKYoYWvdI5qu3qKu/KamdGmH7SUP3e35shDE=;
        b=VLvaTwHo62IKFEQhTMvPkIajcl/zp7v9FKAjjzCLdzQQldEdYmI2Dj9GZrUsM2kD8J
         EM7DLaDHoQLtvmI/WhsZJR2tpOs4jUOguZALhF7tKmo/b/kyCVqr+OsxXmASomEaD5UE
         fYavuPqzJHU86B4KiP1t+lrw7SI7Zur+bWh06Dc310CXWOZul1lQ3XTRDK5DN5GqiLGc
         2FjKvwjzEH63ZulN86lZRmwEZs0Eg+mqVhcM8ZhwewP8XIFBfSmjsQR8wZjyzQCsad3o
         311KXV/5tn2ls74V2G7vdwPLBBL8Dyvz9GRnBK7wnfDseg5nfykpoVY2078w0W36R825
         ZFUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792120937; x=1792725737;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9H3Ce4+vKYoYWvdI5qu3qKu/KamdGmH7SUP3e35shDE=;
        b=1fjLRU9gzHsod5qJvhi2KTPXebQtlMLs9SBS2b6ZzOyHSmB7SfILkA8HxdrzG7jMaZ
         ozCZJZys4xyjePyhdn8JdolK+lRugbnyNc3IJ05gIzbCjVOKxVljdooMuSFFUHRE7fNO
         j2pG7Rq6v0+BEfVMwgJJivOtUqHEhooU1JsiXkg3LxlAcIxApAKEOBH7vBTCvzS2MlBL
         QgTMnFGREzbokj0o1mVJgnIpWc3PHQVs7NyI5lZuJX8aizApduxqJPPUB2scpdPnwPSm
         5pXf7+J4N5Fjq4cIbTSjf2BlNfHb0nctOrRfAuneYmSBERJRK52+00VQcqa8X13GXH3q
         43wA==
X-Gm-Message-State: AFq9FYKeLyYukb/PUF7w7t7JnsZes4EYla3zSfSudIEu1uR4THO/zLld
	AEr9FkQrT9B92zy9SuG8zg73r8BESJLI4XIWWGvFBjoWi5BeirRVhw5LLWh7Vflb+j4mFOAqPPP
	avZjtNvYrxZfSGXeQxdAUe5xeAzE7eEuvDJnFIYFS1NoU0cXErTr7HICp6JMD6VKk/Gos+Q==
X-Gm-Gg: AYBFou0XpLrYcikdrJtceXw2nGRKWHkIhBHPvKnAOEC0XGCMpuijs3Z8eReMtCrNp/y
	+hwiSPM/HP0XrCPakaJ3nr+KlOpCR458njG/bCHkJlI3xVsG3n/Ac3afubWuDxWorFNwvhoM06/
	l9EDJU8SWrUFpB7M/0+ACMh8eHhryCvo2LrBW5PrX7Ebs0jVa9zhX7PDpjpl4eMKuRyqwE+WDR4
	XwGTxQin/7I8QYvDzQd9c/p5WyLWG9WdJ7R+Fhmfav3I6LryiR8N5rBscSLifVpgIykP7dc3bvp
	TduMnYQvoF3T+aXes51HspcC63OQ9uiHAKltS6C3kwXm8VUmk5dTqdHO6jzrjrXrixI6nKxNEm9
	Ux0+Ilu8W95VIaxWVu+kzoeINs6OUkiWfPp6eP4DReJ9Gx4iCl6BbxDw+kU0tGy511ASK4dNiRU
	uUJ6YFexp4oAxJ6USU4eOxsg==
X-Received: by 2002:a05:7301:1a04:b0:359:3460:bc1c with SMTP id 5a478bee46e88-3593460bce0mr21201424eec.12.1792120936795;
        Thu, 15 Oct 2026 20:22:16 -0700 (PDT)
X-Received: by 2002:a05:7301:1a04:b0:359:3460:bc1c with SMTP id 5a478bee46e88-3593460bce0mr21201402eec.12.1792120936266;
        Thu, 15 Oct 2026 20:22:16 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-360819be413sm2256698eec.13.2026.10.15.20.22.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 20:22:15 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Date: Fri, 16 Oct 2026 08:51:43 +0530
Subject: [PATCH ath-next v2 06/17] wifi: ath12k: move multi MSI vector flag
 to ath12k_dev_flags
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-mpp-bringup-v2-6-f510c33bfcf5@oss.qualcomm.com>
References: <20261016-mpp-bringup-v2-0-f510c33bfcf5@oss.qualcomm.com>
In-Reply-To: <20261016-mpp-bringup-v2-0-f510c33bfcf5@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath12k@lists.infradead.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Proofpoint-ORIG-GUID: OqUF0gZFalYAoypyHl9Xt82zJmfZ8f88
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDAxMiBTYWx0ZWRfX3nTa5ipG+Bsu
 48OTU9IqDdTDygZ+ZpKoVL1SrfUsBUxYPTIPkcZXWoxYVg4Qf9ShArx59Y7O5scsV28h1BP69uC
 +xoJxBOyEPc2xaJvgmH9sbwCByQmXGI=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDAxMiBTYWx0ZWRfX2Ghwjo7RoEzt
 nr6CCNFpu03EpFf36oKHiO8b9RsRNu3tybdZV4I2TjtDgrEKONFnlbc2DIYnbYfjSh5leHrc+lv
 F3AW9JiGsYqxMlQiKQ9EHBfVz80Nu96/0jegUo3NpiJtsm1P13WF6z9Bmusk3/rfuT9WnUOoDfL
 Mh+y/GtVIFUwdsu3VdZZ7XZ2Gg2dndlnj2qbx58jY5tv2S3Tcqt3tQFfFgY3+yN1TLkyBzqwe0D
 bZF39oCyeCrc+d17dc9Qq3oNQkbuOvwhhXaVknmGUqss/tRnIEsQFctZRi/QyGc5SLCE01hzVsf
 GtAnyVquouaNBl2wjN0bmDyGK6wtSqFMvAM++ny/XwS4EoA0IzMayq9sid2AZO0C8KQojP9GjxM
 eIP0Gn6FNt0I5+l+yoRG0OAPvWv4EB/kwUoMFtI0K68QVd7XXBbMI/uWNezhiQYxfM6b2GfkUBc
 hn3tJ1QkdhUvwnHyUzw==
X-Proofpoint-GUID: OqUF0gZFalYAoypyHl9Xt82zJmfZ8f88
X-Authority-Analysis: v=2.4 cv=L/CI0OT8 c=1 sm=1 tr=0 ts=6ad19869 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=jN1JcmgayTw_7mYEAw8A:9 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 malwarescore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160012

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

