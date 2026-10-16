Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F283AF64F
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 03:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792120968; cv=none; b=tG946qABiuW5MqHXpP9F87EPINlCxmCbwajvhBb5asjh4lSIt4JoMklCx6O69/g0BXTyl/Ktn4kgHqg04Vi/BNQVL+ZPmBiCnnUAHBkjpGuEUSJ+SC2hToIUHzhPyiLxLZnTiaNW00EDdd8wnOHB+Wk5NkzzkT11wp3p8n/BvT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792120968; c=relaxed/simple;
	bh=mp5xwB41E1VqXdiDIiuYdz4+MIKxEtHkdtMYBAeIduk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hvD/ged3Bh3ybJ9DJeDLRlUA/Tz+NJxA7OF6z8uVWTqA4EO7M+y2ulPLTlQlpLEYpnRwT6dHC6CP4T+5+/7OGYfd7nYRTrGv5U+dCP2cxBXJv2+l4TY0f8TH9XtXKGRAOm21ZwQr4q4w98TVSPQiUUQO0KbDhSpzf9jo/3VxhYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=F2bdp+6d; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ksQRc9k1; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="F2bdp+6d";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ksQRc9k1"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FLsYWw2677928
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 03:22:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	wp0RCDsMhT3bPJrXj+baRIvNKxXxFWOrsPt+1Rjd8Wo=; b=F2bdp+6dnVv/KPmX
	skFLlY3XS0Wwhb/t7fbOS6GVZJ8qlOm6pPKgIBeNMiu0PSLKgYmPiA4Ww54aWeIf
	6NGrlLEYD+cgeolUaP6sNfHJ5oINaU+5ERsOlWKsjbK/D+1JmmSMjh9s2kOYzMp3
	5dtmyyUeGXY8b0OyMDszO097wqraPyelrFyBk9hG3XS8SzneWd5BKRlgh3Na7p7B
	HBTgEENceD3Y3FL/v8BcaVRL4WJW7UT7oSZBEn8YeHrKdjVPQgyNPd1CNDBH+1Sw
	pyVO+IwqPFkFu1UH02U+beY+MTbEJEZhRv/sUqz8Zr8BUUpFNBVx5fdmK4ISyq4w
	UZWGSQ==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hb19tag9h-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 03:22:45 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-30bcb065bfdso10585117eec.0
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 20:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792120965; x=1792725765; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wp0RCDsMhT3bPJrXj+baRIvNKxXxFWOrsPt+1Rjd8Wo=;
        b=ksQRc9k1xP56wzp093zgB/dVG/aoeURyElDSrmXbZHeGuelEir+K8EwHeXYb7TSf3f
         SAZOtMJKrkcJSz/bjvqBnHSg5g2pZHUhJuD0JjKMpY9kPNKvn7gGi5pXH6//Hwy1PvBC
         0C8vZD5D7KQfTR1ITS4N3rGM9fyaDdBpLYBM3Z4T3RHDlRsSu+HY13INQ21og1oL0p9v
         mxts+71ZVHI6QlVWqe+DBoVsaaXY15y4HJBrX/ete3kJQMPTH0TRwkl62NaHByot2Qv8
         Xwi2ryMSwSCLHOa8X11BQARVmDWmw5ft79Pzm5NGSpkA2EVzKt0bVITpSDaU0eoiv4xq
         ywJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792120965; x=1792725765;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wp0RCDsMhT3bPJrXj+baRIvNKxXxFWOrsPt+1Rjd8Wo=;
        b=WdX/yoWnGMOh2cta9FMuwmtFzxVKvEbTN5CDN8JMao8v5/5Uxzi/yNgngSY+rWQOuv
         3ks0lkNV86Y3TtGkEPbh5L69sMJ4Z3DhbhZaTr7zn0MvMcmY0V67r392hqFIX7Bw0Odd
         otmdO8YLbd/9+j7EteHnsHbTXhdgfEhExc95WaIgiO+ruBmuyp1GhZvb/yhYvYcCa5mp
         bWVMmEtpUrxLgums+XZ3xTyFotlpPoai5e77d4Q30dwGbpKZ1hKqBLCJYU35UvE0TZjU
         2SQ+SE5aCT2zDkUUPJ5bIYHEvY2GCv3yPbJjUlqjVp2uuoOZV7LRYz9ITngjKjSyu61O
         V+og==
