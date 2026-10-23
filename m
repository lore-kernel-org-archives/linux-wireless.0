Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792738895;
	b=m+Z0F2ScaZhUsnVHsDkhIgan6O81nMnMUN5cyYz37naND0Gt3qSkR5jLvaC2rRzbDM9E
	 C/vsZRKS3bqHehJi1M8+9hgD5e7K64za4DOEtS49rzAR63+fdeB2/dmM04T1lAZTzfXPF
	 4OLrmwE8XY6/QgZgbXVx2RkwEyjZ4OHys4XFuthuQ7SN4XlkTEnbj1TmwE0FzxdowcEIB
	 KO4yD4iel59hke2CF6Rc5/cK1j873cLnvEims3YQqzxLyGtbnmqHF209eSHOAtSYGsYxS
	 +TMLLf4NVsUwKQNlgpHPiD7je4eCeAgKdyhHIOptW63UyzR2mjZ9pQ7472GLIh1UKJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792738895;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=UQ/JM6CaN1XmFsZMKDNcGKjdu1vRxBuFX7+yqFt9ezA=;
	b=xkG4niCvqJvqjuo+TrgDzkjndQWg3RS2KTRNC7UM6vsAoydqQfurSVGdzNwkNDFFbN9G
	 RqhBhX/2QDvQNTbDvdq43vGVsNCAMhTrOC2Vj8TT99MFBtikjbipTXk/t7nMX55xHFqx4
	 OsCkKcTdF6+KhMuWZldduzFdQKdMwvsKoHzjR5GfBD4XhK2mjECj7DvaIj7gmaQt51d5N
	 9VK4DeStRhYckMJrubwTGvs1ZypMj7n1Yt6o7dINTW80nuJG14AcNqh5x3w1LJ1Z2Ql/j
	 29kUk+ExvAqulboaGp0BTfA+kO2aQekIBcmnrUuAv8odWDry2lDC5KHCxu4m/SEWUeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=GyTKVD6J;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="i7cRNo/K";
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD3460A380F
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 07:01:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7BD3460A380F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=GyTKVD6J;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=i7cRNo/K
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69N1FAff988714
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 07:01:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	UQ/JM6CaN1XmFsZMKDNcGKjdu1vRxBuFX7+yqFt9ezA=; b=GyTKVD6Jvsjp9M7c
	o9i00fL0yE7n0sYN/dfe7RdPzOU1rbMCMPQWhix7/6idz/czzJHTQf/lkXW+wwjU
	LWtllh+G4ALTaxOhuL1t7fg8cZHO0fy2vr9rQZTnvL7BMWh47xjw1STGKaUrY1cS
	PBy/Le5Yc36XIHnWx29nGHRYVUFoUM5VDGk+YZG8lclOgQL9JBl5SlGGs0P9HIH5
	h/xluJsVey7QRuRpXwR6j+ZJhBFnjdoLUuejK5C9molNpmVMxRzsdwWmXtt5dJD0
	6BwntCgE5te9hP7v8fzaDZ2aPlRbT4KMNBkktRtNXHHBhOVvN5HDlIwrTVf07BPS
	tABeng==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hfpahtsr1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 07:01:28 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3abfcf726dcso958784a91.2
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 00:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792738887; x=1793343687; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UQ/JM6CaN1XmFsZMKDNcGKjdu1vRxBuFX7+yqFt9ezA=;
        b=i7cRNo/KEQKPv+aqpGFgupVjYzEjyrl5pqv3KZiRnVLnJI2aQR+K02OrklbNYN2DTU
         2WFtGcqU+ZxxgDTlzjv+aX2wcmRoMXP7ybXEx8uPUF0J+DOARCzk6yuWqEVBPlam1BW3
         tCHi98kcR+H47naoZDxpoeX8xFEqdhr9AcVkQ/h5NFOh5l/0ESkCN4w4905dnaVlWPBS
         LLJfJAH5MB5ISxg3tiahKPxrhyg16GZyL02fQ/akI/ofyj6lRvVo6ubIWCiBXu3xu/yL
         JnyazXwIk3viqCaydeqKvlQcUk/fKoFHit2NAFHCA8nB+YoVJm9zh2TVX3ESmglfUzBJ
         hOVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792738887; x=1793343687;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UQ/JM6CaN1XmFsZMKDNcGKjdu1vRxBuFX7+yqFt9ezA=;
        b=sSqm1Gh+VCpu1jn2jka6Puq0lRY6QsY9EybiBDtdy4iy82+IdtMRJp0mOnrAn+0/ft
         7dsPlbINxg69yBl+Ud8+P4zNznA7NDj5gi8uwDZCT6SZg0/9cCqV7P34vuszupNzLnyb
         eEAqj+/qXrNkpgvBczj1VKmbJWoT5yQashrwdGWmXYXjvpo/MdgPBjAa+77QyETtjk1U
         EY9qjj6wpwD9E+eqgvCFNvKqlV/wXA/+LAPsaUS2o0fEGlhT0vzkgXmYrVP+mvlEG3HM
         PXn/XtCLYFjHls1w6YUc6fb4tmsdSud1n2YZs8UuH6TAGHj4ARNIftdiintZr0UBRYP1
         JgfA==
