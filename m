Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D834963AA
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 12:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784811314; cv=none; b=JnnwWWO98Q0iMptd3JtPE7zmI890Yrl7DiTN9BC/asuZzVK/U7eBHo5dfd6+H8p/qn07eLvIs7fEKzplKTdgBL0Jp7j4f9JHjKDKofykHv94dbzejQXFTSI0aMxIXlYRFzMnViw4cZQUsDIqCIjRG72cQugoz6NGJyftj08NzKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784811314; c=relaxed/simple;
	bh=GMZkvpA4p8/D72YGYWouPOD+Vktpq4lsglpx+iSypTA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DcWSSDrRjPc2oEvzj+gAoffcsxwxconACYoZ9fkWIQwdxvmAd4V3ufMF4HvLc6XgyVvKFJhOCMExZfZVhRVAenQgp3sNQ4pzYqUUbNR0vgReAzPSUyTM2E85yM0VaavfFn+YxewUtNnsVjf7mOzIHe4/uVk31jjZy5gaFNsJjfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=NkXh3iwg; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=QtksapEv; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="NkXh3iwg";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="QtksapEv"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N8qgQK3642636
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 12:55:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=uosMbuo5mUL
	+wpsJKBaRkdlSOd/ZPwbep/HNPlBi0YI=; b=NkXh3iwgJDmnXgqlJNIsFwSNFk0
	QjeJBGODDGScSZhlp64Xz2wq94IkeMcme4HA33cBlnkAhxGjaNcOfER7rix1SLvs
	CoC63VRYwf/9UizXOEEsfg0EzSSZgXZ0yBlsnvyKrR5uUelU1IyTJ64lN3PU+ytU
	MLgGIWVyWalVPAoPcYDRDy7NWKkqyF0VQFsgg4FRMHfBKxMCILS+OWf/0JpBTf51
	8Ks0oS+QGDAXod3h5l2SA/MPJaxKBFzadiedtiaHRCgf4gw+8qpkP5ENN+rVHatG
	hmgPu4cR1E3M94OXZNN7edRngzuYtPg+F0H7CYQXqwaBvNEeLdxlCCRGD4A==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fkayha444-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 12:55:11 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cc7e86e7c5so11470995ad.3
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 05:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784811311; x=1785416111; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uosMbuo5mUL+wpsJKBaRkdlSOd/ZPwbep/HNPlBi0YI=;
        b=QtksapEvqnZ/GPmASusF9lKwmxuHbPTK8h0texDvWrVShpPA4Tk0tmWFJiu+AtOeBp
         CMhTMdLB+VoXTbIU/VICnYS6N/Jr+hxyM8YlRKVzPwCu4aLzqNLRX7b+Y2Pmy0G5vRVh
         AFuUNYRJ+UQp2+YnJGucaPsPGP+C9NBhNJbN2MrIrwpuhQ79CN0FbEPsnRFplTn2VR6N
         LCAnl9Ijvcgq6lDQRdNZ+NB/mLTLLTTjnOvfOe2+7r+5XaP73O8fn6HOZWlEyXrhxwCg
         cJNtr8YfegMKslslTadS3qofYZP9k4kj7txBNrD9Ck2+YRK/Vw0HNvyMGT2oYb3AaYuv
         4YmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784811311; x=1785416111;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uosMbuo5mUL+wpsJKBaRkdlSOd/ZPwbep/HNPlBi0YI=;
        b=hIBVEI2Oj6GuWVARJaFApQdYwNmL3VMEuZ0cqdsi2snw1nyKBlXq+po0dFWbXwHQQL
         TrzmLGafrdtkkEDm9yh8u05Ub/P6Xn7l/tr8xFO/za6owrmm2x5MPhoOR1vxF+KxxNnN
         GcZw+tMWNxY5qltCU14UYii3CgdiVy3DkHdKzdzQ4ZjgWkfO1qCGqBTDidrLi33dAmEn
         z9MCKPSY8HDbjx8kNEmhrAqO5Qqi2ZSVc/9soMkuW89aBUuCA6noEMZyc8iwrgwCB46h
         JYlqQ3/pCz22h+7D1hZ1LdhxeGcFsnjXNYLSfo3mm9ej9FEyo0qxMCHdJLg4zD55LIBh
         11dg==
