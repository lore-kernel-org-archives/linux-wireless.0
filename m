Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8ED8375ACB
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 03:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792120952; cv=none; b=R1KlbTDVwN2H1WUgoczQKY2WeafGTMrns4sJxrCK7qEYmSGz6lBn8O6E6z5r0RmmKWubg0V5GFvyCn9GfwYg55RRRrxf4FIShVl5rh3n1B1hKxaPrZZbgr960v/BqLwMRoXd36SbrXvYegCju+vhBJnR3gBkKUNAmMZjZ7pWI7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792120952; c=relaxed/simple;
	bh=QgVnRMxXVlNk2B0erCzCAnkl4/YWHQVmaHD5aXG/R1w=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dKdUEwptbKyevf/0hJTWwqLSrQXyiPE/nKtF6gPWXOWz/yOvpDD5mjylDGOhxnpKzph38eZnFTghyZs1/fFYEFQrxBhWeUUqgpqVk9IQWcEJHZmdNUTYaUuyHHeaN19Es2r2qgGTNeLbgt3aiG8KrkNuCRwc0eCDRrvc2px2LZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Hs6xo075; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=WfgqS9sT; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Hs6xo075";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="WfgqS9sT"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69G2FE9n3202275
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 03:22:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	5kUQdOW24c5jNgScPxlXh4VzOb4yzLmXbjVCRfz9C3I=; b=Hs6xo075deQa5g+J
	HbNwJvBoKM6xiougM26CaneMWkgjJoqHoMdBsr/3z0ikWuAFVu8dFmenBqSLZtfa
	Cm4CidWmYQmdo2+2q5WwgCCeDN3cjY1XdNZtHW3itl0gaTucns7zo/QipzE+zXoM
	Ns2frhBo33vh33I7aeuSStJ6zr2OoHE2KYoJPFDBTecyCEi0CW2dAc1NFyGvrw5n
	PPPGTKwwPCwK7RKnOtThYGYO5yJJpA5vx67gMuydrpVx6v8UspcLk1gaefxuvdKx
	GF01L4+75etKT7YMKa8OEfeOry1ykHEHDsdzyL+vzN+tDpMxASf11i6w7Ig29Zjz
	3gUr9Q==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hb3r39u0m-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 03:22:31 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-33c35f5ca6cso12163267eec.1
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 20:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792120950; x=1792725750; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5kUQdOW24c5jNgScPxlXh4VzOb4yzLmXbjVCRfz9C3I=;
        b=WfgqS9sTkitavvJgCWaP4mUzTA/TAdAL8f0egt9Bxj9Gi0ulGalaEcJOMHTZh7sw7N
         n7lg0zCWpYpsg4roH7NPGSHhItFGdrPpSxGMHKwysyUVRaBZaCTidx6uHr20R7kO66Vt
         XLRziOuiW49PztsOQWIkz+p8c27s/XGdhuJTMIlhLG/TgHJtwAa8/pwKX6x0bYCOEcjn
         iRyICi75qR1Dy0JVO4a1SgeQitLj6aN03qkb+LsX3SOok9Apy3JLl5JWaUHai+MHpmuI
         I0QwpvUpw/G2oGPvXFAcF10GTYVKMWINuSz4oDpIjaOcNuf7oDt+O/VT4F8b1gYZ5Ndk
         UFiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792120950; x=1792725750;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5kUQdOW24c5jNgScPxlXh4VzOb4yzLmXbjVCRfz9C3I=;
        b=lefd9qsRNEfQASLpxWMo2Nj2gAwuLamL28Paf7oNNpyY94SH4t4GVKGuANBbY0G65M
         FZBg8ipAFo/Z1PjY2CenuhGvLIUcWVsQwjlIEP4n8tggge8/Tbqh/lsPml3ygAVQw9YX
         q0glvM+f+28/E2aNXTi0idzRwJNoTOkwAC8p9Rr6i664R8o+/9CjihQE5StgWKtwfDcZ
         xiDpO3P4N1igirHd1+Xek+xosDZ3YMBcsHAxvZJBYZwBRSCCgWiK417v7Uk1jPZGOoGH
         LKpF77VYW6GlrhPDK14R1FGarHDIwpcdDAFLtRH5mzLPjUjGFeHd62LA0wDPB8nMaTCj
         Y9mg==
X-Gm-Message-State: AFq9FYLVq3FtFs4jNb8FjDi9i2js4tMvQUvhuoAHafqxV/rxp7oHlD1V
	+rxrBUMBw9w2GgI66XDc7iHkYeexPnssz+oJukfM/B2NQNTiBGI9aoJHzkpRuQY77UPSmrp2swX
	88nt4XAEKvuhNHDojdj3w0+RQ/2KLkJVSlyi7mOKQrzkKz9lHvD6uTdMkxp7B4/nn/gTExw==
