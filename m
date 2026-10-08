Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1AB549AA29
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 10:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791455099; cv=none; b=utimz+2L+gjsus/fAnn1I7lMbivp+8wH+OAC4qh/V5cSRYAOFnwHsfkyNZae4/p756JuoPt13Su1HWaXed2SEPiGxtF7l3jHfvRNHE3EVnMBGMC8SGQAkosMSo120/pDk4hHpHjRT7xTh3j0INLOvPKrr+ZXg8bFmVToFeAjZ6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791455099; c=relaxed/simple;
	bh=QgVnRMxXVlNk2B0erCzCAnkl4/YWHQVmaHD5aXG/R1w=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UQs6h3651W4Z7cDZtNPzEPB7O6Ggv/1jbmjISi4+zjhIBH1wy/gZpa08wh1DNTyl3005rXkH+wCdIhMuxr44Wn9ym0G1XbgfDd8oCAeCYIdbXMhJkRY9mS5fAGo2bAUrInVX6OHtu24qFRkBcjo3q1OsjxzrMA35wOlOl4hQMYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=UgVSjH5T; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ULDlg3GJ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="UgVSjH5T";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ULDlg3GJ"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6987K6lK2189866
	for <linux-wireless@vger.kernel.org>; Thu, 8 Oct 2026 10:24:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	5kUQdOW24c5jNgScPxlXh4VzOb4yzLmXbjVCRfz9C3I=; b=UgVSjH5TIZ5O3VV4
	Cjg7kD9hVCWT8y6IlLtWe71Pgz8ZI0/sHyk+yk29dw00hTzLR4Aye9pX5XGh0dQ5
	LgyWd9txO7fhuWsFGCFnTIu0U9xUGYsU5K9RAIhdfIry5uT3o53RP9sWDVdBRuRV
	0qPdlfcRMr4mY1gsm3wun0pqB5VZ4QvInvo2DYBVcaS5x9AXqjSxoqAxt3U09H9X
	dKBaltTvehieFA0D1XZlTRzWd0SfMjqibl7zA1Kq4s4gdgCDz+jMlIRqLBHqydDH
	kUuow9PYjVvEgiKuvvW4MBVxs2A7ia1XVqmuXPB5AJrPF4UBP1ZBKlgSRhPjWIrM
	O3YK/Q==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h5xe3adc2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 10:24:57 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2df8484f12cso54363425ad.3
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 03:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791455096; x=1792059896; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5kUQdOW24c5jNgScPxlXh4VzOb4yzLmXbjVCRfz9C3I=;
        b=ULDlg3GJDhGDkKDoJ4jEko+4v9YPRMKKThHT/4cAjCfEBh+sIVdUgKT2xOrUSvc3bB
         FN5k2Z2RcOD/uD4jNsKqlr8MtCImYuEqPe7LWalknGSmWCnT6kOD9/2zwNyntWXcKMpA
         AH7gIN1cuAQ2+l94OkuEPSZWfugD9api537Lxb3ESQYwSd4YJ6SYBFXSmMtAREY1qjJj
         EyvBaoqo9Do92oBmIue/A3n4N3DFszdgfh5eSD7lQtKGmktbXse+qWSUNxxjEzfi4bOD
         7M5WSOWR1MeGcqt4KzbETlIrrsxWKKttUuGFGue+9GWprjGl/KKFeKH90pipHJaYKkN7
         IkqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791455096; x=1792059896;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5kUQdOW24c5jNgScPxlXh4VzOb4yzLmXbjVCRfz9C3I=;
        b=fiiEtakZ9AQhrbqMz5F5HLPIKQDnATTOP7/eK8CW9fSozu3gD7xL2NqO6EdRddYA/V
         CpyTIg4+1YiMfgyBbVuINGPqtsVR/h/sUXvdKixzWVyNiHyWHxOtmwcJ4PWP485gteh4
         At2gHucPtiwk2HLM5oEXg5FHFC2mvoG6JLC+p6+EkQ0fWQPAGOJDkekdnZziPBPiW8yp
         Ra9QTkFcfhvazp8eHrcM/FeubNQYO6FXztsw/XD0zgrG1pepYlsxQwt+CfoPbiz6bDYY
         gMW4ftiqbujiTvQ7tAkj3167ZqS32vJGTFXup2/QgHKX9ITk5c+pNCkVvfCJbC9w7Psv
         7+Hw==
X-Gm-Message-State: AFq9FYK8brAhGX99UORlDjCSqkTnclMGKifWjuadpFvceMMQ5YobpQaJ
	lHkL3jW2Jj0g1sfpZqBTdKesPAimAR6mTVkp9JxPqZAqZzruMysuNtFg7VPiySMSHtbPKACTaSo
	MoZMDsmg0wFcEyqnPXQ7NK479E4b+0gV+8ShXeXwipokgu398uPTqsfnRL3Cq/mFQsvDRQQ==
