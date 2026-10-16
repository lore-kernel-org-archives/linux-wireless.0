Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C536A35C197
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 03:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792120931; cv=none; b=PMkE8/dnpWdwxew6vOKulg6nClwIwy2lPvUcEe7xd0yYqAQIOfhKUaMfTq2M2di8HPHNlgJzErq8HeAKq+mMWnU3LzfrA5NZOa0v/be7WIngjHYrUeI+WYjfA6BUFC011EX0OsW8dzuiRMsMLi8z8CEtzGT4YPq1chkKhXd12LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792120931; c=relaxed/simple;
	bh=/UU8GJTxDpInLuxZ9mNJMxg54IzilmGy46v57pGMLug=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CE2go7shdiQ6wl/Tw+w43GIpqSUjq1Ublvhnsvi2nTlD5dQ4bk+yoJrMCY7ZaZgUdpymfAmGI8Dmlv654DGOrCAfUX4s2+/fTU0bAN1X6gETTVmCioYRvIeyDwTB2GIPnhDUjx2Qnxd9jTNaVi4ba+3fA7nS67R/J48klqY9wCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=nyS3D/YC; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=DEdylz5u; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="nyS3D/YC";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="DEdylz5u"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FKKUT63800297
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 03:22:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	PBDv/dTqiVEnzWEKRasuco/mmrDrzRIuItpv/7sGIcU=; b=nyS3D/YCe4ByCqib
	kM2nq7F6rC7b0fNdQ45GGjg4pKUiKGB0iYLad+1SXCE7fszRIu3MW1RyzGwg3P/p
	lCi9Z/+q41ayELgIFiwHqxnF7gRNDsTohW7h9XJinwsRhw/k2/UOOmYmTq0YsLh4
	u1k4I7Z59w6LGqYiWVCy6CIhcRgVgexCNzmswZEt10s9hy3Jq0pRWt14NSSjLyL9
	YoZ47KSvEdfOLph+/jI6anCviaIJQoEm7belqhnWs7iJlmnqrs0hbe6AayHRBvej
	VeJBjc+UA9HBWimDxmLIwNRVEr8i3EoGIZl2QFNv7ajJzFMgputj+yq/gsSAgeuM
	PNEAuw==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hb5se99pw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 03:22:08 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-341eff9e381so16724337eec.1
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 20:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792120928; x=1792725728; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PBDv/dTqiVEnzWEKRasuco/mmrDrzRIuItpv/7sGIcU=;
        b=DEdylz5uK5/EhDYllSKk/o0CT1N08BaonUqOWQkZkBrVnYoLmyyinVTkSv8yvTK8pK
         cY/wPCX/E7TZ0NU5EtTuPkTsiGfY0cZ5uvyFz/eiiyFLUd9bnoDrDUx7cb32mniaemdK
         LcgrDQBMvTOpB49JJM2IbGTmLTxMjsdLgG0rf8jrOfw3JXr7A5xs9ocPnDvOuzmJttIV
         3i8R8TfVED61pJdJQjdoBlDd4HJF0AAzL0k2WQhMa/cRMr6HUCsqtVNdaWOcWazLGWrd
         mCxhMin/zL2Xk/dmMVzxgdc80Af8M0P8MLNvpP4wn9vnhTujMsr4GCqjQDZD5yxYLxDo
         Crpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792120928; x=1792725728;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PBDv/dTqiVEnzWEKRasuco/mmrDrzRIuItpv/7sGIcU=;
        b=PqR3yorHByVmLB1YSza5yd/2d4PCEZvTOhn7FJsZ6/zJnojSGxvbbWgSNey0MnEL/p
         X1IoosVFSmQH7CeslcnDMTWUHQFAPXYUGg+C6zfC4eGujkqeJU1uMjnjqgYp9OigH2yF
         7miUXtX5txy643HCtGF9px06fgb44XMgFosY2CekjE9QbHHDCASrQPi9qMgNwIpYz7YN
         BARs2BC61DpjFa2HEeelNDpsgGo9OGBZr0YhOaOfHEh+2DPx49jvj+k7MzeBouf/Ko3c
         IV+DBHcid6UJwxDIg2TGqH7epD1JNoSsq2Qc4RJxWCIeDOIaETWTHegl61vAkI9BdqqR
         FDkA==
X-Gm-Message-State: AFq9FYKVTkPp7y7fHOJtSjTrlQQ6uiXvUIhHKz5nyb1Rt0zQjvMOozhq
	keS3vu7aw0v1mZgcv3dUERkva2eDkVWJ8voCyQA0DMbhKkPhxirWxv4haozvN5jedcZ4lFsUCV4
	8e15ss8/jHnQ+hJXEtz3Rw2mu1tIJ1D/wD2OCwh4PWWkuVkFVVMDdcgcKDCgJA5BsnGTYvQ==
