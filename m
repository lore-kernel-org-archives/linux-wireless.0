Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055AA3F9F56
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 14:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786373103; cv=none; b=P6x/EK3j3X2X4KnIBIwjErVXgHLIdETnMNcbPVbcr4LjwSbuENkYfLcppzMJTDVzq84qPqNyDqpVKf2QiEv+TB/mpxBWPbno0ZQQgWAaXEpF1spT9+DZ8A7IQDATYT31QBZbNz2Vuf4c8z73FqWQquEgczU0xM1hpwt1if9wg4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786373103; c=relaxed/simple;
	bh=GrAVKFk9b8+Omhi+eJPRkC4+9zTLOxA/E0XxtSKuhc4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CxW55gxlfjOcp1BD2aPMBPZGpnoHpdJNN1ApGfmxagoE7Hy/GwtdsK6/NLfW8Av0fBOnVwzVfbIxto37l5QQhLiBsk6VfENl42vmyqOTBXlXxH0ZUJugrV8+MB2jIIUewS2X6couYZ/VgdNhxeLtvNafUPjCtSaEPsNK47TxnVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=lXo+dFY7; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Pc7esI6W; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="lXo+dFY7";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Pc7esI6W"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67ACinOs397250
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 14:45:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=CDc+pb3v6Mf
	SQtwl3l04JeLhGdo7Yuk7Oq1L+GHXJBo=; b=lXo+dFY70GerCuZhjA0PoL46aFq
	lyM7FehEiRGvuTgjvdimzt0tLqQvAjH79H4zFIx0Wjh4r8jsCjNojMnv95rsob1w
	mcu0fsYJLuD7qLyO0w+lqc3lw7UwmLVA/DOqHd/j0YJ1pXWzV8xQ7QFFZcU4tjZm
	q9z7rkdG/NMLAqMRjADzq+NNpx95SjRECNCK9hhwBRBhDAQwBb2UvXbggtArpAGF
	DTd6oUyZTMjNxwFEPVmXbMQsHdcZwI6dRqgav4JX43/1TtI70o054WtQdtesIk0F
	Yu2068QLmB3sZ1ouwRXQ1CjcXJSOTGCXUPC1OSScGskvOgllUW58xS4FonQ==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fycges4y6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 14:45:00 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3823dcc1647so2041581a91.3
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 07:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786373100; x=1786977900; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CDc+pb3v6MfSQtwl3l04JeLhGdo7Yuk7Oq1L+GHXJBo=;
        b=Pc7esI6WVL4YW2+psvxBpAzt8Hgors2OGOB9BxdYiMSHBH7GoeFxMbKYElcihdXJiS
         wpUGhHY+g1Zo2Lcu0zxJ1MVBkewrfUCohgCAsPPP4D+lKgWnYtQjb5rDtjMCPr4JBHam
         xt9GLRJyfBwPHnZ2isdX4dEkYfxOEQvU7OIKnthMGZW7qPIcyzpqb13uVdyhXJvzGK3k
         gwGZIRXDiTGUlngpcs94t6pS2H8Jpe8aOX0oP9C8XwcuV/nr7NecEM8oE5CWugmP2iFN
         MaFuMNqmm43uZkJpCm3Q3T0on3zC6zQ/uGPsk7HU21VHWO830gf6NrF86Zc4WOVA6Fpa
         tLKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786373100; x=1786977900;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CDc+pb3v6MfSQtwl3l04JeLhGdo7Yuk7Oq1L+GHXJBo=;
        b=gP7jm/uI7KYiZoMr8uL7eZKBj4G8agUZk8tTm79nuLFctHzOaUZxsvG9XPisv2pYcI
         oX/y+nwnHgkOBFGnwbNRQR82DhlgkOL4qwegyk5XanqGuFbpKK7zpr8F901T2HyhKtsY
         Wp0ANlB2e4JHVSEo+e1v1AoT64+3N9hDIybABIF6VEAxvOYBSHDfQlB2s6JYom+yiyj2
         k5IJe3+BBAfoGau+6tdP0d4Sk44Q56mlH5vja3m26xhbs8s3QTOP8Oq5Rpn0CI0Y0xgv
         pfkQGKv3edJoFDsmJBvae7IlsYTKLUzIVnQTCRKNhRY3nf3l+eEOERsmIIKt7Phskp0F
         d/eg==