X-Gm-Message-State: AOJu0Ywrf7kMzwxlz6HDu2Cayl/g3Dnm4viaWi9kazkwPCbs89HA7Hth
	aHFCRnMeFfc4tHPFTEh23rHuIS5SOr2MT4KzzXeKBR/EfAA8H4FeQwuozoauBx8BX5RgMZJNqD7
	C0O3RV6au2PIoxYLgr5feQod4jfunRRhB5qzOkmUNXux18wvqFJCAWOtBQ/JUBVRLwWdWYSqUuE
	xNUA==
X-Gm-Gg: AR+sD11yLNMGNGVL2+z6nIidmks4f7GqAziq/wZLLkj5tcXlukjy3Y5gbJjqryyEI9e
	wl2n9r2PxuiFWPBFw/j9y/OjHjM0xsWMsl7DzYGhLVBLGP1iatSTszvz+Qj5VwhmtOcZzEC+Nz+
	IF6aLRqtf9M/bozpKwAhSyRvr3eM4WQ+wepwo5LFn/sflvMGLSPHG7j1YXriJP/hWbVrwp47e5k
	RVRUukUwipNPZHr4hF1qmY8bIXZxESLitPojBvzq73sUJh6BOjgazGnD1XQWirLR27wI6mOC5Nk
	xko/te/DJY8pL6EberNQYWPVc5PSRV6PFmhDoCkfbo50SIW+FLk/RZGhL+Wk90XIfVmGeInW9Cd
	PvVZoJHxCFvpuXwfeHiyPQ3NoxiZUTOmu+DtqYiJj+mLyFwW8u6Fh
X-Received: by 2002:a17:903:124c:b0:2cc:6018:f030 with SMTP id d9443c01a7336-2cfa6b7dbcamr34960285ad.14.1784811310825;
        Thu, 23 Jul 2026 05:55:10 -0700 (PDT)
X-Received: by 2002:a17:903:124c:b0:2cc:6018:f030 with SMTP id d9443c01a7336-2cfa6b7dbcamr34959925ad.14.1784811310363;
        Thu, 23 Jul 2026 05:55:10 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf8f350475sm32998385ad.70.2026.07.23.05.55.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 05:55:09 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next 3/8] wifi: ath12k: add TCL ring TX buffer allocation failure counter
Date: Thu, 23 Jul 2026 18:24:43 +0530
Message-Id: <20260723125448.922361-4-pardeep.kaur@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260723125448.922361-1-pardeep.kaur@oss.qualcomm.com>
References: <20260723125448.922361-1-pardeep.kaur@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=HZgkiCE8 c=1 sm=1 tr=0 ts=6a620f2f cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=EUspDBNiAAAA:8
 a=EdzCd4oJGJVa484SHGUA:9 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-ORIG-GUID: QQ2uXv8A7k3e8mkoB_j2vU0Gw51k-q5F
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDEyNyBTYWx0ZWRfXwRHRSuiS8qLe
 Blni+pDKNMJq/cS5NMjPogMYqbMXAUD4sapZO7UPFl7sB2TM175y5XR1WOo01ZXHlu1zrWQOLPy
 cJW+R9ZHnEtLWROw4WKcgv5vBkCQ+zx43Wno5JelT4ZyXxFWlVAcd1BRjUj3feZ6EHbAfTKrkWH
 LryzyJfi7rDuXxa2gAw+esK/Zyx3t2rCgG4qzmXZX+hSSYYsmAvkcn8/wcI74ZteMXW6/gbkgYU
 wtQcBaEwfdq7iSe7gaa8/xa8Y1DfCejDTnGXpUHfI+mruyzYgPJHVxZXwnHoSzlK/OEcnRhFohW
 qc8e0ElJDWOvwJphHb1h7bxl4m+rJMSXh9ujwgD6SRWLNc/2oEskZlaEOZ2hUsRKe8YmRaKqzbI
 z+nEOg4SQyLSygnody2Y4gFjgi4AFE8RXQDpE0l6YL0HhhP5LQw1FauQmD3znJc8kTyw3sru1uf
 07lkxzUjyFGFbf2UCXw==
