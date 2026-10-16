Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDFD36C0C8
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 03:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792120927; cv=none; b=IQa8duHs/n++bNYgoi1Gv0K3lgfJKZEhJPk0g9bHLEnH0siUfVZcl5GWoLM2F9Lo375szYlu38z6AVHv39Sy8Vjocc6XHu0H/KQ+7LYTV/v8g0C9TUZsuTv+WWDZxJaMRIAQPq5rMciSGlHPsAK27R8WyVzK8a2rMQxxR8D0N6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792120927; c=relaxed/simple;
	bh=2f5cqCxSIO+39bjVWmkyO5VC/e+fUCLD7h2BdP3uXE0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZPHUfqvXgwYv8FCh8ECqdg9ErdG36d7E41tMuUJgaZ5SDS/b0DQ4nMPGD/Jsl3kpNIpYjTO8LMRXmJZzEboJV0qPV4T8bjLYMcA25lVnfhUX0woIAsPUNnKhHCHJFQGvtNDSyQEOIja9JQZMWVJal8PjJHkt4HGz7E9mMvIi0jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=LnOGGb44; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=T4CO5r22; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="LnOGGb44";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="T4CO5r22"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69G1CGYt1890815
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 03:22:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	cFutmOhm6NeNyUgq6NlpBDGor1rLlHRNYCp+sYPk9iM=; b=LnOGGb44De/DYDCp
	3oRVyw+HfcsLpXL/Maxs3b/bbBetd/G8MhjqDjdPe18i9MFYCVp2PpG8rpohIJtk
	LMBKnDKiM/J4Q6Sw3jgGlmtKhEz6rmEqB9lpZlxt1DeKbZyUo8HqlBODgwNGdabn
	PhKKR15xX3jcokEVquuH8yCkuBzV3ocuYu4kAhc84Pn+rW+DoI1im4rKsefQX36w
	U3K7MmRacZzy7HsgabZ09xizvh+f5KNUZtthXJaaSORl2758yM0HuXAfxPm0TDy7
	DjMriN5hQUvuitBFQa/jrccLcBr1nMLTBRAkGmGOth51KCQCAUXOA+gMCge9ElRe
	4MSG4A==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hba260bw4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 03:22:04 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-35fb6be0f9fso2607352eec.0
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 20:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792120923; x=1792725723; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cFutmOhm6NeNyUgq6NlpBDGor1rLlHRNYCp+sYPk9iM=;
        b=T4CO5r22fts7v0ZzrWzsbtrO5sI7lPTKQcrg5DnuUFoGyxL5IHZJ39yOB5c4T2uAOI
         tAIDOUqQOCNqvRcf8M8WMLLTQlpjlW2np6sTTuewUIcniri694Ahmh9H+TnFD8uc3fvk
         bdUqUcdrsfNFIoGMLwQWo8TGuH1qc5+szF3O9H82CAv0M57qoznxtJXGFr0t7+czXzNb
         4vl3uu6P56RvjpQpJjYvITPmjMiZk/BuBNekHoDGKLjbvdTvRj6o0jmTCdJsn8bi06oG
         TE2mGZnGBCbC6tXxPdi88DX88I66ffNiJlH41mYXCh1xhes4c9lHg85ipzkG2LMHcPfE
         Srrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792120924; x=1792725724;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cFutmOhm6NeNyUgq6NlpBDGor1rLlHRNYCp+sYPk9iM=;
        b=u69hvxfW5nwOapve6GnT0R/C+IQNbKSS8WoV1qSdlwK/BM5GrkrmHry2gqiIuAECtg
         Xb/N4hRSFp1W6+wGhaPnraQgxu7I0zIxJTQx4gi+thtr3sqrxBBoMpldhkO7OSzoKKE7
         NiqjwMhmLNnoB/hfo3lqzfLZxiOzKjIlfKfZ7i/s4LuD10fs1xG4ZaT5Z1Q9GxEZJtJT
         tkyWBSKViG6Wwr2sfYpzLAYxfKTZ2m5EUHNb/6OVfHpw3GFPQEgiysIllXVc3QlfS51U
         Arp91MkIE0xhUo7CS8yy6FLs+AKA59Uo3WSqCyIGerOYBEvDZuH+Hjrzc6+Vp4NzFT0b
         M39w==
X-Gm-Message-State: AFq9FYJiDMEm9VxAQXMmR/YNQ5a7N76eIsewOT/4f/c74Z2xswznAg4O
	DTccVMYM4bjGhgehUtQUl3ftR8Yh966YJF6+AYLmN5CccYC7tSxl/4X3CGoQxIzpnkWrRi+JVlE
	cxEv2OgzFrYW88ejbC6SLpItLYONpPpN4ybUtPVrwXQuW9p/bWkbdeJDOroxD4zHN2W57WA==
