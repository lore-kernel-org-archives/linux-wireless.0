Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6AA37702B
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 10:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786010867; cv=none; b=F3syzB9LbH1CJZ5ANExiNd+WHKtwx7Wlh+ubgEKrAg8l7pwbdavpG1oEEknSrq+LwTlVl9VcFvILOAN9yLQyWEYfwF6sGbUC3wkn1/4iUWtz0kKYwmjVi76xfYEjFMj9MJVA6U2yIuZF2QKW8q8vYUTNz31YiOv+goFbFwEaFOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786010867; c=relaxed/simple;
	bh=LBC9I9XwzwRIsKhUcG67uymeyj0tGJXiO2GSiFFJ5dQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VRUXrmAmcjszLRE8wLudGM9m4+D0G58MTRjdAgLcu1MBvMXbP9LtQ99J6IFqO3+7WBuD0FXcdshRjKSIaLscJcTU//tc+TBY3DcK+rUWzr50RQNayvpQcyJbiKQnSNHMwGHz98up+esX8kc1E4/ntH1Nk2PO/wpz1P84ghaWvwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mJQyuC6h; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=dfbOYj86; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mJQyuC6h";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="dfbOYj86"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6769nfZn1580758
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2026 10:07:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=XSGzh9lPVIO
	X0gxfEZMJTF4LJynlHT+NQszGI18tGyg=; b=mJQyuC6h545YctEgTERpDJMeJgE
	z/OTihXcwByNKazPxwyColK9uny3XWwJYW+igVrvGFfOG4M4ZJqUfJrbBpR83mzx
	JdHnO95OAxw/2zUyKlAchtwmPZcJC/2jFXZ4QmP1zDUff5jDeLjxBDGorwCYpuC5
	d73cfKdI7adA+MrSBVl6VVkMaRQtraYgdLf+aZWE4ioGbxcosZjU66BBEWVWTpc4
	Y1O2AquFK7GxyXbDTNoqkRgrn3e7GFqQW0pHSK73tZKPr8+rQwA6pHWMLskJtd6M
	KGiF1HGNa4tT3lmyEbCOrZgF6uXhEhpTje/H4En9QyAN3laXfG3gWGrsZMQ==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvmrjh0dc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 10:07:38 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2cfe48ca1efso29523985ad.0
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 03:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786010858; x=1786615658; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XSGzh9lPVIOX0gxfEZMJTF4LJynlHT+NQszGI18tGyg=;
        b=dfbOYj86lle7sL3vySe04CuIlcVLsm+Opx7Ns0BsXjCDBCTGMc3HMy0x0P5N7dktZz
         D+TqnKtdGlYmWbYi+mR1U4AqbV+TGtlz2CTie6/07WEpjAVtpTysWuD2BaYCaygvOhrA
         j4ec/r8pHTsXPVIEY15iXbC3kUuqfUydsIkqxXIyX/iqXorYbO0DAlWMspIiVfx5q+8W
         8IIuohpWyWAPfi/ns1tmOMS6nkZYAMtfou8V3pqq3DzGNcjSzsoMN07KVZo6XUqwPmgl
         R8u/v9eJGAe2o574Ekw2umZUC3uhMV+A4OXVpC/+yCRTfHXA6YhFCBTqiBWgO4O9iRxW
         Wb0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786010858; x=1786615658;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XSGzh9lPVIOX0gxfEZMJTF4LJynlHT+NQszGI18tGyg=;
        b=mQNOOrp8q0cfaFOvzOAK3ODXqZoRvWFLiKz0Z2j+0lvOCf3dOx/JpQlxCV0QP6ea6s
         oHMRCvp4cnD1uMmhztLSM22GSqSZnDNa5iT3BzTHLL9Wg7dL4k22im4C5fcBq4OMvuT5
         BVnsOi8OYJV4NAVq88rD0P6CmwUor+63oWTm+eAqAMhR/lGzKmrGG0mgBTQvBNKEISCb
         FNdt1tbmB0pjICJhudSZdKQmsrWxCkvTloGzOd9V/476iWE8vBvjRi2cNBqfs5BiP6jM
         Gq0X1qVFf05PxMi9NivbldCR3X7yQNCSrXXRV3vofmArXtktAaN2pRH0MzVUYe4PNK1z
         XWzw==
