Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792738915;
	b=2x4RoBPmvVjmc+/kMNpFG3dntoUbOK0y/DOiV7zTDDQtskxhu/ZznjX2idXcXcyNAxYj
	 4OqpWyMZpVGiX9Tefx9ZqZl5tz5hXwf69DhgHvI45dPmGGQNJJ4iwdhwPl6IBThfgBs4S
	 N2eYIjRIsy3jViv6abPn4qPZ7t9/6godM0Vj+uptI6dDP0vopBHqY1fudmcnlRXbqRsn4
	 2whcf4Kc/IcXqPRfL3YVtMXX/qmUHzPggM4Dxl/NlgtdL8aTnOmFiT7CGEkK4QU2EutF5
	 i24fLoPiHdR4VXLtmB2PePWU3NjJ+Anc9SVE1YxTRoSrrPAfA+c2Na4Z4mKcVc/hSNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792738915;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=5kUQdOW24c5jNgScPxlXh4VzOb4yzLmXbjVCRfz9C3I=;
	b=F7vw/Mg3Y3XlApLgahTohdSraisIY7SwbyYRt3dBJMfPJMp5STKPVgQCMsgegdqQdJ2b
	 o0iqw6S5lAA27uJbLMjW7FRRTZVqztEckbGlDaAF3OsXnqdUBskKqJmXhkWg8LGerYlPr
	 uoj7my5UC/hkiCexkJ3aIuk6TUnr//DEgNi6BOrLW2Lnk1dmNLHKeWDb1HMubhaqGR/cy
	 60Qln13xvV7r6N5t+53gPs+5iNbxtv0k3NOz3kdC54Zt5F+eAvfaDn9ZDbmRWFmCKoIya
	 jHwM1Gru6QPsd3hhpWinb7VmDVmKVg+AAjVvyfNMdVNvqmk2J4ENwHwXURS7DYB5u3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=ZofF8Moh;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Y9LYm7Kx;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E2A60A6F73
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 07:01:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 14E2A60A6F73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=ZofF8Moh;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Y9LYm7Kx
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69N1FGI51792788
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 07:01:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	5kUQdOW24c5jNgScPxlXh4VzOb4yzLmXbjVCRfz9C3I=; b=ZofF8Mohc+USW1eI
	NDFrJvaaQSRAQsSPoHSy7cpknJ1bfuCth11Q0ARVxBr916UiFOSYxyLIywCyZS8c
	EExb1vL98f9mBJurk8W3rL57ammW8yryZRVgHFLwL90C/YHwz4rw3PeocYmh+cIF
	hrbcMPkVqKgo0EMJ2tFl0eZV7VO/VEj+h+/qGk7dfc4klK6KE1i+cjNhKCfAt/n9
	CgZ2mUC1FyeKmWPi1ZKLkBg4BdOsABv0IYfE+7S8dLJ692DDRJPuLgpNae64B5T8
	J50+bV5STkXSPKQyjh3uXpuUlGv3naULoEmaefn3ZYsiQq3/tneVE5zjv8g/NX0s
	T3aysg==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hfnq0jwg5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 07:01:54 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3abfcf726dcso959544a91.2
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 00:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792738913; x=1793343713; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5kUQdOW24c5jNgScPxlXh4VzOb4yzLmXbjVCRfz9C3I=;
        b=Y9LYm7KxY2bk/4TtqZ+1UIE86CmBC42GOyxPhfmMQ0Uw7gRSux2XSGV81r7n4cqyXB
         DZm0ZryfoWQJ6lfKoqC0XLZSw1oDRXTK9tl0Xvw/+OGT1tl4S9aI9RwuVZmT9Hgud6Un
         xHJ1NDc2QY+KRAJmBCxGnkobkZjpJ6UR+cuhfDsuobtU2RXkH3cPs5n6IzDQadPeM64E
         WLpnzARcB8qb/HOHcdj8yVojsXJJu/gfkY8qsxaa/U1AcCGj64DLD0mEqon1Y7Ra//gO
         GZ/8t+O3EtuytBaRT8k77AJd19l8uocSbZGs6cjaBI1khCVr2SVkWeuhMuMTGTKJgrDy
         yDww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792738913; x=1793343713;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5kUQdOW24c5jNgScPxlXh4VzOb4yzLmXbjVCRfz9C3I=;
        b=2PD1zGQyajktarRyea39dlmKBkNZyZpy5VqywfpL90qtsZraUFTG0iAb2yNZPk8Cek
         yO4Xv96SDmzBLguc3eLiaO8dARvMHuCbQYSWLG4/52retV2wkflU0JL1O7QjKuaJCy9P
         t3CsGI8gamPSPblbK2b5D07UjsFSTdS75K1qwVNfvQ105IWb6LizEM1W7VOC7IgO9buq
         tSyqIwBIlcMncyLCxMKSMwbANYLSRZcyf/DYAi32VKf6xHawS64eXtPR/8qaMUq3GA/2
         xk6oo5UaURA2BPFW6MzPFuoa2gt7UbxFFrCdSpd4J1mP9dIGSwo3QG/B+4U9cSkHb8G3
         rbJw==
