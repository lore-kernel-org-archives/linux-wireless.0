Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8920F39A04C
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 03:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792120957; cv=none; b=gT9YrqfhhOol3zXC57BNi2JlGmGE3LqrLUYpHHgzerD322LMgBQTu5qQjlEBe1LN/fCMMMY4HNLHQikL+BRFTRk1ifSlFYGHh0r0H5wjnK9n4evDdnL1SMDpleJvkzqVdUDCzaDVUuDS9g8LH4v24/AquiPCURgG2egmsgHyLnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792120957; c=relaxed/simple;
	bh=0QRbdJf2wr23jgxU8aOFYqXhwWKN+nfRv5rDGTDGjwI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=P956WYGBkRqCdW84jbDUe/1b3/1Z1/J1PxmKDgQHFjArPPkun/MFxRDhX8Y8grVTfk3NPnhvfSNkB1/gSonccajTWysXs4UymhnlPv6Vdo7B4r5eyrJ1uQAmq9sroy3hKHRyYUk7IOOobtLSLDrKfV3/XpIQEqftgqUiqPUOFZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=AVei3o0r; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Dd2YI6g/; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="AVei3o0r";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Dd2YI6g/"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FKKO8M3800216
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 03:22:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	7QPZlqB6JbLBBQy1E+Vaf4lakspSDZfLvql5vmZjMlk=; b=AVei3o0rrTWrsVxr
	W46F6cdjgt3FILt2kZ9zKhEjv1/RcpUmshgO9L+dHNvJaMj8x8Nd7cmFZE+r77mj
	/iioxgUCbRTUzFILr3jiPv+vMaZBrpaoEzHqMQa8QjTo3GcIPr3+teIxTYYxtHTA
	vF+Syl2RcojLMnhp7PqORRkJP+modeeJmaQ4KCtMOGOX13s7z41Apt7Ic5mT6hhv
	D3sGd0baTlv76j+VTICyRDJLCnzeY+gt8Trw8CGGD2EyR7ky4JGt8us5wP5XNehg
	g34SnLYISys1dl5C2K7ElguY9kbgSlj2P+Vcf5uULIbNYTzg//oFWiWbDuLlXzMh
	OjT80g==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hb5se99rn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 03:22:35 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-3592749a017so549865eec.1
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 20:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792120955; x=1792725755; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7QPZlqB6JbLBBQy1E+Vaf4lakspSDZfLvql5vmZjMlk=;
        b=Dd2YI6g/brFlNWzDtNdo/Wt871uyfcELVEJtyCnBsq92rgAfkVbxDdtoraCDlVVfgF
         UlT+Y5lxltjpSYre5mD1R22XQzDlH30mzhF2qQZrmg2e5nQ8KYEh/2dCsLznZdkHOMYj
         JEnP1LOLsgsZ82BZZOJ33KC5D4FN0rPJeXNJoRWsWvsA0ouCvhFr25qtYJid/t1btrTu
         6bonT5xTKY9lVpvS/qcrT4GsMycMlvm9DYEjYF/DgUMcf1YLfzBkJ/ErrWbDfQYip8QX
         kZkP/R9G5dc/lmZs6HUv2HdH6nJXEqfeibeRp+TBwEE0fzeH3h6sSG1fZ7MVy14Q5aNN
         GBBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792120955; x=1792725755;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7QPZlqB6JbLBBQy1E+Vaf4lakspSDZfLvql5vmZjMlk=;
        b=ighUHMXm+lK0nlYdwOIB5S/xn/M0EeQqFKlHBv8P/V3caDeQ28NSZPjDnT6QKbmJNK
         NNJogCt1ZOjaO4/HqWptJrpdeNrniovFgf3Twv3XCug4ibENYUwbUZCXyOjTzSEKpgs8
         baN7oMsG5U/OWqL9OKM3vuUlLLbfLdkRnLCNGMFqfeyVdH8iAbX2TFH1v75Gemt5qKno
         MmyB2z25h7WWpMq8Ts6yVMhSo/UVsDiMEgD0C5zaSXAaGFOArKIOh+BtySPS2jjzYU7n
         rBnjR3UpE9moU6nV+Brjhnm/CDl31ecLfLoo5Bdaxt0cMIVBbWNSiD6gf8pj7QJBCf4a
         Lejg==
X-Gm-Message-State: AFq9FYJ+Y2ddFqDUud3QeBYUEmXLC23OfQr31Y8mmlkSSTZ3uKF1Rd1n
	mGipT1KjRY+3e737ipL/acT3tN3qNzhuaLLsApA6sIAAUEYTi9mZeKWyhwAzGqw66svuch9m/lj
	dtQ1yOVd8jVuCbd/h56KG39ZcxhJ+0F7+zFH9QDFwDDwJWCjChXgDNloKR0BQr99sQ9v78g==