X-Gm-Message-State: AOJu0YwcgUXtAGC71O2B6vAUW5PIgAMPWzQA4/Hl557WlZFSm7/R5Ods
	GMgDxBHInS2oo9NA+2+dHrHtxl8o22L0LMNlaZK3umAOliiCUXB2Ew+yxvQgUwSxIpbxIrJ4Ewb
	6s1iD+cmSfcF88bIpm9NtBpEjDSSJyrjmF/VQt1mJLi4rkW7+ObZVdJ9BcF7CxPxMrTVOgw==
X-Gm-Gg: AR+sD10souOsSpM/6T2jFax4AU1uA/ujIgKVCa9DkT2RzJ9TRNPaG77Q/5J+MoqBhpl
	nrvAuY2bjWsURYb5ANX4WLZq4qkJnywzembCIeR23KyFscDl1SNS8KLJeq89kY51ALHXnCfTt1U
	ZT9b98LzJVuaLhBWilwGkNjcJ+kao6NWv5BtRemjKiso1PW0HaRJY4REog4NtaBdyMX+os5dYx4
	tP+QkYnCRM+bZLMaoTg3KnNWtUVm6/TaOzOFm5cEB8BiC86RKtkWyk0jKl9JkrO4iCyJvz1LgtB
	rMwAVo4zVITLb9H+ENKlmVkkK4lSjHIYiYxXzWSgBE30cSZ0+O/BDF4dhXTRHNxqOT6+XNInVbY
	f1UG230ahjHdaqT5eAM78epdVCmdmrmJj7t6CwqHgj9kmdj8hLU6R
X-Received: by 2002:a17:903:19c6:b0:2c9:e69f:8b0f with SMTP id d9443c01a7336-2d0ca9fefb7mr170811125ad.17.1786010857498;
        Thu, 06 Aug 2026 03:07:37 -0700 (PDT)
X-Received: by 2002:a17:903:19c6:b0:2c9:e69f:8b0f with SMTP id d9443c01a7336-2d0ca9fefb7mr170810445ad.17.1786010857081;
        Thu, 06 Aug 2026 03:07:37 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d0b6fbf2c6sm24027115ad.34.2026.08.06.03.07.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 03:07:36 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Aniruddha Mishra <aniruddha.mishra@oss.qualcomm.com>,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next 5/8] wifi: ath12k: add WBM RX error drop statistics
Date: Thu,  6 Aug 2026 15:36:59 +0530
Message-Id: <20260806100702.3479326-6-pardeep.kaur@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260806100702.3479326-1-pardeep.kaur@oss.qualcomm.com>
References: <20260806100702.3479326-1-pardeep.kaur@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=VNPtWdPX c=1 sm=1 tr=0 ts=6a745cea cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=EUspDBNiAAAA:8
 a=njqguKqIJykaDPTg3YMA:9 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-ORIG-GUID: 1WI35NCRmYdM83v88fkpHy7MfyF7YdeK
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDA3OSBTYWx0ZWRfX9pkHcC1kCwR1
 LBYpcnRD/XTRRjRighjlPNPH+7ZYH5lMeeQsmWd8sSRIZ8yJNJmNHA998MCBd2L580XfLLYh21X
 B59UaYieszI+6urAvR6ta+dZg13i3KI=