X-Gm-Gg: AYBFou1bUwWFltNKh83EFh+fr/yjM4zgN9GDkBQUihXAQFX/j3x15tIQ1Hj6oKj6wDO
	b8DpszeZG1698eatVsQ1UZLK5Ek66j7EUcnvX+pRJFo3CLMlnsLYoyTK0pA65gBB8aa87AHM9pR
	JT6WFpVjX4WkuTDPQryxKm0HnCLZecRBUqAsoyhroqdT10YEGSzoWHzd0IFZOp+iToNwQag9+zC
	dxIZOwHADfTABwpU5OBTTPNmxxXrQJLEClczWhKrZnTgdiesCKh3C5DSUsS8bRlvU0NRgSTxb8a
	wLfvrAnpWbyZhDkCwzS5oyxaT6sa0PdU2xd8CLn25N2RLzpTvwgQuQ9+KL11YASmcIeWEOyj/+D
	QyUI5XJ/FbdAQOqTv3vsYtu8yA2DTN1RmPyWJWgG+Su8K26w2xcvov0oSbkOWPRTp4N2et1zBrr
	dSAPG8wqCp43/zF4bDm+DbHQ==
X-Received: by 2002:a17:902:fd86:b0:2dd:c0ff:e728 with SMTP id d9443c01a7336-2e600545a2bmr41630445ad.58.1791455093643;
        Thu, 08 Oct 2026 03:24:53 -0700 (PDT)
X-Received: by 2002:a17:902:fd86:b0:2dd:c0ff:e728 with SMTP id d9443c01a7336-2e600545a2bmr41630255ad.58.1791455093163;
        Thu, 08 Oct 2026 03:24:53 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e6046fe39csm22081655ad.16.2026.10.08.03.24.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 03:24:52 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Date: Thu, 08 Oct 2026 15:54:05 +0530
Subject: [PATCH ath-next 09/17] wifi: ath12k: add support for unified
 data-region memory allocation
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261008-mpp_bringup-v1-9-2c5797b5e4ac@oss.qualcomm.com>
References: <20261008-mpp_bringup-v1-0-2c5797b5e4ac@oss.qualcomm.com>
In-Reply-To: <20261008-mpp_bringup-v1-0-2c5797b5e4ac@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath12k@lists.infradead.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Authority-Analysis: v=2.4 cv=J4s/fwnS c=1 sm=1 tr=0 ts=6ac76f79 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=iclRB15sEzZHjfpwsoEA:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDA0MSBTYWx0ZWRfX8+FW/G9rAfiH
 8/yuiOu+Y1kksfTy76QVrqYGXTFzopwrMkbjsetM+bDjce5pg6Q7gxnTNOU9ZYzd0wVf5LBKA8U
 yBJAFlkpMnHY2Qf0ayppSTPSNCOo0iQ=
X-Proofpoint-GUID: MYtCwTVy4IWD6iSYcVWIKbralsJqCA4V
X-Proofpoint-ORIG-GUID: MYtCwTVy4IWD6iSYcVWIKbralsJqCA4V
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDA0MSBTYWx0ZWRfX1QWDbb4B2SFp
 45vtfJ96EV52M5rI+p++kJk6nQextMMNHke7Foy/I4Qi2tCsjJ5y4RS19UBlZZmdFM5ExhTgEMm
 MiqAVCyE8SMuVf5eR/fXTV2gSl5D14EWJJeRTpxZEgbnicMMKQTj/cugTcuRcad1mRx5kupMfB2
 PvEJzvCfQcNPA8ouopPz/fl/eMqsJIV6QvYA9vhxU48md/fJwZAUHbPFRfyij6yv7P8qXyyz+ZR
 0itA7OmTI98kgDKXusHedjTQolnNAlhxGOu5gqkQFeuzqPFWXy0JPVbEQbJTZJrpzbFWVWgKP3F
 ob0Dfq34RbIAA4Bv8E0gZC0iNVZjjQiBIaklW35GZkKwSxDocjH5c9WGV5PfA3vJ8akh/0pJMfA
 rT6jG46yC+gmf/6xy3eWcWLfffgs7wvuQZ+vcBpm7X9nhqFsp0E1+eQ2gQ6yqt4P4WYDHKRyU9N
 lfnK/inuktTKJI6e5Fw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_03,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 phishscore=0 clxscore=1015 lowpriorityscore=0
 adultscore=0 priorityscore=1501 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610080041

Add support for devices such as QCN6432 that provide the M3 and
calibration memory through a unified data-region reserved-memory
node. The QCN6432 device tree continues to provide separate
q6-region and mlo-global-mem regions, while the memory types
mapped to M3 and calibration memory are allocated sequentially from
data-region.

Track the allocated space using an offset and allocate each required
memory chunk from the unified region.

If the data-region lookup does not return a reserved-memory region,
fall back to the existing per-memory-type allocation scheme using the
named memory regions such as q6-region, m3-dump, and q6-caldb.

