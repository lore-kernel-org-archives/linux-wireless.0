Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7CE498926
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 10:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791455111; cv=none; b=lmv0hHW+IdBmVlItqqhaWSfLY1yGDoowAhKxgnx24Y8B6cHc61jz0tARvuw/JiS0rdwpJ/Nz9q07+VDSBUrrkkfbVkioGcDpqi2EjzNTeeqyFvqDTsRZOveJCPhjVHNJt5sw4YxuyKBsoUc5DYevGdlkwmcw6lhApkq+Aw4r4Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791455111; c=relaxed/simple;
	bh=jW/7UUDyL3HyaN/gTigzVghK+/J4tjjNR3AC6QLyfGc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=J2i3F7YySxHM3fQJv4y1j2R603DJAqvLZdXcw6sNBJ1c5hmMvX5zgCiZKzUzJvSfZnUIWp1ogFThi5aEO1C9PnM0Sv90B3ESdw2ChEtaW12xdC3CGKccC++DWpnVtef06mzVLWStjK6h6ERrpwMMXTy/4fUDaqAuDa9IK+HEjOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=p2b9QZDX; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=LKaWBhFR; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="p2b9QZDX";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="LKaWBhFR"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6987KBZA1574597
	for <linux-wireless@vger.kernel.org>; Thu, 8 Oct 2026 10:25:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	BPtAgPGyDX4LIJj5+VGGoUZSUG3Qs2DKqEGaZSXoIRo=; b=p2b9QZDXX7ZDbeFy
	ebmcmmol5rEQN0jZIN6IPEv9yA8H8+80VdrIUWyN25+DtpTjev10eLrDYUQEoliP
	rauE0BfamkHR7EwsaSn0i9678zjSz3MblSHFRv9japULJ3ouBZ3NGVWHlV4xkeY6
	gRPul9SpSzdWmrn5bj2xNufHRXLTpa5i/ky3IKOqawD5QsyBtMte+mYTr0xUKGEi
	bvACm8ZSCao3B7NhjnyT1vFon7myGfPxRsF4fdaPtyEYFbdbffjWep91jtDKsjYA
	Uy0w+1kQ5F557CvDrkUwHADtkplRK1gLB0AE1AB2YFCzR5exC23R+6iLRLvK6H78
	RtflbQ==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h5xe52fgn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 10:25:09 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2df375fb9b2so54482505ad.2
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 03:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791455108; x=1792059908; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BPtAgPGyDX4LIJj5+VGGoUZSUG3Qs2DKqEGaZSXoIRo=;
        b=LKaWBhFRFsMjgWIMSFQFQXRbGmzTTqtX1SeZRyLfulDYv5GvIDFiFnQq0dJkrpHUYR
         dJPTdRDEj861RwGSt4euHmElkcVzFbQitplK6v9wMgMx4JrUJvOPD9g6WG8NZ9Y5HVBD
         CeJ5OPLgJ+9CGTaVVemfn4PoFoJ/Aw7wCkYydNyK8N5j62UkXXWOg/jXtG3cbR/6Z+7W
         37M77mXd4TPUbQ3sYPUw2VPKQJyx8G8d3Fu/+cMqee1bSXYXgHkg2du8eebfFTLsfvf5
         QU2iK5TIg7iX53uNVzhcmciRDatK568+RhVhzUiPSS8IzanIdk9N5KKvcPfM5WQckHJP
         qtTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791455108; x=1792059908;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BPtAgPGyDX4LIJj5+VGGoUZSUG3Qs2DKqEGaZSXoIRo=;
        b=a7cxWZjLdzfYexbxXu+HuMzpIS1D1zzNOBDpA30upY/yfqTn3ZKz/VmPQFVXpLoLLq
         PqvqhfTsdYDIWKkSLzQHUHaSOHrpEYbgiVoZsl2Iaz9wE+ezuL8wuGyS/+H95KLI/R6C
         0tBqIEH5DoOCyeZsThz/WTk6UVE4AtFyra/I694i5NWZy3RfuSw77t3QcPV/ZeC7k5x5
         OU5RnRLWaH7ejjKEX0OQC+hGUj9q7F/uMvMoPEZPDbMEk3vx4ZluDXc06UhHXdORWCV4
         VMDRSZEewm4gagNdjKw+Qf+0Bep6dJXQ7WS2USBves99QcLjOtUtlFFwaZKw7SL6AxQj
         bFYA==
X-Gm-Message-State: AFq9FYJmcC4yCG52C3IpRzQ0TuQsXujoduKs53xIekHBPM8Bt5dE6bws
	FO+6c2tLx9I5nJTYnRtHC1QKrqqfwJlgJeBcYFnjpLk5TRwGHSTw80Z4r9uS8T2poq8EaWm8MOO
	m26mZ23YSU5HVYxB8VMXa3hqfLfVAt/39GQE87JJOmvudgqSgKXq7KW04v3gHkqG3V613ag==
X-Gm-Gg: AYBFou2gj3RI3AkCHc2cfcTfkg9gq13GP6dWo5UO5QCBGKADowUuFU1+Af+PQXnvCGw
	FaADue0wqIueEJE4UfL8s6g+AE4A3DQyKPOl1stwFsPkJ6c2yiCiKJ8MLEsXWMs0yw+6OJRWgdq
	wkHnYJx+d1C0xjn1otkDNe261upJXSmthKIeytzplL34EG4riPp01NOUhAoUpD7kc2TGO0EeHl3
	WZ+Kuwt+PvfnhWo0G/acPD3QnFtkV3PRb5krDSB9ETeFVlaVkfitmdnc79gD4RrWbbj5wN7rp+j
	1jN4rcDw8w+xsVRA+Q+y/+QmQAxLOrAe3U5vjoa27A/dKy7vWqML7CksthuNowU3OBfysx1ez8o
	PK0WcRi0NpFzL9f7tZi5H5dPzm+YGCz0rDJOgT3/Lb6GX4CQkFphgstqI9mFj1ZSU7Yi4KfCqOE
	O96Q2zoEMobZYBmllHAbOOWA==