X-Gm-Gg: AYBFou0iYMzt9VSI5/cxK8Whc7hWRLUeE6LR6Y+SV/V3+FQxHd3l9qj+1x3sV7/sAvK
	sMyGUiXUquI70GLP1jmbb8G/npayoF/QRR2+iuJMncJl3/3N2tT060SMdvWckk6MmI0biwER7Lh
	+8IKwxw97XBoVA+BwW+N7i4qnYC+KP6fcib6QIbfQJxB7I1IGGZ1gG7RH+nK3KNRg9s0ZNXwUva
	YKkzaBmfRah+wnJbVSnSdKjoLSlm6m6wUJSCEJNwaJgkzLJHlww4s3x8kwlsHsC9Wbr6RBYbOca
	s/KnFlRIKtdHoL7tmtKRaTbi0EsFdSCN3jYJjOdXDCJbYsl9ob20jkbTHPlvDHWEQO8MMjKue1n
	wIDVHzSjuXM/3LFFoV3sPgPoAbkh8rgFd34HDjIGQPPdDSBpVFOVQW6mJ0Suf4s99vGriQoFm3W
	Sh0IKU7lUSGXngM++nINPs8A==
X-Received: by 2002:a05:693c:400f:b0:360:1637:3f1 with SMTP id 5a478bee46e88-36016370a3fmr2885308eec.40.1792120923475;
        Thu, 15 Oct 2026 20:22:03 -0700 (PDT)
X-Received: by 2002:a05:693c:400f:b0:360:1637:3f1 with SMTP id 5a478bee46e88-36016370a3fmr2885261eec.40.1792120922701;
        Thu, 15 Oct 2026 20:22:02 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-360819be413sm2256698eec.13.2026.10.15.20.21.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 20:22:02 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Date: Fri, 16 Oct 2026 08:51:40 +0530
Subject: [PATCH ath-next v2 03/17] wifi: ath12k: Add hardware parameter for
 QCN6432
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-mpp-bringup-v2-3-f510c33bfcf5@oss.qualcomm.com>
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
X-Authority-Analysis: v=2.4 cv=bsHZl0ai c=1 sm=1 tr=0 ts=6ad1985c cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=COk6AnOGAAAA:8 a=EUspDBNiAAAA:8 a=IkfkkYc7qEKKYK4gSbYA:9 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDAxMiBTYWx0ZWRfX8cT6EIozeSLf
 1vJrgQ4H8jqr5zFjS+QxpHeCG//Abht+cMdgrEBeHRZCvc3ZK+h5vX4R5YrrrirVTT8PdLPBhXC
 KB/JuxIXmCI8nN8uCkEYbEh73c73prNY0rEI8mqlExts3jBYlo7X/CpFJPLffwkrRC7ogk5KjjL
 lg8IhTw2TfhrXrujzcWKqDNIy4tHSg6WpFHdxkk6D2VLE6ynb83GgrB7eIVTpJ7U8NEtxErkMF6
 pNzg1cATJqnwdSqXHR/wfca4hpIqraGfk+sfGzr4669GZfO0THLOBiRK8+G2KBOKQWiRXo8KfV/
 ExphBhhNt7iaXkxuJzgPoSzgW2dP6QiNRP8Vq7IiHAkK8SmlfYkNulHrhqxOZlkzcJP2/YGi5he
 cE8fEfoUSHVgaugFF+XVgBggCWiklIZFxsuWXqzoSDGsLlNetpf3rN8JYhAOpGpLia89SSAmGwu
 frtRmMxMHnuesVxk7rQ==
X-Proofpoint-ORIG-GUID: ZxJ68vqkj74yfpAoh4Ix8cj8y4zSmG-Y
X-Proofpoint-GUID: ZxJ68vqkj74yfpAoh4Ix8cj8y4zSmG-Y
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDAxMiBTYWx0ZWRfX3b0lJ8mwMQhT
 bpxX+rAfZR0YrUREhMStJB3fsdCg9TWGFuLzuEPAN/Xp7ITHc6CC73376MHjbkmDQVBCTBSH6qJ
 9q56YN7tGKT8/lLH6teRyOnixHv9D+0=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 suspectscore=0 phishscore=0 spamscore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160012

From: Sowmiya Sree Elavalagan <quic_ssreeela@quicinc.com>

Add hardware parameter (ath12k_hw_params) for WiFi device QCN6432.

Some hardware parameters, such as host_ce_config, target_ce_config,
and svc_to_ce_map, are identical between the QCN6432 and IPQ5332
devices. Therefore, use the same parameters for the QCN6432.

Additionally, certain hardware parameters like wmi_init and hw_ops
are the same between the QCN6432 and QCN9274 devices. So, use the
same parameters for the QCN6432.

Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.6-01275-QCAHKSWPL_SILICONZ-1

Signed-off-by: Sowmiya Sree Elavalagan <quic_ssreeela@quicinc.com>
Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/core.h     |  1 +
 drivers/net/wireless/ath/ath12k/qmi.h      |  1 +
 drivers/net/wireless/ath/ath12k/wifi7/hw.c | 85 ++++++++++++++++++++++++++++++
 3 files changed, 87 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/core.h b/drivers/net/wireless/ath/ath12k/core.h