X-Gm-Gg: AYBFou34p57avv76HAspu5zMjGcQkTnSGkP3I8UFgX9/ilc3EIUGwuhMho02nZ6hAUZ
	BAgPnrpdxAE8IaAal0W+DCk24EELUt7UKchEYfpyGSRheHjQ6MbGmSWTxwIVeoy0UmZ7tx3dJHt
	5NBzcwd9SY7VPN7UYP6tPPdc2i74bZh4sC5eRJJP3xKVkz0w1ywubuoek0LKYphCFckr5cS1YQ2
	WJVBHa9e3KjTH6ku6K02HAoQsmcLyRkJvPzbdr0R12Hg/hv7Znl+MMnGRTEQb1h1pGUeID1Fgwv
	phlK/wO1W5BJA6+ANlHxzzn/K49zLocpGzoQ1dYjulZI2WJHf9HryOZRFEsm2AmjrgDD/RAbACI
	xjH9t6YF3FPasZ9A0ozEspquDsiBxDAw29DQ+fnfCp3/TfP+Fr2Pck/PeAJmswBsF0TtcoV+XHV
	kPqiilLcaSFuD0TtPKkaDiGw==
X-Received: by 2002:a05:7300:cd91:b0:351:dbc:b663 with SMTP id 5a478bee46e88-3537e13248cmr40625996eec.31.1792120950198;
        Thu, 15 Oct 2026 20:22:30 -0700 (PDT)
X-Received: by 2002:a05:7300:cd91:b0:351:dbc:b663 with SMTP id 5a478bee46e88-3537e13248cmr40625950eec.31.1792120949655;
        Thu, 15 Oct 2026 20:22:29 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-360819be413sm2256698eec.13.2026.10.15.20.22.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 20:22:29 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Date: Fri, 16 Oct 2026 08:51:46 +0530
Subject: [PATCH ath-next v2 09/17] wifi: ath12k: add support for unified
 data-region memory allocation
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-mpp-bringup-v2-9-f510c33bfcf5@oss.qualcomm.com>
References: <20261016-mpp-bringup-v2-0-f510c33bfcf5@oss.qualcomm.com>
In-Reply-To: <20261016-mpp-bringup-v2-0-f510c33bfcf5@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath12k@lists.infradead.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDAxMiBTYWx0ZWRfX6MP1A2zng9jZ
 ml8zYUH0YMRzaJWEeEVsgV0WGoV81cpDuY3fzyG96evFHresBS1f3N8uXLLNkd9/pf5xW1bqjUj
 2XrIiFZrqUlytx2V4l2BHhJ+Hj1ieQWcfbiRXSP8MLhcnZ9JzOsIKSMCmiXqB1RA8Be8fgtHh8N
 bmQhQMr42xbInHSTJCIRyukV94YaXCKN4sI0LOlEfTGCP07PiOq45r3BoA5743z6XYhbd7V5C4/
 9AAVQZfotF24lQCAF/g3d5c4oyWtv7mqA5mikKpojMf3HFiiBsJJ5Fxbln3Z551xY7X68neMD/a
 akZG3avhdzYY5u3R+EsFysoWTKoUcle5md6xLJvfrwQKM+KQul5/M+Wawehmjmb78KEfnxkK1YT
 fFTblMeVcsF4J6gFQiC3/UTHGGkBueaRLN6x2Ue9JRySyKs+br4O1uQ6Y4lFIH6DlJCRV6+COGE
 riKC3vKFSTHL3TJWxAg==
X-Proofpoint-GUID: TsiUVTh1LIwkb6vu3VBO5T_WNVFGQa71
X-Proofpoint-ORIG-GUID: TsiUVTh1LIwkb6vu3VBO5T_WNVFGQa71
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDAxMiBTYWx0ZWRfX2ZkE8NgXn3tB
 YSg25Gq1pvTsDTSWPytLEZcGIlAxc4cU0zuBlgcYOcB3FdvYdzCKktWumzEaE0hEWWy6lg5YnHU
 pWu0rNSym/Ckgqdu5tS8zytSqIbsZeg=
X-Authority-Analysis: v=2.4 cv=INGXmQvG c=1 sm=1 tr=0 ts=6ad19877 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=iclRB15sEzZHjfpwsoEA:9 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 adultscore=0 priorityscore=1501
 malwarescore=0 suspectscore=0 bulkscore=0 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160012

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

