Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879D53F39CB
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 14:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786373120; cv=none; b=pvlw8gooIzlu01JZzDaQ29ttVulbKojI1VXi1Dw5RW5lQRjEJtBm7I3xdfw0w+kGIPCy2puIzLPVsYMKFu2fakTEITW3ABurg3h3usNMZjg+oGQRhsxINAosXIOgNqtRMR7QvEeyWdBoKOqmZZL6V4SgfBkHkaksfHPnw9bSV4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786373120; c=relaxed/simple;
	bh=nFPKyzPb9kQdcz6LhyzwmL75sx3bNZXWwjwQRpo9v60=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=k8by4MTe1zgMIe7Mif+qYtxYgYyFk3ODbBgtbOBlWAfIIvacdgu8BdbIIjmM7+FKSAJ4TBH/PKyxBav5mqLOKwDvpDfWiDwqlr6AZwTmw6bRMUGEB8e0osVLTdw6PU+XJLWXC9+sT7WQ/T+HDabyAFFx847m4zsWCoiJ8KMpl6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=E0FzOElP; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=FFBhi5PI; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="E0FzOElP";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="FFBhi5PI"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67ACj4d01367762
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 14:45:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=uRk+1Rwpfg+
	nLylheZltDzyyCE65fCZN8pVLsGu0DbA=; b=E0FzOElP5GTVF1ZvtOiKW+vA1cs
	bo0djud5JzGUsAgSS9NEOpUf9ggY3RXHFDYjj6sVyFvhjaW4eRFt4SCsojtSLVtq
	ruUmaYNZc6JYSa2CJcoj+kXcIrjtpdJQh9d5KJIfNjVoO9XdHru4B0OOraeDAYEK
	8qKfomTkGwBf4kc/a6ImPZGz1Y4baWSj0VqyHiBUQC8iqQZHhR2kJX6Rdo99k5vp
	ElMXCAPf2Va3Cfn0Gaw/4wXGuPGXRMPywkDaeL2rT90eDUKcrF76Ed/x02L2XFMa
	tIN+kaFTgwNYepXnWLFv+h17fPKlAzpIESasoWXQiGEJxrF4ZXHrp/ykmWA==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fy8v4a1je-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 14:45:18 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38fcaa5f82cso2078599a91.3
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 07:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786373117; x=1786977917; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uRk+1Rwpfg+nLylheZltDzyyCE65fCZN8pVLsGu0DbA=;
        b=FFBhi5PIxXThIXkYgqL7YRrw+ppbEyPynDFzwsjnzEf1/szNx14XdJ0FHLN4VDW1Ts
         IYJdjh/YIu1lVN9G8rvpVtmV+Vsi+ijj8w4XVE/hPg/aaU4UIZD2uYkrRAynGePRN16t
         tGShybfGP0Yx1LvHeLQ1aaFg1oaTHw/qghQd5kjB+nLB2GusKHadXs6KSx5k2261iomR
         iuVCn2e1a16eKm0ZwoHXNadMHBoHeqAukRNJAmD8fkn2ZxeZ9mwOaMPuhzAaUg+M2nlo
         LvMANqrdGEnEEQQJj8mqSH4XjOOUO/NdTf6MfxYnPvGcR6IZFI+pOBdS1zB9OrOB8f1a
         QlzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786373117; x=1786977917;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uRk+1Rwpfg+nLylheZltDzyyCE65fCZN8pVLsGu0DbA=;
        b=YBqp6THDo6axFloHbONsLB7HDhOYhCpxnHfBVSzyD4InqsOOwN17y7p0s2RoXP677b
         VKLGmI15lwJlCVSYPUcgdI0xsoapb7iEYZD6J8HjWc7wge0LmZt9QMtB5GNg1HmOwjDN
         6RhUmp67K+YeASefcMu/QgqqlOmAA3pSzSvqX3/PNGaRmYAy8nwrYLAI3/stexcLh+8V
         NoNG5eqPSJ/d8ovOiLP4vd1uR2DCC4vLYa83Z4fbCQlpSahHdN5GM6JTdrqplPVuutWe
         35BHOHUywHsKijd+HyRMds4gv0J0heS6ac8lTrefkdGcFkW/fx2XmDTkQZdwdBHRgSzt
         qgGg==
X-Gm-Message-State: AOJu0Yyf80j9dVxgmmrtiV4sZev0KVcz+EBc2gk+0PGmGp+2HZRnavI/
	DCvyla6jvCvoUtrsWHvQpeR7Ei46xnSNt8zqcRjZlKy8YxXmqVusptc/jXJsJ5fbDn5Dkcsy5jq
	yz8uB0P7GVEb2zcUM8Gr8PB8KoBf2M8vHqz2OAMzXlmhHN/GpIbqeDhAtaRWESuR36OZH4A==