X-Proofpoint-GUID: 1WI35NCRmYdM83v88fkpHy7MfyF7YdeK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDA3OSBTYWx0ZWRfX27tHWA3uxhHj
 63MsPIrttYpys7cNHqhOT36WeLMMNJ5AMT32IWwzV96ID3l79QFgLMnv+AXExalWxIHiXbhodqG
 r7Lov6BqQj7E3SDkRbY7nwJsEbOcpA8iu4SDV/2xRRR/LILUCTgU8YqOx37eCv9mLMmvFLk10Nq
 VZIMZWEuZX5FOyJ6OCBSIkTBJ5evqBA9dNjIkuKVJgdj2n0cn4pE+tSBRySlaMHWLE8R8tWctW+
 zP9FGjXmO/TiD+2OO9Z1qq/aXtejt5TFp+/UfAArHiP2Op71InAveId0pfxZ6M7pQ9GMt3+l1wp
 QQ1E+Q+dcWcE1ld/e1i32MBRn8t7BE9pZOrOkM2GPbpn1olbUHDgmU3QRKCgOITHF8BcqUy89AK
 0bFLuDjy30UxEJlwEGCnNX19biwxItrDAXOSmzHKdnRqUbw8hIluiJ99bXgEGyVthEGnk0LHXNw
 Ak0o4+wVPDpdUZH/NSg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 adultscore=0 impostorscore=0 priorityscore=1501
 spamscore=0 suspectscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608060079

From: Aniruddha Mishra <aniruddha.mishra@oss.qualcomm.com>

Without fine-grained drop counters, diagnosing RX failures in the
WBM error path requires intrusive debugging. Introduce per-drop-reason
counters to track exactly where and why packets are dropped during
WBM RX error handling.

Introduce a new dp_stats.h header and define ath12k_wbm_err_drop_reason
enum there covering all drop points in the WBM RX error path: descriptor
parse failures, SW descriptor retrieval errors, null partner DP,
invalid HW link ID, null pdev/ar, CAC running, scatter-gather drops,
and invalid NWifi header length. The new header is included by dp.h
which is already included by all consumers.

Add ath12k_device_dp_rx_wbm_err_stats struct grouping rxdma_error[],
reo_error[], and the new drop[] counters, replacing the flat arrays
previously in ath12k_device_dp_stats.

Add bounds checks before indexing rxdma_error[] and reo_error[] with
hardware-supplied err_code values to prevent out-of-bounds writes, using
the same likely/WARN_ON_ONCE pattern as the TX stats bounds fixes.

Add ath12k_wifi7_dp_rx_wbm_err_free_skb() helper to combine drop stat
increment and skb free at each drop site, reducing repetition. Define
the helper at the top of dp_rx.c before its first use.

Increment WBM_ERR_DROP_RXDMA_GENERIC only inside rxdma_err()'s
default: branch so it counts only unhandled RXDMA errors, not every
RXDMA drop - consistent with how WBM_ERR_DROP_REO_GENERIC is counted.

Expose WBM RX drop counts in the device_dp_stats debugfs file under a
new 'WBM Rx Drop Count' section.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6.r1-00402-QCAHKSWPL_SILICONZ-1

Signed-off-by: Aniruddha Mishra <aniruddha.mishra@oss.qualcomm.com>
Co-developed-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Signed-off-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/debugfs.c     | 23 +++++++++-
 drivers/net/wireless/ath/ath12k/dp.h          | 10 +++-
 drivers/net/wireless/ath/ath12k/dp_stats.h    | 25 ++++++++++
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c | 46 +++++++++++++++----
 .../net/wireless/ath/ath12k/wifi7/hal_rx.c    |  5 +-
 5 files changed, 95 insertions(+), 14 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath12k/dp_stats.h

diff --git a/drivers/net/wireless/ath/ath12k/debugfs.c b/drivers/net/wireless/ath/ath12k/debugfs.c
index 0e446a666f4c..f9653fb7b038 100644
--- a/drivers/net/wireless/ath/ath12k/debugfs.c
+++ b/drivers/net/wireless/ath/ath12k/debugfs.c
@@ -1071,6 +1071,20 @@ static ssize_t ath12k_debugfs_dump_device_dp_stats(struct file *file,
 		[HAL_REO_DEST_RING_ERROR_CODE_PN_ERR_FLAG_SET] = "PN err",
 		[HAL_REO_DEST_RING_ERROR_CODE_DESC_BLOCKED] = "Desc blocked"};
 