X-Gm-Message-State: AFq9FYK7b7oWlqPrliaYU3QCgdfaPM68YxK5udOR58XrJJ0RrnQCYAsW
	QC5VQeA68CIGHjOgEWsd2SYiO8PP2r/i8FSsK5D52ZhdoAy3H3RyvndnxVc7dPZ2W+zOvqnteMF
	vR4QdO/ol4kjSTLZ8/TVlNMjN2wiRu7CaWAB+HYw7nJbbPfb2J4FXUBWK248DA85HNLCjnA==
X-Gm-Gg: AYBFou1Qo0sTvetOUzdikizok60PIZJ8/9x2nGRooOCevqKSa3qn3WYyAkB96ZMzt9Y
	x6WND999qK0GxzifBtwoQkUjCIgcTt5dchEswd1bwIqIOibjlZfTz7x6Pz521RkhIfSqz6fpK/v
	EhnzAdM1YPEkYf6SwGVQAS67HRHJaBpFokxjH1Pcjon3xz5EgStBsa1+kBztxYJHuEFrXYsss1D
	W296QJ3zhL6X9ZDJ/lyuuYunDM+Dy7oAvaZE6jeDVSXQbCGyk4/dKQThF/Rj9m90MIOrjMX3Ww3
	+8KGnuWaxdl4MAoqfytEFs9XdnFSaZ4DlBd8nMOu9LyEdRqSn99v+9DjNCZQUzU2Ahv698Ir2Sg
	ZZtMAvhmeDrhH/zkvaRXShewu1vD1S0s8kfa0RytXajPPoqymfmSoJf9YIbRjiUVcplzd0w6JIs
	sqHAhQWjgP9yMOnAxtwtsCXg==
X-Received: by 2002:a05:7301:9c91:b0:35f:8c5d:5928 with SMTP id 5a478bee46e88-35f8c5d5bc7mr4168023eec.30.1792120964694;
        Thu, 15 Oct 2026 20:22:44 -0700 (PDT)
X-Received: by 2002:a05:7301:9c91:b0:35f:8c5d:5928 with SMTP id 5a478bee46e88-35f8c5d5bc7mr4167994eec.30.1792120964106;
        Thu, 15 Oct 2026 20:22:44 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-360819be413sm2256698eec.13.2026.10.15.20.22.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 20:22:43 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Date: Fri, 16 Oct 2026 08:51:49 +0530
Subject: [PATCH ath-next v2 12/17] wifi: ath12k: Enable MSI interrupt
 support for DP interrupt
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-mpp-bringup-v2-12-f510c33bfcf5@oss.qualcomm.com>
References: <20261016-mpp-bringup-v2-0-f510c33bfcf5@oss.qualcomm.com>
In-Reply-To: <20261016-mpp-bringup-v2-0-f510c33bfcf5@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath12k@lists.infradead.org,
        Sowmiya Sree Elavalagan <quic_ssreeela@quicinc.com>,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Proofpoint-GUID: LBmj2EBxxKsOtO2AjZBwssVtzMSUl7BM