X-Gm-Message-State: AOJu0YwxVbjUFtUTL3vpbbnZ6o9PY4jqks6aqss+mjjYiPoaSHDvoiDC
	49m/PyAe0XtqJyJLWb6sD3QqiaTFySQexZurS+vcXI7V7SkFgIyK6V+guhXtce1dhepK3FtbrrH
	lLc/aeiWl1AYVZu6NyvJO0udzaLyXERgdG//kNJx654bXmsJq8OiWdYe61WLuKlLTLDACtQ==
X-Gm-Gg: AR+sD108Yx8r3Yk2y9IxeihOHRwaCWuwzHUSRbJ1TRJZdDW4rC950w37f0THfQKJYJZ
	mN+YYjhFn2YP3OXJevc1Sd+k2YjMHxJTw/WnOicnMrB9dVB8pbOj0W0NJkxuKlFfOkza8CwMiiN
	mInMymzOGYNcUel4wD14k9SR5/77HmkzPNYSQr0Z6aXTXUMUHM74I7g3D+bLWVu4Gp8vKObsNLN
	mKZsR5QuIOdAr8YbvxyRVE+F0ogFcqHg1AOcE6lL8mwimByScdK26w0oLjbhsUV1hpZKXm63SLP
	tTlOse2IcqDiDQHaGcjBPEvto3j4fl5TIAWnh/6V34Rt3wfd/6tSbB7InsD5BQDPmKQ6LimV4kd
	pxG2TzrU/JnQlrCAAcKazCd8x0iTlqPIMaQVJyjAj3TDO6EI23Bnj
X-Received: by 2002:a17:90b:4a49:b0:381:5bd6:eb19 with SMTP id 98e67ed59e1d1-392cca41cc5mr1824392a91.18.1786373099588;
        Mon, 10 Aug 2026 07:44:59 -0700 (PDT)
X-Received: by 2002:a17:90b:4a49:b0:381:5bd6:eb19 with SMTP id 98e67ed59e1d1-392cca41cc5mr1824344a91.18.1786373099138;
        Mon, 10 Aug 2026 07:44:59 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3926254ee45sm12797317a91.2.2026.08.10.07.44.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 07:44:58 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next v3 3/8] wifi: ath12k: add TCL ring TX buffer allocation failure counter
Date: Mon, 10 Aug 2026 20:14:39 +0530
Message-Id: <20260810144444.2033607-4-pardeep.kaur@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260810144444.2033607-1-pardeep.kaur@oss.qualcomm.com>
References: <20260810144444.2033607-1-pardeep.kaur@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: I8JNhTjziEcH-mM19iSgI6Oi-6vWUAhc
X-Authority-Analysis: v=2.4 cv=R4cz39RX c=1 sm=1 tr=0 ts=6a79e3ec cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=EUspDBNiAAAA:8
 a=vo2QL9yUnAtzEB9pKL0A:9 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-GUID: I8JNhTjziEcH-mM19iSgI6Oi-6vWUAhc
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDEyNiBTYWx0ZWRfX4TifTFoH/KAh
 moIbh3FEGz+q9k67Jza6IpzJjlOvzChrXNrCzg8ULEW2y8uhf87RVI03EKjpIZKUnkHNei8MpAk
 E3xvy3qH3DEiXQlQXRBw9hs5Rh92bLs=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDEyNiBTYWx0ZWRfX0pGlC/IPTAJc
 4QpOfd1yl3nmKe/3p8vxtN1wCxm0UV92XSBN4N6hc66SRhDcWEtWTVKBM+bES3ynP3LztA6gFZJ
 zEpCt4FfNbCF1jRxG5sbskPhEY1hY9C2b1nSYBQL3Z+DH3WL+yy8k+6tCg0kpZChvmtwmXhNbcB
 hzJbelmIkidQb+eDRNU7l1S3IyQnCE5exNB+9aCMI51n2l9fIaBrpbwCyXNN/7YctPQDXt4C7QU
 LeBiSp8aMcuev7ZZ3SSJrHA2POx1rH5vwpray0ZMMFx1o/WzOQ+81uYWXOMN6QR8eBeEslLGz9z
 ngW43enK7Z4R9+mgJFZSRnUx7peAP0ooUFpM5Jrh+xpAVRlgAwgWenLI2XT5n6hIrnUE3/gtuIX
 iO4eUrUCHgI9+J2DQCNPTu6UdAo/9Grk+eMGYfzP+97y6NntQvBrShbakypRURlleptNg2XHp6v
 O/nZGZNiuwz0ZpQSdig==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-10_03,2026-08-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608100126