+	static const char *wbm_rx_drop[WBM_ERR_DROP_MAX] = {
+		[WBM_ERR_GET_SW_DESC] = "SW desc error",
+		[WBM_ERR_DESC_PARSE] = "Desc parse error",
+		[WBM_ERR_DROP_INV_HW_ID] = "Invalid hw id",
+		[WBM_ERR_DROP_NULL_PRTNR_DP] = "Null Partner dp",
+		[WBM_ERR_DROP_NULL_PROC_DP] = "Process Null Partner dp",
+		[WBM_ERR_DROP_NULL_PDEV] = "Null Pdev",
+		[WBM_ERR_DROP_NULL_AR] = "Null ar",
+		[WBM_ERR_DROP_CAC_RUNNING] = "CAC Running",
+		[WBM_ERR_DROP_SG] = "Scatter Gather",
+		[WBM_ERR_DROP_INV_NWIFI_HDR] = "Invalid NWifi Hdr len",
+		[WBM_ERR_DROP_REO_GENERIC]  = "REO Generic",
+		[WBM_ERR_DROP_RXDMA_GENERIC] = "RXDMA Generic"};
+
 	static const char *wbm_rel_src[HAL_WBM_REL_SRC_MODULE_MAX] = {
 		[HAL_WBM_REL_SRC_MODULE_TQM] = "TQM",
 		[HAL_WBM_REL_SRC_MODULE_RXDMA] = "Rxdma",
@@ -1095,13 +1109,18 @@ static ssize_t ath12k_debugfs_dump_device_dp_stats(struct file *file,
 
 	for (i = 0; i < HAL_REO_ENTR_RING_RXDMA_ECODE_MAX; i++)
 		len += scnprintf(buf + len, size - len, "%s: %u\n",
-				 rxdma_err[i], device_stats->rxdma_error[i]);
+				 rxdma_err[i], device_stats->wbm_err.rxdma_error[i]);
 
 	len += scnprintf(buf + len, size - len, "\nREO errors:\n");
 
 	for (i = 0; i < HAL_REO_DEST_RING_ERROR_CODE_MAX; i++)
 		len += scnprintf(buf + len, size - len, "%s: %u\n",
-				 reo_err[i], device_stats->reo_error[i]);
+				 reo_err[i], device_stats->wbm_err.reo_error[i]);
+
+	len += scnprintf(buf + len, size - len, "\nWBM Rx Drop Count:\n");
+	for (i = 0; i < WBM_ERR_DROP_MAX; i++)
+		len += scnprintf(buf + len, size - len, "%s: %u\n",
+				 wbm_rx_drop[i], device_stats->wbm_err.drop[i]);
 
 	len += scnprintf(buf + len, size - len, "\nHAL REO errors:\n");
 
diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
index 16675210806a..9b57b2170b60 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -7,6 +7,7 @@
 #ifndef ATH12K_DP_H
 #define ATH12K_DP_H
 
+#include "dp_stats.h"
 #include "hw.h"
 #include "dp_htt.h"
 #include "dp_cmn.h"
@@ -437,13 +438,18 @@ struct ath12k_device_dp_tx_err_stats {
 	atomic_t misc_fail;
 };
 