Introduce a helper ath12k_qmi_map_target_mem() to initialize and map QMI
target memory chunks.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.6-01322-QCAHKSWPL_SILICONZ-1
Tested-on: QCN6432 hw1.0 AHB WLAN.WBE.1.6-01322-QCAHKSWPL_SILICONZ-1

Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/qmi.c | 83 +++++++++++++++++++++++++++++------
 1 file changed, 70 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/qmi.c b/drivers/net/wireless/ath/ath12k/qmi.c
index 817bd820623d..cc488cfe2b2f 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.c
+++ b/drivers/net/wireless/ath/ath12k/qmi.c
@@ -2842,6 +2842,26 @@ static const char *ath12k_qmi_get_mem_reg_name(int mem_type)
 	}
 }
 
+static int ath12k_qmi_map_target_mem(struct ath12k_base *ab, int idx,
+				     phys_addr_t paddr, u32 size, u32 type)
+{
+	ab->qmi.target_mem[idx].paddr = paddr;
+
+	if (paddr) {
+		ab->qmi.target_mem[idx].v.ioaddr =
+			ioremap(ab->qmi.target_mem[idx].paddr, size);
+		if (!ab->qmi.target_mem[idx].v.ioaddr)
+			return -EIO;
+	} else {
+		ab->qmi.target_mem[idx].v.ioaddr = NULL;
+	}
+
+	ab->qmi.target_mem[idx].size = size;
+	ab->qmi.target_mem[idx].type = type;
+
+	return 0;
+}
+
 static int ath12k_qmi_assign_target_mem_chunk(struct ath12k_base *ab)
 {
 	struct device_node *np = ab->dev->of_node;
@@ -2851,6 +2871,48 @@ static int ath12k_qmi_assign_target_mem_chunk(struct ath12k_base *ab)
 	const char *rname;
 	int i, idx, ret;
 
+	ret = of_reserved_mem_region_to_resource_byname(np, "data-region", &res);
+	if (ret && ret != -ENODATA)
+		return ret;
+
+	if (!ret) {
+		avail_rmem_size = resource_size(&res);
+		for (i = 0, idx = 0; i < ab->qmi.mem_seg_count; i++) {
+			chunk = &ab->qmi.target_mem[i];
+
+			if (chunk->type == CALDB_MEM_REGION_TYPE) {
+				ret = ath12k_qmi_map_target_mem(ab, idx, 0, chunk->size,
+								chunk->type);
+				if (ret)
+					goto out;
+
+				idx++;
+				continue;
+			}
+
+			if (offset > avail_rmem_size ||
+			    avail_rmem_size - offset < chunk->size) {
+				ath12k_err(ab, "failed to assign mem type %u req size %u avail size %zu\n",
+					   chunk->type, chunk->size,
+					   offset > avail_rmem_size ? 0 :
+					   avail_rmem_size - offset);
+				ret = -EINVAL;
+				goto out;
+			}
+
+			ret = ath12k_qmi_map_target_mem(ab, idx, res.start + offset,
+							chunk->size, chunk->type);
+			if (ret)
+				goto out;
+
+			offset += chunk->size;
+			idx++;
+		}
+
+		ab->qmi.mem_seg_count = idx;
+		return 0;
+	}
+
 	for (i = 0, idx = 0; i < ab->qmi.mem_seg_count; i++) {
 		chunk = &ab->qmi.target_mem[i];
 		if (chunk->type == CALDB_MEM_REGION_TYPE) {
@@ -2860,10 +2922,11 @@ static int ath12k_qmi_assign_target_mem_chunk(struct ath12k_base *ab)
 			 * Once cold boot calibration is enabled add support to
 			 * assign reserved memory from DT.
 			 */
-			ab->qmi.target_mem[idx].paddr = 0;
-			ab->qmi.target_mem[idx].v.ioaddr = NULL;
-			ab->qmi.target_mem[idx].size = chunk->size;
-			ab->qmi.target_mem[idx].type = chunk->type;
+			ret = ath12k_qmi_map_target_mem(ab, idx, 0, chunk->size,
+							chunk->type);
+			if (ret)
+				goto out;
+
 			idx++;
 			continue;
 		}
@@ -2904,16 +2967,10 @@ static int ath12k_qmi_assign_target_mem_chunk(struct ath12k_base *ab)
 			goto out;
 		}
 
-		ab->qmi.target_mem[idx].paddr = res.start;
-		ab->qmi.target_mem[idx].v.ioaddr = ioremap(ab->qmi.target_mem[idx].paddr,
-							   chunk->size);
-		if (!ab->qmi.target_mem[idx].v.ioaddr) {
-			ret = -EIO;
+		ret = ath12k_qmi_map_target_mem(ab, idx, res.start, chunk->size,
+						chunk->type);
+		if (ret)
 			goto out;
-		}
-
-		ab->qmi.target_mem[idx].size = chunk->size;
-		ab->qmi.target_mem[idx].type = chunk->type;
 		idx++;
 	}
 	ab->qmi.mem_seg_count = idx;

-- 
2.34.1