X-Gm-Gg: AYBFou0DuBMEieSC7837uJBWQyuzL+qTIO10I9crSC+eO2JL8U6lvt1i7Xi9V9PXhz6
	doY90y6Fdd76yUaHclyat2EqBz7rlW0uygScR2qDPAV38aMX9kpy1Y4vD7DXegDQ8F8OsXnPVNQ
	039tFJieJgHRusofiHbOqCB4OtaCmEuN3+JWkqXDNRDPvJXsmJFs4N+oIaIUROmw0jFHInCuUnT
	QLFJHV0Vwf2Dw1zxEwAHKCn2/GD+f1zSjOsqi6/GC4ObjwccBNwBpYqWsTMcgUncyPVQddqaR8y
	ZQOgTsKiTAvBqvJYptG7h/cZdahfYZtPtneAZhywyPFdQbhz5ktJRHjLgvaYgvACAfav/qkbGqF
	ceh1oOyqNIB7fGs/z+Su8MjVAPQ4tOSH50LFEQV0XN+tA2wMGi9t14Q310cp3hQhO327HbjtmyF
	OjURWz86TNEv+yP07QtUUCgw==
X-Received: by 2002:a05:693c:808d:b0:343:5f5f:eef0 with SMTP id 5a478bee46e88-3602f1757f4mr2286963eec.21.1792120955108;
        Thu, 15 Oct 2026 20:22:35 -0700 (PDT)
X-Received: by 2002:a05:693c:808d:b0:343:5f5f:eef0 with SMTP id 5a478bee46e88-3602f1757f4mr2286935eec.21.1792120954568;
        Thu, 15 Oct 2026 20:22:34 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-360819be413sm2256698eec.13.2026.10.15.20.22.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 20:22:33 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Date: Fri, 16 Oct 2026 08:51:47 +0530
Subject: [PATCH ath-next v2 10/17] wifi: ath12k: move MSI config to pci.c
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-mpp-bringup-v2-10-f510c33bfcf5@oss.qualcomm.com>
References: <20261016-mpp-bringup-v2-0-f510c33bfcf5@oss.qualcomm.com>
In-Reply-To: <20261016-mpp-bringup-v2-0-f510c33bfcf5@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath12k@lists.infradead.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDAxMiBTYWx0ZWRfX3wRjkuZrvt3/
 BIUUyEPiQH8k8gkwEi6bJH8zvlrEbhps+dbiH1jfCcY6SSQFqf2RCy85JCTXye5FljYx44mJVUL
 VagGxhBuipfypDDsVdOJXiGhjctXVOk=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDAxMiBTYWx0ZWRfXxfJmW1nSaNMJ
 Tz7rJAJKcPhcf/p8cEVWrsEIkwf/EDF8lqR8DGlAqYPwLort8Jj709HciZAJQHS0EaPpKlL2nli
 SXr1kchNzP9+Hm0uBL53Xo5pd2Mb/+HuRhwmvQcnhEnPJat1VNYWzD7R0H+2yt1Xk8rJAbkpsRi
 YIOdfDbG8TZszBO8NiSXrk32nX4cJyJiurG4ksyLEkZioSRiBzMoetdsae9cWdcHZt5J0DrbCuC
 cd2MEn7BdUsiWgvc9ZNjDDBNgAO4ykmiDywQOz6zsHhcpLYQhfmJBQoq2+IYgwumhnwi/4S11qw
 B0ShMDp0U2dpGdW5H6srJK0IrRdGjcd0oVKdeB8X0kwSmKi7wyy+2KETYBOOpPYfc8JjUXw0MQi
 3d92pyqzEWY1JdjotQCySD5B0TAnhuzxzby0V3bYv3JSN4X7oeXjrRO9dt8kdj2EaOED27VUXaT
 kntjhn0/QRVZtvcIqog==
X-Authority-Analysis: v=2.4 cv=P4yvFSAu c=1 sm=1 tr=0 ts=6ad1987b cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=qUmDSaCxm7SoV8805q0A:9 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-ORIG-GUID: h3LhHsvu9EKZmRMr1Cw1z0oh74tppqKb
X-Proofpoint-GUID: h3LhHsvu9EKZmRMr1Cw1z0oh74tppqKb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 suspectscore=0 lowpriorityscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 bulkscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160012

Move the ath12k_wifi7_msi_config array from wifi7/pci.c to pci.c
so it can be shared between QCN9274 and QCN6432 devices. Rename it to
ath12k_msi_config.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.6-01322-QCAHKSWPL_SILICONZ-1
Tested-on: QCN6432 hw1.0 AHB WLAN.WBE.1.6-01322-QCAHKSWPL_SILICONZ-1

Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/pci.c       | 14 ++++++++++++++
 drivers/net/wireless/ath/ath12k/pci.h       |  2 ++
 drivers/net/wireless/ath/ath12k/wifi7/pci.c | 19 +++----------------
 3 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