X-Gm-Gg: AYBFou1d5sAG669vnFrHMlfo5DlufuFZBnXxe1q2HiO2FjZbzsjBm8RAlanO8YN8wld
	V/tqdRTvRqlwgv68wjZzrpcqsTgwj+rZkrnVkSSXkKvXI+S74B4WUbzVxsbzLLd3cmIloaidaYD
	IPp5ZueFTYPn7YZts7V0v/bXu3Gb5CpUY69N7gPhTh4he3Ipxw9rPWpC4jPLBDK+aKGOVw5HQHh
	MPRIlffrLdy4AiZ12x2BfEMPzzot811mKr3UmdiQuCc/dUn0oPy3BuY1sWjCI4iO3byrC0K6Nim
	9THuO4XXwdaH9WD3V1ls2HWV5mx5AOkRYNnYna4HiJL8B2IqZEArhyvWhek/YdXsbOAvVUlfjZN
	gsP5L4++RS0X81hO+Px23t5fT/uXooNCCz8CXYmM9JvRI2ord/RBzHQooMFV+0rL5xcJlYUCwva
	tyARM3hyUFXH0ZvMxSgGDbPQ==
X-Received: by 2002:a05:7300:e9d6:10b0:354:1db3:674e with SMTP id 5a478bee46e88-3541db367f0mr30095081eec.6.1792120927939;
        Thu, 15 Oct 2026 20:22:07 -0700 (PDT)
X-Received: by 2002:a05:7300:e9d6:10b0:354:1db3:674e with SMTP id 5a478bee46e88-3541db367f0mr30095052eec.6.1792120927321;
        Thu, 15 Oct 2026 20:22:07 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-360819be413sm2256698eec.13.2026.10.15.20.22.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 20:22:06 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Date: Fri, 16 Oct 2026 08:51:41 +0530
Subject: [PATCH ath-next v2 04/17] wifi: ath12k: Add hardware ring mask for
 QCN6432
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-mpp-bringup-v2-4-f510c33bfcf5@oss.qualcomm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDAxMiBTYWx0ZWRfX6xiL29OD8Oa6
 ba2zwZuMMJ5gGFTZAWRPYccU/TRuzvnpuDKW+KU0fXCuLPUiyjgr6DQuCR/M2FDz/q89D/sP5+H
 +RyDaLNhK9sUbbep4eSRqdvTEL0w/ac=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDAxMiBTYWx0ZWRfX7WVRT0qb0cxW
 lf5pnXFQm54TUgHK1mWXbOur7y6HQOlJdyEBNOozD8rU3c4CRDRkt0JxNr+u96jUwXERv+GbNn8
 HwsHfnFGKjsSPM6VtIHvITwKx05viy4DyGb9GJBsBxfYp/6JckXXCQF5o232PCCxvTfdP9CZhRJ
 4ycvW6odQbhzqEV1gg1f2J4DCCnSpmi/bcBDkyAPqZTy066k0g+fIZbBCpKQSG7Mrjd/icKheEb
 ejxz5ajdn8UYCi/0Puu6VmtiZxm9k35Sg43lsoc7GvLcaHVGmQix155AkXiVCYgMTUo33jN1Jgk
 qSUXKZtCHS3oIII7KQevb0UzXm6+xSUA5nYd2o/juSZifG+xct6ODdqTQW1jPvzbvAcey+lbdRu
 FKvxn23JDKpFwZZEuZk+hDBC3esnbjLWyfm417xyTzwgokurVcnzgfjN6fZPtELTQQkFwUJ/Vpt
 mvKbBurCAUAnnQFr2BA==
X-Authority-Analysis: v=2.4 cv=P4yvFSAu c=1 sm=1 tr=0 ts=6ad19860 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=COk6AnOGAAAA:8 a=EUspDBNiAAAA:8 a=qBdOBzyLVJzNEwNtDhoA:9 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-ORIG-GUID: s95pzj75c8pbnniBa9YYLHg8VqnFGUwf
X-Proofpoint-GUID: s95pzj75c8pbnniBa9YYLHg8VqnFGUwf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 suspectscore=0 lowpriorityscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 bulkscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160012

From: Sowmiya Sree Elavalagan <quic_ssreeela@quicinc.com>

Add hardware ring mask configuration for QCN6432 to support interrupt group
mappings for various hardware rings.

