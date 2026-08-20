Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE7938C407
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 05:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787204899; cv=none; b=JRw1wwNB6sz2Eb09K8UpUwGqeMHlbYGNdt3/jfgA7WCC/B2hQtoeQR/TO+qE6LDF++yZ8bHQap+1I9Efy08K57RPNpGhX2IdY8VCNN48XSp6raJJgyiENZzDewFdMmM3vfaDbT80CQQaBpjON7W/AsViw5BdpnEeDIr1khEnTXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787204899; c=relaxed/simple;
	bh=18jMLmK/E0WWya8FHrl8Ilmax3ovdTD2NAKFkDYsR/I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=m3wJ0z+biVFMz1ROTNHmFPRrWXCnqt0Ja+0oaCe6XYIsB4rjv9xNDbmAQeZ7RtrQbgOCTKHALo46uiBO7vo6cpmBUA8XEV4LhoAg0clFgnOJ+5BO/lIAyxmh0UyzLnQ30OlmfnGzLxHtbEEotA5MN0xuqhcwLStdrEE/7gZSVuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZeSMni+3; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=HoAPAj1V; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZeSMni+3";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="HoAPAj1V"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67JL85At1027578
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 05:48:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=KxN8Vq8Yyh7
	fQ2xvAc0ZugpfsxO62FJwARFvw1IdocM=; b=ZeSMni+3wS/TqPWkQab1PXh1hNj
	YNljjzO6r7sVVkPPQE5NDQkoW8HJbrqaMX4CLR60vDUtQSEeBTxGYkoLw+hqAN0J
	qGgGCPECP7Mm1zQpJKBpyjhuKuz9R+i1U11vP8Cp2RHLG+Iknf1Bm7py41Monmac
	7XOBncfZSw9L4zGj28UNUxfU0cnW8IJ6C39TrzSw8c9g8G1C8iDBtBwHon50xDx/
	2btaV0B2ZJUdfcGUTPQuMDEB9mDkxLmuZABhgMzVFuvrqUnHTSEG826z8IVzRfoN
	FSzEpmK0iak9yuThh0d/AsmxOWKtuLo/OtPRvKK4nEqpbj0WtC82btwRcZA==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g5es4kavv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 05:48:16 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38e4758ab46so3018883a91.0
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 22:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787204895; x=1787809695; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KxN8Vq8Yyh7fQ2xvAc0ZugpfsxO62FJwARFvw1IdocM=;
        b=HoAPAj1VMCNMzvG/aCzpKzdq+bEuoAP5f+DMO4lePoXgl7q5wAvNi+k7XhMrnz2G6e
         vZJH+fsmYC5wW0KVC/4cMFqxP/Ha92rMNGxMcQMPKCt5/G6KXz+GjTnOnvalnJQwyg2U
         DUi66s7fVOD/2ibW9wP8o/mbIk6m9hEOXphVt9TZMaDQIkRn8I+4gRemYd37RGWk39sP
         Ti7px3lMuE4yXvD/rWRJNN9D42riAEvi5nabSVKD2l3fR6w3VfsQpgWSnp91Pz5L3OzQ
         X1ycjnGarsjzLVSvH4jg8ODtvVF/3amQAkpERlXWGBVGLiScjwIGe2P+rwQACXJI5ZYJ
         BtFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787204895; x=1787809695;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KxN8Vq8Yyh7fQ2xvAc0ZugpfsxO62FJwARFvw1IdocM=;
        b=NrD1yJ+ECt0IeHZaYq0EQbV8V6+YxstZbvBiCB+aGT1x8dgIRmRbQd7vDOgm4qvBa7
         ckrP+6qoCU9NxwJ0zOBv8OiMr78qTGSYkOFKMLmyW277CQGpzY3l5v6dF8t+ppehkfGN
         GSh3TYk7cMOjlLbZr4otpSAHIG4ziOJEm9v5n1EVI5egzOExfV5WGWnUQ/X1SXh0gmTq
         o3LoRn2GW5+4AVkRsiSjlrUNCnxMVN+3BKk06g6eJhiXikCBHZrNSbhLJQLTC6wLul7p
         9yTWdfvXxiqrjsj4QaqUtVXxKF/fDkmT92iJAxSVLDmeq8JndU5X3xFYD6ZIa3wI3MA7
         loig==
X-Gm-Message-State: AFuF++mMNGEUUAHVWcJs9ZCP2F6juD+kYfHsM7I/Asd0goiqs6v24dGu
	Jm692EN5rsdrA7klOGC6jL9OF5K6uIuNuIfdIzcXCB2XwKK/jpnhYhpqdDASCZhbWv4EyV+FkGR
	SlOmjmTOsvlvO96Nq5t4j9OvXafh+a42uPN4Bobw0s8uxonTx0EZoZu6ZtgKD8+OTAlvI8Q==
X-Gm-Gg: AR+sD12R38HVKJZQL6lCROwOmFfUWxPvoGVF6NV0Awc7EvRyC6viCwnrHeAnv4vOJYz
	Dugfz2kU33U/yxUTNpCNyje8f+S+oKrKHRS+ueaxRxnmupGE35PouptMS37D46EqQAaVF9xeT/m
	yNZsJ9Ob8IWwX/bbjgKmNkSn0/CBbjjFuPanXyLYdBJJe6vzhi4ZPv85dVkU1JuwmDUr6zYMIrk
	Td+JmbfGzzOyMSB9ByWHT/wBQJR0LUOYJsgzQllsEKiKvMt9iZVVK2+XHJOJHlw/yROGbBfWBGg
	5J3CBi/lqw664Q4aRtnLkEtaElb9AUwZRnFztSii+H34FA7HaVR7X7HO26OnOsOlinGk6SANN6Y
	SXo6Glw/urtHVOwHuH2Ed8ixoDHd5Ppy6baod2Xgzsos6kL9/6d5LMWX6/NtUPimP/jawVEQubf
	56365beQTQJuUW23FtbDwyUb4=