X-Proofpoint-ORIG-GUID: LBmj2EBxxKsOtO2AjZBwssVtzMSUl7BM
X-Authority-Analysis: v=2.4 cv=NqZE4MdJ c=1 sm=1 tr=0 ts=6ad19885 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=COk6AnOGAAAA:8 a=EUspDBNiAAAA:8 a=BHcOcFGZyyTdvy3InMAA:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDAxMiBTYWx0ZWRfX2/i4uNoiDb1j
 E9qPpU0DM/ai0zl1pfB02Rm0FLhFYLS6h6fn+kH1ZeApdPXHRksy7VKeSB2ebbKjHXzB2qo+IvX
 pF1bqZu0YBvARMH38OXwpXgHTbvxF6M3AQrrvIcQcbQgw504BG31bREcv2k5d8iE8rjlbiEM8TE
 Gi1VLeYpNQw3GGuJDi9Q6gtFytU87qnbtICps2ht66yLpMmPuBo9TcnVOjOY2r21hvGZx/7L3k6
 qhgEcMMvlUNCLt1H9vLrjz7ZeY78/wwBFMCHmFOMhCEd8gLxapnRHr/2xIKJiY7hd/6oJUTHs/W
 3X5xTj2IeIZxmJMXJH69um9W7dI31+G/NEvirwsHq0WCeCAEuqPjXmkWd7ByZ3XpO7pSodaQawW
 bg89nBB8xn6pulCIdBkhdYg26a29hGabF5gbFCFYNN3VgQKgSyaPnoG1dg5BVgRw3U1nea1Fi3A
 oFwWmlxQgDUndUT4lKw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDAxMiBTYWx0ZWRfXyYqQC2xbM1IR
 fsF5SljONT8CiY0Tpl6ocAiJ/B/0Be7kTyrv4w/T/4Lct0bBXYOJ4aPTVVLVvNIYGVB7T1zk+6d
 F2RDZ7i6VhrIBvUrDxIZdaKuX2gqvTs=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 spamscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 suspectscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160012

From: Sowmiya Sree Elavalagan <quic_ssreeela@quicinc.com>

Configure and request external MSI interrupts for DP ring groups on the
QCN6432 platform.
Create a NAPI context for each active external interrupt group and
disable the corresponding IRQs while NAPI polling is in progress.
Re-enable the IRQs after completing the NAPI poll.

Handle allocation and cleanup of NAPI contexts and external IRQs during
configuration failure and driver removal. Also disable external DP
interrupts from the AHB IRQ disable path.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.6-01322-QCAHKSWPL_SILICONZ-1
Tested-on: QCN6432 hw1.0 AHB WLAN.WBE.1.6-01322-QCAHKSWPL_SILICONZ-1

Signed-off-by: Sowmiya Sree Elavalagan <quic_ssreeela@quicinc.com>
Co-developed-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/core.h |   2 +
 drivers/net/wireless/ath/ath12k/pci.c  |   6 +-
 drivers/net/wireless/ath/ath12k/pcic.c | 122 +++++++++++++++++++++++++++++++++
 3 files changed, 129 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.h b/drivers/net/wireless/ath/ath12k/core.h
