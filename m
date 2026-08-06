Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0556133A6F2
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 13:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786022688; cv=none; b=DDSKuLw9LzJWdJs2Ji2DPmem9uZM8/f2izXjrNw2ICYDrNr5RexbOEZpN6Yq3BQ7aa4qc88fMW3SY4ak5Cx4kjYs4M4r36ezVKnwP1zZl7RtVg6wSYj+138pD8w0C7HfXbVmZn/KptFgSi9K5d+/JyiFn80mGMwglp78KlDVYQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786022688; c=relaxed/simple;
	bh=12qURBaXe+VHVvlbhm3Cu4vyINZGxaOnV/zbqdV3a/E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=m1P6aR7blj9uyIRJ/taxXVurqrwweZT1mdSafGdLz2hobUJPjEae9jVxR50xIqWlrHFoZrUg1gVeovDKJiqSBgPh4gnN0vMehrTwC5I10clSUf873mtjeokCFBVsB9av6wswvrjOeVL3D4ak85dlPWhypjWek5REnId/Rvdg09g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=QlLPuz25; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jjBVClLU; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="QlLPuz25";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jjBVClLU"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 676Bwwbv3037385
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2026 13:24:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=YwGMP9ynsxK
	lI/ohrLuFqx2UZfFwtRO5rMgbVYv71W8=; b=QlLPuz25pb7dBvilhlqbTWoNFdw
	6UbIbSmWEu5bzuVti/PdgMs49FAIaLzW31whpW1lxzbAYuYyC2D7lGt3u4Xmi04A
	2I3Ln9XT4sJ0MyG65MgD4SkL4WpZlOOv4gL0GzTs1mLcM6OpHePfe947Atmr6F5u
	E/QPswEt4KwNds5CboXQLVwq06aq5lwi774ncAN9R8VfTJplMzRChqIB7kVOC0dW
	9FEu6hfdVEHkP7+T+uotRWFADljr+J0SrN79D1bnBOAM+yPhnzXIFR9mWFTVIsuZ
	23Ehek208RgpOHgGBUGaTvJh7q3C/3orO8tMtpSSHu72v8VLV5JeS7tKcpg==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvsvd0dfs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 13:24:41 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8484ba00601so2810745b3a.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 06:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786022681; x=1786627481; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YwGMP9ynsxKlI/ohrLuFqx2UZfFwtRO5rMgbVYv71W8=;
        b=jjBVClLUNgo4QXKwl1kJjcvA/wlGixKTABPKs6sjtg3Q1JG71AKhRrrUCLmmtbhHVM
         1hh2ivoZHGpJEuKnAasERL+WF7Y+cYMC8fCf53H72bJ6eqvz59s62ORqX3JZTyarQo9P
         CW03AbXHELA9HK6YEmiSe0D0HVmO+XVxp/by+GidlYaJX2vwhow0BP53iChXa5ANFnDC
         6walhjDOLGAouJgHcUXldUrT5XFAnWyDWcVt1hOhCFhyZv7eIoGxd2fMiuj6clIi2wQv
         Vh2B0isbo55YUgMQR0zXiTuqWiUuhjycMUXocTqjlQznFzP3F52ma9tY0VNVcSSZ6s9p
         Hnbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786022681; x=1786627481;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YwGMP9ynsxKlI/ohrLuFqx2UZfFwtRO5rMgbVYv71W8=;
        b=IM3yOcnv+zjKMyDoFbyxf9mx+TA2CdMlNeOvntHmkb56wUg5j9ZZkSSID3tpN7z4yl
         lWmpMtUuSbp1hKBOjqzVkRVpQQSQepUKnB0p6+R4vtCgSK+Cxb+YycJDjAbdXoU52Qux
         f0aAh/uf28nVtYf+oEaTsRGDr00vxYG/PTgzBW8ljSU6FU+tpm9pr/2lbbezngiFdUdq
         /4vj1THB2Njx8L8pn5nI9eYjH89Zxionxhi5+duDQBL7XGqg2zmS9aVgj8WEzjJbkewd
         ML5LK/0u4mypU4/un4K1Tu9lqpXKSLGZYdrIkweBpxsCS4MQkHgFHbtKfLipN3xpoC3t
         TmRw==