X-Received: by 2002:a17:90b:53c7:b0:381:528a:808c with SMTP id 98e67ed59e1d1-3958108453emr19900055a91.12.1787204894929;
        Wed, 19 Aug 2026 22:48:14 -0700 (PDT)
X-Received: by 2002:a17:90b:53c7:b0:381:528a:808c with SMTP id 98e67ed59e1d1-3958108453emr19899953a91.12.1787204894415;
        Wed, 19 Aug 2026 22:48:14 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957fbf3dc2sm5440931a91.17.2026.08.19.22.48.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 22:48:14 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        quic_kiranv@quicinc.com, baochen.qiang@oss.qualcomm.com,
        vasanthakumar.thiagarajan@oss.qualcomm.com, quic_periyasa@quicinc.com,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Subject: [PATCH ath-next 1/7] wifi: ath12k: move dp_profile_params to dp.h
Date: Thu, 20 Aug 2026 11:17:58 +0530
Message-Id: <20260820054804.3222296-2-aaradhana.sahu@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260820054804.3222296-1-aaradhana.sahu@oss.qualcomm.com>
References: <20260820054804.3222296-1-aaradhana.sahu@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 0sWr4RuQZMFyE1TEnE5VF7DOvELf5sNI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIwMDA0MCBTYWx0ZWRfX/A1gccpFpDPF
 Dz7XicOLudECTCXv1aIlz3iQ6Fs5hzbsqgv2J3ma0oPL0GtQ2bdj4YUw4s7z0a4n9025iMeRFfB
 QEazufFecfbL2HLks9YJBiYM6NJFcHLTk//PmeZiIVGHVRAuzg2Wx8sVOn+S+4vOlE70lcUHQlx
 fmQ5lw8syrAfS9bxjNk+cmJNxoQt9+8X8iKGX1X+XxPNLC20+YUKIiBiSPvQhgiOCJaKx2+oNFK
 IkWu/MdkM2tfXDOXIwI0832tFESdHaFW/9zMGeB7NKDFFd1BDNCTVs+75oDPCIP8J3E2KX0Ue+m
 8qDgBu1jtydbAFj2VprfQMqOCA69Ykr8Ui7xdQRFp0Nk7jRVYpB1z7+e2Azo0M2neF5fENaNbkp
 Z/z6v2mMbwZkp6UrQFZpDUSzhF/ecb2FN0u48foK6gukPAlITAJ4j5s6LHg4+2ckf8zaiPwb7//
 d04/JPCy+shbyuB3EtQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIwMDA0MCBTYWx0ZWRfX3zHF3rqFJVhz
 3zcDHSjtOiMGgAN7P0ZvzibjGnLHQJiqRxrq+IIMz+Mxb4eS9WNLf+XfMkNTBP98jkWKYHMAnR2
 g14KHLZlltxSm9ArnFGkAXFuvc9rb2E=
X-Authority-Analysis: v=2.4 cv=CN8amxrD c=1 sm=1 tr=0 ts=6a869520 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=EUspDBNiAAAA:8
 a=B-dlgS1riLFybKXUj3sA:9 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-ORIG-GUID: 0sWr4RuQZMFyE1TEnE5VF7DOvELf5sNI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_06,2026-08-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 bulkscore=0 clxscore=1015 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608200040

Move struct ath12k_dp_profile_params from core.h to dp.h as it is
specifically used for Data Path operations. This improves code
organization by keeping DP-related structures in the DP header.

No functional change intended.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1

Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/core.h | 9 ---------
 drivers/net/wireless/ath/ath12k/dp.h   | 9 +++++++++
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.h b/drivers/net/wireless/ath/ath12k/core.h
index a98fc6e0699d..4718da494aab 100644
--- a/drivers/net/wireless/ath/ath12k/core.h
+++ b/drivers/net/wireless/ath/ath12k/core.h
@@ -928,15 +928,6 @@ struct ath12k_wsi_info {
 	u32 hw_link_id_base;
 };
 
-struct ath12k_dp_profile_params {
-	u32 tx_comp_ring_size;
-	u32 rxdma_monitor_buf_ring_size;
-	u32 rxdma_monitor_dst_ring_size;
-	u32 num_pool_tx_desc;
-	u32 rx_desc_count;
-	u32 rx_release_ring_size;
-};
-
 struct ath12k_mem_profile_based_param {
 	u32 num_vdevs;
 	u32 max_client_single;
diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
index bef0f2ba0560..72d3de2db5d8 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -23,6 +23,15 @@ struct ath12k_ext_irq_grp;
 struct ath12k_dp_rx_tid;
 struct ath12k_dp_rx_tid_rxq;
 
+struct ath12k_dp_profile_params {
+	u32 tx_comp_ring_size;
+	u32 rxdma_monitor_buf_ring_size;
+	u32 rxdma_monitor_dst_ring_size;
+	u32 num_pool_tx_desc;
+	u32 rx_desc_count;
+	u32 rx_release_ring_size;
+};
+
 #define DP_MON_PURGE_TIMEOUT_MS     100
 #define DP_MON_SERVICE_BUDGET       128
 
-- 
2.34.1