index 21332aeb0c22..bbbde9f05ea9 100644
--- a/drivers/net/wireless/ath/ath12k/core.h
+++ b/drivers/net/wireless/ath/ath12k/core.h
@@ -165,6 +165,7 @@ enum ath12k_hw_rev {
 #define ATH12K_EXT_IRQ_NUM_MAX	16
 #define ATH12K_MAX_TCL_RING_NUM	3
 #define ATH12K_MAX_MSI_VECTOR	32
+#define ATH12K_EXT_IRQ_NAME_LEN	32
 
 struct ath12k_ext_irq_grp {
 	struct ath12k_base *ab;
@@ -175,6 +176,7 @@ struct ath12k_ext_irq_grp {
 	bool napi_enabled;
 	struct napi_struct napi;
 	struct net_device *napi_ndev;
+	char irq_name[ATH12K_EXT_IRQ_NAME_LEN];
 };
 
 enum ath12k_smbios_cc_type {
diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
index a26fdb3c0ad2..4bb14a95aec9 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -348,11 +348,15 @@ void ath12k_pci_free_ext_irq(struct ath12k_base *ab, int num_ext_irq_grp)
 	for (i = 0; i < num_ext_irq_grp; i++) {
 		struct ath12k_ext_irq_grp *irq_grp = &ab->ext_irq_grp[i];
 
+		if (!irq_grp->napi_ndev)
+			continue;
+
 		for (j = 0; j < irq_grp->num_irq; j++)
 			free_irq(ab->irq_num[irq_grp->irqs[j]], irq_grp);
 
 		netif_napi_del(&irq_grp->napi);
 		free_netdev(irq_grp->napi_ndev);
+		irq_grp->napi_ndev = NULL;
 	}
 }
 
@@ -1118,7 +1122,7 @@ void ath12k_pci_ext_irq_enable(struct ath12k_base *ab)
 	for (i = 0; i < ATH12K_EXT_IRQ_GRP_NUM_MAX; i++) {
 		struct ath12k_ext_irq_grp *irq_grp = &ab->ext_irq_grp[i];
 
-		if (!irq_grp->napi_enabled) {
+		if (irq_grp->napi_ndev && !irq_grp->napi_enabled) {
 			napi_enable(&irq_grp->napi);
 			irq_grp->napi_enabled = true;
 		}
diff --git a/drivers/net/wireless/ath/ath12k/pcic.c b/drivers/net/wireless/ath/ath12k/pcic.c
index fea284c3707b..13097cdf2794 100644
--- a/drivers/net/wireless/ath/ath12k/pcic.c
+++ b/drivers/net/wireless/ath/ath12k/pcic.c
@@ -181,6 +181,113 @@ static irqreturn_t ath12k_pcic_ce_interrupt_handler(int irq, void *arg)
 	return IRQ_HANDLED;
 }
 
+static void ath12k_pcic_ext_grp_enable(struct ath12k_ext_irq_grp *irq_grp)
+{
+	int i;
+
+	for (i = 0; i < irq_grp->num_irq; i++)
+		enable_irq(irq_grp->ab->irq_num[irq_grp->irqs[i]]);
+}
+
+static int ath12k_pcic_ext_grp_napi_poll(struct napi_struct *napi, int budget)
+{
+	struct ath12k_ext_irq_grp *irq_grp = container_of(napi,
+						struct ath12k_ext_irq_grp,
+						napi);
+	struct ath12k_base *ab = irq_grp->ab;
+	int work_done;
+
+	work_done = ath12k_dp_service_srng(ab->dp, irq_grp, budget);
+	if (work_done < budget) {
+		if (likely(napi_complete_done(napi, work_done)))
+			ath12k_pcic_ext_grp_enable(irq_grp);
+	}
+
+	if (work_done > budget)
+		work_done = budget;
+
+	return work_done;
+}
+
+static int ath12k_pcic_ext_irq_config(struct ath12k_base *ab,
+				      struct msi_desc **msi_desc, int num_msi)
+{
+	struct ath12k_ahb *ab_ahb = ath12k_ab_to_ahb(ab);
+	struct ath12k_ext_irq_grp *irq_grp;
+	int j, i, k, vec_idx = 0, ret = 0;
+	u8 userpd_id = ab_ahb->userpd_id;
+	u32 num_irq, base_idx;
+	struct msi_desc *desc;
+
+	base_idx = ATH12K_MSI_IRQ_CE0_OFFSET + CE_COUNT_MAX;
+
+	for (i = 0; i < ATH12K_EXT_IRQ_GRP_NUM_MAX; i++) {
+		num_irq = 0;
+		irq_grp = &ab->ext_irq_grp[i];
+		irq_grp->ab = ab;
+		irq_grp->grp_id = i;
+
+		if (ab->hw_params->ring_mask->tx[i] ||
+		    ab->hw_params->ring_mask->rx[i] ||
+		    ab->hw_params->ring_mask->rx_err[i] ||
+		    ab->hw_params->ring_mask->rx_wbm_rel[i] ||
+		    ab->hw_params->ring_mask->reo_status[i] ||
+		    ab->hw_params->ring_mask->host2rxdma[i] ||
+		    ab->hw_params->ring_mask->rx_mon_dest[i]) {
+			num_irq = 1;
+		}
+
+		if (!num_irq)
+			continue;
+
+		desc = msi_desc[vec_idx];
+
+		irq_grp->napi_ndev = alloc_netdev_dummy(0);
+		if (!irq_grp->napi_ndev) {
+			ret = -ENOMEM;
+			goto fail_allocate;
+		}
+
+		netif_napi_add(irq_grp->napi_ndev, &irq_grp->napi,
+			       ath12k_pcic_ext_grp_napi_poll);
+		irq_grp->num_irq = num_irq;
+		irq_grp->irqs[0] = base_idx + i;
+
+		for (j = 0; j < irq_grp->num_irq; j++) {
+			int irq_idx = irq_grp->irqs[j];
+
+			scnprintf(irq_grp->irq_name, sizeof(irq_grp->irq_name),
+				  "pcic%u_wlan_dp_%u", userpd_id, i);
+			irq_set_status_flags(desc->irq, IRQ_DISABLE_UNLAZY);
+			ret = request_irq(desc->irq, ath12k_pci_ext_interrupt_handler,
+					  IRQF_SHARED, irq_grp->irq_name, irq_grp);
+			if (ret) {
+				ath12k_err(ab, "failed request irq %d, for group %d : %d\n",
+					   desc->irq, irq_grp->grp_id, ret);
+
+				for (k = 0; k < j; k++)
+					free_irq(ab->irq_num[irq_grp->irqs[k]], irq_grp);
+
+				netif_napi_del(&irq_grp->napi);
+				free_netdev(irq_grp->napi_ndev);
+				irq_grp->napi_ndev = NULL;
+				goto fail_allocate;
+			}
+
+			ab->irq_num[irq_idx] = desc->irq;
+			disable_irq_nosync(ab->irq_num[irq_idx]);
+		}
+
+		vec_idx = (vec_idx + 1) % num_msi;
+	}
+
+	return 0;
+
+fail_allocate:
+	ath12k_pci_free_ext_irq(ab, i);
+	return ret;
+}
+
 static int ath12k_pcic_ce_irq_config(struct ath12k_base *ab,
 				     struct msi_desc **msi_desc, int num_msi)
 {
@@ -294,9 +401,23 @@ int ath12k_pcic_config_irq(struct ath12k_base *ab)
 		goto free_msi;
 	}
 
+	ret = ath12k_pci_get_user_msi_assignment(ab, "DP", &num_vectors,
+						 &user_base_data, &base_vector);
+	if (ret)
+		goto free_ce_irq;
+
+	ret = ath12k_pcic_request_msi_irqs(ab, base_vector, num_vectors,
+					   ath12k_pcic_ext_irq_config);
+	if (ret) {
+		ath12k_err(ab, "failed to config DP irq\n");
+		goto free_ce_irq;
+	}
+
 	set_bit(ATH12K_FLAG_MULTI_MSI_VECTORS, &ab->dev_flags);
 	return 0;
 
+free_ce_irq:
+	ath12k_pci_free_ce_irq(ab, ab->hw_params->ce_count);
 free_msi:
 	platform_device_msi_free_irqs_all(&pdev->dev);
 	return ret;
@@ -307,5 +428,6 @@ void ath12k_pcic_free_irq(struct ath12k_base *ab)
 	struct platform_device *pdev = ab->pdev;
 
 	ath12k_pci_free_ce_irq(ab, ab->hw_params->ce_count);
+	ath12k_pci_free_ext_irq(ab, ATH12K_EXT_IRQ_GRP_NUM_MAX);
 	platform_device_msi_free_irqs_all(&pdev->dev);
 }

-- 
2.34.1