index 993aa3f350aa..d87c59f68c12 100644
--- a/drivers/net/wireless/ath/ath12k/core.h
+++ b/drivers/net/wireless/ath/ath12k/core.h
@@ -158,6 +158,7 @@ enum ath12k_hw_rev {
 	ATH12K_HW_IPQ5332_HW10,
 	ATH12K_HW_QCC2072_HW10,
 	ATH12K_HW_IPQ5424_HW10,
+	ATH12K_HW_QCN6432_HW10,
 };
 
 #define ATH12K_IRQ_NUM_MAX 57
diff --git a/drivers/net/wireless/ath/ath12k/qmi.h b/drivers/net/wireless/ath/ath12k/qmi.h
index 1b1c88906f1e..60d5811b1c87 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.h
+++ b/drivers/net/wireless/ath/ath12k/qmi.h
@@ -20,6 +20,7 @@
 
 #define ATH12K_QMI_WLFW_SERVICE_INS_ID_V01_QCN9274	0x07
 #define ATH12K_QMI_WLFW_SERVICE_INS_ID_V01_IPQ5332	0x2
+#define ATH12K_QMI_WLFW_SERVICE_INS_ID_V01_QCN6432	0x60
 #define ATH12K_QMI_WLANFW_MAX_TIMESTAMP_LEN_V01	32
 #define ATH12K_QMI_RESP_LEN_MAX			8192
 #define ATH12K_QMI_WLANFW_MAX_NUM_MEM_SEG_V01	52
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hw.c b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
index b1c17cc197df..494c7b3ae1ac 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hw.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
@@ -906,6 +906,91 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 			.max_client_dbs_sbs = 128,
 		},
 
+		.host_alloc_ml_id = true,
+		.advertise_iface_mac_pool = false,
+	},
+	{
+		.name = "qcn6432 hw1.0",
+		.hw_rev = ATH12K_HW_QCN6432_HW10,
+		.fw = {
+			.dir = "QCN6432/hw1.0",
+			.board_size = 256 * 1024,
+			.cal_offset = 128 * 1024,
+			.m3_loader = ath12k_m3_fw_loader_remoteproc,
+			.download_aux_ucode = false,
+		},
+		.max_radios = 1,
+		.single_pdev_only = false,
+		.qmi_service_ins_id = ATH12K_QMI_WLFW_SERVICE_INS_ID_V01_QCN6432,
+		.internal_sleep_clock = false,
+
+		.hw_ops = &qcn9274_ops,
+		.ring_mask = &ath12k_wifi7_hw_ring_mask_ipq5332,
+
+		.host_ce_config = ath12k_wifi7_host_ce_config_ipq5332,
+		.ce_count = 12,
+		.target_ce_config = ath12k_wifi7_target_ce_config_wlan_ipq5332,
+		.target_ce_count = 12,
+		.svc_to_ce_map = ath12k_wifi7_target_service_to_ce_map_wlan_ipq5332,
+		.svc_to_ce_map_len = 18,
+
+		.rxdma1_enable = true,
+		.num_rxdma_per_pdev = 1,
+		.num_rxdma_dst_ring = 0,
+		.rx_mac_buf_ring = false,
+		.vdev_start_delay = false,
+
+		.interface_modes = BIT(NL80211_IFTYPE_STATION) |
+				   BIT(NL80211_IFTYPE_AP) |
+				   BIT(NL80211_IFTYPE_MESH_POINT) |
+				   BIT(NL80211_IFTYPE_AP_VLAN),
+		.supports_monitor = true,
+		.supports_cong_ctrl_max_msdus = true,
+
+		.idle_ps = false,
+		.download_calib = true,
+		.supports_suspend = false,
+		.tcl_ring_retry = true,
+		.reoq_lut_support = false,
+		.supports_shadow_regs = false,
+
+		.num_tcl_banks = 48,
+		.max_tx_ring = 4,
+		.mhi_config = NULL,
+		.wmi_init = &ath12k_wifi7_wmi_init_qcn9274,
+
+		.qmi_cnss_feature_bitmap = BIT(CNSS_QDSS_CFG_MISS_V01),
+
+		.rfkill_pin = 0,
+		.rfkill_cfg = 0,
+		.rfkill_on_level = 0,
+
+		.rddm_size = 0,
+
+		.def_num_link = 0,
+		.max_mlo_peer = 256,
+
+		.otp_board_id_register = 0,
+
+		.supports_sta_ps = false,
+
+		.acpi_guid = NULL,
+		.supports_dynamic_smps_6ghz = false,
+		.iova_mask = 0,
+		.supports_aspm = false,
+
+		.ce_ie_addr = NULL,
+		.ce_remap = NULL,
+		.bdf_addr_offset = 0,
+
+		.current_cc_support = false,
+		.dp_primary_link_only = true,
+		.client = {
+			.max_client_single = 256,
+			.max_client_dbs = 128,
+			.max_client_dbs_sbs = 128,
+		},
+
 		.host_alloc_ml_id = true,
 		.advertise_iface_mac_pool = false,
 	},

-- 
2.34.1