+struct ath12k_device_dp_rx_wbm_err_stats {
+	u32 rxdma_error[HAL_REO_ENTR_RING_RXDMA_ECODE_MAX];
+	u32 reo_error[HAL_REO_DEST_RING_ERROR_CODE_MAX];
+	u32 drop[WBM_ERR_DROP_MAX];
+};
+
 struct ath12k_device_dp_stats {
 	u32 err_ring_pkts;
 	u32 invalid_rbm;
-	u32 rxdma_error[HAL_REO_ENTR_RING_RXDMA_ECODE_MAX];
-	u32 reo_error[HAL_REO_DEST_RING_ERROR_CODE_MAX];
 	u32 hal_reo_error[DP_REO_DST_RING_MAX];
 	struct ath12k_device_dp_tx_err_stats tx_err;
+	struct ath12k_device_dp_rx_wbm_err_stats wbm_err;
 	u32 reo_rx[DP_REO_DST_RING_MAX][ATH12K_MAX_DEVICES];
 	u32 rx_wbm_rel_source[HAL_WBM_REL_SRC_MODULE_MAX][ATH12K_MAX_DEVICES];
 	u32 tqm_rel_reason[MAX_TQM_RELEASE_REASON];
diff --git a/drivers/net/wireless/ath/ath12k/dp_stats.h b/drivers/net/wireless/ath/ath12k/dp_stats.h
new file mode 100644
index 000000000000..04d3892acff3
--- /dev/null
+++ b/drivers/net/wireless/ath/ath12k/dp_stats.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: BSD-3-Clause-Clear */
+/*
+ * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
+ */
+
+#ifndef ATH12K_DP_STATS_H
+#define ATH12K_DP_STATS_H
+
+enum ath12k_wbm_err_drop_reason {
+	WBM_ERR_GET_SW_DESC,
+	WBM_ERR_DESC_PARSE,
+	WBM_ERR_DROP_INV_HW_ID,
+	WBM_ERR_DROP_NULL_PRTNR_DP,
+	WBM_ERR_DROP_NULL_PROC_DP,
+	WBM_ERR_DROP_NULL_PDEV,
+	WBM_ERR_DROP_NULL_AR,
+	WBM_ERR_DROP_CAC_RUNNING,
+	WBM_ERR_DROP_SG,
+	WBM_ERR_DROP_INV_NWIFI_HDR,
+	WBM_ERR_DROP_REO_GENERIC,
+	WBM_ERR_DROP_RXDMA_GENERIC,
+	WBM_ERR_DROP_MAX,
+};
+
+#endif /* ATH12K_DP_STATS_H */
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
index 95d87dd67872..b203513d63cc 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
@@ -12,6 +12,15 @@
 #include "hal_wcn7850.h"
 #include "hal_qcc2072.h"
 
+static void
+ath12k_wifi7_dp_rx_wbm_err_free_skb(struct ath12k_dp *dp,
+				    struct sk_buff *msdu,
+				    enum ath12k_wbm_err_drop_reason drop_reason)
+{
+	dp->device_stats.wbm_err.drop[drop_reason]++;
+	dev_kfree_skb_any(msdu);
+}
+
 static u16 ath12k_wifi7_dp_rx_get_peer_id(struct ath12k_dp *dp,
 					  enum ath12k_peer_metadata_version ver,
 					  __le32 peer_metadata)
@@ -1614,6 +1623,7 @@ static int ath12k_wifi7_dp_rx_h_null_q_desc(struct ath12k_pdev_dp *dp_pdev,
 		/* First buffer will be freed by the caller, so deduct it's length */
 		msdu_len = msdu_len - (DP_RX_BUFFER_SIZE - hal_rx_desc_sz);
 		ath12k_wifi7_dp_rx_null_q_desc_sg_drop(dp, msdu_len, msdu_list);
+		dp->device_stats.wbm_err.drop[WBM_ERR_DROP_SG]++;
 		return -EINVAL;
 	}
 
@@ -1649,8 +1659,10 @@ static int ath12k_wifi7_dp_rx_h_null_q_desc(struct ath12k_pdev_dp *dp_pdev,
 		skb_put(msdu, hal_rx_desc_sz + l3pad_bytes + msdu_len);
 		skb_pull(msdu, hal_rx_desc_sz + l3pad_bytes);
 	}
-	if (unlikely(!ath12k_dp_rx_check_nwifi_hdr_len_valid(dp, msdu, rx_info)))
+	if (unlikely(!ath12k_dp_rx_check_nwifi_hdr_len_valid(dp, msdu, rx_info))) {
+		dp->device_stats.wbm_err.drop[WBM_ERR_DROP_INV_NWIFI_HDR]++;
 		return -EINVAL;
+	}
 
 	ath12k_dp_rx_h_ppdu(dp_pdev, rx_info);
 	ret = ath12k_wifi7_dp_rx_h_mpdu(dp_pdev, msdu, rx_info);
@@ -1763,7 +1775,10 @@ static bool ath12k_wifi7_dp_rx_h_rxdma_err(struct ath12k_pdev_dp *dp_pdev,
 	struct ath12k_skb_rxcb *rxcb = ATH12K_SKB_RXCB(msdu);
 	bool drop = false;
 
-	dp->device_stats.rxdma_error[rxcb->err_code]++;
+	if (likely(rxcb->err_code < HAL_REO_ENTR_RING_RXDMA_ECODE_MAX))
+		dp->device_stats.wbm_err.rxdma_error[rxcb->err_code]++;
+	else
+		WARN_ON_ONCE(1);
 
 	switch (rxcb->err_code) {
 	case HAL_REO_ENTR_RING_RXDMA_ECODE_UNAUTH_WDS_ERR:
@@ -1780,6 +1795,7 @@ static bool ath12k_wifi7_dp_rx_h_rxdma_err(struct ath12k_pdev_dp *dp_pdev,
 		/* TODO: Review other rxdma error code to check if anything is
 		 * worth reporting to mac80211
 		 */
+		dp->device_stats.wbm_err.drop[WBM_ERR_DROP_RXDMA_GENERIC]++;
 		drop = true;
 		break;
 	}
@@ -1796,7 +1812,10 @@ static bool ath12k_wifi7_dp_rx_h_reo_err(struct ath12k_pdev_dp *dp_pdev,
 	struct ath12k_skb_rxcb *rxcb = ATH12K_SKB_RXCB(msdu);
 	bool drop = false;
 
-	dp->device_stats.reo_error[rxcb->err_code]++;
+	if (likely(rxcb->err_code < HAL_REO_DEST_RING_ERROR_CODE_MAX))
+		dp->device_stats.wbm_err.reo_error[rxcb->err_code]++;
+	else
+		WARN_ON_ONCE(1);
 
 	switch (rxcb->err_code) {
 	case HAL_REO_DEST_RING_ERROR_CODE_DESC_ADDR_ZERO:
@@ -1813,6 +1832,7 @@ static bool ath12k_wifi7_dp_rx_h_reo_err(struct ath12k_pdev_dp *dp_pdev,
 		/* TODO: Review other errors and process them to mac80211
 		 * as appropriate.
 		 */
+		dp->device_stats.wbm_err.drop[WBM_ERR_DROP_REO_GENERIC]++;
 		drop = true;
 		break;
 	}
@@ -1935,6 +1955,7 @@ int ath12k_wifi7_dp_rx_process_wbm_err(struct ath12k_dp *dp,
 		ret = ath12k_wifi7_hal_wbm_desc_parse_err(dp, rx_desc,
 							  &err_info);
 		if (ret) {
+			dp->device_stats.wbm_err.drop[WBM_ERR_DESC_PARSE]++;
 			ath12k_warn(ab, "failed to parse rx error in wbm_rel ring desc %d\n",
 				    ret);
 			continue;
@@ -1946,6 +1967,7 @@ int ath12k_wifi7_dp_rx_process_wbm_err(struct ath12k_dp *dp,
 		if (!desc_info) {
 			desc_info = ath12k_dp_get_rx_desc(dp, err_info.cookie);
 			if (!desc_info) {
+				dp->device_stats.wbm_err.drop[WBM_ERR_GET_SW_DESC]++;
 				ath12k_warn(ab, "Invalid cookie in DP WBM rx error descriptor retrieval: 0x%x\n",
 					    err_info.cookie);
 				continue;
@@ -1961,7 +1983,8 @@ int ath12k_wifi7_dp_rx_process_wbm_err(struct ath12k_dp *dp,
 		device_id = desc_info->device_id;
 		partner_dp = ath12k_dp_hw_grp_to_dp(dp_hw_grp, device_id);
 		if (unlikely(!partner_dp)) {
-			dev_kfree_skb_any(msdu);
+			ath12k_wifi7_dp_rx_wbm_err_free_skb(dp, msdu,
+							    WBM_ERR_DROP_NULL_PRTNR_DP);
 
 			/* In any case continuation bit is set
 			 * in the previous record, cleanup scatter_msdu_list
@@ -2007,7 +2030,8 @@ int ath12k_wifi7_dp_rx_process_wbm_err(struct ath12k_dp *dp,
 		hw_link_id = ath12k_dp_rx_get_msdu_src_link(partner_dp->hal,
 							    msdu_data);
 		if (hw_link_id >= ATH12K_GROUP_MAX_RADIO) {
-			dev_kfree_skb_any(msdu);
+			ath12k_wifi7_dp_rx_wbm_err_free_skb(dp, msdu,
+							    WBM_ERR_DROP_INV_HW_ID);
 
 			/* In any case continuation bit is set
 			 * in the previous record, cleanup scatter_msdu_list
@@ -2068,7 +2092,8 @@ int ath12k_wifi7_dp_rx_process_wbm_err(struct ath12k_dp *dp,
 			ath12k_dbg(ab, ATH12K_DBG_DATA,
 				   "Unable to process WBM error msdu due to invalid hw link id %d device id %d\n",
 				   hw_link_id, device_id);
-			dev_kfree_skb_any(msdu);
+			ath12k_wifi7_dp_rx_wbm_err_free_skb(dp, msdu,
+							    WBM_ERR_DROP_NULL_PROC_DP);
 			continue;
 		}
 
@@ -2077,18 +2102,21 @@ int ath12k_wifi7_dp_rx_process_wbm_err(struct ath12k_dp *dp,
 
 		dp_pdev = ath12k_dp_to_pdev_dp(partner_dp, pdev_idx);
 		if (!dp_pdev) {
-			dev_kfree_skb_any(msdu);
+			ath12k_wifi7_dp_rx_wbm_err_free_skb(dp, msdu,
+							    WBM_ERR_DROP_NULL_PDEV);
 			continue;
 		}
 		ar = ath12k_pdev_dp_to_ar(dp_pdev);
 
 		if (!ar || !rcu_dereference(ar->ab->pdevs_active[pdev_idx])) {
-			dev_kfree_skb_any(msdu);
+			ath12k_wifi7_dp_rx_wbm_err_free_skb(dp, msdu,
+							    WBM_ERR_DROP_NULL_AR);
 			continue;
 		}
 
 		if (test_bit(ATH12K_FLAG_CAC_RUNNING, &ar->dev_flags)) {
-			dev_kfree_skb_any(msdu);
+			ath12k_wifi7_dp_rx_wbm_err_free_skb(dp, msdu,
+							    WBM_ERR_DROP_CAC_RUNNING);
 			continue;
 		}
 
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hal_rx.c b/drivers/net/wireless/ath/ath12k/wifi7/hal_rx.c
index 49c693289709..60e7a36097f1 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hal_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hal_rx.c
@@ -329,7 +329,10 @@ int ath12k_wifi7_hal_desc_reo_parse_err(struct ath12k_dp *dp,
 				    HAL_REO_DEST_RING_INFO0_PUSH_REASON);
 	err_code = le32_get_bits(desc->info0,
 				 HAL_REO_DEST_RING_INFO0_ERROR_CODE);
-	dp->device_stats.reo_error[err_code]++;
+	if (likely(err_code < HAL_REO_DEST_RING_ERROR_CODE_MAX))
+		dp->device_stats.wbm_err.reo_error[err_code]++;
+	else
+		WARN_ON_ONCE(1);
 
 	if (push_reason != HAL_REO_DEST_RING_PUSH_REASON_ERR_DETECTED &&
 	    push_reason != HAL_REO_DEST_RING_PUSH_REASON_ROUTING_INSTRUCTION) {
-- 
2.34.1