X-Gm-Message-State: AFq9FYKasPHPkn1arXgkzJ7VPmNGyWv5+XrjdDv++Ygn95eNb98ejm2b
	yuIXXYGQcrK/hgdE8cXPwP8zOjwMCjf4UXHfcv1pPmR4H3gCQD/Vil6qY0NycYV4tczlVMnTa5f
	P/1O2CqwYg/DzoK74iUYKqfqPYo4Cw+KqTPZFv48Kjcn7sQIU/xu5nb3yUnlTM8dZrKMemQ==
X-Gm-Gg: AYBFou2it3WUpE6/UrZN/KCd1bldVHQFCirjfRTYuk8SrOUsLVPaZ56U8PTWXr1kgts
	hzH5JGWBdAdNyC3IlHqzUt/oftElF417PEcCtmnVE7MoU4ADRRXPM9tAVPoOdpjM16nyRRQGgmf
	b5PeLm6vXtZ2DVTzOmkp0RMzzlmj/CTpQQA9LsUeuV78i7ljydOj5zqyEHOfDJNGswGgK4F2orU
	GSUtRzjZk60YhCg2b4L4enABMcALMKr664T9LDAlWvTXq+MdM9Ngrg7dIyLJaeysXhQcFjc1h3J
	p6tatONfacn7YCbcGUEuAn1rfSowNmAUzzMcx3oTzShRFuJtDNmzcvsUZ+MrRv2PNc6I/ESXkoo
	UWOei3zlfpt2y/HblTVWuhQCpqVUvrCXUyvZuvKzTymNrxrso1iYioD0urWRpvJq4BeS4PJkgyD
	zCge+FWTMy+x3HnPmC8HXZAQ==
X-Received: by 2002:a17:90b:3c0a:b0:3a8:bd51:205b with SMTP id 98e67ed59e1d1-3adce0cbffcmr1184624a91.37.1792738912737;
        Fri, 23 Oct 2026 00:01:52 -0700 (PDT)
X-Received: by 2002:a17:90b:3c0a:b0:3a8:bd51:205b with SMTP id 98e67ed59e1d1-3adce0cbffcmr1184601a91.37.1792738912170;
        Fri, 23 Oct 2026 00:01:52 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd8ba8a6dcdsm399751a12.18.2026.10.23.00.01.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 00:01:51 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Date: Fri, 23 Oct 2026 12:31:12 +0530
Subject: [PATCH ath-next v3 09/17] wifi: ath12k: add support for unified
 data-region memory allocation
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
Message-Id: <20261023-mpp-bringup-v3-9-19f3fcbf7b5f@oss.qualcomm.com>
References: <20261023-mpp-bringup-v3-0-19f3fcbf7b5f@oss.qualcomm.com>
In-Reply-To: <20261023-mpp-bringup-v3-0-19f3fcbf7b5f@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath12k@lists.infradead.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Proofpoint-ORIG-GUID: L0VZWLeYgDwzPNaFt79i7zPA2hYkLfOT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAyNyBTYWx0ZWRfX67H9sQFs47eV
 Oywt8B9Kody9fq3R0+JN47jwuhPaEQ0ApU9dueblNUK+ShwgvO744R/c92FuauQcfxXB6PJFHtq
 9pgu03U0P0XIvDB8rQqtElYW2K6muLTo9piQI+lQIt6ffcioOX76SVlxLKrlSmHAc9iEjtVkUfZ
 G2JlQ3cPTZMaEH6iRf2gI49gq2Z6AfFLhc5wbVZBCRePMfI71R6FbSNHWMLFYXBrqHE6osikfmj
 mo5B0Avt5pmcOq6mEHjxROQvWBQdRpS4Mb/0rJJwHYHsMv/AHNWaPhLgi1FRY82IpKDw1iAXSro
 YMXunL3UqV7QYGndwlNehoEXutMvysqDlGiUXsstQ4lkH2PyUqHiXyUL5wYPdQa5JeqHQ0qcKYa
 ufnP/8o3qFEWqdE6Gied3PWOHmphc+AQLsXUMw30vuaazWhHf0eT0ILWB3Lfcuz34EuCCuGpazB
 mycfeHZzwZqIBKFNj7Q==
X-Proofpoint-GUID: L0VZWLeYgDwzPNaFt79i7zPA2hYkLfOT
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAyNyBTYWx0ZWRfXzYOw4wOlXizQ
 YlaldT6DmWkGDUsq/a7IS00boJnRdPrcAUNGDdIZjRkddwqgcYn1CRCsBS+QZmmsL7VKRwlGrkG
 I79sS3eC/07PaYoynnV0XqRTedXD3p4=
X-Authority-Analysis: v=2.4 cv=UaHE26SN c=1 sm=1 tr=0 ts=6adb0662 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=iclRB15sEzZHjfpwsoEA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 spamscore=0
 malwarescore=0 lowpriorityscore=0 suspectscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610230027

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