From: Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>

When ath12k_dp_tx_assign_buffer() fails, the TX path returns -ENOMEM
silently with no visibility into which traffic class is affected.
Without a counter, TX descriptor pool exhaustion is invisible during
debugging.

Add txbuf_na[] indexed by pool_id to ath12k_device_dp_tx_err_stats to
track TX descriptor pool allocation failures per traffic class and
increment it on assign failure in the TX path. Expose the per-pool
counts in debugfs under a new 'TX Descriptor Pool Alloc Failures'
section.

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
index d54995b7adb2..ec49692107a8 100644
--- a/drivers/net/wireless/ath/ath12k/debugfs.c
+++ b/drivers/net/wireless/ath/ath12k/debugfs.c
@@ -1117,6 +1117,11 @@ static ssize_t ath12k_debugfs_dump_device_dp_stats(struct file *file,
 		len += scnprintf(buf + len, size - len, "ring%d: %u\n",
 				 i, device_stats->tx_err.desc_na[i]);
 
+	len += scnprintf(buf + len, size - len, "\nTX Descriptor Pool Alloc Failures:\n");
+	for (i = 0; i < ATH12K_HW_MAX_QUEUES; i++)
+		len += scnprintf(buf + len, size - len, "pool%d: %u\n",
+				 i, device_stats->tx_err.txbuf_na[i]);
+
 	len += scnprintf(buf + len, size - len,
 			 "\nMisc Transmit Failures: %d\n",
 			 atomic_read(&device_stats->tx_err.misc_fail));
diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
index bef0f2ba0560..16675210806a 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -429,6 +429,8 @@ struct ath12k_dp_arch_ops {
 struct ath12k_device_dp_tx_err_stats {
 	/* TCL Ring Descriptor unavailable */
 	u32 desc_na[DP_TCL_NUM_RING_MAX];
+	/* TX descriptor pool exhausted (per pool_id / traffic class) */
+	u32 txbuf_na[ATH12K_HW_MAX_QUEUES];
 	/* Other failures during dp_tx due to mem allocation failure
 	 * idr unavailable etc.
 	 */
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
index a8afc1cb0712..11048c568331 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
@@ -167,8 +167,10 @@ int ath12k_wifi7_dp_tx(struct ath12k_pdev_dp *dp_pdev, struct ath12k_link_vif *a
 	tx_ring = &dp->tx_ring[ti.ring_id];
 
 	tx_desc = ath12k_dp_tx_assign_buffer(dp, pool_id);
-	if (!tx_desc)
+	if (!tx_desc) {
+		dp->device_stats.tx_err.txbuf_na[pool_id]++;
 		return -ENOMEM;
+	}
 
 	dp_link_vif = ath12k_dp_vif_to_dp_link_vif(&ahvif->dp_vif, arvif->link_id);
 
-- 
2.34.1