index e6fe891e58b1..fe0939ca890c 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -40,6 +40,20 @@ static const struct ath12k_msi_config msi_config_one_msi = {
 	},
 };
 
+/* TODO: revisit IRQ mapping for new SRNGs */
+const struct ath12k_msi_config ath12k_msi_config[] = {
+	{
+		.total_vectors = 16,
+		.total_users = 3,
+		.users = (const struct ath12k_msi_user[]) {
+			{ .name = "MHI", .num_vectors = 3, .base_vector = 0 },
+			{ .name = "CE", .num_vectors = 5, .base_vector = 3 },
+			{ .name = "DP", .num_vectors = 8, .base_vector = 8 },
+		},
+	},
+};
+EXPORT_SYMBOL(ath12k_msi_config);
+
 static const char *irq_name[ATH12K_IRQ_NUM_MAX] = {
 	"bhi",
 	"mhi-er0",
diff --git a/drivers/net/wireless/ath/ath12k/pci.h b/drivers/net/wireless/ath/ath12k/pci.h
index 3097afb03432..55cc875f9ce0 100644
--- a/drivers/net/wireless/ath/ath12k/pci.h
+++ b/drivers/net/wireless/ath/ath12k/pci.h
@@ -96,6 +96,8 @@ struct ath12k_msi_config {
 	const struct ath12k_msi_user *users;
 };
 
+extern const struct ath12k_msi_config ath12k_msi_config[];
+
 enum ath12k_pci_flags {
 	ATH12K_PCI_FLAG_INIT_DONE,
 	ATH12K_PCI_FLAG_IS_MSI_64,
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/pci.c b/drivers/net/wireless/ath/ath12k/wifi7/pci.c
index bb617bb6b71a..783c5d020f07 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/pci.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/pci.c
@@ -37,19 +37,6 @@ static const struct pci_device_id ath12k_wifi7_pci_id_table[] = {
 
 MODULE_DEVICE_TABLE(pci, ath12k_wifi7_pci_id_table);
 
-/* TODO: revisit IRQ mapping for new SRNG's */
-static const struct ath12k_msi_config ath12k_wifi7_msi_config[] = {
-	{
-		.total_vectors = 16,
-		.total_users = 3,
-		.users = (struct ath12k_msi_user[]) {
-			{ .name = "MHI", .num_vectors = 3, .base_vector = 0 },
-			{ .name = "CE", .num_vectors = 5, .base_vector = 3 },
-			{ .name = "DP", .num_vectors = 8, .base_vector = 8 },
-		},
-	},
-};
-
 static const struct ath12k_pci_ops ath12k_wifi7_pci_ops_qcn9274 = {
 	.wakeup = NULL,
 	.release = NULL,
@@ -103,7 +90,7 @@ static int ath12k_wifi7_pci_probe(struct pci_dev *pdev,
 
 	switch (pci_dev->device) {
 	case QCN9274_DEVICE_ID:
-		ab->msi.config = &ath12k_wifi7_msi_config[ATH12K_MSI_CONFIG_PCI];
+		ab->msi.config = &ath12k_msi_config[ATH12K_MSI_CONFIG_PCI];
 		ab->static_window_map = true;
 		ab_pci->pci_ops = &ath12k_wifi7_pci_ops_qcn9274;
 		/*
@@ -130,7 +117,7 @@ static int ath12k_wifi7_pci_probe(struct pci_dev *pdev,
 		break;
 	case WCN7850_DEVICE_ID:
 		ab->id.bdf_search = ATH12K_BDF_SEARCH_BUS_AND_BOARD;
-		ab->msi.config = &ath12k_wifi7_msi_config[ATH12K_MSI_CONFIG_PCI];
+		ab->msi.config = &ath12k_msi_config[ATH12K_MSI_CONFIG_PCI];
 		ab->static_window_map = false;
 		ab_pci->pci_ops = &ath12k_wifi7_pci_ops_wcn7850;
 		/*
@@ -154,7 +141,7 @@ static int ath12k_wifi7_pci_probe(struct pci_dev *pdev,
 		break;
 	case QCC2072_DEVICE_ID:
 		ab->id.bdf_search = ATH12K_BDF_SEARCH_BUS_AND_BOARD;
-		ab->msi.config = &ath12k_wifi7_msi_config[ATH12K_MSI_CONFIG_PCI];
+		ab->msi.config = &ath12k_msi_config[ATH12K_MSI_CONFIG_PCI];
 		ab->static_window_map = false;
 		ab_pci->pci_ops = &ath12k_wifi7_pci_ops_wcn7850;
 		ab_pci->window_reg_addr = WINDOW_REG_ADDRESS_QCC2072;

-- 
2.34.1