X-Gm-Message-State: AOJu0YwXrdymlv03vSCfrIiB5kR2Y+n7coJwIRZo8It4Kwdc425ZqprY
	44o+dt2ReTxZ34yheYme2ZKNkywgYwXExFFt9UbSQqmtE0OFKasCrLM7wgdLdn3QW3etCuKL9Ns
	q9eV/iRXKH7HEnW8Ky58fd6f1fYb48TBJuAllykpVax6nwqYbk22fOv0mtjHyv30U1urL9FE5Zw
	VdKg==
X-Gm-Gg: AR+sD11FYwzkVmBi9LDUjYYX6KULmZETWUefNSBNtawMtTr+OagndNMbVu/tRVB6nAi
	TBbyaX5tQH8vw/mMgQkq2eQYt74BaBoSYgDzUhF4JZEeadLEU3aNaDNU/SHo8QPrUAIQbVTBx1R
	glUExiACQ4ZaGMDaq1nU4tOvhBijxLczXal0NydqRX179VGc8uEdAiq5yW+Wsi7qg8x476f+arP
	Rrq2pbjHcc/QKeo7TbUz/w7JaLSX4f69tg5KcCS0h8eriDSQQ7viBlWlq1RjxDCZmxYql/0Kbn0
	8eXXzpNLW19sWnQZ/uk7lUbKKtLJ2hVYewBhqamEi9FGcBi2bim4cl+tCRE/a4fRBywrdrAMUvR
	80SRXIhjIlUEJHvDGe8hP/4hufpSosFWpST0Qd5LGIDrTMy1ElU9D
X-Received: by 2002:a05:6a00:44cd:b0:84e:216d:7e4e with SMTP id d2e1a72fcca58-84f2e031748mr17884403b3a.1.1786022681030;
        Thu, 06 Aug 2026 06:24:41 -0700 (PDT)
X-Received: by 2002:a05:6a00:44cd:b0:84e:216d:7e4e with SMTP id d2e1a72fcca58-84f2e031748mr17884349b3a.1.1786022680601;
        Thu, 06 Aug 2026 06:24:40 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f456b785dsm1411637b3a.36.2026.08.06.06.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 06:24:40 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next v2 1/8] wifi: ath12k: fix out-of-bounds access on TX stats arrays
Date: Thu,  6 Aug 2026 18:54:20 +0530
Message-Id: <20260806132427.3704828-2-pardeep.kaur@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260806132427.3704828-1-pardeep.kaur@oss.qualcomm.com>
References: <20260806132427.3704828-1-pardeep.kaur@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDEwNSBTYWx0ZWRfXz4CBmNLGFHnz
 sj2NkJgB1SCLvtcusSO5L73z7JlTbHiEF3YEAETvksiUjSXvIBZnHaQcYDfdiiAeDUBEiQ9OOfJ
 rYeDc5R90EtAQ0G9RBL4IQl5gXDxV70=