X-Gm-Message-State: AFq9FYLTbXqXdRzA6v6PU+C8H8BjflDmENKRB+E+fOBWc9bFU2x1fENn
	ZwPQIRcufb2sBEDz+NkV4n28KoaCaLU2eXrpyergcUBS3sa53fswva+gFSpui9CosNLSCIbEXxq
	cXsRjUww+4/eG4l3ytXBeCxXyfSaubvyzXbozW+lUmXsi57v+vXTYAy/tvhs6B2A5y6SRew==
X-Gm-Gg: AYBFou1AUHgmOrVHqMSfrpJXS0nrH0eG0MR3Y9SgIPhUaHg0ilJIVxCmXHlTDR9kTwM
	D/q3xG4EkSJtMYv4koM6MSfqyT1Y1tDZZ9DyIJpQsHKF+tNVNdmcrRqfJBb5KPFWyjh363CNDlp
	A6V7nxPExMWNRrHogDK0Nkja+tf9hmi/5jIAO2BMK/ypOV+gFZZKoN2vNGCXB+zbvszNEe0dZUa
	0JClLif/AAv87SPLXDxiMFvxIqAIKlSWcQS78/gPUGoY7lTIBW2N6edGxp+g1ucno42bCatvF6t
	M5t9rIuYjjtEbQWynLxhiy/tR9nh2ha7oHK1de7sy1qlUKRhSqzWgXk7CXF1pkRDGzCdPtsRgae
	qUTmHy25A4XSpMKzXKnuk9+7KqQuCNHeZG0Bl3pibF/WLzE721ZI3Wn2jAjKtOM5WKr/SIFcIXT
	HWZDOWTevs40GYlvMTmKWRFQ==
X-Received: by 2002:a17:90b:5201:b0:3ac:9c37:9426 with SMTP id 98e67ed59e1d1-3adce07f6e4mr1162228a91.31.1792738887325;
        Fri, 23 Oct 2026 00:01:27 -0700 (PDT)
X-Received: by 2002:a17:90b:5201:b0:3ac:9c37:9426 with SMTP id 98e67ed59e1d1-3adce07f6e4mr1162194a91.31.1792738886675;
        Fri, 23 Oct 2026 00:01:26 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd8ba8a6dcdsm399751a12.18.2026.10.23.00.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 00:01:26 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Date: Fri, 23 Oct 2026 12:31:06 +0530
Subject: [PATCH ath-next v3 03/17] wifi: ath12k: Add hardware parameter for
 QCN6432
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261023-mpp-bringup-v3-3-19f3fcbf7b5f@oss.qualcomm.com>
References: <20261023-mpp-bringup-v3-0-19f3fcbf7b5f@oss.qualcomm.com>
In-Reply-To: <20261023-mpp-bringup-v3-0-19f3fcbf7b5f@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath12k@lists.infradead.org,
        Sowmiya Sree Elavalagan <quic_ssreeela@quicinc.com>,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAyNyBTYWx0ZWRfX85boNitQRQGX
 VL/SArkkXYet3pX+otlY6uHhfFnRbJOAD4CU4JbJbCCNTnTAvdfdpRyAASoMMmUbAYcV7b6XB02
 wtO02zCwh41al21Vl/UB6A4p9JUMGtg=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAyNyBTYWx0ZWRfXyb/UF9pqesDg
 sDLseHWkt2d0or8Wje7c61EmonypKzt15zVZ/7TNGUlvWXziPBHdg0MTUWtbmx7pU4sPmdD8Z12
 m8A02MjxQHhWnDkG86vmx2agA4WNtNbGn8XXNH3tkSIgXokH0DngOshLFbWCXduBdD3YjV+wMgi
 4zjUkTEMa70D7z+PoZWnrF2SmpZfeSygkds3nl0hEqORJ/SXnzMmNIG87GplHp7ttLZBzgtE+Nn
 EyP7iWVzlCgWRG5CBT0iZXoFbYhgTresqJ5thPiOtQ9rYIj59EECj3KV0qtrygl+se92zhjF3Pk
 1As96eYdVyMzm5wEgG39s9FnseNqGgTWzXSoSl+CeLJJpBcbFiMJFCvAi9E/aYSnNiVlB/LdciM
 8qqbL9aLD/4iUMHmoF84doer2NrBzJuRhbf2xyid/vBIILhKOV4fcii4PB6pfadUA+Mc1r48MEC
 azPaTXBbYry+S4CPduA==
X-Proofpoint-GUID: mtmUcTabgqkODklMdCS1FnLmawHaLoeA
X-Authority-Analysis: v=2.4 cv=YIMKWhGx c=1 sm=1 tr=0 ts=6adb0648 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=COk6AnOGAAAA:8 a=EUspDBNiAAAA:8 a=IkfkkYc7qEKKYK4gSbYA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-ORIG-GUID: mtmUcTabgqkODklMdCS1FnLmawHaLoeA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 phishscore=0 lowpriorityscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610230027

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
 drivers/net/wireless/ath/ath12k/wifi7/hw.c | 86 ++++++++++++++++++++++++++++++
 3 files changed, 88 insertions(+)

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
index b1c17cc197df..643c95c9bccd 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hw.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
@@ -906,6 +906,92 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
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
+		.qmi_max_chunk_size = SZ_2M,
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