X-Received: by 2002:a17:903:4b24:b0:2e2:ffcb:87a9 with SMTP id d9443c01a7336-2e6003891d5mr41562025ad.24.1791455107018;
        Thu, 08 Oct 2026 03:25:07 -0700 (PDT)
X-Received: by 2002:a17:903:4b24:b0:2e2:ffcb:87a9 with SMTP id d9443c01a7336-2e6003891d5mr41561715ad.24.1791455106508;
        Thu, 08 Oct 2026 03:25:06 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e6046fe39csm22081655ad.16.2026.10.08.03.25.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 03:25:05 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Date: Thu, 08 Oct 2026 15:54:08 +0530
Subject: [PATCH ath-next 12/17] wifi: ath12k: Enable MSI interrupt support
 for DP interrupt
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261008-mpp_bringup-v1-12-2c5797b5e4ac@oss.qualcomm.com>
References: <20261008-mpp_bringup-v1-0-2c5797b5e4ac@oss.qualcomm.com>
In-Reply-To: <20261008-mpp_bringup-v1-0-2c5797b5e4ac@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath12k@lists.infradead.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
        Sowmiya Sree Elavalagan <quic_ssreeela@quicinc.com>
X-Mailer: b4 0.15.2
X-Proofpoint-ORIG-GUID: RvOwzx-G7UwV2kJZn-ZutMr01uf9RyD0
X-Authority-Analysis: v=2.4 cv=E4dYNqdl c=1 sm=1 tr=0 ts=6ac76f85 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=COk6AnOGAAAA:8 a=EUspDBNiAAAA:8 a=3HAlypJ90nm0-WewFtkA:9 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDA0MSBTYWx0ZWRfX8viUGEmu4Jnp
 yE8LWShOZIC3b7KHV85uJAYnBJIGQuDinYO9D9Lk3P5HgUu1I6f+3Awb8fCHshPizxcYnG1pjne
 LwazMhWgkycqbRry1WnuaknFZ1vGBnk=
X-Proofpoint-GUID: RvOwzx-G7UwV2kJZn-ZutMr01uf9RyD0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDA0MSBTYWx0ZWRfX7Pgey6l7Xrz4
 ytDQU3THmDc1dJdOwy4U8fQtpgD8ZZ9GWvVyGgasvHnmmnz+ZoaxMuCu8U3qzjpaa7FSTSPaGpR
 zwW5eZnC3aU/ZX101UwiEVdVcwFhFpnp8dQlbaRo2eBaTvFnvlPO+jo+4KgKJIgj3AH8MHaXPam
 F3QO1xmOQtictHjMPG2dUUus2xSKfuqgiyp5KPVo9zPgBowKFvuJW55wssY/JhZWCfx0yDzM8b5
 MrmWuw2KOoVopI8yPFEojfHSMT+no7Dfk7YoQqit5N9TBBTWpfJqGTsMTZ4/5i/x06P/ANom5wj
 T52Mwlo/h2jAyOSePnqDEO0KLG2uV6FU/1EMm5A2BHxJbgy7fzTxUv97OKn053HwsoLwhYXb/Yb
 G5HN64/r37ZCwkJxcTGrfJy5n3O7UBjpq7aPOefvur9ACfGBzkBBPpx6XJzEwYPXZXeWPuisjJv
 G+INOwPewB8xZHLXLoQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_03,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 phishscore=0 spamscore=0 impostorscore=0
 clxscore=1015 priorityscore=1501 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610080041

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
 drivers/net/wireless/ath/ath12k/ahb.c  |   1 +
 drivers/net/wireless/ath/ath12k/core.h |   2 +
 drivers/net/wireless/ath/ath12k/pci.c  |   6 +-
 drivers/net/wireless/ath/ath12k/pcic.c | 121 +++++++++++++++++++++++++++++++++
 4 files changed, 129 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/ahb.c b/drivers/net/wireless/ath/ath12k/ahb.c
index 78367126f49f..892872f70b2f 100644
--- a/drivers/net/wireless/ath/ath12k/ahb.c
+++ b/drivers/net/wireless/ath/ath12k/ahb.c
@@ -558,6 +558,7 @@ static void ath12k_ahb_disable_irq(struct ath12k_base *ab)
 	}
 
 	ath12k_ahb_ce_irqs_disable(ab);
+	ath12k_ahb_ext_irq_disable(ab);
 }
 
 static void ath12k_ahb_ce_workqueue(struct work_struct *work)
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
index fea284c3707b..06178b4f20d1 100644
--- a/drivers/net/wireless/ath/ath12k/pcic.c
+++ b/drivers/net/wireless/ath/ath12k/pcic.c
@@ -181,6 +181,112 @@ static irqreturn_t ath12k_pcic_ce_interrupt_handler(int irq, void *arg)
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
+		desc = msi_desc[vec_idx];
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
@@ -294,9 +400,23 @@ int ath12k_pcic_config_irq(struct ath12k_base *ab)
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
@@ -307,5 +427,6 @@ void ath12k_pcic_free_irq(struct ath12k_base *ab)
 	struct platform_device *pdev = ab->pdev;
 
 	ath12k_pci_free_ce_irq(ab, ab->hw_params->ce_count);
+	ath12k_pci_free_ext_irq(ab, ATH12K_EXT_IRQ_GRP_NUM_MAX);
 	platform_device_msi_free_irqs_all(&pdev->dev);
 }

-- 
2.34.1