X-Authority-Analysis: v=2.4 cv=WbY8rUhX c=1 sm=1 tr=0 ts=6a748b19 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22 a=EUspDBNiAAAA:8
 a=QbJcohpuGl3nbjs-xDYA:9 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-ORIG-GUID: cku0FH1OPLmZSfqUkkCeEhltlgvlm-2Y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDEwNSBTYWx0ZWRfX4h8FQDi14zvu
 d+pA+xEzSU/GEf/2Qi6JT2z0SRPEK4L4eEkJUyyk/jtqTlh75voWBqtdguKHp00Womx8zCPXoSV
 sNNYUnQYD2LEzHf5P2xvj8hVI8W0s8FHzURbsFxtlFiwEIvJwcr7Vu2vuu5Swj7r0ivpLJlDhQm
 dsJBtl/+yK+93l0FAapzP5XKppdpIyRmW77XYgVRmqCQAnktWVEwgr1Q7Semf8yDFK5zz22KTiL
 KvhKBvj4lA/2f4JHGtXilcpW2i7spsPw1w51mHF2XDQXLciEfJk0Ja/41B8+JPKzib7FrLSXSN8
 y/+qiz66ChP632WDl5V0+qlBnTOfra1WSIs/FiDT0adipnQfh1vDrikZLbrTIs4GXcqS8GVdZ7S
 Wb3GKNBQCZqpNi63EmYQ/c2jB0xJ8uQuhfmmjMXY4xykEifIzW/gxycUks1EmvGm6PSOcmxnt9k
 S7so9L+JGUulH9pvf7A==
X-Proofpoint-GUID: cku0FH1OPLmZSfqUkkCeEhltlgvlm-2Y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1015 spamscore=0 phishscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608060105

From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>

The fw_tx_status[], tx_wbm_rel_source[], and tqm_rel_reason[] arrays
are indexed directly by values read from hardware without bounds checks.
Values at or beyond MAX_FW_TX_STATUS, HAL_WBM_REL_SRC_MODULE_MAX, or
MAX_TQM_RELEASE_REASON respectively would write past the end of the
arrays causing memory corruption.

Add bounds checks using likely() and WARN_ON_ONCE() before incrementing
each counter, consistent with the existing pattern used elsewhere in
the ath12k codebase.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6.r1-00402-QCAHKSWPL_SILICONZ-1

Fixes: c5c62287e690 ("wifi: ath12k: Add device dp stats support")
Signed-off-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
index 587d58eeccfa..632230e77802 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
@@ -582,7 +582,10 @@ ath12k_dp_tx_process_htt_tx_complete(struct ath12k_dp *dp, void *desc,
 
 	wbm_status = le32_get_bits(status_desc->info0,
 				   HTT_TX_WBM_COMP_INFO0_STATUS);
-	dp->device_stats.fw_tx_status[wbm_status]++;
+	if (likely(wbm_status < MAX_FW_TX_STATUS))
+		dp->device_stats.fw_tx_status[wbm_status]++;
+	else
+		WARN_ON_ONCE(1);
 
 	switch (wbm_status) {
 	case HAL_WBM_REL_HTT_TX_COMP_STATUS_OK:
@@ -984,11 +987,17 @@ void ath12k_wifi7_dp_tx_completion_handler(struct ath12k_dp *dp, int ring_id)
 		/* Find the HAL_WBM_RELEASE_INFO0_REL_SRC_MODULE value */
 		buf_rel_source = le32_get_bits(tx_status->info0,
 					       HAL_WBM_RELEASE_INFO0_REL_SRC_MODULE);
-		dp->device_stats.tx_wbm_rel_source[buf_rel_source]++;
+		if (likely(buf_rel_source < HAL_WBM_REL_SRC_MODULE_MAX))
+			dp->device_stats.tx_wbm_rel_source[buf_rel_source]++;
+		else
+			WARN_ON_ONCE(1);
 
 		rel_status = le32_get_bits(tx_status->info0,
 					   HAL_WBM_COMPL_TX_INFO0_TQM_RELEASE_REASON);
-		dp->device_stats.tqm_rel_reason[rel_status]++;
+		if (likely(rel_status < MAX_TQM_RELEASE_REASON))
+			dp->device_stats.tqm_rel_reason[rel_status]++;
+		else
+			WARN_ON_ONCE(1);
 
 		/* Release descriptor as soon as extracting necessary info
 		 * to reduce contention
base-commit: 691e5e43b2aa
--
2.34.1