X-Gm-Gg: AR+sD10OOlSxt6jRFTIbnhRVskAhjbfBUYCh+zPGhZIaKZU2cD0/qM/Tm5gQscrky4h
	eMuML08ZS3OhJOqf4cV+SjjwwOh6IqauQIIEPKBHsBLJ++Ej/YhSK3M7NG1UvRLDLfLtgQO2daG
	2AEE9At7zkvz5Nz3p30MD1pC3DQsW7xl3m9psXQGI9Xx4R72YaTaHnuKP/yp13bxwlE77fbe6Gg
	1iZTS2wZwZsBSrtU08zDjwOxehMvx8p65NIoeux71pFtDYCfxxuNp+2KB7aUjagE46BZSlPiNX9
	uTzgtHNCtaOn2BWXkUfnlvMV1tZ5xZJmjosTBb2HvhGfhgCRlDZqpcNZ6UtY8lE8eoHCBfp8nYc
	dW8TdDcdBQ0q0hv5JkHtnkn6/A9798GBs6ed6KiNvou5efSaHjYeA
X-Received: by 2002:a17:90a:e7c7:b0:37d:f983:7b5 with SMTP id 98e67ed59e1d1-392cc961c23mr1716864a91.9.1786373117229;
        Mon, 10 Aug 2026 07:45:17 -0700 (PDT)
X-Received: by 2002:a17:90a:e7c7:b0:37d:f983:7b5 with SMTP id 98e67ed59e1d1-392cc961c23mr1716832a91.9.1786373116798;
        Mon, 10 Aug 2026 07:45:16 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3926254ee45sm12797317a91.2.2026.08.10.07.45.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 07:45:16 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next v3 7/8] wifi: ath12k: fix 1-based ring index in REO Rx Received debugfs output
Date: Mon, 10 Aug 2026 20:14:43 +0530
Message-Id: <20260810144444.2033607-8-pardeep.kaur@oss.qualcomm.com>
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
X-Proofpoint-ORIG-GUID: x-qqbdaWd3hzGYaQ4YwJo3qgoYwC6pkk
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDEyNiBTYWx0ZWRfXz82jeAdsPB9N
 URh/6kCQEsChOjiu6p+Fz5MTE0sgtMU2mQUOP35vvi26UAJL+V268lsF2SbQakYLekXA5+w7wNe
 +/01AOHgbifX93at1vVCDBlFdONjvNU=
X-Authority-Analysis: v=2.4 cv=W5EIkxWk c=1 sm=1 tr=0 ts=6a79e3fe cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=EUspDBNiAAAA:8
 a=qz0A3ntWxt9h8-tH59wA:9 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDEyNiBTYWx0ZWRfX0h8npPKTVvCZ
 BrrHQXxMs+/WkHONJ8RjBPgIQUtjUOzb7hAJszwgIDayZguyWWPH3daoZTaaweHdjQU+pRS6OB4
 1avlscsfFKqxNSBF2Ds7wIddXTlvqGsaB/g4MSiCy7xYLX2uAvtCEZtOXTXFNDZCOaVUQf9AQzC
 Fj0VDCZSImpQX9FbfFu4lzLtb+5vWD+/sFHJ+f7UPacTqrYPQ+5rVBiPHJt/lFDcCaiDMcb1/x6
 IPd6kS3jmFpFGdYW+YoAIdXEa6jTBnCTXfjPGSguYtwwaGT4H8zsQE12JUYJoA+0/mYtioEjaJl
 aWE7uEMujK+HWuFNTLabSx3w9wiuET2JCXpBgyVAMOcY1CJCQQ++WIKhwhUdynu3zU5FkThUPXJ
 5Swg9TKIlk0zVHph/MHkrsE5kBtj/EjaSJTANLEaBPWrGFUENtY91pM5UvQrT8JFa7A/dyTv+Zj
 OJFBmgZik/wcndE4FAA==
X-Proofpoint-GUID: x-qqbdaWd3hzGYaQ4YwJo3qgoYwC6pkk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-10_03,2026-08-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 adultscore=0 bulkscore=0 spamscore=0 impostorscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608100126

From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>

The REO Rx Received section in device_dp_stats debugfs uses a 1-based
ring index ("Ring1:", "Ring2:", ...) which is inconsistent with the rest
of ath12k where rings are indexed from 0. Fix it to use 0-based indexing
and lowercase "ring%d:" to match the style used by all other ring counters
in the same function.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6.r1-00402-QCAHKSWPL_SILICONZ-1

Signed-off-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/debugfs.c b/drivers/net/wireless/ath/ath12k/debugfs.c
index 55e3b411d108..fe513b3489bc 100644
--- a/drivers/net/wireless/ath/ath12k/debugfs.c
+++ b/drivers/net/wireless/ath/ath12k/debugfs.c
@@ -1215,7 +1215,7 @@ static ssize_t ath12k_debugfs_dump_device_dp_stats(struct file *file,
 	len += scnprintf(buf + len, size - len, "\nREO Rx Received:\n");
 
 	for (i = 0; i < DP_REO_DST_RING_MAX; i++) {
-		len += scnprintf(buf + len, size - len, "Ring%d:", i + 1);
+		len += scnprintf(buf + len, size - len, "ring%d:", i);
 
 		for (j = 0; j < ab->ag->num_devices; j++) {
 			len += scnprintf(buf + len, size - len,
-- 
2.34.1