X-Proofpoint-GUID: QQ2uXv8A7k3e8mkoB_j2vU0Gw51k-q5F
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDEyNyBTYWx0ZWRfX4Yip3BrtcSJA
 rxSgYV+L5Xqz6tGnFpfzzmMEzdvF2GBiCcEUJelU58wwH/GFvxqfY+nlGA7R4HTShohp0er9mZj
 qBS0ba44UTFKJM4GDOTqh6lVvByT2M8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 phishscore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 adultscore=0 spamscore=0 impostorscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607230127

From: Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>

When ath12k_dp_tx_assign_buffer() fails, the TX path returns -ENOMEM
silently with no per-ring visibility into how often this occurs.
Without a counter, buffer pool exhaustion on a specific TCL ring is
invisible during debugging.

Add txbuf_na[] to ath12k_device_dp_tx_err_stats to track per-ring TX
buffer allocation failures and increment it on assign failure in the
TX path. Expose the per-ring counts in debugfs under a new 'TCL Ring
Buffer Alloc Failures' section.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6.r1-00402-QCAHKSWPL_SILICONZ-1

Signed-off-by: Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>
Co-developed-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Signed-off-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/debugfs.c     | 5 +++++
 drivers/net/wireless/ath/ath12k/dp.h          | 2 ++
 drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c | 4 +++-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/debugfs.c b/drivers/net/wireless/ath/ath12k/debugfs.c
index d54995b7adb2..0f8b458200a8 100644
--- a/drivers/net/wireless/ath/ath12k/debugfs.c
+++ b/drivers/net/wireless/ath/ath12k/debugfs.c
@@ -1117,6 +1117,11 @@ static ssize_t ath12k_debugfs_dump_device_dp_stats(struct file *file,
 		len += scnprintf(buf + len, size - len, "ring%d: %u\n",
 				 i, device_stats->tx_err.desc_na[i]);
 
+	len += scnprintf(buf + len, size - len, "\nTCL Ring Buffer Alloc Failures:\n");
+	for (i = 0; i < DP_TCL_NUM_RING_MAX; i++)
+		len += scnprintf(buf + len, size - len, "ring%d: %u\n",
+				 i, device_stats->tx_err.txbuf_na[i]);
+
 	len += scnprintf(buf + len, size - len,
 			 "\nMisc Transmit Failures: %d\n",
 			 atomic_read(&device_stats->tx_err.misc_fail));
diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
index a94bbc337df4..ac125adde258 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -428,6 +428,8 @@ struct ath12k_dp_arch_ops {
 struct ath12k_device_dp_tx_err_stats {
 	/* TCL Ring Descriptor unavailable */
 	u32 desc_na[DP_TCL_NUM_RING_MAX];
+	/* TCL Ring Buffers unavailable */
+	u32 txbuf_na[DP_TCL_NUM_RING_MAX];
 	/* Other failures during dp_tx due to mem allocation failure
 	 * idr unavailable etc.
 	 */
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
index a0e409452a19..ca0e1369af21 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
@@ -123,8 +123,10 @@ int ath12k_wifi7_dp_tx(struct ath12k_pdev_dp *dp_pdev, struct ath12k_link_vif *a
 	tx_ring = &dp->tx_ring[ti.ring_id];
 
 	tx_desc = ath12k_dp_tx_assign_buffer(dp, pool_id);
-	if (!tx_desc)
+	if (!tx_desc) {
+		dp->device_stats.tx_err.txbuf_na[ti.ring_id]++;
 		return -ENOMEM;
+	}
 
 	dp_link_vif = ath12k_dp_vif_to_dp_link_vif(&ahvif->dp_vif, arvif->link_id);
 
-- 
2.34.1