The QCN6432 requires a different ring mask configuration compared to
IPQ5332 and QCN9274, with support for up to 12 external IRQ groups
instead of the previous maximum of 11. Hence add a dedicated ring mask
structure that defines the interrupt group assignments for TX rings,
RX rings, RX monitor destination, RX error handling, RX WBM release,
REO status, Host2RXDMA communication, and TX monitor destination.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.6-01322-QCAHKSWPL_SILICONZ-1
Tested-on: QCN6432 hw1.0 AHB WLAN.WBE.1.6-01322-QCAHKSWPL_SILICONZ-1

Signed-off-by: Sowmiya Sree Elavalagan <quic_ssreeela@quicinc.com>
Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/hw.h       |  2 +-
 drivers/net/wireless/ath/ath12k/wifi7/hw.c | 52 +++++++++++++++++++++++++++++-
 2 files changed, 52 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/hw.h b/drivers/net/wireless/ath/ath12k/hw.h
index 52558dd126a0..833aa6d43ce4 100644
--- a/drivers/net/wireless/ath/ath12k/hw.h
+++ b/drivers/net/wireless/ath/ath12k/hw.h
@@ -127,7 +127,7 @@ enum ath12k_bus {
 	ATH12K_BUS_AHB,
 };
 
-#define ATH12K_EXT_IRQ_GRP_NUM_MAX 11
+#define ATH12K_EXT_IRQ_GRP_NUM_MAX 12
 
 struct hal_rx_desc;
 struct hal_tcl_data_cmd;
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hw.c b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
index 494c7b3ae1ac..616ff695763c 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hw.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
@@ -332,6 +332,56 @@ static const struct ath12k_hw_ring_mask ath12k_wifi7_hw_ring_mask_wcn7850 = {
 	},
 };
 
+static const struct ath12k_hw_ring_mask ath12k_wifi7_hw_ring_mask_qcn6432 = {
+	.tx  = {
+		ATH12K_TX_RING_MASK_0,
+		ATH12K_TX_RING_MASK_1,
+		ATH12K_TX_RING_MASK_2,
+		0, 0, 0, 0, 0, 0, 0, 0,
+		ATH12K_TX_RING_MASK_3
+	},
+	.rx_mon_dest = {
+		0, 0, 0, 0, 0, 0, 0, 0,
+		ATH12K_RX_MON_RING_MASK_0,
+		ATH12K_RX_MON_RING_MASK_1,
+		ATH12K_RX_MON_RING_MASK_2,
+		0
+	},
+	.rx = {
+		0, 0, 0, 0,
+		ATH12K_RX_RING_MASK_0,
+		ATH12K_RX_RING_MASK_1,
+		ATH12K_RX_RING_MASK_2,
+		ATH12K_RX_RING_MASK_3,
+		0, 0, 0, 0
+	},
+	.rx_err = {
+		0, 0, 0,
+		ATH12K_RX_ERR_RING_MASK_0,
+		0, 0, 0, 0, 0, 0, 0, 0
+	},
+	.rx_wbm_rel = {
+		0, 0, 0,
+		ATH12K_RX_WBM_REL_RING_MASK_0,
+		0, 0, 0, 0, 0, 0, 0, 0
+	},
+	.reo_status = {
+		0, 0, 0,
+		ATH12K_REO_STATUS_RING_MASK_0,
+		0, 0, 0, 0, 0, 0, 0, 0
+	},
+	.host2rxdma = {
+		0, 0,
+		ATH12K_HOST2RXDMA_RING_MASK_0,
+		0, 0, 0, 0, 0, 0, 0, 0, 0
+	},
+	.tx_mon_dest = {
+		ATH12K_TX_MON_RING_MASK_0,
+		0, 0, 0, 0, 0, 0, 0, 0, 0,
+		0, 0
+	},
+};
+
 static const struct ce_ie_addr ath12k_wifi7_ce_ie_addr_ipq5332 = {
 	.ie1_reg_addr = CE_HOST_IPQ5332_IE_ADDRESS - HAL_IPQ5332_CE_WFSS_REG_BASE,
 	.ie2_reg_addr = CE_HOST_IPQ5332_IE_2_ADDRESS - HAL_IPQ5332_CE_WFSS_REG_BASE,
@@ -925,7 +975,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 		.internal_sleep_clock = false,
 
 		.hw_ops = &qcn9274_ops,
-		.ring_mask = &ath12k_wifi7_hw_ring_mask_ipq5332,
+		.ring_mask = &ath12k_wifi7_hw_ring_mask_qcn6432,
 
 		.host_ce_config = ath12k_wifi7_host_ce_config_ipq5332,
 		.ce_count = 12,

-- 
2.34.1

